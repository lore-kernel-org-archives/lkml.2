Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1LGWEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:04:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54597 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1LGWD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:03:59 -0500
Date: Wed, 7 Dec 2011 14:03:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <efault@gmx.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [resubmit] Re: [patch-final] Re: patch] cpusets, cgroups: disallow
 attaching kthreadd
In-Reply-To: <1323232617.5057.50.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.1112071401431.27360@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net> <1316775204.7562.9.camel@marge.simson.net> <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
 <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net> <1318233815.6527.5.camel@marge.simson.net> <1318925436.9641.23.camel@marge.simson.net> <CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
 <1319001860.6222.34.camel@marge.simson.net> <alpine.DEB.2.00.1110261326550.23111@chino.kir.corp.google.com> <alpine.DEB.2.00.1111101251070.21036@chino.kir.corp.google.com> <alpine.DEB.2.00.1112061212510.28251@chino.kir.corp.google.com>
 <20111206144721.7b1d473d.akpm@linux-foundation.org> <alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com> <1323227914.5057.10.camel@marge.simson.net> <1323232617.5057.50.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, Mike Galbraith wrote:

> Door #1 with speeling correction.
> 
> From: Mike Galbraith <efault@gmx.de>
> 
> cpusets, cgroups: disallow attaching kthreadd
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
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Paul Menage <paul@paulmenage.org>

Yes, this looks good.  Andrew could you apply this?

> ---
>  kernel/cpuset.c     |    6 ++++--
>  kernel/sched/core.c |   10 ++++++++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> Index: linux-3.0-tip/kernel/cpuset.c
> ===================================================================
> --- linux-3.0-tip.orig/kernel/cpuset.c
> +++ linux-3.0-tip/kernel/cpuset.c
> @@ -59,6 +59,7 @@
>  #include <linux/mutex.h>
>  #include <linux/workqueue.h>
>  #include <linux/cgroup.h>
> +#include <linux/kthread.h>
>  
>  /*
>   * Workqueue for cpuset related tasks.
> @@ -1385,9 +1386,10 @@ static int cpuset_can_attach(struct cgro
>  	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
>  	 * applicable for such threads.  This prevents checking for success of
>  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
> -	 * be changed.
> +	 * be changed.  We also disallow attaching kthreadd, to prevent its
> +	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
>  	 */
> -	if (tsk->flags & PF_THREAD_BOUND)
> +	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
>  		return -EINVAL;
>  
>  	return 0;
> Index: linux-3.0-tip/kernel/sched/core.c
> ===================================================================
> --- linux-3.0-tip.orig/kernel/sched/core.c
> +++ linux-3.0-tip/kernel/sched/core.c
> @@ -71,6 +71,7 @@
>  #include <linux/ftrace.h>
>  #include <linux/slab.h>
>  #include <linux/init_task.h>
> +#include <linux/kthread.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -7461,6 +7462,15 @@ cpu_cgroup_destroy(struct cgroup_subsys
>  static int
>  cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  {
> +	/*
> +	 * kthreadd can fork workers for an RT workqueue in a cgroup
> +	 * which may or may not have rt_runtime allocated.  Just say no,
> +	 * as attaching a global resource to a non-root group  doesn't
> +	 * make any sense anyway.
> +	 */
> +	if (tsk == kthreadd_task)
> +		return -EINVAL;
> +
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
>  		return -EINVAL;
