Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1C3Vuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:50:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:48759 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933445Ab1C3VHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133193"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: venki@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [103/275] sched: Do not account irq time to current task
Message-Id: <20110330210542.1BF143E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: 305e6835e05513406fa12820e40e4a8ecb63743c upstream

Scheduler accounts both softirq and interrupt processing times to the
currently running task. This means, if the interrupt processing was
for some other task in the system, then the current task ends up being
penalized as it gets shorter runtime than otherwise.

Change sched task accounting to acoount only actual task time from
currently running task. Now update_curr(), modifies the delta_exec to
depend on rq->clock_task.

Note that this change only handles CONFIG_IRQ_TIME_ACCOUNTING case. We can
extend this to CONFIG_VIRT_CPU_ACCOUNTING with minimal effort. But, thats
for later.

This change will impact scheduling behavior in interrupt heavy conditions.

Tested on a 4-way system with eth0 handled by CPU 2 and a network heavy
task (nc) running on CPU 3 (and no RSS/RFS). With that I have CPU 2
spending 75%+ of its time in irq processing. CPU 3 spending around 35%
time running nc task.

Now, if I run another CPU intensive task on CPU 2, without this change
/proc/<pid>/schedstat shows 100% of time accounted to this task. With this
change, it rightly shows less than 25% accounted to this task as remaining
time is actually spent on irq processing.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1286237003-12406-7-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c      |   38 +++++++++++++++++++++++++++++++++++++-
 kernel/sched_fair.c |    6 +++---
 kernel/sched_rt.c   |    8 ++++----
 3 files changed, 44 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:03:00.273293178 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:54:59.406482364 -0700
@@ -491,6 +491,7 @@
 	struct mm_struct *prev_mm;
 
 	u64 clock;
+	u64 clock_task;
 
 	atomic_t nr_iowait;
 
@@ -641,10 +642,18 @@
 
 #endif /* CONFIG_CGROUP_SCHED */
 
+static u64 irq_time_cpu(int cpu);
+
 inline void update_rq_clock(struct rq *rq)
 {
+	int cpu = cpu_of(rq);
+	u64 irq_time;
+
 	if (!rq->skip_clock_update)
 		rq->clock = sched_clock_cpu(cpu_of(rq));
+	irq_time = irq_time_cpu(cpu);
+	if (rq->clock - irq_time > rq->clock_task)
+		rq->clock_task = rq->clock - irq_time;
 }
 
 /*
@@ -1821,6 +1830,18 @@
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
+/*
+ * There are no locks covering percpu hardirq/softirq time.
+ * They are only modified in account_system_vtime, on corresponding CPU
+ * with interrupts disabled. So, writes are safe.
+ * They are read and saved off onto struct rq in update_rq_clock().
+ * This may result in other CPU reading this CPU's irq time and can
+ * race with irq/account_system_vtime on this CPU. We would either get old
+ * or new value (or semi updated value on 32 bit) with a side effect of
+ * accounting a slice of irq time to wrong task when irq is in progress
+ * while we read rq->clock. That is a worthy compromise in place of having
+ * locks on each irq in account_system_time.
+ */
 static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
 
@@ -1837,6 +1858,14 @@
 	sched_clock_irqtime = 0;
 }
 
+static u64 irq_time_cpu(int cpu)
+{
+	if (!sched_clock_irqtime)
+		return 0;
+
+	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
+}
+
 void account_system_vtime(struct task_struct *curr)
 {
 	unsigned long flags;
@@ -1866,6 +1895,13 @@
 	local_irq_restore(flags);
 }
 
+#else
+
+static u64 irq_time_cpu(int cpu)
+{
+	return 0;
+}
+
 #endif
 
 #include "sched_stats.h"
@@ -3263,7 +3299,7 @@
 
 	if (task_current(rq, p)) {
 		update_rq_clock(rq);
-		ns = rq->clock - p->se.exec_start;
+		ns = rq->clock_task - p->se.exec_start;
 		if ((s64)ns < 0)
 			ns = 0;
 	}
Index: linux-2.6.35.y/kernel/sched_fair.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_fair.c	2011-03-29 23:03:00.126296938 -0700
+++ linux-2.6.35.y/kernel/sched_fair.c	2011-03-29 23:54:59.406482364 -0700
@@ -519,7 +519,7 @@
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock;
+	u64 now = rq_of(cfs_rq)->clock_task;
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -602,7 +602,7 @@
 	/*
 	 * We are starting a new run period:
 	 */
-	se->exec_start = rq_of(cfs_rq)->clock;
+	se->exec_start = rq_of(cfs_rq)->clock_task;
 }
 
 /**************************************************
@@ -1803,7 +1803,7 @@
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, rq->clock, sd);
+	tsk_cache_hot = task_hot(p, rq->clock_task, sd);
 	if (!tsk_cache_hot ||
 		sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
Index: linux-2.6.35.y/kernel/sched_rt.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_rt.c	2011-03-29 23:03:00.028299446 -0700
+++ linux-2.6.35.y/kernel/sched_rt.c	2011-03-29 23:03:00.322291923 -0700
@@ -609,7 +609,7 @@
 	if (!task_has_rt_policy(curr))
 		return;
 
-	delta_exec = rq->clock - curr->se.exec_start;
+	delta_exec = rq->clock_task - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
@@ -618,7 +618,7 @@
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
 
-	curr->se.exec_start = rq->clock;
+	curr->se.exec_start = rq->clock_task;
 	cpuacct_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
@@ -1075,7 +1075,7 @@
 	} while (rt_rq);
 
 	p = rt_task_of(rt_se);
-	p->se.exec_start = rq->clock;
+	p->se.exec_start = rq->clock_task;
 
 	return p;
 }
@@ -1716,7 +1716,7 @@
 {
 	struct task_struct *p = rq->curr;
 
-	p->se.exec_start = rq->clock;
+	p->se.exec_start = rq->clock_task;
 
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
