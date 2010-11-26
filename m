Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0KZKb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:31:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:43615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab0KZKb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:31:56 -0500
Date: Fri, 26 Nov 2010 10:30:53 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, yakui.zhao@intel.com,
        mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, rostedt@goodmis.org,
        ling.ma@intel.com, tglx@linutronix.de, miaox@cn.fujitsu.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, yakui.zhao@intel.com,
        mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, ling.ma@intel.com,
        rostedt@goodmis.org, miaox@cn.fujitsu.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1290668693-27068-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1290668693-27068-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Print both of prefaulted and no prefaulted results by default
Message-ID: <tip-49ce8fc651794878189fd5f273228832cdfb5be9@git.kernel.org>
Git-Commit-ID: 49ce8fc651794878189fd5f273228832cdfb5be9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:30:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49ce8fc651794878189fd5f273228832cdfb5be9
Gitweb:     http://git.kernel.org/tip/49ce8fc651794878189fd5f273228832cdfb5be9
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 25 Nov 2010 16:04:52 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 08:15:57 +0100

perf bench: Print both of prefaulted and no prefaulted results by default

After applying this patch, perf bench mem memcpy prints
both of prefualted and without prefaulted score of memcpy().

New options --no-prefault and --only-prefault are added
to print single result, mainly for scripting usage.

Usage example:

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
Cc: h.mitake@gmail.com
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <1290668693-27068-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/mem-memcpy.c |  219 ++++++++++++++++++++++++++++++-----------
 1 files changed, 162 insertions(+), 57 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 38dae74..db82021 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -12,6 +12,7 @@
 #include "../util/parse-options.h"
 #include "../util/header.h"
 #include "bench.h"
+#include "mem-memcpy-arch.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -23,8 +24,10 @@
 
 static const char	*length_str	= "1MB";
 static const char	*routine	= "default";
-static bool		use_clock	= false;
+static bool		use_clock;
 static int		clock_fd;
+static bool		only_prefault;
+static bool		no_prefault;
 
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
@@ -34,19 +37,33 @@ static const struct option options[] = {
 		    "Specify routine to copy"),
 	OPT_BOOLEAN('c', "clock", &use_clock,
 		    "Use CPU clock for measuring"),
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
 	{ "default",
 	  "Default memcpy() provided by glibc",
 	  memcpy },
+#ifdef ARCH_X86_64
+
+#define MEMCPY_FN(fn, name, desc) { name, desc, fn },
+#include "mem-memcpy-x86-64-asm-def.h"
+#undef MEMCPY_FN
+
+#endif
+
 	{ NULL,
 	  NULL,
 	  NULL   }
@@ -89,29 +106,98 @@ static double timeval2double(struct timeval *ts)
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
@@ -126,61 +212,80 @@ int bench_mem_memcpy(int argc, const char **argv,
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
-	if (use_clock) {
-		init_clock();
-		clock_start = get_clock();
-	} else {
-		BUG_ON(gettimeofday(&tv_start, NULL));
-	}
-
-	routines[i].fn(dst, src, length);
+	if (bench_format == BENCH_FORMAT_DEFAULT)
+		printf("# Copying %s Bytes ...\n\n", length_str);
 
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
