Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1DGMlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:41:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60249 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab1DGMlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:41:01 -0400
Message-Id: <20110407122941.875856012@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:43 +0200
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
Subject: [PATCH 02/23] sched: Simplify cpu_power initialization
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-simplify-cpu_power.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in update_group_power() does what init_sched_groups_power()
does and more, so remove the special init_ code and call the generic
code instead.

Also move the sd->span_weight initialization because
update_group_power() needs it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   44 +++++---------------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6655,9 +6655,6 @@ cpu_attach_domain(struct sched_domain *s
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
 
-	for (tmp = sd; tmp; tmp = tmp->parent)
-		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
-
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
@@ -7135,11 +7132,6 @@ static void free_sched_groups(const stru
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
-	struct sched_domain *child;
-	struct sched_group *group;
-	long power;
-	int weight;
-
 	WARN_ON(!sd || !sd->groups);
 
 	if (cpu != group_first_cpu(sd->groups))
@@ -7147,36 +7139,7 @@ static void init_sched_groups_power(int
 
 	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
 
-	child = sd->child;
-
-	sd->groups->cpu_power = 0;
-
-	if (!child) {
-		power = SCHED_LOAD_SCALE;
-		weight = cpumask_weight(sched_domain_span(sd));
-		/*
-		 * SMT siblings share the power of a single core.
-		 * Usually multiple threads get a better yield out of
-		 * that one core than a single thread would have,
-		 * reflect that in sd->smt_gain.
-		 */
-		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-			power *= sd->smt_gain;
-			power /= weight;
-			power >>= SCHED_LOAD_SHIFT;
-		}
-		sd->groups->cpu_power += power;
-		return;
-	}
-
-	/*
-	 * Add cpu_power of each child group to this groups cpu_power.
-	 */
-	group = child->groups;
-	do {
-		sd->groups->cpu_power += group->cpu_power;
-		group = group->next;
-	} while (group != child->groups);
+	update_group_power(sd, cpu);
 }
 
 /*
@@ -7483,7 +7446,7 @@ static int __build_sched_domains(const s
 {
 	enum s_alloc alloc_state = sa_none;
 	struct s_data d;
-	struct sched_domain *sd;
+	struct sched_domain *sd, *tmp;
 	int i;
 #ifdef CONFIG_NUMA
 	d.sd_allnodes = 0;
@@ -7506,6 +7469,9 @@ static int __build_sched_domains(const s
 		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
+
+		for (tmp = sd; tmp; tmp = tmp->parent)
+			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
 	}
 
 	for_each_cpu(i, cpu_map) {


