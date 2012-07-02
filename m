Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2GBNqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:46:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36363 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2GBNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:46:32 -0400
From: Hitoshi Mitake <h.mitake@gmail.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: [PATCH v2] perf bench: fix confused variable namings and descriptions in mem subsystem
Date: Mon,  2 Jul 2012 22:46:17 +0900
Message-Id: <1341236777-18457-1-git-send-email-h.mitake@gmail.com>
X-Mailer: git-send-email 1.7.10.rc0.41.gfa678
In-Reply-To: <c1865315-643c-44da-bbae-fd96cd2912f4@email.android.com>
References: <c1865315-643c-44da-bbae-fd96cd2912f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Namhyung Kim pointed, there are confused namings and descriptions
of words "cycle" and "clock" in mem-memset.c and mem-memcpy.c.

With the option "-c" (or "--clock", now renamed as "--cycle"), mem
subsystem measures cost of memset() and memcpy() with cpu-cycles
event.

But current mem subsystem source code contains lots of confused
variable namings and descriptions with "clock" (e.g. the variable
use_clock). This is a very bad style because there is another software
event named "cpu-clock". This patch replaces wrong usage of "clock" to
"cycle".

v2: modified Documentation/perf-bench.txt for the descriptions of
--cycle option

Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 tools/perf/Documentation/perf-bench.txt |    4 +-
 tools/perf/bench/mem-memcpy.c           |   80 +++++++++++++++----------------
 tools/perf/bench/mem-memset.c           |   80 +++++++++++++++----------------
 3 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index f3c716a..7065cd6 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -144,7 +144,7 @@ On x86-64, x86-64-unrolled, x86-64-movsq and x86-64-movsb are supported.
 Repeat memcpy invocation this number of times.
 
 -c::
---clock::
+--cycle::
 Use perf's cpu-cycles event instead of gettimeofday syscall.
 
 -o::
@@ -176,7 +176,7 @@ On x86-64, x86-64-unrolled, x86-64-stosq and x86-64-stosb are supported.
 Repeat memset invocation this number of times.
 
 -c::
---clock::
+--cycle::
 Use perf's cpu-cycles event instead of gettimeofday syscall.
 
 -o::
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index d990365..02dad5d 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -24,8 +24,8 @@
 static const char	*length_str	= "1MB";
 static const char	*routine	= "default";
 static int		iterations	= 1;
-static bool		use_clock;
-static int		clock_fd;
+static bool		use_cycle;
+static int		cycle_fd;
 static bool		only_prefault;
 static bool		no_prefault;
 
@@ -37,7 +37,7 @@ static const struct option options[] = {
 		    "Specify routine to copy"),
 	OPT_INTEGER('i', "iterations", &iterations,
 		    "repeat memcpy() invocation this number of times"),
-	OPT_BOOLEAN('c', "clock", &use_clock,
+	OPT_BOOLEAN('c', "cycle", &use_cycle,
 		    "Use cycles event instead of gettimeofday() for measuring"),
 	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
 		    "Show only the result with page faults before memcpy()"),
@@ -76,27 +76,27 @@ static const char * const bench_mem_memcpy_usage[] = {
 	NULL
 };
 
-static struct perf_event_attr clock_attr = {
+static struct perf_event_attr cycle_attr = {
 	.type		= PERF_TYPE_HARDWARE,
 	.config		= PERF_COUNT_HW_CPU_CYCLES
 };
 
-static void init_clock(void)
+static void init_cycle(void)
 {
-	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
 
-	if (clock_fd < 0 && errno == ENOSYS)
+	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 	else
-		BUG_ON(clock_fd < 0);
+		BUG_ON(cycle_fd < 0);
 }
 
-static u64 get_clock(void)
+static u64 get_cycle(void)
 {
 	int ret;
 	u64 clk;
 
-	ret = read(clock_fd, &clk, sizeof(u64));
+	ret = read(cycle_fd, &clk, sizeof(u64));
 	BUG_ON(ret != sizeof(u64));
 
 	return clk;
@@ -119,9 +119,9 @@ static void alloc_mem(void **dst, void **src, size_t length)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
-static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
+static u64 do_memcpy_cycle(memcpy_t fn, size_t len, bool prefault)
 {
-	u64 clock_start = 0ULL, clock_end = 0ULL;
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
 	void *src = NULL, *dst = NULL;
 	int i;
 
@@ -130,14 +130,14 @@ static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
 	if (prefault)
 		fn(dst, src, len);
 
-	clock_start = get_clock();
+	cycle_start = get_cycle();
 	for (i = 0; i < iterations; ++i)
 		fn(dst, src, len);
-	clock_end = get_clock();
+	cycle_end = get_cycle();
 
 	free(src);
 	free(dst);
-	return clock_end - clock_start;
+	return cycle_end - cycle_start;
 }
 
 static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
@@ -182,17 +182,17 @@ int bench_mem_memcpy(int argc, const char **argv,
 	int i;
 	size_t len;
 	double result_bps[2];
-	u64 result_clock[2];
+	u64 result_cycle[2];
 
 	argc = parse_options(argc, argv, options,
 			     bench_mem_memcpy_usage, 0);
 
-	if (use_clock)
-		init_clock();
+	if (use_cycle)
+		init_cycle();
 
 	len = (size_t)perf_atoll((char *)length_str);
 
-	result_clock[0] = result_clock[1] = 0ULL;
+	result_cycle[0] = result_cycle[1] = 0ULL;
 	result_bps[0] = result_bps[1] = 0.0;
 
 	if ((s64)len <= 0) {
@@ -223,11 +223,11 @@ int bench_mem_memcpy(int argc, const char **argv,
 
 	if (!only_prefault && !no_prefault) {
 		/* show both of results */
-		if (use_clock) {
-			result_clock[0] =
-				do_memcpy_clock(routines[i].fn, len, false);
-			result_clock[1] =
-				do_memcpy_clock(routines[i].fn, len, true);
+		if (use_cycle) {
+			result_cycle[0] =
+				do_memcpy_cycle(routines[i].fn, len, false);
+			result_cycle[1] =
+				do_memcpy_cycle(routines[i].fn, len, true);
 		} else {
 			result_bps[0] =
 				do_memcpy_gettimeofday(routines[i].fn,
@@ -237,9 +237,9 @@ int bench_mem_memcpy(int argc, const char **argv,
 						len, true);
 		}
 	} else {
-		if (use_clock) {
-			result_clock[pf] =
-				do_memcpy_clock(routines[i].fn,
+		if (use_cycle) {
+			result_cycle[pf] =
+				do_memcpy_cycle(routines[i].fn,
 						len, only_prefault);
 		} else {
 			result_bps[pf] =
@@ -251,12 +251,12 @@ int bench_mem_memcpy(int argc, const char **argv,
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
 		if (!only_prefault && !no_prefault) {
-			if (use_clock) {
-				printf(" %14lf Clock/Byte\n",
-					(double)result_clock[0]
+			if (use_cycle) {
+				printf(" %14lf Cycle/Byte\n",
+					(double)result_cycle[0]
 					/ (double)len);
-				printf(" %14lf Clock/Byte (with prefault)\n",
-					(double)result_clock[1]
+				printf(" %14lf Cycle/Byte (with prefault)\n",
+					(double)result_cycle[1]
 					/ (double)len);
 			} else {
 				print_bps(result_bps[0]);
@@ -265,9 +265,9 @@ int bench_mem_memcpy(int argc, const char **argv,
 				printf(" (with prefault)\n");
 			}
 		} else {
-			if (use_clock) {
-				printf(" %14lf Clock/Byte",
-					(double)result_clock[pf]
+			if (use_cycle) {
+				printf(" %14lf Cycle/Byte",
+					(double)result_cycle[pf]
 					/ (double)len);
 			} else
 				print_bps(result_bps[pf]);
@@ -277,17 +277,17 @@ int bench_mem_memcpy(int argc, const char **argv,
 		break;
 	case BENCH_FORMAT_SIMPLE:
 		if (!only_prefault && !no_prefault) {
-			if (use_clock) {
+			if (use_cycle) {
 				printf("%lf %lf\n",
-					(double)result_clock[0] / (double)len,
-					(double)result_clock[1] / (double)len);
+					(double)result_cycle[0] / (double)len,
+					(double)result_cycle[1] / (double)len);
 			} else {
 				printf("%lf %lf\n",
 					result_bps[0], result_bps[1]);
 			}
 		} else {
-			if (use_clock) {
-				printf("%lf\n", (double)result_clock[pf]
+			if (use_cycle) {
+				printf("%lf\n", (double)result_cycle[pf]
 					/ (double)len);
 			} else
 				printf("%lf\n", result_bps[pf]);
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index bf0d5f5..350cc95 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -24,8 +24,8 @@
 static const char	*length_str	= "1MB";
 static const char	*routine	= "default";
 static int		iterations	= 1;
-static bool		use_clock;
-static int		clock_fd;
+static bool		use_cycle;
+static int		cycle_fd;
 static bool		only_prefault;
 static bool		no_prefault;
 
@@ -37,7 +37,7 @@ static const struct option options[] = {
 		    "Specify routine to set"),
 	OPT_INTEGER('i', "iterations", &iterations,
 		    "repeat memset() invocation this number of times"),
-	OPT_BOOLEAN('c', "clock", &use_clock,
+	OPT_BOOLEAN('c', "cycle", &use_cycle,
 		    "Use cycles event instead of gettimeofday() for measuring"),
 	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
 		    "Show only the result with page faults before memset()"),
@@ -76,27 +76,27 @@ static const char * const bench_mem_memset_usage[] = {
 	NULL
 };
 
-static struct perf_event_attr clock_attr = {
+static struct perf_event_attr cycle_attr = {
 	.type		= PERF_TYPE_HARDWARE,
 	.config		= PERF_COUNT_HW_CPU_CYCLES
 };
 
-static void init_clock(void)
+static void init_cycle(void)
 {
-	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
 
-	if (clock_fd < 0 && errno == ENOSYS)
+	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 	else
-		BUG_ON(clock_fd < 0);
+		BUG_ON(cycle_fd < 0);
 }
 
-static u64 get_clock(void)
+static u64 get_cycle(void)
 {
 	int ret;
 	u64 clk;
 
-	ret = read(clock_fd, &clk, sizeof(u64));
+	ret = read(cycle_fd, &clk, sizeof(u64));
 	BUG_ON(ret != sizeof(u64));
 
 	return clk;
@@ -115,9 +115,9 @@ static void alloc_mem(void **dst, size_t length)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
-static u64 do_memset_clock(memset_t fn, size_t len, bool prefault)
+static u64 do_memset_cycle(memset_t fn, size_t len, bool prefault)
 {
-	u64 clock_start = 0ULL, clock_end = 0ULL;
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
 	void *dst = NULL;
 	int i;
 
@@ -126,13 +126,13 @@ static u64 do_memset_clock(memset_t fn, size_t len, bool prefault)
 	if (prefault)
 		fn(dst, -1, len);
 
-	clock_start = get_clock();
+	cycle_start = get_cycle();
 	for (i = 0; i < iterations; ++i)
 		fn(dst, i, len);
-	clock_end = get_clock();
+	cycle_end = get_cycle();
 
 	free(dst);
-	return clock_end - clock_start;
+	return cycle_end - cycle_start;
 }
 
 static double do_memset_gettimeofday(memset_t fn, size_t len, bool prefault)
@@ -176,17 +176,17 @@ int bench_mem_memset(int argc, const char **argv,
 	int i;
 	size_t len;
 	double result_bps[2];
-	u64 result_clock[2];
+	u64 result_cycle[2];
 
 	argc = parse_options(argc, argv, options,
 			     bench_mem_memset_usage, 0);
 
-	if (use_clock)
-		init_clock();
+	if (use_cycle)
+		init_cycle();
 
 	len = (size_t)perf_atoll((char *)length_str);
 
-	result_clock[0] = result_clock[1] = 0ULL;
+	result_cycle[0] = result_cycle[1] = 0ULL;
 	result_bps[0] = result_bps[1] = 0.0;
 
 	if ((s64)len <= 0) {
@@ -217,11 +217,11 @@ int bench_mem_memset(int argc, const char **argv,
 
 	if (!only_prefault && !no_prefault) {
 		/* show both of results */
-		if (use_clock) {
-			result_clock[0] =
-				do_memset_clock(routines[i].fn, len, false);
-			result_clock[1] =
-				do_memset_clock(routines[i].fn, len, true);
+		if (use_cycle) {
+			result_cycle[0] =
+				do_memset_cycle(routines[i].fn, len, false);
+			result_cycle[1] =
+				do_memset_cycle(routines[i].fn, len, true);
 		} else {
 			result_bps[0] =
 				do_memset_gettimeofday(routines[i].fn,
@@ -231,9 +231,9 @@ int bench_mem_memset(int argc, const char **argv,
 						len, true);
 		}
 	} else {
-		if (use_clock) {
-			result_clock[pf] =
-				do_memset_clock(routines[i].fn,
+		if (use_cycle) {
+			result_cycle[pf] =
+				do_memset_cycle(routines[i].fn,
 						len, only_prefault);
 		} else {
 			result_bps[pf] =
@@ -245,12 +245,12 @@ int bench_mem_memset(int argc, const char **argv,
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
 		if (!only_prefault && !no_prefault) {
-			if (use_clock) {
-				printf(" %14lf Clock/Byte\n",
-					(double)result_clock[0]
+			if (use_cycle) {
+				printf(" %14lf Cycle/Byte\n",
+					(double)result_cycle[0]
 					/ (double)len);
-				printf(" %14lf Clock/Byte (with prefault)\n ",
-					(double)result_clock[1]
+				printf(" %14lf Cycle/Byte (with prefault)\n ",
+					(double)result_cycle[1]
 					/ (double)len);
 			} else {
 				print_bps(result_bps[0]);
@@ -259,9 +259,9 @@ int bench_mem_memset(int argc, const char **argv,
 				printf(" (with prefault)\n");
 			}
 		} else {
-			if (use_clock) {
-				printf(" %14lf Clock/Byte",
-					(double)result_clock[pf]
+			if (use_cycle) {
+				printf(" %14lf Cycle/Byte",
+					(double)result_cycle[pf]
 					/ (double)len);
 			} else
 				print_bps(result_bps[pf]);
@@ -271,17 +271,17 @@ int bench_mem_memset(int argc, const char **argv,
 		break;
 	case BENCH_FORMAT_SIMPLE:
 		if (!only_prefault && !no_prefault) {
-			if (use_clock) {
+			if (use_cycle) {
 				printf("%lf %lf\n",
-					(double)result_clock[0] / (double)len,
-					(double)result_clock[1] / (double)len);
+					(double)result_cycle[0] / (double)len,
+					(double)result_cycle[1] / (double)len);
 			} else {
 				printf("%lf %lf\n",
 					result_bps[0], result_bps[1]);
 			}
 		} else {
-			if (use_clock) {
-				printf("%lf\n", (double)result_clock[pf]
+			if (use_cycle) {
+				printf("%lf\n", (double)result_cycle[pf]
 					/ (double)len);
 			} else
 				printf("%lf\n", result_bps[pf]);
-- 
1.7.10.rc0.41.gfa678

