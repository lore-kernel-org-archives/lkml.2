Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0D1LT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:19:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28907 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0D1LTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:19:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Yy6RsUCa+/gdP+IMPad3R3DiD34OgURxJk2UEYZqw3FHtHwEalVZ8rOa4BiW/4/wI
	9H8Ql6VjZqD6QtQ/b3/nA==
Subject: [PATCH v2 5/6] sched: add exports tracking cfs bandwidth control
	statistics
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 28 Apr 2010 04:17:12 -0700
Message-ID: <20100428111712.7954.24829.stgit@kitami.corp.google.com>
In-Reply-To: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
References: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
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
---
 kernel/sched.c      |   26 ++++++++++++++++++++++++++
 kernel/sched_fair.c |   19 ++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index aca1d32..ac74d3a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -251,6 +251,11 @@ struct cfs_bandwidth {
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
 
@@ -423,6 +428,7 @@ struct cfs_rq {
 #ifdef CONFIG_CFS_BANDWIDTH
 	u64 quota_assigned, quota_used;
 	int throttled;
+	u64 throttled_timestamp;
 #endif
 #endif
 };
@@ -460,6 +466,10 @@ void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 quota, u64 period)
 
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
+
+	cfs_b->nr_periods = 0;
+	cfs_b->nr_throttled = 0;
+	cfs_b->throttled_time = 0;
 }
 
 static
@@ -8996,6 +9006,18 @@ static int cpu_cfs_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
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
 
@@ -9042,6 +9064,10 @@ static struct cftype cpu_files[] = {
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 11de5de..edea44e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1229,15 +1229,26 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 			break;
 	}
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
 }
 
 static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct rq *rq = rq_of(cfs_rq);
 
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
@@ -1271,7 +1282,7 @@ static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	int i, idle = 1;
+	int i, idle = 1, num_throttled = 0;
 	u64 delta;
 	const struct cpumask *span;
 
@@ -1293,6 +1304,7 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 
 		if (!cfs_rq_throttled(cfs_rq))
 			continue;
+		num_throttled++;
 
 		delta = tg_request_cfs_quota(cfs_rq->tg);
 
@@ -1306,6 +1318,11 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 		}
 	}
 
+	/* update throttled stats */
+	cfs_b->nr_periods++;
+	if (num_throttled)
+		cfs_b->nr_throttled++;
+
 	return idle;
 }
 

