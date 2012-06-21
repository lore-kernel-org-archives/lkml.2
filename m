Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab2FUWCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:02:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:1314 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760480Ab2FUWCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:02:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168713982"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Subject: [PATCH v2 2/3] x86, x2apic: limit the vector reservation to the user specified mask
Date: Thu, 21 Jun 2012 15:02:24 -0700
Message-Id: <1340316145-4431-3-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
References: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the x2apic cluster mode, vector for an interrupt is currently reserved on
all the cpu's that are part of the x2apic cluster. But the interrupts will
be routed only to the cluster (derived from the first cpu in the mask) members
specified in the mask. So there is no need to reserve the vector in the unused
cluster members.

Modify __assign_irq_vector() to reserve the vectors based on the user
specified irq destination mask. If the new mask is a proper subset of
the currently used mask, cleanup the vector allocation on the unused cpu
members.

Also, allow the apic driver to tune the vector domain based on the
affinity mask (which in most cases is the user-specified mask).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/apic.h           |    9 ++++++---
 arch/x86/kernel/apic/apic_noop.c      |    3 ++-
 arch/x86/kernel/apic/io_apic.c        |   31 +++++++++++++++----------------
 arch/x86/kernel/apic/x2apic_cluster.c |    6 +++---
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b37fa12..c276809 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,7 +306,8 @@ struct apic {
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask,
+					 const struct cpumask *mask);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -615,7 +616,8 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       unsigned int *apicid);
 
 static inline void
-flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
+flat_vector_allocation_domain(int cpu, struct cpumask *retmask,
+			      const struct cpumask *mask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -630,7 +632,8 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 }
 
 static inline void
-default_vector_allocation_domain(int cpu, struct cpumask *retmask)
+default_vector_allocation_domain(int cpu, struct cpumask *retmask,
+				 const struct cpumask *mask)
 {
 	cpumask_copy(retmask, cpumask_of(cpu));
 }
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 08c337b..e145f28 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -100,7 +100,8 @@ static unsigned long noop_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask,
+					  const struct cpumask *mask)
 {
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7a945f8..406eee7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1113,7 +1113,6 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	 */
 	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
 	static int current_offset = VECTOR_OFFSET_START % 16;
-	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
 
@@ -1123,28 +1122,28 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
 		return -ENOMEM;
 
-	old_vector = cfg->vector;
-	if (old_vector) {
-		cpumask_and(tmp_mask, mask, cpu_online_mask);
-		if (cpumask_subset(tmp_mask, cfg->domain)) {
-			free_cpumask_var(tmp_mask);
-			return 0;
-		}
-	}
-
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
 	cpumask_clear(cfg->old_domain);
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	while (cpu < nr_cpu_ids) {
-		int new_cpu;
-		int vector, offset;
+		int new_cpu, vector, offset;
 
-		apic->vector_allocation_domain(cpu, tmp_mask);
+		apic->vector_allocation_domain(cpu, tmp_mask, mask);
 
 		if (cpumask_subset(tmp_mask, cfg->domain)) {
-			free_cpumask_var(tmp_mask);
-			return 0;
+			err = 0;
+			if (cpumask_equal(tmp_mask, cfg->domain))
+				break;
+			/*
+			 * New cpumask using the vector is a proper subset of
+			 * the current in use mask. So cleanup the vector
+			 * allocation for the members that are not used anymore.
+			 */
+			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
+			cfg->move_in_progress = 1;
+			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
+			break;
 		}
 
 		vector = current_vector;
@@ -1172,7 +1171,7 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		if (old_vector) {
+		if (cfg->vector) {
 			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index b5d889b..bde78d0 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -212,10 +212,10 @@ static int x2apic_cluster_probe(void)
 /*
  * Each x2apic cluster is an allocation domain.
  */
-static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask,
+					     const struct cpumask *mask)
 {
-	cpumask_clear(retmask);
-	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
+	cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
 }
 
 static struct apic apic_x2apic_cluster = {
-- 
1.7.6.5

