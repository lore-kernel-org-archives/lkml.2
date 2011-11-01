Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab1KAXsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:48:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55815 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab1KAXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:46:50 -0400
From: Tejun Heo <tj@kernel.org>
To: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] cgroup: always lock threadgroup during migration
Date: Tue,  1 Nov 2011 16:46:27 -0700
Message-Id: <1320191193-8110-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320191193-8110-1-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update cgroup to take advantage of the fack that threadgroup_lock()
guarantees stable threadgroup.

* Lock threadgroup even if the target is a single task.  This
  guarantees that when the target tasks stay stable during migration
  regardless of the target type.

* Remove PF_EXITING early exit optimization from attach_task_by_pid()
  and check it in cgroup_task_migrate() instead.  The optimization was
  for rather cold path to begin with and PF_EXITING state can be
  trusted throughout migration by checking it after locking
  threadgroup.

* Don't add PF_EXITING tasks to target task array in
  cgroup_attach_proc().  This ensures that task migration is performed
  only for live tasks.

* Remove -ESRCH failure path from cgroup_task_migrate().  With the
  above changes, it's guaranteed to be called only for live tasks.

After the changes, only live tasks are migrated and they're guaranteed
to stay alive until migration is complete.  This removes problems
caused by exec and exit racing against cgroup migration including
symmetry among cgroup attach methods and different cgroup methods
racing each other.

v2: Oleg pointed out that one more PF_EXITING check can be removed
    from cgroup_attach_proc().  Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   51 +++++++++++++++++++++++----------------------------
 1 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f0e099f..83e10f9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1762,7 +1762,7 @@ EXPORT_SYMBOL_GPL(cgroup_path);
  *
  * 'guarantee' is set if the caller promises that a new css_set for the task
  * will already exist. If not set, this function might sleep, and can fail with
- * -ENOMEM. Otherwise, it can only fail with -ESRCH.
+ * -ENOMEM. Must be called with cgroup_mutex and threadgroup locked.
  */
 static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 			       struct task_struct *tsk, bool guarantee)
@@ -1800,13 +1800,9 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 	}
 	put_css_set(oldcg);
 
-	/* if PF_EXITING is set, the tsk->cgroups pointer is no longer safe. */
+	/* @tsk can't exit as its threadgroup is locked */
 	task_lock(tsk);
-	if (tsk->flags & PF_EXITING) {
-		task_unlock(tsk);
-		put_css_set(newcg);
-		return -ESRCH;
-	}
+	WARN_ON_ONCE(tsk->flags & PF_EXITING);
 	rcu_assign_pointer(tsk->cgroups, newcg);
 	task_unlock(tsk);
 
@@ -1832,8 +1828,8 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
  * @cgrp: the cgroup the task is attaching to
  * @tsk: the task to be attached
  *
- * Call holding cgroup_mutex. May take task_lock of
- * the task 'tsk' during call.
+ * Call with cgroup_mutex and threadgroup locked. May take task_lock of
+ * @tsk during call.
  */
 int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
@@ -1842,6 +1838,10 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	struct cgroup *oldcgrp;
 	struct cgroupfs_root *root = cgrp->root;
 
+	/* @tsk either already exited or can't exit until the end */
+	if (tsk->flags & PF_EXITING)
+		return -ESRCH;
+
 	/* Nothing to do if the task is already in that cgroup */
 	oldcgrp = task_cgroup_from_root(tsk, root);
 	if (cgrp == oldcgrp)
@@ -2062,6 +2062,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	tsk = leader;
 	i = 0;
 	do {
+		/* @tsk either already exited or can't exit until the end */
+		if (tsk->flags & PF_EXITING)
+			continue;
+
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
 		get_task_struct(tsk);
@@ -2116,11 +2120,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 			continue;
 		/* get old css_set pointer */
 		task_lock(tsk);
-		if (tsk->flags & PF_EXITING) {
-			/* ignore this task if it's going away */
-			task_unlock(tsk);
-			continue;
-		}
 		oldcg = tsk->cgroups;
 		get_css_set(oldcg);
 		task_unlock(tsk);
@@ -2158,9 +2157,8 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 			if (ss->attach_task)
 				ss->attach_task(cgrp, tsk);
 		}
-		/* if the thread is PF_EXITING, it can just get skipped. */
 		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0 && retval != -ESRCH);
+		BUG_ON(retval != 0);
 	}
 	/* nothing is sensitive to fork() after this point. */
 
@@ -2212,8 +2210,8 @@ out_free_group_list:
 
 /*
  * Find the task_struct of the task to attach by vpid and pass it along to the
- * function to attach either it or all tasks in its threadgroup. Will take
- * cgroup_mutex; may take task_lock of task.
+ * function to attach either it or all tasks in its threadgroup. Will lock
+ * cgroup_mutex and threadgroup; may take task_lock of task.
  */
 static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 {
@@ -2240,11 +2238,6 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 			 * detect it later.
 			 */
 			tsk = tsk->group_leader;
-		} else if (tsk->flags & PF_EXITING) {
-			/* optimization for the single-task-only case */
-			rcu_read_unlock();
-			cgroup_unlock();
-			return -ESRCH;
 		}
 		/*
 		 * even if we're attaching all tasks in the thread group, we
@@ -2268,13 +2261,15 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 		get_task_struct(tsk);
 	}
 
-	if (threadgroup) {
-		threadgroup_lock(tsk);
+	threadgroup_lock(tsk);
+
+	if (threadgroup)
 		ret = cgroup_attach_proc(cgrp, tsk);
-		threadgroup_unlock(tsk);
-	} else {
+	else
 		ret = cgroup_attach_task(cgrp, tsk);
-	}
+
+	threadgroup_unlock(tsk);
+
 	put_task_struct(tsk);
 	cgroup_unlock();
 	return ret;
-- 
1.7.3.1

