Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2FNNdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:33:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:53290 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab2FNNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:33:16 -0400
Message-Id: <20120614133212.810726968@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jun 2012 15:29:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/4] sched/fair: Optimize cgroup pick_next_task_fair
References: <20120614132902.800827488@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
path") it is likely we pick a new task from the same cgroup, doing a put
and then set on all intermediate entities is a waste of time, so try to
avoid this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/fair.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 7 deletions(-)
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1285,15 +1285,46 @@ wakeup_preempt_entity(struct sched_entit
  */
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_first_entity(cfs_rq);
-	struct sched_entity *left = se;
+	struct sched_entity *left = __pick_first_entity(cfs_rq);
+	struct sched_entity *se, *curr = cfs_rq->curr;
+
+	/*
+	 * Since its possible we got here without doing put_prev_entity() we
+	 * also have to consider cfs_rq->curr. If it was set, and is still a
+	 * runnable entity, update_curr() will update its vruntime, otherwise
+	 * forget we've ever seen it.
+	 */
+	if (curr) {
+		if (curr->on_rq)
+			update_curr(cfs_rq);
+		else
+			curr = NULL;
+	}
+
+	/*
+	 * If curr is set we have to see if its left of the leftmost entity
+	 * still in the tree, provided there was anything in the tree at all.
+	 */
+	if (!left || (curr && entity_before(curr, left)))
+		left = curr;
+
+	se = left; /* ideally we run the leftmost entity */
 
 	/*
 	 * Avoid running the skip buddy, if running something else can
 	 * be done without getting too unfair.
 	 */
 	if (cfs_rq->skip == se) {
-		struct sched_entity *second = __pick_next_entity(se);
+		struct sched_entity *second;
+
+		if (se == curr) {
+			second = __pick_first_entity(cfs_rq);
+		} else {
+			second = __pick_next_entity(se);
+			if (!second || (curr && entity_before(curr, second)))
+				second = curr;
+		}
+
 		if (second && wakeup_preempt_entity(second, left) < 1)
 			se = second;
 	}
@@ -2993,23 +3024,53 @@ static void check_preempt_wakeup(struct 
 static struct task_struct *
 pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
-	struct sched_entity *se;
+	struct sched_entity *se, *pse;
+	struct task_struct *p;
 
 	if (!cfs_rq->nr_running)
 		return NULL;
 
-	if (prev)
+	if (prev && (prev->sched_class != &fair_sched_class)) {
 		prev->sched_class->put_prev_task(rq, prev);
+		prev = NULL;
+	}
 
 	do {
 		se = pick_next_entity(cfs_rq);
-		set_next_entity(cfs_rq, se);
+		if (!prev)
+			set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
 	p = task_of(se);
+
+	/*
+	 * If we haven't yet done put_prev_entity and the selected task is
+	 * a different task than we started out with, try and touch the least
+	 * amount of cfs_rq trees.
+	 */
+	if (prev && prev != p) {
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
 


