Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0EBNz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:55:56 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50660 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab0EBNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:55:25 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4][RFC] perf bench: implement parallel oriented benchmarking
Date: Sun,  2 May 2010 22:55:19 +0900
Message-Id: <1272808519-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements structure for parallel oriented benchmarking in perf bench.
Now perf bench receives the option -p or --parallel.
These are used for specifying number of parallelism of benchmark.

Important point is that every programmer who writes each benchmark programs
don't have to care about parallelism.
If benchmark program was written in the guide line of perf bench,
benchmarks will be able to parallel execution ready.

Of course, benchmark programs can care about parallelism.
For example, sched messaging and sched pipe create
their own threads or processes.

=== How to implement a suite of perf bench ===

Each benchmarks have to implement these functions.

 void *(*parse_arg)(int argc, const char **argv, const char *prefix);
 void (*prepare)(struct bench_ctx *);
 void (*bench)(struct bench_ctx *);
 void (*clean)(struct bench_ctx *);

1) parse_arg()
   argc, argv, prefix will be passed to this function.
   And this function should allocate and return memory for storing parameters.
   Returned pointer will be assigned to void *param of struct bench_ctx.
   *param will be shared between each instance of benchmark thread/process.
   So it should be treated as read only object.

1) prepare()
   This function should prepare memory for each instance of benchmark
   thread/process from bench_ctx->param and return it.
   Returned pointer will be assigned to void *priv of struct bench_ctx.
   *priv will not be shared between each instance of benchmark thread/process.
   This can be destroyed by each thread/process.

2) benchmark()
   Do benchmark.

3) clean()
   Clean up resources used in benchmarking.
   This function will be called only in thread mode.
   Because if perf bench is executed with process mode,
   each instance of benchmarking will be exit(),
   so cleaning will not be required.

And these functions should be registered in bench/<subsystem name>.h
like this form:

BENCH("<name>", "<easy description>",
      <parse_arg()>, <prepare()>, <bench()>, <clean()>)

The headers will be included by bench/bench.h and builtin-bench.c
for prototypes and structures.

ATTENTION: 
* BENCH_END() has style problem with checkpatch.pl like this:
ERROR: Macros with multiple statements should be enclosed in a do - while loop
#170: FILE: tools/perf/builtin-bench.c:44:
+#define BENCH(n, s, pa, pr, b, c) {n, s, pa, pr, b, c},

ERROR: Macros with complex values should be enclosed in parenthesis
#172: FILE: tools/perf/builtin-bench.c:46:
+#define BENCH_END() ALL, { NULL, NULL, NULL, NULL, NULL, NULL }

But I think these are not fatal.
If you think this is a fatal problem, please tell me,
I'd like to seek another way.

Example of usage:
| % ./perf bench -p 2 all     # do every benchmarks with 2 groups
| # Running sched/messaging benchmark with 2 parallelism ...
|      Total time: 0.066 [sec]
| # Running sched/pipe benchmark with 2 parallelism ...
|      Total time: 11.429 [sec]
| # Running mem/memcpy benchmark with 2 parallelism ...
|      Total time: 0.002 [sec]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/Makefile        |    5 +
 tools/perf/bench/bench.h   |   32 ++++++
 tools/perf/builtin-bench.c |  227 +++++++++++++++++++++++++++++++++-----------
 3 files changed, 209 insertions(+), 55 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3ac6b67..1980d7f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -415,6 +415,10 @@ LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/cpumap.h
+LIB_H += bench/bench.h
+LIB_H += bench/sample.h
+LIB_H += bench/sched.h
+LIB_H += bench/mem.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -471,6 +475,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
+BUILTIN_OBJS += $(OUTPUT)bench/sample-sample.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-help.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..5ccf137 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,9 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <unistd.h>
+#include <pthread.h>
+
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
@@ -14,4 +17,33 @@ extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __us
 
 extern int bench_format;
 
+struct bench_ctx {
+	int argc;
+	const char **argv;
+	const char *prefix;
+
+	void (*prepare)(struct bench_ctx *);
+	void (*bench)(struct bench_ctx *);
+	void (*clean)(struct bench_ctx *);
+
+	pthread_t pt;
+	pid_t pid;
+
+	int readyfd, wakefd;
+	void *param;		/* shared */
+	void *priv;		/* not shared */
+};
+
+#define BENCH(n, s, parse, prepare, bench, clean)			\
+	void *parse(int argc, const char **argv, const char *prefix);	\
+	void prepare(struct bench_ctx *ctx);				\
+	void bench(struct bench_ctx *ctx);				\
+	void clean(struct bench_ctx *ctx);				\
+
+#include "sample.h"
+#include "sched.h"
+#include "mem.h"
+
+#undef BENCH
+
 #endif
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 4699677..29d39e6 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -26,48 +26,55 @@
 #include <stdlib.h>
 #include <string.h>
 
+struct bench_subsys {
+	const char *name;
+	const char *summary;
+	struct bench_suite *suites;
+};
+
 struct bench_suite {
 	const char *name;
 	const char *summary;
-	int (*fn)(int, const char **, const char *);
+	void *(*parse_arg)(int argc, const char **argv, const char *prefix);
+	void (*prepare)(struct bench_ctx *);
+	void (*bench)(struct bench_ctx *);
+	void (*clean)(struct bench_ctx *);
 };
-						\
-/* sentinel: easy for help */
-#define suite_all { "all", "test all suite (pseudo suite)", NULL }
+
+#define BENCH(n, s, pa, pr, b, c) {n, s, pa, pr, b, c},
+#define ALL { "all", "test all suite (pseudo suite)", NULL, NULL, NULL, NULL }
+#define BENCH_END() ALL, { NULL, NULL, NULL, NULL, NULL, NULL }
+
+#ifdef BUILD_SAMPLE		/* if you need, turn it on manually */
+static struct bench_suite sample_suites[] = {
+#include "bench/sample.h"
+	BENCH_END()
+};
+#endif
 
 static struct bench_suite sched_suites[] = {
-	{ "messaging",
-	  "Benchmark for scheduler and IPC mechanisms",
-	  bench_sched_messaging },
-	{ "pipe",
-	  "Flood of communication over pipe() between two processes",
-	  bench_sched_pipe      },
-	suite_all,
-	{ NULL,
-	  NULL,
-	  NULL                  }
+#include "bench/sched.h"
+	BENCH_END()
 };
 
 static struct bench_suite mem_suites[] = {
-	{ "memcpy",
-	  "Simple memory copy in various ways",
-	  bench_mem_memcpy },
-	suite_all,
-	{ NULL,
-	  NULL,
-	  NULL             }
+#include "bench/mem.h"
+	BENCH_END()
 };
 
-struct bench_subsys {
-	const char *name;
-	const char *summary;
-	struct bench_suite *suites;
-};
+#undef BENCH
 
 static struct bench_subsys subsystems[] = {
+#ifdef BUILD_SAMPLE
+	{ "sample",
+	  "sample implementation of perf bench",
+	  sample_suites
+	},
+#endif
 	{ "sched",
 	  "scheduler and IPC mechanism",
-	  sched_suites },
+	  sched_suites
+	},
 	{ "mem",
 	  "memory access performance",
 	  mem_suites },
@@ -98,9 +105,16 @@ static void dump_suites(int subsys_index)
 static char *bench_format_str;
 int bench_format = BENCH_FORMAT_DEFAULT;
 
+static int thread_mode;		/* default is process mode */
+static int parallel = 1;
+
 static const struct option bench_options[] = {
 	OPT_STRING('f', "format", &bench_format_str, "default",
 		    "Specify format style"),
+	OPT_BOOLEAN('t', "thread", &thread_mode,
+		    "Be multi thread instead of multi process"),
+	OPT_INTEGER('p', "parallel", &parallel,
+		    "Number of processes (or threads)"),
 	OPT_END()
 };
 
@@ -139,38 +153,144 @@ static int bench_str2int(char *str)
 	return BENCH_FORMAT_UNKNOWN;
 }
 
-static void all_suite(struct bench_subsys *subsys)	  /* FROM HERE */
+static void *worker(void *arg)
 {
-	int i;
-	const char *argv[2];
-	struct bench_suite *suites = subsys->suites;
+	int dummy = 0;
+	struct bench_ctx *ctx = arg;
+	struct pollfd pollfd = { .fd = ctx->wakefd, .events = POLLIN };
+
+	ctx->prepare(ctx);
+	if (write(ctx->readyfd, &dummy, 1) != 1)
+		die("writing data to readyfd failed\n");
+	if (poll(&pollfd, 1, -1) != 1)
+		die("poll()ing wakefd failed\n");
+
+	ctx->bench(ctx);
+
+	if (thread_mode)
+		pthread_exit(NULL);
+	else
+		exit(0);
+
+	return NULL;
+}
+
+static int do_one_suite(int argc, const char **argv, const char *prefix,
+			struct bench_subsys *subsys, struct bench_suite *suite)
+{
+	int i, dummy = 0;
+	struct bench_ctx *ctx_array;
+	struct timeval start, stop, diff;
+	int readyfd[2], wakefd[2];
+	void *param;
+
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("# Running %s/%s benchmark with %d parallelism ...\n",
+		       subsys->name, suite->name, parallel);
+	}
+
+	ctx_array = zalloc(parallel * sizeof(struct bench_ctx));
+	if (!ctx_array)
+		die("Memory allocation failed\n");
+
+	param = suite->parse_arg(argc, argv, prefix);
+
+	if (pipe(readyfd))
+		die("pipe() failed\n");
+	if (pipe(wakefd))
+		die("pipe() failed\n");
+
+	for (i = 0; i < parallel; i++) {
+		ctx_array[i].argc = argc;
+		ctx_array[i].argv = argv;
+		ctx_array[i].prefix = prefix;
+
+		ctx_array[i].param = param;
+		ctx_array[i].prepare = suite->prepare;
+		ctx_array[i].bench = suite->bench;
+		ctx_array[i].clean = suite->clean;
+
+		ctx_array[i].readyfd = readyfd[1];
+		ctx_array[i].wakefd = wakefd[0];
+
+		if (thread_mode) {
+			if (pthread_create(&ctx_array[i].pt, NULL,
+					   worker, &ctx_array[i]))
+				die("pthread_create() failed\n");
+		} else {
+			ctx_array[i].pid = fork();
+			switch (ctx_array[i].pid) {
+			case 0:
+				worker(&ctx_array[i]);
+				break;
+			case -1:
+				die("fork() failed\n");
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < parallel; i++) {
+		if (read(readyfd[0], &dummy, 1) != 1)
+			die("reading data from readyfd failed\n");
+	}
+
+	gettimeofday(&start, NULL);
+	if (write(wakefd[1], &dummy, 1) != 1)
+		die("writing data to wakefd failed\n");
+
+	for (i = 0; i < parallel; i++) {
+		if (thread_mode) {
+			if (pthread_join(ctx_array[i].pt, NULL))
+				die("pthread_join() failed\n");
+		} else {
+			if (wait(NULL) == -1)
+				die("wait() failed\n");
+		}
+	}
+
+	gettimeofday(&stop, NULL);
+	timersub(&stop, &start, &diff);
+
+	printf(" %14s: %lu.%03lu [sec]\n", "Total time",
+	       diff.tv_sec,
+	       (unsigned long) (diff.tv_usec/1000));
 
-	argv[1] = NULL;
 	/*
-	 * TODO:
-	 * preparing preset parameters for
-	 * embedded, ordinary PC, HPC, etc...
-	 * will be helpful
+	 * if it is process mode, resources are freeed
+	 * because child processes already exit()ed
 	 */
-	for (i = 0; suites[i].fn; i++) {
-		printf("# Running %s/%s benchmark...\n",
-		       subsys->name,
-		       suites[i].name);
-
-		argv[1] = suites[i].name;
-		suites[i].fn(1, argv, NULL);
-		printf("\n");
+	if (thread_mode) {
+		for (i = 0; i < parallel; i++)
+			ctx_array[i].clean(&ctx_array[i]);
 	}
+
+	free(param);
+	free(ctx_array);
+
+	return 0;
 }
 
-static void all_subsystem(void)
+static void do_all_suite(int argc, const char **argv, const char *prefix,
+			struct bench_subsys *subsys)
 {
 	int i;
+
+	for (i = 0; subsys->suites[i].parse_arg; i++)
+		do_one_suite(argc, argv, prefix, subsys, &subsys->suites[i]);
+}
+
+static void do_all_subsystem(int argc, const char **argv, const char *prefix)
+{
+	int i;
+
 	for (i = 0; subsystems[i].suites; i++)
-		all_suite(&subsystems[i]);
+		do_all_suite(argc, argv, prefix, &subsystems[i]);
 }
 
-int cmd_bench(int argc, const char **argv, const char *prefix __used)
+int cmd_bench(int argc, const char **argv, const char *prefix)
 {
 	int i, j, status = 0;
 
@@ -195,7 +315,7 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (!strcmp(argv[0], "all")) {
-		all_subsystem();
+		do_all_subsystem(argc, argv, prefix);
 		goto end;
 	}
 
@@ -210,7 +330,7 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 		}
 
 		if (!strcmp(argv[1], "all")) {
-			all_suite(&subsystems[i]);
+			do_all_suite(argc, argv, prefix, &subsystems[i]);
 			goto end;
 		}
 
@@ -218,12 +338,9 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 			if (strcmp(subsystems[i].suites[j].name, argv[1]))
 				continue;
 
-			if (bench_format == BENCH_FORMAT_DEFAULT)
-				printf("# Running %s/%s benchmark...\n",
-				       subsystems[i].name,
-				       subsystems[i].suites[j].name);
-			status = subsystems[i].suites[j].fn(argc - 1,
-							    argv + 1, prefix);
+			status = do_one_suite(argc, argv, prefix,
+					      &subsystems[i],
+					      &subsystems[i].suites[j]);
 			goto end;
 		}
 
-- 
1.7.1

