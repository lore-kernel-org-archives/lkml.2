Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1ACOgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:36:07 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53287 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab1ACOgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:36:05 -0500
Subject: [RFC][PATCH] sembench: add stddev to the burn stats
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101224123743.303699501@chello.nl>
References: <20101224122338.172750730@chello.nl>
	 <20101224123743.303699501@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 15:36:10 +0100
Message-ID: <1294065370.2016.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 13:23 +0100, Peter Zijlstra wrote:
> As measured using: http://oss.oracle.com/~mason/sembench.c
> 
> $ echo 4096 32000 64 128 > /proc/sys/kernel/sem
> $ ./sembench -t 2048 -w 1900 -o 0
> 
> unpatched: run time 30 seconds 537953 worker burns per second
> patched:   run time 30 seconds 657336 worker burns per second
> 
> Still need to sort out all the races marked XXX (non-trivial), and its
> x86 only for the moment.


---

Adds stats to see how stable the sembench results are, it does slow the
burn rate down, I guess because we're now touching the FPU and the
context switch overhead increases dramatically, but it does show its
relatively stable.

New output looks like:

# ./sembench -t 2048 -w 1900 -o 0 -r 30
main loop going
all done
2048 threads, waking 1900 at a time
using ipc sem operations
main thread burns: 2374
worker burn count total 4510600 min 1187 max 2374 avg 2202.441 +- 0.415%
run time 30 seconds 150353 worker burns per second

---
--- sembench.c	2010-04-12 20:45:50.000000000 +0200
+++ sembench3.c	2011-01-03 15:29:42.000000000 +0100
@@ -1,6 +1,6 @@
 /*
  * copyright Oracle 2007.  Licensed under GPLv2
- * To compile: gcc -Wall -o sembench sembench.c -lpthread
+ * To compile: gcc -Wall -o sembench sembench.c -lpthread -lm
  *
  * usage: sembench -t thread count -w wakenum -r runtime -o op
  * op can be: 0 (ipc sem) 1 (nanosleep) 2 (futexes)
@@ -28,8 +28,9 @@
 #include <sys/time.h>
 #include <sys/syscall.h>
 #include <errno.h>
+#include <math.h>
 
-#define VERSION "0.2"
+#define VERSION "0.3"
 
 /* futexes have been around since 2.5.something, but it still seems I
  * need to make my own syscall.  Sigh.
@@ -78,10 +79,55 @@
 
 int *semid_lookup = NULL;
 
+struct stats
+{
+	double n, mean, M2;
+};
+
+static void update_stats(struct stats *stats, long long val)
+{
+	double delta;
+
+	stats->n++;
+	delta = val - stats->mean;
+	stats->mean += delta / stats->n;
+	stats->M2 += delta*(val - stats->mean);
+}
+
+static double avg_stats(struct stats *stats)
+{
+	return stats->mean;
+}
+
+/*
+ * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
+ *
+ *       (\Sum n_i^2) - ((\Sum n_i)^2)/n
+ * s^2 = -------------------------------
+ *                  n - 1
+ *
+ * http://en.wikipedia.org/wiki/Stddev
+ *
+ * The std dev of the mean is related to the std dev by:
+ *
+ *             s
+ * s_mean = -------
+ *          sqrt(n)
+ *
+ */
+static double stddev_stats(struct stats *stats)
+{
+	double variance = stats->M2 / (stats->n - 1);
+	double variance_mean = variance / stats->n;
+
+	return sqrt(variance_mean);
+}
+
 pthread_mutex_t worklist_mutex = PTHREAD_MUTEX_INITIALIZER;
 static unsigned long total_burns = 0;
 static unsigned long min_burns = ~0UL;
 static unsigned long max_burns = 0;
+static struct stats burn_stats;
 static int thread_count = 0;
 struct lockinfo *worklist_head = NULL;
 struct lockinfo *worklist_tail = NULL;
@@ -385,6 +431,7 @@
 		min_burns = burn_count;
 	if (burn_count > max_burns)
 		max_burns = burn_count;
+	update_stats(&burn_stats, burn_count);
 	thread_count--;
 	pthread_mutex_unlock(&worklist_mutex);
 	return (void *)0;
@@ -508,8 +555,9 @@
 	printf("%d threads, waking %d at a time\n", num_threads, wake_num);
 	printf("using %s\n", ops->name);
 	printf("main thread burns: %d\n", burn_count);
-	printf("worker burn count total %lu min %lu max %lu avg %lu\n",
-	       total_burns, min_burns, max_burns, total_burns / num_threads);
+	printf("worker burn count total %lu min %lu max %lu avg %.3f +- %.3f%%\n",
+	       total_burns, min_burns, max_burns, avg_stats(&burn_stats),
+	       100 * stddev_stats(&burn_stats) / avg_stats(&burn_stats));
 	printf("run time %d seconds %lu worker burns per second\n",
 		(int)(now.tv_sec - start.tv_sec),
 		total_burns / (now.tv_sec - start.tv_sec));

