Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1KBUfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:35:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59191 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1KBUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:39 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 27/28] rcu: Allow dyntick-idle mode for CPUs with callbacks
Date: Wed,  2 Nov 2011 13:30:48 -0700
Message-Id: <1320265849-5744-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5930-0000-0000-000000D6369D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Currently, RCU does not permit a CPU to enter dyntick-idle mode if that
CPU has any RCU callbacks queued.  This means that workloads for which
each CPU wakes up and does some RCU updates every few ticks will never
enter dyntick-idle mode.  This can result in significant unnecessary power
consumption, so this patch permits a given to enter dyntick-idle mode if
it has callbacks, but only if that same CPU has completed all current
work for the RCU core.  We determine use rcu_pending() to determine
whether a given CPU has completed all current work for the RCU core.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    5 +-
 kernel/rcutree.h        |    4 +
 kernel/rcutree_plugin.h |  156 +++++++++++++++++++++++++++++++++++++----------
 3 files changed, 132 insertions(+), 33 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2a8d9a6..3d7b474 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -365,6 +365,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	rcu_prepare_for_idle(smp_processor_id());
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
@@ -1085,6 +1086,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	 * callbacks are waiting on the grace period that just now
 	 * completed.
 	 */
+	rcu_schedule_wake_gp_end();
 	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
 		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
 
@@ -1670,6 +1672,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
+	rcu_wake_cpus_for_gp_end();
 	trace_rcu_utilization("End RCU core");
 }
 
@@ -1923,7 +1926,7 @@ static int rcu_pending(int cpu)
  * by the current CPU, even if none need be done immediately, returning
  * 1 if so.
  */
-static int rcu_needs_cpu_quick_check(int cpu)
+static int rcu_cpu_has_callbacks(int cpu)
 {
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index fd2f87d..ea32405 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -88,6 +88,7 @@ struct rcu_dynticks {
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
+	int wake_gp_end;	    /* A GP ended, need to wake up CPUs. */
 };
 
 /* RCU's kthread states for tracing. */
@@ -467,5 +468,8 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
 static void __cpuinit rcu_prepare_kthreads(int cpu);
+static void rcu_prepare_for_idle(int cpu);
+static void rcu_wake_cpus_for_gp_end(void);
+static void rcu_schedule_wake_gp_end(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7a7961f..5509147 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1953,7 +1953,31 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
  */
 int rcu_needs_cpu(int cpu)
 {
-	return rcu_needs_cpu_quick_check(cpu);
+	return rcu_cpu_has_callbacks(cpu);
+}
+
+/*
+ * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=y,
+ * is nothing.
+ */
+static void rcu_prepare_for_idle(int cpu)
+{
+}
+
+/*
+ * CPUs are never putting themselves to sleep with callbacks pending,
+ * so there is no need to awaken them.
+ */
+static void rcu_wake_cpus_for_gp_end(void)
+{
+}
+
+/*
+ * CPUs are never putting themselves to sleep with callbacks pending,
+ * so there is no need to schedule the act of awakening them.
+ */
+static void rcu_schedule_wake_gp_end(void)
+{
 }
 
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
@@ -1961,47 +1985,56 @@ int rcu_needs_cpu(int cpu)
 #define RCU_NEEDS_CPU_FLUSHES 5
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
+static DEFINE_PER_CPU(bool, rcu_awake_at_gp_end);
 
 /*
- * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  This function is part of the RCU implementation; it is -not-
- * an exported member of the RCU API.
+ * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
+ * callbacks on this CPU, (2) this CPU has not yet attempted to enter
+ * dyntick-idle mode, and (3) this CPU is in the process of attempting to
+ * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
+ * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
+ * it is better to incur scheduling-clock interrupts than to spin
+ * continuously for the same time duration!
+ */
+int rcu_needs_cpu(int cpu)
+{
+	/* If no callbacks, RCU doesn't need the CPU. */
+	if (!rcu_cpu_has_callbacks(cpu))
+		return 0;
+	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
+	return per_cpu(rcu_dyntick_holdoff, cpu) == jiffies;
+}
+
+/*
+ * Check to see if any RCU-related work can be done by the current CPU,
+ * and if so, schedule a softirq to get it done.  This function is part
+ * of the RCU implementation; it is -not- an exported member of the RCU API.
  *
- * Because we are not supporting preemptible RCU, attempt to accelerate
- * any current grace periods so that RCU no longer needs this CPU, but
- * only if all other CPUs are already in dynticks-idle mode.  This will
- * allow the CPU cores to be powered down immediately, as opposed to after
- * waiting many milliseconds for grace periods to elapse.
+ * The idea is for the current CPU to clear out all work required by the
+ * RCU core for the current grace period, so that this CPU can be permitted
+ * to enter dyntick-idle mode.  In some cases, it will need to be awakened
+ * at the end of the grace period by whatever CPU ends the grace period.
+ * This allows CPUs to go dyntick-idle more quickly, and to reduce the
+ * number of wakeups by a modest integer factor.
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
  * invoke_rcu_core() to cause rcu_process_callbacks() to be invoked
  * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
+ *
+ * The caller must have disabled interrupts.
  */
-int rcu_needs_cpu(int cpu)
+static void rcu_prepare_for_idle(int cpu)
 {
 	int c = 0;
-	int snap;
-	int thatcpu;
 
-	/* Check for being in the holdoff period. */
-	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies)
-		return rcu_needs_cpu_quick_check(cpu);
-
-	/* Don't bother unless we are the last non-dyntick-idle CPU. */
-	for_each_online_cpu(thatcpu) {
-		if (thatcpu == cpu)
-			continue;
-		snap = atomic_add_return(0, &per_cpu(rcu_dynticks,
-						     thatcpu).dynticks);
-		smp_mb(); /* Order sampling of snap with end of grace period. */
-		if ((snap & 0x1) != 0) {
-			per_cpu(rcu_dyntick_drain, cpu) = 0;
-			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-			return rcu_needs_cpu_quick_check(cpu);
-		}
+	/* If no callbacks or in the holdoff period, enter dyntick-idle. */
+	if (!rcu_cpu_has_callbacks(cpu)) {
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		return;
 	}
+	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies)
+		return;
 
 	/* Check and update the rcu_dyntick_drain sequencing. */
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
@@ -2010,10 +2043,25 @@ int rcu_needs_cpu(int cpu)
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		return rcu_needs_cpu_quick_check(cpu);
+		if (!rcu_pending(cpu)) {
+			per_cpu(rcu_awake_at_gp_end, cpu) = 1;
+			return;  /* Nothing to do immediately. */
+		}
+		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
+		return;
 	}
 
-	/* Do one step pushing remaining RCU callbacks through. */
+	/*
+	 * Do one step of pushing the remaining RCU callbacks through
+	 * the RCU core state machine.
+	 */
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
+		rcu_preempt_qs(cpu);
+		force_quiescent_state(&rcu_preempt_state, 0);
+		c = c || per_cpu(rcu_preempt_data, cpu).nxtlist;
+	}
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
 		rcu_sched_qs(cpu);
 		force_quiescent_state(&rcu_sched_state, 0);
@@ -2028,7 +2076,51 @@ int rcu_needs_cpu(int cpu)
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
 	if (c)
 		invoke_rcu_core();
-	return c;
 }
 
+/*
+ * Wake up a CPU by invoking the RCU core.  Intended for use by
+ * rcu_wake_cpus_for_gp_end(), which passes this function to
+ * smp_call_function_single().
+ */
+static void rcu_wake_cpu(void *unused)
+{
+	invoke_rcu_core();
+}
+
+/*
+ * If an RCU grace period ended recently, scan the rcu_awake_at_gp_end
+ * per-CPU variables, and wake up any CPUs that requested a wakeup.
+ */
+static void rcu_wake_cpus_for_gp_end(void)
+{
+	int cpu;
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (!rdtp->wake_gp_end)
+		return;
+	rdtp->wake_gp_end = 0;
+	for_each_online_cpu(cpu) {
+		if (per_cpu(rcu_awake_at_gp_end, cpu)) {
+			per_cpu(rcu_awake_at_gp_end, cpu) = 0;
+			smp_call_function_single(cpu, rcu_wake_cpu, NULL, 0);
+		}
+	}
+}
+
+/*
+ * A grace period has just ended, and so we will need to awaken CPUs
+ * that now have work to do.  But we cannot send IPIs with interrupts
+ * disabled, so just set a flag so that this will happen upon exit
+ * from RCU core processing.
+ */
+static void rcu_schedule_wake_gp_end(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	rdtp->wake_gp_end = 1;
+}
+
+/* @@@ need tracing as well. */
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
-- 
1.7.3.2

