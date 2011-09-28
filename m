Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1I1Xqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:46:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61698 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1I1Xql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:46:41 -0400
Date: Thu, 29 Sep 2011 01:46:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110928234633.GA3537@somewhere>
References: <20110925164804.GD2995@linux.vnet.ibm.com>
 <20110926010418.GA18553@somewhere>
 <CAFTL4hy4t4z2GX=Tj5wjVv=BSGaSbcspDw3FGUy_2uK=9HU_2A@mail.gmail.com>
 <20110926012611.GJ2995@linux.vnet.ibm.com>
 <20110926092052.GD18553@somewhere>
 <20110926225032.GQ2399@linux.vnet.ibm.com>
 <20110927121648.GK18553@somewhere>
 <20110927180142.GD2335@linux.vnet.ibm.com>
 <20110928123116.GP18553@somewhere>
 <20110928184025.GF2383@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928184025.GF2383@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:40:25AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 28, 2011 at 02:31:21PM +0200, Frederic Weisbecker wrote:
> > On Tue, Sep 27, 2011 at 11:01:42AM -0700, Paul E. McKenney wrote:
> > > On Tue, Sep 27, 2011 at 02:16:50PM +0200, Frederic Weisbecker wrote:
> 
> [ . . . ]
> 
> > > > > But all of this stuff looks to me to be called from the context
> > > > > of the idle task, so that idle_cpu() will always return "true"...
> > > > 
> > > > I meant "idle_cpu() && !in_interrupt()" that should return false in
> > > > rcu_read_lock_sched_held().
> > > 
> > > The problem is that the idle tasks now seem to make quite a bit of use
> > > of RCU on entry to and exit from the idle loop itself, for example,
> > > via tracing.  So it seems like it is time to have the idle loop
> > > explictly tell RCU when the idle extended quiescent state is in effect.
> > > 
> > > An experimental patch along these lines is included below.  Does this
> > > approach seem reasonable, or am I missing something subtle (or even
> > > not so subtle) here?
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > > rcu: Explicitly track idle CPUs.
> > > 
> > > In the good old days, RCU simply checked to see if it was running in
> > > the context of an idle task to determine whether or not it was in the
> > > idle extended quiescent state.  However, the entry to and exit from
> > > idle has become more ornate over the years, and some of this processing
> > > now uses RCU while running in the context of the idle task.  It is
> > > therefore no longer reasonable to assume that anything running in the
> > > context of one of the idle tasks is in an extended quiscent state.
> > > 
> > > This commit therefore explicitly tracks whether each CPU is in the
> > > idle loop, allowing the idle task to use RCU anywhere except in those
> > > portions of the idle loops where RCU has been explicitly informed that
> > > it is in a quiescent state.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > I fear we indeed need that now.
> 
> And we probably need to factor this patch stack.  Given the number
> of warnings and errors due to RCU's confusion about what means "idle",
> we simply are not bisectable as is.

Not sure what you mean. You want to split that specific patch or
others?

> > > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > > index 375e7d8..cd9e2d1 100644
> > > --- a/include/linux/tick.h
> > > +++ b/include/linux/tick.h
> > > @@ -131,8 +131,16 @@ extern ktime_t tick_nohz_get_sleep_length(void);
> > >  extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
> > >  extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
> > >  # else
> > > -static inline void tick_nohz_idle_enter(bool rcu_ext_qs) { }
> > > -static inline void tick_nohz_idle_exit(void) { }
> > > +static inline void tick_nohz_idle_enter(bool rcu_ext_qs)
> > > +{
> > > +	if (rcu_ext_qs())
> > > +		rcu_idle_enter();
> > > +}
> > 
> > rcu_ext_qs is not a function.
> 
> Ooooh...  Good catch.  Would you believe that gcc didn't complain?
> Or maybe my scripts are missing some gcc complaints.  But I would
> expect the following to catch them:
> 
> 	egrep -q "Stop|Error|error:|warning:|improperly set"
> 
> Anything I am missing?

No idea :)

> > Although idle and rcu/nohz are still close notions, it sounds
> > more logical the other way around in the ordering:
> > 
> > tick_nohz_idle_enter() {
> > 	rcu_idle_enter() {
> > 		rcu_enter_nohz();
> > 	}
> > }
> > 
> > tick_nohz_irq_exit() {
> >         rcu_idle_enter() {
> >                 rcu_enter_nohz();
> >         }
> > }
> > 
> > Because rcu ext qs is something used by idle, not the opposite.
> 
> The problem I have with this is that it is rcu_enter_nohz() that tracks
> the irq nesting required to correctly decide whether or not we are going
> to really go to idle state.  Furthermore, there are cases where we
> do enter idle but do not enter nohz, and that has to be handled correctly
> as well.
> 
> Now, it is quite possible that I am suffering a senior moment and just
> failing to see how to structure this in the design where rcu_idle_enter()
> invokes rcu_enter_nohz(), but regardless, I am failing to see how to
> structure this so that it works correctly.
> 
> Please feel free to enlighten me!

Ah I realize that you want to call rcu_idle_exit() when we enter
the first level interrupt and rcu_idle_enter() when we exit it
to return to idle loop.

But we use that check:

	if (user ||
	    (rcu_is_cpu_idle() &&
 	     !in_softirq() &&
 	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
 		rcu_sched_qs(cpu);

So we ensure that by the time we call rcu_check_callbacks(), we are not nesting
in another interrupt.

That said we found RCU uses after we decrement the hardirq offset and until
we reach rcu_irq_exit(). So rcu_check_callbacks() may miss these places
and account spurious quiescent states.

But between sub_preempt_count() and rcu_irq_exit(), irqs are disabled
AFAIK so we can't be interrupted by rcu_check_callbacks(), except during the
softirqs processing. But we have that ordering:

add_preempt_count(SOTFIRQ_OFFSET)
local_irq_enable()

do softirqs

local_irq_disable()
sub_preempt_count(SOTFIRQ_OFFSET)

So the !in_softirq() check covers us during the time we process softirqs.

The only assumption we need is that there is no place between
sub_preempt_count(IRQ_EXIT_OFFSET) and rcu_irq_ext() that has
irqs enabled and that is an rcu read side critical section.

I'm not aware of any automatic check to ensure that though.

Anyway, the delta patch looks good. Just a little thing:

> -void tick_nohz_idle_exit(void)
> +void tick_nohz_idle_exit(bool rcu_ext_qs)

It becomes weird to have both idle_enter/idle_exit having
that parameter.

Would it make sense to have tick_nohz_idle_[exit|enter]_norcu()
and a version without norcu?

>  {
>  	int cpu = smp_processor_id();
>  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> @@ -559,7 +559,7 @@ void tick_nohz_idle_exit(void)
>  
>  	ts->inidle = 0;
>  
> -	if (ts->rcu_ext_qs) {
> +	if (rcu_ext_qs) {
>  		rcu_exit_nohz();
>  		ts->rcu_ext_qs = 0;
>  	}
