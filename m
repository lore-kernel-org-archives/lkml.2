Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1EOFup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 01:50:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34930 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1EOFuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 01:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZBT2fx4JsrNALRGSsuGp4ppTNH/+tsV8CsDYrRREDUtkTpuZKJNUgutuXhdUnSfNnu
         cMF9VjAWOs0BdfEX4NbEDo0Abn+eGp/gk8VoXM5UdnhZQnyLIMWyjY4dw3D8SZ1eMtgA
         eVEPNSBcretKa6lp1qWa8spiP2bOmZzd4qgZE=
MIME-Version: 1.0
In-Reply-To: <1305122055.2914.220.camel@laptop>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
	<1305016329.2914.22.camel@laptop>
	<BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
	<1305122055.2914.220.camel@laptop>
Date: Sun, 15 May 2011 13:50:42 +0800
Message-ID: <BANLkTikCF8uTH05gGG_H2bEYvZe0wmtS9A@mail.gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 9:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-05-11 at 21:26 +0800, Hillf Danton wrote:
>> Your work for rewriting NUMA support, published at
>>          http://marc.info/?l=linux-kernel&m=130218515520540
>> is patched by changing how level is computed and by changing how it is
>> used to build the mask.
>>
>> When computing, some valid levels are lost in your work.
>>
>> When building mask, nodes are selected only if they have same distance,
>> thus nodes of less distance are also masked out since the computation of
>> level now is tough.
>>
>> Without MUNA hardware, I did not test the patch:(
>
> I do have a (tiny) NUMA box (2 nodes) but that actually booted with the
> old code too, Andreas Hermann from AMD (CC'ed) is usually willing to
> test such patches on somewhat larger systems. Please send a full patch
> against tip/master for him to apply.
>

Hi Peter

With the guiding from Ingo on git fetch the tip/master, the work is
now finished:)

Hopely it is not too late for Andreas.

In the following, the concern is also added for distances not covered by level,
please review again.

thanks
Hillf
---
 include/linux/topology.h |   25 -----
 kernel/sched.c           |  220 ++++++++++++++++++++++++++--------------------
 2 files changed, 126 insertions(+), 119 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index b91a40e..fce56c8 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
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
diff --git a/kernel/sched.c b/kernel/sched.c
index f9778c0..5845815 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6791,94 +6791,6 @@ static int __init isolated_cpu_setup(char *str)

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
-	int i, n, val, min_val, best_node = -1;
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
-	if (best_node != -1)
-		node_set(best_node, *used_nodes);
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
-		if (next_node < 0)
-			break;
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
@@ -6911,6 +6823,7 @@ typedef const struct cpumask
*(*sched_domain_mask_f)(int cpu);
 struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
+	int		    numa_level;
 	struct sd_data      data;
 };

@@ -7029,7 +6942,6 @@ sd_init_##type(struct
sched_domain_topology_level *tl, int cpu) 	\

 SD_INIT_FUNC(CPU)
 #ifdef CONFIG_NUMA
- SD_INIT_FUNC(ALLNODES)
  SD_INIT_FUNC(NODE)
 #endif
 #ifdef CONFIG_SCHED_SMT
@@ -7153,15 +7065,135 @@ static struct sched_domain_topology_level
default_topology[] = {
 	{ sd_init_BOOK, cpu_book_mask, },
 #endif
 	{ sd_init_CPU, cpu_cpu_mask, },
-#ifdef CONFIG_NUMA
-	{ sd_init_NODE, cpu_node_mask, },
-	{ sd_init_ALLNODES, cpu_allnodes_mask, },
-#endif
 	{ NULL, },
 };

 static struct sched_domain_topology_level *sched_domain_topology =
default_topology;

+#ifdef CONFIG_NUMA
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
+	for (j = 0; j < nr_node_ids; j++) {
+		int distance = node_distance(0, j);
+		printk("distance(0,%d): %d\n", j, distance);
+		for (i = 0; i < level; i++) {
+			/* check if already exist */
+			if (distance == sched_domains_numa_distance[i])
+				goto next_node;
+			/* sort and insert distance */
+			if (distance < sched_domains_numa_distance[i])
+				break;
+		}
+		if (i == level) {
+			sched_domains_numa_distance[level++] = distance;
+			sched_domains_numa_levels = level;
+			continue;
+		}
+		for (k = level -1; k >= i; k--)
+			sched_domains_numa_distance[k+1] =
+			sched_domains_numa_distance[k];
+
+		sched_domains_numa_distance[i] = distance;
+		sched_domains_numa_levels = ++level;
+next_node:
+		;
+	}
+
+	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
+	if (!sched_domains_numa_masks)
+		return;
+
+	printk("numa levels: %d\n", level);
+	for (i = 0; i < level; i++) {
+		printk("numa distance(%d): %d\n",
+			i, sched_domains_numa_distance[i]);
+
+		sched_domains_numa_masks[i] = alloc_percpu(cpumask_t);
+		if (!sched_domains_numa_masks[i])
+			return;
+
+		for_each_possible_cpu(j) {
+			struct cpumask *mask =
+				per_cpu_ptr(sched_domains_numa_masks[i], j);
+
+			cpumask_clear(mask);
+			for (k = 0; k < nr_node_ids; k++) {
+				if (node_distance(cpu_to_node(j), k) !=
+				    sched_domains_numa_distance[i])
+					continue;
+				cpumask_or(mask, mask, cpumask_of_node(k));
+			}
+
+			cpulist_scnprintf(str, sizeof(str), mask);
+			printk("numa cpu(%d) mask: %s\n", j, str);
+		}
+	}
+
+	for (j = 0; j < nr_node_ids; j++) {
+		for (k = 0; k < nr_node_ids; k++) {
+			int distance = node_distance(j, k);
+			for (i = 0; i < level; i++)
+				if (distance == sched_domains_numa_distance[i])
+					goto covered;
+
+			printk("distance(%d,%d): %d not covered by level\n",
+				j, k, distance);
+		covered:
+			;
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
+	for (j = 0; j < level; i++, j++)
+		tl[i] = (struct sched_domain_topology_level) {
+			.init = sd_init_NUMA,
+			.mask = sd_numa_mask,
+			.numa_level = j,
+		};
+
+
+	for (tl = sched_domain_topology; tl->init; tl++)
+		printk("Topology: %pF\n", tl->init);
+}
+#else
+static inline void sched_init_numa(void) {}
+#endif /* CONFIG_NUMA */
+
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
 	struct sched_domain_topology_level *tl;
@@ -7647,7 +7679,7 @@ void __init sched_init_smp(void)

 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
-
+	sched_init_numa();
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);
