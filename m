Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1DGMk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:40:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:48152 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1DGMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:52 -0400
Message-Id: <20110407122942.664347467@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:58 +0200
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
Subject: [PATCH 17/23] sched: Avoid allocations in sched_domain_debug()
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo23.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we're all serialized by sched_domains_mutex we can use
sched_domains_tmpmask and avoid having to do allocations. This means
we can use sched_domains_debug() for cpu_attach_domain() again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6393,6 +6393,8 @@ static int __init sched_domain_debug_set
 }
 early_param("sched_debug", sched_domain_debug_setup);
 
+static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
+
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
 {
@@ -6476,7 +6478,6 @@ static int sched_domain_debug_one(struct
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
-	cpumask_var_t groupmask;
 	int level = 0;
 
 	if (!sched_domain_debug_enabled)
@@ -6489,20 +6490,14 @@ static void sched_domain_debug(struct sc
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
-	if (!alloc_cpumask_var(&groupmask, GFP_KERNEL)) {
-		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
-		return;
-	}
-
 	for (;;) {
-		if (sched_domain_debug_one(sd, cpu, level, groupmask))
+		if (sched_domain_debug_one(sd, cpu, level, sched_domains_tmpmask))
 			break;
 		level++;
 		sd = sd->parent;
 		if (!sd)
 			break;
 	}
-	free_cpumask_var(groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -6707,7 +6702,7 @@ cpu_attach_domain(struct sched_domain *s
 			sd->child = NULL;
 	}
 
-//	sched_domain_debug(sd, cpu);
+	sched_domain_debug(sd, cpu);
 
 	rq_attach_root(rq, rd);
 	tmp = rq->sd;
@@ -6837,8 +6832,6 @@ static int get_group(int cpu, struct sd_
 	return cpu;
 }
 
-static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
-
 /*
  * build_sched_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
@@ -7225,7 +7218,6 @@ static int build_sched_domains(const str
 	for_each_cpu(i, cpu_map) {
 		sd = *per_cpu_ptr(d.sd, i);
 		cpu_attach_domain(sd, d.rd, i);
-//		sched_domain_debug(sd, i);
 	}
 	rcu_read_unlock();
 


