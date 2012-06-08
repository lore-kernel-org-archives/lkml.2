Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab2FHU3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:29:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37387 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934249Ab2FHU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:29:09 -0400
Date: Fri, 8 Jun 2012 22:29:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120608202904.GA21894@gmail.com>
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

   HEAD: a841f8cef4bb124f0f5563314d0beaf2e1249d72 sched: Fix the relax_domain_level boot parameter

 Thanks,

	Ingo

------------------>
Alex Shi (1):
      sched/numa: Load balance between remote nodes

Dimitri Sivanich (1):
      sched: Fix the relax_domain_level boot parameter

Kamalesh Babulal (1):
      sched/x86: Calculate booted cores after construction of sibling_mask

Peter Zijlstra (4):
      sched/rt: Fix lockdep annotation within find_lock_lowest_rq()
      sched: Fix domain iteration
      sched: Always initialize cpu-power
      sched: Validate assumptions in sched_init_numa()


 arch/x86/kernel/smpboot.c |   9 +++
 include/linux/sched.h     |  11 +++
 kernel/sched/core.c       | 187 +++++++++++++++++++++++++++++++++++++---------
 kernel/sched/fair.c       |   7 +-
 kernel/sched/rt.c         |   2 +-
 kernel/sched/sched.h      |   2 +
 6 files changed, 179 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fd019d7..3fab55b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -382,6 +382,15 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		if ((i == cpu) || (has_mc && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);
 
+	}
+
+	/*
+	 * This needs a separate iteration over the cpus because we rely on all
+	 * cpu_sibling_mask links to be set-up.
+	 */
+	for_each_cpu(i, cpu_sibling_setup_mask) {
+		o = &cpu_data(i);
+
 		if ((i == cpu) || (has_mc && match_mc(c, o))) {
 			link_mask(core, cpu, i);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6029d8c..ac321d7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -876,6 +876,8 @@ struct sched_group_power {
 	 * Number of busy cpus in this group.
 	 */
 	atomic_t nr_busy_cpus;
+
+	unsigned long cpumask[0]; /* iteration mask */
 };
 
 struct sched_group {
@@ -900,6 +902,15 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 	return to_cpumask(sg->cpumask);
 }
 
+/*
+ * cpumask masking which cpus in the group are allowed to iterate up the domain
+ * tree.
+ */
+static inline struct cpumask *sched_group_mask(struct sched_group *sg)
+{
+	return to_cpumask(sg->sgp->cpumask);
+}
+
 /**
  * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
  * @group: The group whose first cpu is to be returned.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c46958e..d5594a4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5556,15 +5556,20 @@ static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
 
 #ifdef CONFIG_SCHED_DEBUG
 
-static __read_mostly int sched_domain_debug_enabled;
+static __read_mostly int sched_debug_enabled;
 
-static int __init sched_domain_debug_setup(char *str)
+static int __init sched_debug_setup(char *str)
 {
-	sched_domain_debug_enabled = 1;
+	sched_debug_enabled = 1;
 
 	return 0;
 }
-early_param("sched_debug", sched_domain_debug_setup);
+early_param("sched_debug", sched_debug_setup);
+
+static inline bool sched_debug(void)
+{
+	return sched_debug_enabled;
+}
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
@@ -5604,7 +5609,12 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (!group->sgp->power) {
+		/*
+		 * Even though we initialize ->power to something semi-sane,
+		 * we leave power_orig unset. This allows us to detect if
+		 * domain iteration is still funny without causing /0 traps.
+		 */
+		if (!group->sgp->power_orig) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -5652,7 +5662,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
 	int level = 0;
 
-	if (!sched_domain_debug_enabled)
+	if (!sched_debug_enabled)
 		return;
 
 	if (!sd) {
@@ -5673,6 +5683,10 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
+static inline bool sched_debug(void)
+{
+	return false;
+}
 #endif /* CONFIG_SCHED_DEBUG */
 
 static int sd_degenerate(struct sched_domain *sd)
@@ -5994,6 +6008,44 @@ struct sched_domain_topology_level {
 	struct sd_data      data;
 };
 
+/*
+ * Build an iteration mask that can exclude certain CPUs from the upwards
+ * domain traversal.
+ *
+ * Asymmetric node setups can result in situations where the domain tree is of
+ * unequal depth, make sure to skip domains that already cover the entire
+ * range.
+ *
+ * In that case build_sched_domains() will have terminated the iteration early
+ * and our sibling sd spans will be empty. Domains should always include the
+ * cpu they're built on, so check that.
+ *
+ */
+static void build_group_mask(struct sched_domain *sd, struct sched_group *sg)
+{
+	const struct cpumask *span = sched_domain_span(sd);
+	struct sd_data *sdd = sd->private;
+	struct sched_domain *sibling;
+	int i;
+
+	for_each_cpu(i, span) {
+		sibling = *per_cpu_ptr(sdd->sd, i);
+		if (!cpumask_test_cpu(i, sched_domain_span(sibling)))
+			continue;
+
+		cpumask_set_cpu(i, sched_group_mask(sg));
+	}
+}
+
+/*
+ * Return the canonical balance cpu for this group, this is the first cpu
+ * of this group that's also in the iteration mask.
+ */
+int group_balance_cpu(struct sched_group *sg)
+{
+	return cpumask_first_and(sched_group_cpus(sg), sched_group_mask(sg));
+}
+
 static int
 build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 {
@@ -6012,6 +6064,12 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
+		child = *per_cpu_ptr(sdd->sd, i);
+
+		/* See the comment near build_group_mask(). */
+		if (!cpumask_test_cpu(i, sched_domain_span(child)))
+			continue;
+
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
 				GFP_KERNEL, cpu_to_node(cpu));
 
@@ -6019,8 +6077,6 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			goto fail;
 
 		sg_span = sched_group_cpus(sg);
-
-		child = *per_cpu_ptr(sdd->sd, i);
 		if (child->child) {
 			child = child->child;
 			cpumask_copy(sg_span, sched_domain_span(child));
@@ -6030,13 +6086,24 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		cpumask_or(covered, covered, sg_span);
 
 		sg->sgp = *per_cpu_ptr(sdd->sgp, i);
-		atomic_inc(&sg->sgp->ref);
+		if (atomic_inc_return(&sg->sgp->ref) == 1)
+			build_group_mask(sd, sg);
 
+		/*
+		 * Initialize sgp->power such that even if we mess up the
+		 * domains and no possible iteration will get us here, we won't
+		 * die on a /0 trap.
+		 */
+		sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);
+
+		/*
+		 * Make sure the first group of this domain contains the
+		 * canonical balance cpu. Otherwise the sched_domain iteration
+		 * breaks. See update_sg_lb_stats().
+		 */
 		if ((!groups && cpumask_test_cpu(cpu, sg_span)) ||
-			       cpumask_first(sg_span) == cpu) {
-			WARN_ON_ONCE(!cpumask_test_cpu(cpu, sg_span));
+		    group_balance_cpu(sg) == cpu)
 			groups = sg;
-		}
 
 		if (!first)
 			first = sg;
@@ -6109,6 +6176,7 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
+		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
@@ -6150,7 +6218,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		sg = sg->next;
 	} while (sg != sd->groups);
 
-	if (cpu != group_first_cpu(sg))
+	if (cpu != group_balance_cpu(sg))
 		return;
 
 	update_group_power(sd, cpu);
@@ -6200,11 +6268,8 @@ int sched_domain_level_max;
 
 static int __init setup_relax_domain_level(char *str)
 {
-	unsigned long val;
-
-	val = simple_strtoul(str, NULL, 0);
-	if (val < sched_domain_level_max)
-		default_relax_domain_level = val;
+	if (kstrtoint(str, 0, &default_relax_domain_level))
+		pr_warn("Unable to set relax_domain_level\n");
 
 	return 1;
 }
@@ -6314,14 +6379,13 @@ static struct sched_domain_topology_level *sched_domain_topology = default_topol
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
-static int sched_domains_numa_scale;
 static int *sched_domains_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
 
 static inline int sd_local_flags(int level)
 {
-	if (sched_domains_numa_distance[level] > REMOTE_DISTANCE)
+	if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
 		return 0;
 
 	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
@@ -6379,6 +6443,42 @@ static const struct cpumask *sd_numa_mask(int cpu)
 	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
 }
 
+static void sched_numa_warn(const char *str)
+{
+	static int done = false;
+	int i,j;
+
+	if (done)
+		return;
+
+	done = true;
+
+	printk(KERN_WARNING "ERROR: %s\n\n", str);
+
+	for (i = 0; i < nr_node_ids; i++) {
+		printk(KERN_WARNING "  ");
+		for (j = 0; j < nr_node_ids; j++)
+			printk(KERN_CONT "%02d ", node_distance(i,j));
+		printk(KERN_CONT "\n");
+	}
+	printk(KERN_WARNING "\n");
+}
+
+static bool find_numa_distance(int distance)
+{
+	int i;
+
+	if (distance == node_distance(0, 0))
+		return true;
+
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		if (sched_domains_numa_distance[i] == distance)
+			return true;
+	}
+
+	return false;
+}
+
 static void sched_init_numa(void)
 {
 	int next_distance, curr_distance = node_distance(0, 0);
@@ -6386,7 +6486,6 @@ static void sched_init_numa(void)
 	int level = 0;
 	int i, j, k;
 
-	sched_domains_numa_scale = curr_distance;
 	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
 	if (!sched_domains_numa_distance)
 		return;
@@ -6397,23 +6496,41 @@ static void sched_init_numa(void)
 	 *
 	 * Assumes node_distance(0,j) includes all distances in
 	 * node_distance(i,j) in order to avoid cubic time.
-	 *
-	 * XXX: could be optimized to O(n log n) by using sort()
 	 */
 	next_distance = curr_distance;
 	for (i = 0; i < nr_node_ids; i++) {
 		for (j = 0; j < nr_node_ids; j++) {
-			int distance = node_distance(0, j);
-			if (distance > curr_distance &&
-					(distance < next_distance ||
-					 next_distance == curr_distance))
-				next_distance = distance;
+			for (k = 0; k < nr_node_ids; k++) {
+				int distance = node_distance(i, k);
+
+				if (distance > curr_distance &&
+				    (distance < next_distance ||
+				     next_distance == curr_distance))
+					next_distance = distance;
+
+				/*
+				 * While not a strong assumption it would be nice to know
+				 * about cases where if node A is connected to B, B is not
+				 * equally connected to A.
+				 */
+				if (sched_debug() && node_distance(k, i) != distance)
+					sched_numa_warn("Node-distance not symmetric");
+
+				if (sched_debug() && i && !find_numa_distance(distance))
+					sched_numa_warn("Node-0 not representative");
+			}
+			if (next_distance != curr_distance) {
+				sched_domains_numa_distance[level++] = next_distance;
+				sched_domains_numa_levels = level;
+				curr_distance = next_distance;
+			} else break;
 		}
-		if (next_distance != curr_distance) {
-			sched_domains_numa_distance[level++] = next_distance;
-			sched_domains_numa_levels = level;
-			curr_distance = next_distance;
-		} else break;
+
+		/*
+		 * In case of sched_debug() we verify the above assumption.
+		 */
+		if (!sched_debug())
+			break;
 	}
 	/*
 	 * 'level' contains the number of unique distances, excluding the
@@ -6525,7 +6642,7 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
-			sgp = kzalloc_node(sizeof(struct sched_group_power),
+			sgp = kzalloc_node(sizeof(struct sched_group_power) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
 			if (!sgp)
 				return -ENOMEM;
@@ -6578,7 +6695,6 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 	if (!sd)
 		return child;
 
-	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
 	if (child) {
 		sd->level = child->level + 1;
@@ -6586,6 +6702,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		child->parent = sd;
 	}
 	sd->child = child;
+	set_domain_attribute(sd, attr);
 
 	return sd;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b2a2d23..c9fd6d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3602,7 +3602,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		} while (group != child->groups);
 	}
 
-	sdg->sgp->power = power;
+	sdg->sgp->power_orig = sdg->sgp->power = power;
 }
 
 /*
@@ -3652,7 +3652,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	int i;
 
 	if (local_group)
-		balance_cpu = group_first_cpu(group);
+		balance_cpu = group_balance_cpu(group);
 
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
@@ -3667,7 +3667,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu) {
+			if (idle_cpu(i) && !first_idle_cpu &&
+					cpumask_test_cpu(i, sched_group_mask(group))) {
 				first_idle_cpu = 1;
 				balance_cpu = i;
 			}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2a4e8df..573e1ca 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1562,7 +1562,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 				     task_running(rq, task) ||
 				     !task->on_rq)) {
 
-				raw_spin_unlock(&lowest_rq->lock);
+				double_unlock_balance(rq, lowest_rq);
 				lowest_rq = NULL;
 				break;
 			}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ba9dccf..6d52cea 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -526,6 +526,8 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_id);
 
+extern int group_balance_cpu(struct sched_group *sg);
+
 #endif /* CONFIG_SMP */
 
 #include "stats.h"
