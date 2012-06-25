Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2FYUiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:38:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:22174 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095Ab2FYUiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:38:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="158064571"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, agordeev@redhat.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org
Subject: [PATCH v3 1/3] x86, apic: optimize cpu traversal in __assign_irq_vector() using domain membership
Date: Mon, 25 Jun 2012 13:38:27 -0700
Message-Id: <1340656709-11423-2-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340656709-11423-1-git-send-email-suresh.b.siddha@intel.com>
References: <1340656709-11423-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently __assign_irq_vector() goes through each cpu in the specified mask
until it finds a free vector in all the cpu's that are part of the same
interrupt domain. We visit all the interrupt domain sibling cpus to reserve
the free vector. So, when we fail to find a free vector in an interrupt
domain, it is safe to continue our search with a cpu belonging to a new
interrupt domain. No need to go through each cpu, if the domain
containing that cpu is already visited.

Use the irq_cfg's old_domain to track the visited domains and optimize
the cpu traversal while finding a free vector in the given cpumask.

NOTE: We can also optimize the search by using for_each_cpu and skip the
current cpu, if it is not the first cpu in the mask returned by the
vector_allocation_domain(). But re-using the cfg->old_domain to track
the visited domains will be slightly faster.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apic.h           |    8 +++-----
 arch/x86/kernel/apic/apic_noop.c      |    3 +--
 arch/x86/kernel/apic/io_apic.c        |   15 ++++++++-------
 arch/x86/kernel/apic/x2apic_cluster.c |    3 +--
 arch/x86/kernel/vsmp_64.c             |    3 +--
 5 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 8619a87..b37fa12 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,7 +306,7 @@ struct apic {
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -614,7 +614,7 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       const struct cpumask *andmask,
 			       unsigned int *apicid);
 
-static inline bool
+static inline void
 flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
@@ -627,14 +627,12 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	 */
 	cpumask_clear(retmask);
 	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
-	return false;
 }
 
-static inline bool
+static inline void
 default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_copy(retmask, cpumask_of(cpu));
-	return true;
 }
 
 static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 65c07fc..08c337b 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -100,12 +100,11 @@ static unsigned long noop_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static bool noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
 	cpumask_copy(retmask, cpumask_of(cpu));
-	return true;
 }
 
 static u32 noop_apic_read(u32 reg)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 99a794d..7a945f8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1134,12 +1134,13 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
-	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+	cpumask_clear(cfg->old_domain);
+	cpu = cpumask_first_and(mask, cpu_online_mask);
+	while (cpu < nr_cpu_ids) {
 		int new_cpu;
 		int vector, offset;
-		bool more_domains;
 
-		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
+		apic->vector_allocation_domain(cpu, tmp_mask);
 
 		if (cpumask_subset(tmp_mask, cfg->domain)) {
 			free_cpumask_var(tmp_mask);
@@ -1156,10 +1157,10 @@ next:
 		}
 
 		if (unlikely(current_vector == vector)) {
-			if (more_domains)
-				continue;
-			else
-				break;
+			cpumask_or(cfg->old_domain, cfg->old_domain, tmp_mask);
+			cpumask_andnot(tmp_mask, mask, cfg->old_domain);
+			cpu = cpumask_first_and(tmp_mask, cpu_online_mask);
+			continue;
 		}
 
 		if (test_bit(vector, used_vectors))
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 943d03f..b5d889b 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -212,11 +212,10 @@ static int x2apic_cluster_probe(void)
 /*
  * Each x2apic cluster is an allocation domain.
  */
-static bool cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
 	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
-	return true;
 }
 
 static struct apic apic_x2apic_cluster = {
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index fa5adb7..3f0285a 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -208,10 +208,9 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  * In vSMP, all cpus should be capable of handling interrupts, regardless of
  * the APIC used.
  */
-static bool fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_setall(retmask);
-	return false;
 }
 
 static void vsmp_apic_post_init(void)
-- 
1.7.6.5

