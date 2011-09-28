Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1I1Smn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:42:43 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36109 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab1I1Smm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:42:42 -0400
Date: Wed, 28 Sep 2011 11:40:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110928184025.GF2383@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110925130622.GA9205@somewhere.redhat.com>
 <20110925164804.GD2995@linux.vnet.ibm.com>
 <20110926010418.GA18553@somewhere>
 <CAFTL4hy4t4z2GX=Tj5wjVv=BSGaSbcspDw3FGUy_2uK=9HU_2A@mail.gmail.com>
 <20110926012611.GJ2995@linux.vnet.ibm.com>
 <20110926092052.GD18553@somewhere>
 <20110926225032.GQ2399@linux.vnet.ibm.com>
 <20110927121648.GK18553@somewhere>
 <20110927180142.GD2335@linux.vnet.ibm.com>
 <20110928123116.GP18553@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928123116.GP18553@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092818-8974-0000-0000-0000007FED6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 02:31:21PM +0200, Frederic Weisbecker wrote:
> On Tue, Sep 27, 2011 at 11:01:42AM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 27, 2011 at 02:16:50PM +0200, Frederic Weisbecker wrote:

[ . . . ]

> > > > But all of this stuff looks to me to be called from the context
> > > > of the idle task, so that idle_cpu() will always return "true"...
> > > 
> > > I meant "idle_cpu() && !in_interrupt()" that should return false in
> > > rcu_read_lock_sched_held().
> > 
> > The problem is that the idle tasks now seem to make quite a bit of use
> > of RCU on entry to and exit from the idle loop itself, for example,
> > via tracing.  So it seems like it is time to have the idle loop
> > explictly tell RCU when the idle extended quiescent state is in effect.
> > 
> > An experimental patch along these lines is included below.  Does this
> > approach seem reasonable, or am I missing something subtle (or even
> > not so subtle) here?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > rcu: Explicitly track idle CPUs.
> > 
> > In the good old days, RCU simply checked to see if it was running in
> > the context of an idle task to determine whether or not it was in the
> > idle extended quiescent state.  However, the entry to and exit from
> > idle has become more ornate over the years, and some of this processing
> > now uses RCU while running in the context of the idle task.  It is
> > therefore no longer reasonable to assume that anything running in the
> > context of one of the idle tasks is in an extended quiscent state.
> > 
> > This commit therefore explicitly tracks whether each CPU is in the
> > idle loop, allowing the idle task to use RCU anywhere except in those
> > portions of the idle loops where RCU has been explicitly informed that
> > it is in a quiescent state.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I fear we indeed need that now.

And we probably need to factor this patch stack.  Given the number
of warnings and errors due to RCU's confusion about what means "idle",
we simply are not bisectable as is.

Nevertheless, see below for an incremental patch based on your feedback.

> Just some comments:
> 
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 9d40e42..5b7e62c 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -177,6 +177,9 @@ extern void rcu_sched_qs(int cpu);
> >  extern void rcu_bh_qs(int cpu);
> >  extern void rcu_check_callbacks(int cpu, int user);
> >  struct notifier_block;
> > +extern void rcu_idle_enter(void);
> > +extern void rcu_idle_exit(void);
> > +extern int rcu_is_cpu_idle(void);
> >  
> >  #ifdef CONFIG_NO_HZ
> >  
> > @@ -187,10 +190,12 @@ extern void rcu_exit_nohz(void);
> >  
> >  static inline void rcu_enter_nohz(void)
> >  {
> > +	rcu_idle_enter();
> >  }
> >  
> >  static inline void rcu_exit_nohz(void)
> >  {
> > +	rcu_idle_exit();
> >  }
> >  
> >  #endif /* #else #ifdef CONFIG_NO_HZ */
> > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > index 375e7d8..cd9e2d1 100644
> > --- a/include/linux/tick.h
> > +++ b/include/linux/tick.h
> > @@ -131,8 +131,16 @@ extern ktime_t tick_nohz_get_sleep_length(void);
> >  extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
> >  extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
> >  # else
> > -static inline void tick_nohz_idle_enter(bool rcu_ext_qs) { }
> > -static inline void tick_nohz_idle_exit(void) { }
> > +static inline void tick_nohz_idle_enter(bool rcu_ext_qs)
> > +{
> > +	if (rcu_ext_qs())
> > +		rcu_idle_enter();
> > +}
> 
> rcu_ext_qs is not a function.

Ooooh...  Good catch.  Would you believe that gcc didn't complain?
Or maybe my scripts are missing some gcc complaints.  But I would
expect the following to catch them:

	egrep -q "Stop|Error|error:|warning:|improperly set"

Anything I am missing?

(And yes, I did remove the "()" in both cases.)

> > +static inline void tick_nohz_idle_exit(void)
> > +{
> > +	if (rcu_ext_qs())
> > +		rcu_idle_exit();
> > +}
> 
> So we probably need to track whether we entered in rcu_ext_qs
> so that we can know if we cann rcu_idle_exit(). Or may
> be pass the rcu_ext_qs parameter down to tick_nohz_idle_exit() as well.

Good point.

> >  static inline ktime_t tick_nohz_get_sleep_length(void)
> >  {
> >  	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
> > diff --git a/kernel/rcu.h b/kernel/rcu.h
> > index f600868..220b4fe 100644
> > --- a/kernel/rcu.h
> > +++ b/kernel/rcu.h
> > @@ -23,6 +23,8 @@
> >  #ifndef __LINUX_RCU_H
> >  #define __LINUX_RCU_H
> >  
> > +/* Avoid tracing overhead if not configure, mostly for RCU_TINY's benefit. */
> > +
> >  #ifdef CONFIG_RCU_TRACE
> >  #define RCU_TRACE(stmt) stmt
> >  #else /* #ifdef CONFIG_RCU_TRACE */
> <snip>
> > diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> > index 9e493b9..6d7207d 100644
> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -65,8 +65,10 @@ static long rcu_dynticks_nesting = 1;
> >   */
> >  void rcu_enter_nohz(void)
> >  {
> > -	if (--rcu_dynticks_nesting == 0)
> > +	if (--rcu_dynticks_nesting == 0) {
> >  		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
> > +		rcu_idle_enter();
> 
> Although idle and rcu/nohz are still close notions, it sounds
> more logical the other way around in the ordering:
> 
> tick_nohz_idle_enter() {
> 	rcu_idle_enter() {
> 		rcu_enter_nohz();
> 	}
> }
> 
> tick_nohz_irq_exit() {
>         rcu_idle_enter() {
>                 rcu_enter_nohz();
>         }
> }
> 
> Because rcu ext qs is something used by idle, not the opposite.

The problem I have with this is that it is rcu_enter_nohz() that tracks
the irq nesting required to correctly decide whether or not we are going
to really go to idle state.  Furthermore, there are cases where we
do enter idle but do not enter nohz, and that has to be handled correctly
as well.

Now, it is quite possible that I am suffering a senior moment and just
failing to see how to structure this in the design where rcu_idle_enter()
invokes rcu_enter_nohz(), but regardless, I am failing to see how to
structure this so that it works correctly.

Please feel free to enlighten me!

							Thanx, Paul

------------------------------------------------------------------------

rcu: Add rcu_ext_qs argument to tick_nohz_idle_exit()

When the system is built with CONFIG_NO_HZ=n, tick_nohz_idle_exit()
does not have enough information to determine whether or not it should
tell RCU that an idle extended quiescent state has started.  This commit
therefore adds an rcu_ext_qs argument to tick_nohz_idle_exit() to supply
this information.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 51b0e39..e155474 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -208,7 +208,7 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 5041c84..a563d5f 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -37,7 +37,7 @@ void cpu_idle(void)
 		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			cpu_idle_sleep();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index f22a0da..c99f57c 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -91,7 +91,7 @@ void cpu_idle(void)
 		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			idle();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 0f5290f..843fab3 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -106,7 +106,7 @@ void cpu_idle(void)
 		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			idle();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 20be814..58269b1 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -77,7 +77,7 @@ void __noreturn cpu_idle(void)
 		     system_state == SYSTEM_BOOTING))
 			play_dead();
 #endif
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index a0e31a7..6c124a4 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -93,7 +93,7 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index f239427..0df97a9 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -576,7 +576,7 @@ static void iseries_shared_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
@@ -609,7 +609,7 @@ static void iseries_dedicated_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 3dbaf59..1763390 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -93,7 +93,7 @@ void cpu_idle(void)
 		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			default_idle();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index bb0a627..c238f42 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -109,7 +109,7 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 3c5d363..76b5786 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -100,7 +100,7 @@ void cpu_idle(void)
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
 
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 
 		preempt_enable_no_resched();
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 727dc85..bdcdafe 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -105,7 +105,7 @@ void cpu_idle(void)
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 5693d6d..72d2ffe 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -248,7 +248,7 @@ void default_idle(void)
 		tick_nohz_idle_enter(true);
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 	}
 }
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index afa50d9..371b935 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -63,7 +63,7 @@ void cpu_idle(void)
 			local_irq_enable();
 			start_critical_timings();
 		}
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8c2faa9..9e557d9 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -112,7 +112,7 @@ void cpu_idle(void)
 			pm_idle();
 			start_critical_timings();
 		}
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(true);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index dee2e6c..93e1b09 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -150,7 +150,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit(false);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index cd9e2d1..ec481bd 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -125,7 +125,7 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 
 # ifdef CONFIG_NO_HZ
 extern void tick_nohz_idle_enter(bool rcu_ext_qs);
-extern void tick_nohz_idle_exit(void);
+extern void tick_nohz_idle_exit(bool rcu_ext_qs);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
@@ -133,12 +133,12 @@ extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_idle_enter(bool rcu_ext_qs)
 {
-	if (rcu_ext_qs())
+	if (rcu_ext_qs)
 		rcu_idle_enter();
 }
-static inline void tick_nohz_idle_exit(void)
+static inline void tick_nohz_idle_exit(bool rcu_ext_qs)
 {
-	if (rcu_ext_qs())
+	if (rcu_ext_qs)
 		rcu_idle_exit();
 }
 static inline ktime_t tick_nohz_get_sleep_length(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index cd1a54e..914a0bd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -535,7 +535,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
  *
  * Restart the idle tick when the CPU is woken up from idle
  */
-void tick_nohz_idle_exit(void)
+void tick_nohz_idle_exit(bool rcu_ext_qs)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
@@ -559,7 +559,7 @@ void tick_nohz_idle_exit(void)
 
 	ts->inidle = 0;
 
-	if (ts->rcu_ext_qs) {
+	if (rcu_ext_qs) {
 		rcu_exit_nohz();
 		ts->rcu_ext_qs = 0;
 	}

