Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0FVWMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:12:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42258 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0FVWMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:12:30 -0400
Date: Tue, 22 Jun 2010 15:12:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100622221226.GP2290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618190251.GA17297@redhat.com>
 <20100618193403.GA17314@redhat.com>
 <20100618223354.GL2365@linux.vnet.ibm.com>
 <20100621170919.GA13826@redhat.com>
 <20100621205128.GI2354@linux.vnet.ibm.com>
 <20100622212357.GA19670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622212357.GA19670@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 11:23:57PM +0200, Oleg Nesterov wrote:
> On 06/21, Paul E. McKenney wrote:
> >
> > Indeed, the tough part is figuring out when you are done given that things
> > can come and go at will.  Some additional tricks, in no particular order:
> >
> > 1.	Always start at the group leader.
> 
> We can't. We have users which start at the arbitrary thread.

OK.

> > 2.	Maintain a separate task structure that flags the head of the
> > 	list.  This separate structure is freed one RCU grace period
> > 	following the disappearance of the current group leader.
> 
> Even simpler, we can just add list_head into signal_struct. I thought
> about this, but this breaks thread_group_empty (this is fixeable) and,
> again, I'd like very much to avoid adding new fields into task_struct
> or signal_struct.

Understood.

> > > Well, another field in task_struct...
> >
> > Yeah, would be good to avoid this.  Not sure it can be avoided, though.
> 
> Why? I think next_thread_careful() from
> 	http://marc.info/?l=linux-kernel&m=127714242731448
> should work.
> 
> If the caller holds tasklist or siglock, this change has no effect.
> 
> If the caller does while_each_thread() under rcu_read_lock(), then
> it is OK to break the loop earlier than we do now. The lockless
> while_each_thread() works in a "best effort" manner anyway, if it
> races with exit_group() or exec() it can miss some/most/all sub-threads
> (including the new leader) with or without this change.
> 
> Yes, zap_threads() needs additional fixes. But I think it is better
> to complicate a couple of lockless callers (or just change them
> to take tasklist) which must not miss an "interesting" thread.

Is it the case that creating a new group leader from an existing group
always destroys the old group?  It certainly is the case for exec().

In my earlier emails, I was assuming that it was possible to create a
new thread group without destroying the old one, and that the thread
group leader might leave the thread group and form a new one, so that a
new thread group leader would be selected for the old group.  I suspect
that I was confused.  ;-)

Anyway, if creating a new thread group implies destroying the old one,
and if the thread group leader cannot be concurrently creating a new
thread group and traversing the old one, then yes, I do believe your
code at http://marc.info/?l=linux-kernel&m=127714242731448 will work.

Assuming that the call to next_thread_careful(t) in the definition of
while_each_thread() is replaced with next_thread_careful(g,t).

And give or take memory barriers.

The implied memory barrier mentioned in the comment in your example code
is the spin_lock_irqsave() and spin_unlock_irqrestore() in free_pid(),
which is called from __change_pid() which is called from detach_pid()?
One some platforms, code may be reordered from both sides into the
resulting critical section, so you actually need two non-overlapping
lock-based critical sections to guarantee full memory-barrier semantics.

And the atomic_inc() in free_pidmap() is not required to provide
memory-barrier semantics, and does not do so on all platforms.

Or does the implied memory barrier correspond to the first of three calls
to detach_pid() in __unhash_process()?  (The above analysis assumes that
it corresponds to the last of the three.)

> > > > o	Do the de_thread() incrementally.  So if the list is tasks A,
> > > > 	B, and C, in that order, and if we are de-thread()ing B,
> > > > 	then make A's pointer refer to C,
> > >
> > > This breaks while_each_thread() under tasklist/siglock. It must
> > > see all unhashed tasks.
> >
> > Could de_thread() hold those locks in order to avoid that breakage?
> 
> How can it hold, say, siglock? We need to wait a grace period.
> To clarify. de_thread() kills all threads except the group_leader,
> so we have only 2 threads: group_leader A and B.
> 
> If we add synchronize_rcu() before release_task(leader) (as Roland
> suggested), then we don't need to change A's pointer. This probably
> fixes while_each_thread() in the common case. But this disallows
> the tricks like rcu_lock_break().
> 
> 
> And. Whatever we do with de_thread(), this can't fix the lockless
> while_each_thread(not_a_group_leader, t). I do not know if there is
> any user which does this though.
> fastpath_timer_check()->thread_group_cputimer() does this, but this
> is wrong and we already have the patch which removes it.

Indeed.  Suppose that the starting task is the one immediately preceding
the task group leader.  You get a pointer to the task in question
and traverse to the next task (the task group leader), during which
time the thread group leader does exec() and maybe a pthread_create()
or two.  Oops!  You are now now traversing the wrong thread group!

There are ways of fixing this, but all the ones I know of require more
fields in the task structure, so best if we don't need to start somewhere
other than a group leader.

							Thanx, Paul
