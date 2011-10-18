Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1JRImx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:42:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:40030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1JRImw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:42:52 -0400
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        David Rientjes <rientjes@google.com>
Date: Tue, 18 Oct 2011 10:42:35 +0200
In-Reply-To: <1318925436.9641.23.camel@marge.simson.net>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <1318925436.9641.23.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318927355.21167.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 10:10 +0200, Mike Galbraith wrote:

> ---
>  kernel/cpuset.c |    6 ++++--
>  kernel/sched.c  |   10 ++++++++++
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
> @@ -1382,9 +1383,10 @@ static int cpuset_can_attach(struct cgro
>  	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
>  	 * applicable for such threads.  This prevents checking for success of
>  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
> -	 * be changed.
> +	 * be changed.  We also disallow attaching kthreadd, to prevent it's
> +	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
>  	 */
> -	if (tsk->flags & PF_THREAD_BOUND)
> +	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
>  		return -EINVAL;
>  
>  	return 0;
> Index: linux-3.0-tip/kernel/sched.c
> ===================================================================
> --- linux-3.0-tip.orig/kernel/sched.c
> +++ linux-3.0-tip/kernel/sched.c
> @@ -71,6 +71,7 @@
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
>  #include <linux/slab.h>
> +#include <linux/kthread.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -9141,6 +9142,15 @@ cpu_cgroup_destroy(struct cgroup_subsys
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
> 
> 

Why special case these two, why not simply disallow moving kthreadd into
_any_ cgroup what so ever and be done with it?

---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 453100a..18eed58 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1824,6 +1824,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	struct cgroup *oldcgrp;
 	struct cgroupfs_root *root = cgrp->root;
 
+	if (tsk == kthreadd_task)
+		return -EINVAL;
+
 	/* Nothing to do if the task is already in that cgroup */
 	oldcgrp = task_cgroup_from_root(tsk, root);
 	if (cgrp == oldcgrp)

