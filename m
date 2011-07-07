Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1GGFd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:33:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1GGFdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=dFkBQOvmX6SIRmwuQSZ/ZxxwdfiVNPE1fShyt/zy48Pjy5gB7JX5pApJbXi1qEUMP
	mprob0BcHLoQ84HcWz02w==
Message-Id: <20110707053100.545442047@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:45 -0700
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
Subject: [patch 09/17] sched: add support for unthrottling group entities
References: <20110707053036.173186930@google.com>
Content-Disposition: inline; filename=sched-bwc-unthrottle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of each period we refresh the global bandwidth pool.  At this time
we must also unthrottle any cfs_rq entities who are now within bandwidth once 
more (as quota permits).

Unthrottled entities have their corresponding cfs_rq->throttled flag cleared
and their entities re-enqueued.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c      |    3 +
 kernel/sched_fair.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 127 insertions(+), 4 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -9005,6 +9005,9 @@ static int tg_set_cfs_bandwidth(struct t
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
+
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
 out_unlock:
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1455,6 +1455,84 @@ static void throttle_cfs_rq(struct cfs_r
 	raw_spin_unlock(&cfs_b->lock);
 }
 
+static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct sched_entity *se;
+	int enqueue = 1;
+	long task_delta;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	cfs_rq->throttled = 0;
+	raw_spin_lock(&cfs_b->lock);
+	list_del_rcu(&cfs_rq->throttled_list);
+	raw_spin_unlock(&cfs_b->lock);
+
+	if (!cfs_rq->load.weight)
+		return;
+
+	task_delta = cfs_rq->h_nr_running;
+	for_each_sched_entity(se) {
+		if (se->on_rq)
+			enqueue = 0;
+
+		cfs_rq = cfs_rq_of(se);
+		if (enqueue)
+			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+		cfs_rq->h_nr_running += task_delta;
+
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+	}
+
+	if (!se)
+		rq->nr_running += task_delta;
+
+	/* determine whether we need to wake up potentially idle cpu */
+	if (rq->curr == rq->idle && rq->cfs.nr_running)
+		resched_task(rq->curr);
+}
+
+static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
+		u64 remaining, u64 expires)
+{
+	struct cfs_rq *cfs_rq;
+	u64 runtime = remaining;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(cfs_rq, &cfs_b->throttled_cfs_rq,
+				throttled_list) {
+		struct rq *rq = rq_of(cfs_rq);
+
+		raw_spin_lock(&rq->lock);
+		if (!cfs_rq_throttled(cfs_rq))
+			goto next;
+
+		runtime = -cfs_rq->runtime_remaining + 1;
+		if (runtime > remaining)
+			runtime = remaining;
+		remaining -= runtime;
+
+		cfs_rq->runtime_remaining += runtime;
+		cfs_rq->runtime_expires = expires;
+
+		/* we check whether we're throttled above */
+		if (cfs_rq->runtime_remaining > 0)
+			unthrottle_cfs_rq(cfs_rq);
+
+next:
+		raw_spin_unlock(&rq->lock);
+
+		if (!remaining)
+			break;
+	}
+	rcu_read_unlock();
+
+	return remaining;
+}
+
 /*
  * Responsible for refilling a task_group's bandwidth and unthrottling its
  * cfs_rqs as appropriate. If there has been no activity within the last
@@ -1463,22 +1541,64 @@ static void throttle_cfs_rq(struct cfs_r
  */
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	int idle = 1;
+	u64 runtime, runtime_expires;
+	int idle = 1, throttled;
 
 	raw_spin_lock(&cfs_b->lock);
 	/* no need to continue the timer with no bandwidth constraint */
 	if (cfs_b->quota == RUNTIME_INF)
 		goto out_unlock;
 
-	idle = cfs_b->idle;
+	throttled = !list_empty(&cfs_b->throttled_cfs_rq);
+	/* idle depends on !throttled (for the case of a large deficit) */
+	idle = cfs_b->idle && !throttled;
+
 	/* if we're going inactive then everything else can be deferred */
 	if (idle)
 		goto out_unlock;
 
 	__refill_cfs_bandwidth_runtime(cfs_b);
 
-	/* mark as potentially idle for the upcoming period */
-	cfs_b->idle = 1;
+	if (!throttled) {
+		/* mark as potentially idle for the upcoming period */
+		cfs_b->idle = 1;
+		goto out_unlock;
+	}
+
+	/*
+	 * There are throttled entities so we must first use the new bandwidth
+	 * to unthrottle them before making it generally available.  This
+	 * ensures that all existing debts will be paid before a new cfs_rq is
+	 * allowed to run.
+	 */
+	runtime = cfs_b->runtime;
+	runtime_expires = cfs_b->runtime_expires;
+	cfs_b->runtime = 0;
+
+	/*
+	 * This check is repeated as we are holding onto the new bandwidth
+	 * while we unthrottle.  This can potentially race with an unthrottled
+	 * group trying to acquire new bandwidth from the global pool.
+	 */
+	while (throttled && runtime > 0) {
+		raw_spin_unlock(&cfs_b->lock);
+		/* we can't nest cfs_b->lock while distributing bandwidth */
+		runtime = distribute_cfs_runtime(cfs_b, runtime,
+						 runtime_expires);
+		raw_spin_lock(&cfs_b->lock);
+
+		throttled = !list_empty(&cfs_b->throttled_cfs_rq);
+	}
+
+	/* return (any) remaining runtime */
+	cfs_b->runtime = runtime;
+	/*
+	 * While we are ensured activity in the period following an
+	 * unthrottle, this also covers the case in which the new bandwidth is
+	 * insufficient to cover the existing bandwidth deficit.  (Forcing the
+	 * timer to remain active while there are any throttled entities.)
+	 */
+	cfs_b->idle = 0;
 out_unlock:
 	if (idle)
 		cfs_b->timer_active = 0;


