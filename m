Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1DGMmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:42:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab1DGMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:56 -0400
Message-Id: <20110407122942.969433965@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:10:04 +0200
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
Subject: [PATCH 23/23] sched: Dynamic sched_domain::level
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo21.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the SD_LV_ enum and use dynamic level assignments.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |   23 +++--------------------
 kernel/cpuset.c       |    2 +-
 kernel/sched.c        |    9 ++++++---
 3 files changed, 10 insertions(+), 24 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -891,25 +891,6 @@ static inline struct cpumask *sched_grou
 	return to_cpumask(sg->cpumask);
 }
 
-enum sched_domain_level {
-	SD_LV_NONE = 0,
-#ifdef CONFIG_SCHED_SMT
-	SD_LV_SIBLING,
-#endif
-#ifdef CONFIG_SCHED_MC
-	SD_LV_MC,
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	SD_LV_BOOK,
-#endif
-	SD_LV_CPU,
-#ifdef CONFIG_NUMA
-	SD_LV_NODE,
-	SD_LV_ALLNODES,
-#endif
-	SD_LV_MAX
-};
-
 struct sched_domain_attr {
 	int relax_domain_level;
 };
@@ -918,6 +899,8 @@ struct sched_domain_attr {
 	.relax_domain_level = -1,			\
 }
 
+extern int sched_domain_level_max;
+
 struct sched_domain {
 	/* These fields must be setup */
 	struct sched_domain *parent;	/* top domain must be null terminated */
@@ -935,7 +918,7 @@ struct sched_domain {
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
 	int flags;			/* See SD_* */
-	enum sched_domain_level level;
+	int level;
 
 	/* Runtime fields. */
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -1164,7 +1164,7 @@ int current_cpuset_is_being_rebound(void
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-	if (val < -1 || val >= SD_LV_MAX)
+	if (val < -1 || val >= sched_domain_level_max)
 		return -EINVAL;
 #endif
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6942,7 +6942,6 @@ sd_init_##type(struct sched_domain_topol
 {									\
 	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);	\
 	*sd = SD_##type##_INIT;						\
-	sd->level = SD_LV_##type;					\
 	SD_INIT_NAME(sd, type);						\
 	sd->private = &tl->data;					\
 	return sd;							\
@@ -6964,13 +6963,14 @@ SD_INIT_FUNC(CPU)
 #endif
 
 static int default_relax_domain_level = -1;
+int sched_domain_level_max;
 
 static int __init setup_relax_domain_level(char *str)
 {
 	unsigned long val;
 
 	val = simple_strtoul(str, NULL, 0);
-	if (val < SD_LV_MAX)
+	if (val < sched_domain_level_max)
 		default_relax_domain_level = val;
 
 	return 1;
@@ -7149,8 +7149,11 @@ struct sched_domain *build_sched_domain(
 
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
-	if (child)
+	if (child) {
+		sd->level = child->level + 1;
+		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
+	}
 	sd->child = child;
 
 	return sd;


