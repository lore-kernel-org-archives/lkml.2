Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab1AVFFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 00:05:15 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45762 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1AVFFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 00:05:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=AQFCsSI9YSqiRW1vfRpr9DSPAaJwpXtl+/fyoWPaME0J89pI1Jp4XT5oWO6NcD0aC
	kL9taA1UiN6ggQ5AfrT2A==
Message-Id: <20110122044851.915214637@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 20:45:01 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [patch 3/5] sched: simplify update_cfs_shares parameters
References: <20110122044458.058531078@google.com>
Content-Disposition: inline; filename=sched-clean_update_shares.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-visiting this:  Since update_cfs_shares will now only ever re-weight an
entity that is a relative parent of the current entity in enqueue_entity; we
can safely issue the account_entity_enqueue relative to that cfs_rq and avoid
the requirement for special handling of the enqueue case in update_cfs_shares.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -540,7 +540,7 @@ static u64 sched_vslice(struct cfs_rq *c
 }
 
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
-static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
+static void update_cfs_shares(struct cfs_rq *cfs_rq);
 
 /*
  * Update the current task's runtime statistics. Skip current tasks that
@@ -778,7 +778,7 @@ static void reweight_entity(struct cfs_r
 		account_entity_enqueue(cfs_rq, se);
 }
 
-static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+static void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg;
 	struct sched_entity *se;
@@ -789,11 +789,11 @@ static void update_cfs_shares(struct cfs
 	if (!se)
 		return;
 
-	load = cfs_rq->load.weight + weight_delta;
+	load = cfs_rq->load.weight;
 
 	load_weight = atomic_read(&tg->load_weight);
-	load_weight -= cfs_rq->load_contribution;
 	load_weight += load;
+	load_weight -= cfs_rq->load_contribution;
 
 	shares = (tg->shares * load);
 	if (load_weight)
@@ -811,7 +811,7 @@ static void update_entity_shares_tick(st
 {
 	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
@@ -819,7 +819,7 @@ static void update_cfs_load(struct cfs_r
 {
 }
 
-static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 }
 
@@ -950,8 +950,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
-	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
+	update_cfs_shares(cfs_rq);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -1013,7 +1013,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq, 0);
+	update_cfs_shares(cfs_rq);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1254,7 +1254,7 @@ enqueue_task_fair(struct rq *rq, struct 
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 
 	hrtick_update(rq);
@@ -1284,7 +1284,7 @@ static void dequeue_task_fair(struct rq 
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 
 	hrtick_update(rq);
@@ -2095,7 +2095,7 @@ static int update_shares_cpu(struct task
 	 * We need to update shares after updating tg->load_weight in
 	 * order to adjust the weight of groups with long running tasks.
 	 */
-	update_cfs_shares(cfs_rq, 0);
+	update_cfs_shares(cfs_rq);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
Index: tip3/kernel/sched.c
===================================================================
--- tip3.orig/kernel/sched.c
+++ tip3/kernel/sched.c
@@ -8510,7 +8510,7 @@ int sched_group_set_shares(struct task_g
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		for_each_sched_entity(se)
-			update_cfs_shares(group_cfs_rq(se), 0);
+			update_cfs_shares(group_cfs_rq(se));
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 


