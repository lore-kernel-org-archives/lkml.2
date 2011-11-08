Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1KHE36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:29:58 -0500
Received: from smtp-out.google.com ([74.125.121.67]:10541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1KHE3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:29:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=HVEofsjPd/0mlqW/62k19wQyte3bTpdI1z81UfbYtuSG8kx/bXG605hCTwnTD9VTb
	LCZD5RQW6t+CuzIvKg7Tw==
Message-Id: <20111108042736.683407863@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:26:35 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Cc: Ben Segall <bsegall@google.com>
Subject: [patch 3/3] From: Ben Segall <bsegall@google.com>
References: <20111108042632.977080206@google.com>
Content-Disposition: inline; filename=sched-bwc-fix_nr_running.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: update task accounting on throttle so that idle_balance() will trigger

Since throttling occurs in the put_prev_task() path we do not get to observe
this delta against nr_running when making the decision to idle_balance().

Fix this by first enumerating cfs_rq throttle states so that we can distinguish
throttling cfs_rqs.  Then remove tasks that will be throttled in put_prev_task
from rq->nr_running/cfs_rq->h_nr_running when in account_cfs_rq_runtime,
rather than delaying until put_prev_task.

This allows schedule() to call idle_balance when we go idle due to throttling.

Using Kamalesh's nested-cgroup test case[1] we see the following improvement on
a 16 core system:
baseline: Average CPU Idle percentage 13.9667%
  +patch: Average CPU Idle percentage 3.53333%
[1]: https://lkml.org/lkml/2011/9/15/261

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c      |   24 ++++++++----
 kernel/sched_fair.c |  101 ++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 87 insertions(+), 38 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -269,6 +269,13 @@ struct cfs_bandwidth {
 #endif
 };
 
+enum runtime_state {
+	RUNTIME_UNLIMITED,
+	RUNTIME_AVAILABLE,
+	RUNTIME_THROTTLING,
+	RUNTIME_THROTTLED
+};
+
 /* task group related information */
 struct task_group {
 	struct cgroup_subsys_state css;
@@ -402,12 +409,12 @@ struct cfs_rq {
 	unsigned long load_contribution;
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
-	int runtime_enabled;
+	enum runtime_state runtime_state;
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
 	u64 throttled_timestamp;
-	int throttled, throttle_count;
+	int throttle_count;
 	struct list_head throttled_list;
 #endif
 #endif
@@ -470,7 +477,7 @@ static void init_cfs_bandwidth(struct cf
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
-	cfs_rq->runtime_enabled = 0;
+	cfs_rq->runtime_state = RUNTIME_UNLIMITED;
 	INIT_LIST_HEAD(&cfs_rq->throttled_list);
 }
 
@@ -6368,7 +6375,7 @@ static void unthrottle_offline_cfs_rqs(s
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
 		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 
-		if (!cfs_rq->runtime_enabled)
+		if (!cfs_rq_runtime_enabled(cfs_rq))
 			continue;
 
 		/*
@@ -9263,11 +9270,14 @@ static int tg_set_cfs_bandwidth(struct t
 		struct rq *rq = rq_of(cfs_rq);
 
 		raw_spin_lock_irq(&rq->lock);
-		cfs_rq->runtime_enabled = runtime_enabled;
-		cfs_rq->runtime_remaining = 0;
-
 		if (cfs_rq_throttled(cfs_rq))
 			unthrottle_cfs_rq(cfs_rq);
+
+		if (runtime_enabled)
+			cfs_rq->runtime_state = RUNTIME_AVAILABLE;
+		else
+			cfs_rq->runtime_state = RUNTIME_UNLIMITED;
+		cfs_rq->runtime_remaining = 0;
 		raw_spin_unlock_irq(&rq->lock);
 	}
 out_unlock:
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1387,6 +1387,27 @@ static void expire_cfs_rq_runtime(struct
 	}
 }
 
+static void account_nr_throttling(struct cfs_rq *cfs_rq, long nr_throttling)
+{
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	for_each_sched_entity(se) {
+		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
+		if (!se->on_rq)
+			break;
+
+		qcfs_rq->h_nr_running -= nr_throttling;
+
+		if (qcfs_rq->runtime_state == RUNTIME_THROTTLING)
+			break;
+	}
+
+	if (!se)
+		rq_of(cfs_rq)->nr_running -= nr_throttling;
+}
+
 static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec)
 {
@@ -1401,14 +1422,33 @@ static void __account_cfs_rq_runtime(str
 	 * if we're unable to extend our runtime we resched so that the active
 	 * hierarchy can be throttled
 	 */
-	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
-		resched_task(rq_of(cfs_rq)->curr);
+	if (assign_cfs_rq_runtime(cfs_rq))
+		return;
+
+	if (unlikely(!cfs_rq->curr) || throttled_hierarchy(cfs_rq) ||
+	   cfs_rq->runtime_state == RUNTIME_THROTTLING)
+		return;
+
+	resched_task(rq_of(cfs_rq)->curr);
+
+	/*
+	* Remove us from nr_running/h_nr_running so
+	* that idle_balance gets called if necessary
+	*/
+	account_nr_throttling(cfs_rq, cfs_rq->h_nr_running);
+	cfs_rq->runtime_state = RUNTIME_THROTTLING;
+}
+
+static inline int cfs_rq_runtime_enabled(struct cfs_rq *cfs_rq)
+{
+	return cfs_bandwidth_used() &&
+		cfs_rq->runtime_state != RUNTIME_UNLIMITED;
 }
 
 static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 						   unsigned long delta_exec)
 {
-	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
+	if (!cfs_rq_runtime_enabled(cfs_rq))
 		return;
 
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
@@ -1416,7 +1456,9 @@ static __always_inline void account_cfs_
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
-	return cfs_bandwidth_used() && cfs_rq->throttled;
+	return cfs_bandwidth_used() &&
+		(cfs_rq->runtime_state == RUNTIME_THROTTLED ||
+		 cfs_rq->runtime_state == RUNTIME_THROTTLING);
 }
 
 /* check whether cfs_rq, or any parent, is throttled */
@@ -1483,7 +1525,6 @@ static void throttle_cfs_rq(struct cfs_r
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	long task_delta, dequeue = 1;
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
@@ -1492,25 +1533,19 @@ static void throttle_cfs_rq(struct cfs_r
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
 
-	task_delta = cfs_rq->h_nr_running;
 	for_each_sched_entity(se) {
 		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
 		/* throttled entity or throttle-on-deactivate */
 		if (!se->on_rq)
 			break;
 
-		if (dequeue)
-			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
-		qcfs_rq->h_nr_running -= task_delta;
+		dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
 
 		if (qcfs_rq->load.weight)
-			dequeue = 0;
+			break;
 	}
 
-	if (!se)
-		rq->nr_running -= task_delta;
-
-	cfs_rq->throttled = 1;
+	cfs_rq->runtime_state = RUNTIME_THROTTLED;
 	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
@@ -1525,9 +1560,15 @@ static void unthrottle_cfs_rq(struct cfs
 	int enqueue = 1;
 	long task_delta;
 
+	if (cfs_rq->runtime_state == RUNTIME_THROTTLING) {
+		/* do only the partial unthrottle */
+		account_nr_throttling(cfs_rq, -cfs_rq->h_nr_running);
+		return;
+	}
+
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
-	cfs_rq->throttled = 0;
+	cfs_rq->runtime_state = RUNTIME_AVAILABLE;
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
 	list_del_rcu(&cfs_rq->throttled_list);
@@ -1743,10 +1784,7 @@ static void __return_cfs_rq_runtime(stru
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_bandwidth_used())
-		return;
-
-	if (!cfs_rq->runtime_enabled || cfs_rq->nr_running)
+	if (!cfs_rq_runtime_enabled(cfs_rq) || cfs_rq->nr_running)
 		return;
 
 	__return_cfs_rq_runtime(cfs_rq);
@@ -1791,15 +1829,12 @@ static void do_sched_cfs_slack_timer(str
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_bandwidth_used())
-		return;
-
 	/* an active group must be handled by the update_curr()->put() path */
-	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
+	if (!cfs_rq_runtime_enabled(cfs_rq) || cfs_rq->curr)
 		return;
 
 	/* ensure the group is not already throttled */
-	if (cfs_rq_throttled(cfs_rq))
+	if (cfs_rq->runtime_state == RUNTIME_THROTTLED)
 		return;
 
 	/* update runtime allocation */
@@ -1814,17 +1849,21 @@ static void check_cfs_rq_runtime(struct 
 	if (!cfs_bandwidth_used())
 		return;
 
-	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
+	if (likely(cfs_rq->runtime_state != RUNTIME_THROTTLING))
 		return;
 
 	/*
-	 * it's possible for a throttled entity to be forced into a running
-	 * state (e.g. set_curr_task), in this case we're finished.
+	* it is possible for additional bandwidth to arrive between
+	* when we call resched_task for being out of runtime and we
+	* call put_prev_task, in which case reaccount the now running
+	* tasks
 	 */
-	if (cfs_rq_throttled(cfs_rq))
-		return;
-
-	throttle_cfs_rq(cfs_rq);
+	if (unlikely(cfs_rq->runtime_remaining > 0)) {
+		account_nr_throttling(cfs_rq, -cfs_rq->h_nr_running);
+		cfs_rq->runtime_state = RUNTIME_AVAILABLE;
+	} else {
+		throttle_cfs_rq(cfs_rq);
+	}
 }
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,


