Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2DCR6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:58:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab2DCR6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:58:31 -0400
Message-ID: <1333475906.7439.7.camel@marge.simpson.net>
Subject: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Apr 2012 19:58:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hazzards of moving kthreadd into a non-root cgroup is still present
in mainline.  Last go 'round stalled with Peter not liking the
cpuset,cpu per controller specific exclusion.  I agree that total
exclusion is the better option, and below is a respin doing that.

cgroups: disallow attaching kthreadd

Allowing kthreadd to be moved to a non-root group makes no sense, it being
a global resource, and needlessly leads unsuspecting users toward trouble.

1. An RT workqueue worker thread spawned in a task group with no rt_runtime
allocated is not schedulable.  Simple user error, but harmful to the box.

2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
rendering the cpuset immortal.

Save the user some unexpected trouble, just say no.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
---
 kernel/cgroup.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/kthread.h>
 
 #include <linux/atomic.h>
 
@@ -1894,6 +1895,14 @@ int cgroup_attach_task(struct cgroup *cg
 	if (tsk->flags & PF_EXITING)
 		return -ESRCH;
 
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
@@ -2172,6 +2181,17 @@ static int attach_task_by_pid(struct cgr
 
 	if (threadgroup)
 		tsk = tsk->group_leader;
+
+	/*
+	 * Workqueue threads may acquire PF_THREAD_BOUND and become
+	 * trapped in a cpuset, or RT worker may be born in a cgroup
+	 * with no rt_runtime allocated.  Just say no.
+	 */
+	if (tsk == kthreadd_task) {
+		ret = -EINVAL;
+		goto out_unlock_cgroup;
+	}
+
 	get_task_struct(tsk);
 	rcu_read_unlock();
 



