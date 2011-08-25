Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1HYWom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:44:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63455 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab1HYWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:43:33 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] cgroup: improve old cgroup handling in cgroup_attach_proc()
Date: Fri, 26 Aug 2011 00:43:08 +0200
Message-Id: <1314312192-26885-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314312192-26885-1-git-send-email-tj@kernel.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_attach_proc() behaves differently from cgroup_attach_task() in
the following aspects.

* All hooks are invoked even if no task is actually being moved.

* ->can_attach_task() is called for all tasks in the group whether the
  new cgrp is different from the current cgrp or not; however,
  ->attach_task() is skipped if new equals new.  This makes the calls
  asymmetric.

This patch improves old cgroup handling in cgroup_attach_proc() by
looking up the current cgroup at the head, recording it in the flex
array along with the task itself, and using it to remove the above two
differences.  This will also ease further changes.

-v2: nr_todo renamed to nr_migrating_tasks as per Paul Menage's
     suggestion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   70 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a606fa2..8a47380 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1739,6 +1739,11 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 }
 EXPORT_SYMBOL_GPL(cgroup_path);
 
+struct task_and_cgroup {
+	struct task_struct	*task;
+	struct cgroup		*cgrp;
+};
+
 /*
  * cgroup_task_migrate - move a task from one cgroup to another.
  *
@@ -1990,15 +1995,15 @@ static int css_set_prefetch(struct cgroup *cgrp, struct css_set *cg,
  */
 int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 {
-	int retval, i, group_size;
+	int retval, i, group_size, nr_migrating_tasks;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
 	bool cancel_failed_ss = false;
 	/* guaranteed to be initialized later, but the compiler needs this */
-	struct cgroup *oldcgrp = NULL;
 	struct css_set *oldcg;
 	struct cgroupfs_root *root = cgrp->root;
 	/* threadgroup list cursor and array */
 	struct task_struct *tsk;
+	struct task_and_cgroup *tc;
 	struct flex_array *group;
 	/*
 	 * we need to make sure we have css_sets for all the tasks we're
@@ -2017,8 +2022,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 */
 	group_size = get_nr_threads(leader);
 	/* flex_array supports very large thread-groups better than kmalloc. */
-	group = flex_array_alloc(sizeof(struct task_struct *), group_size,
-				 GFP_KERNEL);
+	group = flex_array_alloc(sizeof(*tc), group_size, GFP_KERNEL);
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
@@ -2042,8 +2046,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	}
 	/* take a reference on each task in the group to go in the array. */
 	tsk = leader;
-	i = 0;
+	i = nr_migrating_tasks = 0;
 	do {
+		struct task_and_cgroup ent;
+
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
 		get_task_struct(tsk);
@@ -2051,14 +2057,23 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
 		 */
-		retval = flex_array_put_ptr(group, i, tsk, GFP_ATOMIC);
+		ent.task = tsk;
+		ent.cgrp = task_cgroup_from_root(tsk, root);
+		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
+		if (ent.cgrp != cgrp)
+			nr_migrating_tasks++;
 	} while_each_thread(leader, tsk);
 	/* remember the number of threads in the array for later. */
 	group_size = i;
 	rcu_read_unlock();
 
+	/* methods shouldn't be called if no task is actually migrating */
+	retval = 0;
+	if (!nr_migrating_tasks)
+		goto out_put_tasks;
+
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
 	 */
@@ -2074,8 +2089,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		if (ss->can_attach_task) {
 			/* run on each task in the threadgroup. */
 			for (i = 0; i < group_size; i++) {
-				tsk = flex_array_get_ptr(group, i);
-				retval = ss->can_attach_task(cgrp, tsk);
+				tc = flex_array_get(group, i);
+				if (tc->cgrp == cgrp)
+					continue;
+				retval = ss->can_attach_task(cgrp, tc->task);
 				if (retval) {
 					failed_ss = ss;
 					cancel_failed_ss = true;
@@ -2091,23 +2108,22 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 */
 	INIT_LIST_HEAD(&newcg_list);
 	for (i = 0; i < group_size; i++) {
-		tsk = flex_array_get_ptr(group, i);
+		tc = flex_array_get(group, i);
 		/* nothing to do if this task is already in the cgroup */
-		oldcgrp = task_cgroup_from_root(tsk, root);
-		if (cgrp == oldcgrp)
+		if (tc->cgrp == cgrp)
 			continue;
 		/* get old css_set pointer */
-		task_lock(tsk);
-		if (tsk->flags & PF_EXITING) {
+		task_lock(tc->task);
+		if (tc->task->flags & PF_EXITING) {
 			/* ignore this task if it's going away */
-			task_unlock(tsk);
+			task_unlock(tc->task);
 			continue;
 		}
-		oldcg = tsk->cgroups;
+		oldcg = tc->task->cgroups;
 		get_css_set(oldcg);
-		task_unlock(tsk);
+		task_unlock(tc->task);
 		/* see if the new one for us is already in the list? */
-		if (css_set_check_fetched(cgrp, tsk, oldcg, &newcg_list)) {
+		if (css_set_check_fetched(cgrp, tc->task, oldcg, &newcg_list)) {
 			/* was already there, nothing to do. */
 			put_css_set(oldcg);
 		} else {
@@ -2130,20 +2146,19 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 			ss->pre_attach(cgrp);
 	}
 	for (i = 0; i < group_size; i++) {
-		tsk = flex_array_get_ptr(group, i);
+		tc = flex_array_get(group, i);
 		/* leave current thread as it is if it's already there */
-		oldcgrp = task_cgroup_from_root(tsk, root);
-		if (cgrp == oldcgrp)
+		if (tc->cgrp == cgrp)
 			continue;
 
 		/* if the thread is PF_EXITING, it can just get skipped. */
-		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
+		retval = cgroup_task_migrate(cgrp, tc->cgrp, tc->task, true);
 		BUG_ON(retval != 0 && retval != -ESRCH);
 
 		/* attach each task to each subsystem */
 		for_each_subsys(root, ss) {
 			if (ss->attach_task)
-				ss->attach_task(cgrp, tsk);
+				ss->attach_task(cgrp, tc->task);
 		}
 	}
 	/* nothing is sensitive to fork() after this point. */
@@ -2154,8 +2169,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 * being moved, this call will need to be reworked to communicate that.
 	 */
 	for_each_subsys(root, ss) {
-		if (ss->attach)
-			ss->attach(ss, cgrp, oldcgrp, leader);
+		if (ss->attach) {
+			tc = flex_array_get(group, 0);
+			ss->attach(ss, cgrp, tc->cgrp, tc->task);
+		}
 	}
 
 	/*
@@ -2184,10 +2201,11 @@ out_cancel_attach:
 				ss->cancel_attach(ss, cgrp, leader);
 		}
 	}
+out_put_tasks:
 	/* clean up the array of referenced threads in the group. */
 	for (i = 0; i < group_size; i++) {
-		tsk = flex_array_get_ptr(group, i);
-		put_task_struct(tsk);
+		tc = flex_array_get(group, i);
+		put_task_struct(tc->task);
 	}
 out_free_group_list:
 	flex_array_free(group);
-- 
1.7.6

