Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab2CZSdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:33:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59733 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab2CZSdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:33:03 -0400
Date: Mon, 26 Mar 2012 11:32:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
Message-ID: <20120326183232.GK2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120325205249.GA29528@linux.vnet.ibm.com>
 <1332748484.16159.61.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332748484.16159.61.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032618-3352-0000-0000-00000395EC51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 09:54:44AM +0200, Peter Zijlstra wrote:
> On Sun, 2012-03-25 at 13:52 -0700, Paul E. McKenney wrote:
> > The preemptible-RCU implementations of __rcu_read_lock() have not been
> > inlinable due to task_struct references that ran afoul of include-file
> > dependencies.  Fix this (as suggested by Linus) by moving the task_struct
> > ->rcu_read_lock_nesting field to a per-CPU variable that is saved and
> > restored at context-switch time.  With this change, __rcu_read_lock()
> > references only that new per-CPU variable, and so may be safely
> > inlined.  This change also allows some code that was duplicated in
> > kernel/rcutree_plugin.h and kernel/rcutiny_plugin.h to be merged into
> > include/linux/rcupdate.h.
> > 
> > This same approach unfortunately cannot be used on __rcu_read_unlock()
> > because it also references the task_struct ->rcu_read_unlock_special
> > field, to which cross-task access is required by rcu_boost().  This
> > function will be handled in a separate commit, if need be.
> > 
> > The TREE_RCU variant passes modest rcutorture runs, while TINY_RCU still
> > has a few bugs.  Peter Zijlstra might have some thoughts on hooking into
> > the scheduler.  Disallows use of RCU from within the architecture-specific
> > switch_to() function, which probably runs afoul of tracing for at least
> > some architectures.  There probably are still a few other bugs, as well.
> > 
> > TREE_RCU should be OK for experimental usage.
> 
> Right, so I really dislike adding this cache-miss to the context switch
> path, that said, rcu is used often enough that the savings on
> rcu_read_lock() might just come out in favour of this.. but it would be
> very nice to have some numbers.

I need to get it into known-good shape before evaluating, but yes, some
justification is clearly required.

> Also,
> 
> >  /*
> > + * Save the incoming task's value for rcu_read_lock_nesting at the
> > + * end of a context switch.  There can be no process-state RCU read-side
> > + * critical sections between the call to rcu_switch_from() and to
> > + * rcu_switch_to().  Interrupt-level RCU read-side critical sections are
> > + * OK because rcu_read_unlock_special() takes early exits when called
> > + * at interrupt level.
> > + */
> > +void rcu_switch_from(void)
> > +{
> > +	current->rcu_read_lock_nesting_save =
> > +		__this_cpu_read(rcu_read_lock_nesting);
> > +	barrier();
> > +	__this_cpu_write(rcu_read_lock_nesting, 0);
> > +}
> 
> Since rcu_switch_to() will again write rcu_read_lock_nesting, what's the
> point of setting it to zero?
> 
> Also, that barrier(), there's a clear dependency between the operations
> how can the compiler mess that up?

Both were debugging assists which I have now removed.

> > +/*
> > + * Restore the incoming task's value for rcu_read_lock_nesting at the
> > + * end of a context switch.
> >   */
> > +void rcu_switch_to(void)
> >  {
> > +	__this_cpu_write(rcu_read_lock_nesting,
> > +			 current->rcu_read_lock_nesting_save);
> > +	barrier();
> > +	current->rcu_read_lock_nesting_save = 0;
> >  }
> 
> Similar, a future rcu_switch_from() will again over-write
> current->rcu_read_lock_nesting_save, what's the point of clearing it?

I removed that one as well, again, debug code.

> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2051,7 +2051,9 @@ context_switch(struct rq *rq, struct task_struct *prev,
> >  #endif
> >  
> >  	/* Here we just switch the register state and the stack. */
> > +	rcu_switch_from();
> >  	switch_to(prev, next, prev);
> > +	rcu_switch_to();
> >  
> >  	barrier();
> >  	/*
> 
> So why not save one call and do:
> 
> 	switch_to(prev, next, prev);
>  	rcu_switch_to(prev, next);
> 
> and have
> 
> void rcu_switch_to(struct task_struct *prev, struct task_struct *next)
> {
> 	prev->rcu_read_lock_nesting_save = __this_cpu_read(rcu_read_lock_nesting);
> 	__this_cpu_write(rcu_read_lock_nesting) = next->rcu_read_lock_nesting_save;
> }
> 
> preferably as an inline function so we can avoid all calls.

I could inline them into sched.h, if you are agreeable.

I am a bit concerned about putting them both together because I am betting
that at least some of the architectures having tracing in switch_to(),
which I currently do not handle well.  At the moment, the ways I can
think of to handle it well require saving before the switch and restoring
afterwards.  Otherwise, I can end up with the ->rcu_read_unlock_special
flags getting associated with the wrong RCU read-side critical section,
as happened last year.

Preemption is disabled at this point, correct?

Hmmm...  One way that I could reduce the overhead that preemptible RCU
imposes on the scheduler would be to move the task_struct queuing from
its current point upon entry to the scheduler to just before switch_to().
(The _bh and _sched quiescent states still need to remain at scheduler
entry.)  That would mean that RCU would not queue tasks that entered
the scheduler, but did not actually do a context switch.

Would that be helpful?

							Thanx, Paul

