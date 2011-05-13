Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab1EMSWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:22:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:47009 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab1EMSVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="1391428"
Message-Id: <20110513181009.155612876@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 13 May 2011 11:04:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/5] x86, x2apic: Minimize IPI register writes using cluster groups
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=minimize_IPI_register_writes_using_cluster_groups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>
Subjct: x86, x2apic: Minimize IPI register writes using cluster groups

In the case of x2apic cluster mode we can group IPI register writes based
on the cluster group instead of individual per-cpu destination messages.

This reduces the apic register writes and reduces the amount of IPI messages
(in the best case we can reduce it by a factor of 16).

With this change, the cost of flush_tlb_others(), with the flush tlb IPI being
sent from a cpu in the socket-1 to all the logical cpus in socket-2 (on a
Westmere-EX system that has 20 logical cpus in a socket) is 3x times better now
(compared to the former 'send one-by-one' algorithm).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c |   58 +++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
@@ -5,6 +5,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/dmar.h>
+#include <linux/cpu.h>
 
 #include <asm/smp.h>
 #include <asm/apic.h>
@@ -12,6 +13,7 @@
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
+static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -54,30 +56,52 @@ static inline u32 x2apic_cluster(int cpu
 	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
 }
 
-/*
- * for now, we send the IPI's one by one in the cpumask.
- * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
- * at once. We have 16 cpu's in a cluster. This will minimize IPI register
- * writes.
- */
 static void
 __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
-	unsigned long query_cpu;
-	unsigned long this_cpu;
+	struct cpumask *cpus_in_cluster_ptr;
+	struct cpumask *ipi_mask_ptr;
+	unsigned int cpu, this_cpu;
 	unsigned long flags;
+	u32 dest;
 
 	x2apic_wrmsr_fence();
 
 	local_irq_save(flags);
 
 	this_cpu = smp_processor_id();
-	for_each_cpu(query_cpu, mask) {
-		if (apic_dest == APIC_DEST_ALLBUT && query_cpu == this_cpu)
+
+	/*
+	 * We are to modify mask, so we need an own copy
+	 * and be sure it's manipulated with irq off.
+	 */
+	ipi_mask_ptr = __raw_get_cpu_var(ipi_mask);
+	cpumask_copy(ipi_mask_ptr, mask);
+
+	/*
+	 * The idea is to send one IPI per cluster.
+	 */
+	for_each_cpu(cpu, ipi_mask_ptr) {
+		unsigned long i;
+
+		cpus_in_cluster_ptr = per_cpu(cpus_in_cluster, cpu);
+		dest = 0;
+
+		/* Collect cpus in cluster. */
+		for_each_cpu_and(i, ipi_mask_ptr, cpus_in_cluster_ptr) {
+			if (apic_dest == APIC_DEST_ALLINC || i != this_cpu)
+				dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+		}
+
+		if (!dest)
 			continue;
-		__x2apic_send_IPI_dest(
-			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, apic->dest_logical);
+
+		__x2apic_send_IPI_dest(dest, vector, apic->dest_logical);
+		/*
+		 * Cluster sibling cpus should be discared now so
+		 * we would not send IPI them second time.
+		 */
+		cpumask_andnot(ipi_mask_ptr, ipi_mask_ptr, cpus_in_cluster_ptr);
 	}
 
 	local_irq_restore(flags);
@@ -198,6 +222,10 @@ update_clusterinfo(struct notifier_block
 		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
 					GFP_KERNEL)) {
 			err = -ENOMEM;
+		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
+					       GFP_KERNEL)) {
+			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+			err = -ENOMEM;
 		}
 		break;
 	case CPU_UP_CANCELED:
@@ -210,6 +238,7 @@ update_clusterinfo(struct notifier_block
 			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
 		}
 		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
 		break;
 	}
 
@@ -225,8 +254,9 @@ static int x2apic_init_cpu_notifier(void
 	int cpu = smp_processor_id();
 
 	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
 
-	BUG_ON(!per_cpu(cpus_in_cluster, cpu));
+	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
 
 	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
 	register_hotcpu_notifier(&x2apic_cpu_notifier);


