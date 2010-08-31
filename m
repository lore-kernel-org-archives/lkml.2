Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab0HaI0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:26:51 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:48280 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab0HaI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:26:47 -0400
Message-Id: <20100831082844.253053798@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 31 Aug 2010 10:28:16 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH V2 2/4] sched: add book scheduling domain
References: <20100831082814.501484459@de.ibm.com>
Content-Disposition: inline; filename=02-sched-book.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

On top of the SMT and MC scheduling domains this adds the BOOK scheduling
domain. This is useful for NUMA like machines which do not have an interface
which tells which piece of memory is attached to which node or where the
hardware performs striping.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 include/linux/sched.h    |    1 
 include/linux/topology.h |    6 +++
 kernel/sched.c           |   77 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 82 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -875,6 +875,7 @@ enum sched_domain_level {
 	SD_LV_NONE = 0,
 	SD_LV_SIBLING,
 	SD_LV_MC,
+	SD_LV_BOOK,
 	SD_LV_CPU,
 	SD_LV_NODE,
 	SD_LV_ALLNODES,
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -201,6 +201,12 @@ int arch_update_cpu_topology(void);
 	.balance_interval	= 64,					\
 }
 
+#ifdef CONFIG_SCHED_BOOK
+#ifndef SD_BOOK_INIT
+#error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
+#endif
+#endif /* CONFIG_SCHED_BOOK */
+
 #ifdef CONFIG_NUMA
 #ifndef SD_NODE_INIT
 #error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6508,6 +6508,7 @@ struct s_data {
 	cpumask_var_t		nodemask;
 	cpumask_var_t		this_sibling_map;
 	cpumask_var_t		this_core_map;
+	cpumask_var_t		this_book_map;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
 	struct sched_group	**sched_group_nodes;
@@ -6519,6 +6520,7 @@ enum s_alloc {
 	sa_rootdomain,
 	sa_tmpmask,
 	sa_send_covered,
+	sa_this_book_map,
 	sa_this_core_map,
 	sa_this_sibling_map,
 	sa_nodemask,
@@ -6572,6 +6574,31 @@ cpu_to_core_group(int cpu, const struct
 }
 #endif /* CONFIG_SCHED_MC */
 
+/*
+ * book sched-domains:
+ */
+#ifdef CONFIG_SCHED_BOOK
+static DEFINE_PER_CPU(struct static_sched_domain, book_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_book);
+
+static int
+cpu_to_book_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *mask)
+{
+	int group = cpu;
+#ifdef CONFIG_SCHED_MC
+	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
+	group = cpumask_first(mask);
+#elif defined(CONFIG_SCHED_SMT)
+	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
+	group = cpumask_first(mask);
+#endif
+	if (sg)
+		*sg = &per_cpu(sched_group_book, group).sg;
+	return group;
+}
+#endif /* CONFIG_SCHED_BOOK */
+
 static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
 
@@ -6580,7 +6607,10 @@ cpu_to_phys_group(int cpu, const struct
 		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
-#ifdef CONFIG_SCHED_MC
+#ifdef CONFIG_SCHED_BOOK
+	cpumask_and(mask, cpu_book_mask(cpu), cpu_map);
+	group = cpumask_first(mask);
+#elif defined(CONFIG_SCHED_MC)
 	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
 	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
@@ -6841,6 +6871,9 @@ SD_INIT_FUNC(CPU)
 #ifdef CONFIG_SCHED_MC
  SD_INIT_FUNC(MC)
 #endif
+#ifdef CONFIG_SCHED_BOOK
+ SD_INIT_FUNC(BOOK)
+#endif
 
 static int default_relax_domain_level = -1;
 
@@ -6890,6 +6923,8 @@ static void __free_domain_allocs(struct
 		free_cpumask_var(d->tmpmask); /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
+	case sa_this_book_map:
+		free_cpumask_var(d->this_book_map); /* fall through */
 	case sa_this_core_map:
 		free_cpumask_var(d->this_core_map); /* fall through */
 	case sa_this_sibling_map:
@@ -6936,8 +6971,10 @@ static enum s_alloc __visit_domain_alloc
 		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
 		return sa_this_sibling_map;
-	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d->this_book_map, GFP_KERNEL))
 		return sa_this_core_map;
+	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+		return sa_this_book_map;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
@@ -6995,6 +7032,23 @@ static struct sched_domain *__build_cpu_
 	return sd;
 }
 
+static struct sched_domain *__build_book_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
+#ifdef CONFIG_SCHED_BOOK
+	sd = &per_cpu(book_domains, i).sd;
+	SD_INIT(sd, BOOK);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_book_group(i, cpu_map, &sd->groups, d->tmpmask);
+#endif
+	return sd;
+}
+
 static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
 	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 	struct sched_domain *parent, int i)
@@ -7052,6 +7106,15 @@ static void build_sched_groups(struct s_
 						d->send_covered, d->tmpmask);
 		break;
 #endif
+#ifdef CONFIG_SCHED_BOOK
+	case SD_LV_BOOK: /* set up book groups */
+		cpumask_and(d->this_book_map, cpu_map, cpu_book_mask(cpu));
+		if (cpu == cpumask_first(d->this_book_map))
+			init_sched_build_groups(d->this_book_map, cpu_map,
+						&cpu_to_book_group,
+						d->send_covered, d->tmpmask);
+		break;
+#endif
 	case SD_LV_CPU: /* set up physical groups */
 		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
 		if (!cpumask_empty(d->nodemask))
@@ -7099,12 +7162,14 @@ static int __build_sched_domains(const s
 
 		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
+		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 	}
 
 	for_each_cpu(i, cpu_map) {
 		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
+		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
 	}
 
@@ -7135,6 +7200,12 @@ static int __build_sched_domains(const s
 		init_sched_groups_power(i, sd);
 	}
 #endif
+#ifdef CONFIG_SCHED_BOOK
+	for_each_cpu(i, cpu_map) {
+		sd = &per_cpu(book_domains, i).sd;
+		init_sched_groups_power(i, sd);
+	}
+#endif
 
 	for_each_cpu(i, cpu_map) {
 		sd = &per_cpu(phys_domains, i).sd;
@@ -7160,6 +7231,8 @@ static int __build_sched_domains(const s
 		sd = &per_cpu(cpu_domains, i).sd;
 #elif defined(CONFIG_SCHED_MC)
 		sd = &per_cpu(core_domains, i).sd;
+#elif defined(CONFIG_SCHED_BOOK)
+		sd = &per_cpu(book_domains, i).sd;
 #else
 		sd = &per_cpu(phys_domains, i).sd;
 #endif

