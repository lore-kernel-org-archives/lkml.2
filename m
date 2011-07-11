Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab1GKOP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:15:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51078 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab1GKOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:15:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: [PATCH 3/7] cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
Date: Mon, 11 Jul 2011 16:15:02 +0200
Message-Id: <1310393706-321-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to prepare the integration of a new max number of proc
cgroup subsystem. We'll need to release some resources from the
previous cgroup.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
---
 block/blk-cgroup.c      |   10 ++++++----
 include/linux/cgroup.h  |    5 +++--
 kernel/cgroup.c         |   10 ++++++----
 kernel/cgroup_freezer.c |    3 ++-
 kernel/cpuset.c         |    6 ++++--
 kernel/events/core.c    |    5 +++--
 kernel/sched.c          |    6 ++++--
 7 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..d1bfe88 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -30,8 +30,8 @@ EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
-static int blkiocg_can_attach_task(struct cgroup *, struct task_struct *);
-static void blkiocg_attach_task(struct cgroup *, struct task_struct *);
+static int blkiocg_can_attach_task(struct cgroup *, struct cgroup *, struct task_struct *);
+static void blkiocg_attach_task(struct cgroup *, struct cgroup *, struct task_struct *);
 static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
 static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 
@@ -1614,7 +1614,8 @@ done:
  * of the main cic data structures.  For now we allow a task to change
  * its cgroup only if it's the only owner of its ioc.
  */
-static int blkiocg_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+static int blkiocg_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				   struct task_struct *tsk)
 {
 	struct io_context *ioc;
 	int ret = 0;
@@ -1629,7 +1630,8 @@ static int blkiocg_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	return ret;
 }
 
-static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+static void blkiocg_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				struct task_struct *tsk)
 {
 	struct io_context *ioc;
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ab4ac0c..e8288a0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -468,11 +468,12 @@ struct cgroup_subsys {
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			  struct task_struct *tsk);
-	int (*can_attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
+	int (*can_attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			       struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			      struct task_struct *tsk);
 	void (*pre_attach)(struct cgroup *cgrp);
-	void (*attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
+	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2731d11..c3ee4cf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1841,7 +1841,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 			}
 		}
 		if (ss->can_attach_task) {
-			retval = ss->can_attach_task(cgrp, tsk);
+			retval = ss->can_attach_task(cgrp, oldcgrp, tsk);
 			if (retval) {
 				failed_ss = ss;
 				goto out;
@@ -1857,7 +1857,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		if (ss->pre_attach)
 			ss->pre_attach(cgrp);
 		if (ss->attach_task)
-			ss->attach_task(cgrp, tsk);
+			ss->attach_task(cgrp, oldcgrp, tsk);
 		if (ss->attach)
 			ss->attach(ss, cgrp, oldcgrp, tsk);
 	}
@@ -2072,7 +2072,9 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 			/* run on each task in the threadgroup. */
 			for (i = 0; i < group_size; i++) {
 				tsk = flex_array_get_ptr(group, i);
-				retval = ss->can_attach_task(cgrp, tsk);
+				oldcgrp = task_cgroup_from_root(tsk, root);
+
+				retval = ss->can_attach_task(cgrp, oldcgrp, tsk);
 				if (retval) {
 					failed_ss = ss;
 					cancel_failed_ss = true;
@@ -2135,7 +2137,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		/* attach each task to each subsystem */
 		for_each_subsys(root, ss) {
 			if (ss->attach_task)
-				ss->attach_task(cgrp, tsk);
+				ss->attach_task(cgrp, oldcgrp, tsk);
 		}
 		/* if the thread is PF_EXITING, it can just get skipped. */
 		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index e691818..c1421a1 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -175,7 +175,8 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 	return 0;
 }
 
-static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+static int freezer_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				   struct task_struct *tsk)
 {
 	rcu_read_lock();
 	if (__cgroup_freezing_or_frozen(tsk)) {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9c9b754..f66c9b4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1390,7 +1390,8 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	return 0;
 }
 
-static int cpuset_can_attach_task(struct cgroup *cgrp, struct task_struct *task)
+static int cpuset_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				  struct task_struct *task)
 {
 	return security_task_setscheduler(task);
 }
@@ -1418,7 +1419,8 @@ static void cpuset_pre_attach(struct cgroup *cont)
 }
 
 /* Per-thread attachment work. */
-static void cpuset_attach_task(struct cgroup *cont, struct task_struct *tsk)
+static void cpuset_attach_task(struct cgroup *cont, struct cgroup *old,
+			       struct task_struct *tsk)
 {
 	int err;
 	struct cpuset *cs = cgroup_cs(cont);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..3daf0eb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7403,7 +7403,8 @@ static int __perf_cgroup_move(void *info)
 }
 
 static void
-perf_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *task)
+perf_cgroup_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			struct task_struct *task)
 {
 	task_function_call(task, __perf_cgroup_move, task);
 }
@@ -7419,7 +7420,7 @@ static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	if (!(task->flags & PF_EXITING))
 		return;
 
-	perf_cgroup_attach_task(cgrp, task);
+	perf_cgroup_attach_task(cgrp, old_cgrp, task);
 }
 
 struct cgroup_subsys perf_subsys = {
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..adec58d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8790,7 +8790,8 @@ cpu_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 }
 
 static int
-cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			   struct task_struct *tsk)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
@@ -8804,7 +8805,8 @@ cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 }
 
 static void
-cpu_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+cpu_cgroup_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+		       struct task_struct *tsk)
 {
 	sched_move_task(tsk);
 }
-- 
1.7.5.4

