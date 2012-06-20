Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2FTPUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:20:18 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44756 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2FTPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:20:13 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, a.p.zijlstra@chello.nl, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 1/5] ARM: topology: Add arch_scale_freq_power function
Date: Wed, 20 Jun 2012 17:19:18 +0200
Message-Id: <1340205562-7653-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
References: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add infrastructure to be able to modify the cpu_power of each core

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 8200dea..51f23b3 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -22,6 +22,37 @@
 #include <asm/cputype.h>
 #include <asm/topology.h>
 
+/*
+ * cpu power scale management
+ */
+
+/*
+ * cpu power table
+ * This per cpu data structure describes the relative capacity of each core.
+ * On a heteregenous system, cores don't have the same computation capacity
+ * and we reflect that difference in the cpu_power field so the scheduler can
+ * take this difference into account during load balance. A per cpu structure
+ * is preferred because each CPU updates its own cpu_power field during the
+ * load balance except for idle cores. One idle core is selected to run the
+ * rebalance_domains for all idle cores and the cpu_power can be updated
+ * during this sequence.
+ */
+static DEFINE_PER_CPU(unsigned long, cpu_scale);
+
+unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return per_cpu(cpu_scale, cpu);
+}
+
+static void set_power_scale(unsigned int cpu, unsigned long power)
+{
+	per_cpu(cpu_scale, cpu) = power;
+}
+
+/*
+ * cpu topology management
+ */
+
 #define MPIDR_SMP_BITMASK (0x3 << 30)
 #define MPIDR_SMP_VALUE (0x2 << 30)
 
@@ -41,6 +72,9 @@
 #define MPIDR_LEVEL2_MASK 0xFF
 #define MPIDR_LEVEL2_SHIFT 16
 
+/*
+ * cpu topology table
+ */
 struct cputopo_arm cpu_topology[NR_CPUS];
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
@@ -134,7 +168,7 @@ void init_cpu_topology(void)
 {
 	unsigned int cpu;
 
-	/* init core mask */
+	/* init core mask and power*/
 	for_each_possible_cpu(cpu) {
 		struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
 
@@ -143,6 +177,8 @@ void init_cpu_topology(void)
 		cpu_topo->socket_id = -1;
 		cpumask_clear(&cpu_topo->core_sibling);
 		cpumask_clear(&cpu_topo->thread_sibling);
+
+		set_power_scale(cpu, SCHED_POWER_SCALE);
 	}
 	smp_wmb();
 }
-- 
1.7.9.5

