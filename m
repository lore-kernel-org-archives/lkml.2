Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0IKRki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 13:40:38 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39719 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab0IKRkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 13:40:36 -0400
Message-Id: <20100911174003.227776749@efficios.com>
User-Agent: quilt/0.48-1
Date: Sat, 11 Sep 2010 13:37:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>
Subject: [RFC patch 2/2] sched: sleepers coarse granularity on wakeup
References: <20100911173732.551632040@efficios.com>
Content-Disposition: inline; filename=sched-sleeper-coarse-gran.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 11 Sep 2010 17:40:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep a larger granularity for awakened sleepers, so the "FAIR_SLEEPER" feature
is not affected by shrinking granularity.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    1 +
 kernel/sched_debug.c  |    1 +
 kernel/sched_fair.c   |   11 +++++++++++
 4 files changed, 14 insertions(+)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -70,6 +70,11 @@ static unsigned int sched_nr_latency = 3
 static unsigned int sched_nr_latency_max = 8;
 
 /*
+ * Runtime slice given to awakened sleepers.
+ */
+unsigned int sysctl_sched_sleeper_wakeup_slice = 2000000ULL;
+
+/*
  * After fork, child runs first. If set to 0 (default) then
  * parent will (try to) run first.
  */
@@ -765,6 +770,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 			thresh >>= 1;
 
 		vruntime -= thresh;
+		se->sleeper_wakeup_slice = sysctl_sched_sleeper_wakeup_slice;
 	}
 
 	/* ensure we never gain time by being placed backwards. */
@@ -881,6 +887,11 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	if (delta_exec < curr->sleeper_wakeup_slice)
+		return;
+	else
+		curr->sleeper_wakeup_slice = 0;
+
 	if (delta_exec < __sched_gran(cfs_rq->nr_running))
 		return;
 
Index: linux-2.6-lttng.git/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.git.orig/include/linux/sched.h
+++ linux-2.6-lttng.git/include/linux/sched.h
@@ -1132,6 +1132,7 @@ struct sched_entity {
 	u64			prev_sum_exec_runtime;
 
 	u64			nr_migrations;
+	unsigned long		sleeper_wakeup_slice;
 
 #ifdef CONFIG_SCHEDSTATS
 	struct sched_statistics statistics;
Index: linux-2.6-lttng.git/kernel/sched.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched.c
+++ linux-2.6-lttng.git/kernel/sched.c
@@ -2422,6 +2422,7 @@ static void __sched_fork(struct task_str
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
+	p->se.sleeper_wakeup_slice	= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
Index: linux-2.6-lttng.git/kernel/sched_debug.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_debug.c
+++ linux-2.6-lttng.git/kernel/sched_debug.c
@@ -334,6 +334,7 @@ static int sched_debug_show(struct seq_f
 	PN(sysctl_sched_std_granularity);
 	PN(sysctl_sched_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
+	PN(sysctl_sched_sleeper_wakeup_slice);
 	P(sysctl_sched_features);
 #undef PN
 #undef P

