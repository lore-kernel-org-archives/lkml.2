Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1FUHYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:24:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab1FUHVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=MzRxOoovy2j2Qlyv4eDBSQeRjARMhfK4XfjkPWKf+lV/KAniWjXsB0YVVTCq718pT
	SrLy/8JMX1aroFw6hEX/g==
Message-Id: <20110621071700.284687900@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:16:55 -0700
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
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 06/16] sched: add a timer to handle CFS bandwidth refresh
References: <20110621071649.862846205@google.com>
Content-Disposition: inline; filename=sched-bwc-bandwidth_timers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a per-task_group timer which handles the refresh of the global
CFS bandwidth pool.

Since the RT pool is using a similar timer there's some small refactoring to
share this support.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c      |   87 ++++++++++++++++++++++++++++++++++++++++------------
 kernel/sched_fair.c |   36 +++++++++++++++++++--
 2 files changed, 101 insertions(+), 22 deletions(-)

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
+
+		soft = hrtimer_get_softexpires(period_timer);
+		hard = hrtimer_get_expires(period_timer);
+		delta = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(period_timer, soft, delta,
+					 HRTIMER_MODE_ABS_PINNED, 0);
+	}
+}
 
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
 	u64 quota, runtime;
 	s64 hierarchal_quota;
+
+	int idle, timer_active;
+	struct hrtimer period_timer;
 #endif
 };
 
@@ -399,6 +405,28 @@ static inline struct cfs_bandwidth *tg_c
 }
 
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
@@ -406,6 +434,9 @@ static void init_cfs_bandwidth(struct cf
 	cfs_b->runtime = 0;
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
+
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
 }
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
@@ -413,8 +444,26 @@ static void init_cfs_rq_runtime(struct c
 	cfs_rq->runtime_enabled = 0;
 }
 
+/* requires cfs_b->lock */
+static void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	/*
+	 * Handle the extremely unlikely case of trying to start the period
+	 * timer, while that timer is in the tear-down path from having
+	 * decided to no longer run.  In this case we must wait for the
+	 * (tail of the) callback to terminate so that we can re-enqueue it.
+	 */
+	if (unlikely(hrtimer_active(&cfs_b->period_timer)))
+		hrtimer_cancel(&cfs_b->period_timer);
+
+	cfs_b->timer_active = 1;
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+}
+
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{}
+{
+	hrtimer_cancel(&cfs_b->period_timer);
+}
 #else
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1306,9 +1306,16 @@ static void assign_cfs_rq_runtime(struct
 	raw_spin_lock(&cfs_b->lock);
 	if (cfs_b->quota == RUNTIME_INF)
 		amount = min_amount;
-	else if (cfs_b->runtime > 0) {
-		amount = min(cfs_b->runtime, min_amount);
-		cfs_b->runtime -= amount;
+	else {
+		/* ensure bandwidth timer remains active under consumption */
+		if (!cfs_b->timer_active)
+			__start_cfs_bandwidth(cfs_b);
+
+		if (cfs_b->runtime > 0) {
+			amount = min(cfs_b->runtime, min_amount);
+			cfs_b->runtime -= amount;
+			cfs_b->idle = 0;
+		}
 	}
 	raw_spin_unlock(&cfs_b->lock);
 
@@ -1327,6 +1334,29 @@ static void account_cfs_rq_runtime(struc
 
 	assign_cfs_rq_runtime(cfs_rq);
 }
+
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+{
+	u64 quota, runtime = 0;
+	int idle = 1;
+
+	raw_spin_lock(&cfs_b->lock);
+	quota = cfs_b->quota;
+
+	if (quota != RUNTIME_INF) {
+		runtime = quota;
+		cfs_b->runtime = runtime;
+
+		idle = cfs_b->idle;
+		cfs_b->idle = 1;
+	}
+
+	if (idle)
+		cfs_b->timer_active = 0;
+	raw_spin_unlock(&cfs_b->lock);
+
+	return idle;
+}
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}


