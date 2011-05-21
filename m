Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1EUOIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:08:51 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49881 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab1EUOIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:08:48 -0400
Date: Sat, 21 May 2011 07:08:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110521140845.GA12157@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-80d02085d99039b3b7f3a73c8896226b0cb1ba07@git.kernel.org>
 <4DD6D746.6070107@kernel.org>
 <20110520224250.GL2366@linux.vnet.ibm.com>
 <4DD6F4A2.1070401@kernel.org>
 <20110520231428.GN2366@linux.vnet.ibm.com>
 <4DD6F64C.3030402@kernel.org>
 <20110520234923.GQ2366@linux.vnet.ibm.com>
 <4DD70120.9090801@kernel.org>
 <20110521131844.GE2271@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521131844.GE2271@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 06:18:44AM -0700, Paul E. McKenney wrote:
> On Fri, May 20, 2011 at 05:02:40PM -0700, Yinghai Lu wrote:
> > On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
> > > On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
> > ...
> > >>
> > >> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
> > > 
> > > OK, just to make sure I understand...  You are compiling exactly the
> > > same kernel source tree with exactly the same .config, just with two
> > > different versions of gcc, correct?
> > yes.
> > > 
> > > If so, it is quite possible that the slow one is the correct one.  :-/
> > yeah, new version always have problem.
> > 
> > looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1
> 
> OK, so fedora14 is the fast one (4.5.1) and opensuse11.3 is the slow
> one (4.5.0), correct?

And does commit c7a3786030 help?  This commit (from Peter Zijlstra)
tidied up RCU kthreads' scheduler interactions.  The patch is below,
though it is probably more convenient to pull it from the rcu/next
branch of:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git

							Thanx, Paul

------------------------------------------------------------------------

rcu: Remove waitqueue usage for cpu, node, and boost kthreads

It is not necessary to use waitqueues for the RCU kthreads because
we always know exactly which thread is to be awakened.  In addition,
wake_up() only issues an actual wakeup when there is a thread waiting on
the queue, which was why there was an extra explicit wake_up_process()
to get the RCU kthreads started.

Eliminating the waitqueues (and wake_up()) in favor of wake_up_process()
eliminates the need for the initial wake_up_process() and also shrinks
the data structure size a bit.  The wakeup logic is placed in a new
rcu_wait() macro.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b0b482..a1a8bb6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -94,7 +94,6 @@ static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
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
 
@@ -1595,14 +1594,12 @@ static int rcu_cpu_kthread(void *arg)
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
@@ -1653,7 +1650,6 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;
@@ -1676,8 +1672,7 @@ static int rcu_node_kthread(void *arg)
 
 	for (;;) {
 		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(rnp->node_wq,
-					 atomic_read(&rnp->wakemask) != 0);
+		rcu_wait(atomic_read(&rnp->wakemask) != 0);
 		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		mask = atomic_xchg(&rnp->wakemask, 0);
@@ -1761,7 +1756,6 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rnp->node_kthread_task = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		wake_up_process(t);
 		sp.sched_priority = 99;
 		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	}
@@ -1778,21 +1772,16 @@ static int __init rcu_spawn_kthreads(void)
 
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
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 561dcb9..7b9a08b 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -159,9 +159,6 @@ struct rcu_node {
 	struct task_struct *boost_kthread_task;
 				/* kthread that takes care of priority */
 				/*  boosting for this rcu_node structure. */
-	wait_queue_head_t boost_wq;
-				/* Wait queue on which to park the boost */
-				/*  kthread. */
 	unsigned int boost_kthread_status;
 				/* State of boost_kthread_task for tracing. */
 	unsigned long n_tasks_boosted;
@@ -188,9 +185,6 @@ struct rcu_node {
 				/* kthread that takes care of this rcu_node */
 				/*  structure, for example, awakening the */
 				/*  per-CPU kthreads as needed. */
-	wait_queue_head_t node_wq;
-				/* Wait queue on which to park the per-node */
-				/*  kthread. */
 	unsigned int node_kthread_status;
 				/* State of node_kthread_task for tracing. */
 } ____cacheline_internodealigned_in_smp;
@@ -336,6 +330,16 @@ struct rcu_data {
 						/*  scheduling clock irq */
 						/*  before ratting on them. */
 
+#define rcu_wait(cond)							\
+do {									\
+	for (;;) {							\
+		set_current_state(TASK_INTERRUPTIBLE);			\
+		if (cond)						\
+			break;						\
+		schedule();						\
+	}								\
+	__set_current_state(TASK_RUNNING);				\
+} while (0)
 
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
@@ -445,7 +449,6 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
-static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 					  cpumask_var_t cm);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ed339702..049f278 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1196,8 +1196,7 @@ static int rcu_boost_kthread(void *arg)
 
 	for (;;) {
 		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(rnp->boost_wq, rnp->boost_tasks ||
-							rnp->exp_tasks);
+		rcu_wait(rnp->boost_tasks || rnp->exp_tasks);
 		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
 		if (more2boost)
@@ -1275,14 +1274,6 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
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
@@ -1306,7 +1297,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;
@@ -1328,10 +1318,6 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
 
-static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
-{
-}
-
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp,
 						 int rnp_index)
