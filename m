Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1DGMoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:44:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1DGMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:52 -0400
Message-Id: <20110407122942.134511046@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:48 +0200
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
Subject: [PATCH 07/23] sched: Simplify finding the lowest sched_domain
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of relying on knowing the build order and various CONFIG_
flags simply remember the bottom most sched_domain when we created the
domain hierarchy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-generic/percpu.h |    4 ++++
 kernel/sched.c               |   23 +++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6841,11 +6841,13 @@ struct s_data {
 	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
+	struct sched_domain ** __percpu sd;
 	struct root_domain	*rd;
 };
 
 enum s_alloc {
 	sa_rootdomain,
+	sa_sd,
 	sa_tmpmask,
 	sa_send_covered,
 	sa_nodemask,
@@ -7080,6 +7082,8 @@ static void __free_domain_allocs(struct
 	switch (what) {
 	case sa_rootdomain:
 		free_rootdomain(d->rd); /* fall through */
+	case sa_sd:
+		free_percpu(d->sd); /* fall through */
 	case sa_tmpmask:
 		free_cpumask_var(d->tmpmask); /* fall through */
 	case sa_send_covered:
@@ -7100,10 +7104,15 @@ static enum s_alloc __visit_domain_alloc
 		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
 		return sa_send_covered;
+	d->sd = alloc_percpu(struct sched_domain *);
+	if (!d->sd) {
+		printk(KERN_WARNING "Cannot alloc per-cpu pointers\n");
+		return sa_tmpmask;
+	}
 	d->rd = alloc_rootdomain();
 	if (!d->rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
-		return sa_tmpmask;
+		return sa_sd;
 	}
 	return sa_rootdomain;
 }
@@ -7292,6 +7301,8 @@ static int __build_sched_domains(const s
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 
+		*per_cpu_ptr(d.sd, i) = sd;
+
 		for (tmp = sd; tmp; tmp = tmp->parent) {
 			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
 			build_sched_groups(&d, tmp, cpu_map, i);
@@ -7339,15 +7350,7 @@ static int __build_sched_domains(const s
 
 	/* Attach the domains */
 	for_each_cpu(i, cpu_map) {
-#ifdef CONFIG_SCHED_SMT
-		sd = &per_cpu(cpu_domains, i).sd;
-#elif defined(CONFIG_SCHED_MC)
-		sd = &per_cpu(core_domains, i).sd;
-#elif defined(CONFIG_SCHED_BOOK)
-		sd = &per_cpu(book_domains, i).sd;
-#else
-		sd = &per_cpu(phys_domains, i).sd;
-#endif
+		sd = *per_cpu_ptr(d.sd, i);
 		cpu_attach_domain(sd, d.rd, i);
 	}
 


