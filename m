Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1EGGdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:33:03 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab1EGGcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=wfn1ko8EqmiMYQDm45PEYcwsyohrWbTCkZuE00hKoX1RsUi77dxJunDmhcCNZjzkZ
	r1J0K78N4XmBrecWF0lig==
Message-Id: <20110503092905.163081832@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:54 -0700
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
Subject: [patch 08/15] sched: throttle cfs_rq entities which exceed their local runtime
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-throttle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In account_cfs_rq_runtime() (via update_curr()) we track consumption versus a
cfs_rqs locally assigned runtime and whether there is global runtime available 
to provide a refill when it runs out.

In the case that there is no runtime remaining it's necessary to throttle so
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
 kernel/sched.c      |    7 ++
 kernel/sched_fair.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 133 insertions(+), 5 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -985,6 +985,8 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	se->vruntime = vruntime;
 }
 
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
+
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -1014,8 +1016,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1)
+	if (cfs_rq->nr_running == 1) {
 		list_add_leaf_cfs_rq(cfs_rq);
+		check_enqueue_throttle(cfs_rq);
+	}
 
 	start_cfs_bandwidth(cfs_rq);
 }
@@ -1221,6 +1225,8 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -1230,6 +1236,9 @@ static void put_prev_entity(struct cfs_r
 	if (prev->on_rq)
 		update_curr(cfs_rq);
 
+	/* throttle cfs_rqs exceeding runtime */
+	check_cfs_rq_runtime(cfs_rq);
+
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
@@ -1295,7 +1304,7 @@ static inline u64 sched_cfs_bandwidth_sl
 	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
 }
 
-static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
@@ -1317,6 +1326,8 @@ static void assign_cfs_rq_runtime(struct
 
 	cfs_rq->runtime_remaining += amount;
 	cfs_rq->runtime_expires = max(cfs_rq->runtime_expires, expires);
+
+	return cfs_rq->runtime_remaining > 0;
 }
 
 static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
@@ -1359,7 +1370,90 @@ static void account_cfs_rq_runtime(struc
 	if (cfs_rq->runtime_remaining > 0)
 		return;
 
-	assign_cfs_rq_runtime(cfs_rq);
+	/*
+	 * if we're unable to extend our runtime we resched so that the active
+	 * hierarchy can be throttled
+	 */
+	if (!assign_cfs_rq_runtime(cfs_rq))
+		resched_task(rq_of(cfs_rq)->curr);
+}
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttled;
+}
+
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct sched_entity *se;
+	long task_delta, dequeue = 1;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	/* account load preceding throttle */
+	update_cfs_load(cfs_rq, 0);
+
+	task_delta = -cfs_rq->h_nr_running;
+	for_each_sched_entity(se) {
+		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
+		/* throttled entity or throttle-on-deactivate */
+		if (!se->on_rq)
+			break;
+
+		if (dequeue)
+			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
+		qcfs_rq->h_nr_running += task_delta;
+
+		if (qcfs_rq->load.weight)
+			dequeue = 0;
+	}
+
+	if (!se)
+		rq->nr_running += task_delta;
+
+	cfs_rq->throttled = 1;
+	raw_spin_lock(&cfs_b->lock);
+	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	raw_spin_unlock(&cfs_b->lock);
+}
+
+/* conditionally throttle active cfs_rq's from put_prev_entity() */
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	if (!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0)
+		return;
+
+	/*
+	 * it's possible active load balance has forced a throttled cfs_rq to
+	 * run again, we don't want to re-throttled in this case.
+	 */
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	throttle_cfs_rq(cfs_rq);
+}
+
+/*
+ * When a group wakes up we want to make sure that its quota is not already
+ * expired, otherwise it may be allowed to steal additional ticks of runtime
+ * since update_curr() throttling can not not trigger until it's on-rq.
+ */
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
+{
+	/* an active group must be handled by the update_curr()->put() path */
+	if (cfs_rq->curr || !cfs_rq->runtime_enabled)
+		return;
+
+	/* ensure the group is not already throttled */
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	/* update runtime allocation */
+	account_cfs_rq_runtime(cfs_rq, 0);
+	if (cfs_rq->runtime_remaining <= 0)
+		throttle_cfs_rq(cfs_rq);
 }
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
@@ -1389,6 +1483,14 @@ static int do_sched_cfs_period_timer(str
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 #endif
 
 /**************************************************
@@ -1468,6 +1570,12 @@ enqueue_task_fair(struct rq *rq, struct 
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
 		cfs_rq->h_nr_running++;
+
+		/* end evaluation on throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq)) {
+			se = NULL;
+			break;
+		}
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1475,11 +1583,15 @@ enqueue_task_fair(struct rq *rq, struct 
 		cfs_rq = cfs_rq_of(se);
 		cfs_rq->h_nr_running++;
 
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
-	inc_nr_running(rq);
+	if (!se)
+		inc_nr_running(rq);
 	hrtick_update(rq);
 }
 
@@ -1498,6 +1610,11 @@ static void dequeue_task_fair(struct rq 
 		dequeue_entity(cfs_rq, se, flags);
 		cfs_rq->h_nr_running--;
 
+		/* end evaluation on throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq)) {
+			se = NULL;
+			break;
+		}
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
 			se = parent_entity(se);
@@ -1510,11 +1627,15 @@ static void dequeue_task_fair(struct rq 
 		cfs_rq = cfs_rq_of(se);
 		cfs_rq->h_nr_running--;
 
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
-	dec_nr_running(rq);
+	if (!se)
+		dec_nr_running(rq);
 	hrtick_update(rq);
 }
 
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -258,6 +258,8 @@ struct cfs_bandwidth {
 
 	int idle;
 	struct hrtimer period_timer;
+	struct list_head throttled_cfs_rq;
+
 #endif
 };
 
@@ -392,6 +394,9 @@ struct cfs_rq {
 	int runtime_enabled;
 	u64 runtime_expires;
 	s64 runtime_remaining;
+
+	int throttled;
+	struct list_head throttled_list;
 #endif
 #endif
 };
@@ -433,6 +438,7 @@ static void init_cfs_bandwidth(struct cf
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
 
+	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
 
@@ -442,6 +448,7 @@ static void init_cfs_rq_runtime(struct c
 {
 	cfs_rq->runtime_remaining = 0;
 	cfs_rq->runtime_enabled = 0;
+	INIT_LIST_HEAD(&cfs_rq->throttled_list);
 }
 
 static void start_cfs_bandwidth(struct cfs_rq *cfs_rq)


