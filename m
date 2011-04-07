Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1DGMmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:42:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1DGMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:56 -0400
Message-Id: <20110407122941.978111700@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:45 +0200
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
Subject: [PATCH 04/23] sched: Change NODE sched_domain group creation
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NODE sched_domain is 'special' in that it allocates sched_groups
per CPU, instead of sharing the sched_groups between all CPUs.

While this might have some benefits on large NUMA and avoid remote
memory accesses when iterating the sched_groups, this does break
current code that assumes sched_groups are shared between all
sched_domains (since the dynamic cpu_power patches).

So refactor the NODE groups to behave like all other groups.

(The ALLNODES domain again shared its groups across the CPUs for some
reason).

If someone does measure a performance decrease due to this change we
need to revisit this and come up with another way to have both dynamic
cpu_power and NUMA work nice together.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |  231 ++++++++-------------------------------------------------
 1 file changed, 33 insertions(+), 198 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6837,29 +6837,18 @@ struct static_sched_domain {
 struct s_data {
 #ifdef CONFIG_NUMA
 	int			sd_allnodes;
-	cpumask_var_t		domainspan;
-	cpumask_var_t		covered;
-	cpumask_var_t		notcovered;
 #endif
 	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
-	struct sched_group	**sched_group_nodes;
 	struct root_domain	*rd;
 };
 
 enum s_alloc {
-	sa_sched_groups = 0,
 	sa_rootdomain,
 	sa_tmpmask,
 	sa_send_covered,
 	sa_nodemask,
-	sa_sched_group_nodes,
-#ifdef CONFIG_NUMA
-	sa_notcovered,
-	sa_covered,
-	sa_domainspan,
-#endif
 	sa_none,
 };
 
@@ -6955,18 +6944,10 @@ cpu_to_phys_group(int cpu, const struct
 }
 
 #ifdef CONFIG_NUMA
-/*
- * The init_sched_build_groups can't handle what we want to do with node
- * groups, so roll our own. Now each node has its own list of groups which
- * gets dynamically allocated.
- */
 static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
-static struct sched_group ***sched_group_nodes_bycpu;
-
-static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_node);
 
-static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
+static int cpu_to_node_group(int cpu, const struct cpumask *cpu_map,
 				 struct sched_group **sg,
 				 struct cpumask *nodemask)
 {
@@ -6976,142 +6957,27 @@ static int cpu_to_allnodes_group(int cpu
 	group = cpumask_first(nodemask);
 
 	if (sg)
-		*sg = &per_cpu(sched_group_allnodes, group).sg;
+		*sg = &per_cpu(sched_group_node, group).sg;
 	return group;
 }
 
-static void init_numa_sched_groups_power(struct sched_group *group_head)
-{
-	struct sched_group *sg = group_head;
-	int j;
-
-	if (!sg)
-		return;
-	do {
-		for_each_cpu(j, sched_group_cpus(sg)) {
-			struct sched_domain *sd;
-
-			sd = &per_cpu(phys_domains, j).sd;
-			if (j != group_first_cpu(sd->groups)) {
-				/*
-				 * Only add "power" once for each
-				 * physical package.
-				 */
-				continue;
-			}
-
-			sg->cpu_power += sd->groups->cpu_power;
-		}
-		sg = sg->next;
-	} while (sg != group_head);
-}
+static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
 
-static int build_numa_sched_groups(struct s_data *d,
-				   const struct cpumask *cpu_map, int num)
+static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
+				 struct sched_group **sg,
+				 struct cpumask *nodemask)
 {
-	struct sched_domain *sd;
-	struct sched_group *sg, *prev;
-	int n, j;
+	int group;
 
-	cpumask_clear(d->covered);
-	cpumask_and(d->nodemask, cpumask_of_node(num), cpu_map);
-	if (cpumask_empty(d->nodemask)) {
-		d->sched_group_nodes[num] = NULL;
-		goto out;
-	}
-
-	sched_domain_node_span(num, d->domainspan);
-	cpumask_and(d->domainspan, d->domainspan, cpu_map);
-
-	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
-			  GFP_KERNEL, num);
-	if (!sg) {
-		printk(KERN_WARNING "Can not alloc domain group for node %d\n",
-		       num);
-		return -ENOMEM;
-	}
-	d->sched_group_nodes[num] = sg;
-
-	for_each_cpu(j, d->nodemask) {
-		sd = &per_cpu(node_domains, j).sd;
-		sd->groups = sg;
-	}
-
-	sg->cpu_power = 0;
-	cpumask_copy(sched_group_cpus(sg), d->nodemask);
-	sg->next = sg;
-	cpumask_or(d->covered, d->covered, d->nodemask);
-
-	prev = sg;
-	for (j = 0; j < nr_node_ids; j++) {
-		n = (num + j) % nr_node_ids;
-		cpumask_complement(d->notcovered, d->covered);
-		cpumask_and(d->tmpmask, d->notcovered, cpu_map);
-		cpumask_and(d->tmpmask, d->tmpmask, d->domainspan);
-		if (cpumask_empty(d->tmpmask))
-			break;
-		cpumask_and(d->tmpmask, d->tmpmask, cpumask_of_node(n));
-		if (cpumask_empty(d->tmpmask))
-			continue;
-		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				  GFP_KERNEL, num);
-		if (!sg) {
-			printk(KERN_WARNING
-			       "Can not alloc domain group for node %d\n", j);
-			return -ENOMEM;
-		}
-		sg->cpu_power = 0;
-		cpumask_copy(sched_group_cpus(sg), d->tmpmask);
-		sg->next = prev->next;
-		cpumask_or(d->covered, d->covered, d->tmpmask);
-		prev->next = sg;
-		prev = sg;
-	}
-out:
-	return 0;
-}
-#endif /* CONFIG_NUMA */
+	cpumask_and(nodemask, cpumask_of_node(cpu_to_node(cpu)), cpu_map);
+	group = cpumask_first(nodemask);
 
-#ifdef CONFIG_NUMA
-/* Free memory allocated for various sched_group structures */
-static void free_sched_groups(const struct cpumask *cpu_map,
-			      struct cpumask *nodemask)
-{
-	int cpu, i;
-
-	for_each_cpu(cpu, cpu_map) {
-		struct sched_group **sched_group_nodes
-			= sched_group_nodes_bycpu[cpu];
-
-		if (!sched_group_nodes)
-			continue;
-
-		for (i = 0; i < nr_node_ids; i++) {
-			struct sched_group *oldsg, *sg = sched_group_nodes[i];
-
-			cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
-			if (cpumask_empty(nodemask))
-				continue;
-
-			if (sg == NULL)
-				continue;
-			sg = sg->next;
-next_sg:
-			oldsg = sg;
-			sg = sg->next;
-			kfree(oldsg);
-			if (oldsg != sched_group_nodes[i])
-				goto next_sg;
-		}
-		kfree(sched_group_nodes);
-		sched_group_nodes_bycpu[cpu] = NULL;
-	}
-}
-#else /* !CONFIG_NUMA */
-static void free_sched_groups(const struct cpumask *cpu_map,
-			      struct cpumask *nodemask)
-{
+	if (sg)
+		*sg = &per_cpu(sched_group_allnodes, group).sg;
+	return group;
 }
+
 #endif /* CONFIG_NUMA */
 
 /*
@@ -7212,9 +7078,6 @@ static void __free_domain_allocs(struct
 				 const struct cpumask *cpu_map)
 {
 	switch (what) {
-	case sa_sched_groups:
-		free_sched_groups(cpu_map, d->tmpmask); /* fall through */
-		d->sched_group_nodes = NULL;
 	case sa_rootdomain:
 		free_rootdomain(d->rd); /* fall through */
 	case sa_tmpmask:
@@ -7223,16 +7086,6 @@ static void __free_domain_allocs(struct
 		free_cpumask_var(d->send_covered); /* fall through */
 	case sa_nodemask:
 		free_cpumask_var(d->nodemask); /* fall through */
-	case sa_sched_group_nodes:
-#ifdef CONFIG_NUMA
-		kfree(d->sched_group_nodes); /* fall through */
-	case sa_notcovered:
-		free_cpumask_var(d->notcovered); /* fall through */
-	case sa_covered:
-		free_cpumask_var(d->covered); /* fall through */
-	case sa_domainspan:
-		free_cpumask_var(d->domainspan); /* fall through */
-#endif
 	case sa_none:
 		break;
 	}
@@ -7241,24 +7094,8 @@ static void __free_domain_allocs(struct
 static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 						   const struct cpumask *cpu_map)
 {
-#ifdef CONFIG_NUMA
-	if (!alloc_cpumask_var(&d->domainspan, GFP_KERNEL))
-		return sa_none;
-	if (!alloc_cpumask_var(&d->covered, GFP_KERNEL))
-		return sa_domainspan;
-	if (!alloc_cpumask_var(&d->notcovered, GFP_KERNEL))
-		return sa_covered;
-	/* Allocate the per-node list of sched groups */
-	d->sched_group_nodes = kcalloc(nr_node_ids,
-				      sizeof(struct sched_group *), GFP_KERNEL);
-	if (!d->sched_group_nodes) {
-		printk(KERN_WARNING "Can not alloc sched group node list\n");
-		return sa_notcovered;
-	}
-	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
-#endif
 	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
-		return sa_sched_group_nodes;
+		return sa_none;
 	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
 		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
@@ -7298,6 +7135,7 @@ static struct sched_domain *__build_numa
 	if (parent)
 		parent->child = sd;
 	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
+	cpu_to_node_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
@@ -7410,6 +7248,13 @@ static void build_sched_groups(struct s_
 						d->send_covered, d->tmpmask);
 		break;
 #ifdef CONFIG_NUMA
+	case SD_LV_NODE:
+		sd = &per_cpu(node_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
+						&cpu_to_node_group,
+						d->send_covered, d->tmpmask);
+
 	case SD_LV_ALLNODES:
 		init_sched_build_groups(cpu_map, cpu_map, &cpu_to_allnodes_group,
 					d->send_covered, d->tmpmask);
@@ -7438,7 +7283,6 @@ static int __build_sched_domains(const s
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
 		goto error;
-	alloc_state = sa_sched_groups;
 
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
@@ -7462,16 +7306,13 @@ static int __build_sched_domains(const s
 		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
 		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
+		build_sched_groups(&d, SD_LV_NODE, cpu_map, i);
 	}
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
 	if (d.sd_allnodes)
 		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, 0);
-
-	for (i = 0; i < nr_node_ids; i++)
-		if (build_numa_sched_groups(&d, cpu_map, i))
-			goto error;
 #endif
 
 	/* Calculate CPU power for physical packages and nodes */
@@ -7500,15 +7341,16 @@ static int __build_sched_domains(const s
 	}
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < nr_node_ids; i++)
-		init_numa_sched_groups_power(d.sched_group_nodes[i]);
+	for_each_cpu(i, cpu_map) {
+		sd = &per_cpu(node_domains, i).sd;
+		init_sched_groups_power(i, sd);
+	}
 
 	if (d.sd_allnodes) {
-		struct sched_group *sg;
-
-		cpu_to_allnodes_group(cpumask_first(cpu_map), cpu_map, &sg,
-								d.tmpmask);
-		init_numa_sched_groups_power(sg);
+		for_each_cpu(i, cpu_map) {
+			sd = &per_cpu(allnodes_domains, i).sd;
+			init_sched_groups_power(i, sd);
+		}
 	}
 #endif
 
@@ -7526,7 +7368,6 @@ static int __build_sched_domains(const s
 		cpu_attach_domain(sd, d.rd, i);
 	}
 
-	d.sched_group_nodes = NULL; /* don't free this we still need it */
 	__free_domain_allocs(&d, sa_tmpmask, cpu_map);
 	return 0;
 
@@ -7612,7 +7453,6 @@ static int init_sched_domains(const stru
 static void destroy_sched_domains(const struct cpumask *cpu_map,
 				       struct cpumask *tmpmask)
 {
-	free_sched_groups(cpu_map, tmpmask);
 }
 
 /*
@@ -7889,11 +7729,6 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
-#if defined(CONFIG_NUMA)
-	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
-								GFP_KERNEL);
-	BUG_ON(sched_group_nodes_bycpu == NULL);
-#endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);


