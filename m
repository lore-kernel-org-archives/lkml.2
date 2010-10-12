Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0JLHwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:52:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51709 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab0JLHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:52:08 -0400
Date: Tue, 12 Oct 2010 13:22:02 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed their
	local quota
Message-ID: <20101012075202.GD9893@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012074910.GA9893@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: throttle cfs_rq entities which exceed their local quota

From: Paul Turner <pjt@google.com>

In account_cfs_rq_quota() (via update_curr()) we track consumption versus a
cfs_rq's local quota and whether there is global quota available to continue
enabling it in the event we run out.

This patch adds the required support for the latter case, throttling entities
until quota is available to run.  Throttling dequeues the entity in question
and sends a reschedule to the owning cpu so that it can be evicted.

The following restrictions apply to a throttled cfs_rq:
- It is dequeued from sched_entity hierarchy and restricted from being
  re-enqueued.  This means that new/waking children of this entity will be
  queued up to it, but not past it.
- It does not contribute to weight calculations in tg_shares_up
- In the case that the cfs_rq of the cpu we are trying to pull from is throttled
  it is  is ignored by the loadbalancer in __load_balance_fair() and
  move_one_task_fair().

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   12 ++++++++
 kernel/sched_fair.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 76 insertions(+), 6 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -387,6 +387,7 @@ struct cfs_rq {
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	u64 quota_assigned, quota_used;
+	int throttled;
 #endif
 #endif
 };
@@ -1668,6 +1669,8 @@ static void update_group_shares_cpu(stru
 	}
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
+
 /*
  * Re-compute the task group their per cpu shares over the given domain.
  * This needs to be done in a bottom-up fashion because the rq weight of a
@@ -1688,7 +1691,14 @@ static int tg_shares_up(struct task_grou
 	usd_rq_weight = per_cpu_ptr(update_shares_data, smp_processor_id());
 
 	for_each_cpu(i, sched_domain_span(sd)) {
-		weight = tg->cfs_rq[i]->load.weight;
+		/*
+		 * bandwidth throttled entities cannot contribute to load
+		 * balance
+		 */
+		if (!cfs_rq_throttled(tg->cfs_rq[i]))
+			weight = tg->cfs_rq[i]->load.weight;
+		else
+			weight = 0;
 		usd_rq_weight[i] = weight;
 
 		rq_weight += weight;
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -273,8 +273,18 @@ static inline struct cfs_bandwidth *tg_c
 	return &tg->cfs_bandwidth;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttled;
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec);
+#else
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
 #endif
 
 
@@ -787,6 +797,11 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+
+	if (!entity_is_task(se) && (cfs_rq_throttled(group_cfs_rq(se)) ||
+	     !group_cfs_rq(se)->nr_running))
+		return;
+
 	account_entity_enqueue(cfs_rq, se);
 
 	if (flags & ENQUEUE_WAKEUP) {
@@ -823,6 +838,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	update_curr(cfs_rq);
 
+	if (!entity_is_task(se) && cfs_rq_throttled(group_cfs_rq(se)))
+		return;
+
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
 #ifdef CONFIG_SCHEDSTATS
@@ -1068,6 +1086,9 @@ enqueue_task_fair(struct rq *rq, struct 
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		/* don't continue to enqueue if our parent is throttled */
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1087,8 +1108,11 @@ static void dequeue_task_fair(struct rq 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
-		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		/*
+		 * Don't dequeue parent if it has other entities besides us,
+		 * or if it is throttled
+		 */
+		if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
 			break;
 		flags |= DEQUEUE_SLEEP;
 	}
@@ -1166,6 +1190,35 @@ static u64 tg_request_cfs_quota(struct t
 	return delta;
 }
 
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	/*
+	 * It's possible for the current task to block and re-wake before task
+	 * switch, leading to a throttle within enqueue_task->update_curr()
+	 * versus an an entity that has not technically been enqueued yet.
+	 *
+	 * In this case, since we haven't actually done the enqueue yet, cut
+	 * out and allow enqueue_entity() to short-circuit
+	 */
+	if (!se->on_rq)
+		goto out_throttled;
+
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		dequeue_entity(cfs_rq, se, 1);
+		if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
+			break;
+	}
+
+out_throttled:
+	cfs_rq->throttled = 1;
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec)
 {
@@ -1174,10 +1227,16 @@ static void account_cfs_rq_quota(struct 
 
 	cfs_rq->quota_used += delta_exec;
 
-	if (cfs_rq->quota_used < cfs_rq->quota_assigned)
+	if (cfs_rq_throttled(cfs_rq) ||
+		cfs_rq->quota_used < cfs_rq->quota_assigned)
 		return;
 
 	cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
+
+	if (cfs_rq->quota_used >= cfs_rq->quota_assigned) {
+		throttle_cfs_rq(cfs_rq);
+		resched_task(cfs_rq->rq->curr);
+	}
 }
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
@@ -1995,9 +2054,10 @@ load_balance_fair(struct rq *this_rq, in
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or throttled cfs_rq
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+				cfs_rq_throttled(busiest_cfs_rq))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
