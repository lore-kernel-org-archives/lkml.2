Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1JSFY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:24:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59655 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752179Ab1JSFYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:24:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18xpcEM0nsxcfeqBEZHye2sutJ+piWrC0iXUTdMmX
	7QyRKwNB8lDRfx
Subject: [patch-final] Re: patch] cpusets, cgroups: disallow attaching
 kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <paul@paulmenage.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 07:24:20 +0200
Message-ID: <1319001860.6222.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 21:57 -0700, Paul Menage wrote:
> On Tue, Oct 18, 2011 at 1:10 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Save the user some unexpected trouble, just say no.
> >
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> Acked-by: Paul Menage <paul@paulmenage.org>

Thanks.  Ok, seems it is decided that this is the best way to deal with
annoying corner-case.  For convenience, patch with acquired acks below.


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
 kernel/cpuset.c |    6 ++++--
 kernel/sched.c  |   10 ++++++++++
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
@@ -1382,9 +1383,10 @@ static int cpuset_can_attach(struct cgro
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
Index: linux-3.0-tip/kernel/sched.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched.c
+++ linux-3.0-tip/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/kthread.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -9141,6 +9142,15 @@ cpu_cgroup_destroy(struct cgroup_subsys
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





