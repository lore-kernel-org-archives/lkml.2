Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1EGGc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:32:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1EGGcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=LngCwS/JCQU2HxfmXxr3QFVSWZ7Mo9oGRt7OGjhOMpA9TxgUW3029U4mcxfx7Yumy
	GzqYQTatI+vKbiKN3V0+w==
Message-Id: <20110503092904.895444153@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:51 -0700
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
Subject: [patch 05/15] sched: add a timer to handle CFS bandwidth refresh
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-bandwidth_timers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a per-task_group timer which handles the refresh of the global
CFS bandwidth pool.

Since the RT pool is using a similar timer there's some small refactoring to
share this support.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |   87 ++++++++++++++++++++++++++++++++++++++++------------
 kernel/sched_fair.c |    9 +++++
 2 files changed, 77 insertions(+), 19 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -193,10 +193,28 @@ static inline int rt_bandwidth_enabled(v
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
-	ktime_t now;
+	unsigned long delta;
+	ktime_t soft, hard, now;
+
+	for (;;) {
+		if (hrtimer_active(period_timer))
+			break;
+
+		now = hrtimer_cb_get_time(period_timer);
+		hrtimer_forward(period_timer, now, period);
 
+		soft = hrtimer_get_softexpires(period_timer);
+		hard = hrtimer_get_expires(period_timer);
+		delta = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(period_timer, soft, delta,
+					 HRTIMER_MODE_ABS_PINNED, 0);
+	}
+}
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
@@ -204,22 +222,7 @@ static void start_rt_bandwidth(struct rt
 		return;
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
-	for (;;) {
-		unsigned long delta;
-		ktime_t soft, hard;
-
-		if (hrtimer_active(&rt_b->rt_period_timer))
-			break;
-
-		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
-		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-
-		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
-		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
-		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
-				HRTIMER_MODE_ABS_PINNED, 0);
-	}
+	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
@@ -250,6 +253,9 @@ struct cfs_bandwidth {
 	ktime_t period;
 	u64 quota;
 	s64 hierarchal_quota;
+
+	int idle;
+	struct hrtimer period_timer;
 #endif
 };
 
@@ -394,12 +400,38 @@ static inline struct cfs_bandwidth *tg_c
 
 #ifdef CONFIG_CFS_BANDWIDTH
 static inline u64 default_cfs_period(void);
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, cfs_b->period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_cfs_period_timer(cfs_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
 
 static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	raw_spin_lock_init(&cfs_b->lock);
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
+
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
+
 }
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
@@ -411,8 +443,25 @@ static void init_cfs_rq_runtime(struct c
 		cfs_rq->runtime_enabled = 1;
 }
 
+static void start_cfs_bandwidth(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+
+	if (cfs_b->quota == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&cfs_b->period_timer))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+	raw_spin_unlock(&cfs_b->lock);
+}
+
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{}
+{
+	hrtimer_cancel(&cfs_b->period_timer);
+}
 #else
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1003,6 +1003,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 
 	if (cfs_rq->nr_running == 1)
 		list_add_leaf_cfs_rq(cfs_rq);
+
+	start_cfs_bandwidth(cfs_rq);
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -1220,6 +1222,8 @@ static void put_prev_entity(struct cfs_r
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
+
+		start_cfs_bandwidth(cfs_rq);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -1272,6 +1276,11 @@ static inline u64 default_cfs_period(voi
 {
 	return 500000000ULL;
 }
+
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+{
+	return 1;
+}
 #endif
 
 /**************************************************


