Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab1I3TY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:24:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:32783 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab1I3TYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:24:55 -0400
Date: Fri, 30 Sep 2011 12:24:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110930192438.GA7505@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110927121648.GK18553@somewhere>
 <20110927180142.GD2335@linux.vnet.ibm.com>
 <20110928123116.GP18553@somewhere>
 <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930152946.GA2397@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:29:46AM -0700, Paul E. McKenney wrote:
> On Fri, Sep 30, 2011 at 03:11:09PM +0200, Frederic Weisbecker wrote:
> > On Thu, Sep 29, 2011 at 10:12:05AM -0700, Paul E. McKenney wrote:
> > > On Thu, Sep 29, 2011 at 02:30:44PM +0200, Frederic Weisbecker wrote:
> > > > I was thinking about the fact that idle is a caller of rcu_enter_nohz().
> > > > And there may be more callers of it in the future. So I thought it may
> > > > be better to keep rcu_enter_nohz() idle-agnostic.
> > > > 
> > > > But it's fine, there are other ways to call rcu_idle_enter()/rcu_idle_exit()
> > > > from the right places other than from rcu_enter/exit_nohz().
> > > > We have tick_check_idle() on irq entry and tick_nohz_irq_exit(), both are called
> > > > on the first interrupt level in idle.
> > > > 
> > > > So I can change that easily for the nohz cpusets.
> > > 
> > > Heh!  From what I can see, we were both wrong!
> > > 
> > > My thought at this point is to make it so that rcu_enter_nohz() and
> > > rcu_exit_nohz() are renamed to rcu_enter_idle() and rcu_exit_idle()
> > > respectively.  I drop the per-CPU variable and the added functions
> > > from one of my patches.  These functions, along with rcu_irq_enter(),
> > > rcu_irq_exit(), rcu_nmi_enter(), and rcu_nmi_exit(), are moved out from
> > > under CONFIG_NO_HZ.  This allows these functions to track idle state
> > > regardless of the setting of CONFIG_NO_HZ.  It also separates the state
> > > of the scheduling-clock tick from RCU's view of CPU idleness, which
> > > simplifies things.
> > > 
> > > I will put something together along these lines.
> > 
> > Should I wait for your updated patch before rebasing?
> 
> Gah!!!  I knew I was forgetting something!  I will get that out.
> 
> > > > > > > The problem I have with this is that it is rcu_enter_nohz() that tracks
> > > > > > > the irq nesting required to correctly decide whether or not we are going
> > > > > > > to really go to idle state.  Furthermore, there are cases where we
> > > > > > > do enter idle but do not enter nohz, and that has to be handled correctly
> > > > > > > as well.
> > > > > > > 
> > > > > > > Now, it is quite possible that I am suffering a senior moment and just
> > > > > > > failing to see how to structure this in the design where rcu_idle_enter()
> > > > > > > invokes rcu_enter_nohz(), but regardless, I am failing to see how to
> > > > > > > structure this so that it works correctly.
> > > > > > > 
> > > > > > > Please feel free to enlighten me!
> > > > > > 
> > > > > > Ah I realize that you want to call rcu_idle_exit() when we enter
> > > > > > the first level interrupt and rcu_idle_enter() when we exit it
> > > > > > to return to idle loop.
> > > > > > 
> > > > > > But we use that check:
> > > > > > 
> > > > > > 	if (user ||
> > > > > > 	    (rcu_is_cpu_idle() &&
> > > > > >  	     !in_softirq() &&
> > > > > >  	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
> > > > > >  		rcu_sched_qs(cpu);
> > > > > > 
> > > > > > So we ensure that by the time we call rcu_check_callbacks(), we are not nesting
> > > > > > in another interrupt.
> > > > > 
> > > > > But I would like to enable checks for entering/exiting idle while
> > > > > within an RCU read-side critical section. The idea is to move
> > > > > the checks from their currently somewhat problematic location in
> > > > > rcu_needs_cpu_quick_check() to somewhere more sensible.  My current
> > > > > thought is to move them rcu_enter_nohz() and rcu_exit_nohz() near the
> > > > > calls to rcu_idle_enter() and rcu_idle_exit(), respectively.
> > > > 
> > > > So, checking if we are calling rcu_idle_enter() while in an RCU
> > > > read side critical section?
> > > > 
> > > > But we already have checks that RCU read side API are not called in
> > > > extended quiescent state.
> > > 
> > > Both checks are good.  The existing checks catch this kind of error:
> > > 
> > > 1.	CPU 0 goes idle, entering an RCU extended quiescent state.
> > > 2.	CPU 0 illegally enters an RCU read-side critical section.
> > > 
> > > The new check catches this kind of error:
> > > 
> > > 1.	CPU 0 enters an RCU read-side critical section.
> > > 2.	CPU 0 goes idle, entering an RCU extended quiescent state,
> > > 	but illegally so because it is still in an RCU read-side
> > > 	critical section.
> > 
> > Right.
> > 
> > > 
> > > > > This would mean that they operated only in NO_HZ kernels with lockdep
> > > > > enabled, but I am good with that because to do otherwise would require
> > > > > adding nesting-level counters to the non-NO_HZ case, which I would like
> > > > > to avoid, expecially for TINY_RCU.
> > > 
> > > And my reworking of RCU's NO_HZ code to instead be idle code removes
> > > the NO_HZ-only restriction.  Getting rid of the additional per-CPU
> > > variable reduces the TINY_RCU overhead to acceptable levels.
> > > 
> > > > There can be a secondary check in rcu_read_lock_held() and friends to
> > > > ensures that rcu_is_idle_cpu(). In the non-NO_HZ case it's useful to
> > > > find similar issues.
> > > > 
> > > > In fact we could remove the check for rcu_extended_qs() in read side
> > > > APIs and check instead rcu_is_idle_cpu(). That would work in any
> > > > config and not only NO_HZ.
> > > > 
> > > > But I hope we can actually keep the check for RCU extended quiescent
> > > > state so that when rcu_enter_nohz() is called from other places than
> > > > idle, we are ready for it.
> > > > 
> > > > I believe it's fine to have both checks in PROVE_RCU.
> > > 
> > > Agreed, I have not yet revisited rcu_extended_qs(), but some change
> > > might be useful.
> > 
> > Yep.
> > 
> > > > > OK, my current plans are to start forward-porting to -rc8, and I would
> > > > > like to have this pair of delta patches or something like them pulled
> > > > > into your stack.
> > > > 
> > > > Sure I can take your patches (I'm going to merge the delta into the first).
> > > > But if you want a rebase against -rc8, it's going to be easier if you
> > > > do that rebase on the branch you want me to work on. Then I work on top
> > > > of it.
> > > > 
> > > > For example we can take your rcu/dynticks, rewind to
> > > > "rcu: Make synchronize_sched_expedited() better at work sharing"
> > > > 771c326f20029a9f30b9a58237c9a5d5ddc1763d, rebase on top of -rc8
> > > > and I rebase my patches (yours included) on top of it and I repost.
> > > > 
> > > > Right?
> > > 
> > > Yep!  Your earlier three patches look to need some extended-quiescent-state
> > > rework as well:
> > > 
> > > b5566f3d: Detect illegal rcu dereference in extended quiescent state
> > > ee05e5a4: Inform the user about dynticks-idle mode on PROVE_RCU warning
> > > fa5d22cf: Warn when rcu_read_lock() is used in extended quiescent state
> > > 
> > > So I will leave these out and let you rebase them.
> > 
> > Fine. Just need to know if they need an update against a patch from you
> > that is to come or something.
> 
> I am on it, apologies for the delay!

And here is a first cut, probably totally broken, but a start.

With this change, I am wondering about tick_nohz_stop_sched_tick()'s
invocation of rcu_idle_enter() -- this now needs to be called regardless
of whether or not tick_nohz_stop_sched_tick() actually stops the tick.
Except that if tick_nohz_stop_sched_tick() is invoked with inidle==0,
it looks like we should -not- call rcu_idle_enter().

I eventually just left the rcu_idle_enter() calls in their current
places due to paranoia about messing up and ending up with unbalanced
rcu_idle_enter() and rcu_idle_exit() calls.  Any thoughts on how to
make this work better?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Track idleness independent of idle tasks

Earlier versions of RCU used the scheduling-clock tick to detect idleness
by checking for the idle task, but handled idleness differently for
CONFIG_NO_HZ=y.  But there are now a number of uses of RCU read-side
critical sections in the idle task, for example, for tracing.  A more
fine-grained detection of idleness is therefore required.

This commit presses the old dyntick-idle code into full-time service,
so that calls to rcu_idle_enter(), previously known as rcu_enter_nohz(),
is always invoked at the beginning of an idle loop iteration.  Similarly,
rcu_idle_exit(), previously known as rcu_exit_nohz(), is always invoked at
the end of an idle-loop iteration.  This allows the idle task to use RCU
everywhere except between consecutive rcu_idle_enter() and rcu_idle_exit()
calls, in turn allowing architecture maintainers to specify where it is
permissible to use RCU.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index aaf65f6..49587ab 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -105,14 +105,10 @@ o	"dt" is the current value of the dyntick counter that is incremented
 	or one greater than the interrupt-nesting depth otherwise.
 	The number after the second "/" is the NMI nesting depth.
 
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
 o	"df" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being in
 	dynticks-idle state.
 
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
 o	"of" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being
 	offline.  In a perfect world, this might never happen, but it
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index f743883..bb7f309 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -139,20 +139,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
-#if defined(CONFIG_NO_HZ)
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-static inline void rcu_irq_enter(void)
-{
-	rcu_exit_nohz();
-}
-
-static inline void rcu_irq_exit(void)
-{
-	rcu_enter_nohz();
-}
 
 static inline void rcu_nmi_enter(void)
 {
@@ -163,17 +150,9 @@ static inline void rcu_nmi_exit(void)
 }
 
 #else
-extern void rcu_irq_enter(void);
-extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
 extern void rcu_nmi_exit(void);
 #endif
-#else
-# define rcu_irq_enter() do { } while (0)
-# define rcu_irq_exit() do { } while (0)
-# define rcu_nmi_enter() do { } while (0)
-# define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2cf4226..a90a850 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -177,23 +177,8 @@ extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
-
-#ifdef CONFIG_NO_HZ
-
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-#else /* #ifdef CONFIG_NO_HZ */
-
-static inline void rcu_enter_nohz(void)
-{
-}
-
-static inline void rcu_exit_nohz(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_NO_HZ */
+extern void rcu_idle_enter(void);
+extern void rcu_idle_exit(void);
 
 /*
  * Infrastructure to implement the synchronize_() primitives in
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..35d2ffc 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -127,8 +127,14 @@ extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_stop_sched_tick(int inidle) { }
-static inline void tick_nohz_restart_sched_tick(void) { }
+static inline void tick_nohz_stop_sched_tick(int inidle)
+{
+	rcu_idle_enter();
+}
+static inline void tick_nohz_restart_sched_tick(void)
+{
+	rcu_idle_exit();
+}
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index da775c8..8b9b9d3 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -54,31 +54,47 @@ static void __call_rcu(struct rcu_head *head,
 
 #include "rcutiny_plugin.h"
 
-#ifdef CONFIG_NO_HZ
-
 static long rcu_dynticks_nesting = 1;
 
 /*
- * Enter dynticks-idle mode, which is an extended quiescent state
- * if we have fully entered that mode (i.e., if the new value of
- * dynticks_nesting is zero).
+ * Enter idle, which is an extended quiescent state if we have fully
+ * entered that mode (i.e., if the new value of dynticks_nesting is zero).
  */
-void rcu_enter_nohz(void)
+void rcu_idle_enter(void)
 {
 	if (--rcu_dynticks_nesting == 0)
 		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 }
 
 /*
- * Exit dynticks-idle mode, so that we are no longer in an extended
- * quiescent state.
+ * Exit idle, so that we are no longer in an extended quiescent state.
  */
-void rcu_exit_nohz(void)
+void rcu_idle_exit(void)
 {
 	rcu_dynticks_nesting++;
 }
 
-#endif /* #ifdef CONFIG_NO_HZ */
+#ifdef CONFIG_PROVE_RCU
+
+/*
+ * Test whether the current CPU is idle.
+ */
+int rcu_is_cpu_idle(void)
+{
+	return !rcu_dynticks_nesting;
+}
+
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
+/*
+ * Test whether the current CPU was interrupted from idle.  Nested
+ * interrupts don't count, we must be running at the first interrupt
+ * level.
+ */
+int rcu_is_cpu_rrupt_from_idle(void)
+{
+	return rcu_dynticks_nesting <= 0;
+}
 
 /*
  * Helper function for rcu_sched_qs() and rcu_bh_qs().
@@ -131,10 +147,7 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	if (user ||
-	    (idle_cpu(cpu) &&
-	     !in_softirq() &&
-	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
+	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
 		rcu_bh_qs(cpu);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index cb7c46e..56cc18f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -195,12 +195,10 @@ void rcu_note_context_switch(int cpu)
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
-#ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
 	.dynticks = ATOMIC_INIT(1),
 };
-#endif /* #ifdef CONFIG_NO_HZ */
 
 static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
@@ -328,11 +326,11 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* If preemptible RCU, no point in sending reschedule IPI. */
-	if (rdp->preemptible)
-		return 0;
-
-	/* The CPU is online, so send it a reschedule IPI. */
+	/*
+	 * The CPU is online, so send it a reschedule IPI.  This forces
+	 * it through the scheduler, and (inefficiently) also handles cases
+	 * where idle loops fail to inform RCU about the CPU being idle.
+	 */
 	if (rdp->cpu != smp_processor_id())
 		smp_send_reschedule(rdp->cpu);
 	else
@@ -343,17 +341,15 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
-#ifdef CONFIG_NO_HZ
-
 /**
- * rcu_enter_nohz - inform RCU that current CPU is entering nohz
+ * rcu_idle_enter - inform RCU that current CPU is entering idle
  *
- * Enter nohz mode, in other words, -leave- the mode in which RCU
+ * Enter idle mode, in other words, -leave- the mode in which RCU
  * read-side critical sections can occur.  (Though RCU read-side
- * critical sections can occur in irq handlers in nohz mode, a possibility
+ * critical sections can occur in irq handlers in idle, a possibility
  * handled by rcu_irq_enter() and rcu_irq_exit()).
  */
-void rcu_enter_nohz(void)
+void rcu_idle_enter(void)
 {
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
@@ -374,12 +370,12 @@ void rcu_enter_nohz(void)
 }
 
 /*
- * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
+ * rcu_idle_exit - inform RCU that current CPU is leaving idle
  *
- * Exit nohz mode, in other words, -enter- the mode in which RCU
+ * Exit idle, in other words, -enter- the mode in which RCU
  * read-side critical sections normally occur.
  */
-void rcu_exit_nohz(void)
+void rcu_idle_exit(void)
 {
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
@@ -442,27 +438,32 @@ void rcu_nmi_exit(void)
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
+#ifdef CONFIG_PROVE_RCU
+
 /**
- * rcu_irq_enter - inform RCU of entry to hard irq context
+ * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
  *
- * If the CPU was idle with dynamic ticks active, this updates the
- * rdtp->dynticks to let the RCU handling know that the CPU is active.
+ * If the current CPU is in its idle loop and is neither in an interrupt
+ * or NMI handler, return true.  The caller must have at least disabled
+ * preemption.
  */
-void rcu_irq_enter(void)
+int rcu_is_cpu_idle(void)
 {
-	rcu_exit_nohz();
+	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
 }
 
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
 /**
- * rcu_irq_exit - inform RCU of exit from hard irq context
+ * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
  *
- * If the CPU was idle with dynamic ticks active, update the rdp->dynticks
- * to put let the RCU handling be aware that the CPU is going back to idle
- * with no ticks.
+ * If the current CPU is idle or running at a first-level (not nested)
+ * interrupt from idle, return true.  The caller must have at least
+ * disabled preemption.
  */
-void rcu_irq_exit(void)
+int rcu_is_cpu_rrupt_from_idle(void)
 {
-	rcu_enter_nohz();
+	return (__get_cpu_var(rcu_dynticks).dynticks_nesting & 0x1) <= 1;
 }
 
 #ifdef CONFIG_SMP
@@ -512,24 +513,6 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
-#else /* #ifdef CONFIG_NO_HZ */
-
-#ifdef CONFIG_SMP
-
-static int dyntick_save_progress_counter(struct rcu_data *rdp)
-{
-	return 0;
-}
-
-static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
-{
-	return rcu_implicit_offline_qs(rdp);
-}
-
-#endif /* #ifdef CONFIG_SMP */
-
-#endif /* #else #ifdef CONFIG_NO_HZ */
-
 int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -1341,9 +1324,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 void rcu_check_callbacks(int cpu, int user)
 {
 	trace_rcu_utilization("Start scheduler-tick");
-	if (user ||
-	    (idle_cpu(cpu) && rcu_scheduler_active &&
-	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	if (user || rcu_is_cpu_rrupt_from_idle()) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
@@ -1913,9 +1894,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rdp->qlen = 0;
-#ifdef CONFIG_NO_HZ
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-#endif /* #ifdef CONFIG_NO_HZ */
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 517f2f8..1f0221f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -274,16 +274,12 @@ struct rcu_data {
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
 
-#ifdef CONFIG_NO_HZ
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-#endif /* #ifdef CONFIG_NO_HZ */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
-#ifdef CONFIG_NO_HZ
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
-#endif /* #ifdef CONFIG_NO_HZ */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
@@ -307,11 +303,7 @@ struct rcu_data {
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
-#ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
-#else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_FORCE_QS
-#endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 59c7bee..3b6a0bc 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -67,13 +67,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
-#ifdef CONFIG_NO_HZ
 	seq_printf(m, " dt=%d/%d/%d df=%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, " ql=%ld qs=%c%c%c%c",
 		   rdp->qlen,
@@ -141,13 +139,11 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
-#ifdef CONFIG_NO_HZ
 	seq_printf(m, ",%d,%d,%d,%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, ",%ld,\"%c%c%c%c\"", rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
@@ -171,9 +167,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
-#ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
 	seq_puts(m, "\"kt\",\"ktl\"");
diff --git a/kernel/softirq.c b/kernel/softirq.c
index fca82c3..c0120d5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -296,7 +296,7 @@ void irq_enter(void)
 {
 	int cpu = smp_processor_id();
 
-	rcu_irq_enter();
+	rcu_idle_exit();
 	if (idle_cpu(cpu) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
@@ -347,7 +347,7 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
-	rcu_irq_exit();
+	rcu_idle_enter();
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index eb98e55..d61b908 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -405,7 +405,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
-			rcu_enter_nohz();
+			rcu_idle_enter();
 		}
 
 		ts->idle_sleeps++;
@@ -514,7 +514,7 @@ void tick_nohz_restart_sched_tick(void)
 
 	ts->inidle = 0;
 
-	rcu_exit_nohz();
+	rcu_idle_exit();
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
