Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1CWDKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1CWDKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=D+MAXFS82c8RKD32kYP8II1AodUP7MXPeR2gOnmEGQ/4vcfOn4CxlTWHoJVhfGm7A
	kZ2kcpLtKRI77laQjcmrQ==
Message-Id: <20110323030449.528412206@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:35 -0700
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
Subject: [patch 09/15] sched: add exports tracking cfs bandwidth control statistics
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-throttle_stats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikhil Rao <ncrao@google.com>

This change introduces statistics exports for the cpu sub-system, these are
added through the use of a stat file similar to that exported by other
subsystems.

The following exports are included:

nr_periods:	number of periods in which execution occurred
nr_throttled:	the number of periods above in which execution was throttle
throttled_time:	cumulative wall-time that any cpus have been throttled for
this group

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   27 +++++++++++++++++++++++++++
 kernel/sched_fair.c |   14 +++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -255,6 +255,11 @@ struct cfs_bandwidth {
 	u64 runtime, runtime_assigned, quota;
 	s64 hierarchal_quota; /* used for validating consistency */
 	struct hrtimer period_timer;
+
+	/* throttle statistics */
+	u64			nr_periods;
+	u64			nr_throttled;
+	u64			throttled_time;
 #endif
 };
 
@@ -388,6 +393,7 @@ struct cfs_rq {
 #ifdef CONFIG_CFS_BANDWIDTH
 	int quota_enabled, throttled, throttle_count;
 	s64 quota_remaining;
+	u64 throttled_timestamp;
 #endif
 #endif
 };
@@ -429,6 +435,10 @@ void init_cfs_bandwidth(struct cfs_bandw
 
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
+
+	cfs_b->nr_periods = 0;
+	cfs_b->nr_throttled = 0;
+	cfs_b->throttled_time = 0;
 }
 
 static void init_cfs_rq_quota(struct cfs_rq *cfs_rq)
@@ -9502,6 +9512,19 @@ int sched_cfs_consistent_handler(struct 
 	mutex_unlock(&cfs_constraints_mutex);
 	return ret;
 }
+
+static int cpu_stats_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+
+	cb->fill(cb, "nr_periods", cfs_b->nr_periods);
+	cb->fill(cb, "nr_throttled", cfs_b->nr_throttled);
+	cb->fill(cb, "throttled_time", cfs_b->throttled_time);
+
+	return 0;
+}
 #endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -9548,6 +9571,10 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_cfs_period_read_u64,
 		.write_u64 = cpu_cfs_period_write_u64,
 	},
+	{
+		.name = "stat",
+		.read_map = cpu_stats_show,
+	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1424,6 +1424,7 @@ static void throttle_cfs_rq(struct cfs_r
 	}
 
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
 }
 
 static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
@@ -1431,10 +1432,15 @@ static void unthrottle_cfs_rq(struct cfs
 	struct rq *rq = rq_of(cfs_rq);
 	struct sched_entity *se;
 	struct tg_unthrottle_down_data udd;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	update_rq_clock(rq);
+	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += (rq->clock - cfs_rq->throttled_timestamp);
+	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled_timestamp = 0;
 
 	/* don't include throttled window for load statistics */
 	udd.cpu = rq->cpu;
@@ -1505,11 +1511,12 @@ next:
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
 	u64 runtime, runtime_assigned;
-	int idle;
+	int idle, throttled;
 
 	raw_spin_lock(&cfs_b->lock);
 	runtime = cfs_b->quota;
 	idle = cfs_b->runtime == cfs_b->runtime_assigned;
+	throttled = cfs_b->runtime == 0;
 	raw_spin_unlock(&cfs_b->lock);
 
 	if (runtime == RUNTIME_INF)
@@ -1523,6 +1530,11 @@ static int do_sched_cfs_period_timer(str
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->runtime = runtime;
 	cfs_b->runtime_assigned = runtime_assigned;
+
+	/* update throttled stats */
+	cfs_b->nr_periods++;
+	if (throttled)
+		cfs_b->nr_throttled++;
 	raw_spin_unlock(&cfs_b->lock);
 
 	return idle;


