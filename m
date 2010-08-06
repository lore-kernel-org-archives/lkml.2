Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab0HFQi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab0HFQi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:38:58 -0400
Subject: Re: [PATCH] cgroups: fix API thinko
From: Alex Williamson <alex.williamson@redhat.com>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ben Blum <bblum@google.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <4C5C3985.5060706@us.ibm.com>
References: <20100805225914.GA26772@redhat.com>
	 <4C5C3985.5060706@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 10:38:24 -0600
Message-ID: <1281112704.10055.0.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 09:34 -0700, Sridhar Samudrala wrote:
> On 8/5/2010 3:59 PM, Michael S. Tsirkin wrote:
> > cgroup_attach_task_current_cg API that have upstream is backwards: we
> > really need an API to attach to the cgroups from another process A to
> > the current one.
> >
> > In our case (vhost), a priveledged user wants to attach it's task to cgroups
> > from a less priveledged one, the API makes us run it in the other
> > task's context, and this fails.
> >
> > So let's make the API generic and just pass in 'from' and 'to' tasks.
> > Add an inline wrapper for cgroup_attach_task_current_cg to avoid
> > breaking bisect.
> >
> > Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> > ---
> >
> > Paul, Li, Sridhar, could you please review the following
> > patch?
> >
> > I only compile-tested it due to travel, but looks
> > straight-forward to me.
> > Alex Williamson volunteered to test and report the results.
> > Sending out now for review as I might be offline for a bit.
> > Will only try to merge when done, obviously.
> >
> > If OK, I would like to merge this through -net tree,
> > together with the patch fixing vhost-net.
> > Let me know if that sounds ok.
> >
> > Thanks!
> >
> > This patch is on top of net-next, it is needed for fix
> > vhost-net regression in net-next, where a non-priveledged
> > process can't enable the device anymore:
> >
> > when qemu uses vhost, inside the ioctl call it
> > creates a thread, and tries to add
> > this thread to the groups of current, and it fails.
> > But we control the thread, so to solve the problem,
> > we really should tell it 'connect to out cgroups'.
> >    
> So an unprivileged qemu cannot attach vhost thread to its own cgroups.
> I guess you are planning to make the cgroup_attach_task_all() call in 
> vhost_worker()
> to attach itself to the cgroups of qemu.

Yes, exactly.

Alex

> The new API looks fine, but the
> name is little confusing. How about
>    task_inherit_cgroups(struct task_struct *from, struct task_struct *to)
> 
> > What this patch does is add an API for that.
> >
> >   include/linux/cgroup.h |   11 ++++++++++-
> >   kernel/cgroup.c        |    9 +++++----
> >   2 files changed, 15 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index 43b2072..b38ec60 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -525,7 +525,11 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
> >   void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
> >   int cgroup_scan_tasks(struct cgroup_scanner *scan);
> >   int cgroup_attach_task(struct cgroup *, struct task_struct *);
> > -int cgroup_attach_task_current_cg(struct task_struct *);
> > +int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
> > +static inline int cgroup_attach_task_current_cg(struct task_struct *tsk)
> > +{
> > +	return cgroup_attach_task_all(current, tsk);
> > +}
> >
> >   /*
> >    * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
> > @@ -583,6 +587,11 @@ static inline int cgroupstats_build(struct cgroupstats *stats,
> >   }
> >
> >   /* No cgroups - nothing to do */
> > +static inline int cgroup_attach_task_all(struct task_struct *from,
> > +					 struct task_struct *t)
> > +{
> > +	return 0;
> > +}
> >   static inline int cgroup_attach_task_current_cg(struct task_struct *t)
> >   {
> >   	return 0;
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index dce8ebc..e6293b8 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -1606,10 +1606,11 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
> >   }
> >
> >   /**
> > - * cgroup_attach_task_current_cg - attach task 'tsk' to current task's cgroup
> > + * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
> > + * @from: attach to all cgroups of a given task
> >    * @tsk: the task to be attached
> >    */
> > -int cgroup_attach_task_current_cg(struct task_struct *tsk)
> > +int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
> >   {
> >   	struct cgroupfs_root *root;
> >   	struct cgroup *cur_cg;
> > @@ -1617,7 +1618,7 @@ int cgroup_attach_task_current_cg(struct task_struct *tsk)
> >
> >   	cgroup_lock();
> >   	for_each_active_root(root) {
> > -		cur_cg = task_cgroup_from_root(current, root);
> > +		cur_cg = task_cgroup_from_root(from, root);
> >    
> Now that we are not operating on current, cur_cg should be renamed as 
> from_cg
> >   		retval = cgroup_attach_task(cur_cg, tsk);
> >   		if (retval)
> >   			break;
> > @@ -1626,7 +1627,7 @@ int cgroup_attach_task_current_cg(struct task_struct *tsk)
> >
> >   	return retval;
> >   }
> > -EXPORT_SYMBOL_GPL(cgroup_attach_task_current_cg);
> > +EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
> >
> >   /*
> >    * Attach task with pid 'pid' to cgroup 'cgrp'. Call with cgroup_mutex
> >    
> 
> 



