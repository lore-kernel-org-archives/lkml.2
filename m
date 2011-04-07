Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1DGMmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:42:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1DGMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:56 -0400
Message-Id: <20110407122942.077862519@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:47 +0200
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
Subject: [PATCH 06/23] sched: Simplify sched_group creation
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling build_sched_groups() for each possible sched_domain
we might have created, note that we can simply iterate the
sched_domain tree and call it for each sched_domain present.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7207,15 +7207,12 @@ static struct sched_domain *__build_smt_
 	return sd;
 }
 
-static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
+static void build_sched_groups(struct s_data *d, struct sched_domain *sd,
 			       const struct cpumask *cpu_map, int cpu)
 {
-	struct sched_domain *sd;
-
-	switch (l) {
+	switch (sd->level) {
 #ifdef CONFIG_SCHED_SMT
 	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
-		sd = &per_cpu(cpu_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_cpu_group,
@@ -7224,7 +7221,6 @@ static void build_sched_groups(struct s_
 #endif
 #ifdef CONFIG_SCHED_MC
 	case SD_LV_MC: /* set up multi-core groups */
-		sd = &per_cpu(core_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_core_group,
@@ -7233,7 +7229,6 @@ static void build_sched_groups(struct s_
 #endif
 #ifdef CONFIG_SCHED_BOOK
 	case SD_LV_BOOK: /* set up book groups */
-		sd = &per_cpu(book_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_book_group,
@@ -7241,7 +7236,6 @@ static void build_sched_groups(struct s_
 		break;
 #endif
 	case SD_LV_CPU: /* set up physical groups */
-		sd = &per_cpu(phys_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_phys_group,
@@ -7249,7 +7243,6 @@ static void build_sched_groups(struct s_
 		break;
 #ifdef CONFIG_NUMA
 	case SD_LV_NODE:
-		sd = &per_cpu(node_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_node_group,
@@ -7299,17 +7292,10 @@ static int __build_sched_domains(const s
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 
-		for (tmp = sd; tmp; tmp = tmp->parent)
+		for (tmp = sd; tmp; tmp = tmp->parent) {
 			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
-	}
-
-	for_each_cpu(i, cpu_map) {
-		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
-		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
-		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
-		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
-		build_sched_groups(&d, SD_LV_NODE, cpu_map, i);
-		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, i);
+			build_sched_groups(&d, tmp, cpu_map, i);
+		}
 	}
 
 	/* Calculate CPU power for physical packages and nodes */


