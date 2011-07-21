Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1GUXBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:01:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1GUXB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:01:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=Sx8jopeySbJKo2cPuSLoFmU6z/LQ2ePW2XfhQmikZBD8Qy9/hX6ngyKUp/34KVbU5
	2FfrjR8jMfS9YsnCgxJEw==
Message-Id: <20110721184758.198901931@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 21 Jul 2011 09:43:40 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>, Nikhil Rao <ncrao@google.com>
Subject: [patch 15/18] sched: add exports tracking cfs bandwidth control statistics
References: <20110721164325.231521704@google.com>
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
@@ -9213,6 +9217,19 @@ static int __cfs_schedulable(struct task
 
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
 
@@ -9259,6 +9276,10 @@ static struct cftype cpu_files[] = {
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
@@ -1528,6 +1528,7 @@ static void throttle_cfs_rq(struct cfs_r
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -1545,8 +1546,10 @@ static void unthrottle_cfs_rq(struct cfs
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -1634,6 +1637,7 @@ static int do_sched_cfs_period_timer(str
 	throttled = !list_empty(&cfs_b->throttled_cfs_rq);
 	/* idle depends on !throttled (for the case of a large deficit) */
 	idle = cfs_b->idle && !throttled;
+	cfs_b->nr_periods += overrun;
 
 	/* if we're going inactive then everything else can be deferred */
 	if (idle)
@@ -1647,6 +1651,9 @@ static int do_sched_cfs_period_timer(str
 		goto out_unlock;
 	}
 
+	/* account preceding periods in which throttling occurred */
+	cfs_b->nr_throttled += overrun;
+
 	/*
 	 * There are throttled entities so we must first use the new bandwidth
 	 * to unthrottle them before making it generally available.  This


