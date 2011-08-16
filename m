Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1HPOIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:08:35 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:34020 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab1HPOIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:08:31 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v3 2/2] sched: Handle on_list ancestor in list_add_leaf_cfs_rq()
Date: Tue, 16 Aug 2011 16:07:46 +0200
Message-Id: <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
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
next one. (We only need to make sure not to hit any physically deleted
list entries.)

Suggested-by: Paul Turner <pjt@google.com>
Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

---
Changes since v2:
- undo code movement from v1
- reset next pointer of collected entries to avoid traversing
  physically deleted nodes

Changes since v1:
- moved some more code to include/linux/rculist.h
- added comment regarding RCU
---
 kernel/sched_fair.c |   79 +++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..1317791 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -135,26 +135,65 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return grp->my_q;
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+					struct list_head *leaf_cfs_rqs)
 {
-	if (!cfs_rq->on_list) {
+	if (cfs_rq->on_list)
+		return;
+
+	/*
+	 * Carefully collect leaf-cfs entries:
+	 *
+	 * We might still have concurrent readers on these entries from before
+	 * the previous delete operation. Therefore we cannot collect them in a
+	 * totally independent list. Instead, we reorganize the deleted entries
+	 * within the deleted list, making sure that the next pointers always
+	 * lead back to the list.
+	 */
+	if (list_empty(leaf_cfs_rqs)) {
 		/*
-		 * Ensure we either appear before our parent (if already
-		 * enqueued) or force our parent to appear after us when it is
-		 * enqueued.  The fact that we always enqueue bottom-up
-		 * reduces this to two cases.
+		 * Nothing has been collected so far. Make this cfs_rq the
+		 * first entry. There is no need to take care of its next
+		 * pointer.
 		 */
-		if (cfs_rq->tg->parent &&
-		    cfs_rq->tg->parent->cfs_rq[cpu_of(rq_of(cfs_rq))]->on_list) {
-			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		} else {
-			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		}
+		leaf_cfs_rqs->next = &cfs_rq->leaf_cfs_rq_list;
+		leaf_cfs_rqs->prev = &cfs_rq->leaf_cfs_rq_list;
 
-		cfs_rq->on_list = 1;
+	} else {
+		/*
+		 * We already collected at least one entry. Add this cfs_rq
+		 * after the collected ones. Before that, however, we need to
+		 * set its next pointer to a not deleted list entry so that
+		 * concurrent readers of already collected elements cannot run
+		 * into physically deleted elements.
+		 */
+		cfs_rq->leaf_cfs_rq_list.next =
+					&rq_of(cfs_rq)->leaf_cfs_rq_list;
+		__list_link_rcu(leaf_cfs_rqs->prev, &cfs_rq->leaf_cfs_rq_list);
+		leaf_cfs_rqs->prev = &cfs_rq->leaf_cfs_rq_list;
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
+			list_splice_tail_init_rcu(leaf_cfs_rqs,
+					&parent_cfs_rq->leaf_cfs_rq_list);
+		}
+	} else {
+		list_splice_tail_init_rcu(leaf_cfs_rqs,
+					&rq_of(cfs_rq)->leaf_cfs_rq_list);
+	}
+
+	cfs_rq->on_list = 1;
 }
 
 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -263,7 +302,8 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return NULL;
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+					struct list_head *leaf_cfs_rqs)
 {
 }
 
@@ -979,8 +1019,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1)
-		list_add_leaf_cfs_rq(cfs_rq);
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -1307,12 +1345,17 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	struct list_head leaf_cfs_rqs;
+
+	INIT_LIST_HEAD(&leaf_cfs_rqs);
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		if (cfs_rq->nr_running == 1)
+			list_add_leaf_cfs_rq(cfs_rq, &leaf_cfs_rqs);
 		flags = ENQUEUE_WAKEUP;
 	}
 
-- 
1.7.6

