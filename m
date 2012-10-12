Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab2JLLay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:30:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab2JLLaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:30:52 -0400
Date: Fri, 12 Oct 2012 04:30:38 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-jye7o9wfton73dra5r9hobft@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Implement migration throttle
Git-Commit-ID: e452657576a12abce9fe2291db372145a86862bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:30:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e452657576a12abce9fe2291db372145a86862bc
Gitweb:     http://git.kernel.org/tip/e452657576a12abce9fe2291db372145a86862bc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 9 Oct 2012 14:09:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:19 +0200

sched/numa: Implement migration throttle

Since our memory migration requires 2 scans/samples to stabilize,
don't migrate faster than that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-jye7o9wfton73dra5r9hobft@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h   |    2 ++
 kernel/sched/core.c     |    1 +
 kernel/sched/fair.c     |   16 +++++++++++++---
 kernel/sched/features.h |    1 +
 kernel/sysctl.c         |    7 +++++++
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d6818d7..99a70eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1524,6 +1524,7 @@ struct task_struct {
 #ifdef CONFIG_SCHED_NUMA
 	int node;			/* task home node   */
 	int numa_scan_seq;
+	int numa_migrate_seq;
 	u64 node_stamp;			/* migration stamp  */
 	unsigned long numa_contrib;
 	unsigned long *numa_faults;
@@ -2076,6 +2077,7 @@ extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 extern unsigned int sysctl_sched_shares_window;
 extern unsigned int sysctl_sched_numa_task_period;
+extern unsigned int sysctl_sched_numa_settle_count;
 
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b149cad..c7d0b94 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1543,6 +1543,7 @@ static void __sched_fork(struct task_struct *p)
 	p->node = -1;
 	p->node_stamp = 0ULL;
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
+	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_faults = NULL;
 #endif /* CONFIG_SCHED_NUMA */
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f8eb98e..592291b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -811,9 +811,14 @@ static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 }
 
 /*
- * numa task sample period in ms: 2.5s
+ * numa task sample period in ms: 5s
  */
-unsigned int sysctl_sched_numa_task_period = 2500;
+unsigned int sysctl_sched_numa_task_period = 5000;
+
+/*
+ * Wait for the 2-sample stuff to settle before migrating again
+ */
+unsigned int sysctl_sched_numa_settle_count = 2;
 
 /*
  * Got a PROT_NONE fault for a page on @node.
@@ -859,8 +864,13 @@ void task_numa_placement(void)
 		p->numa_faults[node] /= 2;
 	}
 
-	if (max_node != -1 && p->node != max_node)
+	if (max_node != -1 && p->node != max_node) {
+		if (sched_feat(NUMA_SETTLE) &&
+		    (seq - p->numa_migrate_seq) <= (int)sysctl_sched_numa_settle_count)
+			return;
+		p->numa_migrate_seq = seq;
 		sched_setnode(p, max_node);
+	}
 }
 
 /*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 64ead49..f8a7aeb 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -69,5 +69,6 @@ SCHED_FEAT(NUMA_TTWU_BIAS, false)
 SCHED_FEAT(NUMA_TTWU_TO,   false)
 SCHED_FEAT(NUMA_PULL,      true)
 SCHED_FEAT(NUMA_PULL_BIAS, true)
+SCHED_FEAT(NUMA_SETTLE,    true)
 #endif
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c08b95e..446bbef 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -353,6 +353,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "sched_numa_settle_count",
+		.data		= &sysctl_sched_numa_settle_count,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif /* CONFIG_SCHED_NUMA */
 #endif /* CONFIG_SCHED_DEBUG */
 	{
