Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506Ab2HWOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:16:59 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:33363 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab2HWOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:31 -0400
Message-Id: <20120823141507.200772172@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:35 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [patch 13/16] sched: update_cfs_shares at period edge
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-update_cfs_shares_at_decay.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

Now that our measurement intervals are small (~1ms) we can amortize the posting
of update_shares() to be about each period overflow.  This is a large cost
saving for frequently switching tasks.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44cd4be..12e9ae5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1181,6 +1181,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	}
 
 	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
+	update_cfs_shares(cfs_rq);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
@@ -1390,9 +1391,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
-	update_cfs_shares(cfs_rq);
+	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -1465,7 +1465,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -1485,8 +1484,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
-	se->on_rq = 0;
 	account_entity_dequeue(cfs_rq, se);
+	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1500,7 +1499,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	return_cfs_rq_runtime(cfs_rq);
 
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
+	se->on_rq = 0;
 }
 
 /*
@@ -2512,8 +2511,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
 	if (!se) {
@@ -2573,8 +2572,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
 	if (!se) {
@@ -5620,8 +5619,11 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
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
 


