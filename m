Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab2FHOxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:53:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab2FHOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:53:00 -0400
Date: Fri, 8 Jun 2012 07:52:49 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-4988a40c3981212fa8c64da68722affc1cb6697a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120607131624.GG4759@dhcp-26-207.brq.redhat.com>
References: <20120607131624.GG4759@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Make cpu_mask_to_apicid()
  operations check cpu_online_mask
Git-Commit-ID: 4988a40c3981212fa8c64da68722affc1cb6697a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:52:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4988a40c3981212fa8c64da68722affc1cb6697a
Gitweb:     http://git.kernel.org/tip/4988a40c3981212fa8c64da68722affc1cb6697a
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 7 Jun 2012 15:16:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 11:44:30 +0200

x86/apic: Make cpu_mask_to_apicid() operations check cpu_online_mask

Currently cpu_mask_to_apicid() should not get a offline CPU with
the cpumask. Otherwise some apic drivers might try to access
non-existent per-cpu variables (i.e. x2apic). In that regard
cpu_mask_to_apicid() and cpu_mask_to_apicid_and() operations are
inconsistent.

This fix makes the two operations do not rely on calling
functions and always return the apicid for only online CPUs. As
result, the meaning and implementations of cpu_mask_to_apicid()
and cpu_mask_to_apicid_and() operations become straight.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120607131624.GG4759@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
