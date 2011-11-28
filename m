Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1K1Xd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:33:26 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44562 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab1K1XdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 08/13] rcu: Eliminate RCU_FAST_NO_HZ grace-period hang
Date: Mon, 28 Nov 2011 15:33:00 -0800
Message-Id: <1322523185-456-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-1976-0000-0000-000006F05E4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

With the new implementation of RCU_FAST_NO_HZ, it was possible to hang
RCU grace periods as follows:

o	CPU 0 attempts to go idle, cycles several times through the
	rcu_prepare_for_idle() loop, then goes dyntick-idle when
	RCU needs nothing more from it, while still having at least
	on RCU callback pending.

o	CPU 1 goes idle with no callbacks.

Both CPUs can then stay in dyntick-idle mode indefinitely, preventing
the RCU grace period from ever completing, possibly hanging the system.

This commit therefore prevents CPUs that have RCU callbacks from entering
dyntick-idle mode.  This approach also eliminates the need for the
end-of-grace-period IPIs used previously.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |    1 -
 kernel/rcutree.c           |    2 -
 kernel/rcutree.h           |    3 --
 kernel/rcutree_plugin.h    |   78 +------------------------------------------
 4 files changed, 2 insertions(+), 82 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index debe453..8dd6fcb 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -287,7 +287,6 @@ TRACE_EVENT(rcu_dyntick,
  *
  *	"No callbacks": Nothing to do, no callbacks on this CPU.
  *	"In holdoff": Nothing to do, holding off after unsuccessful attempt.
- *	"Dyntick with callbacks": Callbacks remain, but RCU doesn't need CPU.
  *	"Begin holdoff": Attempt failed, don't retry until next jiffy.
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7fb8b0e..13fab4a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1086,7 +1086,6 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	 * callbacks are waiting on the grace period that just now
 	 * completed.
 	 */
-	rcu_schedule_wake_gp_end();
 	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
 		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
 
@@ -1672,7 +1671,6 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
-	rcu_wake_cpus_for_gp_end();
 	trace_rcu_utilization("End RCU core");
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index ea32405..70d8a55 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -88,7 +88,6 @@ struct rcu_dynticks {
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
-	int wake_gp_end;	    /* A GP ended, need to wake up CPUs. */
 };
 
 /* RCU's kthread states for tracing. */
@@ -469,7 +468,5 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
 static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
 static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle(int cpu);
-static void rcu_wake_cpus_for_gp_end(void);
-static void rcu_schedule_wake_gp_end(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c4daf1e..3d84dbc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1964,28 +1964,11 @@ static void rcu_prepare_for_idle(int cpu)
 {
 }
 
-/*
- * CPUs are never putting themselves to sleep with callbacks pending,
- * so there is no need to awaken them.
- */
-static void rcu_wake_cpus_for_gp_end(void)
-{
-}
-
-/*
- * CPUs are never putting themselves to sleep with callbacks pending,
- * so there is no need to schedule the act of awakening them.
- */
-static void rcu_schedule_wake_gp_end(void)
-{
-}
-
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #define RCU_NEEDS_CPU_FLUSHES 5
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
-static DEFINE_PER_CPU(bool, rcu_awake_at_gp_end);
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -2032,26 +2015,16 @@ static void rcu_prepare_for_idle(int cpu)
 	local_irq_save(flags);
 
 	/*
-	 * If there are no callbacks on this CPU or if RCU has no further
-	 * need for this CPU at the moment, enter dyntick-idle mode.
-	 * Also reset state so as to not prejudice later attempts.
+	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
+	 * Also reset state to avoid prejudicing later attempts.
 	 */
 	if (!rcu_cpu_has_callbacks(cpu)) {
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		per_cpu(rcu_awake_at_gp_end, cpu) = 0;
 		local_irq_restore(flags);
 		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
-	if (!rcu_pending(cpu)) {
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		per_cpu(rcu_awake_at_gp_end, cpu) = 1;
-		local_irq_restore(flags);
-		trace_rcu_prep_idle("Dyntick with callbacks");
-		return;  /* Nothing to do immediately. */
-	}
 
 	/*
 	 * If in holdoff mode, just return.  We will presumably have
@@ -2067,7 +2040,6 @@ static void rcu_prepare_for_idle(int cpu)
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* First time through, initialize the counter. */
 		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
-		per_cpu(rcu_awake_at_gp_end, cpu) = 0;
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
@@ -2113,50 +2085,4 @@ static void rcu_prepare_for_idle(int cpu)
 	}
 }
 
-/*
- * Wake up a CPU by invoking the RCU core.  Intended for use by
- * rcu_wake_cpus_for_gp_end(), which passes this function to
- * smp_call_function_single().
- */
-static void rcu_wake_cpu(void *unused)
-{
-	trace_rcu_prep_idle("CPU awakened at GP end");
-	invoke_rcu_core();
-}
-
-/*
- * If an RCU grace period ended recently, scan the rcu_awake_at_gp_end
- * per-CPU variables, and wake up any CPUs that requested a wakeup.
- */
-static void rcu_wake_cpus_for_gp_end(void)
-{
-	int cpu;
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
-
-	if (!rdtp->wake_gp_end)
-		return;
-	rdtp->wake_gp_end = 0;
-	for_each_online_cpu(cpu) {
-		if (per_cpu(rcu_awake_at_gp_end, cpu)) {
-			per_cpu(rcu_awake_at_gp_end, cpu) = 0;
-			smp_call_function_single(cpu, rcu_wake_cpu, NULL, 0);
-		}
-	}
-}
-
-/*
- * A grace period has just ended, and so we will need to awaken CPUs
- * that now have work to do.  But we cannot send IPIs with interrupts
- * disabled, so just set a flag so that this will happen upon exit
- * from RCU core processing.
- */
-static void rcu_schedule_wake_gp_end(void)
-{
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
-
-	rdtp->wake_gp_end = 1;
-}
-
-/* @@@ need tracing as well. */
-
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
-- 
1.7.3.2

