Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1AGHR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:17:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:63851 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1AGHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 02:17:58 -0500
Date: Fri, 7 Jan 2011 15:17:36 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: consolidate the name of root_task_group and
 init_task_group
Message-ID: <20110107071736.GA32635@windriver.com>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1294375414-31028-1-git-send-email-yong.zhang0@gmail.com>
 <1294378950.8823.36.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1294378950.8823.36.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jan 2011 07:17:39.0480 (UTC) FILETIME=[F78DE980:01CBAE3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 06:42:30AM +0100, Mike Galbraith wrote:
> On Fri, 2011-01-07 at 12:43 +0800, Yong Zhang wrote:
> > root_task_group is the leftover of USER_SCHED, now it's always
> > same to init_task_group.
> 
> Wouldn't the reverse be better?  It's root as in tree.

Well, I have no bias to either of them. Keeping init_task_group is
just that we can touch less lines. :)

If you want root_task_group, here it is:
---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] sched: consolidate the name of root_task_group and init_task_group

root_task_group is the leftover of USER_SCHED, now it's always
same to init_task_group.
But as Mike suggested, root_task_group is maybe the suitable name
to keep for a tree.
So in this patch:
  init_task_group      --> root_task_group
  init_task_group_load --> root_task_group_load
  INIT_TASK_GROUP_LOAD --> ROOT_TASK_GROUP_LOAD

Suggested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h    |    2 +-
 kernel/sched.c           |   42 ++++++++++++++++++++----------------------
 kernel/sched_autogroup.c |    6 +++---
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 883ad10..a6b04a0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2500,7 +2500,7 @@ extern void normalize_rt_tasks(void);
 
 #ifdef CONFIG_CGROUP_SCHED
 
-extern struct task_group init_task_group;
+extern struct task_group root_task_group;
 
 extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_destroy_group(struct task_group *tg);
diff --git a/kernel/sched.c b/kernel/sched.c
index 114a0de..35a8046 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -278,14 +278,12 @@ struct task_group {
 #endif
 };
 
-#define root_task_group init_task_group
-
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-# define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
+# define ROOT_TASK_GROUP_LOAD	NICE_0_LOAD
 
 /*
  * A weight of 0 or 1 can cause arithmetics problems.
@@ -298,13 +296,13 @@ static DEFINE_SPINLOCK(task_group_lock);
 #define MIN_SHARES	2
 #define MAX_SHARES	(1UL << 18)
 
-static int init_task_group_load = INIT_TASK_GROUP_LOAD;
+static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
 
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
-struct task_group init_task_group;
+struct task_group root_task_group;
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
@@ -7848,7 +7846,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	cfs_rq->tg = tg;
 
 	tg->se[cpu] = se;
-	/* se could be NULL for init_task_group */
+	/* se could be NULL for root_task_group */
 	if (!se)
 		return;
 
@@ -7908,18 +7906,18 @@ void __init sched_init(void)
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		init_task_group.se = (struct sched_entity **)ptr;
+		root_task_group.se = (struct sched_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-		init_task_group.cfs_rq = (struct cfs_rq **)ptr;
+		root_task_group.cfs_rq = (struct cfs_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
-		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
+		root_task_group.rt_se = (struct sched_rt_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-		init_task_group.rt_rq = (struct rt_rq **)ptr;
+		root_task_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_RT_GROUP_SCHED */
@@ -7939,13 +7937,13 @@ void __init sched_init(void)
 			global_rt_period(), global_rt_runtime());
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	init_rt_bandwidth(&init_task_group.rt_bandwidth,
+	init_rt_bandwidth(&root_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
-	list_add(&init_task_group.list, &task_groups);
-	INIT_LIST_HEAD(&init_task_group.children);
+	list_add(&root_task_group.list, &task_groups);
+	INIT_LIST_HEAD(&root_task_group.children);
 	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
@@ -7960,34 +7958,34 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		init_task_group.shares = init_task_group_load;
+		root_task_group.shares = root_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 		/*
-		 * How much cpu bandwidth does init_task_group get?
+		 * How much cpu bandwidth does root_task_group get?
 		 *
 		 * In case of task-groups formed thr' the cgroup filesystem, it
 		 * gets 100% of the cpu resources in the system. This overall
 		 * system cpu resource is divided among the tasks of
-		 * init_task_group and its child task-groups in a fair manner,
+		 * root_task_group and its child task-groups in a fair manner,
 		 * based on each entity's (task or task-group's) weight
 		 * (se->load.weight).
 		 *
-		 * In other words, if init_task_group has 10 tasks of weight
+		 * In other words, if root_task_group has 10 tasks of weight
 		 * 1024) and two child groups A0 and A1 (of weight 1024 each),
 		 * then A0's share of the cpu resource is:
 		 *
 		 *	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
 		 *
-		 * We achieve this by letting init_task_group's tasks sit
-		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
+		 * We achieve this by letting root_task_group's tasks sit
+		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
+		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, NULL);
+		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -8814,7 +8812,7 @@ cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 
 	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
-		return &init_task_group.css;
+		return &root_task_group.css;
 	}
 
 	parent = cgroup_tg(cgrp->parent);
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index c80fedc..e011e53 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -11,8 +11,8 @@ static atomic_t autogroup_seq_nr;
 
 static void autogroup_init(struct task_struct *init_task)
 {
-	autogroup_default.tg = &init_task_group;
-	init_task_group.autogroup = &autogroup_default;
+	autogroup_default.tg = &root_task_group;
+	root_task_group.autogroup = &autogroup_default;
 	kref_init(&autogroup_default.kref);
 	init_rwsem(&autogroup_default.lock);
 	init_task->signal->autogroup = &autogroup_default;
@@ -63,7 +63,7 @@ static inline struct autogroup *autogroup_create(void)
 	if (!ag)
 		goto out_fail;
 
-	tg = sched_create_group(&init_task_group);
+	tg = sched_create_group(&root_task_group);
 
 	if (IS_ERR(tg))
 		goto out_free;
-- 
1.7.0.4
