Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0FWP0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0FWP0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:26:22 -0400
Date: Wed, 23 Jun 2010 17:24:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100623152421.GA8445@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621205128.GI2354@linux.vnet.ibm.com> <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622221226.GP2290@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Paul E. McKenney wrote:
>
> On Tue, Jun 22, 2010 at 11:23:57PM +0200, Oleg Nesterov wrote:
> > On 06/21, Paul E. McKenney wrote:
> > >
> > > Yeah, would be good to avoid this.  Not sure it can be avoided, though.
> >
> > Why? I think next_thread_careful() from
> > 	http://marc.info/?l=linux-kernel&m=127714242731448
> > should work.
> >
> > If the caller holds tasklist or siglock, this change has no effect.
> >
> > If the caller does while_each_thread() under rcu_read_lock(), then
> > it is OK to break the loop earlier than we do now. The lockless
> > while_each_thread() works in a "best effort" manner anyway, if it
> > races with exit_group() or exec() it can miss some/most/all sub-threads
> > (including the new leader) with or without this change.
> >
> > Yes, zap_threads() needs additional fixes. But I think it is better
> > to complicate a couple of lockless callers (or just change them
> > to take tasklist) which must not miss an "interesting" thread.
>
> Is it the case that creating a new group leader from an existing group
> always destroys the old group?  It certainly is the case for exec().

Yes. And only exec() can change the leader.

> Anyway, if creating a new thread group implies destroying the old one,
> and if the thread group leader cannot be concurrently creating a new
> thread group and traversing the old one, then yes, I do believe your
> code at http://marc.info/?l=linux-kernel&m=127714242731448 will work.
>
> Assuming that the call to next_thread_careful(t) in the definition of
> while_each_thread() is replaced with next_thread_careful(g,t).

Great.

> And give or take memory barriers.
>
> The implied memory barrier mentioned in the comment in your example code
> is the spin_lock_irqsave() and spin_unlock_irqrestore()

Argh. No, no, no. I meant unlock + lock, not lock + unlock. But when
I look at __change_pid() now I do not see the 2nd lock() after
unlock(pidmap_lock). I was wrong, thanks.

And, even if I was correct it is not nice to rely on the internals
of detach_pid(). If we use next_thread_careful(), __unhash_process()
needs wmb.

Thanks!

> > And. Whatever we do with de_thread(), this can't fix the lockless
> > while_each_thread(not_a_group_leader, t). I do not know if there is
> > any user which does this though.
> > fastpath_timer_check()->thread_group_cputimer() does this, but this
> > is wrong and we already have the patch which removes it.
>
> Indeed.  Suppose that the starting task is the one immediately preceding
> the task group leader.  You get a pointer to the task in question
> and traverse to the next task (the task group leader), during which
> time the thread group leader does exec() and maybe a pthread_create()
> or two.  Oops!  You are now now traversing the wrong thread group!

Yes, but there is another more simple and much more feasible race.
while_each_thread(non_leader, t) will loop forever if non_leader
simply exits and passes __unhash_process(). After that next_thread(t)
can never return non_leader.

> There are ways of fixing this, but all the ones I know of require more
> fields in the task structure,

Just in case, I hope that next_thread_careful() handles this case too.

> so best if we don't need to start somewhere
> other than a group leader.

(I assume, you mean the lockless case)

I am not sure. Because it is not trivial to enforce this rule even if
we add a fat comment. Please look at check_hung_uninterruptible_tasks().
It does do_each_thread/while_each_thread and thus it always starts at
the leader. But in fact this is not true due to rcu_lock_break().

Or proc_task_readdir(). It finds the leader, does get_task_struct(leader)
and drops rcu lock. After that first_tid() takes rcu_read_lock() again
and does the open coded while_each_thread(). At first glance this case
looks fine, "for (pos = leader; nr > 0; --nr)" can't loop forever.
But in fact it is not:

	- proc_task_readdir() finds the leader L, does get_task_struct()
	  and drops rcu lock.

	  Suppose that filp->f_pos >= 2.
          Suppose also that the previous tid cached in filp->f_version
          is no longer valid.

	  The caller is preempted.

	- a sub-thread T does exec, and does release_task(L).

	  But L->thread_group->next == T, so far everything is good

	- T spawns other sub-threads (so that get_nr_threads() > nr)
	  and exits.

	- grace period passes, T's task_struct is freed/unmapped/reused

	- proc_task_readdir() resumes and calls first_tid(L).

	  next_thread(L) returns T == nowhere

It is very possible that I missed something here, my only point is
that I think it would be safer to assume nothing about the leaderness.

Oleg.

