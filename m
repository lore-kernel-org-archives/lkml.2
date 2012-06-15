Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2FOSpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:45:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56540 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab2FOSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:45:06 -0400
Date: Fri, 15 Jun 2012 20:45:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20120615184500.GA11323@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: 4a1e001d2bb75c47a9cdbbfb66ae51daff1ddcba Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent

Most of the diffstat comes from the RCU slow boot regression 
fixes, but there's also a debuggability improvements/fixes.

 Thanks,

	Ingo

------------------>
Christian Borntraeger (1):
      spinlock: Indicate that a lockup is only suspected

Kyle McMartin (1):
      panic: Make panic_on_oops configurable

Paul E. McKenney (4):
      rcu: RCU_FAST_NO_HZ detection of callback adoption
      rcu: Update RCU_FAST_NO_HZ tracing for lazy callbacks
      rcu: Move RCU_FAST_NO_HZ per-CPU variables to rcu_dynticks structure
      rcu: Precompute RCU_FAST_NO_HZ timer offsets

Seiji Aguchi (1):
      kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after smp_send_stop()

Stephen Boyd (1):
      memblock: Document memblock_is_region_{memory,reserved}()


 include/linux/rcutiny.h    |   6 +-
 include/linux/rcutree.h    |   2 +-
 include/trace/events/rcu.h |   1 +
 kernel/panic.c             |   6 +-
 kernel/rcutree.c           |   2 +
 kernel/rcutree.h           |  14 ++++
 kernel/rcutree_plugin.h    | 165 ++++++++++++++++++++++++---------------------
 kernel/time/tick-sched.c   |   7 +-
 lib/Kconfig.debug          |  20 ++++++
 lib/spinlock_debug.c       |   2 +-
 mm/memblock.c              |  20 ++++++
 11 files changed, 160 insertions(+), 85 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index adb5e5a..854dc4c 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,8 +87,9 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
-static inline int rcu_needs_cpu(int cpu)
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return 0;
 }
 
@@ -96,8 +97,9 @@ static inline int rcu_needs_cpu(int cpu)
 
 int rcu_preempt_needs_cpu(void);
 
-static inline int rcu_needs_cpu(int cpu)
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return rcu_preempt_needs_cpu();
 }
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3c6083c..952b793 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -32,7 +32,7 @@
 
 extern void rcu_init(void);
 extern void rcu_note_context_switch(int cpu);
-extern int rcu_needs_cpu(int cpu);
+extern int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
 extern void rcu_cpu_stall_reset(void);
 
 /*
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 1480900..d274734 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -289,6 +289,7 @@ TRACE_EVENT(rcu_dyntick,
  *	"In holdoff": Nothing to do, holding off after unsuccessful attempt.
  *	"Begin holdoff": Attempt failed, don't retry until next jiffy.
  *	"Dyntick with callbacks": Entering dyntick-idle despite callbacks.
+ *	"Dyntick with lazy callbacks": Entering dyntick-idle w/lazy callbacks.
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
  *	"Timer": Timer fired to cause CPU to continue processing callbacks.
diff --git a/kernel/panic.c b/kernel/panic.c
index 8ed89a1..d2a5f4e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -27,7 +27,7 @@
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
 
-int panic_on_oops;
+int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
 static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
@@ -108,8 +108,6 @@ void panic(const char *fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
@@ -117,6 +115,8 @@ void panic(const char *fmt, ...)
 	 */
 	smp_send_stop();
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	bust_spinlocks(0);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0da7b88..3b0f133 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1397,6 +1397,8 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	rdp->qlen_lazy += rsp->qlen_lazy;
 	rdp->qlen += rsp->qlen;
 	rdp->n_cbs_adopted += rsp->qlen;
+	if (rsp->qlen_lazy != rsp->qlen)
+		rcu_idle_count_callbacks_posted();
 	rsp->qlen_lazy = 0;
 	rsp->qlen = 0;
 
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
index 2411000..5271a02 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1886,8 +1886,9 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
  * Because we not have RCU_FAST_NO_HZ, just check whether this CPU needs
  * any flavor of RCU.
  */
-int rcu_needs_cpu(int cpu)
+int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return rcu_cpu_has_callbacks(cpu);
 }
 
@@ -1962,41 +1963,6 @@ static void rcu_idle_count_callbacks_posted(void)
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
-/*
- * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
- * callbacks on this CPU, (2) this CPU has not yet attempted to enter
- * dyntick-idle mode, or (3) this CPU is in the process of attempting to
- * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
- * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
- * it is better to incur scheduling-clock interrupts than to spin
- * continuously for the same time duration!
- */
-int rcu_needs_cpu(int cpu)
-{
-	/* Flag a new idle sojourn to the idle-entry state machine. */
-	per_cpu(rcu_idle_first_pass, cpu) = 1;
-	/* If no callbacks, RCU doesn't need the CPU. */
-	if (!rcu_cpu_has_callbacks(cpu))
-		return 0;
-	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
-	return per_cpu(rcu_dyntick_holdoff, cpu) == jiffies;
-}
-
 /*
  * Does the specified flavor of RCU have non-lazy callbacks pending on
  * the specified CPU?  Both RCU flavor and CPU are specified by the
@@ -2040,6 +2006,47 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
 }
 
 /*
+ * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
+ * callbacks on this CPU, (2) this CPU has not yet attempted to enter
+ * dyntick-idle mode, or (3) this CPU is in the process of attempting to
+ * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
+ * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
+ * it is better to incur scheduling-clock interrupts than to spin
+ * continuously for the same time duration!
+ *
+ * The delta_jiffies argument is used to store the time when RCU is
+ * going to need the CPU again if it still has callbacks.  The reason
+ * for this is that rcu_prepare_for_idle() might need to post a timer,
+ * but if so, it will do so after tick_nohz_stop_sched_tick() has set
+ * the wakeup time for this CPU.  This means that RCU's timer can be
+ * delayed until the wakeup time, which defeats the purpose of posting
+ * a timer.
+ */
+int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+{
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	/* Flag a new idle sojourn to the idle-entry state machine. */
+	rdtp->idle_first_pass = 1;
+	/* If no callbacks, RCU doesn't need the CPU. */
+	if (!rcu_cpu_has_callbacks(cpu)) {
+		*delta_jiffies = ULONG_MAX;
+		return 0;
+	}
+	if (rdtp->dyntick_holdoff == jiffies) {
+		/* RCU recently tried and failed, so don't try again. */
+		*delta_jiffies = 1;
+		return 1;
+	}
+	/* Set up for the possibility that RCU will post a timer. */
+	if (rcu_cpu_has_nonlazy_callbacks(cpu))
+		*delta_jiffies = RCU_IDLE_GP_DELAY;
+	else
+		*delta_jiffies = RCU_IDLE_LAZY_GP_DELAY;
+	return 0;
+}
+
+/*
  * Handler for smp_call_function_single().  The only point of this
  * handler is to wake the CPU up, so the handler does only tracing.
  */
@@ -2075,21 +2082,24 @@ static void rcu_idle_gp_timer_func(unsigned long cpu_in)
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
 
@@ -2108,42 +2118,41 @@ static void rcu_cleanup_after_idle(int cpu)
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
@@ -2152,36 +2161,37 @@ static void rcu_prepare_for_idle(int cpu)
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
-		trace_rcu_prep_idle("Dyntick with callbacks");
-		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		if (rcu_cpu_has_nonlazy_callbacks(cpu))
-			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+		rdtp->dyntick_drain = 0;
+		rdtp->dyntick_holdoff = jiffies;
+		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
+			trace_rcu_prep_idle("Dyntick with callbacks");
+			rdtp->idle_gp_timer_expires =
 					   jiffies + RCU_IDLE_GP_DELAY;
-		else
-			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+		} else {
+			rdtp->idle_gp_timer_expires =
 					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
-		tp = &per_cpu(rcu_idle_gp_timer, cpu);
-		mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
-		per_cpu(rcu_nonlazy_posted_snap, cpu) =
-			per_cpu(rcu_nonlazy_posted, cpu);
+			trace_rcu_prep_idle("Dyntick with lazy callbacks");
+		}
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
@@ -2227,7 +2237,7 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_idle_count_callbacks_posted(void)
 {
-	__this_cpu_add(rcu_nonlazy_posted, 1);
+	__this_cpu_add(rcu_dynticks.nonlazy_posted, 1);
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
@@ -2238,11 +2248,12 @@ static void rcu_idle_count_callbacks_posted(void)
 
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
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index da70c6d..8699978 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -274,6 +274,7 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
+	unsigned long rcu_delta_jiffies;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
@@ -322,7 +323,7 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
-	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
+	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
 	    arch_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
@@ -330,6 +331,10 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 		/* Get the next timer wheel timer */
 		next_jiffies = get_next_timer_interrupt(last_jiffies);
 		delta_jiffies = next_jiffies - last_jiffies;
+		if (rcu_delta_jiffies < delta_jiffies) {
+			next_jiffies = last_jiffies + rcu_delta_jiffies;
+			delta_jiffies = rcu_delta_jiffies;
+		}
 	}
 	/*
 	 * Do not stop the tick, if we are only one off
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a42d3ae..ff5bdee 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -241,6 +241,26 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
+config PANIC_ON_OOPS
+	bool "Panic on Oops" if EXPERT
+	default n
+	help
+	  Say Y here to enable the kernel to panic when it oopses. This
+	  has the same effect as setting oops=panic on the kernel command
+	  line.
+
+	  This feature is useful to ensure that the kernel does not do
+	  anything erroneous after an oops which could result in data
+	  corruption or other issues.
+
+	  Say N if unsure.
+
+config PANIC_ON_OOPS_VALUE
+	int
+	range 0 1
+	default 0 if !PANIC_ON_OOPS
+	default 1 if PANIC_ON_OOPS
+
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index d0ec4f3..e91fbc2 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -118,7 +118,7 @@ static void __spin_lock_debug(raw_spinlock_t *lock)
 		/* lockup suspected: */
 		if (print_once) {
 			print_once = 0;
-			spin_dump(lock, "lockup");
+			spin_dump(lock, "lockup suspected");
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
 #endif
diff --git a/mm/memblock.c b/mm/memblock.c
index 952123e..32a0a5e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -867,6 +867,16 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
+/**
+ * memblock_is_region_memory - check if a region is a subset of memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) is a subset of a memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
@@ -879,6 +889,16 @@ int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size
 		 memblock.memory.regions[idx].size) >= end;
 }
 
+/**
+ * memblock_is_region_reserved - check if a region intersects reserved memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) intersects a reserved memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
 	memblock_cap_size(base, &size);
