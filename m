Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1HISJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:09:51 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49564 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1HISJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:09:50 -0400
Date: Tue, 9 Aug 2011 20:09:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110809180942.GC31645@somewhere.redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
 <20110809151155.GA15311@redhat.com>
 <20110809172746.GA31645@somewhere.redhat.com>
 <20110809175708.GA27866@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809175708.GA27866@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 07:57:08PM +0200, Oleg Nesterov wrote:
> On 08/09, Frederic Weisbecker wrote:
> >
> > On Tue, Aug 09, 2011 at 05:11:55PM +0200, Oleg Nesterov wrote:
> > >
> > > This doesn't look right or I missed something.
> > >
> > > What if tsk exits in between? Afaics this can happen with both
> > > cgroup_attach_task() and cgroup_attach_proc().
> > >
> > > Let's look at cgroup_attach_task(). Suppose that
> > > task_counter_can_attach_task() succeeds and charges the new cgrp,
> > > Then cgroup_task_migrate() returns -ESRCH. Who will uncharge the
> > > new cgrp?
> > >
> >
> > I may totally be missing something but that looks safe to me.
> > If the task has exited then cgroup_task_migrate() fails then we
> > rollback with ->cancel_attach_task().
> 
> cgroup_attach_task() doesn't call ->cancel_attach_task() ;)

Oops right, that's missing :)
 
> > > cgroup_attach_proc() is different, it calls cgroup_task_migrate()
> > > after ->attach_task(). Cough.
> >
> > That's bad. I need to fix that.
> >
> > So if it returns -ESRCH, I shall not call attach_task() on it
> > but cancel_attach_task().
> 
> Afaics this can't help, or I misunderstood. probably attach_task()
> can check PF_EXITING...

But cgroup_task_migrate() checks that already before migrating
cgroups (checks PF_EXITING under task_lock() so that it's
synchronized against cgroup_exit())

> > > ->attach_task() can be skipped if cgrp == oldcgrp... Probably this
> > > is fine, in this case can_attach_task() shouldn't actually charge.
> >
> > In fact in this case it simply doesn't charge. res_counter_common_ancestor()
> > returns the res_counter for cgrp as a limit and thus charging stops as soon
> > as it starts.
> 
> Yes, this is what I meant. Just it wasn't immediately obvious for me,
> initially I thought this is buggy.
> 
> > @@ -1295,6 +1295,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> > > >  	p->group_leader = p;
> > > >  	INIT_LIST_HEAD(&p->thread_group);
> > > >
> > > > +	retval = cgroup_task_counter_fork(p);
> > > > +	if (retval)
> > > > +		goto bad_fork_free_pid;
> > > > +
> > >
> > > Well, imho this is not good. You are adding yet another cgroup hook.
> > > Why you can not reuse cgroup_fork_callbacks() ?
> > >
> > > Yes, it returns void. Can't we chane ->fork() to return the error and
> > > make it boolean?
> >
> > That was my first proposition (minus the rollback with exit() that I forgot)
> > but Paul Menage said that added unnecessary complexity in the fork callbacks.
> 
> Hmm. Yes, this adds some complexity in the fork callbacks.
> 
> But yet another cgroup_task_counter_fork() hook complicates the core kernel
> code. And since I personally do not care about cgroups at all, I think this
> is much worse ;)
> 
> > I would personally prefer that.
> 
> I strongly agree.
> 
> OK. Lets do it this way. Perhaps we can convince Paul later and cleanup.

Fine, I'll rewind to that. I would really prefer it that way.

Thanks!
