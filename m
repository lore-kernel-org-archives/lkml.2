Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1GMQd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:33:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35005 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab1GMQd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:33:27 -0400
Date: Wed, 13 Jul 2011 09:33:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep circular locking error (rcu_node_level_0 vs rq->lock)
Message-ID: <20110713163309.GC2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711231932.GB20367@redhat.com>
 <1310502014.2309.7.camel@laptop>
 <20110712205126.GM2326@linux.vnet.ibm.com>
 <1310507047.2309.10.camel@laptop>
 <20110712225443.GS2326@linux.vnet.ibm.com>
 <1310545448.14978.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310545448.14978.40.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 10:24:08AM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 15:54 -0700, Paul E. McKenney wrote:
> > > @@ -892,6 +892,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
> > >        * prev into current:
> > >        */
> > >       spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
> > > +     rcu_read_acquire();
> > 
> > Oooh...  This is a tricky one.  Hmmm...
> 
> <snip>
> 
> > Does any of this make sense?
> 
> No?
> 
> > > @@ -3141,6 +3170,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
> > >        */
> > >  #ifndef __ARCH_WANT_UNLOCKED_CTXSW
> > >       spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
> > > +     rcu_read_release();
> > 
> > My guess is that we don't need the rcu_read_release() -- the arch shouldn't
> > care that we have a non-atomic field in task_struct incremented, right?
> > 
> > Or am I confused about what this is doing?
> 
> Either that or I used the wrong primitives for what I was meaning to do.
> 
> So from looking at rcupdate.h rcu_read_{acquire,release} are the lockdep
> annotations of the rcu_read_lock. The thing we're doing above is context
> switching and not making lockdep upset.
> 
> The problem is that held lock state is tracked per task, and we're well
> switching tasks, so we need to transfer the held lock state from the old
> to the new task, since the new task will be unlocking the thing, if at
> that time lockdep finds we're not actually holding it it screams bloody
> murder.
> 
> So what we do is we release the lock (annotation only, the actual lock
> says locked) on prev before switching and acquire the lock on next right
> after switching.

OK, got it.  I think, anyway.

So preemptible RCU and context switches are handled as follows by
your patch, correct?

1.	The outgoing task is in an RCU read-side critical section
	due to the rcu_read_lock() that you added at the beginning
	of schedule().

2.	In context_switch(), the lockdep state is set so that lockdep
	believes that the task has exited its RCU read-side critical
	section (thus suppressing the lockdep splat that would otherwise
	appear).

3.	Once the context switch has happened, RCU no longer pays
	attention to the outgoing task.  So the outgoing task's
	current->rcu_read_lock_nesting still indicates that the task is in
	an RCU read-side critical section, but RCU does not know or care.

4.	If the incoming task has done at least one prior context switch,
	its current->rcu_read_lock_nesting will indicate that it is
	already in an RCU read-side critical section.  Since there is
	no opportunity for RCU to report a quiescent state during the
	context switch itself (because holding the runqueue lock keeps
	interrupts disabled), RCU sees the whole context switch event
	as being one big RCU read-side critical section.

	If interrupts were enabled at any point, RCU might see this as
	two back-to-back read-side critical sections.  This might be
	OK for all I know, but it would open the door more widely to
	heavyweight RCU processing at rcu_read_unlock() time.

5.	Yes, context switch is a quiescent state, but that quiescent
	state happens when rcu_note_context_switch() is called from
	schedule, which is before the runqueue lock is acquired, and
	thus before the beginning of the RCU read-side critical section
	that covers the context switch.

6.	In finish_lock_switch(), the rcu_read_acquire() restores
	lockdep state to match that of the incoming task.

	But if the task is newly created, then its value of
	current->rcu_read_lock_nesting will be zero, which will leave
	the incoming task unprotected by RCU.  I believe that you
	need the (untested) patch below to make this work properly.
	But this patch needs to be included in your set, as I don't
	immediately see a reasonable way to make it work independently.
	(Yes, we could have a special CONFIG var for the transition,
	but it sounds a lot easier to just have it be part of your patch.)

7.	Exit processing is done by the task itself before a last
	call to schedule().  From what I can see, it should not matter
	that the value of current->rcu_read_lock_nesting gets incremented
	on this last TASK_DEAD call to schedule().

Or am I still confused?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 580f70c..617a323 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -106,7 +106,7 @@ extern struct group_info init_groups;
 #endif
 #ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
-	.rcu_read_lock_nesting = 0,					\
+	.rcu_read_lock_nesting = 1,					\
 	.rcu_read_unlock_special = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
 	INIT_TASK_RCU_TREE_PREEMPT()					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..6baa51bb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1822,7 +1822,7 @@ extern void task_clear_group_stop_pending(struct task_struct *task);
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
-	p->rcu_read_lock_nesting = 0;
+	p->rcu_read_lock_nesting = 1;
 	p->rcu_read_unlock_special = 0;
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
