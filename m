Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1HIR15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:27:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54654 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1HIR1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:27:55 -0400
Date: Tue, 9 Aug 2011 19:27:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110809172746.GA31645@somewhere.redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
 <20110809151155.GA15311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809151155.GA15311@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 05:11:55PM +0200, Oleg Nesterov wrote:
> On 07/29, Frederic Weisbecker wrote:
> >
> > +static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
> > +					struct task_struct *tsk)
> > +{
> > +	struct res_counter *res = cgroup_task_counter_res(cgrp);
> > +	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
> > +	struct res_counter *limit_fail_at;
> > +
> > +	common_ancestor = res_counter_common_ancestor(res, old_res);
> > +
> > +	return res_counter_charge_until(res, common_ancestor, 1, &limit_fail_at);
> > +}
> >
> > ...
> >
> > +static void task_counter_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
> > +				     struct task_struct *tsk)
> > +{
> > +	res_counter_uncharge_until(cgroup_task_counter_res(old_cgrp), common_ancestor, 1);
> > +}
> 
> This doesn't look right or I missed something.
> 
> What if tsk exits in between? Afaics this can happen with both
> cgroup_attach_task() and cgroup_attach_proc().
> 
> Let's look at cgroup_attach_task(). Suppose that
> task_counter_can_attach_task() succeeds and charges the new cgrp,
> Then cgroup_task_migrate() returns -ESRCH. Who will uncharge the
> new cgrp?
> 

I may totally be missing something but that looks safe to me.
If the task has exited then cgroup_task_migrate() fails then we
rollback with ->cancel_attach_task().

Let me enumerate the possible scenario (may not be exhaustive):

* The task exits (called cgroup_exit()) before we cgroup_task_migrate()
switch the cgroup. In this case we rollback the charge we pushed
on the new cgoup and we return an error.

* The task exits after cgroup_task_migrate(), in which case cgroup
called ->exit() on the task with the new cgroup, uncharging that
task from it. At the same time we call ->attach_task() to uncharge the
old cgroup, which is still what we want as we confirmed the cgroup
migration.
 
> cgroup_attach_proc() is different, it calls cgroup_task_migrate()
> after ->attach_task(). Cough.

That's bad. I need to fix that.

So if it returns -ESRCH, I shall not call attach_task() on it
but cancel_attach_task().

Other than that it should be safe as in the single task case.

> In this case old_cgrp can be uncharged twice, no? And again, nobody
> will uncharge the new cgrp?

(see above)

> ->attach_task() can be skipped if cgrp == oldcgrp... Probably this
> is fine, in this case can_attach_task() shouldn't actually charge.

In fact in this case it simply doesn't charge. res_counter_common_ancestor()
returns the res_counter for cgrp as a limit and thus charging stops as soon
as it starts.
 
> 
> > @@ -1295,6 +1295,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  	p->group_leader = p;
> >  	INIT_LIST_HEAD(&p->thread_group);
> >
> > +	retval = cgroup_task_counter_fork(p);
> > +	if (retval)
> > +		goto bad_fork_free_pid;
> > +
> 
> Well, imho this is not good. You are adding yet another cgroup hook.
> Why you can not reuse cgroup_fork_callbacks() ?
> 
> Yes, it returns void. Can't we chane ->fork() to return the error and
> make it boolean?

That was my first proposition (minus the rollback with exit() that I forgot)
but Paul Menage said that added unnecessary complexity in the fork callbacks.

> 
> Better yet,
> 
> 	-	cgroup_fork_callbacks(p);
> 	-	cgroup_callbacks_done = 1;
> 	+	failed_ss = cgroup_fork_callbacks(p);
> 	+	if (failed_ss)
> 	+		goto bad_fork_free_pid;
> 
> 	...
> 
> 	-	cgroup_exit(p, cgroup_callbacks_done);
> 	+	cgroup_exit(p, failed_ss);
> 
> What do you think?

I would personally prefer that.

> Oleg.
> 
