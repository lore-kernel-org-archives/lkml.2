Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1DGMlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:41:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab1DGMlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:41:11 -0400
Message-Id: <20110407122942.826347257@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:10:01 +0200
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
Subject: [PATCH 20/23] sched: Unify the sched_domain build functions
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo18.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all the __build_$DOM_sched_domain() functions do pretty much the
same thing, unify them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |  133 ++++++++++++++++-----------------------------------------
 1 file changed, 39 insertions(+), 94 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6792,6 +6792,11 @@ static const struct cpumask *cpu_node_ma
 
 	return sched_domains_tmpmask;
 }
+
+static const struct cpumask *cpu_allnodes_mask(int cpu)
+{
+	return cpu_possible_mask;
+}
 #endif /* CONFIG_NUMA */
 
 static const struct cpumask *cpu_cpu_mask(int cpu)
@@ -6819,14 +6824,12 @@ enum s_alloc {
 	sa_none,
 };
 
-typedef struct sched_domain *(*sched_domain_build_f)(struct s_data *d,
-		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-		struct sched_domain *parent, int cpu);
-
+typedef struct sched_domain *(*sched_domain_init_f)(struct s_data *d, int cpu);
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 struct sched_domain_topology_level {
-	sched_domain_build_f build;
+	sched_domain_init_f init;
+	sched_domain_mask_f mask;
 };
 
 /*
@@ -7080,109 +7083,51 @@ static void claim_allocations(int cpu, s
 	}
 }
 
-static struct sched_domain *__build_allnodes_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
+#ifdef CONFIG_SCHED_SMT
+static const struct cpumask *cpu_smt_mask(int cpu)
 {
-	struct sched_domain *sd = NULL;
-#ifdef CONFIG_NUMA
-	sd = sd_init_ALLNODES(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_possible_mask);
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
-#endif
-	return sd;
+	return topology_thread_cpumask(cpu);
 }
+#endif
 
-static struct sched_domain *__build_node_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = NULL;
+static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_NUMA
-	sd = sd_init_NODE(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_node_mask(i));
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
+	{ sd_init_ALLNODES, cpu_allnodes_mask, },
+	{ sd_init_NODE, cpu_node_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd;
-	sd = sd_init_CPU(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_cpu_mask(i));
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
-	return sd;
-}
-
-static struct sched_domain *__build_book_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
+	{ sd_init_CPU, cpu_cpu_mask, },
 #ifdef CONFIG_SCHED_BOOK
-	sd = sd_init_BOOK(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
-	sd->parent = parent;
-	parent->child = sd;
+	{ sd_init_BOOK, cpu_book_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_MC
-	sd = sd_init_MC(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
-	sd->parent = parent;
-	parent->child = sd;
+	{ sd_init_MC, cpu_coregroup_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_SMT
-	sd = sd_init_SIBLING(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, topology_thread_cpumask(i));
-	sd->parent = parent;
-	parent->child = sd;
+	{ sd_init_SIBLING, cpu_smt_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain_topology_level default_topology[] = {
-	{ __build_allnodes_sched_domain, },
-	{ __build_node_sched_domain, },
-	{ __build_cpu_sched_domain, },
-	{ __build_book_sched_domain, },
-	{ __build_mc_sched_domain, },
-	{ __build_smt_sched_domain, },
 	{ NULL, },
 };
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
+		struct s_data *d, const struct cpumask *cpu_map,
+		struct sched_domain_attr *attr, struct sched_domain *parent,
+		int cpu)
+{
+	struct sched_domain *sd = tl->init(d, cpu);
+	if (!sd)
+		return parent;
+
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+
+	return sd;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -7204,8 +7149,8 @@ static int __build_sched_domains(const s
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->build; tl++)
-			sd = tl->build(&d, cpu_map, attr, sd, i);
+		for (tl = sched_domain_topology; tl->init; tl++)
+			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
 
 		*per_cpu_ptr(d.sd, i) = sd;
 	}


