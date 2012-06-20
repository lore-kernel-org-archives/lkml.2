Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2FTPUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:20:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52763 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2FTPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:20:28 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, a.p.zijlstra@chello.nl, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 3/5] ARM: topology: Update cpu_power according to DT information
Date: Wed, 20 Jun 2012 17:19:20 +0200
Message-Id: <1340205562-7653-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
References: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu compatibility field and clock-frequency field of DT to
estimate the capacity of each core of the system and to update
the cpu_power field accordingly.
This patch enables to put more running tasks on big cores than
on LITTLE ones. But this patch doesn't ensure that long running
tasks will run on big cores and short ones on LITTLE cores.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c |  123 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index eb5fc81..f59193c 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -17,7 +17,9 @@
 #include <linux/percpu.h>
 #include <linux/node.h>
 #include <linux/nodemask.h>
+#include <linux/of.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <asm/cputype.h>
 #include <asm/topology.h>
@@ -49,6 +51,122 @@ static void set_power_scale(unsigned int cpu, unsigned long power)
 	per_cpu(cpu_scale, cpu) = power;
 }
 
+#ifdef CONFIG_OF
+struct cpu_efficiency {
+	const char *compatible;
+	unsigned long efficiency;
+};
+
+/*
+ * Table of relative efficiency of each processors
+ * The efficiency value must fit in 20bit. The final
+ * cpu_scale value must be in the range
+ * 0 < cpu_scale < 2*SCHED_POWER_SCALE.
+ * Processors that are not defined in the table,
+ * use the default SCHED_POWER_SCALE value for cpu_scale.
+ */
+struct cpu_efficiency table_efficiency[] = {
+	{"arm,cortex-a15", 3891},
+	{"arm,cortex-a7",  2048},
+	{NULL, },
+};
+
+struct cpu_capacity {
+	unsigned long hwid;
+	unsigned long capacity;
+};
+
+struct cpu_capacity *cpu_capacity;
+
+unsigned long middle_capacity = 1;
+
+static void __init parse_dt_topology(void)
+{
+	struct cpu_efficiency *cpu_eff;
+	struct device_node *cn = NULL;
+	unsigned long min_capacity = (unsigned long)(-1);
+	unsigned long max_capacity = 0;
+	unsigned long capacity = 0;
+	int alloc_size, cpu = 0;
+
+	alloc_size = nr_cpu_ids * sizeof(struct cpu_capacity);
+	cpu_capacity = (struct cpu_capacity *)kzalloc(alloc_size, GFP_NOWAIT);
+
+	while ((cn = of_find_node_by_type(cn, "cpu"))) {
+		const u32 *rate, *reg;
+		int len;
+
+		if (cpu >= num_possible_cpus())
+			break;
+
+		for (cpu_eff = table_efficiency; cpu_eff->compatible; cpu_eff++)
+			if (of_device_is_compatible(cn, cpu_eff->compatible))
+				break;
+
+		if (cpu_eff->compatible == NULL)
+			continue;
+
+		rate = of_get_property(cn, "clock-frequency", &len);
+		if (!rate || len != 4) {
+			pr_err("%s missing clock-frequency property\n",
+				cn->full_name);
+			continue;
+		}
+
+		reg = of_get_property(cn, "reg", &len);
+		if (!reg || len != 4) {
+			pr_err("%s missing reg property\n", cn->full_name);
+			continue;
+		}
+
+		capacity = ((be32_to_cpup(rate)) >> 20) * cpu_eff->efficiency;
+
+		/* Save min capacity of the system */
+		if (capacity < min_capacity)
+			min_capacity = capacity;
+
+		/* Save max capacity of the system */
+		if (capacity > max_capacity)
+			max_capacity = capacity;
+
+		cpu_capacity[cpu].capacity = capacity;
+		cpu_capacity[cpu++].hwid = be32_to_cpup(reg);
+	}
+
+	if (cpu < num_possible_cpus())
+		cpu_capacity[cpu].hwid = (unsigned long)(-1);
+
+	middle_capacity = (min_capacity + max_capacity) >> 11;
+}
+
+void update_cpu_power(unsigned int cpu, unsigned long hwid)
+{
+	unsigned int idx = 0;
+
+	/* look for the cpu's hwid in the cpu capacity table */
+	for (idx = 0; idx < num_possible_cpus(); idx++) {
+		if (cpu_capacity[idx].hwid == hwid)
+			break;
+
+		if (cpu_capacity[idx].hwid == -1)
+			return;
+	}
+
+	if (idx == num_possible_cpus())
+		return;
+
+	set_power_scale(cpu, cpu_capacity[idx].capacity / middle_capacity);
+
+	printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
+		cpu, arch_scale_freq_power(NULL, cpu));
+}
+
+#else
+static inline void parse_dt_topology(void) {}
+static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
+#endif
+
+
 /*
  * cpu topology management
  */
@@ -62,6 +180,7 @@ static void set_power_scale(unsigned int cpu, unsigned long power)
  * These masks reflect the current use of the affinity levels.
  * The affinity level can be up to 16 bits according to ARM ARM
  */
+#define MPIDR_HWID_BITMASK 0xFFFFFF
 
 #define MPIDR_LEVEL0_MASK 0x3
 #define MPIDR_LEVEL0_SHIFT 0
@@ -160,6 +279,8 @@ void store_cpu_topology(unsigned int cpuid)
 
 	update_siblings_masks(cpuid);
 
+	update_cpu_power(cpuid, mpidr & MPIDR_HWID_BITMASK);
+
 	printk(KERN_INFO "CPU%u: thread %d, cpu %d, socket %d, mpidr %x\n",
 		cpuid, cpu_topology[cpuid].thread_id,
 		cpu_topology[cpuid].core_id,
@@ -187,4 +308,6 @@ void init_cpu_topology(void)
 		set_power_scale(cpu, SCHED_POWER_SCALE);
 	}
 	smp_wmb();
+
+	parse_dt_topology();
 }
-- 
1.7.9.5

