Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1GRKwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:52:23 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:34979 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab1GRKwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:52:20 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 2/2] sched: Prevent removal of leaf CFS runqueues with on_list children
Date: Mon, 18 Jul 2011 12:50:58 +0200
Message-Id: <1310986258-29985-3-git-send-email-schnhrr@cs.tu-berlin.de>
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

Currently there are (at least) two situations where a parent gets removed
from the list of leaf CFS runqueues although some of its children are
still on the list.

This patch adds a counter for children depending on a parent, preventing
the parent from being removed too early.

Consider three task groups with these parent pointers:
tg1 --> tg2 --> tg3

Situation 1:

1. Enqueue task A in tg1
2. Dequeue task A
3. Enqueue task B in tg2

In step 1 all three runqueues are added as leaves.

In step 2 the primary reason for being on the list vanishes, but all
three runqueues are kept on the list.

In step 3 we call enqueue_entity() for tg2. There, we call
update_cfs_load() before increasing nr_running. Therefore tg2 can be
removed from the leaf list. Note that enqueue_entity() will re-add tg2
at the end, but this will mix up the order as we do not provide tg1
as prev_cfs_rq.

Situation 2:

There is no guarantee that cfs_rq->load_avg of tg1 drops to zero before
that of tg2. Hence, tg2 can be removed before tg1. If something is
enqueued in tg2 after its removal, it would be added at the wrong
position. Enqueuing something in tg1 before it is removed would further
prevent the situation from sorting out itself.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/sched.c      |    1 +
 kernel/sched_fair.c |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9769c75..88c83b8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -344,6 +344,7 @@ struct cfs_rq {
 	 * list is used during load balance.
 	 */
 	int on_list;
+	int children_on_list;
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d021c75..1c7dd1d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -166,14 +166,22 @@ static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
 		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, prev_leaf_cfs_rq);
 
 		cfs_rq->on_list = 1;
+		if (cfs_rq->tg->parent) {
+			int cpu = cpu_of(rq_of(cfs_rq));
+			cfs_rq->tg->parent->cfs_rq[cpu]->children_on_list++;
+		}
 	}
 }
 
 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
-	if (cfs_rq->on_list) {
+	if (cfs_rq->on_list && !cfs_rq->children_on_list) {
 		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
 		cfs_rq->on_list = 0;
+		if (cfs_rq->tg->parent) {
+			int cpu = cpu_of(rq_of(cfs_rq));
+			cfs_rq->tg->parent->cfs_rq[cpu]->children_on_list--;
+		}
 	}
 }
 
-- 
1.7.3.4

