Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1LGWBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:01:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37942 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1LGWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:01:37 -0500
Date: Wed, 7 Dec 2011 14:01:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <efault@gmx.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [resubmit] Re: [patch-final] Re: patch] cpusets, cgroups: disallow
 attaching kthreadd
In-Reply-To: <1323227914.5057.10.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.1112071354430.27360@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net> <1316775204.7562.9.camel@marge.simson.net>
 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com> <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net> <1318233815.6527.5.camel@marge.simson.net> <1318925436.9641.23.camel@marge.simson.net>
 <CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com> <1319001860.6222.34.camel@marge.simson.net> <alpine.DEB.2.00.1110261326550.23111@chino.kir.corp.google.com> <alpine.DEB.2.00.1111101251070.21036@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1112061212510.28251@chino.kir.corp.google.com> <20111206144721.7b1d473d.akpm@linux-foundation.org> <alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com> <1323227914.5057.10.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, Mike Galbraith wrote:

> > Mike, would you mind resending the patch for the fourth or fifth time?  If 
> > not, I'll rebase it.
> 
> Sure, below are the two candidates.  I like Peter's idea better (door
> #2), "Keep yer grubby mitts offa _my_ Mom" is a natural reaction ;-)
> 

The problem with door #2 is that it may be perfectly legitimate to attach 
kthreadd to a non-root cgroup if that cgroup allows it to move without any 
special PF_THREAD_BOUND exception.  The cpusets case is special because we 
have this in cpuset_can_attach():

        /*
         * Kthreads bound to specific cpus cannot be moved to a new cpuset; we
         * cannot change their cpu affinity and isolating such threads by their
         * set of allowed nodes is unnecessary.  Thus, cpusets are not
         * applicable for such threads.  This prevents checking for success of
         * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
         * be changed.
         */
        if (tsk->flags & PF_THREAD_BOUND)
                return -EINVAL;

that precludes PF_THREAD_BOUND threads from moving to any other cpuset.  
This doesn't impact any other cgroups if cpusets are not used.  The 
exception exists for cpusets since we don't want to be able to attach a 
PF_THREAD_BOUND thread to a cpuset and then subsequently change 
cpuset.mems which would cause a discrepency between threads attached to a 
cpuset and their set of allowed nodes since we cannot touch the affinity 
of these threads: set_cpus_allowed_ptr() returns -EINVAL.

So door #2 would definitely be too heavy of a hammer for something that is 
_only_ a cpusets issue.  If new cgroups come along that need special 
behavior for PF_THREAD_BOUND threads, they need to implement that in their 
own ->can_attach() function just like you have here for cpusets in door 
#1.

[snip to door #2 for completeness]

> Door #2
> 
> 
> From: Mike Galbraith <efault@gmx.de>
> 
> cgroups: disallow attaching kthreadd
> 
> Allowing kthreadd to be moved to a non-root group makes no sense, it being
> a global resource, and needlessly leads unsuspecting users toward trouble.
> 
> 1. An RT workqueue worker thread spawned in a task group with no rt_runtime
> allocated is not schedulable.  Simple user error, but harmful to the box.
> 
> 2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
> rendering the cpuset immortal.
> 
> Save the user some unexpected trouble, just say no.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---
>  kernel/cgroup.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-3.0-tip/kernel/cgroup.c
> ===================================================================
> --- linux-3.0-tip.orig/kernel/cgroup.c
> +++ linux-3.0-tip/kernel/cgroup.c
> @@ -60,6 +60,7 @@
>  #include <linux/eventfd.h>
>  #include <linux/poll.h>
>  #include <linux/flex_array.h> /* used in cgroup_attach_proc */
> +#include <linux/kthread.h>
>  
>  #include <linux/atomic.h>
>  
> @@ -1824,6 +1825,14 @@ int cgroup_attach_task(struct cgroup *cg
>  	struct cgroup *oldcgrp;
>  	struct cgroupfs_root *root = cgrp->root;
>  
> +	/*
> +	 * Workqueue threads may acquire PF_THREAD_BOUND and become
> +	 * trapped in a cpuset, or RT worker may be born in a cgroup
> +	 * with no rt_runtime allocated.  Just say no.
> +	 */
> +	if (tsk == kthreadd_task)
> +		return -EINVAL;
> +
>  	/* Nothing to do if the task is already in that cgroup */
>  	oldcgrp = task_cgroup_from_root(tsk, root);
>  	if (cgrp == oldcgrp)
