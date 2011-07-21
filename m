Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1GUNVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:21:45 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:64410 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1GUNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:21:41 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFC 3/3] sched: Handle on_list ancestor in list_add_leaf_cfs_rq()
Date: Thu, 21 Jul 2011 15:20:23 +0200
Message-Id: <1311254423-25484-4-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
 <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

In the case of an on_list ancestor we may incorrectly place the child to
the right of a great-ancestor on the list.

Consider:

      A
     / \     Here, t1A results in A->cfs_rq being on_list, however when
    B  t1A   we start enqueuing from C this will not be visible.  This is
   /         compounded by the fact that on_list expiration may also be out
  C          of order, punching holes in the tree.
 /
t1C

Prevent this by making additions to the leaf_cfs_rq_list position
independent.

This is done by collecting additions to this list within the
enqueue_task_fair() path until we reach the top or find an on_list
ancestor. All additions are then spliced into the leaf_cfs_rq_list at
once.

The additions cannot be collected in a list with the normal means as
this violates the RCU guarantee that the next pointer of an element
always leads back to the list as long as there could be concurrent
readers.  However, we are still allowed to modify the next pointer of
deleted entries as long as we make sure that they eventually return to
the list. That is, if we have to collect more than one entry in a row,
it is legal to set the next-pointer of the first collected entry to the
next one. (We can do this even without using *_rcu functions, as there
are no new elements on that path.)

Suggested-by: Paul Turner <pjt@google.com>
Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/sched_fair.c |   59 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..f98b424 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -143,26 +143,41 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return cfs_rq->tg->cfs_rq[this_cpu];
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+					struct list_head *leaf_segment)
 {
-	if (!cfs_rq->on_list) {
-		/*
-		 * Ensure we either appear before our parent (if already
-		 * enqueued) or force our parent to appear after us when it is
-		 * enqueued.  The fact that we always enqueue bottom-up
-		 * reduces this to two cases.
-		 */
-		if (cfs_rq->tg->parent &&
-		    cfs_rq->tg->parent->cfs_rq[cpu_of(rq_of(cfs_rq))]->on_list) {
-			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		} else {
-			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		}
+	if (cfs_rq->on_list)
+		return;
 
-		cfs_rq->on_list = 1;
+	if (list_empty(leaf_segment)) {
+		leaf_segment->next = &cfs_rq->leaf_cfs_rq_list;
+		leaf_segment->prev = &cfs_rq->leaf_cfs_rq_list;
+	} else {
+		__list_link(leaf_segment->prev, &cfs_rq->leaf_cfs_rq_list);
+		leaf_segment->prev = leaf_segment->prev->next;
 	}
+
+	/*
+	 * If our parent is on_list or if there is no parent, then splice all
+	 * entries collected so far at the correct position into the
+	 * leaf_cfs_rq_list.
+	 *
+	 * If our parent is not on the list, it will be collected during the
+	 * next call to this function.
+	 */
+	if (cfs_rq->tg->parent) {
+		int cpu = cpu_of(rq_of(cfs_rq));
+		struct cfs_rq *parent_cfs_rq = cfs_rq->tg->parent->cfs_rq[cpu];
+		if (parent_cfs_rq->on_list) {
+			list_splice_tail_init_rcu(leaf_segment,
+					&parent_cfs_rq->leaf_cfs_rq_list);
+		}
+	} else {
+		list_splice_tail_init_rcu(leaf_segment,
+					&rq_of(cfs_rq)->leaf_cfs_rq_list);
+	}
+
+	cfs_rq->on_list = 1;
 }
 
 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -276,7 +291,8 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return &cpu_rq(this_cpu)->cfs;
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+					struct list_head *leaf_segment)
 {
 }
 
@@ -998,8 +1014,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1)
-		list_add_leaf_cfs_rq(cfs_rq);
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -1326,12 +1340,17 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	struct list_head leaf_segment;
+
+	INIT_LIST_HEAD(&leaf_segment);
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		if (cfs_rq->nr_running == 1)
+			list_add_leaf_cfs_rq(cfs_rq, &leaf_segment);
 		flags = ENQUEUE_WAKEUP;
 	}
 
-- 
1.7.6

