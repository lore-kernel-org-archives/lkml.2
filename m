Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1E1Qi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:38:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1E1Qi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:38:26 -0400
Date: Sat, 28 May 2011 18:38:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU and lockdep fixes
Message-ID: <20110528163807.GA9846@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      rcu: Fix unpaired rcu_irq_enter() from locking selftests

Juri Lelli (1):
      Documentation: Add statistics about nested locks

Paul E. McKenney (8):
      rcu: Add memory barriers
      rcu: Remove old memory barriers from rcu_process_callbacks()
      rcu: Don't do reschedule unless in irq
      rcu: Make rcu_enter_nohz() pay attention to nesting
      rcu: Decrease memory-barrier usage based on semi-formal proof
      atomic: Add atomic_or()
      rcu: Avoid acquiring rcu_node locks in timer functions
      rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state

Peter Zijlstra (1):
      rcu: Remove waitqueue usage for cpu, node, and boost kthreads


 Documentation/RCU/trace.txt |   17 ++---
 Documentation/lockstat.txt  |   36 +++++++++-
 include/linux/atomic.h      |   13 ++++
 kernel/rcutree.c            |  164 ++++++++++++++++++-------------------------
 kernel/rcutree.h            |   30 ++++----
 kernel/rcutree_plugin.h     |   24 ++-----
 kernel/rcutree_trace.c      |   12 ++--
 lib/locking-selftest.c      |    2 +-
 8 files changed, 147 insertions(+), 151 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index c078ad4..8173cec 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -99,18 +99,11 @@ o	"qp" indicates that RCU still expects a quiescent state from
 
 o	"dt" is the current value of the dyntick counter that is incremented
 	when entering or leaving dynticks idle state, either by the
-	scheduler or by irq.  The number after the "/" is the interrupt
-	nesting depth when in dyntick-idle state, or one greater than
-	the interrupt-nesting depth otherwise.
-
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
-o	"dn" is the current value of the dyntick counter that is incremented
-	when entering or leaving dynticks idle state via NMI.  If both
-	the "dt" and "dn" values are even, then this CPU is in dynticks
-	idle mode and may be ignored by RCU.  If either of these two
-	counters is odd, then RCU must be alert to the possibility of
-	an RCU read-side critical section running on this CPU.
+	scheduler or by irq.  This number is even if the CPU is in
+	dyntick idle mode and odd otherwise.  The number after the first
+	"/" is the interrupt nesting depth when in dyntick-idle state,
+	or one greater than the interrupt-nesting depth otherwise.
+	The number after the second "/" is the NMI nesting depth.
 
 	This field is displayed only for CONFIG_NO_HZ kernels.
 
diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index 9c0a80d..cef00d4 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -12,8 +12,9 @@ Because things like lock contention can severely impact performance.
 - HOW
 
 Lockdep already has hooks in the lock functions and maps lock instances to
-lock classes. We build on that. The graph below shows the relation between
-the lock functions and the various hooks therein.
+lock classes. We build on that (see Documentation/lockdep-design.txt).
+The graph below shows the relation between the lock functions and the various
+hooks therein.
 
         __acquire
             |
@@ -128,6 +129,37 @@ points are the points we're contending with.
 
 The integer part of the time values is in us.
 
+Dealing with nested locks, subclasses may appear:
+
+32...............................................................................................................................................................................................
+33
+34                               &rq->lock:         13128          13128           0.43         190.53      103881.26          97454        3453404           0.00         401.11    13224683.11
+35                               ---------
+36                               &rq->lock            645          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+37                               &rq->lock            297          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+38                               &rq->lock            360          [<ffffffff8103c4c5>] select_task_rq_fair+0x1f0/0x74a
+39                               &rq->lock            428          [<ffffffff81045f98>] scheduler_tick+0x46/0x1fb
+40                               ---------
+41                               &rq->lock             77          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+42                               &rq->lock            174          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+43                               &rq->lock           4715          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+44                               &rq->lock            893          [<ffffffff81340524>] schedule+0x157/0x7b8
+45
+46...............................................................................................................................................................................................
+47
+48                             &rq->lock/1:         11526          11488           0.33         388.73      136294.31          21461          38404           0.00          37.93      109388.53
+49                             -----------
+50                             &rq->lock/1          11526          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+51                             -----------
+52                             &rq->lock/1           5645          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+53                             &rq->lock/1           1224          [<ffffffff81340524>] schedule+0x157/0x7b8
+54                             &rq->lock/1           4336          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+55                             &rq->lock/1            181          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+
+Line 48 shows statistics for the second subclass (/1) of &rq->lock class
+(subclass starts from 0), since in this case, as line 50 suggests,
+double_rq_lock actually acquires a nested lock of two spinlocks.
+
 View the top contending locks:
 
 # grep : /proc/lock_stat | head
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index 96c038e..ee456c7 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -34,4 +34,17 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
 }
 #endif
 
+#ifndef CONFIG_ARCH_HAS_ATOMIC_OR
+static inline void atomic_or(int i, atomic_t *v)
+{
+	int old;
+	int new;
+
+	do {
+		old = atomic_read(v);
+		new = old | i;
+	} while (atomic_cmpxchg(v, old, new) != old);
+}
+#endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */
+
 #endif /* _LINUX_ATOMIC_H */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f07d2f0..77a7671 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -36,7 +36,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/nmi.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/completion.h>
@@ -95,7 +95,6 @@ static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
-static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
 
@@ -163,7 +162,7 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
-	.dynticks = 1,
+	.dynticks = ATOMIC_INIT(1),
 };
 #endif /* #ifdef CONFIG_NO_HZ */
 
@@ -322,13 +321,25 @@ void rcu_enter_nohz(void)
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	rdtp->dynticks++;
-	rdtp->dynticks_nesting--;
-	WARN_ON_ONCE(rdtp->dynticks & 0x1);
+	if (--rdtp->dynticks_nesting) {
+		local_irq_restore(flags);
+		return;
+	}
+	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
+	smp_mb__before_atomic_inc();  /* See above. */
+	atomic_inc(&rdtp->dynticks);
+	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 	local_irq_restore(flags);
+
+	/* If the interrupt queued a callback, get out of dyntick mode. */
+	if (in_irq() &&
+	    (__get_cpu_var(rcu_sched_data).nxtlist ||
+	     __get_cpu_var(rcu_bh_data).nxtlist ||
+	     rcu_preempt_needs_cpu(smp_processor_id())))
+		set_need_resched();
 }
 
 /*
@@ -344,11 +355,16 @@ void rcu_exit_nohz(void)
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	rdtp->dynticks++;
-	rdtp->dynticks_nesting++;
-	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
+	if (rdtp->dynticks_nesting++) {
+		local_irq_restore(flags);
+		return;
+	}
+	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
+	atomic_inc(&rdtp->dynticks);
+	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
+	smp_mb__after_atomic_inc();  /* See above. */
+	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	local_irq_restore(flags);
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
 
 /**
@@ -362,11 +378,15 @@ void rcu_nmi_enter(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
-	if (rdtp->dynticks & 0x1)
+	if (rdtp->dynticks_nmi_nesting == 0 &&
+	    (atomic_read(&rdtp->dynticks) & 0x1))
 		return;
-	rdtp->dynticks_nmi++;
-	WARN_ON_ONCE(!(rdtp->dynticks_nmi & 0x1));
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+	rdtp->dynticks_nmi_nesting++;
+	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
+	atomic_inc(&rdtp->dynticks);
+	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
+	smp_mb__after_atomic_inc();  /* See above. */
+	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 }
 
 /**
@@ -380,11 +400,14 @@ void rcu_nmi_exit(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
-	if (rdtp->dynticks & 0x1)
+	if (rdtp->dynticks_nmi_nesting == 0 ||
+	    --rdtp->dynticks_nmi_nesting != 0)
 		return;
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	rdtp->dynticks_nmi++;
-	WARN_ON_ONCE(rdtp->dynticks_nmi & 0x1);
+	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
+	smp_mb__before_atomic_inc();  /* See above. */
+	atomic_inc(&rdtp->dynticks);
+	smp_mb__after_atomic_inc();  /* Force delay to next write. */
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
 /**
@@ -395,13 +418,7 @@ void rcu_nmi_exit(void)
  */
 void rcu_irq_enter(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
-
-	if (rdtp->dynticks_nesting++)
-		return;
-	rdtp->dynticks++;
-	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+	rcu_exit_nohz();
 }
 
 /**
@@ -413,18 +430,7 @@ void rcu_irq_enter(void)
  */
 void rcu_irq_exit(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
-
-	if (--rdtp->dynticks_nesting)
-		return;
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	rdtp->dynticks++;
-	WARN_ON_ONCE(rdtp->dynticks & 0x1);
-
-	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (__this_cpu_read(rcu_sched_data.nxtlist) ||
-	    __this_cpu_read(rcu_bh_data.nxtlist))
-		set_need_resched();
+	rcu_enter_nohz();
 }
 
 #ifdef CONFIG_SMP
@@ -436,19 +442,8 @@ void rcu_irq_exit(void)
  */
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
-	int ret;
-	int snap;
-	int snap_nmi;
-
-	snap = rdp->dynticks->dynticks;
-	snap_nmi = rdp->dynticks->dynticks_nmi;
-	smp_mb();	/* Order sampling of snap with end of grace period. */
-	rdp->dynticks_snap = snap;
-	rdp->dynticks_nmi_snap = snap_nmi;
-	ret = ((snap & 0x1) == 0) && ((snap_nmi & 0x1) == 0);
-	if (ret)
-		rdp->dynticks_fqs++;
-	return ret;
+	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
+	return 0;
 }
 
 /*
@@ -459,16 +454,11 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  */
 static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 {
-	long curr;
-	long curr_nmi;
-	long snap;
-	long snap_nmi;
+	unsigned long curr;
+	unsigned long snap;
 
-	curr = rdp->dynticks->dynticks;
-	snap = rdp->dynticks_snap;
-	curr_nmi = rdp->dynticks->dynticks_nmi;
-	snap_nmi = rdp->dynticks_nmi_snap;
-	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+	curr = (unsigned long)atomic_add_return(0, &rdp->dynticks->dynticks);
+	snap = (unsigned long)rdp->dynticks_snap;
 
 	/*
 	 * If the CPU passed through or entered a dynticks idle phase with
@@ -478,8 +468,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * read-side critical section that started before the beginning
 	 * of the current RCU grace period.
 	 */
-	if ((curr != snap || (curr & 0x1) == 0) &&
-	    (curr_nmi != snap_nmi || (curr_nmi & 0x1) == 0)) {
+	if ((curr & 0x1) == 0 || ULONG_CMP_GE(curr, snap + 2)) {
 		rdp->dynticks_fqs++;
 		return 1;
 	}
@@ -908,6 +897,12 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	unsigned long gp_duration;
 
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
+
+	/*
+	 * Ensure that all grace-period and pre-grace-period activity
+	 * is seen before the assignment to rsp->completed.
+	 */
+	smp_mb(); /* See above block comment. */
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
@@ -1455,25 +1450,11 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_process_callbacks(void)
 {
-	/*
-	 * Memory references from any prior RCU read-side critical sections
-	 * executed by the interrupted code must be seen before any RCU
-	 * grace-period manipulations below.
-	 */
-	smp_mb(); /* See above block comment. */
-
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
 
-	/*
-	 * Memory references from any later RCU read-side critical sections
-	 * executed by the interrupted code must be seen after any RCU
-	 * grace-period manipulations above.
-	 */
-	smp_mb(); /* See above block comment. */
-
 	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
 	rcu_needs_cpu_flush();
 }
@@ -1494,7 +1475,7 @@ static void invoke_rcu_cpu_kthread(void)
 		local_irq_restore(flags);
 		return;
 	}
-	wake_up(&__get_cpu_var(rcu_cpu_wq));
+	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
 	local_irq_restore(flags);
 }
 
@@ -1544,13 +1525,10 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
  */
 static void rcu_cpu_kthread_timer(unsigned long arg)
 {
-	unsigned long flags;
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
 	struct rcu_node *rnp = rdp->mynode;
 
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rnp->wakemask |= rdp->grpmask;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	atomic_or(rdp->grpmask, &rnp->wakemask);
 	invoke_rcu_node_kthread(rnp);
 }
 
@@ -1617,14 +1595,12 @@ static int rcu_cpu_kthread(void *arg)
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
@@ -1672,10 +1648,10 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	kthread_bind(t, cpu);
+	set_task_state(t, TASK_INTERRUPTIBLE);
 	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;
@@ -1698,11 +1674,10 @@ static int rcu_node_kthread(void *arg)
 
 	for (;;) {
 		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0);
+		rcu_wait(atomic_read(&rnp->wakemask) != 0);
 		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		mask = rnp->wakemask;
-		rnp->wakemask = 0;
+		mask = atomic_xchg(&rnp->wakemask, 0);
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
 			if ((mask & 0x1) == 0)
@@ -1781,9 +1756,9 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		if (IS_ERR(t))
 			return PTR_ERR(t);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		set_task_state(t, TASK_INTERRUPTIBLE);
 		rnp->node_kthread_task = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		wake_up_process(t);
 		sp.sched_priority = 99;
 		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	}
@@ -1800,21 +1775,16 @@ static int __init rcu_spawn_kthreads(void)
 
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
index 2576648..7b9a08b 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -84,11 +84,9 @@
  * Dynticks per-CPU state.
  */
 struct rcu_dynticks {
-	int dynticks_nesting;	/* Track nesting level, sort of. */
-	int dynticks;		/* Even value for dynticks-idle, else odd. */
-	int dynticks_nmi;	/* Even value for either dynticks-idle or */
-				/*  not in nmi handler, else odd.  So this */
-				/*  remains even for nmi from irq handler. */
+	int dynticks_nesting;	/* Track irq/process nesting level. */
+	int dynticks_nmi_nesting; /* Track NMI nesting level. */
+	atomic_t dynticks;	/* Even value for dynticks-idle, else odd. */
 };
 
 /* RCU's kthread states for tracing. */
@@ -121,7 +119,9 @@ struct rcu_node {
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
-	unsigned long wakemask; /* CPUs whose kthread needs to be awakened. */
+	atomic_t wakemask;	/* CPUs whose kthread needs to be awakened. */
+				/*  Since this has meaning only for leaf */
+				/*  rcu_node structures, 32 bits suffices. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
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
@@ -284,7 +278,6 @@ struct rcu_data {
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
 #endif /* #ifdef CONFIG_NO_HZ */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
@@ -337,6 +330,16 @@ struct rcu_data {
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
@@ -446,7 +449,6 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
-static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 					  cpumask_var_t cm);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3f6559a..a767b7d 100644
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
@@ -1304,9 +1295,9 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	set_task_state(t, TASK_INTERRUPTIBLE);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;
@@ -1328,10 +1319,6 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
 
-static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
-{
-}
-
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp,
 						 int rnp_index)
@@ -1520,7 +1507,6 @@ int rcu_needs_cpu(int cpu)
 {
 	int c = 0;
 	int snap;
-	int snap_nmi;
 	int thatcpu;
 
 	/* Check for being in the holdoff period. */
@@ -1531,10 +1517,10 @@ int rcu_needs_cpu(int cpu)
 	for_each_online_cpu(thatcpu) {
 		if (thatcpu == cpu)
 			continue;
-		snap = per_cpu(rcu_dynticks, thatcpu).dynticks;
-		snap_nmi = per_cpu(rcu_dynticks, thatcpu).dynticks_nmi;
+		snap = atomic_add_return(0, &per_cpu(rcu_dynticks,
+						     thatcpu).dynticks);
 		smp_mb(); /* Order sampling of snap with end of grace period. */
-		if (((snap & 0x1) != 0) || ((snap_nmi & 0x1) != 0)) {
+		if ((snap & 0x1) != 0) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index aa0fd72..9678cc3 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -69,10 +69,10 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
-	seq_printf(m, " dt=%d/%d dn=%d df=%lu",
-		   rdp->dynticks->dynticks,
+	seq_printf(m, " dt=%d/%d/%d df=%lu",
+		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi,
+		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
@@ -141,9 +141,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, ",%d,%d,%d,%lu",
-		   rdp->dynticks->dynticks,
+		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi,
+		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
@@ -167,7 +167,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",");
 #ifdef CONFIG_NO_HZ
-	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
+	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 619313e..507a22f 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -144,7 +144,7 @@ static void init_shared_classes(void)
 
 #define HARDIRQ_ENTER()				\
 	local_irq_disable();			\
-	irq_enter();				\
+	__irq_enter();				\
 	WARN_ON(!in_irq());
 
 #define HARDIRQ_EXIT()				\
