Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1FUHVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:21:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42918 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1FUHVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=ux3S8keodQ4iWikH6w9EiMyoq5yupPA8xTXaIBRqOhSgK6+eL+AxpWLLNML2NFNid
	xQnDblwnMZZFO0ScGTWbw==
Message-Id: <20110621071700.599897751@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:16:58 -0700
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
        Nikhil Rao <ncrao@google.com>
Subject: [patch 09/16] sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
References: <20110621071649.862846205@google.com>
Content-Disposition: inline; filename=sched-bwc-unthrottle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of a new period we must refresh the global bandwidth pool as well
as unthrottle any cfs_rq entities who previously ran out of bandwidth (as quota
permits).

Unthrottled entities have the cfs_rq->throttled flag cleared and are re-enqueued
into the entity hierarchy.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c      |    3 +
 kernel/sched_fair.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 121 insertions(+), 7 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -9002,6 +9002,9 @@ static int tg_set_cfs_bandwidth(struct t
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = quota != RUNTIME_INF;
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
@@ -1448,26 +1448,137 @@ static void throttle_cfs_rq(struct cfs_r
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
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	int idle = 1;
+	int idle = 1, throttled = 0;
+	u64 runtime, runtime_expires;
+
 
 	raw_spin_lock(&cfs_b->lock);
 	if (cfs_b->quota != RUNTIME_INF) {
-		idle = cfs_b->idle;
-		/* If we're going idle then defer handle the refill */
+		/* idle depends on !throttled in the case of a large deficit */
+		throttled = !list_empty(&cfs_b->throttled_cfs_rq);
+		idle = cfs_b->idle && !throttled;
+
+		/* If we're going idle then defer the refill */
 		if (!idle)
 			__refill_cfs_bandwidth_runtime(cfs_b);
+		if (throttled) {
+			runtime = cfs_b->runtime;
+			runtime_expires = cfs_b->runtime_expires;
+
+			/* we must first distribute to throttled entities */
+			cfs_b->runtime = 0;
+		}
 
 		/*
-		 * mark this bandwidth pool as idle so that we may deactivate
-		 * the timer at the next expiration if there is no usage.
+		 * conditionally mark this bandwidth pool as idle so that we may
+		 * deactivate the timer at the next expiration if there is no
+		 * usage.
 		 */
-		cfs_b->idle = 1;
+		cfs_b->idle = !throttled;
 	}
 
-	if (idle)
+	if (idle) {
 		cfs_b->timer_active = 0;
+		goto out_unlock;
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+retry:
+	runtime = distribute_cfs_runtime(cfs_b, runtime, runtime_expires);
+
+	raw_spin_lock(&cfs_b->lock);
+	/* new bandwidth specification may exist */
+	if (unlikely(runtime_expires != cfs_b->runtime_expires))
+		goto out_unlock;
+	/* ensure no-one was throttled while we unthrottling */
+	if (unlikely(!list_empty(&cfs_b->throttled_cfs_rq)) && runtime > 0) {
+		raw_spin_unlock(&cfs_b->lock);
+		goto retry;
+	}
+
+	/* return remaining runtime */
+	cfs_b->runtime = runtime;
+out_unlock:
 	raw_spin_unlock(&cfs_b->lock);
 
 	return idle;


