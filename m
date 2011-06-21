Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1FUHVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:21:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1FUHVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=F6hM5mh/4LTkz4bl3Z1C8WFyS5/jDaajP3JIa7zy7+PEHcIroiBhe+B7i1/qF8VTJ
	7ShBKyo4kXRiQ4wR9SMyA==
Message-Id: <20110621071701.165027089@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:17:04 -0700
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
Subject: [patch 15/16] sched: return unused runtime on voluntary sleep
References: <20110621071649.862846205@google.com>
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
 kernel/sched.c      |   15 +++++++
 kernel/sched_fair.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 1 deletion(-)

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
@@ -476,6 +488,7 @@ static void __start_cfs_bandwidth(struct
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
 
+	/* return excess runtime on last deuque */
+	if (!cfs_rq->nr_running)
+		return_cfs_rq_runtime(cfs_rq);
+
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq);
 }
@@ -1694,11 +1700,104 @@ out_unlock:
 
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
+	    (s64)(cfs_rq->runtime_expires - cfs_b->runtime_expires) >= 0) {
+		cfs_b->runtime += slack_runtime;
+
+		if (cfs_b->runtime > sched_cfs_bandwidth_slice() &&
+		    !list_empty(&cfs_b->throttled_cfs_rq))
+			start_cfs_slack_bandwidth(cfs_b);
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+	cfs_rq->runtime_remaining -= slack_runtime;
+}
+
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


