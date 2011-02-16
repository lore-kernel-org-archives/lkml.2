Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1BPDUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:20:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52369 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1BPDUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:20:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=rts9tD7CljM7JfFC3gU2+xvWxbTzzVEsp74YhdvoBnEZZRjLamUSEzg3vrQ3/U2tm
	kkAtyk2InSBynQS4od/rw==
Message-Id: <20110216031841.068673650@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Feb 2011 19:18:34 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities which exceed their local quota
References: <20110216031831.571628191@google.com>
Content-Disposition: inline; filename=sched-bwc-throttle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 kernel/sched.c      |    3 +
 kernel/sched_fair.c |  121 +++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 114 insertions(+), 10 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -388,6 +388,7 @@ struct cfs_rq {
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	u64 quota_assigned, quota_used;
+	int throttled;
 #endif
 #endif
 };
@@ -1656,6 +1657,8 @@ static void update_h_load(long cpu)
 
 static void double_rq_lock(struct rq *rq1, struct rq *rq2);
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
+
 /*
  * fair double_lock_balance: Safely acquires both rq->locks in a fair
  * way at the expense of forcing extra atomic operations in all
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -331,8 +331,34 @@ static inline struct cfs_bandwidth *tg_c
 	return &tg->cfs_bandwidth;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttled;
+}
+
+/* it's possible to be 'on_rq' in a dequeued (e.g. throttled) hierarchy */
+static inline int entity_on_rq(struct sched_entity *se)
+{
+	for_each_sched_entity(se)
+		if (!se->on_rq)
+			return 0;
+
+	return 1;
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec);
+#else
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static inline int entity_on_rq(struct sched_entity *se)
+{
+	return se->on_rq;
+}
+
 #endif
 
 
@@ -744,9 +770,10 @@ static void update_cfs_rq_load_contribut
 					    int global_update)
 {
 	struct task_group *tg = cfs_rq->tg;
-	long load_avg;
+	long load_avg = 0;
 
-	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
+	if (!cfs_rq_throttled(cfs_rq))
+		load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
 	load_avg -= cfs_rq->load_contribution;
 
 	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
@@ -761,7 +788,11 @@ static void update_cfs_load(struct cfs_r
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
-	if (cfs_rq->tg == &root_task_group)
+	/*
+	 * Don't maintain averages for the root task group, or while we are
+	 * throttled.
+	 */
+	if (cfs_rq->tg == &root_task_group || cfs_rq_throttled(cfs_rq))
 		return;
 
 	now = rq_of(cfs_rq)->clock_task;
@@ -1015,6 +1046,14 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+
+
+#ifdef CONFIG_CFS_BANDWIDTH
+	if (!entity_is_task(se) && (cfs_rq_throttled(group_cfs_rq(se)) ||
+	     !group_cfs_rq(se)->nr_running))
+		return;
+#endif
+
 	update_cfs_load(cfs_rq, 0);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
@@ -1087,6 +1126,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	update_curr(cfs_rq);
 
+#ifdef CONFIG_CFS_BANDWIDTH
+	if (!entity_is_task(se) && cfs_rq_throttled(group_cfs_rq(se)))
+		return;
+#endif
+
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
 #ifdef CONFIG_SCHEDSTATS
@@ -1363,6 +1407,9 @@ enqueue_task_fair(struct rq *rq, struct 
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		/* don't continue to enqueue if our parent is throttled */
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1390,8 +1437,11 @@ static void dequeue_task_fair(struct rq 
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
@@ -1430,6 +1480,42 @@ static u64 tg_request_cfs_quota(struct t
 	return delta;
 }
 
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	/* account load preceeding throttle */
+	update_cfs_load(cfs_rq, 0);
+
+	/* prevent previous buddy nominations from re-picking this se */
+	clear_buddies(cfs_rq_of(se), se);
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
+	update_cfs_rq_load_contribution(cfs_rq, 1);
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec)
 {
@@ -1438,10 +1524,16 @@ static void account_cfs_rq_quota(struct 
 
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
@@ -1941,6 +2033,12 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
+#ifdef CONFIG_CFS_BANDWIDTH
+	/* avoid pre-emption check/buddy nomination for throttled tasks */
+	if (!entity_on_rq(pse))
+		return;
+#endif
+
 	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
@@ -2060,7 +2158,8 @@ static bool yield_to_task_fair(struct rq
 {
 	struct sched_entity *se = &p->se;
 
-	if (!se->on_rq)
+	/* ensure entire hierarchy is on rq (e.g. running & not throttled) */
+	if (!entity_on_rq(se))
 		return false;
 
 	/* Tell the scheduler that we'd really like pse to run next. */
@@ -2280,7 +2379,8 @@ static void update_shares(int cpu)
 
 	rcu_read_lock();
 	for_each_leaf_cfs_rq(rq, cfs_rq)
-		update_shares_cpu(cfs_rq->tg, cpu);
+		if (!cfs_rq_throttled(cfs_rq))
+			update_shares_cpu(cfs_rq->tg, cpu);
 	rcu_read_unlock();
 }
 
@@ -2304,9 +2404,10 @@ load_balance_fair(struct rq *this_rq, in
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


