Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab1ESJmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:42:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab1ESJmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:42:36 -0400
Subject: Re: [PATCH v2 1/2] rcu: don't bind offline cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: yong.zhang0@gmail.com, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        lizf@cn.fujitsu.com, miaox@cn.fujitsu.com
In-Reply-To: <4DD4D9EB.2040603@jp.fujitsu.com>
References: <20110428161149.GA15658@redhat.com>
	 <20110502194416.2D61.A69D9226@jp.fujitsu.com>
	 <20110502195657.2D68.A69D9226@jp.fujitsu.com>
	 <1305129929.2914.247.camel@laptop> <4DCCC61F.80408@jp.fujitsu.com>
	 <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
	 <20110515185547.GL2258@linux.vnet.ibm.com> <20110516132623.GA2058@zhy>
	 <4DD4B358.3080705@jp.fujitsu.com> <1305794078.2466.7193.camel@twins>
	 <4DD4D9EB.2040603@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 11:41:53 +0200
Message-ID: <1305798113.2466.7216.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 17:50 +0900, KOSAKI Motohiro wrote:
> I'm sorry. Please give me a bit time.

N/P, as I've already found out CPU_STARTING isn't a suitable location
either.

How about something like the below...


---
Subject: rcu: Remove waitqueue usage for cpu,node and boost kthreads
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu May 19 11:27:39 CEST 2011

Since wait-queue usage is inconsistent (node) and generally not needed
since we know exactly which thread to wake, rip it out.

The problem is that wake_up() only issues an actual wake-up when there's
a thread waiting on the queue which means we need an extra, explicit,
wakeup to kick-start the kthread itself (they're born sleeping).

Now, since we already know which exact thread we want to wake up,
there's not point really in enqueing it on a waitqueue. So provide Paul
with a nice rcu_wait() macro to replace wait_event_interruptible() with
and rip out all the waitqueue stuff.

This moves us to an explicit, unconditional, wake_up_process() which can
be used to wake us from both conditions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/rcutree.c
===================================================================
--- linux-2.6.orig/kernel/rcutree.c
+++ linux-2.6/kernel/rcutree.c
@@ -94,7 +94,6 @@ static DEFINE_PER_CPU(struct task_struct
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
-static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
 
@@ -1475,7 +1474,7 @@ static void invoke_rcu_cpu_kthread(void)
 		local_irq_restore(flags);
 		return;
 	}
-	wake_up(&__get_cpu_var(rcu_cpu_wq));
+	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
 	local_irq_restore(flags);
 }
 
@@ -1598,14 +1597,12 @@ static int rcu_cpu_kthread(void *arg)
 	unsigned long flags;
 	int spincnt = 0;
 	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
-	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
 	char work;
 	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
 
 	for (;;) {
 		*statusp = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(*wqp,
-					 *workp != 0 || kthread_should_stop());
+		rcu_wait(*workp != 0 || kthread_should_stop());
 		local_bh_disable();
 		if (rcu_cpu_kthread_should_stop(cpu)) {
 			local_bh_enable();
@@ -1656,7 +1653,6 @@ static int __cpuinit rcu_spawn_one_cpu_k
 	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;
@@ -1679,7 +1675,7 @@ static int rcu_node_kthread(void *arg)
 
 	for (;;) {
 		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0);
+		rcu_wait(rnp->wakemask != 0);
 		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		mask = rnp->wakemask;
@@ -1764,7 +1760,6 @@ static int __cpuinit rcu_spawn_one_node_
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rnp->node_kthread_task = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		wake_up_process(t);
 		sp.sched_priority = 99;
 		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	}
@@ -1781,21 +1776,16 @@ static int __init rcu_spawn_kthreads(voi
 
 	rcu_kthreads_spawnable = 1;
 	for_each_possible_cpu(cpu) {
-		init_waitqueue_head(&per_cpu(rcu_cpu_wq, cpu));
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 		if (cpu_online(cpu))
 			(void)rcu_spawn_one_cpu_kthread(cpu);
 	}
 	rnp = rcu_get_root(rcu_state);
-	init_waitqueue_head(&rnp->node_wq);
-	rcu_init_boost_waitqueue(rnp);
 	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	if (NUM_RCU_NODES > 1)
-		rcu_for_each_leaf_node(rcu_state, rnp) {
-			init_waitqueue_head(&rnp->node_wq);
-			rcu_init_boost_waitqueue(rnp);
+	if (NUM_RCU_NODES > 1) {
+		rcu_for_each_leaf_node(rcu_state, rnp)
 			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-		}
+	}
 	return 0;
 }
 early_initcall(rcu_spawn_kthreads);
Index: linux-2.6/kernel/rcutree.h
===================================================================
--- linux-2.6.orig/kernel/rcutree.h
+++ linux-2.6/kernel/rcutree.h
@@ -28,6 +28,17 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
+#define rcu_wait(cond)						\
+do {								\
+	for (;;) {						\
+		set_current_state(TASK_INTERRUPTIBLE);		\
+		if (cond)					\
+			break;					\
+		schedule();					\
+	}							\
+	__set_current_state(TASK_RUNNING);			\
+} while (0)
+
 /*
  * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
  * In theory, it should be possible to add more levels straightforwardly.
@@ -157,9 +168,6 @@ struct rcu_node {
 	struct task_struct *boost_kthread_task;
 				/* kthread that takes care of priority */
 				/*  boosting for this rcu_node structure. */
-	wait_queue_head_t boost_wq;
-				/* Wait queue on which to park the boost */
-				/*  kthread. */
 	unsigned int boost_kthread_status;
 				/* State of boost_kthread_task for tracing. */
 	unsigned long n_tasks_boosted;
@@ -186,9 +194,6 @@ struct rcu_node {
 				/* kthread that takes care of this rcu_node */
 				/*  structure, for example, awakening the */
 				/*  per-CPU kthreads as needed. */
-	wait_queue_head_t node_wq;
-				/* Wait queue on which to park the per-node */
-				/*  kthread. */
 	unsigned int node_kthread_status;
 				/* State of node_kthread_task for tracing. */
 } ____cacheline_internodealigned_in_smp;
@@ -443,7 +448,6 @@ static void __cpuinit rcu_preempt_init_p
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
-static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 					  cpumask_var_t cm);
Index: linux-2.6/kernel/rcutree_plugin.h
===================================================================
--- linux-2.6.orig/kernel/rcutree_plugin.h
+++ linux-2.6/kernel/rcutree_plugin.h
@@ -1196,8 +1196,7 @@ static int rcu_boost_kthread(void *arg)
 
 	for (;;) {
 		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(rnp->boost_wq, rnp->boost_tasks ||
-							rnp->exp_tasks);
+		rcu_wait(rnp->boost_tasks || rnp->exp_tasks);
 		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
 		if (more2boost)
@@ -1275,14 +1274,6 @@ static void rcu_preempt_boost_start_gp(s
 }
 
 /*
- * Initialize the RCU-boost waitqueue.
- */
-static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
-{
-	init_waitqueue_head(&rnp->boost_wq);
-}
-
-/*
  * Create an RCU-boost kthread for the specified node if one does not
  * already exist.  We only create this kthread for preemptible RCU.
  * Returns zero if all is well, a negated errno otherwise.
@@ -1306,7 +1297,6 @@ static int __cpuinit rcu_spawn_one_boost
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;
@@ -1328,10 +1318,6 @@ static void rcu_preempt_boost_start_gp(s
 {
 }
 
-static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
-{
-}
-
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp,
 						 int rnp_index)

