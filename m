Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1HNQZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:25:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab1HNQZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:25:04 -0400
Date: Sun, 14 Aug 2011 16:24:40 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-a9cf55b2861057a213e610da2fec52125439a11d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184757.379275352@google.com>
References: <20110721184757.379275352@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Expire invalid runtime
Git-Commit-ID: a9cf55b2861057a213e610da2fec52125439a11d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:24:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9cf55b2861057a213e610da2fec52125439a11d
Gitweb:     http://git.kernel.org/tip/a9cf55b2861057a213e610da2fec52125439a11d
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:32 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:31 +0200

sched: Expire invalid runtime

Since quota is managed using a global state but consumed on a per-cpu basis
we need to ensure that our per-cpu state is appropriately synchronized.
Most importantly, runtime that is state (from a previous period) should not be
locally consumable.

We take advantage of existing sched_clock synchronization about the jiffy to
efficiently detect whether we have (globally) crossed a quota boundary above.

One catch is that the direction of spread on sched_clock is undefined,
specifically, we don't know whether our local clock is behind or ahead
of the one responsible for the current expiration time.

Fortunately we can differentiate these by considering whether the
global deadline has advanced.  If it has not, then we assume our clock to be
"fast" and advance our local expiration; otherwise, we know the deadline has
truly passed and we expire our local runtime.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.379275352@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    4 ++-
 kernel/sched_fair.c |   90 +++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 34bf8e6..a2d5514 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -256,6 +256,7 @@ struct cfs_bandwidth {
 	ktime_t period;
 	u64 quota, runtime;
 	s64 hierarchal_quota;
+	u64 runtime_expires;
 
 	int idle, timer_active;
 	struct hrtimer period_timer;
@@ -396,6 +397,7 @@ struct cfs_rq {
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
+	u64 runtime_expires;
 	s64 runtime_remaining;
 #endif
 #endif
@@ -9166,8 +9168,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
-	cfs_b->runtime = quota;
 
+	__refill_cfs_bandwidth_runtime(cfs_b);
 	/* restart the period timer (if active) to handle new period expiry */
 	if (runtime_enabled && cfs_b->timer_active) {
 		/* force a reprogram */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index af73a8a..9d1adbd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1272,11 +1272,30 @@ static inline u64 sched_cfs_bandwidth_slice(void)
 	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
 }
 
+/*
+ * Replenish runtime according to assigned quota and update expiration time.
+ * We use sched_clock_cpu directly instead of rq->clock to avoid adding
+ * additional synchronization around rq->lock.
+ *
+ * requires cfs_b->lock
+ */
+static void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
+{
+	u64 now;
+
+	if (cfs_b->quota == RUNTIME_INF)
+		return;
+
+	now = sched_clock_cpu(smp_processor_id());
+	cfs_b->runtime = cfs_b->quota;
+	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
+}
+
 static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
-	u64 amount = 0, min_amount;
+	u64 amount = 0, min_amount, expires;
 
 	/* note: this is a positive sum as runtime_remaining <= 0 */
 	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
@@ -1285,9 +1304,16 @@ static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	if (cfs_b->quota == RUNTIME_INF)
 		amount = min_amount;
 	else {
-		/* ensure bandwidth timer remains active under consumption */
-		if (!cfs_b->timer_active)
+		/*
+		 * If the bandwidth pool has become inactive, then at least one
+		 * period must have elapsed since the last consumption.
+		 * Refresh the global state and ensure bandwidth timer becomes
+		 * active.
+		 */
+		if (!cfs_b->timer_active) {
+			__refill_cfs_bandwidth_runtime(cfs_b);
 			__start_cfs_bandwidth(cfs_b);
+		}
 
 		if (cfs_b->runtime > 0) {
 			amount = min(cfs_b->runtime, min_amount);
@@ -1295,19 +1321,61 @@ static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 			cfs_b->idle = 0;
 		}
 	}
+	expires = cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
 
 	cfs_rq->runtime_remaining += amount;
+	/*
+	 * we may have advanced our local expiration to account for allowed
+	 * spread between our sched_clock and the one on which runtime was
+	 * issued.
+	 */
+	if ((s64)(expires - cfs_rq->runtime_expires) > 0)
+		cfs_rq->runtime_expires = expires;
 }
 
-static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec)
+/*
+ * Note: This depends on the synchronization provided by sched_clock and the
+ * fact that rq->clock snapshots this value.
+ */
+static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_rq->runtime_enabled)
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct rq *rq = rq_of(cfs_rq);
+
+	/* if the deadline is ahead of our clock, nothing to do */
+	if (likely((s64)(rq->clock - cfs_rq->runtime_expires) < 0))
+		return;
+
+	if (cfs_rq->runtime_remaining < 0)
 		return;
 
+	/*
+	 * If the local deadline has passed we have to consider the
+	 * possibility that our sched_clock is 'fast' and the global deadline
+	 * has not truly expired.
+	 *
+	 * Fortunately we can check determine whether this the case by checking
+	 * whether the global deadline has advanced.
+	 */
+
+	if ((s64)(cfs_rq->runtime_expires - cfs_b->runtime_expires) >= 0) {
+		/* extend local deadline, drift is bounded above by 2 ticks */
+		cfs_rq->runtime_expires += TICK_NSEC;
+	} else {
+		/* global deadline is ahead, expiration has passed */
+		cfs_rq->runtime_remaining = 0;
+	}
+}
+
+static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				     unsigned long delta_exec)
+{
+	/* dock delta_exec before expiring quota (as it could span periods) */
 	cfs_rq->runtime_remaining -= delta_exec;
-	if (cfs_rq->runtime_remaining > 0)
+	expire_cfs_rq_runtime(cfs_rq);
+
+	if (likely(cfs_rq->runtime_remaining > 0))
 		return;
 
 	assign_cfs_rq_runtime(cfs_rq);
@@ -1338,7 +1406,12 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 		goto out_unlock;
 
 	idle = cfs_b->idle;
-	cfs_b->runtime = cfs_b->quota;
+	/* if we're going inactive then everything else can be deferred */
+	if (idle)
+		goto out_unlock;
+
+	__refill_cfs_bandwidth_runtime(cfs_b);
+
 
 	/* mark as potentially idle for the upcoming period */
 	cfs_b->idle = 1;
@@ -1557,7 +1630,6 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 
 	return wl;
 }
-
 #else
 
 static inline unsigned long effective_load(struct task_group *tg, int cpu,
