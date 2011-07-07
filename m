Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1GGFdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:33:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1GGFdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=JTuKoDZnQwCwM41HDejKX1HE8vdzj2xLva0p1uJuW/yezQIJtuORJa8sKqqmZZhh6
	CYSd11CSPUP2T2pitdE6Q==
Message-Id: <20110707053101.202705000@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:52 -0700
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
Subject: [patch 16/17] sched: return unused runtime on group dequeue
References: <20110707053036.173186930@google.com>
Content-Disposition: inline; filename=sched-bwc-simple_return_quota.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 kernel/sched.c      |   15 ++++++-
 kernel/sched_fair.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 1 deletion(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -256,7 +256,7 @@ struct cfs_bandwidth {
 	u64 runtime_expires;
 
 	int idle, timer_active;
-	struct hrtimer period_timer;
+	struct hrtimer period_timer, slack_timer;
 	struct list_head throttled_cfs_rq;
 
 	/* statistics */
@@ -417,6 +417,16 @@ static inline struct cfs_bandwidth *tg_c
 
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
@@ -449,6 +459,8 @@ static void init_cfs_bandwidth(struct cf
 	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
+	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->slack_timer.function = sched_cfs_slack_timer;
 }
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
@@ -484,6 +496,7 @@ static void __start_cfs_bandwidth(struct
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	hrtimer_cancel(&cfs_b->period_timer);
+	hrtimer_cancel(&cfs_b->slack_timer);
 }
 #else
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1071,6 +1071,8 @@ static void clear_buddies(struct cfs_rq 
 		__clear_buddies_skip(se);
 }
 
+static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -1109,6 +1111,10 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
 
+	/* return excess runtime on last dequeue */
+	if (!cfs_rq->nr_running)
+		return_cfs_rq_runtime(cfs_rq);
+
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq);
 }
@@ -1724,11 +1730,110 @@ out_unlock:
 
 	return idle;
 }
+
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
+static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	s64 slack_runtime = cfs_rq->runtime_remaining - min_cfs_rq_runtime;
+
+	if (!cfs_rq->runtime_enabled)
+		return;
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
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
+static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {


