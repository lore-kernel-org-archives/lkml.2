Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1EGGeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:34:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1EGGct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=w2aip0ktpYrT4mbCU+Ene04pF6RwCS5/5Vz3ynz0GNSYtMw7EU2Rby082QsoEfZz/
	8H1qZw72wfnKQZgBd/ouA==
Message-Id: <20110503092905.075386331@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:53 -0700
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
Subject: [patch 07/15] sched: expire invalid runtime
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-expire_cfs_rq_runtime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the global quota pool, one challenge is determining when the runtime we
have received from it is still valid.  Fortunately we can take advantage of
sched_clock synchronization around the jiffy to do this cheaply.

The one catch is that we don't know whether our local clock is behind or ahead
of the cpu setting the expiration time (relative to its own clock).

Fortunately we can detect which of these is the case by determining whether the
global deadline has advanced.  If it has not, then we assume we are behind, and
advance our local expiration; otherwise, we know the deadline has truly passed
and we expire our local runtime.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |    8 +++++++-
 kernel/sched_fair.c |   42 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 4 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1299,7 +1299,7 @@ static void assign_cfs_rq_runtime(struct
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
-	u64 amount = 0, min_amount;
+	u64 amount = 0, min_amount, expires;
 
 	/* note: this is a positive sum, runtime_remaining <= 0 */
 	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
@@ -1312,9 +1312,38 @@ static void assign_cfs_rq_runtime(struct
 		cfs_b->runtime -= amount;
 	}
 	cfs_b->idle = 0;
+	expires = cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
 
 	cfs_rq->runtime_remaining += amount;
+	cfs_rq->runtime_expires = max(cfs_rq->runtime_expires, expires);
+}
+
+static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct rq *rq = rq_of(cfs_rq);
+
+	if (rq->clock < cfs_rq->runtime_expires)
+		return;
+
+	/*
+	 * If the local deadline has passed we have to cover for the
+	 * possibility that our sched_clock is ahead and the global deadline
+	 * has not truly expired.
+	 *
+	 * Fortunately we can check which of these is the case by determining
+	 * whether the global deadline has advanced.
+	 */
+
+	if (cfs_rq->runtime_expires >= cfs_b->runtime_expires) {
+		/* extend local deadline, drift is bounded above by 2 ticks */
+		cfs_rq->runtime_expires += TICK_NSEC;
+	} else {
+		/* global deadline is ahead, deadline must have passed */
+		if (cfs_rq->runtime_remaining > 0)
+			cfs_rq->runtime_remaining = 0;
+	}
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
@@ -1324,6 +1353,9 @@ static void account_cfs_rq_runtime(struc
 		return;
 
 	cfs_rq->runtime_remaining -= delta_exec;
+	/* dock delta_exec before expiring quota (as it could span periods) */
+	expire_cfs_rq_runtime(cfs_rq);
+
 	if (cfs_rq->runtime_remaining > 0)
 		return;
 
@@ -1332,16 +1364,20 @@ static void account_cfs_rq_runtime(struc
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	u64 quota, runtime = 0;
+	u64 quota, runtime = 0, runtime_expires;
 	int idle = 0;
 
+	runtime_expires = sched_clock_cpu(smp_processor_id());
+
 	raw_spin_lock(&cfs_b->lock);
 	quota = cfs_b->quota;
 
 	if (quota != RUNTIME_INF) {
 		runtime = quota;
-		cfs_b->runtime = runtime;
+		runtime_expires += ktime_to_ns(cfs_b->period);
 
+		cfs_b->runtime = runtime;
+		cfs_b->runtime_expires = runtime_expires;
 		idle = cfs_b->idle;
 		cfs_b->idle = 1;
 	}
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -253,6 +253,7 @@ struct cfs_bandwidth {
 	ktime_t period;
 	u64 quota;
 	u64 runtime;
+	u64 runtime_expires;
 	s64 hierarchal_quota;
 
 	int idle;
@@ -389,6 +390,7 @@ struct cfs_rq {
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
+	u64 runtime_expires;
 	s64 runtime_remaining;
 #endif
 #endif
@@ -9242,6 +9244,7 @@ static int tg_set_cfs_bandwidth(struct t
 {
 	int i, ret = 0;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	u64 runtime_expires;
 
 	if (tg == &root_task_group)
 		return -EINVAL;
@@ -9271,7 +9274,9 @@ static int tg_set_cfs_bandwidth(struct t
 
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
-	cfs_b->quota = quota;
+	cfs_b->quota = cfs_b->runtime = quota;
+	runtime_expires = sched_clock_cpu(smp_processor_id()) + period;
+	cfs_b->runtime_expires = runtime_expires;
 	raw_spin_unlock_irq(&cfs_b->lock);
 
 	for_each_possible_cpu(i) {
@@ -9281,6 +9286,7 @@ static int tg_set_cfs_bandwidth(struct t
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = quota != RUNTIME_INF;
 		cfs_rq->runtime_remaining = 0;
+		cfs_rq->runtime_expires = runtime_expires;
 		raw_spin_unlock_irq(&rq->lock);
 	}
 out_unlock:


