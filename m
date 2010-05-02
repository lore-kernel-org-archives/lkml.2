Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0EBNza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:55:30 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50643 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab0EBNzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:55:24 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/4][RFC] perf bench: fix "mem" subsystem to adopt new style of perf bench
Date: Sun,  2 May 2010 22:55:17 +0900
Message-Id: <1272808519-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes "mem" subsystem and its only one suite "memcopy"
new perf bench ready.

I reduced clock cycle based result printing.
Because now perf bench provides the function of result printing.
And, if suite specific result printing is needed,
this should be a member of struct bench_ctx
and be called by builtin-bench.c .

Example of usage:

| % ./perf bench mem memcpy -l 100MB       # 100MB memory copy
| # Running mem/memcpy benchmark with 1 parallelism ...
|      Total time: 0.197 [sec]
| % ./perf bench -p 4 mem memcpy -l 100MB  # 4 processes, 100MB memory copy
| # Running mem/memcpy benchmark with 4 parallelism ...
|      Total time: 0.756 [sec]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/bench/mem-memcpy.c |  182 ++++++++++++++--------------------------
 tools/perf/bench/mem.h        |    4 +
 2 files changed, 68 insertions(+), 118 deletions(-)
 create mode 100644 tools/perf/bench/mem.h

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 38dae74..bfafcd8 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -21,22 +21,6 @@
 
 #define K 1024
 
-static const char	*length_str	= "1MB";
-static const char	*routine	= "default";
-static bool		use_clock	= false;
-static int		clock_fd;
-
-static const struct option options[] = {
-	OPT_STRING('l', "length", &length_str, "1MB",
-		    "Specify length of memory to copy. "
-		    "available unit: B, MB, GB (upper and lower)"),
-	OPT_STRING('r', "routine", &routine, "default",
-		    "Specify routine to copy"),
-	OPT_BOOLEAN('c', "clock", &use_clock,
-		    "Use CPU clock for measuring"),
-	OPT_END()
-};
-
 struct routine {
 	const char *name;
 	const char *desc;
@@ -52,141 +36,103 @@ struct routine routines[] = {
 	  NULL   }
 };
 
-static const char * const bench_mem_memcpy_usage[] = {
+static const char * const mem_memcpy_usage[] = {
 	"perf bench mem memcpy <options>",
 	NULL
 };
 
-static struct perf_event_attr clock_attr = {
-	.type		= PERF_TYPE_HARDWARE,
-	.config		= PERF_COUNT_HW_CPU_CYCLES
+struct memcpy_param {
+	const char *length_str;
+	const char *routine;
 };
 
-static void init_clock(void)
+struct memcpy_context {
+	size_t length;
+	char *dst, *src;
+	void * (*fn)(void *dst, const void *src, size_t len);
+};
+
+static void *__mem_memcpy_parse(int argc, const char **argv,
+				const char *prefix __used,
+				struct memcpy_param *param)
 {
-	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+	struct option options[] = {
+		OPT_STRING('l', "length", &param->length_str, "1MB",
+			   "Specify length of memory to copy. "
+			   "available unit: B, MB, GB (upper and lower)"),
+		OPT_STRING('r', "routine", &param->routine, "default",
+			   "Specify routine to copy"),
+		OPT_END()
+	};
 
-	if (clock_fd < 0 && errno == ENOSYS)
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-	else
-		BUG_ON(clock_fd < 0);
+	argc = parse_options(argc, argv, options,
+			     mem_memcpy_usage, PARSE_OPT_KEEP_ARGV0);
+	return param;
 }
 
-static u64 get_clock(void)
+void *mem_memcpy_parse(int argc, const char **argv, const char *prefix)
 {
-	int ret;
-	u64 clk;
+	struct memcpy_param *param;
 
-	ret = read(clock_fd, &clk, sizeof(u64));
-	BUG_ON(ret != sizeof(u64));
+	param = zalloc(sizeof(struct memcpy_param));
+	if (!param)
+		die("Memory allocation failed\n");
 
-	return clk;
+	param->length_str = "1MB";
+	param->routine = "default";
+	return __mem_memcpy_parse(argc, argv, prefix, param);
 }
 
-static double timeval2double(struct timeval *ts)
-{
-	return (double)ts->tv_sec +
-		(double)ts->tv_usec / (double)1000000;
-}
-
-int bench_mem_memcpy(int argc, const char **argv,
-		     const char *prefix __used)
+void mem_memcpy_prepare(struct bench_ctx *ctx)
 {
 	int i;
-	void *dst, *src;
-	size_t length;
-	double bps = 0.0;
-	struct timeval tv_start, tv_end, tv_diff;
-	u64 clock_start, clock_end, clock_diff;
+	struct memcpy_param *param = ctx->param;
+	struct memcpy_context *memc;
 
-	clock_start = clock_end = clock_diff = 0ULL;
-	argc = parse_options(argc, argv, options,
-			     bench_mem_memcpy_usage, 0);
-
-	tv_diff.tv_sec = 0;
-	tv_diff.tv_usec = 0;
-	length = (size_t)perf_atoll((char *)length_str);
-
-	if ((s64)length <= 0) {
-		fprintf(stderr, "Invalid length:%s\n", length_str);
-		return 1;
-	}
+	memc = zalloc(sizeof(struct memcpy_context));
+	if (!memc)
+		die("Memory allocation failed\n");
 
 	for (i = 0; routines[i].name; i++) {
-		if (!strcmp(routines[i].name, routine))
+		if (!strcmp(routines[i].name, param->routine))
 			break;
 	}
+
 	if (!routines[i].name) {
-		printf("Unknown routine:%s\n", routine);
+		printf("Unknown routine:%s\n", param->routine);
 		printf("Available routines...\n");
 		for (i = 0; routines[i].name; i++) {
 			printf("\t%s ... %s\n",
 			       routines[i].name, routines[i].desc);
 		}
-		return 1;
+		exit(1);
 	}
 
-	dst = zalloc(length);
-	if (!dst)
-		die("memory allocation failed - maybe length is too large?\n");
+	memc->fn = routines[i].fn;
+	memc->length = (size_t)perf_atoll(param->length_str);
 
-	src = zalloc(length);
-	if (!src)
-		die("memory allocation failed - maybe length is too large?\n");
+	if (memc->length <= 0)
+		die("Invalid length of memory\n");
 
-	if (bench_format == BENCH_FORMAT_DEFAULT) {
-		printf("# Copying %s Bytes from %p to %p ...\n\n",
-		       length_str, src, dst);
-	}
+	memc->dst = zalloc(memc->length);
+	if (!memc->dst)
+		die("Memory allocation failed\n");
+	memc->src = zalloc(memc->length);
+	if (!memc->src)
+		die("Memory allocation failed\n");
 
-	if (use_clock) {
-		init_clock();
-		clock_start = get_clock();
-	} else {
-		BUG_ON(gettimeofday(&tv_start, NULL));
-	}
-
-	routines[i].fn(dst, src, length);
-
-	if (use_clock) {
-		clock_end = get_clock();
-		clock_diff = clock_end - clock_start;
-	} else {
-		BUG_ON(gettimeofday(&tv_end, NULL));
-		timersub(&tv_end, &tv_start, &tv_diff);
-		bps = (double)((double)length / timeval2double(&tv_diff));
-	}
+	ctx->priv = memc;
+}
 
-	switch (bench_format) {
-	case BENCH_FORMAT_DEFAULT:
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
-			}
-		}
-		break;
-	case BENCH_FORMAT_SIMPLE:
-		if (use_clock) {
-			printf("%14lf\n",
-			       (double)clock_diff / (double)length);
-		} else
-			printf("%lf\n", bps);
-		break;
-	default:
-		/* reaching this means there's some disaster: */
-		die("unknown format: %d\n", bench_format);
-		break;
-	}
+void mem_memcpy_bench(struct bench_ctx *ctx)
+{
+	struct memcpy_context *memc = ctx->priv;
+	memc->fn(memc->dst, memc->src, memc->length);
+}
 
-	return 0;
+void mem_memcpy_clean(struct bench_ctx *ctx)
+{
+	struct memcpy_context *memc = ctx->priv;
+	free(memc->dst);
+	free(memc->src);
 }
diff --git a/tools/perf/bench/mem.h b/tools/perf/bench/mem.h
new file mode 100644
index 0000000..6880a63
--- /dev/null
+++ b/tools/perf/bench/mem.h
@@ -0,0 +1,4 @@
+
+BENCH("memcpy", "Simple memory copy in various ways",
+      mem_memcpy_parse, mem_memcpy_prepare,
+      mem_memcpy_bench, mem_memcpy_clean)
-- 
1.7.1

