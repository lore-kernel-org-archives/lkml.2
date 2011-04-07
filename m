Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1DGMlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:41:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:48203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1DGMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:41:14 -0400
Message-Id: <20110407122942.717702108@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:59 +0200
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
Subject: [PATCH 18/23] sched: Create proper cpu_$DOM_mask() functions
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo16.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to unify the sched domain creation more, create proper
cpu_$DOM_mask() functions for those domains that didn't already have
one.

Use the sched_domains_tmpmask for the weird NUMA domain span.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6793,8 +6793,22 @@ static void sched_domain_node_span(int n
 		cpumask_or(span, span, cpumask_of_node(next_node));
 	}
 }
+
+static const struct cpumask *cpu_node_mask(int cpu)
+{
+	lockdep_assert_held(&sched_domains_mutex);
+
+	sched_domain_node_span(cpu_to_node(cpu), sched_domains_tmpmask);
+
+	return sched_domains_tmpmask;
+}
 #endif /* CONFIG_NUMA */
 
+static const struct cpumask *cpu_cpu_mask(int cpu)
+{
+	return cpumask_of_node(cpu_to_node(cpu));
+}
+
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
 struct sd_data {
@@ -7074,7 +7088,7 @@ static struct sched_domain *__build_alln
 #ifdef CONFIG_NUMA
 	sd = sd_init_ALLNODES(d, i);
 	set_domain_attribute(sd, attr);
-	cpumask_copy(sched_domain_span(sd), cpu_map);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_possible_mask);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
@@ -7090,8 +7104,7 @@ static struct sched_domain *__build_node
 #ifdef CONFIG_NUMA
 	sd = sd_init_NODE(d, i);
 	set_domain_attribute(sd, attr);
-	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
-	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_node_mask(i));
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
@@ -7106,8 +7119,7 @@ static struct sched_domain *__build_cpu_
 	struct sched_domain *sd;
 	sd = sd_init_CPU(d, i);
 	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd),
-			cpumask_of_node(cpu_to_node(i)), cpu_map);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_cpu_mask(i));
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;


