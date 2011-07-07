Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1GGFem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:34:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab1GGFdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=YvMV0bQfoHYI0C4Y5abT8S6jPDeb9mrAyTAx/5ppSYmN52Kxb5qnxTjK2l1UEoLIX
	R4kmUKduMmtUs00MFGAQw==
Message-Id: <20110707053100.263292626@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:42 -0700
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
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 06/17] sched: add a timer to handle CFS bandwidth refresh
References: <20110707053036.173186930@google.com>
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
 kernel/sched.c      |  107 +++++++++++++++++++++++++++++++++++++++++-----------
 kernel/sched_fair.c |   41 ++++++++++++++++++-
 2 files changed, 124 insertions(+), 24 deletions(-)

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
@@ -413,8 +444,34 @@ static void init_cfs_rq_runtime(struct c
 	cfs_rq->runtime_enabled = 0;
 }
 
+/* requires cfs_b->lock, may release to reprogram timer */
+static void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	/*
+	 * The timer may be active because we're trying to set a new bandwidth
+	 * period or because we're racing with the tear-down path
+	 * (timer_active==0 becomes visible before the hrtimer call-back
+	 * terminates).  In either case we ensure that it's re-programmed
+	 */
+	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
+		raw_spin_unlock(&cfs_b->lock);
+		/* ensure cfs_b->lock is available while we wait */
+		hrtimer_cancel(&cfs_b->period_timer);
+
+		raw_spin_lock(&cfs_b->lock);
+		/* if someone else restarted the timer then we're done */
+		if (cfs_b->timer_active)
+			return;
+	}
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
@@ -8891,7 +8948,7 @@ static int __cfs_schedulable(struct task
 
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
-	int i, ret = 0;
+	int i, ret = 0, runtime_enabled;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
 
 	if (tg == &root_task_group)
@@ -8918,10 +8975,18 @@ static int tg_set_cfs_bandwidth(struct t
 	if (ret)
 		goto out_unlock;
 
+	runtime_enabled = quota != RUNTIME_INF;
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
 	cfs_b->runtime = quota;
+
+	/* restart the period timer (if active) to handle new period expiry */
+	if (runtime_enabled && cfs_b->timer_active) {
+		/* force a reprogram */
+		cfs_b->timer_active = 0;
+		__start_cfs_bandwidth(cfs_b);
+	}
 	raw_spin_unlock_irq(&cfs_b->lock);
 
 	for_each_possible_cpu(i) {
@@ -8929,7 +8994,7 @@ static int tg_set_cfs_bandwidth(struct t
 		struct rq *rq = rq_of(cfs_rq);
 
 		raw_spin_lock_irq(&rq->lock);
-		cfs_rq->runtime_enabled = quota != RUNTIME_INF;
+		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
 		raw_spin_unlock_irq(&rq->lock);
 	}
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
 
@@ -1327,6 +1334,34 @@ static void account_cfs_rq_runtime(struc
 
 	assign_cfs_rq_runtime(cfs_rq);
 }
+
+/*
+ * Responsible for refilling a task_group's bandwidth and unthrottling its
+ * cfs_rqs as appropriate. If there has been no activity within the last
+ * period the timer is deactivated until scheduling resumes; cfs_b->idle is
+ * used to track this state.
+ */
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+{
+	int idle = 1;
+
+	raw_spin_lock(&cfs_b->lock);
+	/* no need to continue the timer with no bandwidth constraint */
+	if (cfs_b->quota == RUNTIME_INF)
+		goto out_unlock;
+
+	idle = cfs_b->idle;
+	cfs_b->runtime = cfs_b->quota;
+
+	/* mark as potentially idle for the upcoming period */
+	cfs_b->idle = 1;
+out_unlock:
+	if (idle)
+		cfs_b->timer_active = 0;
+	raw_spin_unlock(&cfs_b->lock);
+
+	return idle;
+}
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}


