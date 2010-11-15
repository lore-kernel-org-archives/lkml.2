Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab0KOXxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:53:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888Ab0KOXxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:53:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=Y9/3y1/oqW/svxx8GnUOQVzWz/uIi5Ka9MA7nP53axy24/0x2KL3gEYzaSmCcB3qv
	5S1aPYuJHJPWCjjFrRNoQ==
Message-Id: <20101115234937.844900206@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 15 Nov 2010 15:47:03 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [tg_shares_up rewrite v4 04/11] sched: fix load corruption from update_cfs_shares
References: <20101115234659.610333554@google.com>
Content-Disposition: inline; filename=sched-tg-fix-update_cfs_shares.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as part of enqueue_entity both a new entity weight and its contribution to the
queuing cfs_rq / rq are updated.  Since update_cfs_shares will only update the
queueing weights when the entity is on_rq (which in this case it is not yet),
there's a dependency loop here:

update_cfs_shares needs account_entity_enqueue to update cfs_rq->load.weight
account_entity_enqueue needs the updated weight for the queuing cfs_rq load[*]

Fix this and avoid spurious dequeue/enqueues by issuing update_cfs_shares as
if we had accounted the enqueue already.

This was also resulting in rq->load corruption previously.

[*]: this dependency also exists when using the group cfs_rq w/ 
update_cfs_shares as the weight of the enqueued entity changes without the
load being updated.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched_fair.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -718,7 +718,7 @@ static void reweight_entity(struct cfs_r
 		account_entity_enqueue(cfs_rq, se);
 }
 
-static void update_cfs_shares(struct cfs_rq *cfs_rq)
+static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 	struct task_group *tg;
 	struct sched_entity *se;
@@ -732,7 +732,7 @@ static void update_cfs_shares(struct cfs
 	if (!se)
 		return;
 
-	load = cfs_rq->load.weight;
+	load = cfs_rq->load.weight + weight_delta;
 
 	load_weight = atomic_read(&tg->load_weight);
 	load_weight -= cfs_rq->load_contribution;
@@ -754,7 +754,7 @@ static inline void update_cfs_load(struc
 {
 }
 
-static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
+static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
@@ -881,8 +881,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
+	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
-	update_cfs_shares(cfs_rq);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -944,7 +944,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
+	update_cfs_shares(cfs_rq, 0);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1177,7 +1177,7 @@ enqueue_task_fair(struct rq *rq, struct 
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
+		update_cfs_shares(cfs_rq, 0);
 	}
 
 	hrtick_update(rq);
@@ -1207,7 +1207,7 @@ static void dequeue_task_fair(struct rq 
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
+		update_cfs_shares(cfs_rq, 0);
 	}
 
 	hrtick_update(rq);
@@ -2028,7 +2028,7 @@ static int tg_shares_up(struct task_grou
 	 * We need to update shares after updating tg->load_weight in
 	 * order to adjust the weight of groups with long running tasks.
 	 */
-	update_cfs_shares(cfs_rq);
+	update_cfs_shares(cfs_rq, 0);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 


