Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0KKD4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:56:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11498 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab0KKDzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:55:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=wSHJy/1RoVZbNOObIU6vceor9Q+HroXCDiUNpS8DG6yER1kNAAvmj/A8FovyrrgBv
	T7h5bG48uEzLHLP9uUSTA==
Message-Id: <20101111035051.156752259@google.com>
References: <20101111035005.443640006@google.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Nov 2010 19:50:15 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [tg_shares_up rewrite v2 10/11] sched: allow update_cfs_load to update global load
Content-Disposition: inline; filename=sched-tg-global_update_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the global load updates from update_shares_cpu() so that
update_cfs_load() can update global load when it is more than ~10% out of sync.

The new global_load parameter allows us to force an update, regardless of
the error factor so that we can synchronize w/ update_shares().

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -538,7 +538,7 @@ static u64 sched_vslice(struct cfs_rq *c
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
-static void update_cfs_load(struct cfs_rq *cfs_rq);
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
 static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
 
 /*
@@ -563,7 +563,7 @@ __update_curr(struct cfs_rq *cfs_rq, str
 
 	cfs_rq->load_unacc_exec_time += delta_exec;
 	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
 }
@@ -701,7 +701,22 @@ account_entity_dequeue(struct cfs_rq *cf
 }
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void update_cfs_load(struct cfs_rq *cfs_rq)
+static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
+					    int global_update)
+{
+	struct task_group *tg = cfs_rq->tg;
+	long load_avg;
+
+	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
+	load_avg -= cfs_rq->load_contribution;
+
+	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
+		atomic_add(load_avg, &tg->load_weight);
+		cfs_rq->load_contribution += load_avg;
+	}
+}
+
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 	u64 period = sysctl_sched_shares_window;
 	u64 now, delta;
@@ -728,6 +743,11 @@ static void update_cfs_load(struct cfs_r
 		cfs_rq->load_avg += delta * load;
 	}
 
+	/* consider updating load contribution on each fold or truncate */
+	if (global_update || cfs_rq->load_period > period
+	    || !cfs_rq->load_period)
+		update_cfs_rq_load_contribution(cfs_rq, global_update);
+
 	while (cfs_rq->load_period > period) {
 		/*
 		 * Inline assembly required to prevent the compiler
@@ -917,7 +937,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
 
@@ -978,7 +998,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq, 0);
@@ -1213,7 +1233,7 @@ enqueue_task_fair(struct rq *rq, struct 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -1243,7 +1263,7 @@ static void dequeue_task_fair(struct rq 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -2045,7 +2065,6 @@ static int update_shares_cpu(struct task
 	struct cfs_rq *cfs_rq;
 	unsigned long flags;
 	struct rq *rq;
-	long load_avg;
 
 	if (!tg->se[cpu])
 		return 0;
@@ -2056,12 +2075,7 @@ static int update_shares_cpu(struct task
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq);
-
-	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
-	load_avg -= cfs_rq->load_contribution;
-	atomic_add(load_avg, &tg->load_weight);
-	cfs_rq->load_contribution += load_avg;
+	update_cfs_load(cfs_rq, 1);
 
 	/*
 	 * We need to update shares after updating tg->load_weight in

-- 

