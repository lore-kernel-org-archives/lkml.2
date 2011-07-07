Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1GGFdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:33:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab1GGFdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=p8gDCu+6F6ARIMakOsRQeBwf0sixRD/DO8bsq5zmzvTGpEEoTS1zk6PT4b1T3/jTq
	8b8wDkFWFylf0y3KWCWsA==
Message-Id: <20110707053101.110722366@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:51 -0700
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
        Hu Tao <hutao@cn.fujitsu.com>, Nikhil Rao <ncrao@google.com>
Subject: [patch 15/17] sched: add exports tracking cfs bandwidth control statistics
References: <20110707053036.173186930@google.com>
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
 kernel/sched_fair.c |    7 +++++++
 2 files changed, 28 insertions(+)

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
@@ -9212,6 +9216,19 @@ static int __cfs_schedulable(struct task
 
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
 
@@ -9258,6 +9275,10 @@ static struct cftype cpu_files[] = {
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
@@ -1522,6 +1522,7 @@ static void throttle_cfs_rq(struct cfs_r
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -1576,8 +1577,10 @@ static void unthrottle_cfs_rq(struct cfs
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -1665,6 +1668,7 @@ static int do_sched_cfs_period_timer(str
 	throttled = !list_empty(&cfs_b->throttled_cfs_rq);
 	/* idle depends on !throttled (for the case of a large deficit) */
 	idle = cfs_b->idle && !throttled;
+	cfs_b->nr_periods += overrun;
 
 	/* if we're going inactive then everything else can be deferred */
 	if (idle)
@@ -1678,6 +1682,9 @@ static int do_sched_cfs_period_timer(str
 		goto out_unlock;
 	}
 
+	/* account preceding periods in which throttling occurred */
+	cfs_b->nr_throttled += overrun;
+
 	/*
 	 * There are throttled entities so we must first use the new bandwidth
 	 * to unthrottle them before making it generally available.  This


