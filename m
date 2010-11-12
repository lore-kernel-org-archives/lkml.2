Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab0KLPCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:02:45 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62656 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0KLPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:02:44 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Ma Ling <ling.ma@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] perf bench: print both of prefaulted and no prefaulted results
Date: Sat, 13 Nov 2010 00:02:38 +0900
Message-Id: <1289574158-6959-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <4CDD56E3.5030303@dcl.info.waseda.ac.jp>
References: <4CDD56E3.5030303@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After applying this patch, perf bench mem memcpy prints
both of prefualted and without prefaulted score of memcpy().

New options --no-prefault and --only-prefault are added
for printing single result, mainly for scripting usage.

Example of usage:
| mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes ...
|
|      634.969014 MB/Sec
|        4.828062 GB/Sec (with prefault)
| mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB --only-prefault
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes ...
|
|        4.705192 GB/Sec (with prefault)
| mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB --no-prefault
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes ...
|
|      642.725568 MB/Sec

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 tools/perf/bench/mem-memcpy.c |  215 +++++++++++++++++++++++++++++------------
 1 files changed, 152 insertions(+), 63 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index be31ddb..61b6ead 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -25,7 +25,8 @@ static const char	*length_str	= "1MB";
 static const char	*routine	= "default";
 static bool		use_clock;
 static int		clock_fd;
-static bool		prefault;
+static bool		only_prefault;
+static bool		no_prefault;
 
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
@@ -35,15 +36,19 @@ static const struct option options[] = {
 		    "Specify routine to copy"),
 	OPT_BOOLEAN('c', "clock", &use_clock,
 		    "Use CPU clock for measuring"),
-	OPT_BOOLEAN('p', "prefault", &prefault,
-		    "Cause page faults before memcpy()"),
+	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
+		    "Show only the result with page faults before memcpy()"),
+	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
+		    "Show only the result without page faults before memcpy()"),
 	OPT_END()
 };
 
+typedef void *(*memcpy_t)(void *, const void *, size_t);
+
 struct routine {
 	const char *name;
 	const char *desc;
-	void * (*fn)(void *dst, const void *src, size_t len);
+	memcpy_t fn;
 };
 
 struct routine routines[] = {
@@ -92,29 +97,98 @@ static double timeval2double(struct timeval *ts)
 		(double)ts->tv_usec / (double)1000000;
 }
 
+static void alloc_mem(void **dst, void **src, size_t length)
+{
+	*dst = zalloc(length);
+	if (!dst)
+		die("memory allocation failed - maybe length is too large?\n");
+
+	*src = zalloc(length);
+	if (!src)
+		die("memory allocation failed - maybe length is too large?\n");
+}
+
+static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
+{
+	u64 clock_start = 0ULL, clock_end = 0ULL;
+	void *src = NULL, *dst = NULL;
+
+	alloc_mem(&src, &dst, len);
+
+	if (prefault)
+		fn(dst, src, len);
+
+	clock_start = get_clock();
+	fn(dst, src, len);
+	clock_end = get_clock();
+
+	free(src);
+	free(dst);
+	return clock_end - clock_start;
+}
+
+static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
+{
+	struct timeval tv_start, tv_end, tv_diff;
+	void *src = NULL, *dst = NULL;
+
+	alloc_mem(&src, &dst, len);
+
+	if (prefault)
+		fn(dst, src, len);
+
+	BUG_ON(gettimeofday(&tv_start, NULL));
+	fn(dst, src, len);
+	BUG_ON(gettimeofday(&tv_end, NULL));
+
+	timersub(&tv_end, &tv_start, &tv_diff);
+
+	free(src);
+	free(dst);
+	return (double)((double)len / timeval2double(&tv_diff));
+}
+
+#define pf (no_prefault ? 0 : 1)
+
+#define print_bps(x) do {					\
+		if (x < K)					\
+			printf(" %14lf B/Sec", x);		\
+		else if (x < K * K)				\
+			printf(" %14lfd KB/Sec", x / K);	\
+		else if (x < K * K * K)				\
+			printf(" %14lf MB/Sec", x / K / K);	\
+		else						\
+			printf(" %14lf GB/Sec", x / K / K / K); \
+	} while (0)
+
 int bench_mem_memcpy(int argc, const char **argv,
 		     const char *prefix __used)
 {
 	int i;
-	void *dst, *src;
-	size_t length;
-	double bps = 0.0;
-	struct timeval tv_start, tv_end, tv_diff;
-	u64 clock_start, clock_end, clock_diff;
+	size_t len;
+	double result_bps[2];
+	u64 result_clock[2];
 
-	clock_start = clock_end = clock_diff = 0ULL;
 	argc = parse_options(argc, argv, options,
 			     bench_mem_memcpy_usage, 0);
 
-	tv_diff.tv_sec = 0;
-	tv_diff.tv_usec = 0;
-	length = (size_t)perf_atoll((char *)length_str);
+	if (use_clock)
+		init_clock();
+
+	len = (size_t)perf_atoll((char *)length_str);
 
-	if ((s64)length <= 0) {
+	result_clock[0] = result_clock[1] = 0ULL;
+	result_bps[0] = result_bps[1] = 0.0;
+
+	if ((s64)len <= 0) {
 		fprintf(stderr, "Invalid length:%s\n", length_str);
 		return 1;
 	}
 
+	/* same to without specifying either of prefault and no-prefault */
+	if (only_prefault && no_prefault)
+		only_prefault = no_prefault = false;
+
 	for (i = 0; routines[i].name; i++) {
 		if (!strcmp(routines[i].name, routine))
 			break;
@@ -129,65 +203,80 @@ int bench_mem_memcpy(int argc, const char **argv,
 		return 1;
 	}
 
-	dst = zalloc(length);
-	if (!dst)
-		die("memory allocation failed - maybe length is too large?\n");
-
-	src = zalloc(length);
-	if (!src)
-		die("memory allocation failed - maybe length is too large?\n");
-
-	if (bench_format == BENCH_FORMAT_DEFAULT) {
-		printf("# Copying %s Bytes from %p to %p ...\n\n",
-		       length_str, src, dst);
-	}
-
-
-	if (prefault)
-		routines[i].fn(dst, src, length);
-
-	if (use_clock) {
-		init_clock();
-		clock_start = get_clock();
-	} else {
-		BUG_ON(gettimeofday(&tv_start, NULL));
-	}
+	if (bench_format == BENCH_FORMAT_DEFAULT)
+		printf("# Copying %s Bytes ...\n\n", length_str);
 
-	routines[i].fn(dst, src, length);
-
-	if (use_clock) {
-		clock_end = get_clock();
-		clock_diff = clock_end - clock_start;
+	if (!only_prefault && !no_prefault) {
+		/* show both of results */
+		if (use_clock) {
+			result_clock[0] =
+				do_memcpy_clock(routines[i].fn, len, false);
+			result_clock[1] =
+				do_memcpy_clock(routines[i].fn, len, true);
+		} else {
+			result_bps[0] =
+				do_memcpy_gettimeofday(routines[i].fn,
+						len, false);
+			result_bps[1] =
+				do_memcpy_gettimeofday(routines[i].fn,
+						len, true);
+		}
 	} else {
-		BUG_ON(gettimeofday(&tv_end, NULL));
-		timersub(&tv_end, &tv_start, &tv_diff);
-		bps = (double)((double)length / timeval2double(&tv_diff));
+		if (use_clock) {
+			result_clock[pf] =
+				do_memcpy_clock(routines[i].fn,
+						len, only_prefault);
+		} else {
+			result_bps[pf] =
+				do_memcpy_gettimeofday(routines[i].fn,
+						len, only_prefault);
+		}
 	}
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
-		if (use_clock) {
-			printf(" %14lf Clock/Byte\n",
-			       (double)clock_diff / (double)length);
-		} else {
-			if (bps < K)
-				printf(" %14lf B/Sec\n", bps);
-			else if (bps < K * K)
-				printf(" %14lfd KB/Sec\n", bps / 1024);
-			else if (bps < K * K * K)
-				printf(" %14lf MB/Sec\n", bps / 1024 / 1024);
-			else {
-				printf(" %14lf GB/Sec\n",
-				       bps / 1024 / 1024 / 1024);
+		if (!only_prefault && !no_prefault) {
+			if (use_clock) {
+				printf(" %14lf Clock/Byte\n",
+					(double)result_clock[0]
+					/ (double)len);
+				printf(" %14lf Clock/Byte (with prefault)\n",
+					(double)result_clock[1]
+					/ (double)len);
+			} else {
+				print_bps(result_bps[0]);
+				printf("\n");
+				print_bps(result_bps[1]);
+				printf(" (with prefault)\n");
 			}
+		} else {
+			if (use_clock) {
+				printf(" %14lf Clock/Byte",
+					(double)result_clock[pf]
+					/ (double)len);
+			} else
+				print_bps(result_bps[pf]);
+
+			printf("%s\n", only_prefault ? " (with prefault)" : "");
 		}
 		break;
 	case BENCH_FORMAT_SIMPLE:
-		if (use_clock) {
-			printf("%14lf\n",
-			       (double)clock_diff / (double)length);
-		} else
-			printf("%lf\n", bps);
+		if (!only_prefault && !no_prefault) {
+			if (use_clock) {
+				printf("%lf %lf\n",
+					(double)result_clock[0] / (double)len,
+					(double)result_clock[1] / (double)len);
+			} else {
+				printf("%lf %lf\n",
+					result_bps[0], result_bps[1]);
+			}
+		} else {
+			if (use_clock) {
+				printf("%lf\n", (double)result_clock[pf]
+					/ (double)len);
+			} else
+				printf("%lf\n", result_bps[pf]);
+		}
 		break;
 	default:
 		/* reaching this means there's some disaster: */
-- 
1.7.1.1

