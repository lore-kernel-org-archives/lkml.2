Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1EGGcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:32:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1EGGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=o2jalrzxzLJi3mxBDgD5PLxGC1ed2QzZMiTyKt4ztnxCrvVicNUgjqJPMjJR7pPq0
	UvRlIG/Wy12dT+OF1nRjw==
Message-Id: <20110503092905.606935177@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:59 -0700
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
Subject: [patch 13/15] sched: add exports tracking cfs bandwidth control statistics
References: <20110503092846.022272244@google.com>
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

Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   22 ++++++++++++++++++++++
 kernel/sched_fair.c |    9 +++++++++
 2 files changed, 31 insertions(+)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -260,6 +260,10 @@ struct cfs_bandwidth {
 	struct hrtimer period_timer;
 	struct list_head throttled_cfs_rq;
 
+	/* statistics */
+	int nr_periods, nr_throttled;
+	u64 throttled_time;
+
 #endif
 };
 
@@ -395,6 +399,7 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
+	u64 throttled_timestamp;
 	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif
@@ -9517,6 +9522,19 @@ int sched_cfs_consistent_handler(struct 
 
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
 
@@ -9563,6 +9581,10 @@ static struct cftype cpu_files[] = {
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
@@ -1459,6 +1459,7 @@ static void throttle_cfs_rq(struct cfs_r
 		rq->nr_running += task_delta;
 
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -1514,8 +1515,10 @@ static void unthrottle_cfs_rq(struct cfs
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* don't include throttled window for load statistics */
@@ -1628,6 +1631,12 @@ retry:
 		raw_spin_unlock(&cfs_b->lock);
 		goto retry;
 	}
+
+	/* update throttled stats */
+	cfs_b->nr_periods += overrun;
+	if (throttled)
+		cfs_b->nr_throttled += overrun;
+
 	cfs_b->runtime = runtime;
 	cfs_b->idle = idle;
 out_unlock:


