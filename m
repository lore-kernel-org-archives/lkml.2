Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1GGFdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:33:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1GGFdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=ClKx1nT3MNRQhX90Kn1htEPA2Vxvf149zfNzYjJQUDJMeI6jt7YuJjNGW90oYUJ6r
	pzHVqOI9ohYBo3JL94RCQ==
Message-Id: <20110707053100.733366172@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:47 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 11/17] sched: prevent interactions with throttled entities
References: <20110707053036.173186930@google.com>
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

Instead, track hierarchicaal throttled state at time of transition.  This
allows us to easily identify whether an entity belongs to a throttled hierarchy
and avoid incorrect interactions with it.

Also, when an entity leaves a throttled hierarchy we need to advance its
time averaging for shares averaging so that the elapsed throttled time is not
considered as part of the cfs_rq's operation.

We also use this information to prevent buddy interactions in the wakeup and
yield_to() paths.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c      |    2 -
 kernel/sched_fair.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 94 insertions(+), 7 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -741,13 +741,15 @@ static void update_cfs_rq_load_contribut
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
@@ -856,7 +858,7 @@ static void update_cfs_shares(struct cfs
 
 	tg = cfs_rq->tg;
 	se = tg->se[cpu_of(rq_of(cfs_rq))];
-	if (!se)
+	if (!se || throttled_hierarchy(cfs_rq))
 		return;
 #ifndef CONFIG_SMP
 	if (likely(se->load.weight == tg->shares))
@@ -1419,6 +1421,64 @@ static inline int cfs_rq_throttled(struc
 	return cfs_rq->throttled;
 }
 
+/* check whether cfs_rq, or any parent, is throttled */
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttle_count;
+}
+
+/*
+ * Ensure that neither of the group entities corresponding to src_cpu or
+ * dest_cpu are members of a throttled hierarchy when performing group
+ * load-balance operations.
+ */
+static inline int throttled_lb_pair(struct task_group *tg,
+				    int src_cpu, int dest_cpu)
+{
+	struct cfs_rq *src_cfs_rq, *dest_cfs_rq;
+
+	src_cfs_rq = tg->cfs_rq[src_cpu];
+	dest_cfs_rq = tg->cfs_rq[dest_cpu];
+
+	return throttled_hierarchy(src_cfs_rq) ||
+	       throttled_hierarchy(dest_cfs_rq);
+}
+
+/* updated child weight may affect parent so we have to do this bottom up */
+static int tg_unthrottle_up(struct task_group *tg, void *data)
+{
+	struct rq *rq = data;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[rq->cpu];
+	u64 delta;
+
+	cfs_rq->throttle_count--;
+	if (!cfs_rq->throttle_count) {
+		/* leaving throttled state, advance shares averaging windows */
+		delta = rq->clock_task - cfs_rq->load_stamp;
+
+		cfs_rq->load_stamp += delta;
+		cfs_rq->load_last += delta;
+
+		/* update entity weight now that we are on_rq again */
+		update_cfs_shares(cfs_rq);
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
@@ -1429,7 +1489,10 @@ static void throttle_cfs_rq(struct cfs_r
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	/* account load preceding throttle */
-	update_cfs_load(cfs_rq, 0);
+	rcu_read_lock();
+	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop,
+			  (void *)(long)rq_of(cfs_rq)->cpu);
+	rcu_read_unlock();
 
 	task_delta = cfs_rq->h_nr_running;
 	for_each_sched_entity(se) {
@@ -1470,6 +1533,10 @@ static void unthrottle_cfs_rq(struct cfs
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
+	update_rq_clock(rq);
+	/* update hierarchical throttle state */
+	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
+
 	if (!cfs_rq->load.weight)
 		return;
 
@@ -1614,6 +1681,17 @@ static inline int cfs_rq_throttled(struc
 {
 	return 0;
 }
+
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static inline int throttled_lb_pair(struct task_group *tg,
+				    int src_cpu, int dest_cpu)
+{
+	return 0;
+}
 #endif
 
 /**************************************************
@@ -2513,6 +2591,9 @@ move_one_task(struct rq *this_rq, int th
 	int pinned = 0;
 
 	for_each_leaf_cfs_rq(busiest, cfs_rq) {
+		if (throttled_lb_pair(cfs_rq->tg, busiest->cpu, this_cpu))
+			continue;
+
 		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
 
 			if (!can_migrate_task(p, busiest, this_cpu,
@@ -2625,8 +2706,13 @@ static void update_shares(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
-	for_each_leaf_cfs_rq(rq, cfs_rq)
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		/* throttled entities do not contribute to load */
+		if (throttled_hierarchy(cfs_rq))
+			continue;
+
 		update_shares_cpu(cfs_rq->tg, cpu);
+	}
 	rcu_read_unlock();
 }
 
@@ -2650,9 +2736,10 @@ load_balance_fair(struct rq *this_rq, in
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or part of a throttled hierarchy
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+		    throttled_lb_pair(tg, busiest_cpu, this_cpu))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -399,7 +399,7 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
-	int throttled;
+	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif
 #endif


