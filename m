Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1GRVbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:31:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:33064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1GRVbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:31:36 -0400
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
In-Reply-To: <20110715104547.29c3c509@kryten>
References: <20110707102107.GA16666@in.ibm.com>
	 <1310036375.3282.509.camel@twins> <20110714103418.7ef25b68@kryten>
	 <20110714143521.5fe4fab6@kryten> <1310649379.2586.273.camel@twins>
	 <20110715104547.29c3c509@kryten>
Content-Type: multipart/mixed; boundary="=-L5ZTn8D7MiAAMxopvNMC"
Date: Mon, 18 Jul 2011 23:35:56 +0200
Message-ID: <1311024956.2309.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L5ZTn8D7MiAAMxopvNMC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Anton, could you test the below two patches on that machine?

It should make things boot again, while I don't have a machine nearly
big enough to trigger any of this, I tested the new code paths by
setting FORCE_SD_OVERLAP in /debug/sched_features. Although any review
of the error paths would be much appreciated.

Also, could you send me the node_distance table for that machine? I'm
curious what the interconnects look like on that thing.

--=-L5ZTn8D7MiAAMxopvNMC
Content-Disposition: attachment; filename="sched-domain-foo-1.patch"
Content-Type: text/x-patch; name="sched-domain-foo-1.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Subject: sched: Break out cpu_power from the sched_group structure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jul 14 13:00:06 CEST 2011

In order to prepare for non-unique sched_groups per domain, we need to
carry the cpu_power elsewhere, so put a level of indirection in.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-qkho2byuhe4482fuknss40ad@git.kernel.org
---
 include/linux/sched.h |   14 +++++++++-----
 kernel/sched.c        |   32 ++++++++++++++++++++++++++------
 kernel/sched_fair.c   |   46 +++++++++++++++++++++++-----------------------
 3 files changed, 58 insertions(+), 34 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6550,7 +6550,7 @@ static int sched_domain_debug_one(struct
 			break;
 		}
 
-		if (!group->cpu_power) {
+		if (!group->sgp->power) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -6574,9 +6574,9 @@ static int sched_domain_debug_one(struct
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->cpu_power != SCHED_POWER_SCALE) {
+		if (group->sgp->power != SCHED_POWER_SCALE) {
 			printk(KERN_CONT " (cpu_power = %d)",
-				group->cpu_power);
+				group->sgp->power);
 		}
 
 		group = group->next;
@@ -6770,8 +6770,10 @@ static struct root_domain *alloc_rootdom
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
 
@@ -6938,6 +6940,7 @@ int sched_smt_power_savings = 0, sched_m
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
+	struct sched_group_power **__percpu sgp;
 };
 
 struct s_data {
@@ -6974,8 +6977,10 @@ static int get_group(int cpu, struct sd_
 	if (child)
 		cpu = cpumask_first(sched_domain_span(child));
 
-	if (sg)
+	if (sg) {
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
+		(*sg)->sgp = *per_cpu_ptr(sdd->sgp, cpu);
+	}
 
 	return cpu;
 }
@@ -7013,7 +7018,7 @@ build_sched_groups(struct sched_domain *
 			continue;
 
 		cpumask_clear(sched_group_cpus(sg));
-		sg->cpu_power = 0;
+		sg->sgp->power = 0;
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
@@ -7178,6 +7183,7 @@ static void claim_allocations(int cpu, s
 	if (cpu == cpumask_first(sched_group_cpus(sg))) {
 		WARN_ON_ONCE(*per_cpu_ptr(sdd->sg, cpu) != sg);
 		*per_cpu_ptr(sdd->sg, cpu) = NULL;
+		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 	}
 }
 
@@ -7227,9 +7233,14 @@ static int __sdt_alloc(const struct cpum
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
@@ -7244,6 +7255,13 @@ static int __sdt_alloc(const struct cpum
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
 
@@ -7261,9 +7279,11 @@ static void __sdt_free(const struct cpum
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
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1583,7 +1583,7 @@ find_idlest_group(struct sched_domain *s
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_POWER_SCALE) / group->cpu_power;
+		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -2629,7 +2629,7 @@ static void update_cpu_power(struct sche
 		power >>= SCHED_POWER_SHIFT;
 	}
 
-	sdg->cpu_power_orig = power;
+	sdg->sgp->power_orig = power;
 
 	if (sched_feat(ARCH_POWER))
 		power *= arch_scale_freq_power(sd, cpu);
@@ -2645,7 +2645,7 @@ static void update_cpu_power(struct sche
 		power = 1;
 
 	cpu_rq(cpu)->cpu_power = power;
-	sdg->cpu_power = power;
+	sdg->sgp->power = power;
 }
 
 static void update_group_power(struct sched_domain *sd, int cpu)
@@ -2663,11 +2663,11 @@ static void update_group_power(struct sc
 
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
@@ -2689,7 +2689,7 @@ fix_small_capacity(struct sched_domain *
 	/*
 	 * If ~90% of the cpu_power is still there, we're good.
 	 */
-	if (group->cpu_power * 32 > group->cpu_power_orig * 29)
+	if (group->sgp->power * 32 > group->sgp->power_orig * 29)
 		return 1;
 
 	return 0;
@@ -2769,7 +2769,7 @@ static inline void update_sg_lb_stats(st
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->cpu_power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -2786,7 +2786,7 @@ static inline void update_sg_lb_stats(st
 	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power,
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
 						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
@@ -2875,7 +2875,7 @@ static inline void update_sd_lb_stats(st
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += sg->cpu_power;
+		sds->total_pwr += sg->sgp->power;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -2960,7 +2960,7 @@ static int check_asym_packing(struct sch
 	if (this_cpu > busiest_cpu)
 		return 0;
 
-	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power,
+	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->sgp->power,
 				       SCHED_POWER_SCALE);
 	return 1;
 }
@@ -2991,7 +2991,7 @@ static inline void fix_small_imbalance(s
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
 					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->cpu_power;
+	scaled_busy_load_per_task /= sds->busiest->sgp->power;
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
 			(scaled_busy_load_per_task * imbn)) {
@@ -3005,28 +3005,28 @@ static inline void fix_small_imbalance(s
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
 
@@ -3072,7 +3072,7 @@ static inline void calculate_imbalance(s
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
-		load_above_capacity /= sds->busiest->cpu_power;
+		load_above_capacity /= sds->busiest->sgp->power;
 	}
 
 	/*
@@ -3088,8 +3088,8 @@ static inline void calculate_imbalance(s
 	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
+	*imbalance = min(max_pull * sds->busiest->sgp->power,
+		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
 			/ SCHED_POWER_SCALE;
 
 	/*
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -893,16 +893,20 @@ static inline int sd_power_saving_flags(
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

--=-L5ZTn8D7MiAAMxopvNMC
Content-Disposition: attachment; filename="sched-domain-foo-2.patch"
Content-Type: text/x-patch; name="sched-domain-foo-2.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Subject: sched: Allow for overlapping sched_domain spans
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Jul 15 10:35:52 CEST 2011

Allow for sched_domain spans that overlap by giving such domains their
own sched_group list instead of sharing the sched_groups amongst
each-other.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-yr71izj2souh2dbifdh6j68y@git.kernel.org
---
 include/linux/sched.h   |    2 
 kernel/sched.c          |  157 +++++++++++++++++++++++++++++++++++++++---------
 kernel/sched_features.h |    2 
 3 files changed, 132 insertions(+), 29 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -844,6 +844,7 @@ enum cpu_idle_type {
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
+#define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
@@ -894,6 +895,7 @@ static inline int sd_power_saving_flags(
 }
 
 struct sched_group_power {
+	atomic_t ref;
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6767,10 +6767,36 @@ static struct root_domain *alloc_rootdom
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
-	if (atomic_dec_and_test(&sd->groups->ref)) {
+
+	/*
+	 * If its an overlapping domain it has private groups, iterate and
+	 * nuke them all.
+	 */
+	if (sd->flags & SD_OVERLAP) {
+		free_sched_groups(sd->groups, 1);
+	} else if (atomic_dec_and_test(&sd->groups->ref)) {
 		kfree(sd->groups->sgp);
 		kfree(sd->groups);
 	}
@@ -6960,15 +6986,73 @@ struct sched_domain_topology_level;
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
+		sg = kzalloc_node(sizeof(struct sched_group), GFP_KERNEL,
+				cpu_to_node(i));
+
+		if (!sg)
+			goto fail;
+
+		sg_span = sched_group_cpus(sg);
+
+		child = *per_cpu_ptr(sdd->sd, i);
+		if (child->child) {
+			child = child->child;
+			*sg_span = *sched_domain_span(child);
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
@@ -6980,23 +7064,21 @@ static int get_group(int cpu, struct sd_
 	if (sg) {
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
 		(*sg)->sgp = *per_cpu_ptr(sdd->sgp, cpu);
+		atomic_set(&(*sg)->sgp->ref, 1); /* for claim_allocations */
 	}
 
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
@@ -7004,6 +7086,12 @@ build_sched_groups(struct sched_domain *
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
 
@@ -7035,6 +7123,8 @@ build_sched_groups(struct sched_domain *
 		last = sg;
 	}
 	last->next = first;
+
+	return 0;
 }
 
 /*
@@ -7049,12 +7139,17 @@ build_sched_groups(struct sched_domain *
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
@@ -7175,16 +7270,15 @@ static enum s_alloc __visit_domain_alloc
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
+
+	if (atomic_read(&(*per_cpu_ptr(sdd->sgp, cpu))->ref))
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
-	}
 }
 
 #ifdef CONFIG_SCHED_SMT
@@ -7209,7 +7303,7 @@ static struct sched_domain_topology_leve
 #endif
 	{ sd_init_CPU, cpu_cpu_mask, },
 #ifdef CONFIG_NUMA
-	{ sd_init_NODE, cpu_node_mask, },
+	{ sd_init_NODE, cpu_node_mask, SDTL_OVERLAP, },
 	{ sd_init_ALLNODES, cpu_allnodes_mask, },
 #endif
 	{ NULL, },
@@ -7277,7 +7371,9 @@ static void __sdt_free(const struct cpum
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
-			kfree(*per_cpu_ptr(sdd->sd, j));
+			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
+			if (sd && (sd->flags & SD_OVERLAP))
+				free_sched_groups(sd->groups, 0);
 			kfree(*per_cpu_ptr(sdd->sg, j));
 			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
@@ -7329,8 +7425,11 @@ static int build_sched_domains(const str
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->init; tl++)
+		for (tl = sched_domain_topology; tl->init; tl++) {
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
+				sd->flags |= SD_OVERLAP;
+		}
 
 		while (sd->child)
 			sd = sd->child;
@@ -7342,13 +7441,13 @@ static int build_sched_domains(const str
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
 
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -70,3 +70,5 @@ SCHED_FEAT(NONIRQ_POWER, 1)
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
 SCHED_FEAT(TTWU_QUEUE, 1)
+
+SCHED_FEAT(FORCE_SD_OVERLAP, 0)

--=-L5ZTn8D7MiAAMxopvNMC--

