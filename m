Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1IDSCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:02:16 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43038 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1IDSB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:01:58 -0400
From: Tejun Heo <htejun@gmail.com>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <menage@google.com>
Subject: [PATCH 4/4] cgroup: always lock threadgroup during migration
Date: Mon,  5 Sep 2011 03:01:20 +0900
Message-Id: <1315159280-25032-5-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315159280-25032-1-git-send-email-htejun@gmail.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

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

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e81f403..e77dd41 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1744,7 +1744,7 @@ EXPORT_SYMBOL_GPL(cgroup_path);
  *
  * 'guarantee' is set if the caller promises that a new css_set for the task
  * will already exist. If not set, this function might sleep, and can fail with
- * -ENOMEM. Otherwise, it can only fail with -ESRCH.
+ * -ENOMEM. Must be called with cgroup_mutex and threadgroup locked.
  */
 static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 			       struct task_struct *tsk, bool guarantee)
@@ -1782,13 +1782,9 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
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
 
@@ -1814,8 +1810,8 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
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
@@ -1824,6 +1820,10 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	struct cgroup *oldcgrp;
 	struct cgroupfs_root *root = cgrp->root;
 
+	/* @tsk either already exited or can't exit until the end */
+	if (tsk->flags & PF_EXITING)
+		return -ESRCH;
+
 	/* Nothing to do if the task is already in that cgroup */
 	oldcgrp = task_cgroup_from_root(tsk, root);
 	if (cgrp == oldcgrp)
@@ -2044,6 +2044,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
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
@@ -2142,7 +2146,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		}
 		/* if the thread is PF_EXITING, it can just get skipped. */
 		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0 && retval != -ESRCH);
+		BUG_ON(retval != 0);
 	}
 	/* nothing is sensitive to fork() after this point. */
 
@@ -2194,8 +2198,8 @@ out_free_group_list:
 
 /*
  * Find the task_struct of the task to attach by vpid and pass it along to the
- * function to attach either it or all tasks in its threadgroup. Will take
- * cgroup_mutex; may take task_lock of task.
+ * function to attach either it or all tasks in its threadgroup. Will lock
+ * cgroup_mutex and threadgroup; may take task_lock of task.
  */
 static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 {
@@ -2218,10 +2222,6 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 			 * detect it later.
 			 */
 			tsk = tsk->group_leader;
-		} else if (tsk->flags & PF_EXITING) {
-			/* optimization for the single-task-only case */
-			rcu_read_unlock();
-			return -ESRCH;
 		}
 
 		/*
@@ -2245,8 +2245,7 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 		get_task_struct(tsk);
 	}
 
-	if (threadgroup)
-		threadgroup_lock(tsk);
+	threadgroup_lock(tsk);
 	ret = -ENODEV;
 	if (cgroup_lock_live_group(cgrp)) {
 		if (threadgroup)
@@ -2255,8 +2254,7 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 			ret = cgroup_attach_task(cgrp, tsk);
 		cgroup_unlock();
 	}
-	if (threadgroup)
-		threadgroup_unlock(tsk);
+	threadgroup_unlock(tsk);
 	put_task_struct(tsk);
 	return ret;
 }
-- 
1.7.6

