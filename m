Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2BKFLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 00:11:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48958 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2BKFLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 00:11:53 -0500
Subject: [RFC][PATCH] sched: Optimize cgroup pick_next_task_fair
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>, Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Feb 2012 06:05:00 +0100
Message-ID: <1328936700.2476.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
path") it is likely we pick a new task from the same cgroup, doing a put
and then set on all intermediate entities is a waste of time, so try to
avoid this.

XXX check put_prev_task()'s update_rq_clock() magic..

Compile tested only.. inspired by pjt's fast switch stories.

Not-quite-signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    4 +-
 kernel/sched/core.c      |   11 ++---
 kernel/sched/fair.c      |   94 +++++++++++++++++++++++++++++-----------------
 kernel/sched/idle_task.c |    6 ++-
 kernel/sched/rt.c        |   10 ++++-
 kernel/sched/stop_task.c |    6 ++-
 6 files changed, 85 insertions(+), 46 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a5be381..37e990b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1117,7 +1117,8 @@ struct sched_class {
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
-	struct task_struct * (*pick_next_task) (struct rq *rq);
+	struct task_struct * (*pick_next_task) (struct rq *rq, 
+						struct task_struct *prev);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
@@ -1210,6 +1211,7 @@ struct sched_entity {
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	int			depth;
 	struct sched_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct cfs_rq		*cfs_rq;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d7c4322..7628d25 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3120,7 +3120,7 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
  * Pick up the highest-prio task:
  */
 static inline struct task_struct *
-pick_next_task(struct rq *rq)
+pick_next_task(struct rq *rq, struct task_struct *prev)
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -3130,13 +3130,13 @@ pick_next_task(struct rq *rq)
 	 * the fair class we can call that function directly:
 	 */
 	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
-		p = fair_sched_class.pick_next_task(rq);
+		p = fair_sched_class.pick_next_task(rq, prev);
 		if (likely(p))
 			return p;
 	}
 
 	for_each_class(class) {
-		p = class->pick_next_task(rq);
+		p = class->pick_next_task(rq, prev);
 		if (p)
 			return p;
 	}
@@ -3197,8 +3197,7 @@ static void __sched __schedule(void)
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	rq->skip_clock_update = 0;
 
@@ -5102,7 +5101,7 @@ static void migrate_tasks(unsigned int dead_cpu)
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq);
+		next = pick_next_task(rq, NULL);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4ab60a2..4ea6f45 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -294,13 +294,13 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
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
@@ -308,17 +308,6 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
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
@@ -332,8 +321,8 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 	 */
 
 	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(*se);
-	pse_depth = depth_se(*pse);
+	se_depth = (*se)->depth;
+	pse_depth = (*pse)->depth;
 
 	while (se_depth > pse_depth) {
 		se_depth--;
@@ -398,10 +387,10 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
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
@@ -1134,10 +1123,10 @@ static void __clear_buddies_last(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->last == se)
-			cfs_rq->last = NULL;
-		else
+		if (cfs_rq->last != se)
 			break;
+
+		cfs_rq->last = NULL;
 	}
 }
 
@@ -1145,10 +1134,10 @@ static void __clear_buddies_next(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->next == se)
-			cfs_rq->next = NULL;
-		else
+		if (cfs_rq->next != se)
 			break;
+
+		cfs_rq->next = NULL;
 	}
 }
 
@@ -1156,10 +1145,10 @@ static void __clear_buddies_skip(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->skip == se)
-			cfs_rq->skip = NULL;
-		else
+		if (cfs_rq->skip != se)
 			break;
+
+		cfs_rq->skip = NULL;
 	}
 }
 
@@ -2991,22 +2980,51 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
-	struct sched_entity *se;
+	struct sched_entity *se, *pse;
 
 	if (!cfs_rq->nr_running)
 		return NULL;
 
+	if (prev && prev->sched_class != &fair_sched_class) {
+		prev->sched_class->put_prev_task(rq, prev);
+		prev = NULL;
+	}
+
 	do {
 		se = pick_next_entity(cfs_rq);
-		set_next_entity(cfs_rq, se);
+		if (!prev)
+			set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
 	p = task_of(se);
+
+	if (prev) {
+		pse = &prev->se;
+
+		while (!(cfs_rq = is_same_group(se, pse))) {
+			int se_depth = se->depth;
+			int pse_depth = pse->depth;
+
+			if (se_depth <= pse_depth) {
+				put_prev_entity(cfs_rq_of(pse), pse);
+				pse = parent_entity(pse);
+			}
+			if (se_depth >= pse_depth) {
+				set_next_entity(cfs_rq_of(se), se);
+				se = parent_entity(se);
+			}
+		}
+
+		put_prev_entity(cfs_rq, pse);
+		set_next_entity(cfs_rq, se);
+	}
+
 	if (hrtick_enabled(rq))
 		hrtick_start_fair(rq, p);
 
@@ -5358,6 +5376,8 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
+	struct sched_entity *se = &p->se;
+
 	/*
 	 * If the task was not on the rq at the time of this cgroup movement
 	 * it must have been asleep, sleeping tasks keep their ->vruntime
@@ -5383,14 +5403,15 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
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
+	se->depth = se->parent->depth + 1;
 	if (!on_rq)
-		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
+		se->vruntime += cfs_rq_of(se)->min_vruntime;
 }
 
 void free_fair_sched_group(struct task_group *tg)
@@ -5488,10 +5509,13 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
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
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 91b4c95..7f5d232 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -22,8 +22,12 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 	resched_task(rq->idle);
 }
 
-static struct task_struct *pick_next_task_idle(struct rq *rq)
+static struct task_struct *
+pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	schedstat_inc(rq, sched_goidle);
 	calc_load_account_idle(rq);
 	return rq->idle;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f42ae7f..0f6c316 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1343,9 +1343,15 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	return p;
 }
 
-static struct task_struct *pick_next_task_rt(struct rq *rq)
+static struct task_struct *
+pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p = _pick_next_task_rt(rq);
+	struct task_struct *p;
+
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+       
+	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
 	if (p)
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 7b386e8..441cc57 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,10 +23,14 @@ check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
 	/* we're never preempted */
 }
 
-static struct task_struct *pick_next_task_stop(struct rq *rq)
+static struct task_struct *
+pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	if (stop && stop->on_rq)
 		return stop;
 


