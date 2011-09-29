Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab1I2ROJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:14:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38153 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab1I2ROH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:14:07 -0400
Date: Thu, 29 Sep 2011 10:12:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110929171205.GA2362@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110926012611.GJ2995@linux.vnet.ibm.com>
 <20110926092052.GD18553@somewhere>
 <20110926225032.GQ2399@linux.vnet.ibm.com>
 <20110927121648.GK18553@somewhere>
 <20110927180142.GD2335@linux.vnet.ibm.com>
 <20110928123116.GP18553@somewhere>
 <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929123040.GB3537@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092917-6078-0000-0000-0000014B3E37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 02:30:44PM +0200, Frederic Weisbecker wrote:
> On Wed, Sep 28, 2011 at 05:55:45PM -0700, Paul E. McKenney wrote:
> > On Thu, Sep 29, 2011 at 01:46:36AM +0200, Frederic Weisbecker wrote:
> > > Not sure what you mean. You want to split that specific patch or
> > > others?
> > 
> > It looks to me that having my pair of patches on top of yours is
> > really ugly.  If we are going to introduce the per-CPU idle variable,
> > we should make a patch stack that uses that from the start.  This allows
> > me to bisect to track down the failures I am seeing on Power.
> 
> Yeah right. My patches fix the use on extended qs in idle. But if
> idle itself is considered as a quiescent state all along, that's about
> useless. So it sounds indeed better in that order.
> 
> > If you are too busy, I can take this on, but we might get better results
> > if you did it.  (And I certainly cannot complain about the large amount
> > of time and energy that you have put into this -- plus the reduction in
> > OS jitter will be really cool to have!)
> 
> No problem, I can take it.

Very good!  Rebasing and testing going well thus far.

> > > > > Although idle and rcu/nohz are still close notions, it sounds
> > > > > more logical the other way around in the ordering:
> > > > > 
> > > > > tick_nohz_idle_enter() {
> > > > > 	rcu_idle_enter() {
> > > > > 		rcu_enter_nohz();
> > > > > 	}
> > > > > }
> > > > > 
> > > > > tick_nohz_irq_exit() {
> > > > >         rcu_idle_enter() {
> > > > >                 rcu_enter_nohz();
> > > > >         }
> > > > > }
> > > > > 
> > > > > Because rcu ext qs is something used by idle, not the opposite.
> > 
> > Re-reading this makes me realize that I would instead say that idle
> > is an example of an RCU extended quiescent state, or that the rcu_ext_qs
> > argument to the various functions is used to indicate whether or not
> > we are immediately entering/leaving idle from RCU's viewpoint.
> > 
> > So what were you really trying to say here?  ;-)
> 
> I was thinking about the fact that idle is a caller of rcu_enter_nohz().
> And there may be more callers of it in the future. So I thought it may
> be better to keep rcu_enter_nohz() idle-agnostic.
> 
> But it's fine, there are other ways to call rcu_idle_enter()/rcu_idle_exit()
> from the right places other than from rcu_enter/exit_nohz().
> We have tick_check_idle() on irq entry and tick_nohz_irq_exit(), both are called
> on the first interrupt level in idle.
> 
> So I can change that easily for the nohz cpusets.

Heh!  From what I can see, we were both wrong!

My thought at this point is to make it so that rcu_enter_nohz() and
rcu_exit_nohz() are renamed to rcu_enter_idle() and rcu_exit_idle()
respectively.  I drop the per-CPU variable and the added functions
from one of my patches.  These functions, along with rcu_irq_enter(),
rcu_irq_exit(), rcu_nmi_enter(), and rcu_nmi_exit(), are moved out from
under CONFIG_NO_HZ.  This allows these functions to track idle state
regardless of the setting of CONFIG_NO_HZ.  It also separates the state
of the scheduling-clock tick from RCU's view of CPU idleness, which
simplifies things.

I will put something together along these lines.

> > > > The problem I have with this is that it is rcu_enter_nohz() that tracks
> > > > the irq nesting required to correctly decide whether or not we are going
> > > > to really go to idle state.  Furthermore, there are cases where we
> > > > do enter idle but do not enter nohz, and that has to be handled correctly
> > > > as well.
> > > > 
> > > > Now, it is quite possible that I am suffering a senior moment and just
> > > > failing to see how to structure this in the design where rcu_idle_enter()
> > > > invokes rcu_enter_nohz(), but regardless, I am failing to see how to
> > > > structure this so that it works correctly.
> > > > 
> > > > Please feel free to enlighten me!
> > > 
> > > Ah I realize that you want to call rcu_idle_exit() when we enter
> > > the first level interrupt and rcu_idle_enter() when we exit it
> > > to return to idle loop.
> > > 
> > > But we use that check:
> > > 
> > > 	if (user ||
> > > 	    (rcu_is_cpu_idle() &&
> > >  	     !in_softirq() &&
> > >  	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
> > >  		rcu_sched_qs(cpu);
> > > 
> > > So we ensure that by the time we call rcu_check_callbacks(), we are not nesting
> > > in another interrupt.
> > 
> > But I would like to enable checks for entering/exiting idle while
> > within an RCU read-side critical section. The idea is to move
> > the checks from their currently somewhat problematic location in
> > rcu_needs_cpu_quick_check() to somewhere more sensible.  My current
> > thought is to move them rcu_enter_nohz() and rcu_exit_nohz() near the
> > calls to rcu_idle_enter() and rcu_idle_exit(), respectively.
> 
> So, checking if we are calling rcu_idle_enter() while in an RCU
> read side critical section?
> 
> But we already have checks that RCU read side API are not called in
> extended quiescent state.

Both checks are good.  The existing checks catch this kind of error:

1.	CPU 0 goes idle, entering an RCU extended quiescent state.
2.	CPU 0 illegally enters an RCU read-side critical section.

The new check catches this kind of error:

1.	CPU 0 enters an RCU read-side critical section.
2.	CPU 0 goes idle, entering an RCU extended quiescent state,
	but illegally so because it is still in an RCU read-side
	critical section.

> > This would mean that they operated only in NO_HZ kernels with lockdep
> > enabled, but I am good with that because to do otherwise would require
> > adding nesting-level counters to the non-NO_HZ case, which I would like
> > to avoid, expecially for TINY_RCU.

And my reworking of RCU's NO_HZ code to instead be idle code removes
the NO_HZ-only restriction.  Getting rid of the additional per-CPU
variable reduces the TINY_RCU overhead to acceptable levels.

> There can be a secondary check in rcu_read_lock_held() and friends to
> ensures that rcu_is_idle_cpu(). In the non-NO_HZ case it's useful to
> find similar issues.
> 
> In fact we could remove the check for rcu_extended_qs() in read side
> APIs and check instead rcu_is_idle_cpu(). That would work in any
> config and not only NO_HZ.
> 
> But I hope we can actually keep the check for RCU extended quiescent
> state so that when rcu_enter_nohz() is called from other places than
> idle, we are ready for it.
> 
> I believe it's fine to have both checks in PROVE_RCU.

Agreed, I have not yet revisited rcu_extended_qs(), but some change
might be useful.

> > > That said we found RCU uses after we decrement the hardirq offset and until
> > > we reach rcu_irq_exit(). So rcu_check_callbacks() may miss these places
> > > and account spurious quiescent states.
> > > 
> > > But between sub_preempt_count() and rcu_irq_exit(), irqs are disabled
> > > AFAIK so we can't be interrupted by rcu_check_callbacks(), except during the
> > > softirqs processing. But we have that ordering:
> > > 
> > > add_preempt_count(SOTFIRQ_OFFSET)
> > > local_irq_enable()
> > > 
> > > do softirqs
> > > 
> > > local_irq_disable()
> > > sub_preempt_count(SOTFIRQ_OFFSET)
> > > 
> > > So the !in_softirq() check covers us during the time we process softirqs.
> > > 
> > > The only assumption we need is that there is no place between
> > > sub_preempt_count(IRQ_EXIT_OFFSET) and rcu_irq_ext() that has
> > > irqs enabled and that is an rcu read side critical section.
> > > 
> > > I'm not aware of any automatic check to ensure that though.
> > 
> > Nor am I, which is why I am looking to the checks in
> > rcu_enter_nohz() and rcu_exit_nohz() called out above.
> 
> Yep.
> 
> > > Anyway, the delta patch looks good.
> > 
> > OK, my current plans are to start forward-porting to -rc8, and I would
> > like to have this pair of delta patches or something like them pulled
> > into your stack.
> 
> Sure I can take your patches (I'm going to merge the delta into the first).
> But if you want a rebase against -rc8, it's going to be easier if you
> do that rebase on the branch you want me to work on. Then I work on top
> of it.
> 
> For example we can take your rcu/dynticks, rewind to
> "rcu: Make synchronize_sched_expedited() better at work sharing"
> 771c326f20029a9f30b9a58237c9a5d5ddc1763d, rebase on top of -rc8
> and I rebase my patches (yours included) on top of it and I repost.
> 
> Right?

Yep!  Your earlier three patches look to need some extended-quiescent-state
rework as well:

b5566f3d: Detect illegal rcu dereference in extended quiescent state
ee05e5a4: Inform the user about dynticks-idle mode on PROVE_RCU warning
fa5d22cf: Warn when rcu_read_lock() is used in extended quiescent state

So I will leave these out and let you rebase them.

> > >                                     Just a little thing:
> > > 
> > > > -void tick_nohz_idle_exit(void)
> > > > +void tick_nohz_idle_exit(bool rcu_ext_qs)
> > > 
> > > It becomes weird to have both idle_enter/idle_exit having
> > > that parameter.
> > > 
> > > Would it make sense to have tick_nohz_idle_[exit|enter]_norcu()
> > > and a version without norcu?
> > 
> > Given that we need to make this work in CONFIG_NO_HZ=n kernels, I believe
> > that the current API is OK.  But if you would like to change the API
> > during the forward-port to -rc8, I am also OK with the alternative API
> > you suggest.
> 
> Fine. I'll do that rename.

Works for me!  ;-)

							Thanx, Paul

