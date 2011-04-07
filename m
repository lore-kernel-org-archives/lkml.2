Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1DGMoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:44:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60227 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1DGMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:54 -0400
Message-Id: <20110407122942.770335383@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:10:00 +0200
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
Subject: [PATCH 19/23] sched: Stuff the sched_domain creation in a data-structure
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo17.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make the topology contruction fully dynamic, remove the
still hard-coded list of possible domains and stuck them in a
data-structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6819,6 +6819,16 @@ enum s_alloc {
 	sa_none,
 };
 
+typedef struct sched_domain *(*sched_domain_build_f)(struct s_data *d,
+		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+		struct sched_domain *parent, int cpu);
+
+typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
+
+struct sched_domain_topology_level {
+	sched_domain_build_f build;
+};
+
 /*
  * Assumes the sched_domain tree is fully constructed
  */
@@ -7161,6 +7171,18 @@ static struct sched_domain *__build_smt_
 	return sd;
 }
 
+static struct sched_domain_topology_level default_topology[] = {
+	{ __build_allnodes_sched_domain, },
+	{ __build_node_sched_domain, },
+	{ __build_cpu_sched_domain, },
+	{ __build_book_sched_domain, },
+	{ __build_mc_sched_domain, },
+	{ __build_smt_sched_domain, },
+	{ NULL, },
+};
+
+static struct sched_domain_topology_level *sched_domain_topology = default_topology;
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -7179,13 +7201,11 @@ static int __build_sched_domains(const s
 
 	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
+		struct sched_domain_topology_level *tl;
+
 		sd = NULL;
-		sd = __build_allnodes_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_node_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
+		for (tl = sched_domain_topology; tl->build; tl++)
+			sd = tl->build(&d, cpu_map, attr, sd, i);
 
 		*per_cpu_ptr(d.sd, i) = sd;
 	}


