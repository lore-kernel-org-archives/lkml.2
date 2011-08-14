Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1HNQjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:39:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:56558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab1HNQjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:39:14 -0400
Date: Sun, 14 Aug 2011 16:39:00 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-d8b4986d3dbc4fabc2054d63f1d31d6ed2fb1ca8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110721184758.306848658@google.com>
References: <20110721184758.306848658@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Return unused runtime on group dequeue
Git-Commit-ID: d8b4986d3dbc4fabc2054d63f1d31d6ed2fb1ca8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:39:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8b4986d3dbc4fabc2054d63f1d31d6ed2fb1ca8
Gitweb:     http://git.kernel.org/tip/d8b4986d3dbc4fabc2054d63f1d31d6ed2fb1ca8
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:41 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:54 +0200

sched: Return unused runtime on group dequeue

When a local cfs_rq blocks we return the majority of its remaining quota to the
global bandwidth pool for use by other runqueues.

We do this only when the quota is current and there is more than
min_cfs_rq_quota [1ms by default] of runtime remaining on the rq.

In the case where there are throttled runqueues and we have sufficient
bandwidth to meter out a slice, a second timer is kicked off to handle this
delivery, unthrottling where appropriate.

Using a 'worst case' antagonist which executes on each cpu
for 1ms before moving onto the next on a fairly large machine:

no quota generations:

 197.47 ms       /cgroup/a/cpuacct.usage
 199.46 ms       /cgroup/a/cpuacct.usage
 205.46 ms       /cgroup/a/cpuacct.usage
 198.46 ms       /cgroup/a/cpuacct.usage
 208.39 ms       /cgroup/a/cpuacct.usage

Since we are allowed to use "stale" quota our usage is effectively bounded by
the rate of input into the global pool and performance is relatively stable.

with quota generations [1s increments]:

 119.58 ms       /cgroup/a/cpuacct.usage
 119.65 ms       /cgroup/a/cpuacct.usage
 119.64 ms       /cgroup/a/cpuacct.usage
 119.63 ms       /cgroup/a/cpuacct.usage
 119.60 ms       /cgroup/a/cpuacct.usage

The large deficit here is due to quota generations (/intentionally/) preventing
us from now using previously stranded slack quota.  The cost is that this quota
becomes unavailable.

with quota generations and quota return:

 200.09 ms       /cgroup/a/cpuacct.usage
 200.09 ms       /cgroup/a/cpuacct.usage
 198.09 ms       /cgroup/a/cpuacct.usage
 200.09 ms       /cgroup/a/cpuacct.usage
 200.06 ms       /cgroup/a/cpuacct.usage

By returning unused quota we're able to both stably consume our desired quota
and prevent unintentional overages due to the abuse of slack quota from
previous quota periods (especially on a large machine).

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184758.306848658@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   15 +++++++-
 kernel/sched_fair.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 35c9185..6baade0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -259,7 +259,7 @@ struct cfs_bandwidth {
 	u64 runtime_expires;
 
 	int idle, timer_active;
-	struct hrtimer period_timer;
+	struct hrtimer period_timer, slack_timer;
 	struct list_head throttled_cfs_rq;
 
 	/* statistics */
@@ -421,6 +421,16 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 
 static inline u64 default_cfs_period(void);
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
+
+static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, slack_timer);
+	do_sched_cfs_slack_timer(cfs_b);
+
+	return HRTIMER_NORESTART;
+}
 
 static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 {
@@ -453,6 +463,8 @@ static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
+	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->slack_timer.function = sched_cfs_slack_timer;
 }
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
@@ -488,6 +500,7 @@ static void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	hrtimer_cancel(&cfs_b->period_timer);
+	hrtimer_cancel(&cfs_b->slack_timer);
 }
 #else
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d201f28..1ca2cd4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1052,6 +1052,8 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__clear_buddies_skip(se);
 }
 
+static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -1090,6 +1092,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
 
+	/* return excess runtime on last dequeue */
+	return_cfs_rq_runtime(cfs_rq);
+
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq);
 }
@@ -1674,6 +1679,108 @@ out_unlock:
 	return idle;
 }
 
+/* a cfs_rq won't donate quota below this amount */
+static const u64 min_cfs_rq_runtime = 1 * NSEC_PER_MSEC;
+/* minimum remaining period time to redistribute slack quota */
+static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
+/* how long we wait to gather additional slack before distributing */
+static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
+
+/* are we near the end of the current quota period? */
+static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
+{
+	struct hrtimer *refresh_timer = &cfs_b->period_timer;
+	u64 remaining;
+
+	/* if the call-back is running a quota refresh is already occurring */
+	if (hrtimer_callback_running(refresh_timer))
+		return 1;
+
+	/* is a quota refresh about to occur? */
+	remaining = ktime_to_ns(hrtimer_expires_remaining(refresh_timer));
+	if (remaining < min_expire)
+		return 1;
+
+	return 0;
+}
+
+static void start_cfs_slack_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	u64 min_left = cfs_bandwidth_slack_period + min_bandwidth_expiration;
+
+	/* if there's a quota refresh soon don't bother with slack */
+	if (runtime_refresh_within(cfs_b, min_left))
+		return;
+
+	start_bandwidth_timer(&cfs_b->slack_timer,
+				ns_to_ktime(cfs_bandwidth_slack_period));
+}
+
+/* we know any runtime found here is valid as update_curr() precedes return */
+static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	s64 slack_runtime = cfs_rq->runtime_remaining - min_cfs_rq_runtime;
+
+	if (slack_runtime <= 0)
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota != RUNTIME_INF &&
+	    cfs_rq->runtime_expires == cfs_b->runtime_expires) {
+		cfs_b->runtime += slack_runtime;
+
+		/* we are under rq->lock, defer unthrottling using a timer */
+		if (cfs_b->runtime > sched_cfs_bandwidth_slice() &&
+		    !list_empty(&cfs_b->throttled_cfs_rq))
+			start_cfs_slack_bandwidth(cfs_b);
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+	/* even if it's not valid for return we don't want to try again */
+	cfs_rq->runtime_remaining -= slack_runtime;
+}
+
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	if (!cfs_rq->runtime_enabled || !cfs_rq->nr_running)
+		return;
+
+	__return_cfs_rq_runtime(cfs_rq);
+}
+
+/*
+ * This is done with a timer (instead of inline with bandwidth return) since
+ * it's necessary to juggle rq->locks to unthrottle their respective cfs_rqs.
+ */
+static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
+{
+	u64 runtime = 0, slice = sched_cfs_bandwidth_slice();
+	u64 expires;
+
+	/* confirm we're still not at a refresh boundary */
+	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
+		runtime = cfs_b->runtime;
+		cfs_b->runtime = 0;
+	}
+	expires = cfs_b->runtime_expires;
+	raw_spin_unlock(&cfs_b->lock);
+
+	if (!runtime)
+		return;
+
+	runtime = distribute_cfs_runtime(cfs_b, runtime, expires);
+
+	raw_spin_lock(&cfs_b->lock);
+	if (expires == cfs_b->runtime_expires)
+		cfs_b->runtime = runtime;
+	raw_spin_unlock(&cfs_b->lock);
+}
+
 /*
  * When a group wakes up we want to make sure that its quota is not already
  * expired/exceeded, otherwise it may be allowed to steal additional ticks of
@@ -1715,6 +1822,7 @@ static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
+static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
