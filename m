Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab2FELXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635Ab2FELXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:23:36 -0400
Date: Tue, 5 Jun 2012 13:23:29 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/8] x86: apic: Factor out default target_cpus() operation
Message-ID: <20120605112324.GA11449@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/apic.h           |    5 +++++
 arch/x86/include/asm/x2apic.h         |    9 ---------
 arch/x86/kernel/apic/apic_flat_64.c   |   14 ++------------
 arch/x86/kernel/apic/apic_numachip.c  |    7 +------
 arch/x86/kernel/apic/bigsmp_32.c      |   11 +----------
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    7 +------
 8 files changed, 12 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d854101..5bc64bf 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -520,6 +520,11 @@ static inline const struct cpumask *default_target_cpus(void)
 #endif
 }
 
+static inline const struct cpumask *online_target_cpus(void)
+{
+	return cpu_online_mask;
+}
+
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
 
diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
index 92e54ab..ff4cf37 100644
--- a/arch/x86/include/asm/x2apic.h
+++ b/arch/x86/include/asm/x2apic.h
@@ -9,15 +9,6 @@
 #include <asm/ipi.h>
 #include <linux/cpumask.h>
 
-/*
- * Need to use more than cpu 0, because we need more vectors
- * when MSI-X are used.
- */
-static const struct cpumask *x2apic_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static int x2apic_apic_id_valid(int apicid)
 {
 	return 1;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 8ef4e15..5ebaeba 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -36,11 +36,6 @@ static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 1;
 }
 
-static const struct cpumask *flat_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
@@ -186,7 +181,7 @@ static struct apic apic_flat =  {
 	.irq_delivery_mode		= dest_LowestPrio,
 	.irq_dest_mode			= 1, /* logical */
 
-	.target_cpus			= flat_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
@@ -261,11 +256,6 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
-static const struct cpumask *physflat_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
@@ -344,7 +334,7 @@ static struct apic apic_physflat =  {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= physflat_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 23e7542..55b5560 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -72,11 +72,6 @@ static int numachip_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
-static const struct cpumask *numachip_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void numachip_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
@@ -253,7 +248,7 @@ static struct apic apic_numachip __refconst = {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= numachip_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 0cdec70..6915f9d 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -26,15 +26,6 @@ static int bigsmp_apic_id_registered(void)
 	return 1;
 }
 
-static const struct cpumask *bigsmp_target_cpus(void)
-{
-#ifdef CONFIG_SMP
-	return cpu_online_mask;
-#else
-	return cpumask_of(0);
-#endif
-}
-
 static unsigned long bigsmp_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
@@ -205,7 +196,7 @@ static struct apic apic_bigsmp = {
 	/* phys delivery to target CPU: */
 	.irq_dest_mode			= 0,
 
-	.target_cpus			= bigsmp_target_cpus,
+	.target_cpus			= default_target_cpus,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= bigsmp_check_apicid_used,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 8f012b2..9edc1a0 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -219,7 +219,7 @@ static struct apic apic_x2apic_cluster = {
 	.irq_delivery_mode		= dest_LowestPrio,
 	.irq_dest_mode			= 1, /* logical */
 
-	.target_cpus			= x2apic_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 991e315..ddf5fa8 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -131,7 +131,7 @@ static struct apic apic_x2apic_phys = {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= x2apic_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 87bfa69..a77b75c 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -185,11 +185,6 @@ EXPORT_SYMBOL_GPL(uv_possible_blades);
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
-static const struct cpumask *uv_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
@@ -362,7 +357,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= uv_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
