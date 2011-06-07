Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1FGEkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:40:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48339 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab1FGEkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:40:19 -0400
Date: Mon, 6 Jun 2011 21:40:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent
 states
Message-ID: <20110607044005.GB2292@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
 <rcu-splat-split-printk@mdm.bga.com>
 <20110606181021.GL3066@linux.vnet.ibm.com>
 <20110607001905.GE17026@somewhere.redhat.com>
 <20110607004250.GZ3066@linux.vnet.ibm.com>
 <20110607013630.GF17026@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607013630.GF17026@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 03:36:32AM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 06, 2011 at 05:42:50PM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 07, 2011 at 02:19:07AM +0200, Frederic Weisbecker wrote:
> > > On Mon, Jun 06, 2011 at 11:10:21AM -0700, Paul E. McKenney wrote:
> > > > commit c15d76f26712bd5228aa0c6af7a7e7c492a812c9
> > > > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > Date:   Tue May 24 08:31:09 2011 -0700
> > > > 
> > > >     rcu: Restore checks for blocking in RCU read-side critical sections
> > > >     
> > > >     Long ago, using TREE_RCU with PREEMPT would result in "scheduling
> > > >     while atomic" diagnostics if you blocked in an RCU read-side critical
> > > >     section.  However, PREEMPT now implies TREE_PREEMPT_RCU, which defeats
> > > >     this diagnostic.  This commit therefore adds a replacement diagnostic
> > > >     based on PROVE_RCU.
> > > >     
> > > >     Because rcu_lockdep_assert() and lockdep_rcu_dereference() are now being
> > > >     used for things that have nothing to do with rcu_dereference(), rename
> > > >     lockdep_rcu_dereference() to lockdep_rcu_suspicious() and add a third
> > > >     argument that is a string indicating what is suspicious.  This third
> > > >     argument is passed in from a new third argument to rcu_lockdep_assert().
> > > >     Update all calls to rcu_lockdep_assert() to add an informative third
> > > >     argument.
> > > >     
> > > >     Finally, add a pair of rcu_lockdep_assert() calls from within
> > > >     rcu_note_context_switch(), one complaining if a context switch occurs
> > > >     in an RCU-bh read-side critical section and another complaining if a
> > > >     context switch occurs in an RCU-sched read-side critical section.
> > > >     These are present only if the PROVE_RCU kernel parameter is enabled.
> > > >     
> > > >     Again, you must enable PROVE_RCU to see these new diagnostics.  But you
> > > >     are enabling PROVE_RCU to check out new RCU uses in any case, aren't you?
> > > >     
> > > >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > A little comment about this patch:
> > > 
> > > <snip>
> > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > index 88547c8..8b4b3da 100644
> > > > --- a/kernel/rcutree.c
> > > > +++ b/kernel/rcutree.c
> > > > @@ -153,6 +153,12 @@ void rcu_bh_qs(int cpu)
> > > >   */
> > > >  void rcu_note_context_switch(int cpu)
> > > >  {
> > > > +	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
> > > > +			   "Illegal context switch in RCU-bh"
> > > > +			   " read-side critical section");
> > > > +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> > > > +			   "Illegal context switch in RCU-sched"
> > > > +			   " read-side critical section");
> > > 
> > > This looks like more a check to make inside might_sleep().
> > > It's better because might_sleep() triggers the check even if
> > > we don't actually go to sleep.
> > 
> > This does make quite a bit of sense.
> > 
> > > In fact I believe might_sleep() already does the job fine:
> > > 
> > > If !PREEMPT, might_sleep() detects that preemption is disabled
> > > by rcu_read_lock().
> > 
> > If !PREEMPT, isn't the preempt_disable() called by rcu_read_lock()
> > implemented as follows?
> > 
> > #define preempt_disable()               do { } while (0)
> > 
> > Unless I am missing something, __might_sleep() won't detect that.
> 
> Ah, right.
> 
> > > If PREEMPT, might_sleep() checks rcu_preempt_depth().
> > 
> > Agreed, for CONFIG_TREE_PREEMPT_RCU and CONFIG_TINY_PREEMPT_RCU,
> > the existing might_sleep() checks do cover it.
> > 
> > So I could export an rcu_might_sleep() or some such that contained
> > the above two rcu_lockdep_assert()s, but only if !PREEMPT_RCU.
> > If PREEMPT_RCU, rcu_might_sleep() would be a no-op.
> > 
> > Seem reasonable, or am I missing something?
> 
> Ok but that only improves the rcu debugging. What about instead improving
> might_sleep() to also work in !PREEMPT, so that it profits to any detection
> of forbidden sleeping (sleep inside spinlock, preempt_disable, might_fault, etc...)
> 
> We could define a new config:
> 
> config PREEMPT_COUNT
>        default PREEMPT || DEBUG_SPINLOCK_SLEEP
> 
> and build preempt_disable()/preempt_enable() on top of that instead
> of using CONFIG_PREEMPT directly.
> 
> Does that look sane?

The bit I am missing is how to distinguish between spinlocks (where
sleeping is illegal) and mutexes (where sleeping is perfectly fine).
We could teach lockdep the difference, I suppose, but it is not clear
to me that it is worth it.

In contrast, with RCU, this is straightforward -- check for rcu_sched
and rcu_bh, but not SRCU.

							Thanx, Paul

