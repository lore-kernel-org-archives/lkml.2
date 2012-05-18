Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab2ERKsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:48:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2ERKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:48:17 -0400
Date: Fri, 18 May 2012 03:48:03 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-lz8zudea6tqgbxduk9mcs7x3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Provide sysctl knob to disable numa scheduling and turn it off by default
Git-Commit-ID: bcdf5162b92dfc0999b0e0ecf25d778733cc4c4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:48:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcdf5162b92dfc0999b0e0ecf25d778733cc4c4d
Gitweb:     http://git.kernel.org/tip/bcdf5162b92dfc0999b0e0ecf25d778733cc4c4d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 May 2012 15:07:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 09:48:59 +0200

sched/numa: Provide sysctl knob to disable numa scheduling and turn it off by default

Provide a knob to make all this numa scheduling go-away.

Also provide a Kconfig entry to set the default for this new knob.

Requested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-lz8zudea6tqgbxduk9mcs7x3@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |   13 +++++++
 init/Kconfig          |   18 ++++++++++
 kernel/sched/numa.c   |   89 +++++++++++++++++++++++++++++++++++++++---------
 kernel/sysctl.c       |   11 ++++++
 4 files changed, 114 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 024a5f9..4879103 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -90,6 +90,7 @@ struct sched_param {
 #include <linux/latencytop.h>
 #include <linux/cred.h>
 #include <linux/llist.h>
+#include <linux/jump_label.h>
 
 #include <asm/processor.h>
 
@@ -1584,9 +1585,14 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+extern struct static_key sched_numa_disabled;
+
 static inline int tsk_home_node(struct task_struct *p)
 {
 #ifdef CONFIG_NUMA
+	if (static_key_false(&sched_numa_disabled))
+		return -1;
+
 	return p->node;
 #else
 	return -1;
@@ -2058,6 +2064,13 @@ static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 #endif
 
+#ifdef CONFIG_NUMA
+extern int sysctl_sched_numa;
+int sched_numa_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
diff --git a/init/Kconfig b/init/Kconfig
index e4e84f2..2f6bfc1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -865,6 +865,24 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+config SCHED_NUMA_DEFAULT
+	bool "Enable NUMA scheduling by default"
+	depends on NUMA
+	default n
+	help
+	  This option selects the default enablement of a scheduler feature
+	  that gives each process a home-node and allocates all its memory
+	  from there and tries to schedule all the process tasks on that node
+	  (or as near to it) while trying to maintain fairness.
+
+	  Without this feature memory is allocated on whatever node a task
+	  happens to run on and the scheduler is free to migrate tasks around
+	  at will -- which can result in significant cross-node memory
+	  traffic.
+
+	  Regardless of this setting it can always be changed at runtime
+	  by changing /proc/sys/kernel/sched_numa.
+
 config MM_OWNER
 	def_bool NUMA
 
diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index 7b74a15..b98338b 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -18,6 +18,9 @@
 
 #include "sched.h"
 
+struct static_key sched_numa_disabled = STATIC_KEY_INIT_FALSE;
+static DEFINE_MUTEX(sched_numa_mutex);
+int sysctl_sched_numa = IS_ENABLED(CONFIG_SCHED_NUMA_DEFAULT);
 
 static const int numa_balance_interval = 2 * HZ; /* 2 seconds */
 
@@ -137,7 +140,7 @@ bool account_numa_enqueue(struct task_struct *p)
 
 void account_numa_dequeue(struct task_struct *p)
 {
-	int home_node = tsk_home_node(p);
+	int home_node = p->node; /* ignore sched_numa_disabled */
 	struct numa_cpu_load *nl;
 	struct rq *rq;
 
@@ -444,7 +447,7 @@ void select_task_node(struct task_struct *p, struct mm_struct *mm, int sd_flags)
 {
 	int node;
 
-	if (!sched_feat(NUMA_SELECT)) {
+	if (!sched_feat(NUMA_SELECT) || !sysctl_sched_numa) {
 		p->node = -1;
 		return;
 	}
@@ -766,13 +769,74 @@ static int numad_thread(void *data)
 	return 0;
 }
 
+static int numad_create(struct node_queue *nq)
+{
+	struct task_struct *numad;
+
+	if (!sysctl_sched_numa)
+		return 0;
+
+	numad = kthread_create_on_node(numad_thread,
+			nq, nq->node, "numad/%d", nq->node);
+	if (IS_ERR(numad))
+		return PTR_ERR(numad);
+
+	nq->numad = numad;
+	nq->next_schedule = jiffies + HZ;
+
+	return 0;
+}
+
+static void numad_destroy(struct node_queue *nq)
+{
+	kthread_stop(nq->numad);
+	nq->numad = NULL;
+}
+
+int sched_numa_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int old, new, ret, node;
+
+	mutex_lock(&sched_numa_mutex);
+	get_online_cpus();
+
+	old = sysctl_sched_numa;
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	new = sysctl_sched_numa;
+
+	if (old == new)
+		goto unlock;
+
+	if (new)
+		static_key_slow_dec(&sched_numa_disabled);
+	else
+		static_key_slow_inc(&sched_numa_disabled);
+
+	for_each_online_node(node) {
+		struct node_queue *nq = nq_of(node);
+
+		if (new && !nq->numad) {
+			if (!numad_create(nq))
+				wake_up_process(nq->numad);
+		} else if (!new && nq->numad)
+			numad_destroy(nq);
+	}
+
+unlock:
+	put_online_cpus();
+	mutex_unlock(&sched_numa_mutex);
+
+	return ret;
+}
+
 static int __cpuinit
 numa_hotplug(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	int cpu = (long)hcpu;
 	int node = cpu_to_node(cpu);
 	struct node_queue *nq = nq_of(node);
-	struct task_struct *numad;
 	int err = 0;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -780,19 +844,12 @@ numa_hotplug(struct notifier_block *nb, unsigned long action, void *hcpu)
 		if (nq->numad)
 			break;
 
-		numad = kthread_create_on_node(numad_thread,
-				nq, node, "numad/%d", node);
-		if (IS_ERR(numad)) {
-			err = PTR_ERR(numad);
-			break;
-		}
-
-		nq->numad = numad;
-		nq->next_schedule = jiffies + HZ; // XXX sync-up?
+		err = numad_create(nq);
 		break;
 
 	case CPU_ONLINE:
-		wake_up_process(nq->numad);
+		if (nq->numad)
+			wake_up_process(nq->numad);
 		break;
 
 	case CPU_DEAD:
@@ -801,10 +858,8 @@ numa_hotplug(struct notifier_block *nb, unsigned long action, void *hcpu)
 			break;
 
 		if (cpumask_any_and(cpu_online_mask,
-				    cpumask_of_node(node)) >= nr_cpu_ids) {
-			kthread_stop(nq->numad);
-			nq->numad = NULL;
-		}
+				    cpumask_of_node(node)) >= nr_cpu_ids)
+			numad_destroy(nq);
 		break;
 	}
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..40ecba2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -373,6 +373,17 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 	},
 #endif
+#ifdef CONFIG_NUMA
+	{
+		.procname	= "sched_numa",
+		.data		= &sysctl_sched_numa,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sched_numa_handler,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
