Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab2EUX77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:59:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:38254 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab2EUX74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:59:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155409326"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: agordeev@redhat.com
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 2/2] x2apic, cluster: use all the members of one cluster specified in the smp_affinity mask for the interrupt desintation
Date: Mon, 21 May 2012 16:58:02 -0700
Message-Id: <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the HW implements round-robin interrupt delivery, this enables multiple
cpu's (which are part of the user specified interrupt smp_affinity mask
and belong to the same x2apic cluster) to service the interrupt.

Also if the platform supports Power Aware Interrupt Routing, then this
enables the interrupt to be routed to an idle cpu or a busy cpu depending on
the perf/power bias tunable.

We are now grouping all the cpu's in a cluster to one vector domain. So that
will limit the total number of interrupt sources handled by Linux. Previously
we support "cpu-count * available-vectors-per-cpu" interrupt sources but this
will now reduce to "cpu-count/16 * available-vectors-per-cpu".

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/x2apic.h         |    9 -----
 arch/x86/kernel/apic/x2apic_cluster.c |   56 +++++++++++++++++++++++----------
 arch/x86/kernel/apic/x2apic_phys.c    |    9 +++++
 3 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
index 92e54ab..7a5a832 100644
--- a/arch/x86/include/asm/x2apic.h
+++ b/arch/x86/include/asm/x2apic.h
@@ -28,15 +28,6 @@ static int x2apic_apic_id_registered(void)
 	return 1;
 }
 
-/*
- * For now each logical cpu is in its own vector allocation domain.
- */
-static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
 static void
 __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
 {
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index ff35cff..90d999c 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -98,34 +98,47 @@ static void x2apic_send_IPI_all(int vector)
 
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	/*
-	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
-	 * May as well be the first.
-	 */
 	int cpu = cpumask_first(cpumask);
+	u32 dest = 0;
+	int i;
 
-	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_logical_apicid, cpu);
-	else
+	if (cpu > nr_cpu_ids)
 		return BAD_APICID;
+
+	for_each_cpu_and(i, cpumask, per_cpu(cpus_in_cluster, cpu))
+		dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+
+	return dest;
 }
 
 static unsigned int
 x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			      const struct cpumask *andmask)
 {
-	int cpu;
+	u32 dest = 0;
+	u16 cluster;
+	int i;
 
-	/*
-	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
-	 * May as well be the first.
-	 */
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
+	for_each_cpu_and(i, cpumask, andmask) {
+		if (!cpumask_test_cpu(i, cpu_online_mask))
+			continue;
+		dest = per_cpu(x86_cpu_to_logical_apicid, i);
+		cluster = x2apic_cluster(i);
+		break;
 	}
 
-	return per_cpu(x86_cpu_to_logical_apicid, cpu);
+	if (!dest)
+		return BAD_APICID;
+
+	for_each_cpu_and(i, cpumask, andmask) {
+		if (!cpumask_test_cpu(i, cpu_online_mask))
+			continue;
+		if (cluster != x2apic_cluster(i))
+			continue;
+		dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+	}
+
+	return dest;
 }
 
 static void init_x2apic_ldr(void)
@@ -208,6 +221,15 @@ static int x2apic_cluster_probe(void)
 		return 0;
 }
 
+/*
+ * Each x2apic cluster is an allocation domain.
+ */
+static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
+}
+
 static struct apic apic_x2apic_cluster = {
 
 	.name				= "cluster x2apic",
@@ -225,7 +247,7 @@ static struct apic apic_x2apic_cluster = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= x2apic_vector_allocation_domain,
+	.vector_allocation_domain	= cluster_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index c17e982..93b2570 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -120,6 +120,15 @@ static int x2apic_phys_probe(void)
 	return apic == &apic_x2apic_phys;
 }
 
+/*
+ * Each logical cpu is in its own vector allocation domain.
+ */
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
 static struct apic apic_x2apic_phys = {
 
 	.name				= "physical x2apic",
-- 
1.7.6.5

