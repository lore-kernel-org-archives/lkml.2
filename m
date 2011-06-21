Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1FUHVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:21:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1FUHVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=T+6rrlTgMMy/Z+QxoM9AwBfxqEeHnk14tCVz/EsbZrQS4SHqgHZiSs79l/TpMumxR
	bThdF1OMfeOudUMxGPBAg==
Message-Id: <20110621071700.395400025@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:16:56 -0700
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
Subject: [patch 07/16] sched: expire invalid runtime
References: <20110621071649.862846205@google.com>
Content-Disposition: inline; filename=sched-bwc-expire_cfs_rq_runtime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 kernel/sched.c      |    6 ++-
 kernel/sched_fair.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 82 insertions(+), 11 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1294,11 +1294,28 @@ static inline u64 sched_cfs_bandwidth_sl
 	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
 }
 
+/*
+ * replenish runtime according to assigned quota and update expiration time
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
+	cfs_b->runtime = cfs_b->quota;
+	now = sched_clock_cpu(smp_processor_id());
+	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
+}
+
 static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
-	u64 amount = 0, min_amount;
+	u64 amount = 0, min_amount, expires;
 
 	/* note: this is a positive sum, runtime_remaining <= 0 */
 	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
@@ -1307,9 +1324,16 @@ static void assign_cfs_rq_runtime(struct
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
@@ -1317,9 +1341,47 @@ static void assign_cfs_rq_runtime(struct
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
+}
+
+static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct rq *rq = rq_of(cfs_rq);
+
+	if (cfs_rq->runtime_remaining < 0)
+		return;
+
+	/* if the deadline is ahead of our clock, nothing to do */
+	if ((s64)(rq->clock - cfs_rq->runtime_expires) < 0)
+		return;
+
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
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
@@ -1328,7 +1390,10 @@ static void account_cfs_rq_runtime(struc
 	if (!cfs_rq->runtime_enabled)
 		return;
 
+	/* dock delta_exec before expiring quota (as it could span periods) */
 	cfs_rq->runtime_remaining -= delta_exec;
+	expire_cfs_rq_runtime(cfs_rq);
+
 	if (cfs_rq->runtime_remaining > 0)
 		return;
 
@@ -1337,17 +1402,19 @@ static void account_cfs_rq_runtime(struc
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	u64 quota, runtime = 0;
 	int idle = 1;
 
 	raw_spin_lock(&cfs_b->lock);
-	quota = cfs_b->quota;
-
-	if (quota != RUNTIME_INF) {
-		runtime = quota;
-		cfs_b->runtime = runtime;
-
+	if (cfs_b->quota != RUNTIME_INF) {
 		idle = cfs_b->idle;
+		/* If we're going idle then defer handle the refill */
+		if (!idle)
+			__refill_cfs_bandwidth_runtime(cfs_b);
+
+		/*
+		 * mark this bandwidth pool as idle so that we may deactivate
+		 * the timer at the next expiration if there is no usage.
+		 */
 		cfs_b->idle = 1;
 	}
 
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -253,6 +253,7 @@ struct cfs_bandwidth {
 	ktime_t period;
 	u64 quota, runtime;
 	s64 hierarchal_quota;
+	u64 runtime_expires;
 
 	int idle, timer_active;
 	struct hrtimer period_timer;
@@ -393,6 +394,7 @@ struct cfs_rq {
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
+	u64 runtime_expires;
 	s64 runtime_remaining;
 #endif
 #endif
@@ -8981,7 +8983,9 @@ static int tg_set_cfs_bandwidth(struct t
 
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
-	cfs_b->quota = quota;
+	cfs_b->quota = cfs_b->runtime = quota;
+
+	__refill_cfs_bandwidth_runtime(cfs_b);
 	raw_spin_unlock_irq(&cfs_b->lock);
 
 	for_each_possible_cpu(i) {


