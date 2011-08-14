Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1HNQXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:23:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:44438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab1HNQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:23:32 -0400
Date: Sun, 14 Aug 2011 16:23:06 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-58088ad0152ba4b7997388c93d0ca208ec1ece75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184757.277271273@google.com>
References: <20110721184757.277271273@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add a timer to handle CFS bandwidth refresh
Git-Commit-ID: 58088ad0152ba4b7997388c93d0ca208ec1ece75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:23:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58088ad0152ba4b7997388c93d0ca208ec1ece75
Gitweb:     http://git.kernel.org/tip/58088ad0152ba4b7997388c93d0ca208ec1ece75
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:31 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:28 +0200

sched: Add a timer to handle CFS bandwidth refresh

This patch adds a per-task_group timer which handles the refresh of the global
CFS bandwidth pool.

Since the RT pool is using a similar timer there's some small refactoring to
share this support.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.277271273@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |  107 +++++++++++++++++++++++++++++++++++++++++----------
 kernel/sched_fair.c |   40 +++++++++++++++++-
 2 files changed, 123 insertions(+), 24 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 35561c6..34bf8e6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -196,10 +196,28 @@ static inline int rt_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
-	ktime_t now;
+	unsigned long delta;
+	ktime_t soft, hard, now;
 
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
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
@@ -207,22 +225,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
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
 
@@ -253,6 +256,9 @@ struct cfs_bandwidth {
 	ktime_t period;
 	u64 quota, runtime;
 	s64 hierarchal_quota;
+
+	int idle, timer_active;
+	struct hrtimer period_timer;
 #endif
 };
 
@@ -403,6 +409,28 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
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
@@ -410,6 +438,9 @@ static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	cfs_b->runtime = 0;
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
+
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
 }
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
@@ -417,8 +448,34 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
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
@@ -9078,7 +9135,7 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
 
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
-	int i, ret = 0;
+	int i, ret = 0, runtime_enabled;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
 
 	if (tg == &root_task_group)
@@ -9105,10 +9162,18 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
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
@@ -9116,7 +9181,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 		struct rq *rq = rq_of(cfs_rq);
 
 		raw_spin_lock_irq(&rq->lock);
-		cfs_rq->runtime_enabled = quota != RUNTIME_INF;
+		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
 		raw_spin_unlock_irq(&rq->lock);
 	}
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9502aa8..af73a8a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1284,9 +1284,16 @@ static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
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
 
@@ -1315,6 +1322,33 @@ static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
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
