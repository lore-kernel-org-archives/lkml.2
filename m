Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1FUH0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:26:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1FUHVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=n9oqZSOD4ayRGISXGzOaFs5XIk5NB+Py1BaZA1xLwHGWyYjwB0Dbfk0EjdE726Xyo
	Vmj/sOB+fUd/ljqJRAidw==
Message-Id: <20110621071700.494088365@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:16:57 -0700
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
        Nikhil Rao <ncrao@google.com>
Subject: [patch 08/16] sched: throttle cfs_rq entities which exceed their local runtime
References: <20110621071649.862846205@google.com>
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
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c      |    7 ++++
 kernel/sched_fair.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 4 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1311,7 +1311,8 @@ static void __refill_cfs_bandwidth_runti
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
 }
 
-static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+/* returns 0 on failure to allocate runtime */
+static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
@@ -1352,6 +1353,8 @@ static void assign_cfs_rq_runtime(struct
 	 */
 	if ((s64)(expires - cfs_rq->runtime_expires) > 0)
 		cfs_rq->runtime_expires = expires;
+
+	return cfs_rq->runtime_remaining > 0;
 }
 
 static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
@@ -1397,7 +1400,53 @@ static void account_cfs_rq_runtime(struc
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
+	task_delta = cfs_rq->h_nr_running;
+	for_each_sched_entity(se) {
+		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
+		/* throttled entity or throttle-on-deactivate */
+		if (!se->on_rq)
+			break;
+
+		if (dequeue)
+			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
+		qcfs_rq->h_nr_running -= task_delta;
+
+		if (qcfs_rq->load.weight)
+			dequeue = 0;
+	}
+
+	if (!se)
+		rq->nr_running -= task_delta;
+
+	cfs_rq->throttled = 1;
+	raw_spin_lock(&cfs_b->lock);
+	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	raw_spin_unlock(&cfs_b->lock);
 }
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
@@ -1427,6 +1476,11 @@ static int do_sched_cfs_period_timer(str
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
 #endif
 
 /**************************************************
@@ -1505,7 +1559,17 @@ enqueue_task_fair(struct rq *rq, struct 
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+
+		/*
+		 * end evaluation on encountering a throttled cfs_rq
+		 *
+		 * note: in the case of encountering a throttled cfs_rq we will
+		 * post the final h_nr_running decrement below.
+		*/
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		cfs_rq->h_nr_running++;
+
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1513,11 +1577,15 @@ enqueue_task_fair(struct rq *rq, struct 
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
 
@@ -1537,6 +1605,15 @@ static void dequeue_task_fair(struct rq 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
+
+		/*
+		 * end evaluation on encountering a throttled cfs_rq
+		 *
+		 * note: in the case of encountering a throttled cfs_rq we will
+		 * post the final h_nr_running decrement below.
+		*/
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		cfs_rq->h_nr_running--;
 
 		/* Don't dequeue parent if it has other entities besides us */
@@ -1559,11 +1636,15 @@ static void dequeue_task_fair(struct rq 
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
@@ -257,6 +257,8 @@ struct cfs_bandwidth {
 
 	int idle, timer_active;
 	struct hrtimer period_timer;
+	struct list_head throttled_cfs_rq;
+
 #endif
 };
 
@@ -396,6 +398,9 @@ struct cfs_rq {
 	int runtime_enabled;
 	u64 runtime_expires;
 	s64 runtime_remaining;
+
+	int throttled;
+	struct list_head throttled_list;
 #endif
 #endif
 };
@@ -437,6 +442,7 @@ static void init_cfs_bandwidth(struct cf
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
 
+	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
 }
@@ -444,6 +450,7 @@ static void init_cfs_bandwidth(struct cf
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	cfs_rq->runtime_enabled = 0;
+	INIT_LIST_HEAD(&cfs_rq->throttled_list);
 }
 
 /* requires cfs_b->lock */


