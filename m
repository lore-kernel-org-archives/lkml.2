Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934321Ab1ESXsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:48:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:44811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934226Ab1ESXre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:47:34 -0400
X-ExtLoop1: 1
Message-Id: <20110519234637.421800999@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 May 2011 16:45:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        suresh.b.siddha@intel.com
Subject: [patch 3/6] x86, x2apic: track the x2apic cluster sibling map
References: <20110519234545.700125442@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=track_x2apic_cluster_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

In the case of x2apic cluster mode, we can group IPI register writes based on
the cluster group instead of individual per-cpu destination messages.

For this purpose, track the cpu's that belong to the same x2apic cluster.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c |   72 +++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
@@ -11,6 +11,7 @@
 #include <asm/ipi.h>
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -48,6 +49,11 @@ static void
 	native_x2apic_icr_write(cfg, apicid);
 }
 
+static inline u32 x2apic_cluster(int cpu)
+{
+	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
+}
+
 /*
  * for now, we send the IPI's one by one in the cpumask.
  * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
@@ -163,14 +169,76 @@ static void x2apic_send_IPI_self(int vec
 
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
+ /*
+  * At CPU state changes, update the x2apic cluster sibling info.
+  */
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
+static int x2apic_init_cpu_notifier(void)
+{
 	int cpu = smp_processor_id();
 
-	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
+	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+
+	BUG_ON(!per_cpu(cpus_in_cluster, cpu));
+
+	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
+	register_hotcpu_notifier(&x2apic_cpu_notifier);
+	return 1;
 }
 
 static int x2apic_cluster_probe(void)
 {
-	return x2apic_mode;
+	if (x2apic_mode)
+		return x2apic_init_cpu_notifier();
+	else
+		return 0;
 }
 
 struct apic apic_x2apic_cluster = {


