Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab1JRKLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:11:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50729 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754379Ab1JRKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:11:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+SWTEHTK2Svb1F9+zcMPpMA22i59Ic+r+Mv1gLEL
	759PZaE0S/rYOj
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <1318929825.9641.32.camel@marge.simson.net>
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
	 <1318927355.21167.3.camel@twins>
	 <1318927629.9641.27.camel@marge.simson.net>
	 <1318928763.21167.5.camel@twins>
	 <1318929825.9641.32.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 12:11:33 +0200
Message-ID: <1318932693.6748.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 11:23 +0200, Mike Galbraith wrote:
> On Tue, 2011-10-18 at 11:06 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-10-18 at 10:47 +0200, Mike Galbraith wrote:
> > > On Tue, 2011-10-18 at 10:42 +0200, Peter Zijlstra wrote:
> > > 
> > > > Why special case these two, why not simply disallow moving kthreadd into
> > > > _any_ cgroup what so ever and be done with it?
> > > 
> > > These were the cases where it hurt, and cpusets don't have to be a
> > > component of a cgroup.  So we'd still need the cpuset bit.
> > 
> > but but but,, cpusetes are a cgroup thingy?!
> 
> By golly, mount -t cpuset and the thing does say type cgroup.  How 'bout
> that, learn something new every day.  Dinkier is better.

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

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


