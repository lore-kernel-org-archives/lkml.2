Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1I0SDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:03:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44564 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1I0SDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:03:09 -0400
Date: Tue, 27 Sep 2011 11:01:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110927180142.GD2335@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110925050826.GC2995@linux.vnet.ibm.com>
 <20110925112637.GA19298@shutemov.name>
 <20110925130622.GA9205@somewhere.redhat.com>
 <20110925164804.GD2995@linux.vnet.ibm.com>
 <20110926010418.GA18553@somewhere>
 <CAFTL4hy4t4z2GX=Tj5wjVv=BSGaSbcspDw3FGUy_2uK=9HU_2A@mail.gmail.com>
 <20110926012611.GJ2995@linux.vnet.ibm.com>
 <20110926092052.GD18553@somewhere>
 <20110926225032.GQ2399@linux.vnet.ibm.com>
 <20110927121648.GK18553@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110927121648.GK18553@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 02:16:50PM +0200, Frederic Weisbecker wrote:
> On Mon, Sep 26, 2011 at 03:50:32PM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 26, 2011 at 11:20:55AM +0200, Frederic Weisbecker wrote:
> > > On Sun, Sep 25, 2011 at 06:26:11PM -0700, Paul E. McKenney wrote:
> > > > On Mon, Sep 26, 2011 at 03:10:33AM +0200, Frederic Weisbecker wrote:
> > > > > 2011/9/26 Frederic Weisbecker <fweisbec@gmail.com>:
> > > > > > On Sun, Sep 25, 2011 at 09:48:04AM -0700, Paul E. McKenney wrote:
> > > > > >> This is required for RCU_FAST_NO_HZ, which checks to see whether the
> > > > > >> current CPU can accelerate the current grace period so as to enter
> > > > > >> dyntick-idle mode sooner than it would otherwise.  This takes effect
> > > > > >> in the situation where rcu_needs_cpu() sees that there are callbacks.
> > > > > >> It then notes a quiescent state (which is illegal in an RCU read-side
> > > > > >> critical section), calls force_quiescent_state(), and so on.  For this
> > > > > >> to work, the current CPU must be in an RCU read-side critical section.
> > > > > >
> > > > > > You mean it must *not* be in an RCU read-side critical section (ie: in a
> > > > > > quiescent state)?
> > > > > >
> > > > > > That assumption at least fails anytime in idle for the RCU
> > > > > > sched flavour given that preemption is disabled in the idle loop.
> > > > > >
> > > > > >> If this cannot be made to work, another option is to call a new RCU
> > > > > >> function in the case where rcu_needs_cpu() returned false, but after
> > > > > >> the RCU read-side critical section has exited.
> > > > > >
> > > > > > You mean when rcu_needs_cpu() returns true (when we have callbacks
> > > > > > enqueued)?
> > > > > >
> > > > > >> This new RCU function
> > > > > >> could then attempt to rearrange RCU so as to allow the CPU to enter
> > > > > >> dyntick-idle mode more quickly.  It is more important for this to
> > > > > >> happen when the CPU is going idle than when it is executing a user
> > > > > >> process.
> > > > > >>
> > > > > >> So, is this doable?
> > > > > >
> > > > > > At least not when we have RCU sched callbacks enqueued, given preemption
> > > > > > is disabled. But that sounds plausible in order to accelerate the switch
> > > > > > to dyntick-idle mode when we only have rcu and/or rcu bh callbacks.
> > > > > 
> > > > > But the RCU sched case could be dealt with if we embrace every use of
> > > > > it with rcu_read_lock_sched() and rcu_read_unlock_sched(), or some light
> > > > > version that just increases a local counter that rcu_needs_cpu() could check.
> > > > > 
> > > > > It's an easy thing to add: we can ensure preempt is disabled when we call it
> > > > > and we can force rcu_dereference_sched() to depend on it.
> > > > 
> > > > Or just check to see if this is the first level of interrupt from the
> > > > idle task after the scheduler is up.
> > > 
> > > I believe it's always the case. tick_nohz_stop_sched_tick() is only called
> > > from the first level of interrupt in irq_exit().
> > 
> > OK, good, let me see if I really understand this...
> > 
> > Case 1: The interrupt interrupted non-dyntick-idle code.  In this case,
> > 	rcu_needs_cpu() can look at the dyntick-idle state and determine
> > 	that it might not be in a quiescent state.
> 
> I guess by dyntick idle code you mean the fact that the RCU in is
> extended quiescent state? (Not just the tick is stopped)
> 
> If so yeah that looks good.
> 
> > 
> > Case 2: The interrupt interrupted dyntick-idle code.  In this case,
> > 	the interrupted code had better not be in an RCU read-side
> > 	critical section, and rcu_needs_cpu() should be able to
> > 	detect this as well.
> 
> Yeah.
> 
> We already do the appropriate debug checks from the RCU read side
> APIs so I guess rcu_needs_cpu() doesn't even need to do its own
> debugging checks here about extended qs.
> 
> But indeed it can return right away if we are in extended qs.
> 
> > 
> > Case 3: The interrupt interrupted the process of transitioning to
> > 	or from dyntick-idle mode.  This should be prohibited by
> > 	the local_irq_save() calls, right?
> 
> Indeed.
> 
> > 
> > > There is always some race window, as it's based on preempt offset: between
> > > the sub_preempt_count and the softirqs begin and between softirqs end and the end
> > > of the interrupt. But an "idle_cpu() || in_interrupt()" check in rcu_read_lock_sched_held()
> > > should catch those offenders.
> > 
> > But all of this stuff looks to me to be called from the context
> > of the idle task, so that idle_cpu() will always return "true"...
> 
> I meant "idle_cpu() && !in_interrupt()" that should return false in
> rcu_read_lock_sched_held().

The problem is that the idle tasks now seem to make quite a bit of use
of RCU on entry to and exit from the idle loop itself, for example,
via tracing.  So it seems like it is time to have the idle loop
explictly tell RCU when the idle extended quiescent state is in effect.

An experimental patch along these lines is included below.  Does this
approach seem reasonable, or am I missing something subtle (or even
not so subtle) here?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Explicitly track idle CPUs.

In the good old days, RCU simply checked to see if it was running in
the context of an idle task to determine whether or not it was in the
idle extended quiescent state.  However, the entry to and exit from
idle has become more ornate over the years, and some of this processing
now uses RCU while running in the context of the idle task.  It is
therefore no longer reasonable to assume that anything running in the
context of one of the idle tasks is in an extended quiscent state.

This commit therefore explicitly tracks whether each CPU is in the
idle loop, allowing the idle task to use RCU anywhere except in those
portions of the idle loops where RCU has been explicitly informed that
it is in a quiescent state.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9d40e42..5b7e62c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -177,6 +177,9 @@ extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
+extern void rcu_idle_enter(void);
+extern void rcu_idle_exit(void);
+extern int rcu_is_cpu_idle(void);
 
 #ifdef CONFIG_NO_HZ
 
@@ -187,10 +190,12 @@ extern void rcu_exit_nohz(void);
 
 static inline void rcu_enter_nohz(void)
 {
+	rcu_idle_enter();
 }
 
 static inline void rcu_exit_nohz(void)
 {
+	rcu_idle_exit();
 }
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 375e7d8..cd9e2d1 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -131,8 +131,16 @@ extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_idle_enter(bool rcu_ext_qs) { }
-static inline void tick_nohz_idle_exit(void) { }
+static inline void tick_nohz_idle_enter(bool rcu_ext_qs)
+{
+	if (rcu_ext_qs())
+		rcu_idle_enter();
+}
+static inline void tick_nohz_idle_exit(void)
+{
+	if (rcu_ext_qs())
+		rcu_idle_exit();
+}
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
diff --git a/kernel/rcu.h b/kernel/rcu.h
index f600868..220b4fe 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -23,6 +23,8 @@
 #ifndef __LINUX_RCU_H
 #define __LINUX_RCU_H
 
+/* Avoid tracing overhead if not configure, mostly for RCU_TINY's benefit. */
+
 #ifdef CONFIG_RCU_TRACE
 #define RCU_TRACE(stmt) stmt
 #else /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index e4d8a98..daf3f92 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -114,6 +114,45 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/*
+ * In the good old days, RCU just checked to see if the idle task was
+ * running to check for being in the idle loop, which is an extended
+ * quiescent state.  However, RCU is now used by a number of architectures
+ * on the way to the idle loop, but still executed by the idle tasks.
+ * Therefore, we now provide a per-CPU variable for tracking whether
+ * or not a given CPU is idle from an RCU perspective.
+ */
+DEFINE_PER_CPU(char, rcu_cpu_is_idle);
+
+/*
+ * Inform RCU that the current CPU is entering the idle extended quiescent
+ * state.  Preemption must be disabled.
+ */
+void rcu_idle_enter(void)
+{
+	__this_cpu_write(rcu_cpu_is_idle, 1);
+}
+
+/*
+ * Inform RCU that the current CPU is leaving the idle extended quiescent
+ * state.  Preemption must again be disabled.
+ */
+void rcu_idle_exit(void)
+{
+	__this_cpu_write(rcu_cpu_is_idle, 0);
+}
+
+/*
+ * Check to see whether RCU thinks that the current CPU is idle.
+ * Note that interrupt handlers from idle may or may not be counted
+ * as idle by this approach.  If you care about the difference,
+ * be sure to check explicitly like rcu_check_callbacks() does.
+ */
+int rcu_is_cpu_idle(void)
+{
+	return __this_cpu_read(rcu_cpu_is_idle);
+}
+
 struct rcu_synchronize {
 	struct rcu_head head;
 	struct completion completion;
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 9e493b9..6d7207d 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -65,8 +65,10 @@ static long rcu_dynticks_nesting = 1;
  */
 void rcu_enter_nohz(void)
 {
-	if (--rcu_dynticks_nesting == 0)
+	if (--rcu_dynticks_nesting == 0) {
 		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+		rcu_idle_enter();
+	}
 }
 
 /*
@@ -75,7 +77,8 @@ void rcu_enter_nohz(void)
  */
 void rcu_exit_nohz(void)
 {
-	rcu_dynticks_nesting++;
+	if (rcu_dynticks_nesting++ == 0)
+		rcu_idle_exit();
 }
 
 
@@ -146,7 +149,7 @@ void rcu_bh_qs(int cpu)
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
-	    (idle_cpu(cpu) &&
+	    (rcu_is_cpu_idle() &&
 	     !in_softirq() &&
 	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
 		rcu_sched_qs(cpu);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6a7b9bb..00a0eb0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -370,6 +370,7 @@ void rcu_enter_nohz(void)
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	rcu_idle_enter();
 	local_irq_restore(flags);
 }
 
@@ -396,6 +397,7 @@ void rcu_exit_nohz(void)
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	trace_rcu_dyntick("End");
+	rcu_idle_exit();
 	local_irq_restore(flags);
 }
 
@@ -1360,7 +1362,7 @@ void rcu_check_callbacks(int cpu, int user)
 {
 	trace_rcu_utilization("Start scheduler-tick");
 	if (user ||
-	    (idle_cpu(cpu) && rcu_scheduler_active &&
+	    (rcu_is_cpu_idle() && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
