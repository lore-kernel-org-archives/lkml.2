Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2IYXiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:38:18 -0400
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:29273 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754981Ab2IYXiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:38:17 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:38:17 EDT
X-Yahoo-Newman-Id: 750915.5964.bm@omp1013.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rGgC9y4VM1mRwlwr28O5pfpEMDENpQMg4fxTZOBsRrw6uMI
 oPVNRFsOmOVXqZ0v2igDqcYSb.DCR15kUCuhH1mycLY5B1_xrNbjvf__xw3O
 lY4eAj8mpPygS5K6390UpV5Ne7ZkZs0I22nr4Lo2PO10dvN9LIZZD86JnPiM
 vJSYSqaYb7u8pCAu_ZI4mjE6swpRbHU2GkTnSn06ypsXl2xFxiZRYEU5hLVY
 jr35sl8HWo9L23p2gQChmDC5q7CT94GCW2yRRdQM3lFREDeOnQdq7a.1LEe8
 vH0Eeff0AVZBIh19T.jw5vO96qAb1q23s24AzTQP5v_QNmyt8Ov8DTTghEKB
 _FCCb.0l8EWa6Ispy_cqvazTNGo255sEjr69JIzUBD7f9ngo.gnEdXePgL2c
 DNA.3g61nkxiCFFwbEvLzvpOpn7AHL5AB1lW03zh6ixOU7WmO3lnU
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v5 13/25] fair.c: Use generic rbtree impl in fair scheduler
Date: Tue, 25 Sep 2012 18:31:26 -0500
Message-Id: <1348615886-10392-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 kernel/sched/fair.c |   75 ++++++++++++++------------------------------------
 1 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c099cc6..8feb4ea 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -447,6 +447,12 @@ static inline int entity_before(struct sched_entity *a,
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
 
+static inline long greater_vruntime(u64 *a, u64 *b)
+{
+	s64 diff = (s64)(*a - *b);
+	return diff > 0;
+}
+
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
@@ -472,56 +478,17 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 #endif
 }
 
-/*
- * Enqueue an entity into the rb-tree:
+/* NOTE: we're passing greater_vruntime for both compare & greater because we
+ * don't need to use the find function.
  */
-static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
-	struct rb_node *parent = NULL;
-	struct sched_entity *entry;
-	int leftmost = 1;
-
-	/*
-	 * Find the right place in the rbtree:
-	 */
-	while (*link) {
-		parent = *link;
-		entry = rb_entry(parent, struct sched_entity, run_node);
-		/*
-		 * We dont care about collisions. Nodes with
-		 * the same key stay together.
-		 */
-		if (entity_before(se, entry)) {
-			link = &parent->rb_left;
-		} else {
-			link = &parent->rb_right;
-			leftmost = 0;
-		}
-	}
-
-	/*
-	 * Maintain a cache of leftmost tree entries (it is frequently
-	 * used):
-	 */
-	if (leftmost)
-		cfs_rq->rb_leftmost = &se->run_node;
-
-	rb_link_node(&se->run_node, parent, link);
-	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
-}
-
-static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	if (cfs_rq->rb_leftmost == &se->run_node) {
-		struct rb_node *next_node;
-
-		next_node = rb_next(&se->run_node);
-		cfs_rq->rb_leftmost = next_node;
-	}
-
-	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
-}
+RB_DEFINE_INTERFACE(
+	fair_tree,
+	struct cfs_rq, tasks_timeline, rb_leftmost, /* no right or count */, ,
+	struct sched_entity, run_node, vruntime,
+	0, greater_vruntime, greater_vruntime, /* no augment */,
+	/* find unused */ ,
+	static __flatten, /* let gcc decide rather or not to inline insert */
+	/* find_near unused */, /* insert_near unused */)
 
 struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
@@ -1108,7 +1075,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	update_stats_enqueue(cfs_rq, se);
 	check_spread(cfs_rq, se);
 	if (se != cfs_rq->curr)
-		__enqueue_entity(cfs_rq, se);
+		fair_tree_insert(cfs_rq, se);
 	se->on_rq = 1;
 
 	if (cfs_rq->nr_running == 1) {
@@ -1189,7 +1156,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	clear_buddies(cfs_rq, se);
 
 	if (se != cfs_rq->curr)
-		__dequeue_entity(cfs_rq, se);
+		fair_tree_remove(cfs_rq, se);
 	se->on_rq = 0;
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
@@ -1260,7 +1227,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 * runqueue.
 		 */
 		update_stats_wait_end(cfs_rq, se);
-		__dequeue_entity(cfs_rq, se);
+		fair_tree_remove(cfs_rq, se);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
@@ -1339,7 +1306,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
-		__enqueue_entity(cfs_rq, prev);
+		fair_tree_insert(cfs_rq, prev);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -3593,7 +3560,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		/*
 		 * !SD_OVERLAP domains can assume that child groups
 		 * span the current group.
-		 */ 
+		 */
 
 		group = child->groups;
 		do {
-- 
1.7.3.4

