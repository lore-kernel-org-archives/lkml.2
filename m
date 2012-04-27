Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2D0GjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:39:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45551 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2D0GjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:39:17 -0400
Date: Fri, 27 Apr 2012 08:39:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120427063912.GA24047@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: fb2cf2c660971bea0ad86a9a5c19ad39eab61344 sched: Fix OOPS when build_sched_domains() percpu allocation fails

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched: Fix more load-balancing fallout

he, bo (1):
      sched: Fix OOPS when build_sched_domains() percpu allocation fails


 kernel/sched/core.c     |   22 ++++++++++++++++------
 kernel/sched/fair.c     |   18 ++++++++++--------
 kernel/sched/features.h |    1 +
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4603b9d..0533a68 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6405,16 +6405,26 @@ static void __sdt_free(const struct cpumask *cpu_map)
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
-			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
-			if (sd && (sd->flags & SD_OVERLAP))
-				free_sched_groups(sd->groups, 0);
-			kfree(*per_cpu_ptr(sdd->sd, j));
-			kfree(*per_cpu_ptr(sdd->sg, j));
-			kfree(*per_cpu_ptr(sdd->sgp, j));
+			struct sched_domain *sd;
+
+			if (sdd->sd) {
+				sd = *per_cpu_ptr(sdd->sd, j);
+				if (sd && (sd->flags & SD_OVERLAP))
+					free_sched_groups(sd->groups, 0);
+				kfree(*per_cpu_ptr(sdd->sd, j));
+			}
+
+			if (sdd->sg)
+				kfree(*per_cpu_ptr(sdd->sg, j));
+			if (sdd->sgp)
+				kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
 		free_percpu(sdd->sd);
+		sdd->sd = NULL;
 		free_percpu(sdd->sg);
+		sdd->sg = NULL;
 		free_percpu(sdd->sgp);
+		sdd->sgp = NULL;
 	}
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0d97ebd..e955364 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -784,7 +784,7 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
 	if (entity_is_task(se))
-		list_add_tail(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
 #endif
 	cfs_rq->nr_running++;
 }
@@ -3215,6 +3215,8 @@ static int move_one_task(struct lb_env *env)
 
 static unsigned long task_h_load(struct task_struct *p);
 
+static const unsigned int sched_nr_migrate_break = 32;
+
 /*
  * move_tasks tries to move up to load_move weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
@@ -3242,7 +3244,7 @@ static int move_tasks(struct lb_env *env)
 
 		/* take a breather every nr_migrate tasks */
 		if (env->loop > env->loop_break) {
-			env->loop_break += sysctl_sched_nr_migrate;
+			env->loop_break += sched_nr_migrate_break;
 			env->flags |= LBF_NEED_BREAK;
 			break;
 		}
@@ -3252,7 +3254,7 @@ static int move_tasks(struct lb_env *env)
 
 		load = task_h_load(p);
 
-		if (load < 16 && !env->sd->nr_balance_failed)
+		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
 		if ((load / 2) > env->load_move)
@@ -4407,7 +4409,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.dst_cpu	= this_cpu,
 		.dst_rq		= this_rq,
 		.idle		= idle,
-		.loop_break	= sysctl_sched_nr_migrate,
+		.loop_break	= sched_nr_migrate_break,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4445,10 +4447,10 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.load_move = imbalance;
-		env.src_cpu = busiest->cpu;
-		env.src_rq = busiest;
-		env.loop_max = busiest->nr_running;
+		env.load_move	= imbalance;
+		env.src_cpu	= busiest->cpu;
+		env.src_rq	= busiest;
+		env.loop_max	= min_t(unsigned long, sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
 		local_irq_save(flags);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index e61fd73..de00a48 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -68,3 +68,4 @@ SCHED_FEAT(TTWU_QUEUE, true)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(LB_MIN, false)
