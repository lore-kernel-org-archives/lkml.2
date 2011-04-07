Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1DGMoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:44:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1DGMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:52 -0400
Message-Id: <20110407122942.455464579@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:54 +0200
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
Subject: [PATCH 13/23] sched: Simplify NODE/ALLNODES domain creation
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo11.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't treat ALLNODES/NODE different for difference's sake. Simply
always create the ALLNODES domain and let the sd_degenerate() checks
kill it when its redundant. This simplifies the code flow.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6814,9 +6814,6 @@ struct sd_data {
 };
 
 struct s_data {
-#ifdef CONFIG_NUMA
-	int			sd_allnodes;
-#endif
 	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
 	struct sched_domain ** __percpu sd;
@@ -7088,30 +7085,35 @@ static void claim_allocations(int cpu, s
 	}
 }
 
-static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
+static struct sched_domain *__build_allnodes_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
 {
 	struct sched_domain *sd = NULL;
 #ifdef CONFIG_NUMA
-	struct sched_domain *parent;
-
-	d->sd_allnodes = 0;
-	if (cpumask_weight(cpu_map) >
-	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
-		sd = sd_init_ALLNODES(d, i);
-		set_domain_attribute(sd, attr);
-		cpumask_copy(sched_domain_span(sd), cpu_map);
-		d->sd_allnodes = 1;
-	}
-	parent = sd;
+	sd = sd_init_ALLNODES(d, i);
+	set_domain_attribute(sd, attr);
+	cpumask_copy(sched_domain_span(sd), cpu_map);
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+#endif
+	return sd;
+}
 
+static struct sched_domain *__build_node_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = NULL;
+#ifdef CONFIG_NUMA
 	sd = sd_init_NODE(d, i);
 	set_domain_attribute(sd, attr);
 	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
+	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
-	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
 #endif
 	return sd;
 }
@@ -7196,7 +7198,9 @@ static int __build_sched_domains(const s
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
 
-		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
+		sd = NULL;
+		sd = __build_allnodes_sched_domain(&d, cpu_map, attr, sd, i);
+		sd = __build_node_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);


