Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0EBNz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:55:58 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50653 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab0EBNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:55:25 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/4][RFC] perf bench: fix "sched" subsystem to adopt new style of perf bench
Date: Sun,  2 May 2010 22:55:18 +0900
Message-Id: <1272808519-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adopts "sched" subsystem to new structure of perf bench.

This containts a big change of "messaging" suite.
Previous messaging was based on Rusty Russell's hackbench,
and that contained groups of processes or threads.

Now perf bench provides parallel oriented framework,
so the concept of groups was reduced from messaging.
In other words, new messaging suite only cares about one group,
and perf bench creates and controls each groups.

And "pipe" suite changed too.
But this change is little and trivial compared with change of messaging.

Example of usage:

| % ./perf bench sched messaging                # default messaging benchmark
| # Running sched/messaging benchmark with 1 parallelism ...
|      Total time: 0.037 [sec]
| % ./perf bench -p 10 sched messaging          # 10 groups
| # Running sched/messaging benchmark with 10 parallelism ...
|      Total time: 0.357 [sec]
| % ./perf bench -p 10 sched messaging -l 1000  # 10 groups, 1000 loops
| # Running sched/messaging benchmark with 10 parallelism ...
|      Total time: 3.435 [sec]

| % ./perf bench sched pipe                     # default pipe benchmark
| # Running sched/pipe benchmark with 1 parallelism ...
|      Total time: 5.655 [sec]
| % ./perf bench -p 4 sched pipe -l 100000      # 4 groups, 100000 loops
| # Running sched/pipe benchmark with 4 parallelism ...
|      Total time: 2.284 [sec]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/bench/sched-messaging.c |  553 ++++++++++++++++++++----------------
 tools/perf/bench/sched-pipe.c      |  146 +++++-----
 tools/perf/bench/sched.h           |    8 +
 3 files changed, 383 insertions(+), 324 deletions(-)
 create mode 100644 tools/perf/bench/sched.h

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index da1b2e9..029e346 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -12,10 +12,10 @@
 #include "../perf.h"
 #include "../util/util.h"
 #include "../util/parse-options.h"
+#include "../util/header.h"
 #include "../builtin.h"
 #include "bench.h"
 
-/* Test groups of 20 processes spraying to 20 receivers */
 #include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -29,310 +29,365 @@
 #include <sys/poll.h>
 #include <limits.h>
 
-#define DATASIZE 100
-
-static bool use_pipes = false;
-static unsigned int loops = 100;
-static bool thread_mode = false;
-static unsigned int num_groups = 10;
+struct messaging_param {
+	bool use_pipes;
+	unsigned int loops;
+	bool thread_mode;
+	unsigned int pairs;	/* pairs per one group */
+	unsigned int data_size;
+};
 
 struct sender_context {
-	unsigned int num_fds;
-	int ready_out;
-	int wakefd;
-	int out_fds[0];
+	int readyfd, wakefd;
+	pthread_t thid;
+
+	int *sendfds;
+	unsigned int loops;
+	int data_size;
+	char *data;
+
+	void *param;
 };
 
 struct receiver_context {
-	unsigned int num_packets;
-	int in_fds[2];
-	int ready_out;
-	int wakefd;
-};
+	int readyfd, wakefd;
+	pthread_t thid;
 
-static void barf(const char *msg)
-{
-	fprintf(stderr, "%s (error: %s)\n", msg, strerror(errno));
-	exit(1);
-}
+	int readfd;
+	unsigned int loops;
+	int data_size;
+	char *data;
 
-static void fdpair(int fds[2])
-{
-	if (use_pipes) {
-		if (pipe(fds) == 0)
-			return;
-	} else {
-		if (socketpair(AF_UNIX, SOCK_STREAM, 0, fds) == 0)
-			return;
-	}
+	void *param;
+};
 
-	barf(use_pipes ? "pipe()" : "socketpair()");
-}
+struct messaging_context {
+	int readyfd, wakefd;
+
+	struct sender_context **sarray;
+	struct receiver_context **rarray;
+};
 
 /* Block until we're ready to go */
-static void ready(int ready_out, int wakefd)
+static void ready(int readyfd, int wakefd)
 {
 	char dummy;
 	struct pollfd pollfd = { .fd = wakefd, .events = POLLIN };
 
 	/* Tell them we're ready. */
-	if (write(ready_out, &dummy, 1) != 1)
-		barf("CLIENT: ready write");
+	if (write(readyfd, &dummy, 1) != 1)
+		die("write() failed\n");
 
 	/* Wait for "GO" signal */
 	if (poll(&pollfd, 1, -1) != 1)
-		barf("poll");
+		die("poll() failed\n");
 }
 
-/* Sender sprays loops messages down each file descriptor */
-static void *sender(struct sender_context *ctx)
+static void *receiver(void *arg)
 {
-	char data[DATASIZE];
-	unsigned int i, j;
-
-	ready(ctx->ready_out, ctx->wakefd);
-
-	/* Now pump to every receiver. */
-	for (i = 0; i < loops; i++) {
-		for (j = 0; j < ctx->num_fds; j++) {
-			int ret, done = 0;
-
-again:
-			ret = write(ctx->out_fds[j], data + done,
-				    sizeof(data)-done);
-			if (ret < 0)
-				barf("SENDER: write");
-			done += ret;
-			if (done < DATASIZE)
-				goto again;
+	int rtotal, rbytes;
+	struct receiver_context *ctx = arg;
+	struct messaging_param *param = ctx->param;
+
+	ready(ctx->readyfd, ctx->wakefd);
+
+	rtotal = ctx->loops * param->pairs * ctx->data_size;
+loop:
+	rbytes = read(ctx->readfd, ctx->data, ctx->data_size);
+	if (rbytes < 0)
+		die("read() failed\n");
+	rtotal -= rbytes;
+	BUG_ON(rtotal < 0);
+	if (rtotal)
+		goto loop;
+
+	if (param->thread_mode)
+		pthread_exit(NULL);
+	else
+		exit(0);
+	return NULL;
+}
+
+static void *sender(void *arg)
+{
+	unsigned int r;
+	int wtotal, wbytes;
+	struct sender_context *ctx = arg;
+	struct messaging_param *param = ctx->param;
+
+	ready(ctx->readyfd, ctx->wakefd);
+
+	while (ctx->loops--) {
+		for (r = 0; r < param->pairs; r++) {
+			wtotal = 0;
+loop:
+			wbytes = write(ctx->sendfds[r], ctx->data + wtotal,
+				       ctx->data_size - wtotal);
+			if (wbytes < 0)
+				die("write() failed\n");
+			wtotal += wbytes;
+			if (wtotal != ctx->data_size)
+				goto loop;
 		}
 	}
 
+	if (param->thread_mode)
+		pthread_exit(NULL);
+	else
+		exit(0);
 	return NULL;
 }
 
+static const char * const sched_messaging_usage[] = {
+       "perf bench sched messaging <options>",
+       NULL
+};
 
-/* One receiver per fd */
-static void *receiver(struct receiver_context* ctx)
+static void *__sched_messaging_parse(int argc, const char **argv,
+			      const char *prefix __used,
+			      struct messaging_param *param)
 {
-	unsigned int i;
+	const struct option options[] = {
+		OPT_BOOLEAN('p', "pipe", &param->use_pipes,
+			    "Use pipe() instead of socketpair()"),
+		OPT_BOOLEAN('t', "thread", &param->thread_mode,
+			    "Be multi thread instead of multi process"),
+		OPT_INTEGER('g', "pairs", &param->pairs,
+			    "Pairs per one group"),
+		OPT_INTEGER('l', "loop", &param->loops,
+			    "Number of loops"),
+		OPT_INTEGER('d', "datasize", &param->data_size,
+			    "Datasize per messaging"),
+		OPT_END()
+	};
 
-	if (!thread_mode)
-		close(ctx->in_fds[1]);
+	argc = parse_options(argc, argv, options,
+			     sched_messaging_usage, PARSE_OPT_KEEP_ARGV0);
 
-	/* Wait for start... */
-	ready(ctx->ready_out, ctx->wakefd);
+	return param;
+}
 
-	/* Receive them all */
-	for (i = 0; i < ctx->num_packets; i++) {
-		char data[DATASIZE];
-		int ret, done = 0;
+void *sched_messaging_parse(int argc, const char **argv,
+			    const char *prefix __used)
+{
+	struct messaging_param *param;
 
-again:
-		ret = read(ctx->in_fds[0], data + done, DATASIZE - done);
-		if (ret < 0)
-			barf("SERVER: read");
-		done += ret;
-		if (done < DATASIZE)
-			goto again;
-	}
+	param = zalloc(sizeof(struct messaging_param));
+	if (!param)
+		die("Memory allocation failed\n");
 
-	return NULL;
+	/* set default parameters */
+	param->use_pipes = 0;
+	param->thread_mode = 0;
+	param->pairs = 10;
+	param->loops = 100;
+	param->data_size = 100;
+
+	return __sched_messaging_parse(argc, argv, prefix, param);
 }
 
-static pthread_t create_worker(void *ctx, void *(*func)(void *))
+void sched_messaging_prepare(struct bench_ctx *ctx)
 {
-	pthread_attr_t attr;
-	pthread_t childid;
-	int err;
-
-	if (!thread_mode) {
-		/* process mode */
-		/* Fork the receiver. */
-		switch (fork()) {
-		case -1:
-			barf("fork()");
-			break;
-		case 0:
-			(*func) (ctx);
-			exit(0);
-			break;
-		default:
-			break;
-		}
-
-		return (pthread_t)0;
+	unsigned int i, s, r;
+	char dummy;
+	int readyfd[2], wakefd[2];
+	int **commfds;
+
+	struct messaging_context *msg;
+	struct messaging_param *param = ctx->param;
+	struct sender_context **sarray;
+	struct receiver_context **rarray;
+
+	msg = zalloc(sizeof(struct messaging_context));
+	if (!msg)
+		die("Memory allocation failed\n");
+
+	sarray = zalloc(sizeof(struct sender_context *) * param->pairs);
+	if (!sarray)
+		die("Memory allocation failed\n");
+
+	rarray = zalloc(sizeof(struct receiver_context *) * param->pairs);
+	if (!rarray)
+		die("Memory allocation failed\n");
+
+	if (pipe(readyfd))
+		die("pipe() failed\n");
+	if (pipe(wakefd))
+		die("pipe() failed\n");
+
+	msg->readyfd = readyfd[0];
+	msg->wakefd = wakefd[1];
+
+	commfds = zalloc(sizeof(int *) * param->pairs);
+	if (!commfds)
+		die("Memory allocation failed\n");
+	for (i = 0; i < param->pairs; i++) {
+		commfds[i] = zalloc(sizeof(int) * 2);
+		if (!commfds[i])
+			die("Memory allocation failed\n");
 	}
 
-	if (pthread_attr_init(&attr) != 0)
-		barf("pthread_attr_init:");
+	for (i = 0; i < param->pairs; i++) {
+		if (param->use_pipes) {
+			if (pipe(commfds[i]))
+				die("pipe() failed\n");
+		} else {
+			if (socketpair(AF_UNIX, SOCK_STREAM, 0, commfds[i]))
+				die("socketpair() failed\n");
+		}
+	}
 
-#ifndef __ia64__
-	if (pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN) != 0)
-		barf("pthread_attr_setstacksize");
-#endif
+	for (s = 0; s < param->pairs; s++) {
+		struct sender_context *new_sctx = NULL;
+
+		sarray[s] = zalloc(sizeof(struct sender_context));
+		if (!sarray[s])
+			die("Memory allocation failed\n");
+		new_sctx = sarray[s];
+
+		new_sctx->sendfds = zalloc(sizeof(int) * param->pairs);
+		if (!new_sctx->sendfds)
+			die("Memory allocation failed\n");
+		new_sctx->data = zalloc(sizeof(char) * param->data_size);
+		if (!new_sctx->data)
+			die("Memory allocation failed\n");
+		new_sctx->data_size = param->data_size;
+		new_sctx->readyfd = readyfd[1];
+		new_sctx->wakefd = wakefd[0];
+		new_sctx->loops = param->loops;
+		new_sctx->param = param;
+
+		for (r = 0; r < param->pairs; r++)
+			new_sctx->sendfds[r] = commfds[r][1];
+
+		if (param->thread_mode) {
+			if (pthread_create(&new_sctx->thid, NULL,
+					   sender, new_sctx))
+				die("pthread_create()\n");
+		} else {
+			switch (fork()) {
+			case -1:
+				die("fork() failed\n");
+				break;
+			case 0:
+				sender(new_sctx);
+				break;
+			default:
+				/* I'm parent, do nothing */
+				break;
+			}
+		}
+	}
 
-	err = pthread_create(&childid, &attr, func, ctx);
-	if (err != 0) {
-		fprintf(stderr, "pthread_create failed: %s (%d)\n",
-			strerror(err), err);
-		exit(-1);
+	for (r = 0; r < param->pairs; r++) {
+		struct receiver_context *new_rctx = NULL;
+
+		rarray[r] = zalloc(sizeof(struct receiver_context));
+		if (!rarray[r])
+			die("Memory allocation failed\n");
+		new_rctx = rarray[r];
+
+		new_rctx->readyfd = readyfd[1];
+		new_rctx->wakefd = wakefd[0];
+		new_rctx->loops = param->loops;
+
+		new_rctx->data = zalloc(sizeof(char) * param->data_size);
+		if (!new_rctx->data)
+			die("Memory allocation failed\n");
+		new_rctx->data_size = param->data_size;
+		new_rctx->param = param;
+
+		new_rctx->readfd = commfds[r][0];
+
+		if (param->thread_mode) {
+			if (pthread_create(&new_rctx->thid, NULL,
+					   receiver, new_rctx))
+				die("pthread_create()\n");
+		} else {
+			switch (fork()) {
+			case -1:
+				die("fork() failed\n");
+				break;
+			case 0:
+				receiver(new_rctx);
+				break;
+			default:
+				/* I'm parent, do nothing */
+				break;
+			}
+		}
 	}
-	return childid;
-}
 
-static void reap_worker(pthread_t id)
-{
-	int proc_status;
-	void *thread_status;
-
-	if (!thread_mode) {
-		/* process mode */
-		wait(&proc_status);
-		if (!WIFEXITED(proc_status))
-			exit(1);
-	} else {
-		pthread_join(id, &thread_status);
+	for (s = 0; s < param->pairs; s++) {
+		if (read(msg->readyfd, &dummy, 1) != 1)
+			die("read() failed\n");
 	}
+	for (r = 0; r < param->pairs; r++) {
+		if (read(msg->readyfd, &dummy, 1) != 1)
+			die("read() failed\n");
+	}
+
+	msg->sarray = sarray;
+	msg->rarray = rarray;
+	ctx->priv = msg;
+	for (i = 0; i < param->pairs; i++)
+		free(commfds[i]);
+	free(commfds);
 }
 
-/* One group of senders and receivers */
-static unsigned int group(pthread_t *pth,
-		unsigned int num_fds,
-		int ready_out,
-		int wakefd)
+void sched_messaging_bench(struct bench_ctx *ctx)
 {
 	unsigned int i;
-	struct sender_context *snd_ctx = malloc(sizeof(struct sender_context)
-			+ num_fds * sizeof(int));
-
-	if (!snd_ctx)
-		barf("malloc()");
-
-	for (i = 0; i < num_fds; i++) {
-		int fds[2];
-		struct receiver_context *ctx = malloc(sizeof(*ctx));
-
-		if (!ctx)
-			barf("malloc()");
-
-
-		/* Create the pipe between client and server */
-		fdpair(fds);
-
-		ctx->num_packets = num_fds * loops;
-		ctx->in_fds[0] = fds[0];
-		ctx->in_fds[1] = fds[1];
-		ctx->ready_out = ready_out;
-		ctx->wakefd = wakefd;
+	char dummy;
+	struct messaging_context *msg = ctx->priv;
+	struct messaging_param *param = ctx->param;
 
-		pth[i] = create_worker(ctx, (void *)receiver);
+	if (write(msg->wakefd, &dummy, 1) != 1)
+		die("write() failed\n");
 
-		snd_ctx->out_fds[i] = fds[1];
-		if (!thread_mode)
-			close(fds[0]);
-	}
-
-	/* Now we have all the fds, fork the senders */
-	for (i = 0; i < num_fds; i++) {
-		snd_ctx->ready_out = ready_out;
-		snd_ctx->wakefd = wakefd;
-		snd_ctx->num_fds = num_fds;
+	if (param->thread_mode) {
+		for (i = 0; i < param->pairs; i++) {
+			pthread_join(msg->sarray[i]->thid, NULL);
+			pthread_join(msg->rarray[i]->thid, NULL);
+		}
+	} else {
+		int proc_status;
 
-		pth[num_fds+i] = create_worker(snd_ctx, (void *)sender);
+		for (i = 0; i < param->pairs * 2; i++) {
+			wait(&proc_status);
+			if (!WIFEXITED(proc_status))
+				die("Invalid exit status\n");
+		}
 	}
-
-	/* Close the fds we have left */
-	if (!thread_mode)
-		for (i = 0; i < num_fds; i++)
-			close(snd_ctx->out_fds[i]);
-
-	/* Return number of children to reap */
-	return num_fds * 2;
 }
 
-static const struct option options[] = {
-	OPT_BOOLEAN('p', "pipe", &use_pipes,
-		    "Use pipe() instead of socketpair()"),
-	OPT_BOOLEAN('t', "thread", &thread_mode,
-		    "Be multi thread instead of multi process"),
-	OPT_INTEGER('g', "group", &num_groups,
-		    "Specify number of groups"),
-	OPT_INTEGER('l', "loop", &loops,
-		    "Specify number of loops"),
-	OPT_END()
-};
-
-static const char * const bench_sched_message_usage[] = {
-	"perf bench sched messaging <options>",
-	NULL
-};
-
-int bench_sched_messaging(int argc, const char **argv,
-		    const char *prefix __used)
+void sched_messaging_clean(struct bench_ctx *ctx)
 {
-	unsigned int i, total_children;
-	struct timeval start, stop, diff;
-	unsigned int num_fds = 20;
-	int readyfds[2], wakefds[2];
-	char dummy;
-	pthread_t *pth_tab;
+	unsigned int i;
+	struct messaging_param *param = ctx->param;
+	struct messaging_context *msg = ctx->priv;
+
+	for (i = 0; i < param->pairs; i++) {
+		struct sender_context *sctx;
+		sctx = msg->sarray[i];
+		close(sctx->readyfd);
+		close(sctx->wakefd);
+		free(sctx->data);
+		free(sctx);
+	}
 
-	argc = parse_options(argc, argv, options,
-			     bench_sched_message_usage, 0);
-
-	pth_tab = malloc(num_fds * 2 * num_groups * sizeof(pthread_t));
-	if (!pth_tab)
-		barf("main:malloc()");
-
-	fdpair(readyfds);
-	fdpair(wakefds);
-
-	total_children = 0;
-	for (i = 0; i < num_groups; i++)
-		total_children += group(pth_tab+total_children, num_fds,
-					readyfds[1], wakefds[0]);
-
-	/* Wait for everyone to be ready */
-	for (i = 0; i < total_children; i++)
-		if (read(readyfds[0], &dummy, 1) != 1)
-			barf("Reading for readyfds");
-
-	gettimeofday(&start, NULL);
-
-	/* Kick them off */
-	if (write(wakefds[1], &dummy, 1) != 1)
-		barf("Writing to start them");
-
-	/* Reap them all */
-	for (i = 0; i < total_children; i++)
-		reap_worker(pth_tab[i]);
-
-	gettimeofday(&stop, NULL);
-
-	timersub(&stop, &start, &diff);
-
-	switch (bench_format) {
-	case BENCH_FORMAT_DEFAULT:
-		printf("# %d sender and receiver %s per group\n",
-		       num_fds, thread_mode ? "threads" : "processes");
-		printf("# %d groups == %d %s run\n\n",
-		       num_groups, num_groups * 2 * num_fds,
-		       thread_mode ? "threads" : "processes");
-		printf(" %14s: %lu.%03lu [sec]\n", "Total time",
-		       diff.tv_sec,
-		       (unsigned long) (diff.tv_usec/1000));
-		break;
-	case BENCH_FORMAT_SIMPLE:
-		printf("%lu.%03lu\n", diff.tv_sec,
-		       (unsigned long) (diff.tv_usec/1000));
-		break;
-	default:
-		/* reaching here is something disaster */
-		fprintf(stderr, "Unknown format:%d\n", bench_format);
-		exit(1);
-		break;
+	for (i = 0; i < param->pairs; i++) {
+		struct receiver_context *rctx;
+		rctx = msg->rarray[i];
+		close(rctx->readyfd);
+		close(rctx->wakefd);
+		free(rctx->data);
+		free(rctx);
 	}
 
-	return 0;
+	close(msg->readyfd);
+	close(msg->wakefd);
+	free(msg->sarray);
+	free(msg->rarray);
 }
+
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index d9ab3ce..8d2e8fd 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -29,99 +29,95 @@
 #include <sys/types.h>
 
 #define LOOPS_DEFAULT 1000000
-static int loops = LOOPS_DEFAULT;
-
-static const struct option options[] = {
-	OPT_INTEGER('l', "loop", &loops,
-		    "Specify number of loops"),
-	OPT_END()
-};
 
 static const char * const bench_sched_pipe_usage[] = {
 	"perf bench sched pipe <options>",
 	NULL
 };
 
-int bench_sched_pipe(int argc, const char **argv,
-		     const char *prefix __used)
-{
-	int pipe_1[2], pipe_2[2];
-	int m = 0, i;
-	struct timeval start, stop, diff;
-	unsigned long long result_usec = 0;
-
-	/*
-	 * why does "ret" exist?
-	 * discarding returned value of read(), write()
-	 * causes error in building environment for perf
-	 */
-	int ret, wait_stat;
-	pid_t pid, retpid;
-
-	argc = parse_options(argc, argv, options,
-			     bench_sched_pipe_usage, 0);
-
-	assert(!pipe(pipe_1));
-	assert(!pipe(pipe_2));
-
-	pid = fork();
-	assert(pid >= 0);
+struct pipe_param {
+	int loops;
+};
 
-	gettimeofday(&start, NULL);
+struct pipe_context {
+	int loops;
+	int pipe_1[2], pipe_2[2];
+};
 
-	if (!pid) {
-		for (i = 0; i < loops; i++) {
-			ret = read(pipe_1[0], &m, sizeof(int));
-			ret = write(pipe_2[1], &m, sizeof(int));
-		}
-	} else {
-		for (i = 0; i < loops; i++) {
-			ret = write(pipe_1[1], &m, sizeof(int));
-			ret = read(pipe_2[0], &m, sizeof(int));
-		}
-	}
+static void *__sched_pipe_parse(int argc, const char **argv,
+				const char *prefix __used,
+				struct pipe_param *param)
+{
+	const struct option options[] = {
+		OPT_INTEGER('l', "loop", &param->loops,
+			    "Number of loops"),
+		OPT_END()
+	};
 
-	gettimeofday(&stop, NULL);
-	timersub(&stop, &start, &diff);
+	argc = parse_options(argc, argv, options,
+			     bench_sched_pipe_usage, PARSE_OPT_KEEP_ARGV0);
+	return param;
+}
 
-	if (pid) {
-		retpid = waitpid(pid, &wait_stat, 0);
-		assert((retpid == pid) && WIFEXITED(wait_stat));
-	} else {
-		exit(0);
-	}
+void *sched_pipe_parse(int argc, const char **argv, const char *prefix)
+{
+	struct pipe_param *param;
 
-	switch (bench_format) {
-	case BENCH_FORMAT_DEFAULT:
-		printf("# Executed %d pipe operations between two tasks\n\n",
-			loops);
+	param = zalloc(sizeof(struct pipe_param));
+	if (!param)
+		die("Memory allocation failed\n");
+	param->loops = LOOPS_DEFAULT;
 
-		result_usec = diff.tv_sec * 1000000;
-		result_usec += diff.tv_usec;
+	return __sched_pipe_parse(argc, argv, prefix, param);
+}
 
-		printf(" %14s: %lu.%03lu [sec]\n\n", "Total time",
-		       diff.tv_sec,
-		       (unsigned long) (diff.tv_usec/1000));
+void sched_pipe_prepare(struct bench_ctx *ctx)
+{
+	struct pipe_context *pipec;
+	struct pipe_param *param = ctx->param;
+
+	pipec = zalloc(sizeof(struct pipe_context));
+	if (!pipec)
+		die("Memory allocation failed\n");
+	pipec->loops = param->loops;
+	if (pipe(pipec->pipe_1))
+		die("pipe() failed\n");
+	if (pipe(pipec->pipe_2))
+		die("pipe() failed\n");
+
+	ctx->priv = pipec;
+}
 
-		printf(" %14lf usecs/op\n",
-		       (double)result_usec / (double)loops);
-		printf(" %14d ops/sec\n",
-		       (int)((double)loops /
-			     ((double)result_usec / (double)1000000)));
+void sched_pipe_bench(struct bench_ctx *ctx)
+{
+	int ret, m = 0;
+	struct pipe_context *pipec = ctx->priv;
+
+	switch (fork()) {
+	case 0:
+		while (pipec->loops--) {
+			ret = read(pipec->pipe_1[0], &m, sizeof(int));
+			ret = write(pipec->pipe_2[1], &m, sizeof(int));
+		}
 		break;
-
-	case BENCH_FORMAT_SIMPLE:
-		printf("%lu.%03lu\n",
-		       diff.tv_sec,
-		       (unsigned long) (diff.tv_usec / 1000));
+	case -1:
+		die("fork() failed\n");
 		break;
-
 	default:
-		/* reaching here is something disaster */
-		fprintf(stderr, "Unknown format:%d\n", bench_format);
-		exit(1);
+		while (pipec->loops--) {
+			ret = write(pipec->pipe_1[1], &m, sizeof(int));
+			ret = read(pipec->pipe_2[0], &m, sizeof(int));
+		}
 		break;
 	}
+}
+
+void sched_pipe_clean(struct bench_ctx *ctx)
+{
+	struct pipe_context *pipec = ctx->priv;
 
-	return 0;
+	close(pipec->pipe_1[0]);
+	close(pipec->pipe_1[1]);
+	close(pipec->pipe_2[0]);
+	close(pipec->pipe_1[1]);
 }
diff --git a/tools/perf/bench/sched.h b/tools/perf/bench/sched.h
new file mode 100644
index 0000000..2d621b5
--- /dev/null
+++ b/tools/perf/bench/sched.h
@@ -0,0 +1,8 @@
+
+BENCH("messaging", "Benchmark for scheduler and IPC mechanisms",
+      sched_messaging_parse, sched_messaging_prepare,
+      sched_messaging_bench, sched_messaging_clean)
+
+BENCH("pipe", "Flood of communication over pipe() between two processes",
+      sched_pipe_parse, sched_pipe_prepare,
+      sched_pipe_bench, sched_pipe_clean)
-- 
1.7.1

