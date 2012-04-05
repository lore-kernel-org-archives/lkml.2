Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2DEHO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:14:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61718 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2DEHO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:14:56 -0400
Date: Thu, 5 Apr 2012 00:14:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [patch 1/2] cpusets: disallow attaching kthreadd
In-Reply-To: <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1204050013440.9466@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net> <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com> <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com> <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com> <1333601231.7783.31.camel@marge.simpson.net> <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net> <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net> <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

A worker thread spawned by kthreadd may acquire PF_THREAD_BOUND and never
be able to leave a cpuset, rending the cpuset immortal.  Save the user
some unexpected trouble, just say no.

Acked-by: Paul Menage <paul@paulmenage.org>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/cpuset.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -53,6 +53,7 @@
 #include <linux/time.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 #include <linux/atomic.h>
@@ -1389,9 +1390,11 @@ static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 		 * unnecessary.  Thus, cpusets are not applicable for such
 		 * threads.  This prevents checking for success of
 		 * set_cpus_allowed_ptr() on all attached tasks before
-		 * cpus_allowed may be changed.
+		 * cpus_allowed may be changed.  We also disallow attaching
+		 * kthreadd to prevent a child from becoming trapped should it
+		 * later acquire PF_THREAD_BOUND.
 		 */
-		if (task->flags & PF_THREAD_BOUND)
+		if (task->flags & PF_THREAD_BOUND || task == kthreadd_task)
 			return -EINVAL;
 		if ((ret = security_task_setscheduler(task)))
 			return ret;
