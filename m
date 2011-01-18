Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1ARTFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:05:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:52949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab1ARTFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:05:14 -0500
Date: Tue, 18 Jan 2011 19:04:39 GMT
From: tip-bot for Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bharata@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110111101153.GE4772@in.ibm.com>
References: <20110111101153.GE4772@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Reinstate group names in /proc/sched_debug
Message-ID: <tip-efe25c2c7b3a5d17b0c70987a758d8fe7af8e3d1@git.kernel.org>
Git-Commit-ID: efe25c2c7b3a5d17b0c70987a758d8fe7af8e3d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:04:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efe25c2c7b3a5d17b0c70987a758d8fe7af8e3d1
Gitweb:     http://git.kernel.org/tip/efe25c2c7b3a5d17b0c70987a758d8fe7af8e3d1
Author:     Bharata B Rao <bharata@linux.vnet.ibm.com>
AuthorDate: Tue, 11 Jan 2011 15:41:54 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 15:09:39 +0100

sched: Reinstate group names in /proc/sched_debug

Displaying of group names in /proc/sched_debug was dropped in autogroup
patches. Add group names while displaying cfs_rq and tasks information.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110111101153.GE4772@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_debug.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 1dfae3d..4d36f37 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -16,6 +16,8 @@
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
 
+static DEFINE_SPINLOCK(sched_debug_lock);
+
 /*
  * This allows printing both to /proc/sched_debug and
  * to the console
@@ -86,6 +88,23 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 }
 #endif
 
+#ifdef CONFIG_CGROUP_SCHED
+static char group_path[PATH_MAX];
+
+static char *task_group_path(struct task_group *tg)
+{
+	/*
+	 * May be NULL if the underlying cgroup isn't fully-created yet
+	 */
+	if (!tg->css.cgroup) {
+		group_path[0] = '\0';
+		return group_path;
+	}
+	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
+	return group_path;
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -108,6 +127,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_CGROUP_SCHED
+	SEQ_printf(m, " %s", task_group_path(task_group(p)));
+#endif
 
 	SEQ_printf(m, "\n");
 }
@@ -144,7 +166,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	struct sched_entity *last;
 	unsigned long flags;
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, task_group_path(cfs_rq->tg));
+#else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
+#endif
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
@@ -191,7 +217,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
+#ifdef CONFIG_RT_GROUP_SCHED
+	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, task_group_path(rt_rq->tg));
+#else
 	SEQ_printf(m, "\nrt_rq[%d]:\n", cpu);
+#endif
 
 #define P(x) \
 	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rt_rq->x))
@@ -212,6 +242,7 @@ extern __read_mostly int sched_clock_running;
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
 
 #ifdef CONFIG_X86
 	{
@@ -266,10 +297,14 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 #undef P
 #endif
+	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 
+	rcu_read_lock();
 	print_rq(m, rq, cpu);
+	rcu_read_unlock();
+	spin_unlock_irqrestore(&sched_debug_lock, flags);
 }
 
 static const char *sched_tunable_scaling_names[] = {
