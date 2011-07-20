Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1GTVHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:07:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1GTVHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:07:32 -0400
Date: Wed, 20 Jul 2011 23:06:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110720210644.GA31617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (3):
      sched: Break out cpu_power from the sched_group structure
      sched: Allow for overlapping sched_domain spans
      sched: Avoid creating superfluous NUMA domains on non-NUMA systems


 include/linux/sched.h   |   14 +++-
 kernel/sched.c          |  189 ++++++++++++++++++++++++++++++++++++++---------
 kernel/sched_fair.c     |   46 ++++++------
 kernel/sched_features.h |    2 +
 4 files changed, 190 insertions(+), 61 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..bde99d5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -844,6 +844,7 @@ enum cpu_idle_type {
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
+#define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
@@ -893,16 +894,21 @@ static inline int sd_power_saving_flags(void)
 	return 0;
 }
 
-struct sched_group {
-	struct sched_group *next;	/* Must be a circular list */
+struct sched_group_power {
 	atomic_t ref;
-
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
index 3dc716f..14168c4 100644
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
@@ -6774,11 +6774,39 @@ static struct root_domain *alloc_rootdomain(void)
 	return rd;
 }
 
+static void free_sched_groups(struct sched_group *sg, int free_sgp)
+{
+	struct sched_group *tmp, *first;
+
+	if (!sg)
+		return;
+
+	first = sg;
+	do {
+		tmp = sg->next;
+
+		if (free_sgp && atomic_dec_and_test(&sg->sgp->ref))
+			kfree(sg->sgp);
+
+		kfree(sg);
+		sg = tmp;
+	} while (sg != first);
+}
+
 static void free_sched_domain(struct rcu_head *rcu)
 {
 	struct sched_domain *sd = container_of(rcu, struct sched_domain, rcu);
-	if (atomic_dec_and_test(&sd->groups->ref))
+
+	/*
+	 * If its an overlapping domain it has private groups, iterate and
+	 * nuke them all.
+	 */
+	if (sd->flags & SD_OVERLAP) {
+		free_sched_groups(sd->groups, 1);
+	} else if (atomic_dec_and_test(&sd->groups->ref)) {
+		kfree(sd->groups->sgp);
 		kfree(sd->groups);
+	}
 	kfree(sd);
 }
 
@@ -6945,6 +6973,7 @@ int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
+	struct sched_group_power **__percpu sgp;
 };
 
 struct s_data {
@@ -6964,15 +6993,73 @@ struct sched_domain_topology_level;
 typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
+#define SDTL_OVERLAP	0x01
+
 struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
+	int		    flags;
 	struct sd_data      data;
 };
 
-/*
- * Assumes the sched_domain tree is fully constructed
- */
+static int
+build_overlap_sched_groups(struct sched_domain *sd, int cpu)
+{
+	struct sched_group *first = NULL, *last = NULL, *groups = NULL, *sg;
+	const struct cpumask *span = sched_domain_span(sd);
+	struct cpumask *covered = sched_domains_tmpmask;
+	struct sd_data *sdd = sd->private;
+	struct sched_domain *child;
+	int i;
+
+	cpumask_clear(covered);
+
+	for_each_cpu(i, span) {
+		struct cpumask *sg_span;
+
+		if (cpumask_test_cpu(i, covered))
+			continue;
+
+		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
+				GFP_KERNEL, cpu_to_node(i));
+
+		if (!sg)
+			goto fail;
+
+		sg_span = sched_group_cpus(sg);
+
+		child = *per_cpu_ptr(sdd->sd, i);
+		if (child->child) {
+			child = child->child;
+			cpumask_copy(sg_span, sched_domain_span(child));
+		} else
+			cpumask_set_cpu(i, sg_span);
+
+		cpumask_or(covered, covered, sg_span);
+
+		sg->sgp = *per_cpu_ptr(sdd->sgp, cpumask_first(sg_span));
+		atomic_inc(&sg->sgp->ref);
+
+		if (cpumask_test_cpu(cpu, sg_span))
+			groups = sg;
+
+		if (!first)
+			first = sg;
+		if (last)
+			last->next = sg;
+		last = sg;
+		last->next = first;
+	}
+	sd->groups = groups;
+
+	return 0;
+
+fail:
+	free_sched_groups(first, 0);
+
+	return -ENOMEM;
+}
+
 static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 {
 	struct sched_domain *sd = *per_cpu_ptr(sdd->sd, cpu);
@@ -6981,24 +7068,24 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 	if (child)
 		cpu = cpumask_first(sched_domain_span(child));
 
-	if (sg)
+	if (sg) {
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
+		(*sg)->sgp = *per_cpu_ptr(sdd->sgp, cpu);
+		atomic_set(&(*sg)->sgp->ref, 1); /* for claim_allocations */
+	}
 
 	return cpu;
 }
 
 /*
- * build_sched_groups takes the cpumask we wish to span, and a pointer
- * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
- * (due to the fact that we keep track of groups covered with a struct cpumask).
- *
  * build_sched_groups will build a circular linked list of the groups
  * covered by the given span, and will set each group's ->cpumask correctly,
  * and ->cpu_power to 0.
+ *
+ * Assumes the sched_domain tree is fully constructed
  */
-static void
-build_sched_groups(struct sched_domain *sd)
+static int
+build_sched_groups(struct sched_domain *sd, int cpu)
 {
 	struct sched_group *first = NULL, *last = NULL;
 	struct sd_data *sdd = sd->private;
@@ -7006,6 +7093,12 @@ build_sched_groups(struct sched_domain *sd)
 	struct cpumask *covered;
 	int i;
 
+	get_group(cpu, sdd, &sd->groups);
+	atomic_inc(&sd->groups->ref);
+
+	if (cpu != cpumask_first(sched_domain_span(sd)))
+		return 0;
+
 	lockdep_assert_held(&sched_domains_mutex);
 	covered = sched_domains_tmpmask;
 
@@ -7020,7 +7113,7 @@ build_sched_groups(struct sched_domain *sd)
 			continue;
 
 		cpumask_clear(sched_group_cpus(sg));
-		sg->cpu_power = 0;
+		sg->sgp->power = 0;
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
@@ -7037,6 +7130,8 @@ build_sched_groups(struct sched_domain *sd)
 		last = sg;
 	}
 	last->next = first;
+
+	return 0;
 }
 
 /*
@@ -7051,12 +7146,17 @@ build_sched_groups(struct sched_domain *sd)
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
-	WARN_ON(!sd || !sd->groups);
+	struct sched_group *sg = sd->groups;
 
-	if (cpu != group_first_cpu(sd->groups))
-		return;
+	WARN_ON(!sd || !sg);
 
-	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
+	do {
+		sg->group_weight = cpumask_weight(sched_group_cpus(sg));
+		sg = sg->next;
+	} while (sg != sd->groups);
+
+	if (cpu != group_first_cpu(sg))
+		return;
 
 	update_group_power(sd, cpu);
 }
@@ -7177,15 +7277,15 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 static void claim_allocations(int cpu, struct sched_domain *sd)
 {
 	struct sd_data *sdd = sd->private;
-	struct sched_group *sg = sd->groups;
 
 	WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, cpu) != sd);
 	*per_cpu_ptr(sdd->sd, cpu) = NULL;
 
-	if (cpu == cpumask_first(sched_group_cpus(sg))) {
-		WARN_ON_ONCE(*per_cpu_ptr(sdd->sg, cpu) != sg);
+	if (atomic_read(&(*per_cpu_ptr(sdd->sg, cpu))->ref))
 		*per_cpu_ptr(sdd->sg, cpu) = NULL;
-	}
+
+	if (atomic_read(&(*per_cpu_ptr(sdd->sgp, cpu))->ref))
+		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 }
 
 #ifdef CONFIG_SCHED_SMT
@@ -7210,7 +7310,7 @@ static struct sched_domain_topology_level default_topology[] = {
 #endif
 	{ sd_init_CPU, cpu_cpu_mask, },
 #ifdef CONFIG_NUMA
-	{ sd_init_NODE, cpu_node_mask, },
+	{ sd_init_NODE, cpu_node_mask, SDTL_OVERLAP, },
 	{ sd_init_ALLNODES, cpu_allnodes_mask, },
 #endif
 	{ NULL, },
@@ -7234,9 +7334,14 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
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
@@ -7251,6 +7356,13 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
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
 
@@ -7266,11 +7378,15 @@ static void __sdt_free(const struct cpumask *cpu_map)
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
-			kfree(*per_cpu_ptr(sdd->sd, j));
+			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
+			if (sd && (sd->flags & SD_OVERLAP))
+				free_sched_groups(sd->groups, 0);
 			kfree(*per_cpu_ptr(sdd->sg, j));
+			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
 		free_percpu(sdd->sd);
 		free_percpu(sdd->sg);
+		free_percpu(sdd->sgp);
 	}
 }
 
@@ -7316,8 +7432,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->init; tl++)
+		for (tl = sched_domain_topology; tl->init; tl++) {
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
+				sd->flags |= SD_OVERLAP;
+			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
+				break;
+		}
 
 		while (sd->child)
 			sd = sd->child;
@@ -7329,13 +7450,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 	for_each_cpu(i, cpu_map) {
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
 			sd->span_weight = cpumask_weight(sched_domain_span(sd));
-			get_group(i, sd->private, &sd->groups);
-			atomic_inc(&sd->groups->ref);
-
-			if (i != cpumask_first(sched_domain_span(sd)))
-				continue;
-
-			build_sched_groups(sd);
+			if (sd->flags & SD_OVERLAP) {
+				if (build_overlap_sched_groups(sd, i))
+					goto error;
+			} else {
+				if (build_sched_groups(sd, i))
+					goto error;
+			}
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
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index be40f73..1e7066d 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -70,3 +70,5 @@ SCHED_FEAT(NONIRQ_POWER, 1)
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
 SCHED_FEAT(TTWU_QUEUE, 1)
+
+SCHED_FEAT(FORCE_SD_OVERLAP, 0)
