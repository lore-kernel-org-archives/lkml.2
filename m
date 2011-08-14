Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1HNQ0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:26:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:48074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab1HNQ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:26:44 -0400
Date: Sun, 14 Aug 2011 16:26:21 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-85dac906bec3bb41bfaa7ccaa65c4706de5cfdf8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110721184757.480608533@google.com>
References: <20110721184757.480608533@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add support for throttling group entities
Git-Commit-ID: 85dac906bec3bb41bfaa7ccaa65c4706de5cfdf8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:26:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85dac906bec3bb41bfaa7ccaa65c4706de5cfdf8
Gitweb:     http://git.kernel.org/tip/85dac906bec3bb41bfaa7ccaa65c4706de5cfdf8
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:34 +0200

sched: Add support for throttling group entities

Now that consumption is tracked (via update_curr()) we add support to throttle
group entities (and their corresponding cfs_rqs) in the case where this is no
run-time remaining.

Throttled entities are dequeued to prevent scheduling, additionally we mark
them as throttled (using cfs_rq->throttled) to prevent them from becoming
re-enqueued until they are unthrottled.  A list of a task_group's throttled
entities are maintained on the cfs_bandwidth structure.

Note: While the machinery for throttling is added in this patch the act of
throttling an entity exceeding its bandwidth is deferred until later within
the series.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.480608533@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    7 ++++
 kernel/sched_fair.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a2d5514..044260a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -260,6 +260,8 @@ struct cfs_bandwidth {
 
 	int idle, timer_active;
 	struct hrtimer period_timer;
+	struct list_head throttled_cfs_rq;
+
 #endif
 };
 
@@ -399,6 +401,9 @@ struct cfs_rq {
 	int runtime_enabled;
 	u64 runtime_expires;
 	s64 runtime_remaining;
+
+	int throttled;
+	struct list_head throttled_list;
 #endif
 #endif
 };
@@ -441,6 +446,7 @@ static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
 
+	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
 }
@@ -448,6 +454,7 @@ static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	cfs_rq->runtime_enabled = 0;
+	INIT_LIST_HEAD(&cfs_rq->throttled_list);
 }
 
 /* requires cfs_b->lock, may release to reprogram timer */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9d1adbd..72c9d4e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1291,7 +1291,8 @@ static void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
 }
 
-static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+/* returns 0 on failure to allocate runtime */
+static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
@@ -1332,6 +1333,8 @@ static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	 */
 	if ((s64)(expires - cfs_rq->runtime_expires) > 0)
 		cfs_rq->runtime_expires = expires;
+
+	return cfs_rq->runtime_remaining > 0;
 }
 
 /*
@@ -1378,7 +1381,12 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 	if (likely(cfs_rq->runtime_remaining > 0))
 		return;
 
-	assign_cfs_rq_runtime(cfs_rq);
+	/*
+	 * if we're unable to extend our runtime we resched so that the active
+	 * hierarchy can be throttled
+	 */
+	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
+		resched_task(rq_of(cfs_rq)->curr);
 }
 
 static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
@@ -1390,6 +1398,47 @@ static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttled;
+}
+
+static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
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
+}
+
 /*
  * Responsible for refilling a task_group's bandwidth and unthrottling its
  * cfs_rqs as appropriate. If there has been no activity within the last
@@ -1425,6 +1474,11 @@ out_unlock:
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
@@ -1503,7 +1557,17 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+
+		/*
+		 * end evaluation on encountering a throttled cfs_rq
+		 *
+		 * note: in the case of encountering a throttled cfs_rq we will
+		 * post the final h_nr_running increment below.
+		*/
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		cfs_rq->h_nr_running++;
+
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1511,11 +1575,15 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
 
@@ -1535,6 +1603,15 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
@@ -1557,11 +1634,15 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
 
