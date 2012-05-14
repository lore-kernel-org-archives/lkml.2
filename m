Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2ENWdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:33:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60307 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2ENWdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:33:03 -0400
Date: Mon, 14 May 2012 15:32:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120514223255.GA5719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
 <20120428034257.GA2495@linux.vnet.ibm.com>
 <20120501000245.GA4329@linux.vnet.ibm.com>
 <4F9FA50C.9070600@wanadoo.fr>
 <20120501154513.GD2441@linux.vnet.ibm.com>
 <4FA3EAEE.9030601@wanadoo.fr>
 <20120504150411.GC2411@linux.vnet.ibm.com>
 <4FA44CF9.7050604@wanadoo.fr>
 <20120504231442.GT2411@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120504231442.GT2411@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051422-7282-0000-0000-000009070666
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 04:14:42PM -0700, Paul E. McKenney wrote:
> On Fri, May 04, 2012 at 11:41:13PM +0200, Pascal Chapperon wrote:
> > Le 04/05/2012 17:04, Paul E. McKenney a écrit :
> > >On Fri, May 04, 2012 at 04:42:54PM +0200, Pascal Chapperon wrote:
> > >>Le 01/05/2012 17:45, Paul E. McKenney a écrit :
> > >>
> > >>>Here is my RCU_FAST_NO_HZ patch stack on top of v3.4-rc4.
> > >>>
> > >>>Or you can pull branch fnh.2012.05.01a from:
> > >>>
> > >>>	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> > >>>
> > >>>							Thanx, Paul
> > >>>
> > >>I applied your global patch on top of v3.4-rc4. But the slowdown is
> > >>worse than before : boot sequence took 80s instead 20-30s (12s for
> > >>initramfs instead of 2s).
> > >>
> > >>I'll send you rcu tracing log in a second mail.
> > >
> > >Hmmm...  Well, I guess I am glad that I finally did something that
> > >had an effect, but I sure wish that the effect had been in the other
> > >direction!
> > >
> > >Just to make sure I understand: the difference between the 20-30s and
> > >the 80s is exactly the patch I sent you?
> > >
> > >							Thanx, Paul
> > >
> > >
> > Yes. Exactly same kernel config as in previous results, I applied
> > your patch against v3.4-rc4, and sorry, the result is exactly what I
> > said;
> > I saw that your global patch was quite huge, and addresses things which
> > are not directly related with the initial patch (commit
> > 7cb92499000e3c86dae653077b1465458a039ef6); maybe a side effect?
> > 
> > However, I'm ready to try this patch on my smaller laptop which
> > supports well CONFIG_FAST_NO_HZ=y and systemd, if you think it can
> > help ?
> > 
> > Another thought: this issue as nothing to do with i7 Hyper-threading
> > capacities ? (as I test core2duo, Pentium ulv in same conditions and I
> > don't encountered any slowdown ?)
> 
> Well, one possibility is that your setup starts the jiffies counter
> at some interesting value.  The attached patch (also against v3.4-rc4)
> applies a bit more paranoia to the initialization to handle this
> and other possibilities.

This patchset fixes the problem where RCU_FAST_NO_HZ's timers were
being ignored due to the dyntick-idle code having already calculated
the CPU's wakeup time (which I sent earlier, mistakenly offlist), but
also fixes a botched check in my workaround.

Could you please try it out?  This patch is against 3.4-rc4.

							Thanx, Paul

------------------------------------------------------------------------

 include/linux/rcutiny.h    |    6 -
 include/linux/rcutree.h    |    2 
 include/trace/events/rcu.h |    3 
 kernel/rcutiny_plugin.h    |    2 
 kernel/rcutree.c           |    6 -
 kernel/rcutree.h           |   15 +++
 kernel/rcutree_plugin.h    |  213 ++++++++++++++++++++++++++++++---------------
 kernel/time/tick-sched.c   |    7 +
 8 files changed, 179 insertions(+), 75 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e93df77..56048bc 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -95,8 +95,9 @@ static inline void exit_rcu(void)
 {
 }
 
-static inline int rcu_needs_cpu(int cpu)
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return 0;
 }
 
@@ -106,8 +107,9 @@ void rcu_preempt_note_context_switch(void);
 extern void exit_rcu(void);
 int rcu_preempt_needs_cpu(void);
 
-static inline int rcu_needs_cpu(int cpu)
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return rcu_preempt_needs_cpu();
 }
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e8ee5dd..06b1939 100644
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
index 3370997..d274734 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -289,9 +289,12 @@ TRACE_EVENT(rcu_dyntick,
  *	"In holdoff": Nothing to do, holding off after unsuccessful attempt.
  *	"Begin holdoff": Attempt failed, don't retry until next jiffy.
  *	"Dyntick with callbacks": Entering dyntick-idle despite callbacks.
+ *	"Dyntick with lazy callbacks": Entering dyntick-idle w/lazy callbacks.
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
  *	"Timer": Timer fired to cause CPU to continue processing callbacks.
+ *	"Demigrate": Timer fired on wrong CPU, woke up correct CPU.
+ *	"Cleanup after idle": Idle exited, timer canceled.
  */
 TRACE_EVENT(rcu_prep_idle,
 
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..f3b995a 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -846,8 +846,6 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
  */
 int rcu_preempt_needs_cpu(void)
 {
-	if (!rcu_preempt_running_reader())
-		rcu_preempt_cpu_qs();
 	return rcu_preempt_ctrlblk.rcb.rcucblist != NULL;
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1050d6d..38300c0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -349,7 +349,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
-		ftrace_dump(DUMP_ALL);
+		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
@@ -459,7 +459,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 
 		trace_rcu_dyntick("Error on exit: not idle task",
 				  oldval, rdtp->dynticks_nesting);
-		ftrace_dump(DUMP_ALL);
+		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
@@ -1829,6 +1829,8 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->qlen++;
 	if (lazy)
 		rdp->qlen_lazy++;
+	else
+		rcu_idle_count_callbacks_posted();
 
 	if (__is_kfree_rcu_offset((unsigned long)func))
 		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cdd1be0..7e914db 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -88,6 +88,20 @@ struct rcu_dynticks {
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
@@ -471,6 +485,7 @@ static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
+static void rcu_idle_count_callbacks_posted(void);
 static void print_cpu_stall_info_begin(void);
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..7eef245 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1910,8 +1910,9 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
  * Because we not have RCU_FAST_NO_HZ, just check whether this CPU needs
  * any flavor of RCU.
  */
-int rcu_needs_cpu(int cpu)
+int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return rcu_cpu_has_callbacks(cpu);
 }
 
@@ -1938,6 +1939,14 @@ static void rcu_prepare_for_idle(int cpu)
 {
 }
 
+/*
+ * Don't bother keeping a running count of the number of RCU callbacks
+ * posted because CONFIG_RCU_FAST_NO_HZ=n.
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+}
+
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 /*
@@ -1978,30 +1987,6 @@ static void rcu_prepare_for_idle(int cpu)
 #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
-static DEFINE_PER_CPU(int, rcu_dyntick_drain);
-static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
-static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
-static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
-static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
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
@@ -2045,16 +2030,75 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
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
+ * Handler for smp_call_function_single().  The only point of this
+ * handler is to wake the CPU up, so the handler does only tracing.
+ */
+void rcu_idle_demigrate(void *unused)
+{
+	trace_rcu_prep_idle("Demigrate");
+}
+
+/*
  * Timer handler used to force CPU to start pushing its remaining RCU
  * callbacks in the case where it entered dyntick-idle mode with callbacks
  * pending.  The hander doesn't really need to do anything because the
  * real work is done upon re-entry to idle, or by the next scheduling-clock
  * interrupt should idle not be re-entered.
+ *
+ * One special case: the timer gets migrated without awakening the CPU
+ * on which the timer was scheduled on.  In this case, we must wake up
+ * that CPU.  We do so with smp_call_function_single().
  */
-static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
+static void rcu_idle_gp_timer_func(unsigned long cpu_in)
 {
+	int cpu = (int)cpu_in;
+
 	trace_rcu_prep_idle("Timer");
-	return HRTIMER_NORESTART;
+	if (cpu != smp_processor_id())
+		smp_call_function_single(cpu, rcu_idle_demigrate, NULL, 0);
+	else
+		WARN_ON_ONCE(1); /* Getting here can hang the system... */
 }
 
 /*
@@ -2062,29 +2106,25 @@ static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
  */
 static void rcu_prepare_for_idle_init(int cpu)
 {
-	static int firsttime = 1;
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 
-	hrtimer_init(hrtp, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtp->function = rcu_idle_gp_timer_func;
-	if (firsttime) {
-		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
-
-		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
-		upj = jiffies_to_usecs(RCU_IDLE_LAZY_GP_DELAY);
-		rcu_idle_lazy_gp_wait = ns_to_ktime(upj * (u64)1000);
-		firsttime = 0;
-	}
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
-	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	del_timer(&rdtp->idle_gp_timer);
+	trace_rcu_prep_idle("Cleanup after idle");
 }
 
 /*
@@ -2102,19 +2142,41 @@ static void rcu_cleanup_after_idle(int cpu)
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
+	struct timer_list *tp;
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	/*
+	 * If this is an idle re-entry, for example, due to use of
+	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
+	 * loop, then don't take any state-machine actions, unless the
+	 * momentary exit from idle queued additional non-lazy callbacks.
+	 * Instead, repost the ->idle_gp_timer if this CPU has callbacks
+	 * pending.
+	 */
+	if (!rdtp->idle_first_pass &&
+	    (rdtp->nonlazy_posted == rdtp->nonlazy_posted_snap)) {
+		if (rcu_cpu_has_callbacks(cpu)) {
+			tp = &rdtp->idle_gp_timer;
+			mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
+		}
+		return;
+	}
+	rdtp->idle_first_pass = 0;
+	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted - 1;
+
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
@@ -2123,32 +2185,37 @@ static void rcu_prepare_for_idle(int cpu)
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
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
-		else
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_lazy_gp_wait, HRTIMER_MODE_REL);
+		rdtp->dyntick_drain = 0;
+		rdtp->dyntick_holdoff = jiffies;
+		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
+			trace_rcu_prep_idle("Dyntick with callbacks");
+			rdtp->idle_gp_timer_expires =
+					   jiffies + RCU_IDLE_GP_DELAY;
+		} else {
+			rdtp->idle_gp_timer_expires =
+					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
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
@@ -2184,6 +2251,19 @@ static void rcu_prepare_for_idle(int cpu)
 		trace_rcu_prep_idle("Callbacks drained");
 }
 
+/*
+ * Keep a running count of the number of non-lazy callbacks posted
+ * on this CPU.  This running counter (which is never decremented) allows
+ * rcu_prepare_for_idle() to detect when something out of the idle loop
+ * posts a callback, even if an equal number of callbacks are invoked.
+ * Of course, callbacks should only be posted from within a trace event
+ * designed to be called from idle or from within RCU_NONIDLE().
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+	__this_cpu_add(rcu_dynticks.nonlazy_posted, 1);
+}
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #ifdef CONFIG_RCU_CPU_STALL_INFO
@@ -2192,14 +2272,13 @@ static void rcu_prepare_for_idle(int cpu)
 
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct timer_list *tltp = &rdtp->idle_gp_timer;
 
-	sprintf(cp, "drain=%d %c timer=%lld",
-		per_cpu(rcu_dyntick_drain, cpu),
-		per_cpu(rcu_dyntick_holdoff, cpu) == jiffies ? 'H' : '.',
-		hrtimer_active(hrtp)
-			? ktime_to_us(hrtimer_get_remaining(hrtp))
-			: -1);
+	sprintf(cp, "drain=%d %c timer=%lu",
+		rdtp->dyntick_drain,
+		rdtp->dyntick_holdoff == jiffies ? 'H' : '.',
+		timer_pending(tltp) ? tltp->expires - jiffies : -1);
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6a3a5b9..52f5ebb 100644
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

