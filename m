Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196Ab2FGNQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:16:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab2FGNQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:16:32 -0400
Date: Thu, 7 Jun 2012 15:16:25 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 8/8] x86/apic: Make cpu_mask_to_apicid() operations check
 cpu_online_mask
Message-ID: <20120607131624.GG4759@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
 <20120606082231.GD5991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606082231.GD5991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently cpu_mask_to_apicid() should not get a offline CPU with the
cpumask. Otherwise some apic drivers might try to access non-existent
per-cpu variables (i.e. x2apic). In that regard cpu_mask_to_apicid() and
cpu_mask_to_apicid_and() operations are inconsistent.

This fix makes the two operations do not rely on calling functions and
always return the apicid for only online CPUs. As result, the meaning
and implementations of cpu_mask_to_apicid() and cpu_mask_to_apicid_and()
operations become straight.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/apic.h           |    6 ++----
 arch/x86/kernel/apic/apic.c           |    2 +-
 arch/x86/kernel/apic/es7000_32.c      |    3 +--
 arch/x86/kernel/apic/summit_32.c      |    3 +--
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 +-
 6 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ae91f9c..1ed3eea 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -596,7 +596,7 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 static inline int
 __flat_cpu_mask_to_apicid(unsigned long cpu_mask, unsigned int *apicid)
 {
-	cpu_mask &= APIC_ALL_CPUS;
+	cpu_mask = cpu_mask & APIC_ALL_CPUS & cpumask_bits(cpu_online_mask)[0];
 	if (likely(cpu_mask)) {
 		*apicid = (unsigned int)cpu_mask;
 		return 0;
@@ -619,9 +619,7 @@ flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 {
 	unsigned long mask1 = cpumask_bits(cpumask)[0];
 	unsigned long mask2 = cpumask_bits(andmask)[0];
-	unsigned long mask3 = cpumask_bits(cpu_online_mask)[0];
-
-	return __flat_cpu_mask_to_apicid(mask1 & mask2 & mask3, apicid);
+	return __flat_cpu_mask_to_apicid(mask1 & mask2, apicid);
 }
 
 extern int
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b8d9260..7e9bbe7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2136,7 +2136,7 @@ static inline int __default_cpu_to_apicid(int cpu, unsigned int *apicid)
 int default_cpu_mask_to_apicid(const struct cpumask *cpumask,
 			       unsigned int *apicid)
 {
-	int cpu = cpumask_first(cpumask);
+	int cpu = cpumask_first_and(cpumask, cpu_online_mask);
 	return __default_cpu_to_apicid(cpu, apicid);
 }
 
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 515ebb0..b35cfb9 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -534,7 +534,7 @@ es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
-	for_each_cpu(cpu, cpumask) {
+	for_each_cpu_and(cpu, cpumask, cpu_online_mask) {
 		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
@@ -561,7 +561,6 @@ es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 		return 0;
 
 	cpumask_and(cpumask, inmask, andmask);
-	cpumask_and(cpumask, cpumask, cpu_online_mask);
 	es7000_cpu_mask_to_apicid(cpumask, apicid);
 
 	free_cpumask_var(cpumask);
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 5766d84..79d360f 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -272,7 +272,7 @@ summit_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
-	for_each_cpu(cpu, cpumask) {
+	for_each_cpu_and(cpu, cpumask, cpu_online_mask) {
 		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
@@ -298,7 +298,6 @@ summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 		return 0;
 
 	cpumask_and(cpumask, inmask, andmask);
-	cpumask_and(cpumask, cpumask, cpu_online_mask);
 	summit_cpu_mask_to_apicid(cpumask, apicid);
 
 	free_cpumask_var(cpumask);
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 5f86f79..23a46cf 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -99,7 +99,7 @@ static void x2apic_send_IPI_all(int vector)
 static int
 x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
 {
-	int cpu = cpumask_first(cpumask);
+	int cpu = cpumask_first_and(cpumask, cpu_online_mask);
 	int i;
 
 	if (cpu >= nr_cpu_ids)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2f3030f..307aa07 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -286,7 +286,7 @@ uv_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	int cpu = cpumask_first(cpumask);
+	int cpu = cpumask_first_and(cpumask, cpu_online_mask);
 	return __uv_cpu_to_apicid(cpu, apicid);
 }
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
