Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0FCOo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:44:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab0FCOo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:44:58 -0400
Date: Thu, 3 Jun 2010 16:43:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com, menage@google.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100603144321.GA6284@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu> <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu> <20100531175242.GA14691@redhat.com> <20100603045629.GC21006@ghc02.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603045629.GC21006@ghc02.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Ben Blum wrote:
>
> On Mon, May 31, 2010 at 07:52:42PM +0200, Oleg Nesterov wrote:
> >
> > OK, the caller has a reference to the argument, leader,
> >
> > > +	leader = leader->group_leader;
> >
> > But why it is safe to use leader->group_leader if we race with exec?
>
> This line means "let's try to find who the leader is", since
> attach_task_by_pid doesn't grab it for us. It's not "safe", and we still
> check if it's really the leader later (just before the 'commit point').

It is not safe to even dereference this memory, it can point to nowhere.
I do not remember how this patch does "check if it's really the leader later",
but in any case this is too late: iirc at least can_attach(leader) was called.

> Note that before this line 'leader' doesn't really mean the leader -

Yes,

> perhaps i should rename the variables :P
>
> But maybe I also want to grab a reference on the new task?

Of course.

Not that I really understand why this task must be ->group_leader at
this point.

> > > +	list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group) {
> >
> > Even if we didn't change "leader" above, this is not safe in theory.
> > We already discussed this, list_for_each_rcu(head) is only safe when
> > we know that "head" itself is valid.
> >
> > Suppose that this leader exits, then leader->thread_group.next exits
> > too before we take rcu_read_lock().
>
> Why is that a problem? I thought leader->thread_group is supposed to
> stay sane as long as leader is the leader.

Unless we race with exec/exit. Yes, this race is very unlikely.

> This looks like it needs a check to see if 'leader' is still really the
> leader, but nothing more.

Or you can check pid_alive(). Again, you don't really need ->group_leader
to iterate over thread-group.

> > > +	oldcgrp = task_cgroup_from_root(leader, root);
> > > +	if (cgrp != oldcgrp) {
> > > +		retval = cgroup_task_migrate(cgrp, oldcgrp, leader, true);
> > > +		BUG_ON(retval != 0 && retval != -ESRCH);
> > > +	}
> > > +	/* Now iterate over each thread in the group. */
> > > +	list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group) {
> > > +		BUG_ON(tsk->signal != leader->signal);
> > > +		/* leave current thread as it is if it's already there */
> > > +		oldcgrp = task_cgroup_from_root(tsk, root);
> > > +		if (cgrp == oldcgrp)
> > > +			continue;
> > > +		/* we don't care whether these threads are exiting */
> > > +		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
> > > +		BUG_ON(retval != 0 && retval != -ESRCH);
> > > +	}
> >
> > This looks strange. Why do we move leader outside of the loop ?
> > Of course, list_for_each_entry() can't work to move all sub-threads,
> > but "do while_each_thread()" can.
>
> do/while_each_thread oves over all threads in the system, rather than
> just the threadgroup... this isn't supposed to be a fast operation, but
> that seems like overkill.

What are you talking about? ;)

do/while_each_thread iterates over threadgroup.

Oleg.

