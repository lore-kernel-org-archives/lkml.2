Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1DGOFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:05:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1DGOFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:05:43 -0400
Subject: [RFC][PATCH 24/23] sched: Rewrite CONFIG_NUMA support
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20110407120941.400629539@chello.nl>
References: <20110407120941.400629539@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Apr 2011 16:05:23 +0200
Message-ID: <1302185123.3329.1234.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below is proven to be broken on a non-trivial NUMA setup (4 socekt
magny-cours, tested by Andreas) but shows the direction I'm wanting to
take for NUMA.

The current stuff 16 nodes in a domain and one top-level domain to rule
them all just doesn't sound right, esp for these small
non-fully-connected systems of today.

So what it attempts is to sort the numa-distance table and create
domains for each grouping resulting from that. This should then match
the actual machine topology much better.

The problem with it is that its quite possible to generate overlapping
groups for a domain and the magny-cours topology makes that happen. I've
still not quite figured out wth to do about that though :-/


---
Subject: sched: Rewrite CONFIG_NUMA support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Mar 25 21:52:17 CET 2011

Rewrite the CONFIG_NUMA sched domain support.

The current code groups up to 16 nodes in a level and then puts an
ALLNODES domain spanning the entire tree on top of that. This doesn't
reflect the numa topology and esp for the smaller not-fully-connected
machines out there today this might make a difference.

Therefore, build a proper numa topology based on node_distance().

TODO: figure out a way to set SD_flags based on distance such that
      we disable various expensive load-balancing features at some
      point and increase the balance interval prop. to the distance.

XXX: remove debug prints

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/topology.h |   25 -----
 kernel/sched.c           |  201 +++++++++++++++++++++++++----------------------
 2 files changed, 110 insertions(+), 116 deletions(-)

Index: linux-2.6/include/linux/topology.h
===================================================================
--- linux-2.6.orig/include/linux/topology.h
+++ linux-2.6/include/linux/topology.h
@@ -176,31 +176,6 @@ int arch_update_cpu_topology(void);
 }
 #endif
 
-/* sched_domains SD_ALLNODES_INIT for NUMA machines */
-#define SD_ALLNODES_INIT (struct sched_domain) {			\
-	.min_interval		= 64,					\
-	.max_interval		= 64*num_online_cpus(),			\
-	.busy_factor		= 128,					\
-	.imbalance_pct		= 133,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 3,					\
-	.idle_idx		= 3,					\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 0*SD_BALANCE_EXEC			\
-				| 0*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 64,					\
-}
-
 #ifdef CONFIG_SCHED_BOOK
 #ifndef SD_BOOK_INIT
 #error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6723,92 +6723,6 @@ static int __init isolated_cpu_setup(cha
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-#define SD_NODES_PER_DOMAIN 16
-
-#ifdef CONFIG_NUMA
-
-/**
- * find_next_best_node - find the next node to include in a sched_domain
- * @node: node whose sched_domain we're building
- * @used_nodes: nodes already in the sched_domain
- *
- * Find the next node to include in a given scheduling domain. Simply
- * finds the closest node not already in the @used_nodes map.
- *
- * Should use nodemask_t.
- */
-static int find_next_best_node(int node, nodemask_t *used_nodes)
-{
-	int i, n, val, min_val, best_node = 0;
-
-	min_val = INT_MAX;
-
-	for (i = 0; i < nr_node_ids; i++) {
-		/* Start at @node */
-		n = (node + i) % nr_node_ids;
-
-		if (!nr_cpus_node(n))
-			continue;
-
-		/* Skip already used nodes */
-		if (node_isset(n, *used_nodes))
-			continue;
-
-		/* Simple min distance search */
-		val = node_distance(node, n);
-
-		if (val < min_val) {
-			min_val = val;
-			best_node = n;
-		}
-	}
-
-	node_set(best_node, *used_nodes);
-	return best_node;
-}
-
-/**
- * sched_domain_node_span - get a cpumask for a node's sched_domain
- * @node: node whose cpumask we're constructing
- * @span: resulting cpumask
- *
- * Given a node, construct a good cpumask for its sched_domain to span. It
- * should be one that prevents unnecessary balancing, but also spreads tasks
- * out optimally.
- */
-static void sched_domain_node_span(int node, struct cpumask *span)
-{
-	nodemask_t used_nodes;
-	int i;
-
-	cpumask_clear(span);
-	nodes_clear(used_nodes);
-
-	cpumask_or(span, span, cpumask_of_node(node));
-	node_set(node, used_nodes);
-
-	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
-		int next_node = find_next_best_node(node, &used_nodes);
-
-		cpumask_or(span, span, cpumask_of_node(next_node));
-	}
-}
-
-static const struct cpumask *cpu_node_mask(int cpu)
-{
-	lockdep_assert_held(&sched_domains_mutex);
-
-	sched_domain_node_span(cpu_to_node(cpu), sched_domains_tmpmask);
-
-	return sched_domains_tmpmask;
-}
-
-static const struct cpumask *cpu_allnodes_mask(int cpu)
-{
-	return cpu_possible_mask;
-}
-#endif /* CONFIG_NUMA */
-
 static const struct cpumask *cpu_cpu_mask(int cpu)
 {
 	return cpumask_of_node(cpu_to_node(cpu));
@@ -6841,6 +6755,7 @@ typedef const struct cpumask *(*sched_do
 struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
+	int		    numa_level;
 	struct sd_data      data;
 };
 
@@ -6959,7 +6874,6 @@ sd_init_##type(struct sched_domain_topol
 
 SD_INIT_FUNC(CPU)
 #ifdef CONFIG_NUMA
- SD_INIT_FUNC(ALLNODES)
  SD_INIT_FUNC(NODE)
 #endif
 #ifdef CONFIG_SCHED_SMT
@@ -7083,15 +6997,118 @@ static struct sched_domain_topology_leve
 	{ sd_init_BOOK, cpu_book_mask, },
 #endif
 	{ sd_init_CPU, cpu_cpu_mask, },
-#ifdef CONFIG_NUMA
-	{ sd_init_NODE, cpu_node_mask, },
-	{ sd_init_ALLNODES, cpu_allnodes_mask, },
-#endif
 	{ NULL, },
 };
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#ifdef CONFIG_NUMA
+
+static int sched_domains_numa_levels;
+static int *sched_domains_numa_distance;
+static struct cpumask ** __percpu sched_domains_numa_masks;
+static int sched_domains_curr_level;
+
+static struct sched_domain *
+sd_init_NUMA(struct sched_domain_topology_level *tl, int cpu)
+{
+	sched_domains_curr_level = tl->numa_level;
+	return sd_init_NODE(tl, cpu);
+}
+
+static const struct cpumask *sd_numa_mask(int cpu)
+{
+	return per_cpu_ptr(sched_domains_numa_masks[sched_domains_curr_level], cpu);
+}
+
+static void sched_init_numa(void)
+{
+	int next_distance, curr_distance = node_distance(0, 0);
+	struct sched_domain_topology_level *tl;
+	int level = 0;
+	int i, j, k;
+	char str[256];
+
+	sched_domains_numa_distance =
+		kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
+	if (!sched_domains_numa_distance)
+		return;
+
+	next_distance = curr_distance;
+	for (i = 0; i < nr_node_ids; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			int distance = node_distance(0, j);
+			printk("distance(0,%d): %d\n", j, distance);
+			if (distance > curr_distance &&
+					(distance < next_distance ||
+					 next_distance == curr_distance))
+				next_distance = distance;
+		}
+		if (next_distance != curr_distance) {
+			sched_domains_numa_distance[level++] = next_distance;
+			sched_domains_numa_levels = level;
+			curr_distance = next_distance;
+		} else break;
+	}
+
+	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
+	if (!sched_domains_numa_masks)
+		return;
+
+	printk("numa levels: %d\n", level);
+	for (i = 0; i < level; i++) {
+		printk("numa distance(%d): %d\n", i, sched_domains_numa_distance[i]);
+
+		sched_domains_numa_masks[i] = alloc_percpu(cpumask_t);
+		if (!sched_domains_numa_masks[i])
+			return;
+
+		for_each_possible_cpu(j) {
+			struct cpumask *mask =
+				per_cpu_ptr(sched_domains_numa_masks[i], j);
+
+			for (k = 0; k < nr_node_ids; k++) {
+				if (node_distance(cpu_to_node(j), k) >
+						sched_domains_numa_distance[i])
+					continue;
+
+				cpumask_or(mask, mask, cpumask_of_node(k));
+			}
+
+			cpulist_scnprintf(str, sizeof(str), mask);
+			printk("numa cpu(%d) mask: %s\n", j, str);
+		}
+	}
+
+	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
+			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
+	if (!tl)
+		return;
+
+	sched_domain_topology = tl;
+	for (i = 0; default_topology[i].init; i++)
+		tl[i] = default_topology[i];
+
+	for (j = 0; j < level; i++, j++) {
+		tl[i] = (struct sched_domain_topology_level){
+			.init = sd_init_NUMA,
+			.mask = sd_numa_mask,
+			.numa_level = j,
+		};
+	}
+
+	for (tl = sched_domain_topology; tl->init; tl++) {
+		printk("Topology: %pF\n", tl->init);
+	}
+
+	return;
+}
+#else
+static inline void sched_init_numa(void)
+{
+}
+#endif /* CONFIG_NUMA */
+
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
 	struct sched_domain_topology_level *tl;
@@ -7578,6 +7595,8 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
+	sched_init_numa();
+
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);

