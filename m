Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1LGDSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:18:44 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41851 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752964Ab1LGDSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:18:43 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EriQgL8pECtP+rAtnyVkIVMRp44+uREvBONbLzs
	TnyKUkBtIGFFiv
Subject: [resubmit] Re: [patch-final] Re: patch] cpusets, cgroups: disallow
 attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com>
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
	 <CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
	 <1319001860.6222.34.camel@marge.simson.net>
	 <alpine.DEB.2.00.1110261326550.23111@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1111101251070.21036@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1112061212510.28251@chino.kir.corp.google.com>
	 <20111206144721.7b1d473d.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 04:18:34 +0100
Message-ID: <1323227914.5057.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 15:53 -0800, David Rientjes wrote:

> Mike, would you mind resending the patch for the fourth or fifth time?  If 
> not, I'll rebase it.

Sure, below are the two candidates.  I like Peter's idea better (door
#2), "Keep yer grubby mitts offa _my_ Mom" is a natural reaction ;-)

Door #1

From: Mike Galbraith <efault@gmx.de>

cpusets, cgroups: disallow attaching kthreadd

Allowing kthreadd to be moved to a non-root group makes no sense, it being
a global resource, and needlessly leads unsuspecting users toward trouble.

1. An RT workqueue worker thread spawned in a task group with no rt_runtime
allocated is not schedulable.  Simple user error, but harmful to the box.

2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
rendering the cpuset immortal.

Save the user some unexpected trouble, just say no.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Paul Menage <paul@paulmenage.org>

---
 kernel/cpuset.c     |    6 ++++--
 kernel/sched/core.c |   10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-3.0-tip/kernel/cpuset.c
===================================================================
--- linux-3.0-tip.orig/kernel/cpuset.c
+++ linux-3.0-tip/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/kthread.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1385,9 +1386,10 @@ static int cpuset_can_attach(struct cgro
 	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
 	 * applicable for such threads.  This prevents checking for success of
 	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
-	 * be changed.
+	 * be changed.  We also disallow attaching kthreadd, to prevent it's
+	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
 	 */
-	if (tsk->flags & PF_THREAD_BOUND)
+	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
 		return -EINVAL;
 
 	return 0;
Index: linux-3.0-tip/kernel/sched/core.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/core.c
+++ linux-3.0-tip/kernel/sched/core.c
@@ -71,6 +71,7 @@
 #include <linux/ftrace.h>
 #include <linux/slab.h>
 #include <linux/init_task.h>
+#include <linux/kthread.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -7461,6 +7462,15 @@ cpu_cgroup_destroy(struct cgroup_subsys
 static int
 cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
+	/*
+	 * kthreadd can fork workers for an RT workqueue in a cgroup
+	 * which may or may not have rt_runtime allocated.  Just say no,
+	 * as attaching a global resource to a non-root group  doesn't
+	 * make any sense anyway.
+	 */
+	if (tsk == kthreadd_task)
+		return -EINVAL;
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
 		return -EINVAL;


Door #2


From: Mike Galbraith <efault@gmx.de>

cgroups: disallow attaching kthreadd

Allowing kthreadd to be moved to a non-root group makes no sense, it being
a global resource, and needlessly leads unsuspecting users toward trouble.

1. An RT workqueue worker thread spawned in a task group with no rt_runtime
allocated is not schedulable.  Simple user error, but harmful to the box.

2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
rendering the cpuset immortal.

Save the user some unexpected trouble, just say no.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/cgroup.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-3.0-tip/kernel/cgroup.c
===================================================================
--- linux-3.0-tip.orig/kernel/cgroup.c
+++ linux-3.0-tip/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/kthread.h>
 
 #include <linux/atomic.h>
 
@@ -1824,6 +1825,14 @@ int cgroup_attach_task(struct cgroup *cg
 	struct cgroup *oldcgrp;
 	struct cgroupfs_root *root = cgrp->root;
 
+	/*
+	 * Workqueue threads may acquire PF_THREAD_BOUND and become
+	 * trapped in a cpuset, or RT worker may be born in a cgroup
+	 * with no rt_runtime allocated.  Just say no.
+	 */
+	if (tsk == kthreadd_task)
+		return -EINVAL;
+
 	/* Nothing to do if the task is already in that cgroup */
 	oldcgrp = task_cgroup_from_root(tsk, root);
 	if (cgrp == oldcgrp)


Door #3

