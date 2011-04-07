Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1DGMoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:44:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1DGMkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:53 -0400
Message-Id: <20110407122942.505608966@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:55 +0200
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
Subject: [PATCH 14/23] sched: Remove nodemask allocation
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo12.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one nodemask user left so remove it with a direct
computation and save some memory and reduce some code-flow
complexity.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6814,7 +6814,6 @@ struct sd_data {
 };
 
 struct s_data {
-	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
 	struct sched_domain ** __percpu sd;
 	struct sd_data 		sdd[SD_LV_MAX];
@@ -6826,7 +6825,6 @@ enum s_alloc {
 	sa_sd,
 	sa_sd_storage,
 	sa_send_covered,
-	sa_nodemask,
 	sa_none,
 };
 
@@ -7011,8 +7009,6 @@ static void __free_domain_allocs(struct 
 		} /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
-	case sa_nodemask:
-		free_cpumask_var(d->nodemask); /* fall through */
 	case sa_none:
 		break;
 	}
@@ -7025,10 +7021,8 @@ static enum s_alloc __visit_domain_alloc
 
 	memset(d, 0, sizeof(*d));
 
-	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
-		return sa_none;
 	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
-		return sa_nodemask;
+		return sa_none;
 	for (i = 0; i < SD_LV_MAX; i++) {
 		d->sdd[i].sd = alloc_percpu(struct sched_domain *);
 		if (!d->sdd[i].sd)
@@ -7125,7 +7119,8 @@ static struct sched_domain *__build_cpu_
 	struct sched_domain *sd;
 	sd = sd_init_CPU(d, i);
 	set_domain_attribute(sd, attr);
-	cpumask_copy(sched_domain_span(sd), d->nodemask);
+	cpumask_and(sched_domain_span(sd),
+			cpumask_of_node(cpu_to_node(i)), cpu_map);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
@@ -7195,9 +7190,6 @@ static int __build_sched_domains(const s
 
 	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
-		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
-			    cpu_map);
-
 		sd = NULL;
 		sd = __build_allnodes_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_node_sched_domain(&d, cpu_map, attr, sd, i);


