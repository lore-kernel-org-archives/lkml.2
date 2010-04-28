Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0D1LSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:18:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0D1LSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:18:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Q0l7mn0jwWEwRcwfLPKwWLuva/kEVAkSKT+mMeOwAvpmyJ/JYZebJ074toNUBgF4R
	Yu44mU0/ziv4GfjIEFa1g==
Subject: [PATCH v2 3/6] sched: throttle cfs_rq entities which exceed their
	local quota
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 28 Apr 2010 04:17:01 -0700
Message-ID: <20100428111701.7954.32045.stgit@kitami.corp.google.com>
In-Reply-To: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
References: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
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
 kernel/sched.c      |   12 +++++++++-
 kernel/sched_fair.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3b53695..d072881 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -422,6 +422,7 @@ struct cfs_rq {
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	u64 quota_assigned, quota_used;
+	int throttled;
 #endif
 #endif
 };
@@ -1647,6 +1648,8 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
 	}
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
+
 /*
  * Re-compute the task group their per cpu shares over the given domain.
  * This needs to be done in a bottom-up fashion because the rq weight of a
@@ -1667,7 +1670,14 @@ static int tg_shares_up(struct task_group *tg, void *data)
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1db1991..0e480ae 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -273,8 +273,18 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
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
 
 
@@ -799,6 +809,11 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
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
@@ -835,6 +850,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 	 */
 	update_curr(cfs_rq);
 
+	if (!entity_is_task(se) && cfs_rq_throttled(group_cfs_rq(se)))
+		return;
+
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
 #ifdef CONFIG_SCHEDSTATS
@@ -1086,6 +1104,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		/* don't continue to enqueue if our parent is throttled */
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1105,8 +1126,11 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, sleep);
-		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		/*
+		 * Don't dequeue parent if it has other entities besides us,
+		 * or if it is throttled
+		 */
+		if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
 			break;
 		sleep = 1;
 	}
@@ -1184,6 +1208,22 @@ static u64 tg_request_cfs_quota(struct task_group *tg)
 	return delta;
 }
 
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		dequeue_entity(cfs_rq, se, 1);
+		if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
+			break;
+	}
+	cfs_rq->throttled = 1;
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec)
 {
@@ -1192,10 +1232,16 @@ static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 
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
@@ -2057,9 +2103,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
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
@@ -2119,6 +2166,11 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		total_load_moved += load_moved;
 
 #ifdef CONFIG_PREEMPT
+	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
+		/* skip throttled cfs_rq */
+		if (cfs_rq_throttled(busy_cfs_rq))
+			continue;
+
 		/*
 		 * NEWIDLE balancing is a source of latency, so preemptible
 		 * kernels will stop after the first task is pulled to minimize

