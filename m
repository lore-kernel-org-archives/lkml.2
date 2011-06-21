Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1FUHVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:21:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1FUHVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=ScrzIaJyHt+AVc0UHe+E6kuJ/ZWZz0Gr9FRS31f0mjU/o3deQGebjTvMaBR9jj3RK
	+DeY0mCNUjbfjcRr4Enzg==
Message-Id: <20110621071701.065779763@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:17:03 -0700
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
        Nikhil Rao <ncrao@google.com>
Subject: [patch 14/16] sched: add exports tracking cfs bandwidth control statistics
References: <20110621071649.862846205@google.com>
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
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c      |   21 +++++++++++++++++++++
 kernel/sched_fair.c |    8 ++++++++
 2 files changed, 29 insertions(+)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -259,6 +259,9 @@ struct cfs_bandwidth {
 	struct hrtimer period_timer;
 	struct list_head throttled_cfs_rq;
 
+	/* statistics */
+	int nr_periods, nr_throttled;
+	u64 throttled_time;
 #endif
 };
 
@@ -399,6 +402,7 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
+	u64 throttled_timestamp;
 	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif
@@ -9209,6 +9213,19 @@ static int __cfs_schedulable(struct task
 
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
 
@@ -9255,6 +9272,10 @@ static struct cftype cpu_files[] = {
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
@@ -1497,6 +1497,7 @@ static void throttle_cfs_rq(struct cfs_r
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -1555,8 +1556,10 @@ static void unthrottle_cfs_rq(struct cfs
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* don't include throttled window for load statistics */
@@ -1659,6 +1662,11 @@ static int do_sched_cfs_period_timer(str
 		cfs_b->idle = !throttled;
 	}
 
+	/* update throttled stats */
+	cfs_b->nr_periods += overrun;
+	if (throttled)
+		cfs_b->nr_throttled += overrun;
+
 	if (idle) {
 		cfs_b->timer_active = 0;
 		goto out_unlock;


