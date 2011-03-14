Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1CNP1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:27:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab1CNP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:27:49 -0400
Message-Id: <20110314152227.100061459@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 14 Mar 2011 16:06:21 +0100
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
Subject: [RFC][PATCH 08/14] sched: Simplify sched_groups_power initialization
References: <20110314150613.749843433@chello.nl>
Content-Disposition: inline; filename=sched-foo7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, instead of relying on knowing the possible domains and their
order, simply rely on the sched_domain tree and whatever domains are
present in there to initialize the sched_group cpu_power.

Note: we need to iterate the CPU mask backwards because of the
cpumask_first() condition for iterating up the tree. By iterating the
mask backwards we ensure all groups of a domain are set-up before
starting on the parent groups that rely on its children to be
completely done.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   39 +++++----------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7310,43 +7310,14 @@ static int __build_sched_domains(const s
 	}
 
 	/* Calculate CPU power for physical packages and nodes */
-#ifdef CONFIG_SCHED_SMT
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(cpu_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
-#ifdef CONFIG_SCHED_MC
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(core_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(book_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
-
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(phys_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-
-#ifdef CONFIG_NUMA
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(node_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
+	for (i = nr_cpumask_bits-1; i >= 0; i--) {
+		if (!cpumask_test_cpu(i, cpu_map))
+			continue;
 
-	if (d.sd_allnodes) {
-		for_each_cpu(i, cpu_map) {
-			sd = &per_cpu(allnodes_domains, i).sd;
+		sd = *per_cpu_ptr(d.sd, i);
+		for (; sd; sd = sd->parent)
 			init_sched_groups_power(i, sd);
-		}
 	}
-#endif
 
 	/* Attach the domains */
 	for_each_cpu(i, cpu_map) {


