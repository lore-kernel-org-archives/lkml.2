Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2AGGei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 01:34:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37718 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751077Ab2AGGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 01:34:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1839bpp4/w3Wb/y39+ILo4VN33N5ezZhoBpePOudn
	EVBIqzV6PYRchR
Subject: Re: [resubmit] Re: [patch-final] Re: patch] cpusets, cgroups:
 disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20120106140625.f5447039.akpm@linux-foundation.org>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
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
	 <20120106140625.f5447039.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Jan 2012 07:34:17 +0100
Message-ID: <1325918057.6514.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 14:06 -0800, Andrew Morton wrote:
> On Wed, 07 Dec 2011 05:36:57 +0100
> Mike Galbraith <efault@gmx.de> wrote:
> 
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
> 
> Someone's been screwing around in linux-next during the merge window. 
> afacit some patch which was previously there has magically disappeared.
> That killed your patch - the original version of the
> kernel/sched/core.c chagne applies to the new linux-next but the
> kernel/cpuset.c part is all wrecked.

Hm, what to do...

I can't get to mmotm to see what's there, but fresh pulled linux-next
has it as 904655b9, and looked ok. (?)  The only thing I can think to do
is post it as just plugged into fresh pulled master and hope that helps
turn little floundering guppy right side up again.

From: Mike Galbraith <efault@gmx.de>

cpusets, cgroups: disallow attaching kthreadd

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

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0b1712d..cf438f3 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/kthread.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1404,9 +1405,10 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
 	 * applicable for such threads.  This prevents checking for success of
 	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
-	 * be changed.
+	 * be changed.  We also disallow attaching kthreadd, to prevent a child
+	 * from becoming trapped should it later acquire PF_THREAD_BOUND.
 	 */
-	if (tsk->flags & PF_THREAD_BOUND)
+	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
 		return -EINVAL;
 
 	return 0;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4dbfd04..165d610 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -71,6 +71,7 @@
 #include <linux/ftrace.h>
 #include <linux/slab.h>
 #include <linux/init_task.h>
+#include <linux/kthread.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -7576,6 +7577,15 @@ cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	if (tsk->sched_class != &fair_sched_class)
 		return -EINVAL;
 #endif
+	/*
+	 * kthreadd can fork workers for an RT workqueue in a cgroup
+	 * which may or may not have rt_runtime allocated.  Just say no,
+	 * as attaching a global resource to a non-root group  doesn't
+	 * make any sense anyway.
+	 */
+	if (tsk == kthreadd_task)
+		return -EINVAL;
+
 	return 0;
 }
 


