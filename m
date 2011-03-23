Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1CWDKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1CWDKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=AdW+7XTF0K9wd4Niz1PqB93KENZ8U7u9eFHB+btpL585NQJt5yxNws12Xz63IV5ay
	5wLVfScwYb5v/pXz7sPJw==
Message-Id: <20110323030449.941304760@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:39 -0700
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
Subject: [patch 13/15] sched: expire slack quota using generation counters
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-add_quota_generations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a generational counter which is incremented each quota period.  This
allows us to determine on a per-cpu basis whether the currently operating quota
is "current" or not, without requiring us to visit every cpu and explicitly
expire quota on every new period.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

---
 kernel/sched.c      |    6 ++++++
 kernel/sched_fair.c |   42 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 43 insertions(+), 5 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -256,6 +256,7 @@ struct cfs_bandwidth {
 	s64 hierarchal_quota; /* used for validating consistency */
 	struct hrtimer period_timer;
 
+	int quota_generation;
 	struct list_head throttled_cfs_rq;
 	/* throttle statistics */
 	u64			nr_periods;
@@ -396,6 +397,7 @@ struct cfs_rq {
 	s64 quota_remaining;
 	u64 throttled_timestamp;
 
+	int quota_generation;
 	struct list_head throttled_list;
 #endif
 #endif
@@ -436,8 +438,10 @@ void init_cfs_bandwidth(struct cfs_bandw
 	raw_spin_lock_init(&cfs_b->lock);
 	cfs_b->quota = cfs_b->runtime = quota;
 	cfs_b->period = ns_to_ktime(period);
+	cfs_b->quota_generation = 0;
 	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 
+
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
 
@@ -9333,6 +9337,8 @@ static int tg_set_cfs_bandwidth(struct t
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->runtime = cfs_b->quota = quota;
+
+	cfs_bump_quota_generation(cfs_b);
 	raw_spin_unlock_irq(&cfs_b->lock);
 
 	for_each_possible_cpu(i) {
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1331,11 +1331,25 @@ static void check_cfs_rq_quota(struct cf
 	resched_task(rq_of(cfs_rq)->curr);
 }
 
+static void cfs_bump_quota_generation(struct cfs_bandwidth *cfs_b)
+{
+	cfs_b->quota_generation++;
+	smp_mb();
+}
+
+static inline int cfs_rq_quota_current(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+
+	return cfs_rq->quota_generation == cfs_b->quota_generation;
+}
+
 static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
 	u64 amount = 0, min_amount;
+	int generation;
 
 	min_amount = sched_cfs_bandwidth_slice() + (-cfs_rq->quota_remaining);
 
@@ -1347,10 +1361,18 @@ static void request_cfs_rq_quota(struct 
 		} else {
 			amount = min_amount;
 		}
+		generation = cfs_b->quota_generation;
 		raw_spin_unlock(&cfs_b->lock);
 	}
 
+	/* a deficit should be carried forwards, surplus should be dropped */
+
+	if (generation != cfs_rq->quota_generation &&
+	    cfs_rq->quota_remaining > 0)
+		cfs_rq->quota_remaining = 0;
+
 	cfs_rq->quota_remaining += amount;
+	cfs_rq->quota_generation = generation;
 }
 
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
@@ -1361,8 +1383,13 @@ static void account_cfs_rq_quota(struct 
 
 	cfs_rq->quota_remaining -= delta_exec;
 
-	if (cfs_rq->quota_remaining > 0)
-		return;
+	/* we only want to charge deficits against the next generation */
+	if (likely(cfs_rq->quota_remaining > 0)) {
+		if (unlikely(!cfs_rq_quota_current(cfs_rq)))
+			cfs_rq->quota_remaining = 0;
+		else
+			return;
+	}
 
 	request_cfs_rq_quota(cfs_rq);
 }
@@ -1492,7 +1519,8 @@ static void unthrottle_cfs_rq(struct cfs
 		resched_task(rq->curr);
 }
 
-static u64 distribute_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 runtime)
+static u64 distribute_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 runtime,
+		int generation)
 {
 	struct cfs_rq *cfs_rq;
 	u64 quota, remaining = runtime;
@@ -1512,6 +1540,7 @@ static u64 distribute_cfs_bandwidth(stru
 		remaining -= quota;
 
 		cfs_rq->quota_remaining += quota;
+		cfs_rq->quota_generation = generation;
 		if (cfs_rq_throttled(cfs_rq) && cfs_rq->quota_remaining > 0)
 			unthrottle_cfs_rq(cfs_rq);
 
@@ -1529,12 +1558,15 @@ next:
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
 	u64 runtime, runtime_assigned;
-	int idle, throttled;
+	int idle, throttled, generation;
 
 	raw_spin_lock(&cfs_b->lock);
 	runtime = cfs_b->quota;
 	idle = cfs_b->runtime == cfs_b->runtime_assigned;
 	throttled = cfs_b->runtime == 0;
+
+	cfs_bump_quota_generation(cfs_b);
+	generation = cfs_b->quota_generation;
 	raw_spin_unlock(&cfs_b->lock);
 
 	if (runtime == RUNTIME_INF)
@@ -1543,7 +1575,7 @@ static int do_sched_cfs_period_timer(str
 	runtime *= overrun;
 	runtime_assigned = runtime;
 
-	runtime = distribute_cfs_bandwidth(cfs_b, runtime);
+	runtime = distribute_cfs_bandwidth(cfs_b, runtime, generation);
 
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->runtime = runtime;


