Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0JLHxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:53:38 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52929 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab0JLHxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:53:36 -0400
Date: Tue, 12 Oct 2010 13:23:32 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v3 5/7] sched: add exports tracking cfs bandwidth control
	statistics
Message-ID: <20101012075332.GF9893@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012074910.GA9893@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: add exports tracking cfs bandwidth control statistics

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
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   26 ++++++++++++++++++++++++++
 kernel/sched_fair.c |   18 +++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -252,6 +252,11 @@ struct cfs_bandwidth {
 	ktime_t			period;
 	u64			runtime, quota;
 	struct hrtimer		period_timer;
+
+	/* throttle statistics */
+	u64			nr_periods;
+	u64			nr_throttled;
+	u64			throttled_time;
 };
 #endif
 
@@ -388,6 +393,7 @@ struct cfs_rq {
 #ifdef CONFIG_CFS_BANDWIDTH
 	u64 quota_assigned, quota_used;
 	int throttled;
+	u64 throttled_timestamp;
 #endif
 #endif
 };
@@ -425,6 +431,10 @@ void init_cfs_bandwidth(struct cfs_bandw
 
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
+
+	cfs_b->nr_periods = 0;
+	cfs_b->nr_throttled = 0;
+	cfs_b->throttled_time = 0;
 }
 
 static
@@ -9029,6 +9039,18 @@ static int cpu_cfs_period_write_u64(stru
 	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
 }
 
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
 
@@ -9075,6 +9097,10 @@ static struct cftype cpu_files[] = {
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
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1224,16 +1224,26 @@ static void throttle_cfs_rq(struct cfs_r
 
 out_throttled:
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
 }
 
 static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se;
 	struct rq *rq = rq_of(cfs_rq);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
+	/* update stats */
+	update_rq_clock(rq);
+	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += (rq->clock - cfs_rq->throttled_timestamp);
+	raw_spin_unlock(&cfs_b->lock);
+
 	cfs_rq->throttled = 0;
+	cfs_rq->throttled_timestamp = 0;
+
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
@@ -1271,7 +1281,7 @@ static void account_cfs_rq_quota(struct 
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	int i, idle = 1;
+	int i, idle = 1, num_throttled = 0;
 	u64 delta;
 	const struct cpumask *span;
 
@@ -1293,6 +1303,7 @@ static int do_sched_cfs_period_timer(str
 
 		if (!cfs_rq_throttled(cfs_rq))
 			continue;
+		num_throttled++;
 
 		delta = tg_request_cfs_quota(cfs_rq->tg);
 
@@ -1306,6 +1317,11 @@ static int do_sched_cfs_period_timer(str
 		}
 	}
 
+	/* update throttled stats */
+	cfs_b->nr_periods++;
+	if (num_throttled)
+		cfs_b->nr_throttled++;
+
 	return idle;
 }
 
