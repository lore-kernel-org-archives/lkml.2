Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0IKRkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 13:40:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:33631 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0IKRki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 13:40:38 -0400
Message-Id: <20100911174003.051303123@efficios.com>
User-Agent: quilt/0.48-1
Date: Sat, 11 Sep 2010 13:37:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>
Subject: [RFC patch 1/2] sched: dynamically adapt granularity with nr_running
References: <20100911173732.551632040@efficios.com>
Content-Disposition: inline; filename=sched-small-spread.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 11 Sep 2010 17:40:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the minimum granularity is a double-edged sword: if we set it to a too
small value, then the scheduler will preempt tasks too often. If it is too
large, then the "latency" period can grow very large as the number of running
tasks increases.

This patch leaves the same scheduling granularity when there are few tasks on
the system (3 or less), but dynamically adapts (shrinks) the sched granularity
when there are more. At a ceiling value of 8 running tasks (this choice is
arbitrary), it grows the latency rather than shrinking granularity further to
ensure we don't end up calling the scheduler too often.


(on a uniprocessor 2.0 GHz Pentium M)

* Without the patch:

 - wakeup-latency with SIGEV_THREAD in parallel with youtube video and
   make -j10

maximum latency: 50107.8 µs
average latency: 6609.2 µs
missed timer events: 0

 - wakeup-latency with SIGEV_SIGNAL in parallel with youtube video and
   make -j10

maximum latency: 8608.3 µs
average latency: 101.3 µs
missed timer events: 0


* With the patch

 - wakeup-latency with SIGEV_THREAD in parallel with youtube video and
   make -j10

maximum latency: 26367.4 µs
average latency: 5382.6 µs
missed timer events: 0

 - wakeup-latency with SIGEV_SIGNAL in parallel with youtube video and
   make -j10

maximum latency: 3030.4 µs
average latency: 129.3 µs
missed timer events: 0

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched_debug.c |    1 +
 kernel/sched_fair.c  |   39 +++++++++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 10 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -51,16 +51,23 @@ enum sched_tunable_scaling sysctl_sched_
 	= SCHED_TUNABLESCALING_LOG;
 
 /*
- * Minimal preemption granularity for CPU-bound tasks:
+ * Minimum preemption granularity (when number of tasks increases).
+ */
+unsigned int sysctl_sched_min_granularity = 750000ULL;
+unsigned int normalized_sysctl_sched_min_granularity = 750000ULL;
+
+/*
+ * Standard preemption granularity for CPU-bound tasks:
  * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 2000000ULL;
-unsigned int normalized_sysctl_sched_min_granularity = 2000000ULL;
+unsigned int sysctl_sched_std_granularity = 2000000ULL;
+unsigned int normalized_sysctl_sched_std_granularity = 2000000ULL;
 
 /*
- * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
+ * is kept at sysctl_sched_latency / sysctl_sched_std_granularity
  */
 static unsigned int sched_nr_latency = 3;
+static unsigned int sched_nr_latency_max = 8;
 
 /*
  * After fork, child runs first. If set to 0 (default) then
@@ -439,24 +446,36 @@ calc_delta_fair(unsigned long delta, str
 /*
  * The idea is to set a period in which each task runs once.
  *
- * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
- * this period because otherwise the slices get too small.
+ * When there are too many tasks (sysctl_sched_nr_latency) we have to shrink the
+ * slices, up to sysctl_sched_min_granularity.
  *
  * p = (nr <= nl) ? l : l*nr/nl
  */
 static u64 __sched_period(unsigned long nr_running)
 {
+	unsigned long nr_latency_max = sched_nr_latency_max;
 	u64 period = sysctl_sched_latency;
-	unsigned long nr_latency = sched_nr_latency;
 
-	if (unlikely(nr_running > nr_latency)) {
+	if (unlikely(nr_running > nr_latency_max)) {
 		period = sysctl_sched_min_granularity;
 		period *= nr_running;
 	}
-
 	return period;
 }
 
+static unsigned int __sched_gran(unsigned long nr_running)
+{
+	unsigned int gran = sysctl_sched_std_granularity;
+	unsigned long nr_latency = sched_nr_latency;
+
+	if (unlikely(nr_running > nr_latency)) {
+		gran = sysctl_sched_latency;
+		gran /= nr_running;
+		gran = max(gran, sysctl_sched_min_granularity);
+	}
+	return gran;
+}
+
 /*
  * We calculate the wall-time slice from the period by taking a part
  * proportional to the weight.
@@ -862,7 +881,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (delta_exec < sysctl_sched_min_granularity)
+	if (delta_exec < __sched_gran(cfs_rq->nr_running))
 		return;
 
 	if (cfs_rq->nr_running > 1) {
Index: linux-2.6-lttng.git/kernel/sched_debug.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_debug.c
+++ linux-2.6-lttng.git/kernel/sched_debug.c
@@ -331,6 +331,7 @@ static int sched_debug_show(struct seq_f
 	P(jiffies);
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
+	PN(sysctl_sched_std_granularity);
 	PN(sysctl_sched_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);

