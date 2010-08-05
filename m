Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab0HEXGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:06:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0HEXGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:06:12 -0400
Date: Fri, 6 Aug 2010 01:59:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ben Blum <bblum@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] cgroups: fix API thinko
Message-ID: <20100805225914.GA26772@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_attach_task_current_cg API that have upstream is backwards: we
really need an API to attach to the cgroups from another process A to
the current one.

In our case (vhost), a priveledged user wants to attach it's task to cgroups
from a less priveledged one, the API makes us run it in the other
task's context, and this fails.

So let's make the API generic and just pass in 'from' and 'to' tasks.
Add an inline wrapper for cgroup_attach_task_current_cg to avoid
breaking bisect.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Paul, Li, Sridhar, could you please review the following
patch?

I only compile-tested it due to travel, but looks
straight-forward to me.
Alex Williamson volunteered to test and report the results.
Sending out now for review as I might be offline for a bit.
Will only try to merge when done, obviously.

If OK, I would like to merge this through -net tree,
together with the patch fixing vhost-net.
Let me know if that sounds ok.

Thanks!

This patch is on top of net-next, it is needed for fix
vhost-net regression in net-next, where a non-priveledged
process can't enable the device anymore:

when qemu uses vhost, inside the ioctl call it
creates a thread, and tries to add
this thread to the groups of current, and it fails.
But we control the thread, so to solve the problem,
we really should tell it 'connect to out cgroups'.

What this patch does is add an API for that.

 include/linux/cgroup.h |   11 ++++++++++-
 kernel/cgroup.c        |    9 +++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 43b2072..b38ec60 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -525,7 +525,11 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
-int cgroup_attach_task_current_cg(struct task_struct *);
+int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
+static inline int cgroup_attach_task_current_cg(struct task_struct *tsk)
+{
+	return cgroup_attach_task_all(current, tsk);
+}
 
 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
@@ -583,6 +587,11 @@ static inline int cgroupstats_build(struct cgroupstats *stats,
 }
 
 /* No cgroups - nothing to do */
+static inline int cgroup_attach_task_all(struct task_struct *from,
+					 struct task_struct *t)
+{
+	return 0;
+}
 static inline int cgroup_attach_task_current_cg(struct task_struct *t)
 {
 	return 0;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index dce8ebc..e6293b8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1606,10 +1606,11 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 }
 
 /**
- * cgroup_attach_task_current_cg - attach task 'tsk' to current task's cgroup
+ * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
+ * @from: attach to all cgroups of a given task
  * @tsk: the task to be attached
  */
-int cgroup_attach_task_current_cg(struct task_struct *tsk)
+int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 {
 	struct cgroupfs_root *root;
 	struct cgroup *cur_cg;
@@ -1617,7 +1618,7 @@ int cgroup_attach_task_current_cg(struct task_struct *tsk)
 
 	cgroup_lock();
 	for_each_active_root(root) {
-		cur_cg = task_cgroup_from_root(current, root);
+		cur_cg = task_cgroup_from_root(from, root);
 		retval = cgroup_attach_task(cur_cg, tsk);
 		if (retval)
 			break;
@@ -1626,7 +1627,7 @@ int cgroup_attach_task_current_cg(struct task_struct *tsk)
 
 	return retval;
 }
-EXPORT_SYMBOL_GPL(cgroup_attach_task_current_cg);
+EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
 
 /*
  * Attach task with pid 'pid' to cgroup 'cgrp'. Call with cgroup_mutex
-- 
1.7.2.rc0.14.g41c1c
