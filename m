Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1HNQic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:38:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:56483 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1HNQia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:38:30 -0400
Date: Sun, 14 Aug 2011 16:37:42 GMT
From: tip-bot for Nikhil Rao <ncrao@google.com>
Message-ID: <tip-e8da1b18b32064c43881bceef0f051c2110c9ab9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com,
        ncrao@google.com, pjt@google.com, bharata@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, ncrao@google.com,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184758.198901931@google.com>
References: <20110721184758.198901931@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add exports tracking cfs bandwidth control statistics
Git-Commit-ID: e8da1b18b32064c43881bceef0f051c2110c9ab9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:37:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8da1b18b32064c43881bceef0f051c2110c9ab9
Gitweb:     http://git.kernel.org/tip/e8da1b18b32064c43881bceef0f051c2110c9ab9
Author:     Nikhil Rao <ncrao@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:40 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:49 +0200

sched: Add exports tracking cfs bandwidth control statistics

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184758.198901931@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   21 +++++++++++++++++++++
 kernel/sched_fair.c |    7 +++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3973172..35c9185 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -262,6 +262,9 @@ struct cfs_bandwidth {
 	struct hrtimer period_timer;
 	struct list_head throttled_cfs_rq;
 
+	/* statistics */
+	int nr_periods, nr_throttled;
+	u64 throttled_time;
 #endif
 };
 
@@ -402,6 +405,7 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
+	u64 throttled_timestamp;
 	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif
@@ -9397,6 +9401,19 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 
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
 
@@ -9443,6 +9460,10 @@ static struct cftype cpu_files[] = {
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
index f9f671a..d201f28 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1506,6 +1506,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -1523,8 +1524,10 @@ static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -1612,6 +1615,7 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	throttled = !list_empty(&cfs_b->throttled_cfs_rq);
 	/* idle depends on !throttled (for the case of a large deficit) */
 	idle = cfs_b->idle && !throttled;
+	cfs_b->nr_periods += overrun;
 
 	/* if we're going inactive then everything else can be deferred */
 	if (idle)
@@ -1625,6 +1629,9 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 		goto out_unlock;
 	}
 
+	/* account preceding periods in which throttling occurred */
+	cfs_b->nr_throttled += overrun;
+
 	/*
 	 * There are throttled entities so we must first use the new bandwidth
 	 * to unthrottle them before making it generally available.  This
