Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2FFPFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:05:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2FFPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:05:09 -0400
Date: Wed, 6 Jun 2012 08:04:50 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
References: <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic/cluster:
  Use all the members of one cluster specified in the smp_affinity mask for the interrupt destination
Git-Commit-ID: 0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:04:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0
Gitweb:     http://git.kernel.org/tip/0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 21 May 2012 16:58:02 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 09:51:22 +0200

x86/x2apic/cluster: Use all the members of one cluster specified in the smp_affinity mask for the interrupt destination

If the HW implements round-robin interrupt delivery, this
enables multiple cpu's (which are part of the user specified
interrupt smp_affinity mask and belong to the same x2apic
cluster) to service the interrupt.

Also if the platform supports Power Aware Interrupt Routing,
then this enables the interrupt to be routed to an idle cpu or a
busy cpu depending on the perf/power bias tunable.

We are now grouping all the cpu's in a cluster to one vector
domain. So that will limit the total number of interrupt sources
handled by Linux. Previously we support "cpu-count *
available-vectors-per-cpu" interrupt sources but this will now
reduce to "cpu-count/16 * available-vectors-per-cpu".

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org
Cc: gorcunov@openvz.org
Cc: agordeev@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
