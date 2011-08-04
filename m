Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1HDOFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:05:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59753 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1HDOFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:05:34 -0400
Date: Thu, 4 Aug 2011 16:05:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110804140525.GF5768@somewhere.redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
 <20110801161347.5f4aeeeb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801161347.5f4aeeeb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 04:13:47PM -0700, Andrew Morton wrote:
> On Fri, 29 Jul 2011 18:13:29 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Add a new subsystem to limit the number of running tasks,
> > similar to the NR_PROC rlimit but in the scope of a cgroup.
> > 
> > This is a step to be able to isolate a bit more a cgroup against
> > the rest of the system and limit the global impact of a fork bomb
> > inside a given cgroup.
> > 
> > ...
> >
> > +config CGROUP_TASK_COUNTER
> > +        bool "Control number of tasks in a cgroup"
> > +	depends on RESOURCE_COUNTERS
> > +	help
> > +	  This option let the user to set up an upper bound allowed number
> > +	  of tasks inside a cgroup.
> 
> whitespace went weird.

Yep, will fix.
 
> > 
> > ...
> >
>  +
> > +static void task_counter_post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
> > +{
> > +	res_counter_inherit(cgroup_task_counter_res(cgrp), RES_LIMIT);
> 
> cgroup_task_counter_res() has code in it to carefully return NULL in
> one situation, but if it does this, res_counter_inherit() will then
> cheerily oops.  This makes no sense.

Right but the only cgroup for which it returns NULL is the root cgroup.
But we don't post clone the root cgroup itself since it has no parent.

So this can't happen, but I can still add a warn_on condition that escapes.

> > +}
> > +
> > 
> > ...
> >
> > +/* Protected amongst can_attach_task/attach_task/cancel_attach_task by cgroup mutex */
> > +static struct res_counter *common_ancestor;
> > +
> > +static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
> > +					struct task_struct *tsk)
> > +{
> > +	struct res_counter *res = cgroup_task_counter_res(cgrp);
> > +	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
> > +	struct res_counter *limit_fail_at;
> > +
> > +	common_ancestor = res_counter_common_ancestor(res, old_res);
> 
> This might oops too?

Nope, if either res or old_res is NULL, then the common ancestor returned
is NULL. Afterward the charge_until() below will simply charge res over
all the hierarchy if old_res is NULL, or it will do nothing is res itself
is NULL.

I should probably comment on that behaviour.

> 
> > +	return res_counter_charge_until(res, common_ancestor, 1, &limit_fail_at);
> > +}
> > +
> > 
> > ...
> >
> > +int cgroup_task_counter_fork(struct task_struct *child)
> > +{
> > +	struct cgroup_subsys_state *css = child->cgroups->subsys[tasks_subsys_id];
> > +	struct cgroup *cgrp = css->cgroup;
> > +	struct res_counter *limit_fail_at;
> > +
> > +	/* Optimize for the root cgroup case, which doesn't have a limit */
> > +	if (!cgrp->parent)
> > +		return 0;
> > +
> > +	return res_counter_charge(cgroup_task_counter_res(cgrp), 1, &limit_fail_at);
> > +}
> 
> It took a while for me to work out the meaning of the return value from
> this function.  Some documentation would be nice?

Yes and moreover I'm not at all sure about the default return value in
case of failure. -ENOMEM probably matches the need for memory limit
subsystem but for that task counter subsystem.

Probably the res_counter API should return -1 in case of limit reached
and let the caller subsystem deal with the error to return. -ENOMEM
is already too partial.

I guess we should return -EINVAL in case of task counter limit reached?

Once we agree on this I'll document it.

> 
