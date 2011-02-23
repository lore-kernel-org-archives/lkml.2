Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1BWBlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:41:55 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37585 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab1BWBjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 08/11] rcu: Decrease memory-barrier usage based on semi-formal proof
Date: Tue, 22 Feb 2011 17:39:37 -0800
Message-Id: <1298425183-21265-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d09b62d fixed grace-period synchronization, but left some smp_mb()
invocations in rcu_process_callbacks() that are no longer needed, but
sheer paranoia prevented them from being removed.  This commit removes
them and provides a proof of correctness in their absence.  It also adds
a memory barrier to rcu_report_qs_rsp() immediately before the update to
rsp->completed in order to handle the theoretical possibility that the
compiler or CPU might move massive quantities of code into a lock-based
critical section.  This also proves that the sheer paranoia was not
entirely unjustified, at least from a theoretical point of view.

In addition, the old dyntick-idle synchronization depended on the fact
that grace periods were many milliseconds in duration, so that it could
be assumed that no dyntick-idle CPU could reorder a memory reference
across an entire grace period.  Unfortunately for this design, the
addition of expedited grace periods breaks this assumption, which has
the unfortunate side-effect of requiring atomic operations in the
functions that track dyntick-idle state for RCU.  (There is some hope
that the algorithms used in user-level RCU might be applied here, but
some work is required to handle the NMIs that user-space applications
can happily ignore.)

This proof assumes that neither compiler nor CPU will allow a lock
acquisition and release to be reordered, as doing so can result in
deadlock.  The proof is as follows:

1.	A given CPU declares a quiescent state under the protection of
	its leaf rcu_node's lock.

2.	If there is more than one level of rcu_node hierarchy, the
	last CPU to declare a quiescent state will also acquire the
	->lock of the next rcu_node up in the hierarchy,  but only
	after releasing the lower level's lock.  The acquisition of this
	lock clearly cannot occur prior to the acquisition of the leaf
	node's lock.

3.	Step 2 repeats until we reach the root rcu_node structure.
	Please note again that only one lock is held at a time through
	this process.  The acquisition of the root rcu_node's ->lock
	must occur after the release of that of the leaf rcu_node.

4.	At this point, we set the ->completed field in the rcu_state
	structure in rcu_report_qs_rsp().  However, if the rcu_node
	hierarchy contains only one rcu_node, then in theory the code
	preceding the quiescent state could leak into the critical
	section.  We therefore precede the update of ->completed with a
	memory barrier.  All CPUs will therefore agree that any updates
	preceding any report of a quiescent state will have happened
	before the update of ->completed.

5.	Regardless of whether a new grace period is needed, rcu_start_gp()
	will propagate the new value of ->completed to all of the leaf
	rcu_node structures, under the protection of each rcu_node's ->lock.
	If a new grace period is needed immediately, this propagation
	will occur in the same critical section that ->completed was
	set in, but courtesy of the memory barrier in #4 above, is still
	seen to follow any pre-quiescent-state activity.

6.	When a given CPU invokes __rcu_process_gp_end(), it becomes
	aware of the end of the old grace period and therefore makes
	any RCU callbacks that were waiting on that grace period eligible
	for invocation.

	If this CPU is the same one that detected the end of the grace
	period, and if there is but a single rcu_node in the hierarchy,
	we will still be in the single critical section.  In this case,
	the memory barrier in step #4 guarantees that all callbacks will
	be seen to execute after each CPU's quiescent state.

	On the other hand, if this is a different CPU, it will acquire
	the leaf rcu_node's ->lock, and will again be serialized after
	each CPU's quiescent state for the old grace period.

On the strength of this proof, this commit therefore removes the memory
barriers from rcu_process_callbacks() and adds one to rcu_report_qs_rsp().
The effect is to reduce the number of memory barriers by one and to
reduce the frequency of execution from about once per scheduling tick
per CPU to once per grace period.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   48 +++++++---------
 kernel/rcutree.c            |  130 ++++++++++++++++++------------------------
 kernel/rcutree.h            |    9 +--
 kernel/rcutree_plugin.h     |    7 +-
 kernel/rcutree_trace.c      |   12 ++--
 5 files changed, 88 insertions(+), 118 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 6a8c73f..e731ad2 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -21,23 +21,23 @@ rcu_pending() function decided that there was core RCU work to do).
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
-  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
-  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
-  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1 dn=0 df=1545 of=0 ri=0 ql=0 b=10
-  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1 dn=0 df=1992 of=0 ri=0 ql=0 b=10
-  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1 dn=0 df=3331 of=0 ri=4 ql=2 b=10
-  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1 dn=0 df=3224 of=0 ri=0 ql=0 b=10
-  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1 dn=0 df=1818 of=0 ri=0 ql=2 b=10
+  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1/0 df=1101 of=0 ri=36 ql=0 b=10
+  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1/0 df=1015 of=0 ri=0 ql=0 b=10
+  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1/0 df=1839 of=0 ri=0 ql=0 b=10
+  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1/0 df=1545 of=0 ri=0 ql=0 b=10
+  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1/0 df=1992 of=0 ri=0 ql=0 b=10
+  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1/0 df=3331 of=0 ri=4 ql=2 b=10
+  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1/0 df=3224 of=0 ri=0 ql=0 b=10
+  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1/0 df=1818 of=0 ri=0 ql=2 b=10
 rcu_bh:
-  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1 dn=0 df=0 of=0 ri=0 ql=0 b=10
-  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1 dn=0 df=13 of=0 ri=0 ql=0 b=10
-  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1 dn=0 df=9 of=0 ri=0 ql=0 b=10
-  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1/0 df=0 of=0 ri=0 ql=0 b=10
+  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1/0 df=13 of=0 ri=0 ql=0 b=10
+  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1/0 df=15 of=0 ri=0 ql=0 b=10
+  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1/0 df=9 of=0 ri=0 ql=0 b=10
+  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1/0 df=15 of=0 ri=0 ql=0 b=10
+  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1/0 df=15 of=0 ri=0 ql=0 b=10
+  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1/0 df=15 of=0 ri=0 ql=0 b=10
+  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1/0 df=15 of=0 ri=0 ql=0 b=10
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -85,18 +85,10 @@ o	"qp" indicates that RCU still expects a quiescent state from
 
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
+	scheduler or by irq.  The number after the first "/" is the
+	interrupt nesting depth when in dyntick-idle state, or one
+	greater than the interrupt-nesting depth otherwise.  The number
+	after the second "/" is the NMI nesting depth.
 
 	This field is displayed only for CONFIG_NO_HZ kernels.
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5513129..90104a1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -128,7 +128,7 @@ void rcu_note_context_switch(int cpu)
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
-	.dynticks = 1,
+	.dynticks = ATOMIC_INIT(1),
 };
 #endif /* #ifdef CONFIG_NO_HZ */
 
@@ -262,13 +262,25 @@ void rcu_enter_nohz(void)
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
@@ -284,11 +296,16 @@ void rcu_exit_nohz(void)
 
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
@@ -302,11 +319,15 @@ void rcu_nmi_enter(void)
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
@@ -320,11 +341,14 @@ void rcu_nmi_exit(void)
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
@@ -335,13 +359,7 @@ void rcu_nmi_exit(void)
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
@@ -353,18 +371,7 @@ void rcu_irq_enter(void)
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
-	if (__get_cpu_var(rcu_sched_data).nxtlist ||
-	    __get_cpu_var(rcu_bh_data).nxtlist)
-		set_need_resched();
+	rcu_enter_nohz();
 }
 
 #ifdef CONFIG_SMP
@@ -376,19 +383,8 @@ void rcu_irq_exit(void)
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
@@ -399,16 +395,11 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
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
@@ -418,8 +409,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * read-side critical section that started before the beginning
 	 * of the current RCU grace period.
 	 */
-	if ((curr != snap || (curr & 0x1) == 0) &&
-	    (curr_nmi != snap_nmi || (curr_nmi & 0x1) == 0)) {
+	if ((curr & 0x1) == 0 || ULONG_CMP_GE(curr, snap + 2)) {
 		rdp->dynticks_fqs++;
 		return 1;
 	}
@@ -841,6 +831,12 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
+
+	/*
+	 * Ensure that all grace-period and pre-grace-period activity
+	 * is seen before the assignment to rsp->completed.
+	 */
+	smp_mb(); /* See above block comment. */
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -1367,25 +1363,11 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_process_callbacks(struct softirq_action *unused)
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
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e1a6663..bd891de 100644
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
 
 /*
@@ -218,7 +216,6 @@ struct rcu_data {
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
 #endif /* #ifdef CONFIG_NO_HZ */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 38426ef..764b5fc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1182,7 +1182,6 @@ int rcu_needs_cpu(int cpu)
 {
 	int c = 0;
 	int snap;
-	int snap_nmi;
 	int thatcpu;
 
 	/* Check for being in the holdoff period. */
@@ -1193,10 +1192,10 @@ int rcu_needs_cpu(int cpu)
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
index c8e9785..4a21ca5 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -57,10 +57,10 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
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
@@ -115,9 +115,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
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
@@ -130,7 +130,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",");
 #ifdef CONFIG_NO_HZ
-	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
+	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
-- 
1.7.3.2

