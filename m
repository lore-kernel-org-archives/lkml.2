Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1BCVDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:03:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59631 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1BCVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=tTNTT1xqRYveiIoNhZOlOJyl+JAItle3H1WDnB6otB/c8l1BhF71NoJGlrVFSsTWCo
         VBj+IS+omOG74o8g+g2m9Zkf9yTdhE8AIRHp6B2dbwT8HMzNOK7uwr3wXBaSp+5o9r+T
         lUqIrfgA/yGXMjMgzrFyW2SnieKKgo/QgrDB4=
Message-ID: <4D4B1835.10606@gmail.com>
Date: Fri, 04 Feb 2011 00:03:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [RFC 1/2 -tip/master] x86, x2apic: minimize IPI register writes using
 cluster groups
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of x2apic cluster mode we can group IPI register writes based
on the cluster group instead of individual per-cpu destiantion messages.
This reduces the apic register writes and reduces the amount of IPI messages
(in the best case we can reduce it by a factor of 16).

With this change, microbenchmark measuring the cost of flush_tlb_others(),
with the flush tlb IPI being sent from a cpu in the socket-1 to all the logical
cpus in socket-2 (on a Westmere-EX system that has 20 logical cpus in a socket)
is 3x times better now (compared to the former 'send one-by-one' algorithm).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h           |    2
 arch/x86/kernel/apic/probe_64.c       |    4
 arch/x86/kernel/apic/x2apic_cluster.c |  169 +++++++++++++++++++++++++---------
 3 files changed, 131 insertions(+), 44 deletions(-)

Index: tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
+++ tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
@@ -71,7 +71,9 @@ void __init default_setup_apic_routing(v
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
@@ -48,24 +51,53 @@ static void
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
+	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
+}
+
+static void __x2apic_send_IPI_mask(const struct cpumask *mask, int vector,
+				   int exclude_self)
+{
+	unsigned long cpu;
 	unsigned long flags;
+	struct cpumask *cpus_in_cluster_ptr, *ipi_mask_ptr;
+	u32 dest, this_cpu;

 	x2apic_wrmsr_fence();

 	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		__x2apic_send_IPI_dest(
-			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, apic->dest_logical);
+	this_cpu = smp_processor_id();
+
+	/*
+	 * we are to modify mask, so we need an own copy
+	 * and be sure it's manipulated with irq off
+	 */
+	ipi_mask_ptr = __raw_get_cpu_var(ipi_mask);
+	cpumask_copy(ipi_mask_ptr, mask);
+
+	/*
+	 * the idea is to send one IPI per cluster
+	 */
+	for_each_cpu(cpu, ipi_mask_ptr) {
+		unsigned long i;
+		dest = 0;
+		cpus_in_cluster_ptr = per_cpu(cpus_in_cluster, cpu);
+
+		/* only cpus in cluster involved */
+		for_each_cpu_and(i, ipi_mask_ptr, cpus_in_cluster_ptr)
+			if (!exclude_self || i != this_cpu)
+				dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+
+		if (!dest)
+			continue;
+
+		__x2apic_send_IPI_dest(dest, vector, apic->dest_logical);
+		/*
+		 * cluster sibling cpus should be discared now so
+		 * we would not send IPI them second time
+		 */
+		cpumask_andnot(ipi_mask_ptr, ipi_mask_ptr, cpus_in_cluster_ptr);
 	}
 	local_irq_restore(flags);
 }
@@ -73,45 +105,22 @@ static void x2apic_send_IPI_mask(const s
 static void
  x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(mask, vector, 1);
 }

 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
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
@@ -151,6 +160,34 @@ x2apic_cpu_mask_to_apicid_and(const stru
 	return per_cpu(x86_cpu_to_logical_apicid, cpu);
 }

+#define x2apic_propagate_cpu_cluster_status_online(cpu)		\
+	x2apic_propagate_cpu_cluster_status(cpu, 1)
+
+#define x2apic_propagate_cpu_cluster_status_offline(cpu)	\
+	x2apic_propagate_cpu_cluster_status(cpu, 0)
+
+/* kind of 'fill cluster cpu siblings' map */
+static void x2apic_propagate_cpu_cluster_status(int this_cpu, int online)
+{
+	int cpu;
+
+	if (online) {
+		for_each_online_cpu(cpu) {
+			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+				continue;
+			__cpu_set(this_cpu, per_cpu(cpus_in_cluster, cpu));
+			__cpu_set(cpu, per_cpu(cpus_in_cluster, this_cpu));
+		}
+	} else {
+		for_each_online_cpu(cpu) {
+			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+				continue;
+			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
+			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
+		}
+	}
+}
+
 static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -184,8 +221,54 @@ static void init_x2apic_ldr(void)
 	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
 }

-struct apic apic_x2apic_cluster = {
+static int __cpuinit
+cluster_setup(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
+		if (!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu)) {
+			free_cpumask_var(per_cpu(cpus_in_cluster, cpu));
+			free_cpumask_var(per_cpu(ipi_mask, cpu));
+			err = -ENOMEM;
+		}
+		break;
+	case CPU_ONLINE:
+		x2apic_propagate_cpu_cluster_status_online(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DEAD:
+		x2apic_propagate_cpu_cluster_status_offline(cpu);
+		free_cpumask_var(per_cpu(cpus_in_cluster, cpu));
+		free_cpumask_var(per_cpu(ipi_mask, cpu));
+		break;
+	}
+
+	return notifier_from_errno(err);
+}
+
+static struct notifier_block __refdata x2apic_cpu_notifier =
+{
+	.notifier_call = cluster_setup,
+};
+
+void x2apic_init_cpu_notifier(void)
+{
+	int cpu = smp_processor_id();

+	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
+	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
+	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
+	register_hotcpu_notifier(&x2apic_cpu_notifier);
+}
+
+struct apic apic_x2apic_cluster = {
 	.name				= "cluster x2apic",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
Index: tip-linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- tip-linux-2.6.orig/arch/x86/include/asm/apic.h
+++ tip-linux-2.6/arch/x86/include/asm/apic.h
@@ -179,6 +179,8 @@ extern int x2apic_phys;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
+extern void x2apic_init_cpu_notifier(void);
+
 static inline int x2apic_enabled(void)
 {
 	u64 msr;
