Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1IMPNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:13:53 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:36434 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1IMPNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:13:52 -0400
Date: Tue, 13 Sep 2011 17:13:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/12] cgroups: Add a task counter subsystem
Message-ID: <20110913151343.GC23424@somewhere>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
 <1315267986-28937-10-git-send-email-fweisbec@gmail.com>
 <20110906154009.326b8dca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906154009.326b8dca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 03:40:09PM -0700, Andrew Morton wrote:
> On Tue,  6 Sep 2011 02:13:03 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Add a new subsystem to limit the number of running tasks,
> > similar to the NR_PROC rlimit but in the scope of a cgroup.
> > 
> > This is a step to be able to isolate a bit more a cgroup against
> > the rest of the system and limit the global impact of a fork bomb
> > inside a given cgroup.
> 
> It would be nice to show some testing results for the putative
> forkbomb-control feature.

I'm uploading a selftest tool that I've been using to ensure it behaves
as expected. A forkbomb test is included.
 
> >
> > ...
> >
> > +config CGROUP_TASK_COUNTER
> > +	bool "Control number of tasks in a cgroup"
> > +	depends on RESOURCE_COUNTERS
> > +	help
> > +	  Let the user set up an upper bound allowed number of tasks running
> > +	  in a cgroup.
> 
> "of the allowed"?
> 
> Perhaps this help section could be fleshed out somewhat.

I've fixed and expanded it a bit for the v5.

> 
> >
> > ...
> >
> > @@ -0,0 +1,199 @@
> > +/*
> > + * Limits on number of tasks subsystem for cgroups
> > + *
> > + * Copyright (C) 2011 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
> > + *
> > + * Thanks to Andrew Morton, Johannes Weiner, Li Zefan, Oleg Nesterov and Paul Menage
> > + * for their suggestions.
> 
> 80 cols, please.  (checkpatch!)

Fixed in v5.

> 
> > + *
> > + */
> > +
> > +#include <linux/cgroup.h>
> > +#include <linux/slab.h>
> > +#include <linux/res_counter.h>
> > +
> > +
> > +struct task_counter {
> > +	struct res_counter		res;
> > +	struct cgroup_subsys_state	css;
> > +};
> > +
> > +/*
> > + * The root task counter doesn't exist as it's not part of the
> > + * whole task counting in order to optimize the trivial case
> > + * of only one root cgroup living.
> 
> That sentence is rather hard to follow.

I've fixed it too. I mean I tried something...

> > + */
> > +static struct cgroup_subsys_state root_css;
> > +
> > +
> > +static inline struct task_counter *cgroup_task_counter(struct cgroup *cgrp)
> > +{
> > +	if (!cgrp->parent)
> > +		return NULL;
> > +
> > +	return container_of(cgroup_subsys_state(cgrp, tasks_subsys_id),
> > +			    struct task_counter, css);
> > +}
> > +
> > +static inline struct res_counter *cgroup_task_counter_res(struct cgroup *cgrp)
> 
> "cgroup_res_counter" would be a more symmetrical name.  Or perhaps
> cgroup_task_res_counter.  Swapping the "counter" and "res" seems odd.

Indeed; fixed.

> > +{
> > +	struct task_counter *cnt;
> > +
> > +	cnt = cgroup_task_counter(cgrp);
> > +	if (!cnt)
> > +		return NULL;
> > +
> > +	return &cnt->res;
> > +}
> > +
> >
> > ...
> >
> > +/* Protected amongst can_attach_task/attach_task/cancel_attach_task by cgroup mutex */
> 
> /*
>  * Protected amongst can_attach_task/attach_task/cancel_attach_task by cgroup
>  * mutex
>  */
> 
> (checkpatch)

Fixed

> >
> > ...
> >
> > +static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
> > +					struct task_struct *tsk)
> > +{
> > +	struct res_counter *res = cgroup_task_counter_res(cgrp);
> > +	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
> > +	int err;
> > +
> > +	/*
> > +	 * When moving a task from a cgroup to another, we don't want
> > +	 * to charge the common ancestors, even though they will be
> > +	 * uncharged later from attach_task(), because during that
> > +	 * short window between charge and uncharge, a task could fork
> > +	 * in the ancestor and spuriously fail due to the temporary
> > +	 * charge.
> > +	 */
> > +	common_ancestor = res_counter_common_ancestor(res, old_res);
> > +
> > +	/*
> > +	 * If cgrp is the root then res is NULL, however in this case
> > +	 * the common ancestor is NULL as well, making the below a NOP.
> > +	 */
> > +	err = res_counter_charge_until(res, common_ancestor, 1, NULL);
> > +	if (err)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> 
> One would expect a "can"-named function to return a boolean.  This one
> returns an errno which is OK, I guess.  But the function is misnamed
> because if successful it actually alters charges.  A less misleading
> name would be simply task_counter_attach_task(), but that's already
> taken.  Or perhaps task_counter_try_attach_task(), but that seems
> unnecessary to me - many many kernel functions "try" something and back
> out with an errno if it failed.

Yeah, the ->can_attach_task() cgroup subsystem callbacks are more than
just things that passively report if something is possible or not.
They allow some side effects that can be rolled back in ->cancel_attach()
callbacks.

May be they could be renamed as pre_attach() one day. ->pre_attach()
callbacks already exist but are targeted for removal in Tejun's patches.

> 
> I really do dislike the fact that the documentation is over in another
> file and another patch.  For a start, it makes review harder and
> slower.

Ok, I've merged the doc in that patch.

Thanks!
