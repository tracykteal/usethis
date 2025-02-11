test_that("can import standalone file with dependencies", {
  skip_if_offline()
  create_local_package()

  use_standalone("r-lib/rlang", "types-check", ref = "4670cb233ecc8d11")
  expect_setequal(
    as.character(path_rel(dir_ls(proj_path("R"))), proj_path()),
    c("R/import-standalone-types-check.R", "R/import-standalone-obj-type.R")
  )
})

test_that("can use full github url", {
  skip_if_offline()
  create_local_package()

  use_standalone(
    "https://github.com/r-lib/rlang",
    file = "sizes",
    ref = "4670cb233ecc8d11"
  )
  expect_equal(
    as.character(path_rel(dir_ls(proj_path("R"))), proj_path()),
    "R/import-standalone-sizes.R"
  )
})


test_that("can offer choices", {
  skip_if_offline()

  expect_snapshot(error = TRUE, {
    standalone_choose("tidyverse/forcats", ref = "v1.0.0")
    standalone_choose("r-lib/rlang", ref = "4670cb233ecc8d11")
  })
})

test_that("header provides useful summary", {
  expect_snapshot(standalone_header("r-lib/usethis", "R/standalone-test.R"))
})

test_that("can extract dependencies", {
  extract_deps <- function(deps) {
    standalone_dependencies(c("# ---", deps, "# ---"), "test.R")
  }

  expect_equal(extract_deps(NULL), character())
  expect_equal(extract_deps("# dependencies: a"), "a")
  expect_equal(extract_deps("# dependencies: [a, b]"), c("a", "b"))
})

test_that("errors on malformed dependencies", {
  expect_snapshot(error = TRUE, {
    standalone_dependencies(c(), "test.R")
    standalone_dependencies(c("# ---", "# dependencies: 1", "# ---"), "test.R")
  })
})
