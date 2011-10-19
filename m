Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1JSJ7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:59:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:35739 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1JSJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:59:11 -0400
Date: Wed, 19 Oct 2011 11:59:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0.7-rt20
Message-ID: <alpine.LFD.2.02.1110191150280.3240@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0.7-rt20 release.

3.0.7-rt19 is an not announced intermediate release, which only
updates to 3.0.7. No rt changes except dropping patches which made it
into 3.0.7.

Changes from 3.0.7-rt19 to 3.0.7-rt20

  * Fix a long standing RT throttling problem with cgroups and
    RT_GROUP_SCHED (Peter Zijlstra, Thanks to Carsten Emde for
    providing the debug information!)

  * Minor fixes (Yong Zhang)

Delta patch against 3.0.7-rt19

  https://tglx.de/~tglx/rt/patch-3.0.7-rt19-rt20.patch.gz

also appended below.


Patch against 3.0.7 can be found here:

  https://tglx.de/~tglx/rt/patch-3.0.7-rt20.patch.gz


The split quilt queue is available at:

  https://tglx.de/~tglx/rt/patches-3.0.7-rt20.tar.gz

Known issues:

  Yong discovered a non critical cpuhotplug problem, which needs some
  more thought. Will try to address that in the next days as traveling
  allows (about to head to Prague for a long RTLWS/KS/LinuxCon/ELCE
  week).

Enjoy,

	tglx

--------------->
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -139,7 +139,7 @@ static int cpu_unplug_begin(unsigned int
 	struct task_struct *tsk;
 
 	init_completion(&hp->synced);
-	tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d\n", cpu);
+	tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d", cpu);
 	if (IS_ERR(tsk))
 		return (PTR_ERR(tsk));
 	kthread_bind(tsk, cpu);
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -1282,8 +1282,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
-	if (cpu_is_offline(cpu))
-		printk_tick();
+	if (unlikely(cpu_is_offline(cpu)))
+		__this_cpu_write(printk_pending, 0);
 	return __this_cpu_read(printk_pending);
 }
 
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -556,12 +556,9 @@ static inline int balance_runtime(struct
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
-	int i, idle = 1;
+	int i, idle = 1, throttled = 0;
 	const struct cpumask *span;
 
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return 1;
-
 	span = sched_rt_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
@@ -596,12 +593,17 @@ static int do_sched_rt_period_timer(stru
 			if (!rt_rq_throttled(rt_rq))
 				enqueue = 1;
 		}
+		if (rt_rq->rt_throttled)
+			throttled = 1;
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
 		raw_spin_unlock(&rq->lock);
 	}
 
+	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
+		return 1;
+
 	return idle;
 }
 
@@ -633,8 +635,24 @@ static int sched_rt_runtime_exceeded(str
 		return 0;
 
 	if (rt_rq->rt_time > runtime) {
-		rt_rq->rt_throttled = 1;
-		printk_once(KERN_WARNING "sched: RT throttling activated\n");
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+		/*
+		 * Don't actually throttle groups that have no runtime assigned
+		 * but accrue some time due to boosting.
+		 */
+		if (likely(rt_b->rt_runtime)) {
+			rt_rq->rt_throttled = 1;
+			printk_once(KERN_WARNING "sched: RT throttling activated\n");
+		} else {
+			/*
+			 * In case we did anyway, make it go away,
+			 * replenishment is a joke, since it will replenish us
+			 * with exactly 0 ns.
+			 */
+			rt_rq->rt_time = 0;
+		}
+
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
@@ -662,7 +680,8 @@ static void update_curr_rt(struct rq *rq
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
-	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
+	schedstat_set(curr->se.statistics.exec_max,
+		      max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -3274,14 +3274,14 @@ static void flush_gcwq(struct global_cwq
 
 	spin_unlock_irq(&gcwq->lock);
 
-	gcwq = get_gcwq(get_cpu());
+	gcwq = get_gcwq(get_cpu_light());
 	spin_lock_irq(&gcwq->lock);
 	list_for_each_entry_safe(work, nw, &non_affine_works, entry) {
 		list_del_init(&work->entry);
 		___queue_work(get_work_cwq(work)->wq, gcwq, work);
 	}
 	spin_unlock_irq(&gcwq->lock);
-	put_cpu();
+	put_cpu_light();
 }
 
 static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt19
+-rt20
