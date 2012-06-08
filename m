Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2FHE1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45621 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2FHE1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:07 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH rcu 3/8] rcu: Move RCU_FAST_NO_HZ per-CPU variables to rcu_dynticks structure
Date: Thu,  7 Jun 2012 21:26:50 -0700
Message-Id: <1339129615-1795-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
 <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-6148-0000-0000-00000685AAA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The RCU_FAST_NO_HZ code relies on a number of per-CPU variables.
This works, but is hidden from someone scanning the data structures
in rcutree.h.  This commit therefore converts these per-CPU variables
to fields in the per-CPU rcu_dynticks structures.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
---
 kernel/rcutree.h        |   14 +++++++
 kernel/rcutree_plugin.h |   99 +++++++++++++++++++++--------------------------
 2 files changed, 58 insertions(+), 55 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7f5d138..ea05649 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -84,6 +84,20 @@ struct rcu_dynticks {
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
+#ifdef CONFIG_RCU_FAST_NO_HZ
+	int dyntick_drain;	    /* Prepare-for-idle state variable. */
+	unsigned long dyntick_holdoff;
+				    /* No retries for the jiffy of failure. */
+	struct timer_list idle_gp_timer;
+				    /* Wake up CPU sleeping with callbacks. */
+	unsigned long idle_gp_timer_expires;
+				    /* When to wake up CPU (for repost). */
+	bool idle_first_pass;	    /* First pass of attempt to go idle? */
+	unsigned long nonlazy_posted;
+				    /* # times non-lazy CBs posted to CPU. */
+	unsigned long nonlazy_posted_snap;
+				    /* idle-period nonlazy_posted snapshot. */
+#endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 };
 
 /* RCU's kthread states for tracing. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5449f02..6bd9637 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1962,21 +1962,6 @@ static void rcu_idle_count_callbacks_posted(void)
 #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
-/* Loop counter for rcu_prepare_for_idle(). */
-static DEFINE_PER_CPU(int, rcu_dyntick_drain);
-/* If rcu_dyntick_holdoff==jiffies, don't try to enter dyntick-idle mode. */
-static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
-/* Timer to awaken the CPU if it enters dyntick-idle mode with callbacks. */
-static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
-/* Scheduled expiry time for rcu_idle_gp_timer to allow reposting. */
-static DEFINE_PER_CPU(unsigned long, rcu_idle_gp_timer_expires);
-/* Enable special processing on first attempt to enter dyntick-idle mode. */
-static DEFINE_PER_CPU(bool, rcu_idle_first_pass);
-/* Running count of non-lazy callbacks posted, never decremented. */
-static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted);
-/* Snapshot of rcu_nonlazy_posted to detect meaningful exits from idle. */
-static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);
-
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
  * callbacks on this CPU, (2) this CPU has not yet attempted to enter
@@ -1988,13 +1973,15 @@ static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);
  */
 int rcu_needs_cpu(int cpu)
 {
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
 	/* Flag a new idle sojourn to the idle-entry state machine. */
-	per_cpu(rcu_idle_first_pass, cpu) = 1;
+	rdtp->idle_first_pass = 1;
 	/* If no callbacks, RCU doesn't need the CPU. */
 	if (!rcu_cpu_has_callbacks(cpu))
 		return 0;
 	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
-	return per_cpu(rcu_dyntick_holdoff, cpu) == jiffies;
+	return rdtp->dyntick_holdoff == jiffies;
 }
 
 /*
@@ -2075,21 +2062,24 @@ static void rcu_idle_gp_timer_func(unsigned long cpu_in)
  */
 static void rcu_prepare_for_idle_init(int cpu)
 {
-	per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-	setup_timer(&per_cpu(rcu_idle_gp_timer, cpu),
-		    rcu_idle_gp_timer_func, cpu);
-	per_cpu(rcu_idle_gp_timer_expires, cpu) = jiffies - 1;
-	per_cpu(rcu_idle_first_pass, cpu) = 1;
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	rdtp->dyntick_holdoff = jiffies - 1;
+	setup_timer(&rdtp->idle_gp_timer, rcu_idle_gp_timer_func, cpu);
+	rdtp->idle_gp_timer_expires = jiffies - 1;
+	rdtp->idle_first_pass = 1;
 }
 
 /*
  * Clean up for exit from idle.  Because we are exiting from idle, there
- * is no longer any point to rcu_idle_gp_timer, so cancel it.  This will
+ * is no longer any point to ->idle_gp_timer, so cancel it.  This will
  * do nothing if this timer is not active, so just cancel it unconditionally.
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	del_timer(&per_cpu(rcu_idle_gp_timer, cpu));
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	del_timer(&rdtp->idle_gp_timer);
 	trace_rcu_prep_idle("Cleanup after idle");
 }
 
@@ -2108,42 +2098,41 @@ static void rcu_cleanup_after_idle(int cpu)
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
  * invoke_rcu_core() to cause rcu_process_callbacks() to be invoked
- * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
+ * later.  The ->dyntick_drain field controls the sequencing.
  *
  * The caller must have disabled interrupts.
  */
 static void rcu_prepare_for_idle(int cpu)
 {
 	struct timer_list *tp;
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 
 	/*
 	 * If this is an idle re-entry, for example, due to use of
 	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
 	 * loop, then don't take any state-machine actions, unless the
 	 * momentary exit from idle queued additional non-lazy callbacks.
-	 * Instead, repost the rcu_idle_gp_timer if this CPU has callbacks
+	 * Instead, repost the ->idle_gp_timer if this CPU has callbacks
 	 * pending.
 	 */
-	if (!per_cpu(rcu_idle_first_pass, cpu) &&
-	    (per_cpu(rcu_nonlazy_posted, cpu) ==
-	     per_cpu(rcu_nonlazy_posted_snap, cpu))) {
+	if (!rdtp->idle_first_pass &&
+	    (rdtp->nonlazy_posted == rdtp->nonlazy_posted_snap)) {
 		if (rcu_cpu_has_callbacks(cpu)) {
-			tp = &per_cpu(rcu_idle_gp_timer, cpu);
-			mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
+			tp = &rdtp->idle_gp_timer;
+			mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
 		}
 		return;
 	}
-	per_cpu(rcu_idle_first_pass, cpu) = 0;
-	per_cpu(rcu_nonlazy_posted_snap, cpu) =
-		per_cpu(rcu_nonlazy_posted, cpu) - 1;
+	rdtp->idle_first_pass = 0;
+	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted - 1;
 
 	/*
 	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
 	 * Also reset state to avoid prejudicing later attempts.
 	 */
 	if (!rcu_cpu_has_callbacks(cpu)) {
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-		per_cpu(rcu_dyntick_drain, cpu) = 0;
+		rdtp->dyntick_holdoff = jiffies - 1;
+		rdtp->dyntick_drain = 0;
 		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
@@ -2152,38 +2141,37 @@ static void rcu_prepare_for_idle(int cpu)
 	 * If in holdoff mode, just return.  We will presumably have
 	 * refrained from disabling the scheduling-clock tick.
 	 */
-	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
+	if (rdtp->dyntick_holdoff == jiffies) {
 		trace_rcu_prep_idle("In holdoff");
 		return;
 	}
 
-	/* Check and update the rcu_dyntick_drain sequencing. */
-	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+	/* Check and update the ->dyntick_drain sequencing. */
+	if (rdtp->dyntick_drain <= 0) {
 		/* First time through, initialize the counter. */
-		per_cpu(rcu_dyntick_drain, cpu) = RCU_IDLE_FLUSHES;
-	} else if (per_cpu(rcu_dyntick_drain, cpu) <= RCU_IDLE_OPT_FLUSHES &&
+		rdtp->dyntick_drain = RCU_IDLE_FLUSHES;
+	} else if (rdtp->dyntick_drain <= RCU_IDLE_OPT_FLUSHES &&
 		   !rcu_pending(cpu) &&
 		   !local_softirq_pending()) {
 		/* Can we go dyntick-idle despite still having callbacks? */
-		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
+		rdtp->dyntick_drain = 0;
+		rdtp->dyntick_holdoff = jiffies;
 		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
 			trace_rcu_prep_idle("Dyntick with callbacks");
-			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+			rdtp->idle_gp_timer_expires =
 					   jiffies + RCU_IDLE_GP_DELAY;
 		} else {
-			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+			rdtp->idle_gp_timer_expires =
 					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
 			trace_rcu_prep_idle("Dyntick with lazy callbacks");
 		}
-		tp = &per_cpu(rcu_idle_gp_timer, cpu);
-		mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
-		per_cpu(rcu_nonlazy_posted_snap, cpu) =
-			per_cpu(rcu_nonlazy_posted, cpu);
+		tp = &rdtp->idle_gp_timer;
+		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
+		rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
 		return; /* Nothing more to do immediately. */
-	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+	} else if (--(rdtp->dyntick_drain) <= 0) {
 		/* We have hit the limit, so time to give up. */
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
+		rdtp->dyntick_holdoff = jiffies;
 		trace_rcu_prep_idle("Begin holdoff");
 		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
 		return;
@@ -2229,7 +2217,7 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_idle_count_callbacks_posted(void)
 {
-	__this_cpu_add(rcu_nonlazy_posted, 1);
+	__this_cpu_add(rcu_dynticks.nonlazy_posted, 1);
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
@@ -2240,11 +2228,12 @@ static void rcu_idle_count_callbacks_posted(void)
 
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
-	struct timer_list *tltp = &per_cpu(rcu_idle_gp_timer, cpu);
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct timer_list *tltp = &rdtp->idle_gp_timer;
 
 	sprintf(cp, "drain=%d %c timer=%lu",
-		per_cpu(rcu_dyntick_drain, cpu),
-		per_cpu(rcu_dyntick_holdoff, cpu) == jiffies ? 'H' : '.',
+		rdtp->dyntick_drain,
+		rdtp->dyntick_holdoff == jiffies ? 'H' : '.',
 		timer_pending(tltp) ? tltp->expires - jiffies : -1);
 }
 
-- 
1.7.8

