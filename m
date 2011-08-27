Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1H0OQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:16:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58566 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1H0OQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:16:25 -0400
Date: Sat, 27 Aug 2011 16:16:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110827141618.GM3298@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
 <4E4B3322.6060608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4B3322.6060608@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:18:58AM +0800, Li Zefan wrote:
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 412c21b..bea98d2d 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -690,6 +690,13 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
> >  	  select this option (if, for some reason, they need to disable it
> >  	  then noswapaccount does the trick).
> >  
> > +config CGROUP_TASK_COUNTER
> > +        bool "Control number of tasks in a cgroup"
> 
> TAB

I suck at configuring emacs correctly, it always makes me do some crazy things
on Kconfig files.

> 
> > +	depends on RESOURCE_COUNTERS
> > +	help
> > +	  This option let the user to set up an upper bound allowed number
> 
> will let?

First of all I should just not start with "This option ..." :)

> 
> > +	  of tasks inside a cgroup.
> > +
> >  config CGROUP_PERF
> >  	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
> >  	depends on PERF_EVENTS && CGROUPS
> 
> ...
> 
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
> 
> I think we should change the return value of res_counter_charge.
> Currently it returns -ENOMEM when we excceed limit.

Yeah like I said previously in the thread, I need to tweak that from
res_counter API.


> 
> > +}
> > +
> > +struct cgroup_subsys tasks_subsys = {
> > +	.name			= "tasks",
> > +	.subsys_id		= tasks_subsys_id,
> > +	.create			= task_counter_create,
> > +	.post_clone		= task_counter_post_clone,
> > +	.destroy		= task_counter_destroy,
> > +	.exit			= task_counter_exit,
> > +	.can_attach_task	= task_counter_can_attach_task,
> > +	.cancel_attach_task	= task_counter_cancel_attach_task,
> > +	.attach_task		= task_counter_attach_task,
> > +	.populate		= task_counter_populate,
> > +	.early_init		= 1,
> 
> Just set early_init to 0, since this subsystem doesn't have to be
> initialized early during kernel boot.

Ah right, now that we don't touch the root cgroup anymore, we can do that
later.

Thanks.
