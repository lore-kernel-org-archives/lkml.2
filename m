Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0FRWd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:33:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34409 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0FRWd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:33:57 -0400
Date: Fri, 18 Jun 2010 15:33:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100618223354.GL2365@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618190251.GA17297@redhat.com>
 <20100618193403.GA17314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618193403.GA17314@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 09:34:03PM +0200, Oleg Nesterov wrote:
> (add cc's)
> 
> Hmm. Once I sent this patch, I suddenly realized with horror that
> while_each_thread() is NOT safe under rcu_read_lock(). Both
> do_each_thread/while_each_thread or do/while_each_thread() can
> race with exec().
> 
> Yes, it is safe to do next_thread() or next_task(). But:
> 
> 	#define while_each_thread(g, t) \
> 		while ((t = next_thread(t)) != g)
> 
> suppose that t is not the group leader, and it does de_thread() and then
> release_task(g). After that next_thread(t) returns t, not g, and the loop
> will never stop.
> 
> I _really_ hope I missed something, will recheck tomorrow with the fresh
> head. Still I'd like to share my concerns...
> 
> If I am right, probably we can fix this, something like
> 
> 	#define while_each_thread(g, t) \
> 		while ((t = next_thread(t)) != g && pid_alive(g))
> 
> [we can't do while (!thread_group_leadr(t = next_thread(t)))].
> but this needs barrires, and we should validate the callers anyway.
> 
> Or, perhaps,
> 
> 	#define XXX(t)	({
> 		struct task_struct *__prev = t;
> 		t = next_thread(t);
> 		t != g && t != __prev;
> 	})
> 
> 	#define while_each_thread(g, t) \
> 		while (XXX(t))

Isn't the above vulnerable to a pthread_create() immediately following
the offending exec()?  Especially if the task doing the traversal is
preempted?

I cannot claim to understand the task-list code, but here are some
techniques that might (or might not) help:

o	Check ACCESS_ONCE(p->group_leader == g), if false, restart
	the traversal.  Any race on update of p->group_leader would
	sort itself out on later iterations.  This of course might
	require careful attention of the order of updates to ->group_leader
	and the list pointers.  I also don't like it much from a
	worst-case response-time viewpoint.  ;-)

	Plus it requires all operations on the tasks be idempotent,
	which is a bit ugly and restrictive.

o	Maintain an ->oldnext field that tracks the old pointer to
	the next task for one RCU grace period after a de_thread()
	operation.  When the grace period expires (presumably via
	call_rcu()), the ->oldnext field is set to NULL.

	If the ->oldnext field is non-NULL, any subsequent de_thread()
	operations wait until it is NULL.  (I convinced myself that
	pthread_create() need -not- wait, but perhaps mistakenly --
	the idea is that any recent de_thread() victim remains group
	leader, so is skipped by while_each_thread(), but you would
	know better than I.)

	Then while_each_thread() does checks similar to what you have
	above, possibly with the addition of the ->group_leader check,
	but follows the ->oldnext pointer if the checks indicate that
	this task has de_thread()ed itself.  The ->oldnext access will
	need to be preceded by a memory barrier, but this is off the
	fast path, so should be OK.  There would also need to be
	memory barriers on the update side.

o	Do the de_thread() incrementally.  So if the list is tasks A,
	B, and C, in that order, and if we are de-thread()ing B,
	then make A's pointer refer to C, wait a grace period, then
	complete the de_thread() operation.  I would be surprised if
	people would actually be happy with the resulting increase in
	exec() overhead, but mentioning it for completeness.  Of course,
	synchronize_rcu_expedited() has much shorter latency, and might
	work in this situation.  (Though please do let me know if you
	choose this approach -- it will mean that I need to worry about
	synchronize_rcu_expedited() scalability sooner rather than
	later!  Which is OK as long as I know.)

	This all assumes that is OK for de_thread() to block, but I have
	no idea if this is the case.

> Please tell me I am wrong!

It would take a braver man than me to say that Oleg Nesterov is wrong!

							Thanx, Paul

> Oleg.
> 
> On 06/18, Oleg Nesterov wrote:
> >
> > check_hung_uninterruptible_tasks()->rcu_lock_break() introduced by
> > "softlockup: check all tasks in hung_task" commit ce9dbe24 looks
> > absolutely wrong.
> >
> > 	- rcu_lock_break() does put_task_struct(). If the task has exited
> > 	  it is not safe to even read its ->state, nothing protects this
> > 	  task_struct.
> >
> > 	- The TASK_DEAD checks are wrong too. Contrary to the comment, we
> > 	  can't use it to check if the task was unhashed. It can be unhashed
> > 	  without TASK_DEAD, or it can be valid with TASK_DEAD.
> >
> > 	  For example, an autoreaping task can do release_task(current)
> > 	  long before it sets TASK_DEAD in do_exit().
> >
> > 	  Or, a zombie task can have ->state == TASK_DEAD but release_task()
> > 	  was not called, and in this case we must not break the loop.
> >
> > Change this code to check pid_alive() instead, and do this before we
> > drop the reference to the task_struct.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >
> >  kernel/hung_task.c |   11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > --- 35-rc2/kernel/hung_task.c~CHT_FIX_RCU_LOCK_BREAK	2009-12-18 19:05:38.000000000 +0100
> > +++ 35-rc2/kernel/hung_task.c	2010-06-18 20:06:11.000000000 +0200
> > @@ -113,15 +113,20 @@ static void check_hung_task(struct task_
> >   * For preemptible RCU it is sufficient to call rcu_read_unlock in order
> >   * exit the grace period. For classic RCU, a reschedule is required.
> >   */
> > -static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
> > +static bool rcu_lock_break(struct task_struct *g, struct task_struct *t)
> >  {
> > +	bool can_cont;
> > +
> >  	get_task_struct(g);
> >  	get_task_struct(t);
> >  	rcu_read_unlock();
> >  	cond_resched();
> >  	rcu_read_lock();
> > +	can_cont = pid_alive(g) && pid_alive(t);
> >  	put_task_struct(t);
> >  	put_task_struct(g);
> > +
> > +	return can_cont;
> >  }
> >
> >  /*
> > @@ -148,9 +153,7 @@ static void check_hung_uninterruptible_t
> >  			goto unlock;
> >  		if (!--batch_count) {
> >  			batch_count = HUNG_TASK_BATCHING;
> > -			rcu_lock_break(g, t);
> > -			/* Exit if t or g was unhashed during refresh. */
> > -			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> > +			if (!rcu_lock_break(g, t))
> >  				goto unlock;
> >  		}
> >  		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
> 
