Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2KRPZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:25:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58821 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2KRPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:25:52 -0500
From: Hitoshi Mitake <h.mitake@gmail.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Hitoshi Mitake <h.mitake@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Gowrishankar <gowrishankar.m@in.ibm.com>,
        Sripathi Kodi <sripathik@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=203/3=5D=20tools/testing=3A=20port=20functionality=20tests=20of=20futextest=20to=20tools/testing/selftests?=
Date: Mon, 19 Nov 2012 00:24:32 +0900
Message-Id: <1353252272-5480-4-git-send-email-h.mitake@gmail.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1353252272-5480-1-git-send-email-h.mitake@gmail.com>
References: <1353252272-5480-1-git-send-email-h.mitake@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ports functionality tests of futextest to
tools/testing/selftests. After applying this patch, "make run_tests"
in tools/testing/selftests will also test functionalities of futex.

checkpatch.pl reports 8 errors and 1warning with this patch. I believe
these can be acceptable. Because 1 error is for a line over 80
chars, but the line is a simple function prototype. And 8 errors are
for lines which #define constants for line coloring.

If these are not acceptable, please tell me. I'll search other ways.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Gowrishankar <gowrishankar.m@in.ibm.com>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 tools/testing/selftests/Makefile                   |    2 +-
 tools/testing/selftests/futex/.gitignore           |    9 +
 tools/testing/selftests/futex/Makefile             |   32 ++
 tools/testing/selftests/futex/futex_requeue_pi.c   |  376 ++++++++++++++++++++
 .../futex/futex_requeue_pi_mismatched_ops.c        |  151 ++++++++
 .../futex/futex_requeue_pi_signal_restart.c        |  202 +++++++++++
 .../testing/selftests/futex/futex_testing_common.c |   45 +++
 .../testing/selftests/futex/futex_testing_common.h |    9 +
 .../futex/futex_wait_private_mapped_file.c         |  137 +++++++
 tools/testing/selftests/futex/futex_wait_timeout.c |  101 ++++++
 .../futex/futex_wait_uninitialized_heap.c          |  139 +++++++
 .../selftests/futex/futex_wait_wouldblock.c        |   94 +++++
 tools/testing/selftests/futex/logging.c            |   93 +++++
 tools/testing/selftests/futex/logging.h            |   88 +++++
 tools/testing/selftests/futex/run.sh               |   92 +++++
 15 files changed, 1569 insertions(+), 1 deletions(-)
 create mode 100644 tools/testing/selftests/futex/.gitignore
 create mode 100644 tools/testing/selftests/futex/Makefile
 create mode 100644 tools/testing/selftests/futex/futex_requeue_pi.c
 create mode 100644 tools/testing/selftests/futex/futex_requeue_pi_mismatched_ops.c
 create mode 100644 tools/testing/selftests/futex/futex_requeue_pi_signal_restart.c
 create mode 100644 tools/testing/selftests/futex/futex_testing_common.c
 create mode 100644 tools/testing/selftests/futex/futex_testing_common.h
 create mode 100644 tools/testing/selftests/futex/futex_wait_private_mapped_file.c
 create mode 100644 tools/testing/selftests/futex/futex_wait_timeout.c
 create mode 100644 tools/testing/selftests/futex/futex_wait_uninitialized_heap.c
 create mode 100644 tools/testing/selftests/futex/futex_wait_wouldblock.c
 create mode 100644 tools/testing/selftests/futex/logging.c
 create mode 100644 tools/testing/selftests/futex/logging.h
 create mode 100755 tools/testing/selftests/futex/run.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 85baf11..adeacbb 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
+TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug futex
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/futex/.gitignore b/tools/testing/selftests/futex/.gitignore
new file mode 100644
index 0000000..c075e7f
--- /dev/null
+++ b/tools/testing/selftests/futex/.gitignore
@@ -0,0 +1,9 @@
+futex_requeue_pi
+futex_requeue_pi_mismatched_ops
+futex_requeue_pi_signal_restart
+futex_wait_private_mapped_file
+futex_wait_timeout
+futex_wait_uninitialized_heap
+futex_wait_wouldblock
+
+*.o
diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/selftests/futex/Makefile
new file mode 100644
index 0000000..1b03b22
--- /dev/null
+++ b/tools/testing/selftests/futex/Makefile
@@ -0,0 +1,32 @@
+HEADER_DIR := ../../../include/tools
+CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -I$(HEADER_DIR)
+LDFLAGS := $(LDFLAGS) -lpthread -lrt
+
+HEADERS := $(HEADER_DIR)/futex.h $(HEADER_DIR)/atomic.h \
+	logging.h futex_testing_common.h
+
+TARGETS := \
+	futex_wait_timeout \
+	futex_wait_wouldblock \
+	futex_requeue_pi \
+	futex_requeue_pi_signal_restart \
+	futex_requeue_pi_mismatched_ops \
+	futex_wait_uninitialized_heap \
+	futex_wait_private_mapped_file
+
+.PHONY: all clean run_test
+all: $(TARGETS)
+
+$(TARGETS): $(HEADERS) futex_testing_common.o logging.o
+
+futex_testing_common.o: futex_testing_common.c futex_testing_common.h
+	gcc -c futex_testing_common.c
+
+logging.o: logging.c logging.h
+	gcc -c logging.c
+
+run_tests:
+	./run.sh
+
+clean:
+	rm -f $(TARGETS) *.o
diff --git a/tools/testing/selftests/futex/futex_requeue_pi.c b/tools/testing/selftests/futex/futex_requeue_pi.c
new file mode 100644
index 0000000..8ba6c54
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_requeue_pi.c
@@ -0,0 +1,376 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2006-2008
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futex_requeue_pi.c
+ *
+ * DESCRIPTION
+ *      This test excercises the futex syscall op codes needed for requeuing
+ *      priority inheritance aware POSIX condition variables and mutexes.
+ *
+ * AUTHORS
+ *	Sripathi Kodi <sripathik@in.ibm.com>
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2008-Jan-13: Initial version by Sripathi Kodi <sripathik@in.ibm.com>
+ *      2009-Nov-6: futex test adaptation by Darren Hart <dvhltc@us.ibm.com>
+ *      2012-Oct-14:
+ *       ported to tools/testing by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ *****************************************************************************/
+
+#include <errno.h>
+#include <limits.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <string.h>
+#include "atomic.h"
+#include "futex.h"
+#include "logging.h"
+#include "futex_testing_common.h"
+
+#define MAX_WAKE_ITERS 1000
+#define THREAD_MAX 10
+#define SIGNAL_PERIOD_US 100
+
+static atomic_t waiters_blocked = ATOMIC_INITIALIZER;
+static atomic_t waiters_woken = ATOMIC_INITIALIZER;
+
+static futex_t f1 = FUTEX_INITIALIZER;
+static futex_t f2 = FUTEX_INITIALIZER;
+static futex_t wake_complete = FUTEX_INITIALIZER;
+
+struct thread_arg {
+	long id;
+	struct timespec *timeout;
+	int lock;
+	int ret;
+};
+
+#define THREAD_ARG_INITIALIZER { 0, NULL, 0, 0 }
+
+static void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -b	Broadcast wakeup (all waiters)\n");
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -l	Lock the pi futex across requeue\n");
+	printf("  -o	Use a third party pi futex owner during requeue" \
+		" (cancels -l)\n");
+	printf("  -t N	Timeout in nanoseconds (default: 0)\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+static void *waiterfn(void *arg)
+{
+	struct thread_arg *args = (struct thread_arg *)arg;
+	futex_t old_val;
+
+	info("Waiter %ld: running\n", args->id);
+	/* Each thread sleeps for a different amount of time
+	 * This is to avoid races, because we don't lock the
+	 * external mutex here */
+	usleep(1000 * (long)args->id);
+
+	old_val = f1;
+	atomic_inc(&waiters_blocked);
+	info("Calling futex_wait_requeue_pi: %p (%u) -> %p\n",
+	     &f1, f1, &f2);
+	args->ret = futex_wait_requeue_pi(&f1, old_val, &f2, args->timeout,
+					  FUTEX_PRIVATE_FLAG);
+
+	info("waiter %ld woke with %d %s\n", args->id, args->ret,
+	     args->ret < 0 ? strerror(errno) : "");
+	atomic_inc(&waiters_woken);
+	if (args->ret < 0) {
+		if (args->timeout && errno == ETIMEDOUT)
+			args->ret = 0;
+		else {
+			args->ret = RET_ERROR;
+			error("futex_wait_requeue_pi\n", errno);
+		}
+		futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+	}
+	futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+
+	info("Waiter %ld: exiting with %d\n", args->id, args->ret);
+	pthread_exit((void *)&args->ret);
+}
+
+static void *broadcast_wakerfn(void *arg)
+{
+	struct thread_arg *args = (struct thread_arg *)arg;
+	int nr_requeue = INT_MAX;
+	int task_count = 0;
+	futex_t old_val;
+	int nr_wake = 1;
+	int i = 0;
+
+	info("Waker: waiting for waiters to block\n");
+	while (waiters_blocked.val < THREAD_MAX)
+		usleep(1000);
+	usleep(1000);
+
+	info("Waker: Calling broadcast\n");
+	if (args->lock) {
+		info("Calling FUTEX_LOCK_PI on mutex=%x @ %p\n", f2, &f2);
+		futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+	}
+ continue_requeue:
+	old_val = f1;
+	args->ret = futex_cmp_requeue_pi(&f1, old_val, &f2, nr_wake, nr_requeue,
+				   FUTEX_PRIVATE_FLAG);
+	if (args->ret < 0) {
+		args->ret = RET_ERROR;
+		error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
+	} else if (++i < MAX_WAKE_ITERS) {
+		task_count += args->ret;
+		if (task_count < THREAD_MAX - waiters_woken.val)
+			goto continue_requeue;
+	} else {
+		error("max broadcast iterations (%d) reached with %d/%d tasks" \
+			" woken or requeued\n",
+			0, MAX_WAKE_ITERS, task_count, THREAD_MAX);
+		args->ret = RET_ERROR;
+	}
+
+	futex_wake(&wake_complete, 1, FUTEX_PRIVATE_FLAG);
+
+	if (args->lock)
+		futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+
+	if (args->ret > 0)
+		args->ret = task_count;
+
+	info("Waker: exiting with %d\n", args->ret);
+	pthread_exit((void *)&args->ret);
+}
+
+static void *signal_wakerfn(void *arg)
+{
+	struct thread_arg *args = (struct thread_arg *)arg;
+	unsigned int old_val;
+	int nr_requeue = 0;
+	int task_count = 0;
+	int nr_wake = 1;
+	int i = 0;
+
+	info("Waker: waiting for waiters to block\n");
+	while (waiters_blocked.val < THREAD_MAX)
+		usleep(1000);
+	usleep(1000);
+
+	while (task_count < THREAD_MAX && waiters_woken.val < THREAD_MAX) {
+		info("task_count: %d, waiters_woken: %d\n",
+		     task_count, waiters_woken.val);
+		if (args->lock) {
+			info("Calling FUTEX_LOCK_PI on mutex=%x @ %p\n",
+				f2, &f2);
+			futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+		}
+		info("Waker: Calling signal\n");
+		/* cond_signal */
+		old_val = f1;
+		args->ret = futex_cmp_requeue_pi(&f1, old_val, &f2,
+						 nr_wake, nr_requeue,
+						 FUTEX_PRIVATE_FLAG);
+		if (args->ret < 0)
+			args->ret = -errno;
+		info("futex: %x\n", f2);
+		if (args->lock) {
+			info("Calling FUTEX_UNLOCK_PI on mutex=%x @ %p\n",
+				f2, &f2);
+			futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+		}
+		info("futex: %x\n", f2);
+		if (args->ret < 0) {
+			error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
+			args->ret = RET_ERROR;
+			break;
+		}
+
+		task_count += args->ret;
+		usleep(SIGNAL_PERIOD_US);
+		i++;
+		/* we have to loop at least THREAD_MAX times */
+		if (i > MAX_WAKE_ITERS + THREAD_MAX) {
+			error("max signaling iterations (%d) reached, giving" \
+				" up on pending waiters.\n",
+				0, MAX_WAKE_ITERS + THREAD_MAX);
+			args->ret = RET_ERROR;
+			break;
+		}
+	}
+
+	futex_wake(&wake_complete, 1, FUTEX_PRIVATE_FLAG);
+
+	if (args->ret >= 0)
+		args->ret = task_count;
+
+	info("Waker: exiting with %d\n", args->ret);
+	info("Waker: waiters_woken: %d\n", waiters_woken.val);
+	pthread_exit((void *)&args->ret);
+}
+
+static void *third_party_blocker(void *arg)
+{
+	struct thread_arg *args = (struct thread_arg *)arg;
+	int ret2 = 0;
+
+	args->ret = futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+	if (args->ret)
+		goto out;
+	args->ret = futex_wait(&wake_complete, wake_complete, NULL,
+			       FUTEX_PRIVATE_FLAG);
+	ret2 = futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+
+ out:
+	if (args->ret || ret2) {
+		error("third_party_blocker() futex error", 0);
+		args->ret = RET_ERROR;
+	}
+
+	pthread_exit((void *)&args->ret);
+}
+
+int main(int argc, char *argv[])
+{
+	int c, i, ret = RET_PASS;
+	void *(*wakerfn)(void *) = signal_wakerfn;
+	struct thread_arg blocker_arg = THREAD_ARG_INITIALIZER;
+	struct thread_arg waker_arg = THREAD_ARG_INITIALIZER;
+	pthread_t waiter[THREAD_MAX], waker, blocker;
+	struct timespec ts, *tsp = NULL;
+	struct thread_arg args[THREAD_MAX];
+	int *waiter_ret;
+
+	/* Test option defaults */
+	long timeout_ns = 0;
+	int broadcast = 0;
+	int owner = 0;
+	int locked = 0;
+
+
+	while ((c = getopt(argc, argv, "bchlot:v:")) != -1) {
+		switch (c) {
+		case 'b':
+			broadcast = 1;
+			break;
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'l':
+			locked = 1;
+			break;
+		case 'o':
+			owner = 1;
+			locked = 0;
+			break;
+		case 't':
+			timeout_ns = atoi(optarg);
+			break;
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test requeue functionality\n", basename(argv[0]));
+	printf("\tArguments: broadcast=%d locked=%d owner=%d timeout=%ldns\n",
+	       broadcast, locked, owner, timeout_ns);
+
+	if (timeout_ns) {
+		info("timeout_ns = %ld\n", timeout_ns);
+		ret = clock_gettime(CLOCK_MONOTONIC, &ts);
+		time_t secs = (ts.tv_nsec + timeout_ns) / 1000000000;
+		ts.tv_nsec = ((int64_t)ts.tv_nsec + timeout_ns) % 1000000000;
+		ts.tv_sec += secs;
+		info("ts.tv_sec  = %ld\n", ts.tv_sec);
+		info("ts.tv_nsec = %ld\n", ts.tv_nsec);
+		tsp = &ts;
+	}
+
+	if (broadcast)
+		wakerfn = broadcast_wakerfn;
+
+	if (owner) {
+		if (create_rt_thread(&blocker, third_party_blocker,
+				     (void *)&blocker_arg, SCHED_FIFO, 1)) {
+			error("Creating third party blocker thread failed\n",
+			      errno);
+			ret = RET_ERROR;
+			goto out;
+		}
+	}
+
+	atomic_set(&waiters_woken, 0);
+	for (i = 0; i < THREAD_MAX; i++) {
+		args[i].id = i;
+		args[i].timeout = tsp;
+		info("Starting thread %d\n", i);
+		if (create_rt_thread(&waiter[i], waiterfn, (void *)&args[i],
+				     SCHED_FIFO, 1)) {
+			error("Creating waiting thread failed\n", errno);
+			ret = RET_ERROR;
+			goto out;
+		}
+	}
+	waker_arg.lock = locked;
+	if (create_rt_thread(&waker, wakerfn, (void *)&waker_arg,
+				    SCHED_FIFO, 1)) {
+		error("Creating waker thread failed\n", errno);
+		ret = RET_ERROR;
+		goto out;
+	}
+
+	/* Wait for threads to finish */
+	/* Store the first error or failure encountered in waiter_ret */
+	waiter_ret = &args[0].ret;
+	for (i = 0; i < THREAD_MAX; i++) {
+		pthread_join(waiter[i], *waiter_ret ?
+			NULL : (void **)&waiter_ret);
+	}
+
+	if (owner)
+		pthread_join(blocker, NULL);
+	pthread_join(waker, NULL);
+
+out:
+	if (!ret) {
+		if (*waiter_ret)
+			ret = *waiter_ret;
+		else if (waker_arg.ret < 0)
+			ret = waker_arg.ret;
+		else if (blocker_arg.ret)
+			ret = blocker_arg.ret;
+	}
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/futex_requeue_pi_mismatched_ops.c b/tools/testing/selftests/futex/futex_requeue_pi_mismatched_ops.c
new file mode 100644
index 0000000..1721c87
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_requeue_pi_mismatched_ops.c
@@ -0,0 +1,151 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futex_requeue_pi_mismatched_ops.c
+ *
+ * DESCRIPTION
+ *      1. Block a thread using FUTEX_WAIT
+ *      2. Attempt to use FUTEX_CMP_REQUEUE_PI on the futex from 1.
+ *      3. The kernel must detect the mismatch and return -EINVAL.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-9: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *      2012-Oct-14:
+ *       ported to tools/testing by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ *****************************************************************************/
+
+#include <errno.h>
+#include <getopt.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+
+#include "futex.h"
+#include "logging.h"
+
+static futex_t f1 = FUTEX_INITIALIZER;
+static futex_t f2 = FUTEX_INITIALIZER;
+static int child_ret;
+
+static void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+static void *blocking_child(void *arg)
+{
+	child_ret = futex_wait(&f1, f1, NULL, FUTEX_PRIVATE_FLAG);
+	if (child_ret < 0) {
+		child_ret = -errno;
+		error("futex_wait\n", errno);
+	}
+	return (void *)&child_ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret = RET_PASS;
+	pthread_t child;
+	int c;
+
+	while ((c = getopt(argc, argv, "chv:")) != -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Detect mismatched requeue_pi operations\n",
+	       basename(argv[0]));
+
+	if (pthread_create(&child, NULL, blocking_child, NULL)) {
+		error("pthread_create\n", errno);
+		ret = RET_ERROR;
+		goto out;
+	}
+	/* Allow the child to block in the kernel. */
+	sleep(1);
+
+	/*
+	 * The kernel should detect the waiter did not setup the
+	 * q->requeue_pi_key and return -EINVAL. If it does not,
+	 * it likely gave the lock to the child, which is now hung
+	 * in the kernel.
+	 */
+	ret = futex_cmp_requeue_pi(&f1, f1, &f2, 1, 0, FUTEX_PRIVATE_FLAG);
+	if (ret < 0) {
+		if (errno == EINVAL) {
+			/*
+			 * The kernel correctly detected the mismatched
+			 * requeue_pi target and aborted. Wake the child with
+			 * FUTEX_WAKE.
+			 */
+			ret = futex_wake(&f1, 1, FUTEX_PRIVATE_FLAG);
+			if (ret == 1)
+				ret = RET_PASS;
+			else if (ret < 0) {
+				error("futex_wake\n", errno);
+				ret = RET_ERROR;
+			} else {
+				error("futex_wake did not wake the child\n", 0);
+				ret = RET_ERROR;
+			}
+		} else {
+			error("futex_cmp_requeue_pi\n", errno);
+			ret = RET_ERROR;
+		}
+	} else if (ret > 0) {
+		fail("futex_cmp_requeue_pi failed to detect the mismatch\n");
+		ret = RET_FAIL;
+	} else {
+		error("futex_cmp_requeue_pi found no waiters\n", 0);
+		ret = RET_ERROR;
+	}
+
+	pthread_join(child, NULL);
+
+	if (!ret)
+		ret = child_ret;
+
+
+ out:
+	/* If the kernel crashes, we shouldn't return at all. */
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/futex_requeue_pi_signal_restart.c b/tools/testing/selftests/futex/futex_requeue_pi_signal_restart.c
new file mode 100644
index 0000000..1451cc7
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_requeue_pi_signal_restart.c
@@ -0,0 +1,202 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2006-2008
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      requeue_pi_sig_restart.c
+ *
+ * DESCRIPTION
+ *      This test exercises the futex_wait_requeue_pi() signal handling both
+ *      before and after the requeue. The first should be restarted by the
+ *      kernel. The latter should return EWOULDBLOCK to the waiter.
+ *
+ * AUTHORS
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2008-May-5: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *      2012-Oct-14:
+ *       ported to tools/testing by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ *****************************************************************************/
+
+#include <errno.h>
+#include <getopt.h>
+#include <limits.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "atomic.h"
+
+#include "futex.h"
+#include "logging.h"
+#include "futex_testing_common.h"
+
+#define DELAY_US 100
+
+static futex_t f1 = FUTEX_INITIALIZER;
+static futex_t f2 = FUTEX_INITIALIZER;
+static atomic_t requeued = ATOMIC_INITIALIZER;
+
+static int waiter_ret;
+
+static void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+static void handle_signal(int signo)
+{
+	info("signal received %s requeue\n",
+	     requeued.val ? "after" : "prior to");
+}
+
+static void *waiterfn(void *arg)
+{
+	unsigned int old_val;
+	int res;
+	waiter_ret = RET_PASS;
+
+	info("Waiter running\n");
+	info("Calling FUTEX_LOCK_PI on f2=%x @ %p\n", f2, &f2);
+	old_val = f1;
+	res = futex_wait_requeue_pi(&f1, old_val, &(f2), NULL,
+				FUTEX_PRIVATE_FLAG);
+
+	if (!requeued.val || errno != EWOULDBLOCK) {
+		fail("unexpected return from futex_wait_requeue_pi: %d (%s)\n",
+		     res, strerror(errno));
+		info("w2:futex: %x\n", f2);
+		if (!res)
+			futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+		waiter_ret = RET_FAIL;
+	}
+
+	info("Waiter exiting with %d\n", waiter_ret);
+	pthread_exit(NULL);
+}
+
+
+int main(int argc, char *argv[])
+{
+	unsigned int old_val;
+	struct sigaction sa;
+	pthread_t waiter;
+	int c, res, ret = RET_PASS;
+
+	while ((c = getopt(argc, argv, "chv:")) != -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test signal handling during requeue_pi\n",
+		basename(argv[0]));
+	printf("\tArguments: <none>\n");
+
+	sa.sa_handler = handle_signal;
+	sigemptyset(&sa.sa_mask);
+	sa.sa_flags = 0;
+	if (sigaction(SIGUSR1, &sa, NULL)) {
+		error("sigaction\n", errno);
+		exit(1);
+	}
+
+	info("m1:f2: %x\n", f2);
+	info("Creating waiter\n");
+	res = create_rt_thread(&waiter, waiterfn, NULL, SCHED_FIFO, 1);
+	if (ret) {
+		error("Creating waiting thread failed", res);
+		ret = RET_ERROR;
+		goto out;
+	}
+
+	info("Calling FUTEX_LOCK_PI on f2=%x @ %p\n", f2, &f2);
+	info("m2:f2: %x\n", f2);
+	futex_lock_pi(&f2, 0, 0, FUTEX_PRIVATE_FLAG);
+	info("m3:f2: %x\n", f2);
+
+	while (1) {
+		/*
+		 * signal the waiter before requeue, waiter should automatically
+		 * restart futex_wait_requeue_pi() in the kernel. Wait for the
+		 * waiter to block on f1 again.
+		 */
+		info("Issuing SIGUSR1 to waiter\n");
+		pthread_kill(waiter, SIGUSR1);
+		usleep(DELAY_US);
+
+		info("Requeueing waiter via FUTEX_CMP_REQUEUE_PI\n");
+		old_val = f1;
+		res = futex_cmp_requeue_pi(&f1, old_val, &(f2), 1, 0,
+					   FUTEX_PRIVATE_FLAG);
+		/*
+		 * If res is non-zero, we either requeued the waiter or hit an
+		 * error, break out and handle it. If it is zero, then the
+		 * signal may have hit before the the waiter was blocked on f1.
+		 * Try again.
+		 */
+		if (res > 0) {
+			atomic_set(&requeued, 1);
+			break;
+		} else if (res > 0) {
+			error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
+			ret = RET_ERROR;
+			break;
+		}
+	}
+	info("m4:f2: %x\n", f2);
+
+	/*
+	 * Signal the waiter after requeue, waiter should return from
+	 * futex_wait_requeue_pi() with EWOULDBLOCK. Join the thread here so the
+	 * futex_unlock_pi() can't happen before the signal wakeup is detected
+	 * in the kernel.
+	 */
+	info("Issuing SIGUSR1 to waiter\n");
+	pthread_kill(waiter, SIGUSR1);
+	info("Waiting for waiter to return\n");
+	pthread_join(waiter, NULL);
+
+	info("Calling FUTEX_UNLOCK_PI on mutex=%x @ %p\n", f2, &f2);
+	futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+	info("m5:f2: %x\n", f2);
+
+ out:
+	if (ret == RET_PASS && waiter_ret)
+		ret = waiter_ret;
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/futex_testing_common.c b/tools/testing/selftests/futex/futex_testing_common.c
new file mode 100644
index 0000000..3a89d92
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_testing_common.c
@@ -0,0 +1,45 @@
+
+#include "futex_testing_common.h"
+#include "logging.h"
+
+#include <pthread.h>
+#include <string.h>
+
+int create_rt_thread(pthread_t *pth, void *(*func)(void *), void *arg,
+		int policy, int prio)
+{
+	int ret;
+	struct sched_param schedp;
+	pthread_attr_t attr;
+
+	pthread_attr_init(&attr);
+	memset(&schedp, 0, sizeof(schedp));
+
+	ret = pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
+	if (ret) {
+		error("pthread_attr_setinheritsched\n", ret);
+		return -1;
+	}
+
+	ret = pthread_attr_setschedpolicy(&attr, policy);
+	if (ret) {
+		error("pthread_attr_setschedpolicy\n", ret);
+		return -1;
+	}
+
+	schedp.sched_priority = prio;
+	ret = pthread_attr_setschedparam(&attr, &schedp);
+	if (ret) {
+		error("pthread_attr_setschedparam\n", ret);
+		return -1;
+	}
+
+	ret = pthread_create(pth, &attr, func, arg);
+	if (ret) {
+		error("pthread_create\n", ret);
+		return -1;
+	}
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/futex/futex_testing_common.h b/tools/testing/selftests/futex/futex_testing_common.h
new file mode 100644
index 0000000..86c49fb
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_testing_common.h
@@ -0,0 +1,9 @@
+
+#ifndef FUTEX_TESTING_COMMON_H
+#define FUTEX_TESTING_COMMON_H
+
+#include <pthread.h>
+
+int create_rt_thread(pthread_t *pth, void *(*func)(void *), void *arg, int policy, int prio);
+
+#endif	/* FUTEX_TESTING_COMMON_H */
diff --git a/tools/testing/selftests/futex/futex_wait_private_mapped_file.c b/tools/testing/selftests/futex/futex_wait_private_mapped_file.c
new file mode 100644
index 0000000..83f2727
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_wait_private_mapped_file.c
@@ -0,0 +1,137 @@
+/******************************************************************************
+ *
+ * Copyright FUJITSU LIMITED 2010
+ * Copyright KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futex_wait_private_mapped_file.c
+ *
+ * DESCRIPTION
+ *	Internally, Futex has two handling mode, anon and file. The private file
+ *	mapping is special. At first it behave as file, but after write anything
+ *	it behave as anon. This test is intent to test such case.
+ *
+ * AUTHOR
+ *      KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *
+ * HISTORY
+ *      2010-Jan-6:
+ *      Initial version by KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *      2012-Oct-14:
+ *       ported to tools/testing by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ *****************************************************************************/
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/futex.h>
+#include <pthread.h>
+#include <libgen.h>
+#include <signal.h>
+
+#include "logging.h"
+#include "futex.h"
+
+#define PAGE_SZ 4096
+
+static futex_t val = 1;
+
+#define WAKE_WAIT_US 3000000
+static struct timespec wait_timeout = { .tv_sec = 5, .tv_nsec = 0 };
+
+static void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+static void *thr_futex_wait(void *arg)
+{
+	int ret;
+
+	info("futex wait\n");
+	ret = futex_wait(&val, 1, &wait_timeout, 0);
+	if (ret && errno != EWOULDBLOCK && errno != ETIMEDOUT) {
+		error("futex error.\n", errno);
+		print_result(RET_ERROR);
+		exit(RET_ERROR);
+	}
+	if (ret && errno == ETIMEDOUT)
+		fail("waiter timedout\n");
+
+	info("futex_wait: ret = %d, errno = %d\n", ret, errno);
+
+	return NULL;
+}
+
+int main(int argc, char **argv)
+{
+	pthread_t thr;
+	int ret = RET_PASS;
+	int res;
+	int c;
+
+	while ((c = getopt(argc, argv, "chv:")) != -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test the futex value of private file mappings in "	\
+		"FUTEX_WAIT\n", basename(argv[0]));
+
+	ret = pthread_create(&thr, NULL, thr_futex_wait, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "pthread_create error\n");
+		ret = RET_ERROR;
+		goto out;
+	}
+
+	info("wait a while\n");
+	usleep(WAKE_WAIT_US);
+	val = 2;
+	res = futex_wake(&val, 1, 0);
+	info("futex_wake %d\n", res);
+	if (res != 1) {
+		fail("FUTEX_WAKE didn't find the waiting thread.\n");
+		ret = RET_FAIL;
+	}
+
+	info("join\n");
+	pthread_join(thr, NULL);
+
+ out:
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/futex_wait_timeout.c b/tools/testing/selftests/futex/futex_wait_timeout.c
new file mode 100644
index 0000000..63de776
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_wait_timeout.c
@@ -0,0 +1,101 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futex_wait.c
+ *
+ * DESCRIPTION
+ *      Block on a futex and wait for timeout.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-6: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *      2012-Oct-14:
+ *       ported to tools/testing by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ *****************************************************************************/
+
+#include <errno.h>
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+
+#include "futex.h"
+#include "logging.h"
+
+static long timeout_ns = 100000;	/* 100us default timeout */
+
+static void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -t N	Timeout in nanoseconds (default: 100,000)\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+int main(int argc, char *argv[])
+{
+	futex_t f1 = FUTEX_INITIALIZER;
+	struct timespec to;
+	int res, ret = RET_PASS;
+	int c;
+
+	while ((c = getopt(argc, argv, "cht:v:")) != -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 't':
+			timeout_ns = atoi(optarg);
+			break;
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Block on a futex and wait for timeout\n",
+		basename(argv[0]));
+	printf("\tArguments: timeout=%ldns\n", timeout_ns);
+
+	/* initialize timeout */
+	to.tv_sec = 0;
+	to.tv_nsec = timeout_ns;
+
+	info("Calling futex_wait on f1: %u @ %p\n", f1, &f1);
+	res = futex_wait(&f1, f1, &to, FUTEX_PRIVATE_FLAG);
+	if (!res || errno != ETIMEDOUT) {
+		fail("futex_wait returned %d\n", ret < 0 ? errno : ret);
+		ret = RET_FAIL;
+	}
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/futex_wait_uninitialized_heap.c b/tools/testing/selftests/futex/futex_wait_uninitialized_heap.c
new file mode 100644
index 0000000..2c69861
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_wait_uninitialized_heap.c
@@ -0,0 +1,139 @@
+/******************************************************************************
+ *
+ * Copyright FUJITSU LIMITED 2010
+ * Copyright KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futex_wait_uninitialized_heap.c
+ *
+ * DESCRIPTION
+ *      Wait on uninitialized heap. It shold be zero and FUTEX_WAIT should
+ *      return immediately. This test is intent to test zero page handling in
+ *      futex.
+ *
+ * AUTHOR
+ *      KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *
+ * HISTORY
+ *      2010-Jan-6:
+ *       Initial version by KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *      2012-Oct-14:
+ *       ported to tools/testing by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ *****************************************************************************/
+
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <syscall.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/futex.h>
+#include <libgen.h>
+
+#include "logging.h"
+#include "futex.h"
+
+#define WAIT_US 5000000
+
+static int child_blocked = 1;
+static int child_ret;
+static void *buf;
+
+static void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+static void *wait_thread(void *arg)
+{
+	int res;
+	child_ret = RET_PASS;
+	res = futex_wait(buf, 1, NULL, 0);
+	child_blocked = 0;
+
+	if (res != 0 && errno != EWOULDBLOCK) {
+		error("futex failure\n", errno);
+		child_ret = RET_ERROR;
+	}
+	pthread_exit(NULL);
+}
+
+int main(int argc, char **argv)
+{
+	int c, ret = RET_PASS;
+	long page_size;
+	pthread_t thr;
+
+	while ((c = getopt(argc, argv, "chv:")) != -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	page_size = sysconf(_SC_PAGESIZE);
+
+	buf = mmap(NULL, page_size, PROT_READ|PROT_WRITE,
+		   MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
+	if (buf == (void *)-1) {
+		error("mmap\n", errno);
+		exit(1);
+	}
+
+	printf("%s: Test the uninitialized futex value in FUTEX_WAIT\n",
+	       basename(argv[0]));
+
+
+	ret = pthread_create(&thr, NULL, wait_thread, NULL);
+	if (ret) {
+		error("pthread_create\n", errno);
+		ret = RET_ERROR;
+		goto out;
+	}
+
+	info("waiting %dus for child to return\n", WAIT_US);
+	usleep(WAIT_US);
+
+	if (child_blocked) {
+		fail("child blocked in kernel\n");
+		ret = RET_FAIL;
+	} else {
+		ret = child_ret;
+	}
+
+ out:
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/futex_wait_wouldblock.c b/tools/testing/selftests/futex/futex_wait_wouldblock.c
new file mode 100644
index 0000000..63f6d11
--- /dev/null
+++ b/tools/testing/selftests/futex/futex_wait_wouldblock.c
@@ -0,0 +1,94 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futex_wait_wouldblock.c
+ *
+ * DESCRIPTION
+ *      Test if FUTEX_WAIT op returns -EWOULDBLOCK if the futex value differs
+ *      from the expected one.
+ *
+ * AUTHOR
+ *      Gowrishankar <gowrishankar.m@in.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-14: Initial version by Gowrishankar <gowrishankar.m@in.ibm.com>
+ *      2012-Oct-14:
+ *       ported to tools/testing by Hitoshi Mitake <h.mitake@gmail.com>
+ *
+ *****************************************************************************/
+
+#include <errno.h>
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+
+#include "futex.h"
+#include "logging.h"
+
+#define timeout_ns 100000
+
+static void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+int main(int argc, char *argv[])
+{
+	struct timespec to = {.tv_sec = 0, .tv_nsec = timeout_ns};
+	futex_t f1 = FUTEX_INITIALIZER;
+	int res, ret = RET_PASS;
+	int c;
+
+	while ((c = getopt(argc, argv, "cht:v:")) != -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test the unexpected futex value in FUTEX_WAIT\n",
+	       basename(argv[0]));
+
+	info("Calling futex_wait on f1: %u @ %p with val=%u\n", f1, &f1, f1+1);
+	res = futex_wait(&f1, f1+1, &to, FUTEX_PRIVATE_FLAG);
+	if (!res || errno != EWOULDBLOCK) {
+		fail("futex_wait returned: %d %s\n",
+		     res ? errno : res, res ? strerror(errno) : "");
+		ret = RET_FAIL;
+	}
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/logging.c b/tools/testing/selftests/futex/logging.c
new file mode 100644
index 0000000..c207299
--- /dev/null
+++ b/tools/testing/selftests/futex/logging.c
@@ -0,0 +1,93 @@
+
+#include "logging.h"
+
+/*
+ * Define PASS, ERROR, and FAIL strings with and without color escape
+ * sequences, default to no color.
+ */
+#define ESC 0x1B, '['
+#define BRIGHT '1'
+#define GREEN '3', '2'
+#define YELLOW '3', '3'
+#define RED '3', '1'
+#define ESCEND 'm'
+#define BRIGHT_GREEN ESC, BRIGHT, ';', GREEN, ESCEND
+#define BRIGHT_YELLOW ESC, BRIGHT, ';', YELLOW, ESCEND
+#define BRIGHT_RED ESC, BRIGHT, ';', RED, ESCEND
+#define RESET_COLOR ESC, '0', 'm'
+
+static const char PASS_COLOR[] = {
+	BRIGHT_GREEN, ' ', 'P', 'A', 'S', 'S', RESET_COLOR, 0 };
+static const char ERROR_COLOR[] = {
+	BRIGHT_YELLOW, 'E', 'R', 'R', 'O', 'R', RESET_COLOR, 0 };
+static const char FAIL_COLOR[] = {
+	BRIGHT_RED, ' ', 'F', 'A', 'I', 'L', RESET_COLOR, 0 };
+
+static const char INFO_NORMAL[] = " INFO";
+static const char PASS_NORMAL[] = " PASS";
+static const char ERROR_NORMAL[] = "ERROR";
+static const char FAIL_NORMAL[] = " FAIL";
+
+const char *INFO = INFO_NORMAL;
+const char *PASS = PASS_NORMAL;
+const char *ERROR = ERROR_NORMAL;
+const char *FAIL = FAIL_NORMAL;
+
+int _verbose = VCRITICAL;
+
+/**
+ * log_color() - Use colored output for PASS, ERROR, and FAIL strings
+ * @use_color:	use color (1) or not (0)
+ */
+void log_color(int use_color)
+{
+	if (use_color) {
+		PASS = PASS_COLOR;
+		ERROR = ERROR_COLOR;
+		FAIL = FAIL_COLOR;
+	} else {
+		PASS = PASS_NORMAL;
+		ERROR = ERROR_NORMAL;
+		FAIL = FAIL_NORMAL;
+	}
+}
+
+/**
+ * log_verbosity() - Set verbosity of test output
+ * @verbose:	Enable (1) verbose output or not (0)
+ *
+ * Currently setting verbose=1 will enable INFO messages and 0 will disable
+ * them. FAIL and ERROR messages are always displayed.
+ */
+void log_verbosity(int level)
+{
+	if (level > VMAX)
+		level = VMAX;
+	else if (level < 0)
+		level = 0;
+	_verbose = level;
+}
+
+/**
+ * print_result() - Print standard PASS | ERROR | FAIL results
+ * @ret:	the return value to be considered: 0 | RET_ERROR | RET_FAIL
+ *
+ * print_result() is primarily intended for functional tests.
+ */
+void print_result(int ret)
+{
+	const char *result = "Unknown return code";
+	switch (ret) {
+	case RET_PASS:
+		result = PASS;
+		break;
+	case RET_ERROR:
+		result = ERROR;
+		break;
+	case RET_FAIL:
+		result = FAIL;
+		break;
+	}
+	printf("Result: %s\n", result);
+}
+
diff --git a/tools/testing/selftests/futex/logging.h b/tools/testing/selftests/futex/logging.h
new file mode 100644
index 0000000..2d5f975
--- /dev/null
+++ b/tools/testing/selftests/futex/logging.h
@@ -0,0 +1,88 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      logging.h
+ *
+ * DESCRIPTION
+ *      Glibc independent futex library for testing kernel functionality.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-6: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *
+ *****************************************************************************/
+
+#ifndef _LOGGING_H
+#define _LOGGING_H
+
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/futex.h>
+
+/* Verbosity setting for INFO messages */
+#define VQUIET    0
+#define VCRITICAL 1
+#define VINFO     2
+#define VMAX      VINFO
+
+/* Functional test return codes */
+#define RET_PASS   0
+#define RET_ERROR -1
+#define RET_FAIL  -2
+
+void log_color(int use_color);
+void log_verbosity(int level);
+void print_result(int ret);
+
+extern int _verbose;
+
+extern const char *INFO;
+extern const char *PASS;
+extern const char *ERROR;
+extern const char *FAIL;
+
+/* log level macros */
+#define info(message, vargs...)						\
+	do {								\
+		if (_verbose >= VINFO)					\
+			fprintf(stderr, "\t%s: "message, INFO, ##vargs); \
+	} while (0)
+
+#define error(message, err, args...)					\
+	do {								\
+		if (_verbose >= VCRITICAL) {				\
+			if (err)					\
+				fprintf(stderr, "\t%s: %s: "message,	\
+					ERROR, strerror(err), ##args);	\
+			else						\
+				fprintf(stderr, "\t%s: "message,	\
+					ERROR, ##args);			\
+		}							\
+	} while (0)
+
+#define fail(message, args...)						\
+	do {								\
+		if (_verbose >= VCRITICAL)				\
+			fprintf(stderr, "\t%s: "message, FAIL, ##args); \
+	} while (0)
+
+#endif
diff --git a/tools/testing/selftests/futex/run.sh b/tools/testing/selftests/futex/run.sh
new file mode 100755
index 0000000..4440dbd
--- /dev/null
+++ b/tools/testing/selftests/futex/run.sh
@@ -0,0 +1,92 @@
+#!/bin/sh
+
+###############################################################################
+#
+#   Copyright © International Business Machines  Corp., 2009
+#
+#   This program is free software;  you can redistribute it and/or modify
+#   it under the terms of the GNU General Public License as published by
+#   the Free Software Foundation; either version 2 of the License, or
+#   (at your option) any later version.
+#
+#   This program is distributed in the hope that it will be useful,
+#   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+#   the GNU General Public License for more details.
+#
+#   You should have received a copy of the GNU General Public License
+#   along with this program;  if not, write to the Free Software
+#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+#
+# NAME
+#      run.sh
+#
+# DESCRIPTION
+#      Run tests in the current directory.
+#
+# AUTHOR
+#      Darren Hart <dvhltc@us.ibm.com>
+#
+# HISTORY
+#      2009-Nov-9: Initial version by Darren Hart <dvhltc@us.ibm.com>
+#      2010-Jan-6: Add futex_wait_uninitialized_heap and
+#                  futex_wait_private_mapped_file
+#                  by KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+#
+###############################################################################
+
+# Test for a color capable console
+if [ -z "$USE_COLOR" ]; then
+    tput setf 7
+    if [ $? -eq 0 ]; then
+        USE_COLOR=1
+        tput sgr0
+    fi
+fi
+if [ "$USE_COLOR" -eq 1 ]; then
+    COLOR="-c"
+fi
+
+
+echo
+# requeue pi testing
+# without timeouts
+./futex_requeue_pi $COLOR
+./futex_requeue_pi $COLOR -b
+./futex_requeue_pi $COLOR -b -l
+./futex_requeue_pi $COLOR -b -o
+./futex_requeue_pi $COLOR -l
+./futex_requeue_pi $COLOR -o
+# with timeouts
+./futex_requeue_pi $COLOR -b -l -t 5000
+./futex_requeue_pi $COLOR -l -t 5000
+./futex_requeue_pi $COLOR -b -l -t 500000
+./futex_requeue_pi $COLOR -l -t 500000
+./futex_requeue_pi $COLOR -b -t 5000
+./futex_requeue_pi $COLOR -t 5000
+./futex_requeue_pi $COLOR -b -t 500000
+./futex_requeue_pi $COLOR -t 500000
+./futex_requeue_pi $COLOR -b -o -t 5000
+./futex_requeue_pi $COLOR -l -t 5000
+./futex_requeue_pi $COLOR -b -o -t 500000
+./futex_requeue_pi $COLOR -l -t 500000
+# with long timeout
+./futex_requeue_pi $COLOR -b -l -t 2000000000
+./futex_requeue_pi $COLOR -l -t 2000000000
+
+
+echo
+./futex_requeue_pi_mismatched_ops $COLOR
+
+echo
+./futex_requeue_pi_signal_restart $COLOR
+
+echo
+./futex_wait_timeout $COLOR
+
+echo
+./futex_wait_wouldblock $COLOR
+
+echo
+./futex_wait_uninitialized_heap $COLOR
+./futex_wait_private_mapped_file $COLOR
-- 
1.7.5.1

