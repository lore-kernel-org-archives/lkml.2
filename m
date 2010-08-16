Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0HPVcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:32:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44929 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab0HPVcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:32:06 -0400
Date: Mon, 16 Aug 2010 14:32:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100816213200.GK2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100809221447.GA24358@linux.vnet.ibm.com>
 <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100816150737.GB8320@Krystal>
 <20100816183355.GH2388@linux.vnet.ibm.com>
 <20100816191947.GA970@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816191947.GA970@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 03:19:47PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Aug 16, 2010 at 11:07:37AM -0400, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > [...]
> > > > +
> > > > +/*
> > > > + * Tiny-preemptible RCU implementation for rcu_read_unlock().
> > > > + * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> > > > + * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> > > > + * invoke rcu_read_unlock_special() to clean up after a context switch
> > > > + * in an RCU read-side critical section and other special cases.
> > > > + */
> > > > +void __rcu_read_unlock(void)
> > > > +{
> > > > +	struct task_struct *t = current;
> > > > +
> > > > +	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
> > > > +	if (--t->rcu_read_lock_nesting == 0 &&
> > > > +	    unlikely(t->rcu_read_unlock_special))
> > 
> > First, thank you for looking this over!!!
> > 
> > > Hrm I think we discussed this in a past life, but would the following
> > > sequence be possible and correct ?
> > > 
> > > CPU 0
> > > 
> > > read t->rcu_read_unlock_special
> > >   interrupt comes in, preempts. sets t->rcu_read_unlock_special
> > >   <preempted>
> > >   <scheduled back>
> > >   iret
> > > decrement and read t->rcu_read_lock_nesting
> > > test both old "special" value (which we have locally on the stack) and
> > > detect that rcu_read_lock_nesting is 0.
> > > 
> > > We actually missed a reschedule.
> > > 
> > > I think we might need a barrier() between the t->rcu_read_lock_nesting
> > > and t->rcu_read_unlock_special reads.
> > 
> > You are correct -- I got too aggressive in eliminating synchronization.
> > 
> > Good catch!!!
> > 
> > I added an ACCESS_ONCE() to the second term of the "if" condition so
> > that it now reads:
> > 
> > 	if (--t->rcu_read_lock_nesting == 0 &&
> > 	    unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))
> > 
> > This prevents the compiler from reordering because the ACCESS_ONCE()
> > prohibits accessing t->rcu_read_unlock_special unless the value of
> > t->rcu_read_lock_nesting is known to be zero.
> 
> Hrm, --t->rcu_read_lock_nesting does not have any globally visible
> side-effect, so the compiler is free to reorder the memory access across
> the rcu_read_unlock_special access. I think we need the ACCESS_ONCE()
> around the t->rcu_read_lock_nesting access too.

Indeed, it is free to reorder that access.  This has the effect of
extending the scope of the RCU read-side critical section, which is
harmless as long as it doesn't pull a lock or some such into it.

> > >                                       We might need to audit
> > > TREE PREEMPT RCU for the same kind of behavior.
> > 
> > The version of __rcu_read_unlock() in kernel/rcutree_plugin.h is as
> > follows:
> > 
> > void __rcu_read_unlock(void)
> > {
> > 	struct task_struct *t = current;
> > 
> > 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> > 	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
> > 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> 
> This seem to work because we have:
> 
> volatile access (read/update t->rcu_read_lock_nesting)
> && (sequence point)
> volatile access (t->rcu_read_unlock_special)

Yep!!!  ;-)

> The C standard seems to forbid reordering of volatile accesses across
> sequence points, so this should be fine. But it would probably be good
> to document this implied ordering explicitly.

I should probably review commenting globally, and this might be one
place needing help.

> > 		rcu_read_unlock_special(t);
> > #ifdef CONFIG_PROVE_LOCKING
> > 	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> > #endif /* #ifdef CONFIG_PROVE_LOCKING */
> > }
> > 
> > The ACCESS_ONCE() calls should cover this.  I believe that the first
> > ACCESS_ONCE() is redundant, and have checking this more closely on my
> > todo list.
> 
> I doubt so, see explanation above.

Ditto!  ;-)

> > > But I might be (again ?) missing something. I've got the feeling you
> > > already convinced me that this was OK for some reason, but I trip on
> > > this every time I read the code.
> > > 
> > > [...]
> > > 
> > > > +/*
> > > > + * Check for a task exiting while in a preemptible -RCU read-side
> > > > + * critical section, clean up if so.  No need to issue warnings,
> > > > + * as debug_check_no_locks_held() already does this if lockdep
> > > > + * is enabled.
> > > > + */
> > > > +void exit_rcu(void)
> > > > +{
> > > > +	struct task_struct *t = current;
> > > > +
> > > > +	if (t->rcu_read_lock_nesting == 0)
> > > > +		return;
> > > > +	t->rcu_read_lock_nesting = 1;
> > > > +	rcu_read_unlock();
> > > > +}
> > > > +
> > > 
> > > The interaction with preemption is unclear here. exit.c disables
> > > preemption around the call to exit_rcu(), but if, for some reason,
> > > rcu_read_unlock_special was set earlier by preemption, then the
> > > rcu_read_unlock() code might block and cause problems.
> > 
> > But rcu_read_unlock_special() does not block.  In fact, it disables
> > interrupts over almost all of its execution.  Or am I missing some
> > subtlety here?
> 
> I am probably the one who was missing a subtlety about how
> rcu_read_unlock_special() works.
> 
> > 
> > > Maybe we should consider clearing rcu_read_unlock_special here ?
> > 
> > If the task blocked in an RCU read-side critical section just before
> > exit_rcu() was called, we need to remove the task from the ->blkd_tasks
> > list.  If we fail to do so, we might get a segfault later on.  Also,
> > we do need to handle any RCU_READ_UNLOCK_NEED_QS requests from the RCU
> > core.
> > 
> > So I really do like the current approach of calling rcu_read_unlock()
> > to do this sort of cleanup.
> 
> It looks good then, I just wanted to ensure that the side-effects of
> calling rcu_read_unlock() in this code path were well-thought.

Long ago on the first RCU priority-boosting implementation I tried doing
the rcu_read_unlock() by hand.  The unhappy lessons learned caused me
to just use rcu_read_unlock() when I encountered similar situations
later on.  ;-)

							Thanx, Paul
