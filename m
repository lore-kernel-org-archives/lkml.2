Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1CWDK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1CWDKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=Olbfch5jorS4wOB2H/WlUhBwtlABtXpYp7BRjvUJscuubatvOEI7URYQ7SgCCk4Ym
	J+AxAZciXEeoOr+pitpGw==
Message-Id: <20110323030449.828962245@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:38 -0700
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
Subject: [patch 12/15] sched: maintain throttled rqs as a list
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-throttle-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain a list of throttle runqueues instead of having to test every runqueue
to determine whether we need to unthrottle.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |    7 +++++++
 kernel/sched_fair.c |   25 +++++++++++++------------
 2 files changed, 20 insertions(+), 12 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -256,6 +256,7 @@ struct cfs_bandwidth {
 	s64 hierarchal_quota; /* used for validating consistency */
 	struct hrtimer period_timer;
 
+	struct list_head throttled_cfs_rq;
 	/* throttle statistics */
 	u64			nr_periods;
 	u64			nr_throttled;
@@ -394,6 +395,8 @@ struct cfs_rq {
 	int quota_enabled, throttled, throttle_count;
 	s64 quota_remaining;
 	u64 throttled_timestamp;
+
+	struct list_head throttled_list;
 #endif
 #endif
 };
@@ -433,6 +436,7 @@ void init_cfs_bandwidth(struct cfs_bandw
 	raw_spin_lock_init(&cfs_b->lock);
 	cfs_b->quota = cfs_b->runtime = quota;
 	cfs_b->period = ns_to_ktime(period);
+	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
@@ -8141,6 +8145,9 @@ static void init_cfs_rq(struct cfs_rq *c
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 	/* allow initial update_cfs_load() to truncate */
+#ifdef CONFIG_CFS_BANDWIDTH
+	INIT_LIST_HEAD(&cfs_rq->throttled_list);
+#endif
 #ifdef CONFIG_SMP
 	cfs_rq->load_stamp = 1;
 #endif
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1405,6 +1405,7 @@ static int tg_throttle_down(struct task_
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
 	long task_delta, dequeue = 1;
 
@@ -1434,7 +1435,11 @@ static void throttle_cfs_rq(struct cfs_r
 	if (!se)
 		rq->nr_running += task_delta;
 
+	raw_spin_lock(&cfs_b->lock);
 	cfs_rq->throttled = 1;
+	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	raw_spin_unlock(&cfs_b->lock);
+
 	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
 }
 
@@ -1450,6 +1455,10 @@ static void unthrottle_cfs_rq(struct cfs
 	update_rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->throttled_time += (rq->clock - cfs_rq->throttled_timestamp);
+
+	cfs_rq->throttled = 0;
+	list_del_rcu(&cfs_rq->throttled_list);
+
 	raw_spin_unlock(&cfs_b->lock);
 	cfs_rq->throttled_timestamp = 0;
 
@@ -1459,7 +1468,6 @@ static void unthrottle_cfs_rq(struct cfs
 	walk_tg_tree_from(cfs_rq->tg, tg_unthrottle_down, tg_nop,
 			(void*)&udd);
 
-	cfs_rq->throttled = 0;
 	if (!cfs_rq->load.weight)
 		return;
 
@@ -1484,22 +1492,15 @@ static void unthrottle_cfs_rq(struct cfs
 		resched_task(rq->curr);
 }
 
-static inline struct task_group *cfs_bandwidth_tg(struct cfs_bandwidth *cfs_b)
-{
-	return container_of(cfs_b, struct task_group, cfs_bandwidth);
-}
-
 static u64 distribute_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 runtime)
 {
-	int i;
+	struct cfs_rq *cfs_rq;
 	u64 quota, remaining = runtime;
-	const struct cpumask *span;
 
 	rcu_read_lock();
-	span = sched_bw_period_mask();
-	for_each_cpu(i, span) {
-		struct rq *rq = cpu_rq(i);
-		struct cfs_rq *cfs_rq = cfs_bandwidth_tg(cfs_b)->cfs_rq[i];
+	list_for_each_entry_rcu(cfs_rq, &cfs_b->throttled_cfs_rq,
+				throttled_list) {
+		struct rq *rq = rq_of(cfs_rq);
 
 		raw_spin_lock(&rq->lock);
 		if (within_bandwidth(cfs_rq))


