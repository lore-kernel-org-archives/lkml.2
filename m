Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1DGMoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:44:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab1DGMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:54 -0400
Message-Id: <20110407122941.925028189@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:44 +0200
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
Subject: [PATCH 03/23] sched: Simplify build_sched_groups
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notice that the mask being computed is the same as the domain span we
just computed. By using the domain_span we can avoid some mask
allocations and computations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   52 ++++++++++++++++------------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6842,9 +6842,6 @@ struct s_data {
 	cpumask_var_t		notcovered;
 #endif
 	cpumask_var_t		nodemask;
-	cpumask_var_t		this_sibling_map;
-	cpumask_var_t		this_core_map;
-	cpumask_var_t		this_book_map;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
 	struct sched_group	**sched_group_nodes;
@@ -6856,9 +6853,6 @@ enum s_alloc {
 	sa_rootdomain,
 	sa_tmpmask,
 	sa_send_covered,
-	sa_this_book_map,
-	sa_this_core_map,
-	sa_this_sibling_map,
 	sa_nodemask,
 	sa_sched_group_nodes,
 #ifdef CONFIG_NUMA
@@ -7201,12 +7195,6 @@ static void __free_domain_allocs(struct
 		free_cpumask_var(d->tmpmask); /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
-	case sa_this_book_map:
-		free_cpumask_var(d->this_book_map); /* fall through */
-	case sa_this_core_map:
-		free_cpumask_var(d->this_core_map); /* fall through */
-	case sa_this_sibling_map:
-		free_cpumask_var(d->this_sibling_map); /* fall through */
 	case sa_nodemask:
 		free_cpumask_var(d->nodemask); /* fall through */
 	case sa_sched_group_nodes:
@@ -7245,14 +7233,8 @@ static enum s_alloc __visit_domain_alloc
 #endif
 	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
 		return sa_sched_group_nodes;
-	if (!alloc_cpumask_var(&d->this_sibling_map, GFP_KERNEL))
-		return sa_nodemask;
-	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
-		return sa_this_sibling_map;
-	if (!alloc_cpumask_var(&d->this_book_map, GFP_KERNEL))
-		return sa_this_core_map;
 	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
-		return sa_this_book_map;
+		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
@@ -7364,39 +7346,40 @@ static struct sched_domain *__build_smt_
 static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 			       const struct cpumask *cpu_map, int cpu)
 {
+	struct sched_domain *sd;
+
 	switch (l) {
 #ifdef CONFIG_SCHED_SMT
 	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
-		cpumask_and(d->this_sibling_map, cpu_map,
-			    topology_thread_cpumask(cpu));
-		if (cpu == cpumask_first(d->this_sibling_map))
-			init_sched_build_groups(d->this_sibling_map, cpu_map,
+		sd = &per_cpu(cpu_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_cpu_group,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
 #ifdef CONFIG_SCHED_MC
 	case SD_LV_MC: /* set up multi-core groups */
-		cpumask_and(d->this_core_map, cpu_map, cpu_coregroup_mask(cpu));
-		if (cpu == cpumask_first(d->this_core_map))
-			init_sched_build_groups(d->this_core_map, cpu_map,
+		sd = &per_cpu(core_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_core_group,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
 #ifdef CONFIG_SCHED_BOOK
 	case SD_LV_BOOK: /* set up book groups */
-		cpumask_and(d->this_book_map, cpu_map, cpu_book_mask(cpu));
-		if (cpu == cpumask_first(d->this_book_map))
-			init_sched_build_groups(d->this_book_map, cpu_map,
+		sd = &per_cpu(book_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_book_group,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
 	case SD_LV_CPU: /* set up physical groups */
-		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
-		if (!cpumask_empty(d->nodemask))
-			init_sched_build_groups(d->nodemask, cpu_map,
+		sd = &per_cpu(phys_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_phys_group,
 						d->send_covered, d->tmpmask);
 		break;
@@ -7452,11 +7435,8 @@ static int __build_sched_domains(const s
 		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
 		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
-	}
-
-	/* Set up physical groups */
-	for (i = 0; i < nr_node_ids; i++)
 		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
+	}
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */


