Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab2JRRDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:03:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2JRRDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:03:00 -0400
Date: Thu, 18 Oct 2012 10:02:45 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-t5oi4uiv39cd9ffjovp7kun8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched/numa: Make the sampling period adaptive
Git-Commit-ID: 8ba2748a04dbf75d90cbdff7f1aa04255a18406e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:02:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ba2748a04dbf75d90cbdff7f1aa04255a18406e
Gitweb:     http://git.kernel.org/tip/8ba2748a04dbf75d90cbdff7f1aa04255a18406e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Oct 2012 19:41:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Oct 2012 13:56:41 +0200

sched/numa: Make the sampling period adaptive

The normal sampling rate can slow down once a task settles down.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-t5oi4uiv39cd9ffjovp7kun8@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    7 +++++--
 kernel/sched/core.c   |    1 +
 kernel/sched/fair.c   |   16 ++++++++++++----
 kernel/sysctl.c       |   11 +++++++++--
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c7f8656..22be2d6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1525,6 +1525,7 @@ struct task_struct {
 	int node;			/* task home node   */
 	int numa_scan_seq;
 	int numa_migrate_seq;
+	unsigned int numa_task_period;
 	u64 node_stamp;			/* migration stamp  */
 	unsigned long numa_contrib;
 	unsigned long *numa_faults;
@@ -2061,14 +2062,16 @@ enum sched_tunable_scaling {
 };
 extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
+extern unsigned int sysctl_sched_numa_task_period_min;
+extern unsigned int sysctl_sched_numa_task_period_max;
+extern unsigned int sysctl_sched_numa_settle_count;
+
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 extern unsigned int sysctl_sched_shares_window;
-extern unsigned int sysctl_sched_numa_task_period;
-extern unsigned int sysctl_sched_numa_settle_count;
 
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b370f2f..c386297 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1545,6 +1545,7 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_faults = NULL;
+	p->numa_task_period = sysctl_sched_numa_task_period_min;
 #endif /* CONFIG_SCHED_NUMA */
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1a32930..ab2f11b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -813,7 +813,8 @@ static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 /*
  * numa task sample period in ms: 5s
  */
-unsigned int sysctl_sched_numa_task_period = 5000;
+unsigned int sysctl_sched_numa_task_period_min = 5000;
+unsigned int sysctl_sched_numa_task_period_max = 5000*16;
 
 /*
  * Wait for the 2-sample stuff to settle before migrating again
@@ -863,12 +864,19 @@ void task_numa_placement(void)
 		p->numa_faults[node] /= 2;
 	}
 
-	if (max_node != -1 && p->node != max_node) {
+	if (max_node == -1)
+		return;
+
+	if (p->node != max_node) {
+		p->numa_task_period = sysctl_sched_numa_task_period_min;
 		if (sched_feat(NUMA_SETTLE) &&
 		    (seq - p->numa_migrate_seq) <= (int)sysctl_sched_numa_settle_count)
 			return;
 		p->numa_migrate_seq = seq;
 		sched_setnode(p, max_node);
+	} else {
+		p->numa_task_period = min(sysctl_sched_numa_task_period_max,
+				p->numa_task_period * 2);
 	}
 }
 
@@ -902,7 +910,7 @@ void task_numa_work(struct callback_head *work)
 	if (time_before(now, migrate))
 		return;
 
-	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_task_period);
+	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_task_period_min);
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
@@ -930,7 +938,7 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	 * NUMA placement.
 	 */
 	now = curr->se.sum_exec_runtime;
-	period = (u64)sysctl_sched_numa_task_period * NSEC_PER_MSEC;
+	period = (u64)curr->numa_task_period * NSEC_PER_MSEC;
 
 	if (now - curr->node_stamp > period) {
 		curr->node_stamp = now;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 446bbef..2a95d38 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -347,8 +347,15 @@ static struct ctl_table kern_table[] = {
 #endif /* CONFIG_SMP */
 #ifdef CONFIG_SCHED_NUMA
 	{
-		.procname	= "sched_numa_task_period_ms",
-		.data		= &sysctl_sched_numa_task_period,
+		.procname	= "sched_numa_task_period_min_ms",
+		.data		= &sysctl_sched_numa_task_period_min,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_numa_task_period_max_ms",
+		.data		= &sysctl_sched_numa_task_period_max,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
