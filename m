Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161088Ab2ERK1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161032Ab2ERK1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:27:06 -0400
Date: Fri, 18 May 2012 12:26:59 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/3][RFC] x86: x2apic/cluster: Do not handle cpumask
 allocation errors
Message-ID: <20120518102659.GC31517@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this fix allocations of cpumasks are assumed always successfull
and possible failures result in BUG(). It allows few improvements:
  - the code that selects destination CPUs from a cpumask is cleaned
    and always returns the best possible subset of processors;
  - 'ipi_mask' per-cpu variable is eliminated;
  - copying of cpumask with local interrupts disabled is avoided;

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c |  107 ++++++++-------------------------
 1 files changed, 26 insertions(+), 81 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index f8fa4c4..e5770cd 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -12,7 +12,6 @@
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
-static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -28,35 +27,32 @@ static void
 __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
 	struct cpumask *cpus_in_cluster_ptr;
-	struct cpumask *ipi_mask_ptr;
 	unsigned int cpu, this_cpu;
 	unsigned long flags;
 	u32 dest;
+	cpumask_var_t tmp_mask;
 
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
+	if (unlikely(!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC)))
+		BUG();
+	cpumask_copy(tmp_mask, mask);
 
 	this_cpu = smp_processor_id();
 
-	/*
-	 * We are to modify mask, so we need an own copy
-	 * and be sure it's manipulated with irq off.
-	 */
-	ipi_mask_ptr = __raw_get_cpu_var(ipi_mask);
-	cpumask_copy(ipi_mask_ptr, mask);
+	x2apic_wrmsr_fence();
+
+	local_irq_save(flags);
 
 	/*
 	 * The idea is to send one IPI per cluster.
 	 */
-	for_each_cpu(cpu, ipi_mask_ptr) {
+	for_each_cpu(cpu, tmp_mask) {
 		unsigned long i;
 
 		cpus_in_cluster_ptr = per_cpu(cpus_in_cluster, cpu);
 		dest = 0;
 
 		/* Collect cpus in cluster. */
-		for_each_cpu_and(i, ipi_mask_ptr, cpus_in_cluster_ptr) {
+		for_each_cpu_and(i, tmp_mask, cpus_in_cluster_ptr) {
 			if (apic_dest == APIC_DEST_ALLINC || i != this_cpu)
 				dest |= per_cpu(x86_cpu_to_logical_apicid, i);
 		}
@@ -69,10 +65,12 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 		 * Cluster sibling cpus should be discared now so
 		 * we would not send IPI them second time.
 		 */
-		cpumask_andnot(ipi_mask_ptr, ipi_mask_ptr, cpus_in_cluster_ptr);
+		cpumask_andnot(tmp_mask, tmp_mask, cpus_in_cluster_ptr);
 	}
 
 	local_irq_restore(flags);
+
+	free_cpumask_var(tmp_mask);
 }
 
 static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
@@ -116,14 +114,10 @@ __x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
 	unsigned int weight, max_weight;
 	cpumask_var_t target_cpus, cluster_cpus;
 
-	if (unlikely(!alloc_cpumask_var(&target_cpus, GFP_ATOMIC))) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	if (unlikely(!alloc_cpumask_var(&cluster_cpus, GFP_ATOMIC))) {
-		ret = -ENOMEM;
-		goto out_free_target_cpus;
-	}
+	if (unlikely(!alloc_cpumask_var(&target_cpus, GFP_ATOMIC)))
+		BUG();
+	if (unlikely(!alloc_cpumask_var(&cluster_cpus, GFP_ATOMIC)))
+		BUG();
 
 	cpumask_and(target_cpus, cpumask, cpu_online_mask);
 	max_weight = 0;
@@ -149,34 +143,20 @@ __x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
 
 out_free_cluster_cpus:
 	free_cpumask_var(cluster_cpus);
-out_free_target_cpus:
 	free_cpumask_var(target_cpus);
-out:
+
 	return ret;
 }
 
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int err;
-	int cpu;
-	unsigned int apicid;
+	unsigned int apicid = BAD_APICID;
 
 	err = __x2apic_cpu_mask_to_apicid(cpumask, &apicid);
 	WARN_ON(err);
 
-	if (!err)
-		return apicid;
-
-	if (err == -ENOMEM) {
-		for_each_cpu(cpu, cpumask) {
-			if (cpumask_test_cpu(cpu, cpu_online_mask))
-				break;
-		}
-		if (cpu < nr_cpu_ids)
-			return __x2apic_cluster_to_apicid(cpu, cpumask);
-	}
-
-	return BAD_APICID;
+	return apicid;
 }
 
 static unsigned int
@@ -184,46 +164,17 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			      const struct cpumask *andmask)
 {
 	int err;
-	int cpu, first_cpu;
-	unsigned int apicid;
+	unsigned int apicid = 0;
 	cpumask_var_t target_cpus;
 
-	if (likely(alloc_cpumask_var(&target_cpus, GFP_ATOMIC))) {
-		cpumask_and(target_cpus, cpumask, andmask);
-
-		err = __x2apic_cpu_mask_to_apicid(target_cpus, &apicid);
-
-		free_cpumask_var(target_cpus);
-
-		if (!err)
-			return apicid;
-	} else {
-		err = -ENOMEM;
-	}
+	if (unlikely(!alloc_cpumask_var(&target_cpus, GFP_ATOMIC)))
+		BUG();
 
+	cpumask_and(target_cpus, cpumask, andmask);
+	err = __x2apic_cpu_mask_to_apicid(target_cpus, &apicid);
 	WARN_ON(err);
 
-	if (err != -ENOMEM)
-		return 0;
-
-	apicid = 0;
-	first_cpu = nr_cpu_ids;
-
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-			first_cpu = cpu;
-			break;
-		}
-	}
-
-	if (first_cpu < nr_cpu_ids) {
-		for_each_cpu_and(cpu, per_cpu(cpus_in_cluster, first_cpu),
-				 cpumask) {
-			if (!cpumask_test_cpu(cpu, andmask))
-				continue;
-			apicid |= per_cpu(x86_cpu_to_logical_apicid, cpu);
-		}
-	}
+	free_cpumask_var(target_cpus);
 
 	return apicid;
 }
@@ -265,10 +216,6 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
 					GFP_KERNEL)) {
 			err = -ENOMEM;
-		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
-					       GFP_KERNEL)) {
-			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
-			err = -ENOMEM;
 		}
 		break;
 	case CPU_UP_CANCELED:
@@ -281,7 +228,6 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
 		}
 		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
-		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
 		break;
 	}
 
@@ -297,9 +243,8 @@ static int x2apic_init_cpu_notifier(void)
 	int cpu = smp_processor_id();
 
 	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
-	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
 
-	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
+	BUG_ON(!per_cpu(cpus_in_cluster, cpu));
 
 	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
 	register_hotcpu_notifier(&x2apic_cpu_notifier);
-- 
1.7.6.5

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
