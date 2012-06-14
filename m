Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2FNNdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:33:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:53293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2FNNdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:33:17 -0400
Message-Id: <20120614133212.630722817@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jun 2012 15:29:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/4] sched/fair: track cgroup depth
References: <20120614132902.800827488@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Track depth in cgroup tree, this is useful for things like
find_matching_se() where you need to get to a common parent of two
sched entities.

Keeping the depth avoids having to calculate it on the spot, which
saves a number of possible cache-misses.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |   42 +++++++++++++++++++-----------------------
 2 files changed, 20 insertions(+), 23 deletions(-)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1186,6 +1186,7 @@ struct sched_entity {
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	int			depth;
 	struct sched_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct cfs_rq		*cfs_rq;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -295,13 +295,13 @@ static inline void list_del_leaf_cfs_rq(
 	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
 
 /* Do the two (enqueued) entities belong to the same group ? */
-static inline int
+static inline struct cfs_rq *
 is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
 	if (se->cfs_rq == pse->cfs_rq)
-		return 1;
+		return se->cfs_rq;
 
-	return 0;
+	return NULL;
 }
 
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
@@ -309,17 +309,6 @@ static inline struct sched_entity *paren
 	return se->parent;
 }
 
-/* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
-{
-	int depth = 0;
-
-	for_each_sched_entity(se)
-		depth++;
-
-	return depth;
-}
-
 static void
 find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 {
@@ -333,8 +322,8 @@ find_matching_se(struct sched_entity **s
 	 */
 
 	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(*se);
-	pse_depth = depth_se(*pse);
+	se_depth = (*se)->depth;
+	pse_depth = (*pse)->depth;
 
 	while (se_depth > pse_depth) {
 		se_depth--;
@@ -399,10 +388,10 @@ static inline void list_del_leaf_cfs_rq(
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
-static inline int
+static inline struct cfs_rq *
 is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
-	return 1;
+	return cfs_rq_of(se); /* always the same rq */
 }
 
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
@@ -5246,6 +5235,8 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
+	struct sched_entity *se = &p->se;
+
 	/*
 	 * If the task was not on the rq at the time of this cgroup movement
 	 * it must have been asleep, sleeping tasks keep their ->vruntime
@@ -5271,14 +5262,16 @@ static void task_move_group_fair(struct 
 	 * To prevent boost or penalty in the new cfs_rq caused by delta
 	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
 	 */
-	if (!on_rq && (!p->se.sum_exec_runtime || p->state == TASK_WAKING))
+	if (!on_rq && (!se->sum_exec_runtime || p->state == TASK_WAKING))
 		on_rq = 1;
 
 	if (!on_rq)
-		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+		se->vruntime -= cfs_rq_of(se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
+	if (se->parent)
+		se->depth = se->parent->depth + 1;
 	if (!on_rq)
-		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
+		se->vruntime += cfs_rq_of(se)->min_vruntime;
 }
 
 void free_fair_sched_group(struct task_group *tg)
@@ -5376,10 +5369,13 @@ void init_tg_cfs_entry(struct task_group
 	if (!se)
 		return;
 
-	if (!parent)
+	if (!parent) {
 		se->cfs_rq = &rq->cfs;
-	else
+		se->depth = 0;
+	} else {
 		se->cfs_rq = parent->my_q;
+		se->depth = parent->depth + 1;
+	}
 
 	se->my_q = cfs_rq;
 	update_load_set(&se->load, 0);


