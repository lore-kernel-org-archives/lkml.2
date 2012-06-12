Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2FLMCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:02:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64082 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2FLMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:02:39 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, peterz@infradead.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 1/4] ARM: topology: Add arch_scale_freq_power function
Date: Tue, 12 Jun 2012 14:02:01 +0200
Message-Id: <1339502524-10265-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add infrastructure to be able to modify the cpu_power of each core

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/include/asm/topology.h |    2 ++
 arch/arm/kernel/topology.c      |   36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
index 58b8b84..78e4c85 100644
--- a/arch/arm/include/asm/topology.h
+++ b/arch/arm/include/asm/topology.h
@@ -27,11 +27,13 @@ void init_cpu_topology(void);
 void store_cpu_topology(unsigned int cpuid);
 const struct cpumask *cpu_coregroup_mask(int cpu);
 
+void set_power_scale(unsigned int cpu, unsigned long power);
 #else
 
 static inline void init_cpu_topology(void) { }
 static inline void store_cpu_topology(unsigned int cpuid) { }
 
+static inline void set_power_scale(unsigned int cpu, unsigned long power) { }
 #endif
 
 #include <asm-generic/topology.h>
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 8200dea..00301a7 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -22,6 +22,35 @@
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
+ * take this difference into account for load balance. A per cpu structure is
+ * preferred because each cpu is mainly using its own cpu_power even it's not
+ * always true because of nohz_idle_balance
+ */
+static DEFINE_PER_CPU(unsigned long, cpu_scale);
+
+unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return per_cpu(cpu_scale, cpu);
+}
+
+void set_power_scale(unsigned int cpu, unsigned long power)
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
 
@@ -41,6 +70,9 @@
 #define MPIDR_LEVEL2_MASK 0xFF
 #define MPIDR_LEVEL2_SHIFT 16
 
+/*
+ * cpu topology table
+ */
 struct cputopo_arm cpu_topology[NR_CPUS];
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
@@ -134,7 +166,7 @@ void init_cpu_topology(void)
 {
 	unsigned int cpu;
 
-	/* init core mask */
+	/* init core mask and power*/
 	for_each_possible_cpu(cpu) {
 		struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
 
@@ -143,6 +175,8 @@ void init_cpu_topology(void)
 		cpu_topo->socket_id = -1;
 		cpumask_clear(&cpu_topo->core_sibling);
 		cpumask_clear(&cpu_topo->thread_sibling);
+
+		per_cpu(cpu_scale, cpu) = SCHED_POWER_SCALE;
 	}
 	smp_wmb();
 }
-- 
1.7.9.5

