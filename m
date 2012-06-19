Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2FSIaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:30:14 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32912 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2FSIaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:30:09 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, a.p.zijlstra@chello.nl, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH v2 2/5] ARM: topology: factorize the update of sibling masks
Date: Tue, 19 Jun 2012 10:28:53 +0200
Message-Id: <1340094536-20873-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340094536-20873-1-git-send-email-vincent.guittot@linaro.org>
References: <1340094536-20873-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This factorization has also been proposed in another patchset that has not been
merged yet:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/080873.html
So, this patch could be dropped depending of the state of the other one.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c |   47 ++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 37e2e57..92c2fb3 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -82,6 +82,31 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	return &cpu_topology[cpu].core_sibling;
 }
 
+void update_siblings_masks(unsigned int cpuid)
+{
+	struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
+	int cpu;
+	/* update core and thread sibling masks */
+	for_each_possible_cpu(cpu) {
+		cpu_topo = &cpu_topology[cpu];
+
+		if (cpuid_topo->socket_id == cpu_topo->socket_id) {
+			cpumask_set_cpu(cpuid, &cpu_topo->core_sibling);
+			if (cpu != cpuid)
+				cpumask_set_cpu(cpu, &cpuid_topo->core_sibling);
+
+			if (cpuid_topo->core_id == cpu_topo->core_id) {
+				cpumask_set_cpu(cpuid,
+					&cpu_topo->thread_sibling);
+				if (cpu != cpuid)
+					cpumask_set_cpu(cpu,
+						&cpuid_topo->thread_sibling);
+			}
+		}
+	}
+	smp_wmb();
+}
+
 /*
  * store_cpu_topology is called at boot when only one cpu is running
  * and with the mutex cpu_hotplug.lock locked, when several cpus have booted,
@@ -91,7 +116,6 @@ void store_cpu_topology(unsigned int cpuid)
 {
 	struct cputopo_arm *cpuid_topo = &cpu_topology[cpuid];
 	unsigned int mpidr;
-	unsigned int cpu;
 
 	/* If the cpu topology has been already set, just return */
 	if (cpuid_topo->core_id != -1)
@@ -133,26 +157,7 @@ void store_cpu_topology(unsigned int cpuid)
 		cpuid_topo->socket_id = -1;
 	}
 
-	/* update core and thread sibling masks */
-	for_each_possible_cpu(cpu) {
-		struct cputopo_arm *cpu_topo = &cpu_topology[cpu];
-
-		if (cpuid_topo->socket_id == cpu_topo->socket_id) {
-			cpumask_set_cpu(cpuid, &cpu_topo->core_sibling);
-			if (cpu != cpuid)
-				cpumask_set_cpu(cpu,
-					&cpuid_topo->core_sibling);
-
-			if (cpuid_topo->core_id == cpu_topo->core_id) {
-				cpumask_set_cpu(cpuid,
-					&cpu_topo->thread_sibling);
-				if (cpu != cpuid)
-					cpumask_set_cpu(cpu,
-						&cpuid_topo->thread_sibling);
-			}
-		}
-	}
-	smp_wmb();
+	update_siblings_masks(cpuid);
 
 	printk(KERN_INFO "CPU%u: thread %d, cpu %d, socket %d, mpidr %x\n",
 		cpuid, cpu_topology[cpuid].thread_id,
-- 
1.7.9.5

