Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0JPEzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:55:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55933 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0JPExn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:53:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=phBQq60X5y6Y8IET55pvKV7zF3ZWKdMjnbQMNamJBzEzl5ukS5ZW5OpP4Uz3D1P27
	SXaC/R7u2ea3ENr/5D3Yw==
Message-Id: <20101016045119.209713901@google.com>
References: <20101016044349.830426011@google.com>
User-Agent: quilt/0.46-1
Date: Fri, 15 Oct 2010 21:43:59 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC tg_shares_up improvements - v1 10/12] sched: allow update_cfs_load to update global load
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
 	update_cfs_shares(cfs_rq_of(se), se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
 
@@ -978,7 +998,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq_of(se), 0);
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

