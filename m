Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2JXJ4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:56:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2JXJ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:56:52 -0400
Date: Wed, 24 Oct 2012 02:55:40 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-f269ae0469fc882332bdfb5db15d3c1315fe2a10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141507.200772172@google.com>
References: <20120823141507.200772172@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update_cfs_shares at period edge
Git-Commit-ID: f269ae0469fc882332bdfb5db15d3c1315fe2a10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:55:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f269ae0469fc882332bdfb5db15d3c1315fe2a10
Gitweb:     http://git.kernel.org/tip/f269ae0469fc882332bdfb5db15d3c1315fe2a10
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:29 +0200

sched: Update_cfs_shares at period edge

Now that our measurement intervals are small (~1ms) we can amortize the posting
of update_shares() to be about each period overflow.  This is a large cost
saving for frequently switching tasks.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141507.200772172@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dcc27d8..002a769 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1187,6 +1187,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	}
 
 	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
+	update_cfs_shares(cfs_rq);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
@@ -1396,9 +1397,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
-	update_cfs_shares(cfs_rq);
+	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -1471,7 +1471,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -1491,8 +1490,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
-	se->on_rq = 0;
 	account_entity_dequeue(cfs_rq, se);
+	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1506,7 +1505,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	return_cfs_rq_runtime(cfs_rq);
 
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
+	se->on_rq = 0;
 }
 
 /*
@@ -2518,8 +2517,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
 	if (!se) {
@@ -2579,8 +2578,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
 	if (!se) {
@@ -5639,8 +5638,11 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
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
 
