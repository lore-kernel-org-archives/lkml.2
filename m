Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1CWDKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1CWDKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=m2NAKf5Wo5P9AVFBk05fBN5TwlZNu0BICb7AGU5olQ60fg76JaccCGXO2jK3tKsQ9
	DwGZe0kxSmMAFDPUuepvQ==
Message-Id: <20110323030449.333793180@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:33 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 07/15] sched: prevent interactions between throttled entities and load-balance
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-throttled_shares.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the perspective of load-balance and shares distribution, throttled
entities should be invisible.

However, both of these operations work on 'active' lists and are not
inherently aware of what group hierarchies may be present.  In some cases this
may be side-stepped (e.g. we could sideload via tg_load_down in load balance) 
while in others (e.g. update_shares()) it is more difficult to compute without
incurring some O(n**2) costs.

Instead, track hierarchal throttled state at time of transition.  This allows
us to easily identify whether an entity belongs to a throttled hierarchy and
avoid incorrect interactions with it.

Also, when an entity leaves a throttled hierarchy we need to advance its
time averaging for shares averaging so that the elapsed throttled time is not
considered as part of the cfs_rq's operation.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c      |    2 -
 kernel/sched_fair.c |   78 +++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 57 insertions(+), 23 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -739,13 +739,15 @@ static void update_cfs_rq_load_contribut
 	}
 }
 
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
+
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 	u64 period = sysctl_sched_shares_window;
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
-	if (cfs_rq->tg == &root_task_group)
+	if (cfs_rq->tg == &root_task_group || throttled_hierarchy(cfs_rq))
 		return;
 
 	now = rq_of(cfs_rq)->clock_task;
@@ -1312,23 +1314,7 @@ static inline int cfs_rq_throttled(struc
 
 static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
 {
-	struct task_group *tg;
-	struct sched_entity *se;
-
-	if (cfs_rq_throttled(cfs_rq))
-		return 1;
-
-	tg = cfs_rq->tg;
-	se = tg->se[cpu_of(rq_of(cfs_rq))];
-	if (!se)
-		return 0;
-
-	for_each_sched_entity(se) {
-		if (cfs_rq_throttled(cfs_rq_of(se)))
-			return 1;
-	}
-
-	return 0;
+	return cfs_rq->throttle_count > 0;
 }
 
 static inline int within_bandwidth(struct cfs_rq *cfs_rq)
@@ -1381,6 +1367,41 @@ static void account_cfs_rq_quota(struct 
 	request_cfs_rq_quota(cfs_rq);
 }
 
+struct tg_unthrottle_down_data {
+	int cpu;
+	u64 now;
+};
+
+static int tg_unthrottle_down(struct task_group *tg, void *data)
+{
+	struct tg_unthrottle_down_data *udd = data;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[udd->cpu];
+	u64 delta;
+
+	cfs_rq->throttle_count--;
+	if (!cfs_rq->throttle_count) {
+		/* leaving throttled state, move up windows */
+		delta = udd->now - cfs_rq->load_stamp;
+		cfs_rq->load_stamp += delta;
+		cfs_rq->load_last += delta;
+	}
+
+	return 0;
+}
+
+static int tg_throttle_down(struct task_group *tg, void *data)
+{
+	long cpu = (long)data;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
+
+	/* group is entering throttled state, record last load */
+	if (!cfs_rq->throttle_count)
+		update_cfs_load(cfs_rq, 0);
+	cfs_rq->throttle_count++;
+
+	return 0;
+}
+
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se;
@@ -1388,7 +1409,10 @@ static void throttle_cfs_rq(struct cfs_r
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	/* account load preceding throttle */
-	update_cfs_load(cfs_rq, 0);
+	rcu_read_lock();
+	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop,
+			(void*)(long)rq_of(cfs_rq)->cpu);
+	rcu_read_unlock();
 
 	for_each_sched_entity(se) {
 		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
@@ -1408,11 +1432,18 @@ static void unthrottle_cfs_rq(struct cfs
 {
 	struct rq *rq = rq_of(cfs_rq);
 	struct sched_entity *se;
+	struct tg_unthrottle_down_data udd;
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	update_rq_clock(rq);
 
+	/* don't include throttled window for load statistics */
+	udd.cpu = rq->cpu;
+	udd.now = rq->clock_task;
+	walk_tg_tree_from(cfs_rq->tg, tg_unthrottle_down, tg_nop,
+			(void*)&udd);
+
 	cfs_rq->throttled = 0;
 	if (!cfs_rq->load.weight)
 		return;
@@ -2488,8 +2519,10 @@ static void update_shares(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
-	for_each_leaf_cfs_rq(rq, cfs_rq)
-		update_shares_cpu(cfs_rq->tg, cpu);
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		if (!throttled_hierarchy(cfs_rq))
+			update_shares_cpu(cfs_rq->tg, cpu);
+	}
 	rcu_read_unlock();
 }
 
@@ -2515,7 +2548,8 @@ load_balance_fair(struct rq *this_rq, in
 		/*
 		 * empty group
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+				throttled_hierarchy(busiest_cfs_rq));
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -386,7 +386,7 @@ struct cfs_rq {
 	unsigned long load_contribution;
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
-	int quota_enabled, throttled;
+	int quota_enabled, throttled, throttle_count;
 	s64 quota_remaining;
 #endif
 #endif


