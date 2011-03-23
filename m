Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1CWDKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1CWDKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=so6qnXuU3WQ2Sh16B/k8UqEKvSpYavtu25LVCgbFqpqGSVTbGo4qR7oLXNG8CYzsy
	bOhEVZ7boY2yJNbyF845w==
Message-Id: <20110323030449.047028257@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:30 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: [patch 04/15] sched: throttle cfs_rq entities which exceed their local quota
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-throttle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In account_cfs_rq_quota() (via update_curr()) we track consumption versus a
cfs_rqs locally assigned quota and whether there is global quota available 
to provide a refill when it runs out.

In the case that there is no quota remaining it's necessary to throttle so
that execution ceases until the susbequent period.  While it is at this
boundary that we detect (and signal for, via reshed_task) that a throttle is
required, the actual operation is deferred until put_prev_entity().

At this point the cfs_rq is marked as throttled and not re-enqueued, this
avoids potential interactions with throttled runqueues in the event that we
are not immediately able to evict the running task.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |    2 
 kernel/sched_fair.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 113 insertions(+), 6 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -386,7 +386,7 @@ struct cfs_rq {
 	unsigned long load_contribution;
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
-	int quota_enabled;
+	int quota_enabled, throttled;
 	s64 quota_remaining;
 #endif
 #endif
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -321,9 +321,6 @@ find_matching_se(struct sched_entity **s
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
-		                 unsigned long delta_exec);
-
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
  */
@@ -588,6 +585,9 @@ __update_curr(struct cfs_rq *cfs_rq, str
 #endif
 }
 
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec);
+
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
@@ -1221,6 +1221,9 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq);
+static inline int within_bandwidth(struct cfs_rq *cfs_rq);
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -1230,6 +1233,9 @@ static void put_prev_entity(struct cfs_r
 	if (prev->on_rq)
 		update_curr(cfs_rq);
 
+	if (!within_bandwidth(cfs_rq))
+		throttle_cfs_rq(cfs_rq);
+
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
@@ -1241,6 +1247,8 @@ static void put_prev_entity(struct cfs_r
 	cfs_rq->curr = NULL;
 }
 
+static void check_cfs_rq_quota(struct cfs_rq *cfs_rq);
+
 static void
 entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 {
@@ -1249,6 +1257,9 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 	 */
 	update_curr(cfs_rq);
 
+	/* check that entity's usage is still within quota (if enabled) */
+	check_cfs_rq_quota(cfs_rq);
+
 	/*
 	 * Update share accounting for long-running entities.
 	 */
@@ -1294,6 +1305,46 @@ static inline u64 sched_cfs_bandwidth_sl
        return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttled;
+}
+
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	struct task_group *tg;
+	struct sched_entity *se;
+
+	if (cfs_rq_throttled(cfs_rq))
+		return 1;
+
+	tg = cfs_rq->tg;
+	se = tg->se[cpu_of(rq_of(cfs_rq))];
+	if (!se)
+		return 0;
+
+	for_each_sched_entity(se) {
+		if (cfs_rq_throttled(cfs_rq_of(se)))
+			return 1;
+	}
+
+	return 0;
+}
+
+static inline int within_bandwidth(struct cfs_rq *cfs_rq)
+{
+	return !cfs_rq->quota_enabled || cfs_rq->quota_remaining > 0;
+}
+
+static void check_cfs_rq_quota(struct cfs_rq *cfs_rq)
+{
+	if (within_bandwidth(cfs_rq))
+		return;
+
+
+	resched_task(rq_of(cfs_rq)->curr);
+}
+
 static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
@@ -1330,6 +1381,29 @@ static void account_cfs_rq_quota(struct 
 	request_cfs_rq_quota(cfs_rq);
 }
 
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	/* account load preceding throttle */
+	update_cfs_load(cfs_rq, 0);
+
+	for_each_sched_entity(se) {
+		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
+		/* throttled entity or throttle-on-deactivate */
+		if (!se->on_rq)
+			break;
+
+		dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
+		if (qcfs_rq->load.weight)
+			break;
+	}
+
+	cfs_rq->throttled = 1;
+}
+
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
 	return 1;
@@ -1340,6 +1414,23 @@ static inline u64 default_cfs_period(voi
 	return 0;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static inline int within_bandwidth(struct cfs_rq *cfs_rq)
+{
+	return 1;
+}
+
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static void check_cfs_rq_quota(struct cfs_rq *cfs_rq) {}
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq) {}
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}
 #endif
@@ -1421,6 +1512,12 @@ enqueue_task_fair(struct rq *rq, struct 
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		/* end evaluation on throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq)) {
+			se = NULL;
+			break;
+		}
+		check_cfs_rq_quota(cfs_rq);
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1447,10 +1544,15 @@ static void dequeue_task_fair(struct rq 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
-
+		/* end evaluation on throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq)) {
+			se = NULL;
+			break;
+		}
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight)
 			break;
+		check_cfs_rq_quota(cfs_rq);
 		flags |= DEQUEUE_SLEEP;
 	}
 
@@ -1955,6 +2057,10 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
+	/* avoid preemption check/buddy nomination for throttled tasks */
+	if (throttled_hierarchy(cfs_rq_of(pse)))
+		return;
+
 	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
@@ -2076,7 +2182,8 @@ static bool yield_to_task_fair(struct rq
 {
 	struct sched_entity *se = &p->se;
 
-	if (!se->on_rq)
+	/* ensure entire hierarchy is on rq (e.g. running & not throttled) */
+	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
 		return false;
 
 	/* Tell the scheduler that we'd really like pse to run next. */


