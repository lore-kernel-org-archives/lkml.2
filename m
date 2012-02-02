Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2BBBnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:43:51 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:41410 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2BBBnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:24 -0500
Subject: [RFC PATCH 12/14] sched: update_cfs_shares at period edge
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:27 -0800
Message-ID: <20120202013827.20844.23756.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that our measurement intervals are small (~1ms) we can amortize the posting
of update_shares() to be about each period overflow.  This is a large cost
saving for frequently switching tasks.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b6ee7a4..9e2c9a4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1141,6 +1141,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	}
 
 	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
+	update_cfs_shares(cfs_rq);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
@@ -1362,9 +1363,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
-	update_cfs_shares(cfs_rq);
+	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -1437,7 +1437,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -1457,8 +1456,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
-	se->on_rq = 0;
 	account_entity_dequeue(cfs_rq, se);
+	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1472,7 +1471,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	return_cfs_rq_runtime(cfs_rq);
 
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
+	se->on_rq = 0;
 }
 
 /*
@@ -2488,8 +2487,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
 	if (!se) {
@@ -2549,8 +2548,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
 	if (!se) {
@@ -5836,8 +5835,11 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		se = tg->se[i];
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
-		for_each_sched_entity(se)
+		for_each_sched_entity(se) {
 			update_cfs_shares(group_cfs_rq(se));
+			/* update contribution to parent */
+			update_entity_load_avg(se, 1);
+		}
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 


