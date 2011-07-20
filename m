Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1GTR3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:29:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:58025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab1GTR3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:29:21 -0400
Date: Wed, 20 Jul 2011 17:28:43 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-qkho2byuhe4482fuknss40ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Break out cpu_power from the sched_group structure
Git-Commit-ID: 9c3f75cbd144014bea6af866a154cc2e73ab2287
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jul 2011 17:28:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c3f75cbd144014bea6af866a154cc2e73ab2287
Gitweb:     http://git.kernel.org/tip/9c3f75cbd144014bea6af866a154cc2e73ab2287
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Jul 2011 13:00:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jul 2011 18:32:40 +0200

sched: Break out cpu_power from the sched_group structure

In order to prepare for non-unique sched_groups per domain, we need to
carry the cpu_power elsewhere, so put a level of indirection in.

Reported-and-tested-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-qkho2byuhe4482fuknss40ad@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   14 +++++++++-----
 kernel/sched.c        |   32 ++++++++++++++++++++++++++------
 kernel/sched_fair.c   |   46 +++++++++++++++++++++++-----------------------
 3 files changed, 58 insertions(+), 34 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..2e5b3c8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -893,16 +893,20 @@ static inline int sd_power_saving_flags(void)
 	return 0;
 }
 
-struct sched_group {
-	struct sched_group *next;	/* Must be a circular list */
-	atomic_t ref;
-
+struct sched_group_power {
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
 	 */
-	unsigned int cpu_power, cpu_power_orig;
+	unsigned int power, power_orig;
+};
+
+struct sched_group {
+	struct sched_group *next;	/* Must be a circular list */
+	atomic_t ref;
+
 	unsigned int group_weight;
+	struct sched_group_power *sgp;
 
 	/*
 	 * The CPUs this group covers.
diff --git a/kernel/sched.c b/kernel/sched.c
index 3dc716f..36c10d2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6557,7 +6557,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (!group->cpu_power) {
+		if (!group->sgp->power) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -6581,9 +6581,9 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->cpu_power != SCHED_POWER_SCALE) {
+		if (group->sgp->power != SCHED_POWER_SCALE) {
 			printk(KERN_CONT " (cpu_power = %d)",
-				group->cpu_power);
+				group->sgp->power);
 		}
 
 		group = group->next;
@@ -6777,8 +6777,10 @@ static struct root_domain *alloc_rootdomain(void)
 static void free_sched_domain(struct rcu_head *rcu)
 {
 	struct sched_domain *sd = container_of(rcu, struct sched_domain, rcu);
-	if (atomic_dec_and_test(&sd->groups->ref))
+	if (atomic_dec_and_test(&sd->groups->ref)) {
+		kfree(sd->groups->sgp);
 		kfree(sd->groups);
+	}
 	kfree(sd);
 }
 
@@ -6945,6 +6947,7 @@ int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
+	struct sched_group_power **__percpu sgp;
 };
 
 struct s_data {
@@ -6981,8 +6984,10 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 	if (child)
 		cpu = cpumask_first(sched_domain_span(child));
 
-	if (sg)
+	if (sg) {
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
+		(*sg)->sgp = *per_cpu_ptr(sdd->sgp, cpu);
+	}
 
 	return cpu;
 }
@@ -7020,7 +7025,7 @@ build_sched_groups(struct sched_domain *sd)
 			continue;
 
 		cpumask_clear(sched_group_cpus(sg));
-		sg->cpu_power = 0;
+		sg->sgp->power = 0;
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
@@ -7185,6 +7190,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 	if (cpu == cpumask_first(sched_group_cpus(sg))) {
 		WARN_ON_ONCE(*per_cpu_ptr(sdd->sg, cpu) != sg);
 		*per_cpu_ptr(sdd->sg, cpu) = NULL;
+		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 	}
 }
 
@@ -7234,9 +7240,14 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 		if (!sdd->sg)
 			return -ENOMEM;
 
+		sdd->sgp = alloc_percpu(struct sched_group_power *);
+		if (!sdd->sgp)
+			return -ENOMEM;
+
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
 			struct sched_group *sg;
+			struct sched_group_power *sgp;
 
 		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
@@ -7251,6 +7262,13 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sg, j) = sg;
+
+			sgp = kzalloc_node(sizeof(struct sched_group_power),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sgp)
+				return -ENOMEM;
+
+			*per_cpu_ptr(sdd->sgp, j) = sgp;
 		}
 	}
 
@@ -7268,9 +7286,11 @@ static void __sdt_free(const struct cpumask *cpu_map)
 		for_each_cpu(j, cpu_map) {
 			kfree(*per_cpu_ptr(sdd->sd, j));
 			kfree(*per_cpu_ptr(sdd->sg, j));
+			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
 		free_percpu(sdd->sd);
 		free_percpu(sdd->sg);
+		free_percpu(sdd->sgp);
 	}
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..c768588 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1585,7 +1585,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_POWER_SCALE) / group->cpu_power;
+		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -2631,7 +2631,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		power >>= SCHED_POWER_SHIFT;
 	}
 
-	sdg->cpu_power_orig = power;
+	sdg->sgp->power_orig = power;
 
 	if (sched_feat(ARCH_POWER))
 		power *= arch_scale_freq_power(sd, cpu);
@@ -2647,7 +2647,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		power = 1;
 
 	cpu_rq(cpu)->cpu_power = power;
-	sdg->cpu_power = power;
+	sdg->sgp->power = power;
 }
 
 static void update_group_power(struct sched_domain *sd, int cpu)
@@ -2665,11 +2665,11 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 
 	group = child->groups;
 	do {
-		power += group->cpu_power;
+		power += group->sgp->power;
 		group = group->next;
 	} while (group != child->groups);
 
-	sdg->cpu_power = power;
+	sdg->sgp->power = power;
 }
 
 /*
@@ -2691,7 +2691,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	/*
 	 * If ~90% of the cpu_power is still there, we're good.
 	 */
-	if (group->cpu_power * 32 > group->cpu_power_orig * 29)
+	if (group->sgp->power * 32 > group->sgp->power_orig * 29)
 		return 1;
 
 	return 0;
@@ -2771,7 +2771,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->cpu_power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -2788,7 +2788,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power,
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
 						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
@@ -2877,7 +2877,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += sg->cpu_power;
+		sds->total_pwr += sg->sgp->power;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -2962,7 +2962,7 @@ static int check_asym_packing(struct sched_domain *sd,
 	if (this_cpu > busiest_cpu)
 		return 0;
 
-	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power,
+	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->sgp->power,
 				       SCHED_POWER_SCALE);
 	return 1;
 }
@@ -2993,7 +2993,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
 					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->cpu_power;
+	scaled_busy_load_per_task /= sds->busiest->sgp->power;
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
 			(scaled_busy_load_per_task * imbn)) {
@@ -3007,28 +3007,28 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 	 * moving them.
 	 */
 
-	pwr_now += sds->busiest->cpu_power *
+	pwr_now += sds->busiest->sgp->power *
 			min(sds->busiest_load_per_task, sds->max_load);
-	pwr_now += sds->this->cpu_power *
+	pwr_now += sds->this->sgp->power *
 			min(sds->this_load_per_task, sds->this_load);
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
 	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->cpu_power;
+		sds->busiest->sgp->power;
 	if (sds->max_load > tmp)
-		pwr_move += sds->busiest->cpu_power *
+		pwr_move += sds->busiest->sgp->power *
 			min(sds->busiest_load_per_task, sds->max_load - tmp);
 
 	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->cpu_power <
+	if (sds->max_load * sds->busiest->sgp->power <
 		sds->busiest_load_per_task * SCHED_POWER_SCALE)
-		tmp = (sds->max_load * sds->busiest->cpu_power) /
-			sds->this->cpu_power;
+		tmp = (sds->max_load * sds->busiest->sgp->power) /
+			sds->this->sgp->power;
 	else
 		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-			sds->this->cpu_power;
-	pwr_move += sds->this->cpu_power *
+			sds->this->sgp->power;
+	pwr_move += sds->this->sgp->power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
@@ -3074,7 +3074,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
-		load_above_capacity /= sds->busiest->cpu_power;
+		load_above_capacity /= sds->busiest->sgp->power;
 	}
 
 	/*
@@ -3090,8 +3090,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
+	*imbalance = min(max_pull * sds->busiest->sgp->power,
+		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
 			/ SCHED_POWER_SCALE;
 
 	/*
