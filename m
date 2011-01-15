Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1AOCC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 21:02:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1AOCC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 21:02:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=A8OSiWK3TtHtv44H2Vlvt7EDevMzV5h7v1bZtbgLRzX0ct+A6kjxCYo0aDE30PYIt
	3/HZ7f0qe2GSdApRvgu9g==
Message-Id: <20110115015817.160235155@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 14 Jan 2011 17:57:51 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [wake_afine fixes/improvements 2/3] sched: clean up task_hot()
References: <20110115015749.692623529@google.com>
Content-Disposition: inline; filename=no_hot_sd.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer compute per-domain migration costs or have use for task_hot()
external to the fair scheduling class.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |   35 -----------------------------------
 kernel/sched_fair.c |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 36 deletions(-)

Index: tip3/kernel/sched.c
===================================================================
--- tip3.orig/kernel/sched.c
+++ tip3/kernel/sched.c
@@ -1522,8 +1522,6 @@ static unsigned long power_of(int cpu)
 	return cpu_rq(cpu)->cpu_power;
 }
 
-static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -2061,38 +2059,6 @@ static void check_preempt_curr(struct rq
 }
 
 #ifdef CONFIG_SMP
-/*
- * Is this task likely cache-hot:
- */
-static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
-{
-	s64 delta;
-
-	if (p->sched_class != &fair_sched_class)
-		return 0;
-
-	if (unlikely(p->policy == SCHED_IDLE))
-		return 0;
-
-	/*
-	 * Buddy candidates are cache hot:
-	 */
-	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
-			(&p->se == cfs_rq_of(&p->se)->next ||
-			 &p->se == cfs_rq_of(&p->se)->last))
-		return 1;
-
-	if (sysctl_sched_migration_cost == -1)
-		return 1;
-	if (sysctl_sched_migration_cost == 0)
-		return 0;
-
-	delta = now - p->se.exec_start;
-
-	return delta < (s64)sysctl_sched_migration_cost;
-}
-
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 #ifdef CONFIG_SCHED_DEBUG
@@ -9237,4 +9203,3 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
-
Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -1346,6 +1346,36 @@ static void task_waking_fair(struct rq *
 	se->vruntime -= cfs_rq->min_vruntime;
 }
 
+/* is this task likely cache-hot */
+static int
+task_hot(struct task_struct *p, u64 now)
+{
+	s64 delta;
+
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
+	/*
+	 * Buddy candidates are cache hot:
+	 */
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+			(&p->se == cfs_rq_of(&p->se)->next ||
+			 &p->se == cfs_rq_of(&p->se)->last))
+		return 1;
+
+	if (sysctl_sched_migration_cost == -1)
+		return 1;
+	if (sysctl_sched_migration_cost == 0)
+		return 0;
+
+	delta = now - p->se.exec_start;
+
+	return delta < (s64)sysctl_sched_migration_cost;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group
@@ -1954,7 +1984,7 @@ int can_migrate_task(struct task_struct 
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, rq->clock_task, sd);
+	tsk_cache_hot = task_hot(p, rq->clock_task);
 	if (!tsk_cache_hot ||
 		sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS


