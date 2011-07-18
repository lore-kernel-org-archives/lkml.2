Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1GRKwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:52:12 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:34949 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab1GRKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:52:10 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 1/2] sched: Enforce order of leaf CFS runqueues
Date: Mon, 18 Jul 2011 12:50:57 +0200
Message-Id: <1310986258-29985-2-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310986258-29985-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310986258-29985-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

Currently, it is still possible that the ordering constraint
is violated. Consider a hierarchy of at least three task groups:

tg1 --> tg2 (parent of tg1)--> tg3 (grandparent of tg1)

And the following actions:
1. Enqueue task in tg3
2. Enqueue task in tg1

Due to step 1 tg3 will be on the list somewhere.

However, in step 2 tg1 will be inserted at the end of the list, because
its parent tg2 is not yet on the list. tg2 will then be inserted at the
beginning. So we get:

tg2 --> tg3 --> tg1

This patch addresses this by carrying the information of the
previously inserted leaf during bottom-up enqueuing.

This allows us to insert everything without a child at the beginning of
the list and all not yet enqueued parents of that runqueue right after it.
This way, every series of enqueues is guaranteed to be inserted before
older series. (Note, that this requires that a runqueue is not removed
from the list if it has some children that are still on the list.)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/sched_fair.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..d021c75 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -143,23 +143,27 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return cfs_rq->tg->cfs_rq[this_cpu];
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+					struct cfs_rq *prev_cfs_rq)
 {
+	struct list_head *prev_leaf_cfs_rq;
+
 	if (!cfs_rq->on_list) {
 		/*
-		 * Ensure we either appear before our parent (if already
-		 * enqueued) or force our parent to appear after us when it is
-		 * enqueued.  The fact that we always enqueue bottom-up
-		 * reduces this to two cases.
+		 * Ensure that children appear before their parent. The fact
+		 * that we always enqueue from some point in the hierarchie
+		 * until the top reduces this to two cases:
+		 * Either we are in the middle of one of these enqueue series,
+		 * then we enqueue directly after the last enqueued runqueue;
+		 * or we are starting such a sequence in which case we insert
+		 * the runqueue at the beginning of the list.
 		 */
-		if (cfs_rq->tg->parent &&
-		    cfs_rq->tg->parent->cfs_rq[cpu_of(rq_of(cfs_rq))]->on_list) {
-			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		} else {
-			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		}
+		if (prev_cfs_rq)
+			prev_leaf_cfs_rq = &prev_cfs_rq->leaf_cfs_rq_list;
+		else
+			prev_leaf_cfs_rq = &rq_of(cfs_rq)->leaf_cfs_rq_list;
+
+		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, prev_leaf_cfs_rq);
 
 		cfs_rq->on_list = 1;
 	}
@@ -276,7 +280,8 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return &cpu_rq(this_cpu)->cfs;
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+					struct cfs_rq *prev_cfs_rq)
 {
 }
 
@@ -999,7 +1004,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	se->on_rq = 1;
 
 	if (cfs_rq->nr_running == 1)
-		list_add_leaf_cfs_rq(cfs_rq);
+		list_add_leaf_cfs_rq(cfs_rq, group_cfs_rq(se));
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
-- 
1.7.3.4

