Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945930Ab2ERK0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161032Ab2ERK0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:26:48 -0400
Date: Fri, 18 May 2012 12:26:41 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently x2APIC in logical destination mode delivers interrupts to a
single CPU, no matter how many CPUs were specified in the destination
cpumask.

This fix enables delivery of interrupts to multiple CPUs by bit-ORing
Logical IDs of destination CPUs that have matching Cluster ID.

Because only one cluster could be specified in a message destination
address, the destination cpumask is tried for a cluster that contains
maximum number of CPUs matching this cpumask. The CPUs in this cluster
are selected to receive the interrupts while all other CPUs (in the
cpumask) are ignored.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/x2apic.h         |    9 --
 arch/x86/kernel/apic/x2apic_cluster.c |  140 +++++++++++++++++++++++++++++----
 arch/x86/kernel/apic/x2apic_phys.c    |    9 ++-
 3 files changed, 131 insertions(+), 27 deletions(-)

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
index 8f012b2..f8fa4c4 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -96,36 +96,142 @@ static void x2apic_send_IPI_all(int vector)
 	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
+static inline unsigned int
+__x2apic_cluster_to_apicid(int cpu_in_cluster, const struct cpumask *cpumask)
+{
+	unsigned int apicid = 0;
+	int cpu;
+
+	for_each_cpu_and(cpu, per_cpu(cpus_in_cluster, cpu_in_cluster), cpumask)
+		apicid |= per_cpu(x86_cpu_to_logical_apicid, cpu);
+
+	return apicid;
+}
+
+static int
+__x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
+{
+	int ret = 0;
+	int cpu, heaviest;
+	unsigned int weight, max_weight;
+	cpumask_var_t target_cpus, cluster_cpus;
+
+	if (unlikely(!alloc_cpumask_var(&target_cpus, GFP_ATOMIC))) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	if (unlikely(!alloc_cpumask_var(&cluster_cpus, GFP_ATOMIC))) {
+		ret = -ENOMEM;
+		goto out_free_target_cpus;
+	}
+
+	cpumask_and(target_cpus, cpumask, cpu_online_mask);
+	max_weight = 0;
+
+	for_each_cpu(cpu, target_cpus) {
+		cpumask_and(cluster_cpus, per_cpu(cpus_in_cluster, cpu), cpumask);
+
+		weight = cpumask_weight(cluster_cpus);
+		if (weight > max_weight) {
+			max_weight = weight;
+			heaviest = cpu;
+		}
+
+		cpumask_andnot(target_cpus, target_cpus, cluster_cpus);
+	}
+
+	if (!max_weight) {
+		ret = -EINVAL;
+		goto out_free_cluster_cpus;
+	}
+
+	*apicid = __x2apic_cluster_to_apicid(heaviest, cpumask);
+
+out_free_cluster_cpus:
+	free_cpumask_var(cluster_cpus);
+out_free_target_cpus:
+	free_cpumask_var(target_cpus);
+out:
+	return ret;
+}
+
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	/*
-	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
-	 * May as well be the first.
-	 */
-	int cpu = cpumask_first(cpumask);
+	int err;
+	int cpu;
+	unsigned int apicid;
 
-	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_logical_apicid, cpu);
-	else
-		return BAD_APICID;
+	err = __x2apic_cpu_mask_to_apicid(cpumask, &apicid);
+	WARN_ON(err);
+
+	if (!err)
+		return apicid;
+
+	if (err == -ENOMEM) {
+		for_each_cpu(cpu, cpumask) {
+			if (cpumask_test_cpu(cpu, cpu_online_mask))
+				break;
+		}
+		if (cpu < nr_cpu_ids)
+			return __x2apic_cluster_to_apicid(cpu, cpumask);
+	}
+
+	return BAD_APICID;
 }
 
 static unsigned int
 x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			      const struct cpumask *andmask)
 {
-	int cpu;
+	int err;
+	int cpu, first_cpu;
+	unsigned int apicid;
+	cpumask_var_t target_cpus;
+
+	if (likely(alloc_cpumask_var(&target_cpus, GFP_ATOMIC))) {
+		cpumask_and(target_cpus, cpumask, andmask);
+
+		err = __x2apic_cpu_mask_to_apicid(target_cpus, &apicid);
+
+		free_cpumask_var(target_cpus);
+
+		if (!err)
+			return apicid;
+	} else {
+		err = -ENOMEM;
+	}
+
+	WARN_ON(err);
+
+	if (err != -ENOMEM)
+		return 0;
+
+	apicid = 0;
+	first_cpu = nr_cpu_ids;
 
-	/*
-	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
-	 * May as well be the first.
-	 */
 	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
+		if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+			first_cpu = cpu;
 			break;
+		}
+	}
+
+	if (first_cpu < nr_cpu_ids) {
+		for_each_cpu_and(cpu, per_cpu(cpus_in_cluster, first_cpu),
+				 cpumask) {
+			if (!cpumask_test_cpu(cpu, andmask))
+				continue;
+			apicid |= per_cpu(x86_cpu_to_logical_apicid, cpu);
+		}
 	}
 
-	return per_cpu(x86_cpu_to_logical_apicid, cpu);
+	return apicid;
+}
+
+static void
+x2apic_cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_copy(retmask, cpu_possible_mask);
 }
 
 static void init_x2apic_ldr(void)
@@ -225,7 +331,7 @@ static struct apic apic_x2apic_cluster = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= x2apic_vector_allocation_domain,
+	.vector_allocation_domain	= x2apic_cluster_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 991e315..f0ee4a4 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -108,6 +108,13 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
+static void
+x2apic_phys_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
 static void init_x2apic_ldr(void)
 {
 }
@@ -137,7 +144,7 @@ static struct apic apic_x2apic_phys = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= x2apic_vector_allocation_domain,
+	.vector_allocation_domain	= x2apic_phys_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
-- 
1.7.6.5

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
