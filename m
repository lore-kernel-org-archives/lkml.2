Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1EGGcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:32:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50441 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1EGGcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=BQtbeoGdJc1yUyanbvUHgrW/1TgFLi7ZaLKuDfF70dcjcP6k5s+yQOrVNpxh1bDtJ
	nf6+IKw/xZOwz77qDUF0A==
Message-Id: <20110503092905.427302001@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:57 -0700
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
Subject: [patch 11/15] sched: prevent interactions between throttled entities and load-balance
References: <20110503092846.022272244@google.com>
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
incurring some O(n^2) costs.

Instead, track hierarchal throttled state at time of transition.  This allows
us to easily identify whether an entity belongs to a throttled hierarchy and
avoid incorrect interactions with it.

Also, when an entity leaves a throttled hierarchy we need to advance its
time averaging for shares averaging so that the elapsed throttled time is not
considered as part of the cfs_rq's operation.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c      |    2 -
 kernel/sched_fair.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 71 insertions(+), 7 deletions(-)

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
@@ -1383,6 +1385,46 @@ static inline int cfs_rq_throttled(struc
 	return cfs_rq->throttled;
 }
 
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttle_count;
+}
+
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
 	struct rq *rq = rq_of(cfs_rq);
@@ -1393,7 +1435,10 @@ static void throttle_cfs_rq(struct cfs_r
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	/* account load preceding throttle */
-	update_cfs_load(cfs_rq, 0);
+	rcu_read_lock();
+	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop,
+			  (void *)(long)rq_of(cfs_rq)->cpu);
+	rcu_read_unlock();
 
 	task_delta = -cfs_rq->h_nr_running;
 	for_each_sched_entity(se) {
@@ -1463,6 +1508,7 @@ static void unthrottle_cfs_rq(struct cfs
 	struct sched_entity *se;
 	int enqueue = 1;
 	long task_delta;
+	struct tg_unthrottle_down_data udd;
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
@@ -1471,6 +1517,13 @@ static void unthrottle_cfs_rq(struct cfs
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
+	update_rq_clock(rq);
+	/* don't include throttled window for load statistics */
+	udd.cpu = rq->cpu;
+	udd.now = rq->clock_task;
+	walk_tg_tree_from(cfs_rq->tg, tg_unthrottle_down, tg_nop,
+			  (void *)&udd);
+
 	if (!cfs_rq->load.weight)
 		return;
 
@@ -1591,6 +1644,11 @@ static inline int cfs_rq_throttled(struc
 	return 0;
 }
 
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 #endif
@@ -2449,6 +2507,9 @@ move_one_task(struct rq *this_rq, int th
 	int pinned = 0;
 
 	for_each_leaf_cfs_rq(busiest, cfs_rq) {
+		if (throttled_hierarchy(cfs_rq))
+			continue;
+
 		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
 
 			if (!can_migrate_task(p, busiest, this_cpu,
@@ -2548,8 +2609,10 @@ static int update_shares_cpu(struct task
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
-	update_rq_clock(rq);
-	update_cfs_load(cfs_rq, 1);
+	if (!throttled_hierarchy(cfs_rq)) {
+		update_rq_clock(rq);
+		update_cfs_load(cfs_rq, 1);
+	}
 
 	/*
 	 * We need to update shares after updating tg->load_weight in
@@ -2593,9 +2656,10 @@ load_balance_fair(struct rq *this_rq, in
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or part of a throttled hierarchy
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+		    throttled_hierarchy(busiest_cfs_rq))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -395,7 +395,7 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
-	int throttled;
+	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif
 #endif


