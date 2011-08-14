Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1HNQ2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:48455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab1HNQ2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:28:04 -0400
Date: Sun, 14 Aug 2011 16:27:40 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-671fd9dabe5239ad218c7eb48b2b9edee50250e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184757.574628950@google.com>
References: <20110721184757.574628950@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add support for unthrottling group entities
Git-Commit-ID: 671fd9dabe5239ad218c7eb48b2b9edee50250e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:27:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  671fd9dabe5239ad218c7eb48b2b9edee50250e6
Gitweb:     http://git.kernel.org/tip/671fd9dabe5239ad218c7eb48b2b9edee50250e6
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:34 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:36 +0200

sched: Add support for unthrottling group entities

At the start of each period we refresh the global bandwidth pool.  At this time
we must also unthrottle any cfs_rq entities who are now within bandwidth once
more (as quota permits).

Unthrottled entities have their corresponding cfs_rq->throttled flag cleared
and their entities re-enqueued.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.574628950@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    3 +
 kernel/sched_fair.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 044260a..4bbabc2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9192,6 +9192,9 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
+
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
 out_unlock:
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 72c9d4e..7641195 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1439,6 +1439,84 @@ static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
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
@@ -1447,23 +1525,64 @@ static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
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
 
-	/* mark as potentially idle for the upcoming period */
-	cfs_b->idle = 1;
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
