Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2FTPUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:20:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47978 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2FTPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:20:20 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, a.p.zijlstra@chello.nl, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH v3 2/5] ARM: topology: factorize the update of sibling masks
Date: Wed, 20 Jun 2012 17:19:19 +0200
Message-Id: <1340205562-7653-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
References: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
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
 arch/arm/kernel/topology.c |   48 +++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 51f23b3..eb5fc81 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -82,6 +82,32 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	return &cpu_topology[cpu].core_sibling;
 }
 
+void update_siblings_masks(unsigned int cpuid)
+{
+	struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
+	int cpu;
+
+	/* update core and thread sibling masks */
+	for_each_possible_cpu(cpu) {
+		cpu_topo = &cpu_topology[cpu];
+
+		if (cpuid_topo->socket_id != cpu_topo->socket_id)
+			continue;
+
+		cpumask_set_cpu(cpuid, &cpu_topo->core_sibling);
+		if (cpu != cpuid)
+			cpumask_set_cpu(cpu, &cpuid_topo->core_sibling);
+
+		if (cpuid_topo->core_id != cpu_topo->core_id)
+			continue;
+
+		cpumask_set_cpu(cpuid, &cpu_topo->thread_sibling);
+		if (cpu != cpuid)
+			cpumask_set_cpu(cpu, &cpuid_topo->thread_sibling);
+	}
+	smp_wmb();
+}
+
 /*
  * store_cpu_topology is called at boot when only one cpu is running
  * and with the mutex cpu_hotplug.lock locked, when several cpus have booted,
@@ -91,7 +117,6 @@ void store_cpu_topology(unsigned int cpuid)
 {
 	struct cputopo_arm *cpuid_topo = &cpu_topology[cpuid];
 	unsigned int mpidr;
-	unsigned int cpu;
 
 	/* If the cpu topology has been already set, just return */
 	if (cpuid_topo->core_id != -1)
@@ -133,26 +158,7 @@ void store_cpu_topology(unsigned int cpuid)
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

