Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1HWWU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:20:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWWUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:20:18 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] cgroup: kill subsys->can_attach_task(), pre_attach() and attach_task()
Date: Wed, 24 Aug 2011 00:20:00 +0200
Message-Id: <1314138000-2049-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314138000-2049-1-git-send-email-tj@kernel.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three methods are no longer used.  Kill them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    3 --
 kernel/cgroup.c        |   53 ++++-------------------------------------------
 2 files changed, 5 insertions(+), 51 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2470c8e..5659d37 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -490,11 +490,8 @@ struct cgroup_subsys {
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			  struct cgroup_taskset *tset);
-	int (*can_attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			      struct cgroup_taskset *tset);
-	void (*pre_attach)(struct cgroup *cgrp);
-	void (*attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup_taskset *tset);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 474674b..374a4cb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1926,13 +1926,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 				goto out;
 			}
 		}
-		if (ss->can_attach_task) {
-			retval = ss->can_attach_task(cgrp, tsk);
-			if (retval) {
-				failed_ss = ss;
-				goto out;
-			}
-		}
 	}
 
 	retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, false);
@@ -1940,10 +1933,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		goto out;
 
 	for_each_subsys(root, ss) {
-		if (ss->pre_attach)
-			ss->pre_attach(cgrp);
-		if (ss->attach_task)
-			ss->attach_task(cgrp, tsk);
 		if (ss->attach)
 			ss->attach(ss, cgrp, &tset);
 	}
@@ -2075,7 +2064,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 {
 	int retval, i, group_size, nr_todo;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
-	bool cancel_failed_ss = false;
 	/* guaranteed to be initialized later, but the compiler needs this */
 	struct css_set *oldcg;
 	struct cgroupfs_root *root = cgrp->root;
@@ -2166,21 +2154,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 				goto out_cancel_attach;
 			}
 		}
-		/* a callback to be run on every thread in the threadgroup. */
-		if (ss->can_attach_task) {
-			/* run on each task in the threadgroup. */
-			for (i = 0; i < group_size; i++) {
-				tc = flex_array_get(group, i);
-				if (tc->cgrp == cgrp)
-					continue;
-				retval = ss->can_attach_task(cgrp, tc->task);
-				if (retval) {
-					failed_ss = ss;
-					cancel_failed_ss = true;
-					goto out_cancel_attach;
-				}
-			}
-		}
 	}
 
 	/*
@@ -2217,15 +2190,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	}
 
 	/*
-	 * step 3: now that we're guaranteed success wrt the css_sets, proceed
-	 * to move all tasks to the new cgroup, calling ss->attach_task for each
-	 * one along the way. there are no failure cases after here, so this is
-	 * the commit point.
+	 * step 3: now that we're guaranteed success wrt the css_sets,
+	 * proceed to move all tasks to the new cgroup.  There are no
+	 * failure cases after here, so this is the commit point.
 	 */
-	for_each_subsys(root, ss) {
-		if (ss->pre_attach)
-			ss->pre_attach(cgrp);
-	}
 	for (i = 0; i < group_size; i++) {
 		tc = flex_array_get(group, i);
 		/* leave current thread as it is if it's already there */
@@ -2235,19 +2203,11 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		/* if the thread is PF_EXITING, it can just get skipped. */
 		retval = cgroup_task_migrate(cgrp, tc->cgrp, tc->task, true);
 		BUG_ON(retval != 0 && retval != -ESRCH);
-
-		/* attach each task to each subsystem */
-		for_each_subsys(root, ss) {
-			if (ss->attach_task)
-				ss->attach_task(cgrp, tc->task);
-		}
 	}
 	/* nothing is sensitive to fork() after this point. */
 
 	/*
-	 * step 4: do expensive, non-thread-specific subsystem callbacks.
-	 * TODO: if ever a subsystem needs to know the oldcgrp for each task
-	 * being moved, this call will need to be reworked to communicate that.
+	 * step 4: do subsystem attach callbacks.
 	 */
 	for_each_subsys(root, ss) {
 		if (ss->attach)
@@ -2271,11 +2231,8 @@ out_cancel_attach:
 	/* same deal as in cgroup_attach_task */
 	if (retval) {
 		for_each_subsys(root, ss) {
-			if (ss == failed_ss) {
-				if (cancel_failed_ss && ss->cancel_attach)
-					ss->cancel_attach(ss, cgrp, &tset);
+			if (ss == failed_ss)
 				break;
-			}
 			if (ss->cancel_attach)
 				ss->cancel_attach(ss, cgrp, &tset);
 		}
-- 
1.7.6

