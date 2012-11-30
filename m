Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab2K3T7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:59:16 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35250 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab2K3T7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:59:09 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 08/10] sched: Converge NUMA migrations
Date: Fri, 30 Nov 2012 20:58:39 +0100
Message-Id: <1354305521-11583-9-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354305521-11583-1-git-send-email-mingo@kernel.org>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the various convergence models and add a new one: when
a strongly converged NUMA task migrates, prefer to migrate it in
the direction of its preferred node.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c     | 59 +++++++++++++++++++++++++++++++++++--------------
 kernel/sched/features.h |  3 ++-
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1f6104a..10cbfa3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4750,6 +4750,35 @@ done:
 	return target;
 }
 
+static bool numa_allow_migration(struct task_struct *p, int prev_cpu, int new_cpu)
+{
+#ifdef CONFIG_NUMA_BALANCING
+	if (sched_feat(NUMA_CONVERGE_MIGRATIONS)) {
+		/* Help in the direction of expected convergence: */
+		if (p->convergence_node >= 0 && (cpu_to_node(new_cpu) != p->convergence_node))
+			return false;
+
+		return true;
+	}
+
+	if (sched_feat(NUMA_BALANCE_ALL)) {
+ 		if (task_numa_shared(p) >= 0)
+			return false;
+
+		return true;
+	}
+
+	if (sched_feat(NUMA_BALANCE_INTERNODE)) {
+		if (task_numa_shared(p) >= 0) {
+ 			if (cpu_to_node(prev_cpu) != cpu_to_node(new_cpu))
+				return false;
+		}
+	}
+#endif
+	return true;
+}
+
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -4766,7 +4795,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
+	int prev0_cpu = task_cpu(p);
+	int prev_cpu = prev0_cpu;
 	int new_cpu = cpu;
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
@@ -4775,10 +4805,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		return prev_cpu;
 
 #ifdef CONFIG_NUMA_BALANCING
-	/* We do NUMA balancing elsewhere: */
-	if (sched_feat(NUMA_BALANCE_ALL) && task_numa_shared(p) >= 0)
-		return prev_cpu;
-
 	if (sched_feat(WAKE_ON_IDEAL_CPU) && p->ideal_cpu >= 0)
 		return p->ideal_cpu;
 #endif
@@ -4857,8 +4883,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 unlock:
 	rcu_read_unlock();
 
-	if (sched_feat(NUMA_BALANCE_INTERNODE) && task_numa_shared(p) >= 0 && (cpu_to_node(prev_cpu) != cpu_to_node(new_cpu)))
-		return prev_cpu;
+	if (!numa_allow_migration(p, prev0_cpu, new_cpu))
+		return prev0_cpu;
 
 	return new_cpu;
 }
@@ -5401,8 +5427,11 @@ static bool can_migrate_running_task(struct task_struct *p, struct lb_env *env)
 static int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	/* We do NUMA balancing elsewhere: */
-	if (sched_feat(NUMA_BALANCE_ALL) && task_numa_shared(p) > 0 && env->failed <= env->sd->cache_nice_tries)
-		return false;
+
+	if (env->failed <= env->sd->cache_nice_tries) {
+		if (!numa_allow_migration(p, env->src_rq->cpu, env->dst_cpu))
+			return false;
+	}
 
 	if (!can_migrate_pinned_task(p, env))
 		return false;
@@ -5461,10 +5490,7 @@ static int move_one_task(struct lb_env *env)
 		if (!can_migrate_task(p, env))
 			continue;
 
-		if (sched_feat(NUMA_BALANCE_ALL) && task_numa_shared(p) >= 0)
-			continue;
-
-		if (sched_feat(NUMA_BALANCE_INTERNODE) && task_numa_shared(p) >= 0 && (cpu_to_node(env->src_rq->cpu) != cpu_to_node(env->dst_cpu)))
+		if (!numa_allow_migration(p, env->src_rq->cpu, env->dst_cpu))
 			continue;
 
 		move_task(p, env);
@@ -5527,10 +5553,7 @@ static int move_tasks(struct lb_env *env)
 		if (!can_migrate_task(p, env))
 			goto next;
 
-		if (sched_feat(NUMA_BALANCE_ALL) && task_numa_shared(p) >= 0)
-			continue;
-
-		if (sched_feat(NUMA_BALANCE_INTERNODE) && task_numa_shared(p) >= 0 && (cpu_to_node(env->src_rq->cpu) != cpu_to_node(env->dst_cpu)))
+		if (!numa_allow_migration(p, env->src_rq->cpu, env->dst_cpu))
 			goto next;
 
 		move_task(p, env);
@@ -6520,8 +6543,10 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.iteration          = 0,
 	};
 
+#ifdef CONFIG_NUMA_BALANCING
 	if (sched_feat(NUMA_BALANCE_ALL))
 		return 1;
+#endif
 
 	cpumask_copy(cpus, cpu_active_mask);
 	max_lb_iterations = cpumask_weight(env.dst_grpmask);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index fd9db0b..9075faf 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -76,9 +76,10 @@ SCHED_FEAT(WAKE_ON_IDEAL_CPU,		false)
 /* Do the working set probing faults: */
 SCHED_FEAT(NUMA,			true)
 SCHED_FEAT(NUMA_BALANCE_ALL,		false)
-SCHED_FEAT(NUMA_BALANCE_INTERNODE,		false)
+SCHED_FEAT(NUMA_BALANCE_INTERNODE,	false)
 SCHED_FEAT(NUMA_LB,			false)
 SCHED_FEAT(NUMA_GROUP_LB_COMPRESS,	true)
 SCHED_FEAT(NUMA_GROUP_LB_SPREAD,	true)
 SCHED_FEAT(MIGRATE_FAULT_STATS,		false)
+SCHED_FEAT(NUMA_CONVERGE_MIGRATIONS,	true)
 #endif
-- 
1.7.11.7

