Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042Ab2EQPVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:21:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53028 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760778Ab2EQPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:21:49 -0400
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] perf bench: add new benchmark subsystem and suite "futex wait"
Date: Fri, 18 May 2012 00:21:32 +0900
Message-Id: <1337268092-6765-1-git-send-email-h.mitake@gmail.com>
X-Mailer: git-send-email 1.7.10.rc0.41.gfa678
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Eric and Darren,
(CCed perf and futex folks)

I wrote this patch for adding new subsystem "futex" and its suite "wait" to perf
bench on tip/master. This is based on futextest by Darren Hart.

Could you allow me to import your source code of futextest to perf bench, Darren?

Below is the patch, I'd like to hear your comments.



This patch adds new benchmark program for futex subsystem and its suite to perf
bench. The new benchmark is based on performance/futex_wait.c of futextest by
Darren Hart: http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git

This new suite "futex wait" simply create and let worker threads iterate locking
and unlocking of futexes. After this iterations, the result is printed in unit
of Kiter/s: Kilo iteration per second. 1 iter means combination of one locking
and one unlocking.

command line options:
--futex-for-sync: If this option passed, futex will be used instead of pipe()
for sync between main thread and worker threads. This is only for mimicing
subtle behaviour of futextest.

 --futexes <number of futexes>: Number of futexes which will be locked and
unlocked by worker threads. Futexes are distributed to worker threads fairly,
so the condition: <number of futexes> % <number of threads> == 0 must be true.

--threads <number of threads>: Number of worker threads for locking and
unlocking futexes.

--iterations <number of iterations>: Number of iteration (locking and unlocking
futex).

example usage:
$ ./perf bench futex wait --futexes 1 --threads 1
# Running futex/wait benchmark...
# 1 threads and 1 futexes (1 threads for 1 futex)
2.76s user, 0.00s system, 2.76s wall, 1.00 cores
Result: 36232 Kiter/s
$ ./perf bench futex wait --futexes 2 --threads 16
# Running futex/wait benchmark...
# 16 threads and 2 futexes (8 threads for 1 futex)
8.35s user, 16.53s system, 6.38s wall, 3.90 cores
Result: 15674 Kiter/s

I have to note that this patch produces three warns of checkpatch.pl, but these
are not essential and acceptable:

WARNING: line over 80 characters
#36: FILE: tools/perf/bench/bench.h:8:
+extern int bench_futex_wait(int argc, const char **argv, const char *prefix __used);

WARNING: do not add new typedefs
#76: FILE: tools/perf/bench/futex-wait.c:31:
+typedef volatile u_int32_t futex_t;

WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
#76: FILE: tools/perf/bench/futex-wait.c:31:
+typedef volatile u_int32_t futex_t;

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>

---
 tools/perf/Makefile           |    1 +
 tools/perf/bench/bench.h      |    1 +
 tools/perf/bench/futex-wait.c |  377 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c    |   13 ++
 4 files changed, 392 insertions(+)
 create mode 100644 tools/perf/bench/futex-wait.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6f54efb..4a5aaa0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -375,6 +375,7 @@ BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
+BUILTIN_OBJS += $(OUTPUT)bench/futex-wait.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index a09bece..e927583 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -5,6 +5,7 @@ extern int bench_sched_messaging(int argc, const char **argv, const char *prefix
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
+extern int bench_futex_wait(int argc, const char **argv, const char *prefix __used);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/futex-wait.c b/tools/perf/bench/futex-wait.c
new file mode 100644
index 0000000..091973a
--- /dev/null
+++ b/tools/perf/bench/futex-wait.c
@@ -0,0 +1,377 @@
+/*
+ * futex-wait.c
+ *
+ * Measure FUTEX_WAIT operations per second.
+ * based on futex_wait.c of futextest by Darren Hart <dvhart@linux.intel.com>
+ * and Michel Lespinasse <walken@google.com>
+ *
+ * ported to perf bench by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ * original futextest:
+ * http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
+ */
+
+#include "../perf.h"
+#include "../util.h"
+#include "../util/parse-options.h"
+
+#include "bench.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <pthread.h>
+#include <sys/times.h>
+#include <sys/poll.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#include <linux/futex.h>
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <poll.h>
+
+typedef volatile u_int32_t futex_t;
+
+struct thread_barrier {
+	futex_t threads;
+	futex_t unblock;
+};
+
+struct worker_ctx {
+	futex_t *futex;
+	unsigned int iterations;
+
+	int readyfd, wakefd;
+
+	struct thread_barrier *barrier_before, *barrier_after;
+};
+
+static void fdpair(int fds[2])
+{
+	if (pipe(fds) == 0)
+		return;
+
+	die("pipe() failed");
+}
+
+/**
+ * futex() - SYS_futex syscall wrapper
+ * @uaddr:	address of first futex
+ * @op:		futex op code
+ * @val:	typically expected value of uaddr, but varies by op
+ * @timeout:	typically an absolute struct timespec (except where noted
+ *              otherwise). Overloaded by some ops
+ * @uaddr2:	address of second futex for some ops\
+ * @val3:	varies by op
+ * @opflags:	flags to be bitwise OR'd with op, such as FUTEX_PRIVATE_FLAG
+ *
+ * futex() is used by all the following futex op wrappers. It can also be
+ * used for misuse and abuse testing. Generally, the specific op wrappers
+ * should be used instead. It is a macro instead of an static inline function as
+ * some of the types over overloaded (timeout is used for nr_requeue for
+ * example).
+ *
+ * These argument descriptions are the defaults for all
+ * like-named arguments in the following wrappers except where noted below.
+ */
+#define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
+	syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
+
+/**
+ * futex_wait() - block on uaddr with optional timeout
+ * @timeout:	relative timeout
+ */
+static inline int
+futex_wait(futex_t *uaddr, futex_t val, struct timespec *timeout, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT, val, timeout, NULL, 0, opflags);
+}
+/**
+ * futex_wake() - wake one or more tasks blocked on uaddr
+ * @nr_wake:	wake up to this many tasks
+ */
+static inline int
+futex_wake(futex_t *uaddr, int nr_wake, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags);
+}
+
+/**
+ * futex_cmpxchg() - atomic compare and exchange
+ * @uaddr:	The address of the futex to be modified
+ * @oldval:	The expected value of the futex
+ * @newval:	The new value to try and assign the futex
+ *
+ * Implement cmpxchg using gcc atomic builtins.
+ * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
+ *
+ * Return the old futex value.
+ */
+static inline u_int32_t
+futex_cmpxchg(futex_t *uaddr, u_int32_t oldval, u_int32_t newval)
+{
+	return __sync_val_compare_and_swap(uaddr, oldval, newval);
+}
+
+/**
+ * futex_dec() - atomic decrement of the futex value
+ * @uaddr:	The address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_dec(futex_t *uaddr)
+{
+	return __sync_sub_and_fetch(uaddr, 1);
+}
+
+/**
+ * futex_inc() - atomic increment of the futex value
+ * @uaddr:	the address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_inc(futex_t *uaddr)
+{
+	return __sync_add_and_fetch(uaddr, 1);
+}
+
+static inline void futex_wait_lock(futex_t *futex)
+{
+	int status = *futex;
+	if (status == 0)
+		status = futex_cmpxchg(futex, 0, 1);
+	while (status != 0) {
+		if (status == 1)
+			status = futex_cmpxchg(futex, 1, 2);
+		if (status != 0) {
+			futex_wait(futex, 2, NULL, FUTEX_PRIVATE_FLAG);
+			status = *futex;
+		}
+		if (status == 0)
+			status = futex_cmpxchg(futex, 0, 2);
+	}
+}
+
+static inline void futex_cmpxchg_unlock(futex_t *futex)
+{
+	int status = *futex;
+	if (status == 1)
+		status = futex_cmpxchg(futex, 1, 0);
+	if (status == 2) {
+		futex_cmpxchg(futex, 2, 0);
+		futex_wake(futex, 1, FUTEX_PRIVATE_FLAG);
+	}
+}
+
+/* Called by main thread to initialize barrier */
+static void barrier_init(struct thread_barrier *barrier, int threads)
+{
+	barrier->threads = threads;
+	barrier->unblock = 0;
+}
+
+/* Called by worker threads to synchronize with main thread */
+static int barrier_sync(struct thread_barrier *barrier)
+{
+	futex_dec(&barrier->threads);
+	if (barrier->threads == 0)
+		futex_wake(&barrier->threads, 1, FUTEX_PRIVATE_FLAG);
+	while (barrier->unblock == 0)
+		futex_wait(&barrier->unblock, 0, NULL, FUTEX_PRIVATE_FLAG);
+	return barrier->unblock;
+}
+
+/* Called by main thread to wait for all workers to reach sync point */
+static void barrier_wait(struct thread_barrier *barrier)
+{
+	int threads;
+	while ((threads = barrier->threads) > 0)
+		futex_wait(&barrier->threads, threads, NULL,
+			   FUTEX_PRIVATE_FLAG);
+}
+
+/* Called by main thread to unblock worker threads from their sync point */
+static void barrier_unblock(struct thread_barrier *barrier, int value)
+{
+	barrier->unblock = value;
+	futex_wake(&barrier->unblock, INT_MAX, FUTEX_PRIVATE_FLAG);
+}
+
+static bool use_futex_for_sync;
+
+static void *worker(void *arg)
+{
+	char dummy;
+	int iterations;
+	futex_t *futex;
+
+	struct worker_ctx *ctx = (struct worker_ctx *)arg;
+	struct pollfd pollfd = { .fd = ctx->wakefd, .events = POLLIN };
+
+	iterations = ctx->iterations;
+	futex = ctx->futex;
+	/* currently, we have nothing to prepare */
+	if (use_futex_for_sync) {
+		barrier_sync(ctx->barrier_before);
+	} else {
+		if (write(ctx->readyfd, &dummy, 1) != 1)
+			die("write() on readyfd failed");
+
+		if (poll(&pollfd, 1, -1) != 1)
+			die("poll() failed");
+	}
+
+	while (iterations--) {
+		futex_wait_lock(futex);
+		futex_cmpxchg_unlock(futex);
+	}
+
+	if (use_futex_for_sync)
+		barrier_sync(ctx->barrier_after);
+
+	return NULL;
+}
+
+static int iterations = 100000000;
+static int threads = 256;
+/* futexes are fairly distributed for threads */
+static int futexes = 1;
+
+static const struct option options[] = {
+	OPT_INTEGER('i', "iterations", &iterations,
+		    "number of locking and unlocking"),
+	OPT_INTEGER('t', "threads", &threads,
+		    "number of worker threads"),
+	OPT_INTEGER('f', "futexes", &futexes,
+		"number of futexes, the condition"
+		"threads % futexes == 0 must be true"),
+	OPT_BOOLEAN('s', "futex-for-sync", &use_futex_for_sync,
+		"use futex for sync between main thread and worker threads"),
+	OPT_END()
+};
+
+static const char * const bench_futex_wait_usage[] = {
+	"perf bench futex wait <options>",
+	NULL
+};
+
+int bench_futex_wait(int argc, const char **argv,
+		const char *prefix __used)
+{
+	int i;
+	char buf;
+	int wakefds[2], readyfds[2];
+	pthread_t *pth_tab;
+	struct worker_ctx *ctx_tab;
+	futex_t *futex_tab;
+
+	struct thread_barrier barrier_before, barrier_after;
+
+	clock_t before, after;
+	struct tms tms_before, tms_after;
+	int wall, user, system_time;
+	double tick;
+
+	argc = parse_options(argc, argv, options,
+			     bench_futex_wait_usage, 0);
+
+	if (threads % futexes)
+		die("threads %% futexes must be 0");
+
+	if (use_futex_for_sync) {
+		barrier_init(&barrier_before, threads);
+		barrier_init(&barrier_after, threads);
+	} else {
+		fdpair(wakefds);
+		fdpair(readyfds);
+	}
+
+	pth_tab = calloc(sizeof(pthread_t), threads);
+	if (!pth_tab)
+		die("calloc() for pthread descriptors failed");
+	ctx_tab = calloc(sizeof(struct worker_ctx), threads);
+	if (!ctx_tab)
+		die("calloc() for worker contexts failed");
+	futex_tab = calloc(sizeof(futex_t), futexes);
+	if (!futex_tab)
+		die("calloc() for futexes failed");
+
+	for (i = 0; i < threads; i++) {
+		ctx_tab[i].futex = &futex_tab[i % futexes];
+		ctx_tab[i].iterations = iterations / threads;
+
+		ctx_tab[i].readyfd = readyfds[1];
+		ctx_tab[i].wakefd = wakefds[0];
+
+		if (use_futex_for_sync) {
+			ctx_tab[i].barrier_before = &barrier_before;
+			ctx_tab[i].barrier_after = &barrier_after;
+		}
+
+		if (pthread_create(&pth_tab[i], NULL, worker, &ctx_tab[i]))
+			die("pthread_create() for creating workers failed");
+	}
+
+	if (use_futex_for_sync) {
+		barrier_wait(&barrier_before);
+	} else {
+		for (i = 0; i < threads; i++) {
+			if (read(readyfds[0], &buf, 1) != 1)
+				die("read() for ready failed");
+		}
+	}
+
+	before = times(&tms_before);
+
+	if (use_futex_for_sync) {
+		barrier_unblock(&barrier_before, 1);
+	} else {
+		if (write(wakefds[1], &buf, 1) != 1)
+			die("write() for waking up workers failed");
+	}
+
+	if (use_futex_for_sync) {
+		barrier_wait(&barrier_after);
+	} else {
+		for (i = 0; i < threads; i++)
+			pthread_join(pth_tab[i], NULL);
+	}
+
+	after = times(&tms_after);
+
+	wall = after - before;
+	user = tms_after.tms_utime - tms_before.tms_utime;
+	system_time = tms_after.tms_stime - tms_before.tms_stime;
+	tick = 1.0 / sysconf(_SC_CLK_TCK);
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf("# %d threads and %d futexes (%d threads for 1 futex)\n",
+			threads, futexes, threads / futexes);
+		printf("%.2fs user, %.2fs system, %.2fs wall, %.2f cores\n",
+			user * tick, system_time * tick, wall * tick,
+			wall ? (user + system_time) * 1. / wall : 1.);
+		printf("Result: %.0f Kiter/s\n",
+			iterations / (wall * tick * 1000));
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf("%.0f Kiter/s\n",
+			iterations / (wall * tick * 1000));
+		break;
+	default:
+		/* reaching here is something disaster */
+		die("Unknown format:%d\n", bench_format);
+		break;
+	}
+
+	free((void *)pth_tab);
+	free((void *)ctx_tab);
+	free((void *)futex_tab);
+
+	return 0;
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index b0e74ab..cd8ebfd 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -61,6 +61,16 @@ static struct bench_suite mem_suites[] = {
 	  NULL             }
 };
 
+static struct bench_suite futex_suites[] = {
+	{ "wait",
+	  "futex wait",
+	  bench_futex_wait },
+	suite_all,
+	{ NULL,
+	  NULL,
+	  NULL             }
+};
+
 struct bench_subsys {
 	const char *name;
 	const char *summary;
@@ -74,6 +84,9 @@ static struct bench_subsys subsystems[] = {
 	{ "mem",
 	  "memory access performance",
 	  mem_suites },
+	{ "futex",
+	  "futex performance",
+	  futex_suites },
 	{ "all",		/* sentinel: easy for help */
 	  "test all subsystem (pseudo subsystem)",
 	  NULL },
-- 
1.7.10.rc0.41.gfa678

