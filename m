Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1D3RVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 13:21:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36943 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1D3RUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 13:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=GtWPXsb7c/HiuWRbLe+/Oi77QYBZUyz3E1tei2eyYJMdQlBQ+oFcH/e8MrlGoMUP+L
         t32GmqAvJzKCHzNJfiHjdLupXNSXp0/wvSep6VLMk5BR1Tof+F4/1PDBZWavPcP8giyn
         HldLkDUszVncKcY743pbjVPs/3JrCFd4WfeLQ=
Message-Id: <20110430172025.663350009@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 30 Apr 2011 21:15:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/2] x86, x2apic: minimize IPI register writes using cluster groups v4
References: <20110430171459.685415696@openvz.org>
Content-Disposition: inline; filename=x86-x2apic-optimise-cluster-mode-v4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of x2apic cluster mode we can group
IPI register writes based on the cluster group
instead of individual per-cpu destiantion messages.

This reduces the apic register writes and reduces
the amount of IPI messages (in the best case we can
reduce it by a factor of 16).

With this change, microbenchmark measuring the cost
of flush_tlb_others(), with the flush tlb IPI being
sent from a cpu in the socket-1 to all the logical
cpus in socket-2 (on a Westmere-EX system that has
20 logical cpus in a socket) is 3x times better now
(compared to the former 'send one-by-one' algorithm).

v3: Address Ingo concerns on code style, also a note
    added just to not forget that we need merge
    probe_64/32 into some common structure.

v4: Suresh discovered (and fixed) that cluster
    infomation must be updated at CPU_UP_PREPARE
    state otherwise if IPI happens too early we
    will be in touble having incomplete cluster
    sibling map.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h           |    2 
 arch/x86/kernel/apic/probe_64.c       |   13 ++
 arch/x86/kernel/apic/x2apic_cluster.c |  167 ++++++++++++++++++++++++----------
 3 files changed, 136 insertions(+), 46 deletions(-)

Index: tip-linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- tip-linux-2.6.orig/arch/x86/include/asm/apic.h
+++ tip-linux-2.6/arch/x86/include/asm/apic.h
@@ -178,6 +178,8 @@ extern int x2apic_phys;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
+extern void x2apic_init_cpu_notifier(void);
+
 static inline int x2apic_enabled(void)
 {
 	u64 msr;
Index: tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
+++ tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
@@ -55,6 +55,15 @@ static int apicid_phys_pkg_id(int initia
 void __init default_setup_apic_routing(void)
 {
 
+	/*
+	 * FIXME:
+	 *
+	 * Cleanup the apic routing selection by having an apic driver specific
+	 * selection routine. Then all we need to do here is iterate through
+	 * them to finalize the apic selection. That would get rid of the
+	 * ifdef mess and most of the code here.
+	 */
+
 	enable_IR_x2apic();
 
 #ifdef CONFIG_X86_X2APIC
@@ -71,7 +80,9 @@ void __init default_setup_apic_routing(v
 #endif
 
 	if (apic == &apic_flat && num_possible_cpus() > 8)
-			apic = &apic_physflat;
+		apic = &apic_physflat;
+	else if (apic == &apic_x2apic_cluster)
+		x2apic_init_cpu_notifier();
 
 	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 
Index: tip-linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ tip-linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
@@ -5,12 +5,15 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/dmar.h>
+#include <linux/cpu.h>
 
 #include <asm/smp.h>
 #include <asm/apic.h>
 #include <asm/ipi.h>
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
+static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -36,7 +39,7 @@ static void x2apic_vector_allocation_dom
 }
 
 static void
- __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
+__x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
 {
 	unsigned long cfg;
 
@@ -48,70 +51,80 @@ static void
 	native_x2apic_icr_write(cfg, apicid);
 }
 
-/*
- * for now, we send the IPI's one by one in the cpumask.
- * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
- * at once. We have 16 cpu's in a cluster. This will minimize IPI register
- * writes.
- */
-static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+static inline u32 x2apic_cluster(int cpu)
 {
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		__x2apic_send_IPI_dest(
-			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
 }
 
 static void
- x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int exclude_self)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
+	struct cpumask *cpus_in_cluster_ptr;
+	struct cpumask *ipi_mask_ptr;
+	unsigned int cpu, this_cpu;
 	unsigned long flags;
+	u32 dest;
 
 	x2apic_wrmsr_fence();
 
 	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
+	this_cpu = smp_processor_id();
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
+			if (!exclude_self || i != this_cpu)
+				dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+		}
+
+		if (!dest)
 			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
+
+		__x2apic_send_IPI_dest(dest, vector, apic->dest_logical);
+		/*
+		 * Cluster sibling cpus should be discared now so
+		 * we would not send IPI them second time.
+		 */
+		cpumask_andnot(ipi_mask_ptr, ipi_mask_ptr, cpus_in_cluster_ptr);
 	}
+
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_allbutself(int vector)
+static void
+x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
+	__x2apic_send_IPI_mask(mask, vector, 1);
+}
 
-	x2apic_wrmsr_fence();
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, 1);
+}
 
-	local_irq_save(flags);
-	for_each_online_cpu(query_cpu) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__x2apic_send_IPI_mask(mask, vector, 0);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_mask, vector);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, 0);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -151,6 +164,7 @@ x2apic_cpu_mask_to_apicid_and(const stru
 	return per_cpu(x86_cpu_to_logical_apicid, cpu);
 }
 
+
 static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -179,13 +193,76 @@ static void x2apic_send_IPI_self(int vec
 
 static void init_x2apic_ldr(void)
 {
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
+
+	per_cpu(x86_cpu_to_logical_apicid, this_cpu) = apic_read(APIC_LDR);
+
+	__cpu_set(this_cpu, per_cpu(cpus_in_cluster, this_cpu));
+	for_each_online_cpu(cpu) {
+		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+			continue;
+		__cpu_set(this_cpu, per_cpu(cpus_in_cluster, cpu));
+		__cpu_set(cpu, per_cpu(cpus_in_cluster, this_cpu));
+	}
+}
+
+/*
+ * At CPU state changes, update the x2apic cluster sibling info.
+ */
+static int __cpuinit
+update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	unsigned int this_cpu = (unsigned long)hcpu;
+	unsigned int cpu;
+	int err = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
+					GFP_KERNEL)) {
+			err = -ENOMEM;
+		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
+					       GFP_KERNEL)) {
+			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+			err = -ENOMEM;
+		}
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DEAD:
+		for_each_online_cpu(cpu) {
+			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+				continue;
+			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
+			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
+		}
+		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
+		break;
+	}
+
+	return notifier_from_errno(err);
+}
+
+static struct notifier_block __refdata x2apic_cpu_notifier = {
+	.notifier_call = update_clusterinfo,
+};
+
+void x2apic_init_cpu_notifier(void)
+{
 	int cpu = smp_processor_id();
 
-	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
+	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
+
+	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
+
+	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
+	register_hotcpu_notifier(&x2apic_cpu_notifier);
 }
 
 struct apic apic_x2apic_cluster = {
-
 	.name				= "cluster x2apic",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,

