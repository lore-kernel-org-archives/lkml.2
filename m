Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1DGMm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:42:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab1DGMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:56 -0400
Message-Id: <20110407122942.245307941@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:50 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/23] sched: Dynamically allocate sched_domain/sched_group data-structures
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of relying on static allocations for the sched_domain and
sched_group trees, dynamically allocate and RCU free them.

Allocating this dynamically also allows for some build_sched_groups()
simplification since we can now (like with other simplifications) rely
on the sched_domain tree instead of hard-coded knowledge.

One tricky to note is that detach_destroy_domains() needs to hold
rcu_read_lock() over the entire tear-down, per-cpu is not sufficient
since that can lead to partial sched_group existance (could possibly
be solved by doing the tear-down backwards but this is much more
robust).

A concequence of the above is that we can no longer print the
sched_domain debug stuff from cpu_attach_domain() since that might now
run with preemption disabled (due to classic RCU etc.) and
sched_domain_debug() does some GFP_KERNEL allocations.

Another thing to note is that we now fully rely on normal RCU and not
RCU-sched, this is because with the new and exiting RCU flavours we
grew over the years BH doesn't necessarily hold off RCU-sched grace
periods (-rt is known to break this). This would in fact already cause
us grief since we do sched_domain/sched_group iterations from softirq
context.

This patch is somewhat larger than I would like it to be, but I didn't
find any means of shrinking/splitting this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    5 
 kernel/sched.c        |  480 +++++++++++++++++++-------------------------------
 kernel/sched_fair.c   |   30 ++-
 3 files changed, 219 insertions(+), 296 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -868,6 +868,7 @@ static inline int sd_power_saving_flags(
 
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
+	atomic_t ref;
 
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
@@ -973,6 +974,10 @@ struct sched_domain {
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
 #endif
+	union {
+		void *private;		/* used during construction */
+		struct rcu_head rcu;	/* used during destruction */
+	};
 
 	unsigned int span_weight;
 	/*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -417,6 +417,7 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
+	struct rcu_head rcu;
 	cpumask_var_t span;
 	cpumask_var_t online;
 
@@ -571,7 +572,7 @@ static inline int cpu_of(struct rq *rq)
 
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
-			      rcu_read_lock_sched_held() || \
+			      rcu_read_lock_held() || \
 			      lockdep_is_held(&sched_domains_mutex))
 
 /*
@@ -6558,12 +6559,11 @@ sd_parent_degenerate(struct sched_domain
 	return 1;
 }
 
-static void free_rootdomain(struct root_domain *rd)
+static void free_rootdomain(struct rcu_head *rcu)
 {
-	synchronize_sched();
+	struct root_domain *rd = container_of(rcu, struct root_domain, rcu);
 
 	cpupri_cleanup(&rd->cpupri);
-
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
 	free_cpumask_var(rd->span);
@@ -6604,7 +6604,7 @@ static void rq_attach_root(struct rq *rq
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	if (old_rd)
-		free_rootdomain(old_rd);
+		call_rcu_sched(&old_rd->rcu, free_rootdomain);
 }
 
 static int init_rootdomain(struct root_domain *rd)
@@ -6655,6 +6655,25 @@ static struct root_domain *alloc_rootdom
 	return rd;
 }
 
+static void free_sched_domain(struct rcu_head *rcu)
+{
+	struct sched_domain *sd = container_of(rcu, struct sched_domain, rcu);
+	if (atomic_dec_and_test(&sd->groups->ref))
+		kfree(sd->groups);
+	kfree(sd);
+}
+
+static void destroy_sched_domain(struct sched_domain *sd, int cpu)
+{
+	call_rcu(&sd->rcu, free_sched_domain);
+}
+
+static void destroy_sched_domains(struct sched_domain *sd, int cpu)
+{
+	for (; sd; sd = sd->parent)
+		destroy_sched_domain(sd, cpu);
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -6675,20 +6694,25 @@ cpu_attach_domain(struct sched_domain *s
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
+			destroy_sched_domain(parent, cpu);
 		} else
 			tmp = tmp->parent;
 	}
 
 	if (sd && sd_degenerate(sd)) {
+		tmp = sd;
 		sd = sd->parent;
+		destroy_sched_domain(tmp, cpu);
 		if (sd)
 			sd->child = NULL;
 	}
 
-	sched_domain_debug(sd, cpu);
+//	sched_domain_debug(sd, cpu);
 
 	rq_attach_root(rq, rd);
+	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
+	destroy_sched_domains(tmp, cpu);
 }
 
 /* cpus with isolated domains */
@@ -6704,56 +6728,6 @@ static int __init isolated_cpu_setup(cha
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-/*
- * init_sched_build_groups takes the cpumask we wish to span, and a pointer
- * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
- * (due to the fact that we keep track of groups covered with a struct cpumask).
- *
- * init_sched_build_groups will build a circular linked list of the groups
- * covered by the given span, and will set each group's ->cpumask correctly,
- * and ->cpu_power to 0.
- */
-static void
-init_sched_build_groups(const struct cpumask *span,
-			const struct cpumask *cpu_map,
-			int (*group_fn)(int cpu, const struct cpumask *cpu_map,
-					struct sched_group **sg,
-					struct cpumask *tmpmask),
-			struct cpumask *covered, struct cpumask *tmpmask)
-{
-	struct sched_group *first = NULL, *last = NULL;
-	int i;
-
-	cpumask_clear(covered);
-
-	for_each_cpu(i, span) {
-		struct sched_group *sg;
-		int group = group_fn(i, cpu_map, &sg, tmpmask);
-		int j;
-
-		if (cpumask_test_cpu(i, covered))
-			continue;
-
-		cpumask_clear(sched_group_cpus(sg));
-		sg->cpu_power = 0;
-
-		for_each_cpu(j, span) {
-			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
-				continue;
-
-			cpumask_set_cpu(j, covered);
-			cpumask_set_cpu(j, sched_group_cpus(sg));
-		}
-		if (!first)
-			first = sg;
-		if (last)
-			last->next = sg;
-		last = sg;
-	}
-	last->next = first;
-}
-
 #define SD_NODES_PER_DOMAIN 16
 
 #ifdef CONFIG_NUMA
@@ -6844,154 +6818,96 @@ struct static_sched_domain {
 	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
 };
 
+struct sd_data {
+	struct sched_domain **__percpu sd;
+	struct sched_group **__percpu sg;
+};
+
 struct s_data {
 #ifdef CONFIG_NUMA
 	int			sd_allnodes;
 #endif
 	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
-	cpumask_var_t		tmpmask;
 	struct sched_domain ** __percpu sd;
+	struct sd_data 		sdd[SD_LV_MAX];
 	struct root_domain	*rd;
 };
 
 enum s_alloc {
 	sa_rootdomain,
 	sa_sd,
-	sa_tmpmask,
+	sa_sd_storage,
 	sa_send_covered,
 	sa_nodemask,
 	sa_none,
 };
 
 /*
- * SMT sched-domains:
+ * Assumes the sched_domain tree is fully constructed
  */
-#ifdef CONFIG_SCHED_SMT
-static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_groups);
-
-static int
-cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
-		 struct sched_group **sg, struct cpumask *unused)
+static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 {
-	if (sg)
-		*sg = &per_cpu(sched_groups, cpu).sg;
-	return cpu;
-}
-#endif /* CONFIG_SCHED_SMT */
+	struct sched_domain *sd = *per_cpu_ptr(sdd->sd, cpu);
+	struct sched_domain *child = sd->child;
 
-/*
- * multi-core sched-domains:
- */
-#ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
+	if (child)
+		cpu = cpumask_first(sched_domain_span(child));
 
-static int
-cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
-{
-	int group;
-#ifdef CONFIG_SCHED_SMT
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#else
-	group = cpu;
-#endif
 	if (sg)
-		*sg = &per_cpu(sched_group_core, group).sg;
-	return group;
+		*sg = *per_cpu_ptr(sdd->sg, cpu);
+
+	return cpu;
 }
-#endif /* CONFIG_SCHED_MC */
 
 /*
- * book sched-domains:
+ * build_sched_groups takes the cpumask we wish to span, and a pointer
+ * to a function which identifies what group(along with sched group) a CPU
+ * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
+ * (due to the fact that we keep track of groups covered with a struct cpumask).
+ *
+ * build_sched_groups will build a circular linked list of the groups
+ * covered by the given span, and will set each group's ->cpumask correctly,
+ * and ->cpu_power to 0.
  */
-#ifdef CONFIG_SCHED_BOOK
-static DEFINE_PER_CPU(struct static_sched_domain, book_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_book);
-
-static int
-cpu_to_book_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
-{
-	int group = cpu;
-#ifdef CONFIG_SCHED_MC
-	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#endif
-	if (sg)
-		*sg = &per_cpu(sched_group_book, group).sg;
-	return group;
-}
-#endif /* CONFIG_SCHED_BOOK */
-
-static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
-
-static int
-cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
+static void
+build_sched_groups(struct sched_domain *sd, struct cpumask *covered)
 {
-	int group;
-#ifdef CONFIG_SCHED_BOOK
-	cpumask_and(mask, cpu_book_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_MC)
-	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#else
-	group = cpu;
-#endif
-	if (sg)
-		*sg = &per_cpu(sched_group_phys, group).sg;
-	return group;
-}
-
-#ifdef CONFIG_NUMA
-static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_node);
+	struct sched_group *first = NULL, *last = NULL;
+	struct sd_data *sdd = sd->private;
+	const struct cpumask *span = sched_domain_span(sd);
+	int i;
 
-static int cpu_to_node_group(int cpu, const struct cpumask *cpu_map,
-				 struct sched_group **sg,
-				 struct cpumask *nodemask)
-{
-	int group;
+	cpumask_clear(covered);
 
-	cpumask_and(nodemask, cpumask_of_node(cpu_to_node(cpu)), cpu_map);
-	group = cpumask_first(nodemask);
+	for_each_cpu(i, span) {
+		struct sched_group *sg;
+		int group = get_group(i, sdd, &sg);
+		int j;
 
-	if (sg)
-		*sg = &per_cpu(sched_group_node, group).sg;
-	return group;
-}
+		if (cpumask_test_cpu(i, covered))
+			continue;
 
-static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
+		cpumask_clear(sched_group_cpus(sg));
+		sg->cpu_power = 0;
 
-static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
-				 struct sched_group **sg,
-				 struct cpumask *nodemask)
-{
-	int group;
+		for_each_cpu(j, span) {
+			if (get_group(j, sdd, NULL) != group)
+				continue;
 
-	cpumask_and(nodemask, cpumask_of_node(cpu_to_node(cpu)), cpu_map);
-	group = cpumask_first(nodemask);
+			cpumask_set_cpu(j, covered);
+			cpumask_set_cpu(j, sched_group_cpus(sg));
+		}
 
-	if (sg)
-		*sg = &per_cpu(sched_group_allnodes, group).sg;
-	return group;
+		if (!first)
+			first = sg;
+		if (last)
+			last->next = sg;
+		last = sg;
+	}
+	last->next = first;
 }
 
-#endif /* CONFIG_NUMA */
-
 /*
  * Initialize sched groups cpu_power.
  *
@@ -7025,15 +6941,15 @@ static void init_sched_groups_power(int 
 # define SD_INIT_NAME(sd, type)		do { } while (0)
 #endif
 
-#define	SD_INIT(sd, type)	sd_init_##type(sd)
-
-#define SD_INIT_FUNC(type)	\
-static noinline void sd_init_##type(struct sched_domain *sd)	\
-{								\
-	memset(sd, 0, sizeof(*sd));				\
-	*sd = SD_##type##_INIT;					\
-	sd->level = SD_LV_##type;				\
-	SD_INIT_NAME(sd, type);					\
+#define SD_INIT_FUNC(type)						       \
+static noinline struct sched_domain *sd_init_##type(struct s_data *d, int cpu) \
+{									       \
+	struct sched_domain *sd = *per_cpu_ptr(d->sdd[SD_LV_##type].sd, cpu);  \
+	*sd = SD_##type##_INIT;						       \
+	sd->level = SD_LV_##type;					       \
+	SD_INIT_NAME(sd, type);						       \
+	sd->private = &d->sdd[SD_LV_##type];				       \
+	return sd;							       \
 }
 
 SD_INIT_FUNC(CPU)
@@ -7089,13 +7005,22 @@ static void set_domain_attribute(struct 
 static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 				 const struct cpumask *cpu_map)
 {
+	int i, j;
+
 	switch (what) {
 	case sa_rootdomain:
-		free_rootdomain(d->rd); /* fall through */
+		free_rootdomain(&d->rd->rcu); /* fall through */
 	case sa_sd:
 		free_percpu(d->sd); /* fall through */
-	case sa_tmpmask:
-		free_cpumask_var(d->tmpmask); /* fall through */
+	case sa_sd_storage:
+		for (i = 0; i < SD_LV_MAX; i++) {
+			for_each_cpu(j, cpu_map) {
+				kfree(*per_cpu_ptr(d->sdd[i].sd, j));
+				kfree(*per_cpu_ptr(d->sdd[i].sg, j));
+			}
+			free_percpu(d->sdd[i].sd);
+			free_percpu(d->sdd[i].sg);
+		} /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
 	case sa_nodemask:
@@ -7108,25 +7033,70 @@ static void __free_domain_allocs(struct 
 static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 						   const struct cpumask *cpu_map)
 {
+	int i, j;
+
+	memset(d, 0, sizeof(*d));
+
 	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
 		return sa_none;
 	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
 		return sa_nodemask;
-	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
-		return sa_send_covered;
-	d->sd = alloc_percpu(struct sched_domain *);
-	if (!d->sd) {
-		printk(KERN_WARNING "Cannot alloc per-cpu pointers\n");
-		return sa_tmpmask;
+	for (i = 0; i < SD_LV_MAX; i++) {
+		d->sdd[i].sd = alloc_percpu(struct sched_domain *);
+		if (!d->sdd[i].sd)
+			return sa_sd_storage;
+
+		d->sdd[i].sg = alloc_percpu(struct sched_group *);
+		if (!d->sdd[i].sg)
+			return sa_sd_storage;
+
+		for_each_cpu(j, cpu_map) {
+			struct sched_domain *sd;
+			struct sched_group *sg;
+
+		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sd)
+				return sa_sd_storage;
+
+			*per_cpu_ptr(d->sdd[i].sd, j) = sd;
+
+			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sg)
+				return sa_sd_storage;
+
+			*per_cpu_ptr(d->sdd[i].sg, j) = sg;
+		}
 	}
+	d->sd = alloc_percpu(struct sched_domain *);
+	if (!d->sd)
+		return sa_sd_storage;
 	d->rd = alloc_rootdomain();
-	if (!d->rd) {
-		printk(KERN_WARNING "Cannot alloc root domain\n");
+	if (!d->rd)
 		return sa_sd;
-	}
 	return sa_rootdomain;
 }
 
+/*
+ * NULL the sd_data elements we've used to build the sched_domain and
+ * sched_group structure so that the subsequent __free_domain_allocs()
+ * will not free the data we're using.
+ */
+static void claim_allocations(int cpu, struct sched_domain *sd)
+{
+	struct sd_data *sdd = sd->private;
+	struct sched_group *sg = sd->groups;
+
+	WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, cpu) != sd);
+	*per_cpu_ptr(sdd->sd, cpu) = NULL;
+
+	if (cpu == cpumask_first(sched_group_cpus(sg))) {
+		WARN_ON_ONCE(*per_cpu_ptr(sdd->sg, cpu) != sg);
+		*per_cpu_ptr(sdd->sg, cpu) = NULL;
+	}
+}
+
 static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
 	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
 {
@@ -7137,24 +7107,20 @@ static struct sched_domain *__build_numa
 	d->sd_allnodes = 0;
 	if (cpumask_weight(cpu_map) >
 	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
-		sd = &per_cpu(allnodes_domains, i).sd;
-		SD_INIT(sd, ALLNODES);
+		sd = sd_init_ALLNODES(d, i);
 		set_domain_attribute(sd, attr);
 		cpumask_copy(sched_domain_span(sd), cpu_map);
-		cpu_to_allnodes_group(i, cpu_map, &sd->groups, d->tmpmask);
 		d->sd_allnodes = 1;
 	}
 	parent = sd;
 
-	sd = &per_cpu(node_domains, i).sd;
-	SD_INIT(sd, NODE);
+	sd = sd_init_NODE(d, i);
 	set_domain_attribute(sd, attr);
 	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
 	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
-	cpu_to_node_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
@@ -7164,14 +7130,12 @@ static struct sched_domain *__build_cpu_
 	struct sched_domain *parent, int i)
 {
 	struct sched_domain *sd;
-	sd = &per_cpu(phys_domains, i).sd;
-	SD_INIT(sd, CPU);
+	sd = sd_init_CPU(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_copy(sched_domain_span(sd), d->nodemask);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
-	cpu_to_phys_group(i, cpu_map, &sd->groups, d->tmpmask);
 	return sd;
 }
 
@@ -7181,13 +7145,11 @@ static struct sched_domain *__build_book
 {
 	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_BOOK
-	sd = &per_cpu(book_domains, i).sd;
-	SD_INIT(sd, BOOK);
+	sd = sd_init_BOOK(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
 	sd->parent = parent;
 	parent->child = sd;
-	cpu_to_book_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
@@ -7198,13 +7160,11 @@ static struct sched_domain *__build_mc_s
 {
 	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_MC
-	sd = &per_cpu(core_domains, i).sd;
-	SD_INIT(sd, MC);
+	sd = sd_init_MC(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
 	sd->parent = parent;
 	parent->child = sd;
-	cpu_to_core_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
@@ -7215,92 +7175,32 @@ static struct sched_domain *__build_smt_
 {
 	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_SMT
-	sd = &per_cpu(cpu_domains, i).sd;
-	SD_INIT(sd, SIBLING);
+	sd = sd_init_SIBLING(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, topology_thread_cpumask(i));
 	sd->parent = parent;
 	parent->child = sd;
-	cpu_to_cpu_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
 
-static void build_sched_groups(struct s_data *d, struct sched_domain *sd,
-			       const struct cpumask *cpu_map, int cpu)
-{
-	switch (sd->level) {
-#ifdef CONFIG_SCHED_SMT
-	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_cpu_group,
-						d->send_covered, d->tmpmask);
-		break;
-#endif
-#ifdef CONFIG_SCHED_MC
-	case SD_LV_MC: /* set up multi-core groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_core_group,
-						d->send_covered, d->tmpmask);
-		break;
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	case SD_LV_BOOK: /* set up book groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_book_group,
-						d->send_covered, d->tmpmask);
-		break;
-#endif
-	case SD_LV_CPU: /* set up physical groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_phys_group,
-						d->send_covered, d->tmpmask);
-		break;
-#ifdef CONFIG_NUMA
-	case SD_LV_NODE:
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_node_group,
-						d->send_covered, d->tmpmask);
-
-	case SD_LV_ALLNODES:
-		if (cpu == cpumask_first(cpu_map))
-			init_sched_build_groups(cpu_map, cpu_map,
-					&cpu_to_allnodes_group,
-					d->send_covered, d->tmpmask);
-		break;
-#endif
-	default:
-		break;
-	}
-}
-
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
-static int __build_sched_domains(const struct cpumask *cpu_map,
-				 struct sched_domain_attr *attr)
+static int build_sched_domains(const struct cpumask *cpu_map,
+			       struct sched_domain_attr *attr)
 {
 	enum s_alloc alloc_state = sa_none;
+	struct sched_domain *sd;
 	struct s_data d;
-	struct sched_domain *sd, *tmp;
 	int i;
-#ifdef CONFIG_NUMA
-	d.sd_allnodes = 0;
-#endif
 
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
 		goto error;
 
-	/*
-	 * Set up domains for cpus specified by the cpu_map.
-	 */
+	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
@@ -7312,10 +7212,19 @@ static int __build_sched_domains(const s
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 
 		*per_cpu_ptr(d.sd, i) = sd;
+	}
+
+	/* Build the groups for the domains */
+	for_each_cpu(i, cpu_map) {
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+			sd->span_weight = cpumask_weight(sched_domain_span(sd));
+			get_group(i, sd->private, &sd->groups);
+			atomic_inc(&sd->groups->ref);
 
-		for (tmp = sd; tmp; tmp = tmp->parent) {
-			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
-			build_sched_groups(&d, tmp, cpu_map, i);
+			if (i != cpumask_first(sched_domain_span(sd)))
+				continue;
+
+			build_sched_groups(sd, d.send_covered);
 		}
 	}
 
@@ -7324,18 +7233,22 @@ static int __build_sched_domains(const s
 		if (!cpumask_test_cpu(i, cpu_map))
 			continue;
 
-		sd = *per_cpu_ptr(d.sd, i);
-		for (; sd; sd = sd->parent)
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+			claim_allocations(i, sd);
 			init_sched_groups_power(i, sd);
+		}
 	}
 
 	/* Attach the domains */
+	rcu_read_lock();
 	for_each_cpu(i, cpu_map) {
 		sd = *per_cpu_ptr(d.sd, i);
 		cpu_attach_domain(sd, d.rd, i);
+//		sched_domain_debug(sd, i);
 	}
+	rcu_read_unlock();
 
-	__free_domain_allocs(&d, sa_tmpmask, cpu_map);
+	__free_domain_allocs(&d, sa_sd, cpu_map);
 	return 0;
 
 error:
@@ -7343,11 +7256,6 @@ static int __build_sched_domains(const s
 	return -ENOMEM;
 }
 
-static int build_sched_domains(const struct cpumask *cpu_map)
-{
-	return __build_sched_domains(cpu_map, NULL);
-}
-
 static cpumask_var_t *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 static struct sched_domain_attr *dattr_cur;
@@ -7411,31 +7319,24 @@ static int init_sched_domains(const stru
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
-	err = build_sched_domains(doms_cur[0]);
+	err = build_sched_domains(doms_cur[0], NULL);
 	register_sched_domain_sysctl();
 
 	return err;
 }
 
-static void destroy_sched_domains(const struct cpumask *cpu_map,
-				       struct cpumask *tmpmask)
-{
-}
-
 /*
  * Detach sched domains from a group of cpus specified in cpu_map
  * These cpus will now be attached to the NULL domain
  */
 static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
-	/* Save because hotplug lock held. */
-	static DECLARE_BITMAP(tmpmask, CONFIG_NR_CPUS);
 	int i;
 
+	rcu_read_lock();
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
-	synchronize_sched();
-	destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
+	rcu_read_unlock();
 }
 
 /* handle null as "default" */
@@ -7524,8 +7425,7 @@ void partition_sched_domains(int ndoms_n
 				goto match2;
 		}
 		/* no match - add a new doms_new */
-		__build_sched_domains(doms_new[i],
-					dattr_new ? dattr_new + i : NULL);
+		build_sched_domains(doms_new[i], dattr_new ? dattr_new + i : NULL);
 match2:
 		;
 	}
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1621,6 +1621,7 @@ static int select_idle_sibling(struct ta
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
+	rcu_read_lock();
 	for_each_domain(target, sd) {
 		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
@@ -1640,6 +1641,7 @@ static int select_idle_sibling(struct ta
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
 			break;
 	}
+	rcu_read_unlock();
 
 	return target;
 }
@@ -1672,6 +1674,7 @@ select_task_rq_fair(struct rq *rq, struc
 		new_cpu = prev_cpu;
 	}
 
+	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		if (!(tmp->flags & SD_LOAD_BALANCE))
 			continue;
@@ -1722,9 +1725,10 @@ select_task_rq_fair(struct rq *rq, struc
 
 	if (affine_sd) {
 		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
-			return select_idle_sibling(p, cpu);
-		else
-			return select_idle_sibling(p, prev_cpu);
+			prev_cpu = cpu;
+
+		new_cpu = select_idle_sibling(p, prev_cpu);
+		goto unlock;
 	}
 
 	while (sd) {
@@ -1765,6 +1769,8 @@ select_task_rq_fair(struct rq *rq, struc
 		}
 		/* while loop will break here if sd == NULL */
 	}
+unlock:
+	rcu_read_unlock();
 
 	return new_cpu;
 }
@@ -3466,6 +3472,7 @@ static void idle_balance(int this_cpu, s
 	raw_spin_unlock(&this_rq->lock);
 
 	update_shares(this_cpu);
+	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
@@ -3487,6 +3494,7 @@ static void idle_balance(int this_cpu, s
 			break;
 		}
 	}
+	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
 
@@ -3535,6 +3543,7 @@ static int active_load_balance_cpu_stop(
 	double_lock_balance(busiest_rq, target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
+	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
 		if ((sd->flags & SD_LOAD_BALANCE) &&
 		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
@@ -3550,6 +3559,7 @@ static int active_load_balance_cpu_stop(
 		else
 			schedstat_inc(sd, alb_failed);
 	}
+	rcu_read_unlock();
 	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
@@ -3676,6 +3686,7 @@ static int find_new_ilb(int cpu)
 {
 	struct sched_domain *sd;
 	struct sched_group *ilb_group;
+	int ilb = nr_cpu_ids;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -3691,20 +3702,25 @@ static int find_new_ilb(int cpu)
 	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
 		goto out_done;
 
+	rcu_read_lock();
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
 		ilb_group = sd->groups;
 
 		do {
-			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.grp_idle_mask);
+			if (is_semi_idle_group(ilb_group)) {
+				ilb = cpumask_first(nohz.grp_idle_mask);
+				goto unlock;
+			}
 
 			ilb_group = ilb_group->next;
 
 		} while (ilb_group != sd->groups);
 	}
+unlock:
+	rcu_read_unlock();
 
 out_done:
-	return nr_cpu_ids;
+	return ilb;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
@@ -3838,6 +3854,7 @@ static void rebalance_domains(int cpu, e
 
 	update_shares(cpu);
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -3886,6 +3903,7 @@ static void rebalance_domains(int cpu, e
 		if (!balance)
 			break;
 	}
+	rcu_read_unlock();
 
 	/*
 	 * next_balance will be updated only when there is a need.


