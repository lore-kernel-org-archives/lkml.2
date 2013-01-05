Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3AERt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:49:26 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34906 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3AERtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:21 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/14] rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks
Date: Sat,  5 Jan 2013 09:48:58 -0800
Message-Id: <1357408144-15830-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-5406-0000-0000-000003E59C7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Because RCU callbacks are now associated with the number of the grace
period that they must wait for, CPUs can now take advance callbacks
corresponding to grace periods that ended while a given CPU was in
dyntick-idle mode.  This eliminates the need to try forcing the RCU
state machine while entering idle, thus reducing the CPU intensiveness
of RCU_FAST_NO_HZ, which should increase its energy efficiency.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 +
 kernel/rcutree.c         |   28 +++--
 kernel/rcutree.h         |   12 +--
 kernel/rcutree_plugin.h  |  350 +++++++++++++++-------------------------------
 kernel/rcutree_trace.c   |    2 -
 5 files changed, 131 insertions(+), 262 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 275aa3f..4b37b50 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -73,6 +73,7 @@ extern void do_trace_rcu_torture_read(char *rcutorturename,
 #define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
+#define ulong2long(a)		(*(long *)(&(a)))
 
 /* Exported common interfaces */
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 392c977..4b8d91c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2678,19 +2678,27 @@ static int rcu_pending(int cpu)
 }
 
 /*
- * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
- * 1 if so.
+ * Return true if the specified CPU has any callback.  If all_lazy is
+ * non-NULL, store an indication of whether all callbacks are lazy.
+ * (If there are no callbacks, all of them are deemed to be lazy.)
  */
-static int rcu_cpu_has_callbacks(int cpu)
+static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 {
+	bool al = true;
+	bool hc = false;
+	struct rcu_data *rdp;
 	struct rcu_state *rsp;
 
-	/* RCU callbacks either ready or pending? */
-	for_each_rcu_flavor(rsp)
-		if (per_cpu_ptr(rsp->rda, cpu)->nxtlist)
-			return 1;
-	return 0;
+	for_each_rcu_flavor(rsp) {
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (rdp->qlen != rdp->qlen_lazy)
+			al = false;
+		if (rdp->nxtlist)
+			hc = true;
+	}
+	if (all_lazy)
+		*all_lazy = al;
+	return hc;
 }
 
 /*
@@ -2912,7 +2920,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
-	rcu_prepare_for_idle_init(cpu);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/* Add CPU to rcu_node bitmasks. */
@@ -2986,7 +2993,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		 */
 		for_each_rcu_flavor(rsp)
 			rcu_cleanup_dying_cpu(rsp);
-		rcu_cleanup_after_idle(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c865117..282b1d7 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -88,18 +88,13 @@ struct rcu_dynticks {
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
 #ifdef CONFIG_RCU_FAST_NO_HZ
-	int dyntick_drain;	    /* Prepare-for-idle state variable. */
-	unsigned long dyntick_holdoff;
-				    /* No retries for the jiffy of failure. */
-	struct timer_list idle_gp_timer;
-				    /* Wake up CPU sleeping with callbacks. */
-	unsigned long idle_gp_timer_expires;
-				    /* When to wake up CPU (for repost). */
-	bool idle_first_pass;	    /* First pass of attempt to go idle? */
+	bool all_lazy;		    /* Are all CPU's CBs lazy? */
 	unsigned long nonlazy_posted;
 				    /* # times non-lazy CBs posted to CPU. */
 	unsigned long nonlazy_posted_snap;
 				    /* idle-period nonlazy_posted snapshot. */
+	unsigned long last_accelerate;
+				    /* Last jiffy CBs were accelerated. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 #ifdef CONFIG_RCU_USER_QS
@@ -530,7 +525,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void __cpuinit rcu_prepare_kthreads(int cpu);
-static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
 static void rcu_idle_count_callbacks_posted(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0997e9f..9371bdd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1543,14 +1543,7 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
-	return rcu_cpu_has_callbacks(cpu);
-}
-
-/*
- * Because we do not have RCU_FAST_NO_HZ, don't bother initializing for it.
- */
-static void rcu_prepare_for_idle_init(int cpu)
-{
+	return rcu_cpu_has_callbacks(cpu, NULL);
 }
 
 /*
@@ -1587,16 +1580,6 @@ static void rcu_idle_count_callbacks_posted(void)
  *
  * The following three proprocessor symbols control this state machine:
  *
- * RCU_IDLE_FLUSHES gives the maximum number of times that we will attempt
- *	to satisfy RCU.  Beyond this point, it is better to incur a periodic
- *	scheduling-clock interrupt than to loop through the state machine
- *	at full power.
- * RCU_IDLE_OPT_FLUSHES gives the number of RCU_IDLE_FLUSHES that are
- *	optional if RCU does not need anything immediately from this
- *	CPU, even if this CPU still has RCU callbacks queued.  The first
- *	times through the state machine are mandatory: we need to give
- *	the state machine a chance to communicate a quiescent state
- *	to the RCU core.
  * RCU_IDLE_GP_DELAY gives the number of jiffies that a CPU is permitted
  *	to sleep in dyntick-idle mode with RCU callbacks pending.  This
  *	is sized to be roughly one RCU grace period.  Those energy-efficiency
@@ -1612,15 +1595,9 @@ static void rcu_idle_count_callbacks_posted(void)
  * adjustment, they can be converted into kernel config parameters, though
  * making the state machine smarter might be a better option.
  */
-#define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
-#define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
 #define RCU_IDLE_GP_DELAY 4		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
-static int rcu_idle_flushes = RCU_IDLE_FLUSHES;
-module_param(rcu_idle_flushes, int, 0644);
-static int rcu_idle_opt_flushes = RCU_IDLE_OPT_FLUSHES;
-module_param(rcu_idle_opt_flushes, int, 0644);
 static int rcu_idle_gp_delay = RCU_IDLE_GP_DELAY;
 module_param(rcu_idle_gp_delay, int, 0644);
 static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
@@ -1628,6 +1605,8 @@ module_param(rcu_idle_lazy_gp_delay, int, 0644);
 
 extern int tick_nohz_enabled;
 
+#if 0 /*@@@*/
+
 /*
  * Does the specified flavor of RCU have non-lazy callbacks pending on
  * the specified CPU?  Both RCU flavor and CPU are specified by the
@@ -1670,137 +1649,100 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
 	       rcu_preempt_cpu_has_nonlazy_callbacks(cpu);
 }
 
-/*
- * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
- * callbacks on this CPU, (2) this CPU has not yet attempted to enter
- * dyntick-idle mode, or (3) this CPU is in the process of attempting to
- * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
- * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
- * it is better to incur scheduling-clock interrupts than to spin
- * continuously for the same time duration!
- *
- * The delta_jiffies argument is used to store the time when RCU is
- * going to need the CPU again if it still has callbacks.  The reason
- * for this is that rcu_prepare_for_idle() might need to post a timer,
- * but if so, it will do so after tick_nohz_stop_sched_tick() has set
- * the wakeup time for this CPU.  This means that RCU's timer can be
- * delayed until the wakeup time, which defeats the purpose of posting
- * a timer.
- */
-int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
-{
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-
-	/* Flag a new idle sojourn to the idle-entry state machine. */
-	rdtp->idle_first_pass = 1;
-	/* If no callbacks, RCU doesn't need the CPU. */
-	if (!rcu_cpu_has_callbacks(cpu)) {
-		*delta_jiffies = ULONG_MAX;
-		return 0;
-	}
-	if (rdtp->dyntick_holdoff == jiffies) {
-		/* RCU recently tried and failed, so don't try again. */
-		*delta_jiffies = 1;
-		return 1;
-	}
-	/* Set up for the possibility that RCU will post a timer. */
-	if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
-		*delta_jiffies = round_up(rcu_idle_gp_delay + jiffies,
-					  rcu_idle_gp_delay) - jiffies;
-	} else {
-		*delta_jiffies = jiffies + rcu_idle_lazy_gp_delay;
-		*delta_jiffies = round_jiffies(*delta_jiffies) - jiffies;
-	}
-	return 0;
-}
+#endif
 
 /*
- * Handler for smp_call_function_single().  The only point of this
- * handler is to wake the CPU up, so the handler does only tracing.
+ * Try to advance callbacks for all flavors of RCU on the current CPU.
+ * Afterwards, if there are any callbacks ready for immediate invocation,
+ * return true.
  */
-void rcu_idle_demigrate(void *unused)
+static bool rcu_try_advance_all_cbs(void)
 {
-	trace_rcu_prep_idle("Demigrate");
-}
+	bool cbs_ready = false;
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
+	struct rcu_state *rsp;
 
-/*
- * Timer handler used to force CPU to start pushing its remaining RCU
- * callbacks in the case where it entered dyntick-idle mode with callbacks
- * pending.  The hander doesn't really need to do anything because the
- * real work is done upon re-entry to idle, or by the next scheduling-clock
- * interrupt should idle not be re-entered.
- *
- * One special case: the timer gets migrated without awakening the CPU
- * on which the timer was scheduled on.  In this case, we must wake up
- * that CPU.  We do so with smp_call_function_single().
- */
-static void rcu_idle_gp_timer_func(unsigned long cpu_in)
-{
-	int cpu = (int)cpu_in;
+	for_each_rcu_flavor(rsp) {
+		rdp = this_cpu_ptr(rsp->rda);
+		rnp = rdp->mynode;
 
-	trace_rcu_prep_idle("Timer");
-	if (cpu != smp_processor_id())
-		smp_call_function_single(cpu, rcu_idle_demigrate, NULL, 0);
-	else
-		WARN_ON_ONCE(1); /* Getting here can hang the system... */
+		/*
+		 * Don't bother checking unless a grace period has
+		 * completed since we last checked and there are
+		 * callbacks not yet ready to invoke.
+		 */
+		if (rdp->completed != rnp->completed &&
+		    rdp->nxttail[RCU_DONE_TAIL] != rdp->nxttail[RCU_NEXT_TAIL])
+			rcu_process_gp_end(rsp, rdp);
+
+		if (cpu_has_callbacks_ready_to_invoke(rdp))
+			cbs_ready = true;
+	}
+	return cbs_ready;
 }
 
 /*
- * Initialize the timer used to pull CPUs out of dyntick-idle mode.
+ * Allow the CPU to enter dyntick-idle mode unless it has callbacks ready
+ * to invoke.  If the CPU has callbacks, try to advance them.  Tell the
+ * caller to set the timeout based on whether or not there are non-lazy
+ * callbacks.
+ *
+ * The caller must have disabled interrupts.
  */
-static void rcu_prepare_for_idle_init(int cpu)
+int rcu_needs_cpu(int cpu, unsigned long *dj)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 
-	rdtp->dyntick_holdoff = jiffies - 1;
-	setup_timer(&rdtp->idle_gp_timer, rcu_idle_gp_timer_func, cpu);
-	rdtp->idle_gp_timer_expires = jiffies - 1;
-	rdtp->idle_first_pass = 1;
-}
+	/* Snapshot to detect later posting of non-lazy callback. */
+	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
 
-/*
- * Clean up for exit from idle.  Because we are exiting from idle, there
- * is no longer any point to ->idle_gp_timer, so cancel it.  This will
- * do nothing if this timer is not active, so just cancel it unconditionally.
- */
-static void rcu_cleanup_after_idle(int cpu)
-{
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	/* If no callbacks, RCU doesn't need the CPU. */
+	if (!rcu_cpu_has_callbacks(cpu, &rdtp->all_lazy)) {
+		*dj = ULONG_MAX;
+		return 0;
+	}
 
-	del_timer(&rdtp->idle_gp_timer);
-	trace_rcu_prep_idle("Cleanup after idle");
-	rdtp->tick_nohz_enabled_snap = ACCESS_ONCE(tick_nohz_enabled);
+	/* Attempt to advance callbacks. */
+	if (rcu_try_advance_all_cbs()) {
+		/* Some ready to invoke, so initiate later invocation. */
+		invoke_rcu_core();
+		return 1;
+	}
+	rdtp->last_accelerate = jiffies;
+
+	/* Request timer delay depending on laziness, and round. */
+	if (rdtp->all_lazy) {
+		*dj = round_up(rcu_idle_gp_delay + jiffies,
+			       rcu_idle_gp_delay) - jiffies;
+	} else {
+		*dj = round_jiffies(rcu_idle_lazy_gp_delay + jiffies) - jiffies;
+	}
+	return 0;
 }
 
 /*
- * Check to see if any RCU-related work can be done by the current CPU,
- * and if so, schedule a softirq to get it done.  This function is part
- * of the RCU implementation; it is -not- an exported member of the RCU API.
- *
- * The idea is for the current CPU to clear out all work required by the
- * RCU core for the current grace period, so that this CPU can be permitted
- * to enter dyntick-idle mode.  In some cases, it will need to be awakened
- * at the end of the grace period by whatever CPU ends the grace period.
- * This allows CPUs to go dyntick-idle more quickly, and to reduce the
- * number of wakeups by a modest integer factor.
- *
- * Because it is not legal to invoke rcu_process_callbacks() with irqs
- * disabled, we do one pass of force_quiescent_state(), then do a
- * invoke_rcu_core() to cause rcu_process_callbacks() to be invoked
- * later.  The ->dyntick_drain field controls the sequencing.
+ * Prepare a CPU for idle from an RCU perspective.  The first major task
+ * is to sense whether nohz mode has been enabled or disabled via sysfs.
+ * The second major task is to check to see if a non-lazy callback has
+ * arrived at a CPU that previously had only lazy callbacks.  The third
+ * major task is to accelerate (that is, assign grace-period numbers to)
+ * any recently arrived callbacks.
  *
  * The caller must have disabled interrupts.
  */
 static void rcu_prepare_for_idle(int cpu)
 {
-	struct timer_list *tp;
+	struct rcu_data *rdp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct rcu_node *rnp;
+	struct rcu_state *rsp;
 	int tne;
 
 	/* Handle nohz enablement switches conservatively. */
 	tne = ACCESS_ONCE(tick_nohz_enabled);
 	if (tne != rdtp->tick_nohz_enabled_snap) {
-		if (rcu_cpu_has_callbacks(cpu))
+		if (rcu_cpu_has_callbacks(cpu, NULL))
 			invoke_rcu_core(); /* force nohz to see update. */
 		rdtp->tick_nohz_enabled_snap = tne;
 		return;
@@ -1808,125 +1750,56 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!tne)
 		return;
 
-	/* Adaptive-tick mode, where usermode execution is idle to RCU. */
-	if (!is_idle_task(current)) {
-		rdtp->dyntick_holdoff = jiffies - 1;
-		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
-			trace_rcu_prep_idle("User dyntick with callbacks");
-			rdtp->idle_gp_timer_expires =
-				round_up(jiffies + rcu_idle_gp_delay,
-					 rcu_idle_gp_delay);
-		} else if (rcu_cpu_has_callbacks(cpu)) {
-			rdtp->idle_gp_timer_expires =
-				round_jiffies(jiffies + rcu_idle_lazy_gp_delay);
-			trace_rcu_prep_idle("User dyntick with lazy callbacks");
-		} else {
-			return;
-		}
-		tp = &rdtp->idle_gp_timer;
-		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
+	/* If this is a no-CBs CPU, no callbacks, just return. */
+	if (is_nocb_cpu(cpu))
 		return;
-	}
 
 	/*
-	 * If this is an idle re-entry, for example, due to use of
-	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
-	 * loop, then don't take any state-machine actions, unless the
-	 * momentary exit from idle queued additional non-lazy callbacks.
-	 * Instead, repost the ->idle_gp_timer if this CPU has callbacks
-	 * pending.
+	 * If a non-lazy callback arrived at a CPU having only lazy
+	 * callbacks, invoke RCU core for the side-effect of recalculating
+	 * idle duration on re-entry to idle.
 	 */
-	if (!rdtp->idle_first_pass &&
-	    (rdtp->nonlazy_posted == rdtp->nonlazy_posted_snap)) {
-		if (rcu_cpu_has_callbacks(cpu)) {
-			tp = &rdtp->idle_gp_timer;
-			mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
-		}
+	if (rdtp->all_lazy &&
+	    rdtp->nonlazy_posted != rdtp->nonlazy_posted_snap) {
+		invoke_rcu_core();
 		return;
 	}
-	rdtp->idle_first_pass = 0;
-	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted - 1;
 
 	/*
-	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
-	 * Also reset state to avoid prejudicing later attempts.
+	 * If we have not yet accelerated this jiffy, accelerate all
+	 * callbacks on this CPU.
 	 */
-	if (!rcu_cpu_has_callbacks(cpu)) {
-		rdtp->dyntick_holdoff = jiffies - 1;
-		rdtp->dyntick_drain = 0;
-		trace_rcu_prep_idle("No callbacks");
+	if (rdtp->last_accelerate == jiffies)
 		return;
+	rdtp->last_accelerate = jiffies;
+	for_each_rcu_flavor(rsp) {
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (!*rdp->nxttail[RCU_DONE_TAIL])
+			continue;
+		rnp = rdp->mynode;
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		rcu_accelerate_cbs(rsp, rnp, rdp);
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
+}
 
-	/*
-	 * If in holdoff mode, just return.  We will presumably have
-	 * refrained from disabling the scheduling-clock tick.
-	 */
-	if (rdtp->dyntick_holdoff == jiffies) {
-		trace_rcu_prep_idle("In holdoff");
-		return;
-	}
+/*
+ * Clean up for exit from idle.  Attempt to advance callbacks based on
+ * any grace periods that elapsed while the CPU was idle, and if any
+ * callbacks are now ready to invoke, initiate invocation.
+ */
+static void rcu_cleanup_after_idle(int cpu)
+{
+	struct rcu_data *rdp;
+	struct rcu_state *rsp;
 
-	/* Check and update the ->dyntick_drain sequencing. */
-	if (rdtp->dyntick_drain <= 0) {
-		/* First time through, initialize the counter. */
-		rdtp->dyntick_drain = rcu_idle_flushes;
-	} else if (rdtp->dyntick_drain <= rcu_idle_opt_flushes &&
-		   !rcu_pending(cpu) &&
-		   !local_softirq_pending()) {
-		/* Can we go dyntick-idle despite still having callbacks? */
-		rdtp->dyntick_drain = 0;
-		rdtp->dyntick_holdoff = jiffies;
-		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
-			trace_rcu_prep_idle("Dyntick with callbacks");
-			rdtp->idle_gp_timer_expires =
-				round_up(jiffies + rcu_idle_gp_delay,
-					 rcu_idle_gp_delay);
-		} else {
-			rdtp->idle_gp_timer_expires =
-				round_jiffies(jiffies + rcu_idle_lazy_gp_delay);
-			trace_rcu_prep_idle("Dyntick with lazy callbacks");
-		}
-		tp = &rdtp->idle_gp_timer;
-		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
-		rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
-		return; /* Nothing more to do immediately. */
-	} else if (--(rdtp->dyntick_drain) <= 0) {
-		/* We have hit the limit, so time to give up. */
-		rdtp->dyntick_holdoff = jiffies;
-		trace_rcu_prep_idle("Begin holdoff");
-		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
+	if (is_nocb_cpu(cpu))
 		return;
-	}
-
-	/*
-	 * Do one step of pushing the remaining RCU callbacks through
-	 * the RCU core state machine.
-	 */
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
-		rcu_preempt_qs(cpu);
-		force_quiescent_state(&rcu_preempt_state);
-	}
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
-		rcu_sched_qs(cpu);
-		force_quiescent_state(&rcu_sched_state);
-	}
-	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
-		rcu_bh_qs(cpu);
-		force_quiescent_state(&rcu_bh_state);
-	}
-
-	/*
-	 * If RCU callbacks are still pending, RCU still needs this CPU.
-	 * So try forcing the callbacks through the grace period.
-	 */
-	if (rcu_cpu_has_callbacks(cpu)) {
-		trace_rcu_prep_idle("More callbacks");
-		invoke_rcu_core();
-	} else {
-		trace_rcu_prep_idle("Callbacks drained");
+	rcu_try_advance_all_cbs();
+	for_each_rcu_flavor(rsp) {
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (cpu_has_callbacks_ready_to_invoke(rdp))
+			invoke_rcu_core();
 	}
 }
 
@@ -2034,16 +1907,13 @@ early_initcall(rcu_register_oom_notifier);
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-	struct timer_list *tltp = &rdtp->idle_gp_timer;
-	char c;
+	unsigned long nlpd = rdtp->nonlazy_posted - rdtp->nonlazy_posted_snap;
 
-	c = rdtp->dyntick_holdoff == jiffies ? 'H' : '.';
-	if (timer_pending(tltp))
-		sprintf(cp, "drain=%d %c timer=%lu",
-			rdtp->dyntick_drain, c, tltp->expires - jiffies);
-	else
-		sprintf(cp, "drain=%d %c timer not pending",
-			rdtp->dyntick_drain, c);
+	sprintf(cp, "last_accelerate: %04lx/%04lx, nonlazy_posted: %ld, %c%c",
+		rdtp->last_accelerate & 0xffff, jiffies & 0xffff,
+		ulong2long(nlpd),
+		rdtp->all_lazy ? 'L' : '.',
+		rdtp->tick_nohz_enabled_snap ? '.' : 'D');
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 0d095dc..49099e8 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,8 +46,6 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
-#define ulong2long(a) (*(long *)(&(a)))
-
 static int r_open(struct inode *inode, struct file *file,
 					const struct seq_operations *op)
 {
-- 
1.7.8

