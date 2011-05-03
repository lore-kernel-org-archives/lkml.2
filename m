Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1EGGcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:32:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab1EGGcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=g9b1JJkrbMmIp+ysg3GIg1i0QqTFU3tLElpU3jMjiYn/lBVO2SDBYRl+S+ekxgZGV
	tEcgLos55NscmT5I8dNVw==
Message-Id: <20110503092905.252543642@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:55 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: [patch 09/15] sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-unthrottle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of a new period there are several actions we must refresh the
global bandwidth pool as well as unthrottle any cfs_rq entities who previously
ran out of bandwidth (as quota permits).

Unthrottled entities have the cfs_rq->throttled flag cleared and are re-enqueued
into the cfs entity hierarchy.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |    3 +
 kernel/sched_fair.c |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 1 deletion(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -9294,6 +9294,9 @@ static int tg_set_cfs_bandwidth(struct t
 		cfs_rq->runtime_enabled = quota != RUNTIME_INF;
 		cfs_rq->runtime_remaining = 0;
 		cfs_rq->runtime_expires = runtime_expires;
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
@@ -1456,10 +1456,88 @@ static void check_enqueue_throttle(struc
 		throttle_cfs_rq(cfs_rq);
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
 	u64 quota, runtime = 0, runtime_expires;
-	int idle = 0;
+	int idle = 0, throttled = 0;
 
 	runtime_expires = sched_clock_cpu(smp_processor_id());
 
@@ -1469,6 +1547,7 @@ static int do_sched_cfs_period_timer(str
 	if (quota != RUNTIME_INF) {
 		runtime = quota;
 		runtime_expires += ktime_to_ns(cfs_b->period);
+		throttled = !list_empty(&cfs_b->throttled_cfs_rq);
 
 		cfs_b->runtime = runtime;
 		cfs_b->runtime_expires = runtime_expires;
@@ -1477,6 +1556,30 @@ static int do_sched_cfs_period_timer(str
 	}
 	raw_spin_unlock(&cfs_b->lock);
 
+	if (!throttled || quota == RUNTIME_INF)
+		goto out;
+	idle = 0;
+
+retry:
+	runtime = distribute_cfs_runtime(cfs_b, runtime, runtime_expires);
+
+	raw_spin_lock(&cfs_b->lock);
+	/* new new bandwidth may have been set */
+	if (unlikely(runtime_expires != cfs_b->runtime_expires))
+		goto out_unlock;
+	/*
+	 * make sure no-one was throttled while we were handing out the new
+	 * runtime.
+	 */
+	if (runtime > 0 && !list_empty(&cfs_b->throttled_cfs_rq)) {
+		raw_spin_unlock(&cfs_b->lock);
+		goto retry;
+	}
+	cfs_b->runtime = runtime;
+	cfs_b->idle = idle;
+out_unlock:
+	raw_spin_unlock(&cfs_b->lock);
+out:
 	return idle;
 }
 #else


