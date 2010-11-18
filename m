Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab0KROLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:11:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:52059 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab0KROLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:11:40 -0500
Date: Thu, 18 Nov 2010 14:11:16 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234937.844900206@google.com>
References: <20101115234937.844900206@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix load corruption from update_cfs_shares()
Message-ID: <tip-f0d7442a5924a802b66eef79b3708f77297bfb35@git.kernel.org>
Git-Commit-ID: f0d7442a5924a802b66eef79b3708f77297bfb35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:11:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0d7442a5924a802b66eef79b3708f77297bfb35
Gitweb:     http://git.kernel.org/tip/f0d7442a5924a802b66eef79b3708f77297bfb35
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:47 +0100

sched: Fix load corruption from update_cfs_shares()

As part of enqueue_entity both a new entity weight and its contribution to the
queuing cfs_rq / rq are updated.  Since update_cfs_shares will only update the
queueing weights when the entity is on_rq (which in this case it is not yet),
there's a dependency loop here:

update_cfs_shares needs account_entity_enqueue to update cfs_rq->load.weight
account_entity_enqueue needs the updated weight for the queuing cfs_rq load[*]

Fix this and avoid spurious dequeue/enqueues by issuing update_cfs_shares as
if we had accounted the enqueue already.

This was also resulting in rq->load corruption previously.

[*]: this dependency also exists when using the group cfs_rq w/
     update_cfs_shares as the weight of the enqueued entity changes
     without the load being updated.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234937.844900206@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 46ff658..d52b97a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -718,7 +718,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		account_entity_enqueue(cfs_rq, se);
 }
 
-static void update_cfs_shares(struct cfs_rq *cfs_rq)
+static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 	struct task_group *tg;
 	struct sched_entity *se;
@@ -732,7 +732,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq)
 	if (!se)
 		return;
 
-	load = cfs_rq->load.weight;
+	load = cfs_rq->load.weight + weight_delta;
 
 	load_weight = atomic_read(&tg->load_weight);
 	load_weight -= cfs_rq->load_contribution;
@@ -754,7 +754,7 @@ static inline void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 {
 }
 
-static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
+static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
@@ -881,8 +881,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
+	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
-	update_cfs_shares(cfs_rq);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -944,7 +944,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
+	update_cfs_shares(cfs_rq, 0);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1177,7 +1177,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
+		update_cfs_shares(cfs_rq, 0);
 	}
 
 	hrtick_update(rq);
@@ -1207,7 +1207,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
+		update_cfs_shares(cfs_rq, 0);
 	}
 
 	hrtick_update(rq);
@@ -2034,7 +2034,7 @@ static int tg_shares_up(struct task_group *tg, int cpu)
 	 * We need to update shares after updating tg->load_weight in
 	 * order to adjust the weight of groups with long running tasks.
 	 */
-	update_cfs_shares(cfs_rq);
+	update_cfs_shares(cfs_rq, 0);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
