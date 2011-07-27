Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1G0Xml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 19:42:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45773 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1G0Xmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 19:42:39 -0400
Date: Wed, 27 Jul 2011 16:42:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: NeilBrown <neilb@suse.de>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Oleg Nesterov <oleg@tv-sign.ru>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
 questionable code in de_thread.
Message-ID: <20110727234235.GA2318@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727150710.GB5242@unix33.andrew.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 11:07:10AM -0400, Ben Blum wrote:
> On Wed, Jul 27, 2011 at 05:11:01PM +1000, NeilBrown wrote:

[ . . . ]

> >  The race as I understand it is with this code:
> > 
> > 
> > 		list_replace_rcu(&leader->tasks, &tsk->tasks);
> > 		list_replace_init(&leader->sibling, &tsk->sibling);
> > 
> > 		tsk->group_leader = tsk;
> > 		leader->group_leader = tsk;
> > 
> > 
> >  which seems to be called with only tasklist_lock held, which doesn't seem to
> >  be held in the cgroup code.
> > 
> >  If the "thread_group_leader(leader)" call in cgroup_attach_proc() runs before
> >  this chunk is run with the same value for 'leader', but the
> >  while_each_thread is run after, then the while_read_thread() might loop
> >  forever.  rcu_read_lock doesn't prevent this from happening.
> 
> Somehow I was under the impression that holding tasklist_lock (for
> writing) provided exclusion from code that holds rcu_read_lock -
> probably because there are other points in the kernel which do
> while_each_thread with only RCU-read held (and not tasklist):
> 
> - kernel/hung_task.c, check_hung_uninterruptible_tasks()

This one looks OK to me.  The code is just referencing fields in each
of the task structures, and appears to be making proper use of
rcu_dereference().  All this code requires is that the task structures
remain in existence through the full lifetime of the RCU read-side
critical section, which is guaranteed because of the way the task_struct
is freed.

> - kernel/posix-cpu-timers.c, thread_group_cputime()

Same story here.  The code only needs the task_struct structures to
stick around long enough to compute the CPU time consumed, so this
should be OK.

> - fs/ioprio.c, ioprio_set() and ioprio_get()

Here RCU protects traversal to the task structure as in the two
examples above.  In the ioprio_set() case, the actual change is
carried out under task_lock().  So this code relies on RCU to
safely locate the task structure, and on locking to safely carry
out the update.

The ioprio_get() is using RCU to protect finding the task structure.
This returns an integer (the I/O priority), so no locking is required.
Though if compilers continue becoming increasingly aggressive with
their optimizations, there might need to be an ACCESS_ONCE()
in get_task_ioprio().

> (There are also places, like kernel/signal.c, where code does
> while_each_thread with only sighand->siglock held. this also seems
> sketchy, since de_thread only takes that lock after the code quoted
> above. there's a big comment in fs/exec.c where this is also done, but I
> don't quite understand it.)
> 
> You seem to imply that rcu_read_lock() doesn't exclude against
> write_lock(&tasklist_lock). If that's true, then we can fix the cgroup
> code simply by replacing rcu_read_lock/rcu_read_unlock with
> read_lock and read_unlocck on tasklist_lock. (I can hurry a bugfix patch
> for this together if so.)

Indeed, rcu_read_lock() does not exclude write_lock(&tasklist_lock).
In fact, it doesn't exclude against -any- lock.  But don't take my
word for it, instead take a look at the heaviest-weight implementation
of rcu_read_lock() that currently exists in mainline:

	void __rcu_read_lock(void)
	{
		current->rcu_read_lock_nesting++;
		barrier();
	}

That really is all there is to it, at least in the absence of
CONFIG_PROVE_RCU.  The first line does nothing more than increment a
counter in the current tasks task_struct, while the second line does
nothing more than suppress code-motion optimizations that the compiler
might otherwise be tempted to undertake.

The purpose of rcu_read_lock() is instead to prevent any subsequent
synchronize_rcu() calls (on any CPU or from any task) from returning
until this task executes the matching rcu_read_unlock().  If you
make careful use of rcu_read_lock(), synchronize_rcu(), and friends,
you can get an effect that in some ways resembles mutual exclusion,
but that is much faster and more scalable.

In the case of the task structure, rcu_read_lock() guarantees that
any task_struct that you can get a pointer to will remain in
existence until you execute the matching rcu_read_unlock().
By "remain in existence", I mean that the task_struct won't be
freed (and possibly reused).

So rcu_read_lock() is giving you the following guarantee:  If you
legitimately pick up a pointer to an RCU-protected data structure,
then that data structure will not be freed until after you execute
the matching rcu_read_unlock().

> Wouldn't this mean that the three places listed above are also wrong?

I do not believe so, give or take the ACCESS_ONCE().

The issue in your case is that you are relying not just on the
process to exist, but also on the state of group leadership.
RCU protects the former, but not the latter.

I suspect that your suggested bugfix patch would do the trick, but
I must defer to people who understand tasklist locking better than
I do.

							Thanx, Paul

> >  The code in de_thread() is actually questionable by itself.
> >  "list_replace_rcu" cannot really be used on the head of a list - it is only
> >  meant to be used on a member of a list.
> >  To move a list from one head to another you should be using
> >  list_splice_init_rcu().
> >  The ->tasks list doesn't seem to have a clearly distinguished 'head' but
> >  whatever is passed as 'g' to while_each_thread() is effectively a head and
> >  removing it from a list can cause a loop using while_each_thread() can not
> >  find the head and so never complete.
> > 
> >  I' not sure how best to fix this, though possibly changing
> >  while_each_thead to:
> > 
> >    while ((t = next_task(t)) != g && !thread_group_leader(t))
> > 
> >  might be part of it.  We would also need to move 
> >     tsk->group_leader = tsk;
> >  in the above up to the top, and probably add some memory barrier.
> >  However I don't know enough about how the list is used to be sure.
> > 
> > Comments?
> > 
> > Thanks,
> > NeilBrown
> > 
> > 
> 
> I barely understand de_thread() from the reader's perspective, let alone
> from the author's perspective, so I can't speak for that one.
> 
> Thanks for pointing this out!
> 
> -- Ben
