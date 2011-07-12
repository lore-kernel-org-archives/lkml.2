Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1GLWyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:54:46 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50544 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab1GLWyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:54:45 -0400
Date: Tue, 12 Jul 2011 15:54:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep circular locking error (rcu_node_level_0 vs rq->lock)
Message-ID: <20110712225443.GS2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711231932.GB20367@redhat.com>
 <1310502014.2309.7.camel@laptop>
 <20110712205126.GM2326@linux.vnet.ibm.com>
 <1310507047.2309.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310507047.2309.10.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 11:44:07PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 13:51 -0700, Paul E. McKenney wrote:
> > 
> > So I am hoping that your idea of doing rcu_read_lock() before acquiring
> > rq locks (and pi locks) and doing rcu_read_unlock() after releasing them
> > does work out! 
> 
> it would look something like the below, except that it needs some
> performance testing, it does add a lot of rcu fiddling to hot paths.
> 
> Need sleep now.. will poke more in the morning.

Very cool!!!

Just a couple of comments below, one on rcu_read_acquire() and one
on rcu_read_release().

							Thanx, Paul

> ---
>  kernel/sched.c      |   76 ++++++++++++++++++++++++++++++++++++++-------------
>  kernel/sched_fair.c |   14 +++++++---
>  kernel/sched_rt.c   |    6 ++++
>  3 files changed, 73 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9769c75..4bf0951 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -892,6 +892,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
>  	 * prev into current:
>  	 */
>  	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
> +	rcu_read_acquire();

Oooh...  This is a tricky one.  Hmmm...

The !PREEMPT_RCU case seems straightforward, but the PREEMPT_RCU case
needs some thought.

OK, so the outgoing task did an rcu_read_lock(), but it did so -after-
the scheduler invoked rcu_note_context_switch(), correct?  This means
that the outgoing task has its current->rcu_read_lock_nesting set to 1
(assuming that the task didn't enter schedule() within an RCU read-side
critical section), but that the task is not queued on the rcu_node
structure's blkd_tasks list.  This means that the outgoing task's
RCU read-side critical section is being ignored, because only the
->rcu_read_lock_nesting variables of tasks actually running at the
time are paid attention to.

When that task is scheduled once again, its RCU read-side critical
section will suddenly be paid attention to once again.  So maybe
we can just rely on this behavior.

One complication would be newly created tasks that never have run,
because they would not be in RCU read-side critical sections.  They could
be initialized to be born in RCU read-side critical sections, which again
RCU would be ignoring until such time as the task actually started running.

Another complication would be at task-exit time -- it seems like it would
be necessary to avoid the current logic that screams if a task exits
while in an RCU read-side critical section.  But maybe not -- after all,
doesn't the task make those checks on its own, before its final context
switch into oblivion?  If so, it just might all work out without changes.

OK, back to the case where the task called schedule() from within
an RCU read-side critical section.  In this case, the task was queued,
but gets an extra increment of current->rcu_read_lock_nesting after
being queued.  And this extra increment is matched by the extra
decrement when it is scheduled back in, right?  So this should work
out naturally.

Yeah, I know, famous last words.

So I believe that the rcu_read_acquire() you have above is not needed.
Instead, some code to initialize tasks to be born in RCU read-side
critical sections is required.  Which will in turn mean that boot-time
RCU callbacks get deferred until the scheduler is doing context switches
for PREEMPT_RCU kernels, though this can be hacked around if required.
(Boot-time synchronize_rcu() invocations will continue to take their
fast paths, so will continue to work normally, from what I can see at
the moment.)

Does any of this make sense?

>  	raw_spin_unlock_irq(&rq->lock);
>  }
> @@ -960,6 +961,7 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
>  	struct rq *rq;
> 
>  	for (;;) {
> +		rcu_read_lock();
>  		raw_spin_lock_irqsave(&p->pi_lock, *flags);
>  		rq = task_rq(p);
>  		raw_spin_lock(&rq->lock);

[ . . . ]

> @@ -3055,10 +3082,12 @@ static inline void post_schedule(struct rq *rq)
>  	if (rq->post_schedule) {
>  		unsigned long flags;
> 
> +		rcu_read_lock();
>  		raw_spin_lock_irqsave(&rq->lock, flags);
>  		if (rq->curr->sched_class->post_schedule)
>  			rq->curr->sched_class->post_schedule(rq);
>  		raw_spin_unlock_irqrestore(&rq->lock, flags);
> +		rcu_read_unlock();
> 
>  		rq->post_schedule = 0;
>  	}
> @@ -3141,6 +3170,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
>  	 */
>  #ifndef __ARCH_WANT_UNLOCKED_CTXSW
>  	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
> +	rcu_read_release();

My guess is that we don't need the rcu_read_release() -- the arch shouldn't
care that we have a non-atomic field in task_struct incremented, right?

Or am I confused about what this is doing?

>  #endif
> 
>  	/* Here we just switch the register state and the stack. */
> @@ -3607,6 +3637,7 @@ void sched_exec(void)
>  	unsigned long flags;
>  	int dest_cpu;
> 
> +	rcu_read_lock();
>  	raw_spin_lock_irqsave(&p->pi_lock, flags);
>  	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
>  	if (dest_cpu == smp_processor_id())
> @@ -3621,6 +3652,7 @@ void sched_exec(void)

[ . . . ]
