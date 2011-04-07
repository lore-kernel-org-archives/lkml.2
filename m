Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1DGMkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:40:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:48151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1DGMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:52 -0400
Message-Id: <20110407122942.876506131@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:10:02 +0200
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
Subject: [PATCH 21/23] sched: Reverse the topology list
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo19.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get rid of static sched_domain::level assignments, reverse
the topology iteration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7090,20 +7090,23 @@ static const struct cpumask *cpu_smt_mas
 }
 #endif
 
+/*
+ * Topology list, bottom-up.
+ */
 static struct sched_domain_topology_level default_topology[] = {
-#ifdef CONFIG_NUMA
-	{ sd_init_ALLNODES, cpu_allnodes_mask, },
-	{ sd_init_NODE, cpu_node_mask, },
-#endif
-	{ sd_init_CPU, cpu_cpu_mask, },
-#ifdef CONFIG_SCHED_BOOK
-	{ sd_init_BOOK, cpu_book_mask, },
+#ifdef CONFIG_SCHED_SMT
+	{ sd_init_SIBLING, cpu_smt_mask, },
 #endif
 #ifdef CONFIG_SCHED_MC
 	{ sd_init_MC, cpu_coregroup_mask, },
 #endif
-#ifdef CONFIG_SCHED_SMT
-	{ sd_init_SIBLING, cpu_smt_mask, },
+#ifdef CONFIG_SCHED_BOOK
+	{ sd_init_BOOK, cpu_book_mask, },
+#endif
+	{ sd_init_CPU, cpu_cpu_mask, },
+#ifdef CONFIG_NUMA
+	{ sd_init_NODE, cpu_node_mask, },
+	{ sd_init_ALLNODES, cpu_allnodes_mask, },
 #endif
 	{ NULL, },
 };
@@ -7112,18 +7115,18 @@ static struct sched_domain_topology_leve
 
 struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		struct s_data *d, const struct cpumask *cpu_map,
-		struct sched_domain_attr *attr, struct sched_domain *parent,
+		struct sched_domain_attr *attr, struct sched_domain *child,
 		int cpu)
 {
 	struct sched_domain *sd = tl->init(d, cpu);
 	if (!sd)
-		return parent;
+		return child;
 
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
+	if (child)
+		child->parent = sd;
+	sd->child = child;
 
 	return sd;
 }
@@ -7152,6 +7155,9 @@ static int __build_sched_domains(const s
 		for (tl = sched_domain_topology; tl->init; tl++)
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
 
+		while (sd->child)
+			sd = sd->child;
+
 		*per_cpu_ptr(d.sd, i) = sd;
 	}
 


