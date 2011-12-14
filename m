Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1LNUQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:16:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1LNUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:16:06 -0500
Date: Wed, 14 Dec 2011 12:16:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <efault@gmx.de>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [resubmit] Re: [patch-final] Re: patch] cpusets, cgroups:
 disallow attaching kthreadd
Message-Id: <20111214121604.bc26ab42.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1112071401431.27360@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	<1316770936.6641.11.camel@marge.simson.net>
	<1316775204.7562.9.camel@marge.simson.net>
	<alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	<1316788392.6544.33.camel@marge.simson.net>
	<1318224892.6161.45.camel@marge.simson.net>
	<1318233815.6527.5.camel@marge.simson.net>
	<1318925436.9641.23.camel@marge.simson.net>
	<CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
	<1319001860.6222.34.camel@marge.simson.net>
	<alpine.DEB.2.00.1110261326550.23111@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111101251070.21036@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1112061212510.28251@chino.kir.corp.google.com>
	<20111206144721.7b1d473d.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com>
	<1323227914.5057.10.camel@marge.simson.net>
	<1323232617.5057.50.camel@marge.simson.net>
	<alpine.DEB.2.00.1112071401431.27360@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 14:03:56 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 7 Dec 2011, Mike Galbraith wrote:
> 
> > Door #1 with speeling correction.
> > 
> > From: Mike Galbraith <efault@gmx.de>
> > 
> > cpusets, cgroups: disallow attaching kthreadd
> > 
> > Allowing kthreadd to be moved to a non-root group makes no sense, it being
> > a global resource, and needlessly leads unsuspecting users toward trouble.
> > 
> > 1. An RT workqueue worker thread spawned in a task group with no rt_runtime
> > allocated is not schedulable.  Simple user error, but harmful to the box.
> > 
> > 2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
> > rendering the cpuset immortal.
> > 
> > Save the user some unexpected trouble, just say no.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Acked-by: Paul Menage <paul@paulmenage.org>
> 
> Yes, this looks good.  Andrew could you apply this?

This patch needed considerable rework resulting from ongoing churn in
linux-next cgroups code.  It needs checking and retesting, please.


From: Mike Galbraith <efault@gmx.de>
Subject: cpusets, cgroups: disallow attaching kthreadd

Allowing kthreadd to be moved to a non-root group makes no sense, it being
a global resource, and needlessly leads unsuspecting users toward trouble.

1. An RT workqueue worker thread spawned in a task group with no
   rt_runtime allocated is not schedulable.  Simple user error, but
   harmful to the box.

2. A worker thread which acquires PF_THREAD_BOUND can never leave a
   cpuset, rendering the cpuset immortal.

Save the user some unexpected trouble, just say no.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c     |    7 +++++--
 kernel/sched/core.c |    9 +++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpusets-cgroups-disallow-attaching-kthreadd kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-cgroups-disallow-attaching-kthreadd
+++ a/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/kthread.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1417,9 +1418,11 @@ static int cpuset_can_attach(struct cgro
 		 * unnecessary.  Thus, cpusets are not applicable for such
 		 * threads.  This prevents checking for success of
 		 * set_cpus_allowed_ptr() on all attached tasks before
-		 * cpus_allowed may be changed.
+		 * cpus_allowed may be changed.  We also disallow attaching
+		 * kthreadd, to prevent its child from becoming trapped should
+		 * it then acquire PF_THREAD_BOUND.
 		 */
-		if (task->flags & PF_THREAD_BOUND)
+		if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
 			return -EINVAL;
 		if ((ret = security_task_setscheduler(task)))
 			return ret;
diff -puN kernel/sched/core.c~cpusets-cgroups-disallow-attaching-kthreadd kernel/sched/core.c
--- a/kernel/sched/core.c~cpusets-cgroups-disallow-attaching-kthreadd
+++ a/kernel/sched/core.c
@@ -71,6 +71,7 @@
 #include <linux/ftrace.h>
 #include <linux/slab.h>
 #include <linux/init_task.h>
+#include <linux/kthread.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -7535,6 +7536,14 @@ static int cpu_cgroup_can_attach(struct 
 	struct task_struct *task;
 
 	cgroup_taskset_for_each(task, cgrp, tset) {
+		/*
+		 * kthreadd can fork workers for an RT workqueue in a cgroup
+		 * which may or may not have rt_runtime allocated.  Just say no,
+		 * as attaching a global resource to a non-root group  doesn't
+		 * make any sense anyway.
+		 */
+		if (tsk == kthreadd_task)
+			return -EINVAL;
 #ifdef CONFIG_RT_GROUP_SCHED
 		if (!sched_rt_can_attach(cgroup_tg(cgrp), task))
 			return -EINVAL;
_

