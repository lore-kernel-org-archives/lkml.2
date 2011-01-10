Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab1AJFPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 00:15:55 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40426 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJFPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 00:15:53 -0500
Date: Mon, 10 Jan 2011 10:45:51 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip 1/2] sched: Reinstate group names in /proc/sched_debug.
Message-ID: <20110110051551.GC2772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110110051445.GB2772@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110051445.GB2772@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Reinstate group names in /proc/sched_debug.

Displaying of group names in /proc/sched_debug was dropped in autogroup
patches. Add group names while displaying cfs_rq and tasks information.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched_debug.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -16,6 +16,9 @@
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
 
+static char group_path[PATH_MAX];
+static DEFINE_SPINLOCK(sched_debug_lock);
+
 /*
  * This allows printing both to /proc/sched_debug and
  * to the console
@@ -86,6 +89,23 @@ static void print_cfs_group_stats(struct
 }
 #endif
 
+#ifdef CONFIG_CGROUP_SCHED
+static char * task_group_path(struct task_group *tg)
+{
+	/*
+	 * May be NULL if the underlying cgroup isn't fully-created yet
+	 */
+	if (!tg->css.cgroup) {
+		group_path[0] = '\0';
+		return group_path;
+	}
+	rcu_read_lock();
+	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
+	rcu_read_unlock();
+	return group_path;
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -108,6 +128,9 @@ print_task(struct seq_file *m, struct rq
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_CGROUP_SCHED
+	SEQ_printf(m, " %s", task_group_path(task_group(p)));
+#endif
 
 	SEQ_printf(m, "\n");
 }
@@ -144,7 +167,11 @@ void print_cfs_rq(struct seq_file *m, in
 	struct sched_entity *last;
 	unsigned long flags;
 
+#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
+	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, task_group_path(cfs_rq->tg));
+#else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
+#endif
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
@@ -191,7 +218,11 @@ void print_cfs_rq(struct seq_file *m, in
 
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
+#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
+	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, task_group_path(rt_rq->tg));
+#else
 	SEQ_printf(m, "\nrt_rq[%d]:\n", cpu);
+#endif
 
 #define P(x) \
 	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rt_rq->x))
@@ -212,6 +243,7 @@ extern __read_mostly int sched_clock_run
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
 
 #ifdef CONFIG_X86
 	{
@@ -266,10 +298,12 @@ static void print_cpu(struct seq_file *m
 
 #undef P
 #endif
+	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
+	spin_unlock_irqrestore(&sched_debug_lock, flags);
 }
 
 static const char *sched_tunable_scaling_names[] = {
