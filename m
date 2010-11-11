Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab0KKDzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:55:39 -0500
Received: from smtp-out.google.com ([74.125.121.35]:43859 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab0KKDzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:55:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=XQLWA4ehvbpAMO5AXLz6s0OqInMF5K9l/0O2HpTlFXgMNCUnDTqYQZwZQiDgA9N50
	zOwWpyPB30TvNfdZjs3hg==
Message-Id: <20101111035050.767513048@google.com>
References: <20101111035005.443640006@google.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Nov 2010 19:50:10 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [tg_shares_up rewrite v2 05/11] sched: fix update_cfs_load synchronization
Content-Disposition: inline; filename=sched-tg-fix-update_cfs_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using cfs_rq->nr_running is not sufficient to synchronize update_cfs_load with
the put path since nr_running accounting occurs at deactivation.

It's also not safe to make the removal decision based on load_avg as this fails
with both high periods and low shares.  Resolve this by clipping history at 8
foldings.

Note: the above will always occur from update_shares() since in the 
last-task-sleep-case that task will still be cfs_rq->curr when update_cfs_load is 
called.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   33 +++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 13 deletions(-)

Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -674,10 +674,11 @@ account_entity_dequeue(struct cfs_rq *cf
 }
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
+static void update_cfs_load(struct cfs_rq *cfs_rq)
 {
 	u64 period = sched_avg_period();
 	u64 now, delta;
+	unsigned long load = cfs_rq->load.weight;
 
 	if (!cfs_rq)
 		return;
@@ -685,9 +686,19 @@ static void update_cfs_load(struct cfs_r
 	now = rq_of(cfs_rq)->clock;
 	delta = now - cfs_rq->load_stamp;
 
+	/* truncate load history at 4 idle periods */
+	if (cfs_rq->load_stamp > cfs_rq->load_last &&
+	    now - cfs_rq->load_last > 4 * period) {
+		cfs_rq->load_period = 0;
+		cfs_rq->load_avg = 0;
+	}
+
 	cfs_rq->load_stamp = now;
 	cfs_rq->load_period += delta;
-	cfs_rq->load_avg += delta * cfs_rq->load.weight;
+	if (load) {
+		cfs_rq->load_last = now;
+		cfs_rq->load_avg += delta * load;
+	}
 
 	while (cfs_rq->load_period > period) {
 		/*
@@ -700,10 +711,8 @@ static void update_cfs_load(struct cfs_r
 		cfs_rq->load_avg /= 2;
 	}
 
-	if (lb && !cfs_rq->nr_running) {
-		if (cfs_rq->load_avg < (period / 8))
-			list_del_leaf_cfs_rq(cfs_rq);
-	}
+	if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
+		list_del_leaf_cfs_rq(cfs_rq);
 }
 
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
@@ -750,7 +759,7 @@ static void update_cfs_shares(struct cfs
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
+static inline void update_cfs_load(struct cfs_rq *cfs_rq)
 {
 }
 
@@ -880,7 +889,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq, 0);
+	update_cfs_load(cfs_rq);
 	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
 
@@ -941,7 +950,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq, 0);
+	update_cfs_load(cfs_rq);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq, 0);
@@ -1176,7 +1185,7 @@ enqueue_task_fair(struct rq *rq, struct 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq, 0);
+		update_cfs_load(cfs_rq);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -1206,7 +1215,7 @@ static void dequeue_task_fair(struct rq 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq, 0);
+		update_cfs_load(cfs_rq);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -2019,7 +2028,7 @@ static int tg_shares_up(struct task_grou
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq, 1);
+	update_cfs_load(cfs_rq);
 
 	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
 	load_avg -= cfs_rq->load_contribution;
Index: kernel/sched.c
===================================================================
--- kernel/sched.c.orig
+++ kernel/sched.c
@@ -357,7 +357,7 @@ struct cfs_rq {
 
 	u64 load_avg;
 	u64 load_period;
-	u64 load_stamp;
+	u64 load_stamp, load_last;
 
 	unsigned long load_contribution;
 #endif

-- 

