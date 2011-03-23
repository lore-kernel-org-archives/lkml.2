Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1CWDKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1CWDKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=M7n5GO6oTdTRr1ZJs39MNhBRwdYfGXyVgGEHJr0y2iBuNDcNxEUA21Gg/E4sT0Sf2
	N0Ndl8u6Hv80hRAM/m7NQ==
Message-Id: <20110323030450.042414995@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:40 -0700
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
Subject: [patch 14/15] sched: return unused quota on voluntary sleep
References: <20110323030326.789836913@google.com>
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

Bharata's idea to use a slack timer to handle the return helped make this patch
cleaner.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

---
 kernel/sched.c      |   16 ++++++++-
 kernel/sched_fair.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 1 deletion(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -254,7 +254,7 @@ struct cfs_bandwidth {
 	ktime_t period;
 	u64 runtime, runtime_assigned, quota;
 	s64 hierarchal_quota; /* used for validating consistency */
-	struct hrtimer period_timer;
+	struct hrtimer period_timer, slack_timer;
 
 	int quota_generation;
 	struct list_head throttled_cfs_rq;
@@ -432,6 +432,17 @@ static enum hrtimer_restart sched_cfs_pe
 	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
 }
 
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
+
 static
 void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 quota, u64 period)
 {
@@ -444,6 +455,8 @@ void init_cfs_bandwidth(struct cfs_bandw
 
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
+	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->slack_timer.function = sched_cfs_slack_timer;
 
 	cfs_b->nr_periods = 0;
 	cfs_b->nr_throttled = 0;
@@ -477,6 +490,7 @@ static void start_cfs_bandwidth(struct c
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	hrtimer_cancel(&cfs_b->period_timer);
+	hrtimer_cancel(&cfs_b->slack_timer);
 }
 #else
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1225,6 +1225,7 @@ static struct sched_entity *pick_next_en
 
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq);
 static inline int within_bandwidth(struct cfs_rq *cfs_rq);
+static void return_cfs_rq_quota(struct cfs_rq *cfs_rq);
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
@@ -1237,6 +1238,8 @@ static void put_prev_entity(struct cfs_r
 
 	if (!within_bandwidth(cfs_rq))
 		throttle_cfs_rq(cfs_rq);
+	else
+		return_cfs_rq_quota(cfs_rq);
 
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
@@ -1589,6 +1592,94 @@ static int do_sched_cfs_period_timer(str
 
 	return idle;
 }
+
+/* a cfs_rq won't donate quota below this amount */
+static const u64 min_cfs_rq_quota = 1 * NSEC_PER_MSEC;
+/* minimum remaining period time to redistribute slack quota */
+static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
+/* how long we wait to gather additional slack before distributing */
+static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
+
+/* are we near the end of the current quota period? */
+static int quota_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
+{
+	struct hrtimer *refresh_timer = &cfs_b->period_timer;
+	u64 remaining;
+
+	/* if the call back is running a quota refresh is occurring */
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
+static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
+{
+	u64 runtime = 0, slice = sched_cfs_bandwidth_slice();
+	int generation;
+
+	/* confirm we're still not at a refresh boundary */
+	if (quota_refresh_within(cfs_b, min_bandwidth_expiration))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
+		runtime = cfs_b->runtime;
+		cfs_b->runtime = 0;
+	}
+	generation = cfs_b->quota_generation;
+	raw_spin_unlock(&cfs_b->lock);
+
+	if (!runtime)
+		return;
+
+	runtime = distribute_cfs_bandwidth(cfs_b, runtime, generation);
+
+	raw_spin_lock(&cfs_b->lock);
+	cfs_b->runtime = runtime;
+	raw_spin_unlock(&cfs_b->lock);
+}
+
+static void start_cfs_slack_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	u64 min_left = cfs_bandwidth_slack_period + min_bandwidth_expiration;
+
+	/* if there's a quota refresh soon don't bother with slack */
+	if (quota_refresh_within(cfs_b, min_left))
+		return;
+
+	start_bandwidth_timer(&cfs_b->slack_timer,
+				ns_to_ktime(cfs_bandwidth_slack_period));
+}
+
+static void return_cfs_rq_quota(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	s64 slack_quota = cfs_rq->quota_remaining - min_cfs_rq_quota;
+
+	if (!cfs_rq->quota_enabled || cfs_rq->load.weight)
+		return;
+
+	if (slack_quota <= 0 || !cfs_rq_quota_current(cfs_rq))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota != RUNTIME_INF && cfs_rq_quota_current(cfs_rq)) {
+		cfs_b->runtime += slack_quota;
+
+		if (cfs_b->runtime > sched_cfs_bandwidth_slice() &&
+		    !list_empty(&cfs_b->throttled_cfs_rq))
+			start_cfs_slack_bandwidth(cfs_b);
+	}
+	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->quota_remaining -= slack_quota;
+}
+
 #else
 static inline u64 default_cfs_period(void)
 {
@@ -1614,6 +1705,7 @@ static void check_cfs_rq_quota(struct cf
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq) {}
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}
+static void return_cfs_rq_quota(struct cfs_rq *cfs_rq) {}
 #endif
 
 


