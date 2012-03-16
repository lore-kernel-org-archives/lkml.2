Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032474Ab2CPALI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:11:08 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:47260 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032050Ab2CPAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:08:22 -0400
From: Steffen Persvold <sp@numascale.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH] Added separate apic_id_valid() functions for selected apic drivers
Date: Fri, 16 Mar 2012 01:07:41 +0100
Message-Id: <1331856461-5804-1-git-send-email-sp@numascale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
References: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to substitute the check in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic and avoid feigning the x2apic cpu feature in the NumaChip apic code.

The following apic drivers have separate apic_id_valid() functions which will accept x2apic type IDs :

x2apic_phys
x2apic_cluster
x2apic_uv_x
apic_numachip

Signed-off-by: Steffen Persvold <sp@numascale.com>
---
 arch/x86/include/asm/apic.h           |    2 +-
 arch/x86/include/asm/x2apic.h         |    5 +++++
 arch/x86/kernel/acpi/boot.c           |    2 +-
 arch/x86/kernel/apic/apic_numachip.c  |    3 +--
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    7 ++++++-
 arch/x86/mm/srat.c                    |    7 +------
 8 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a9371c9..d3eaac4 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -535,7 +535,7 @@ static inline unsigned int read_apic_id(void)
 
 static inline int default_apic_id_valid(int apicid)
 {
-	return x2apic_mode || (apicid < 255);
+	return (apicid < 255);
 }
 
 extern void default_setup_apic_routing(void);
diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
index 6bf5b8e..92e54ab 100644
--- a/arch/x86/include/asm/x2apic.h
+++ b/arch/x86/include/asm/x2apic.h
@@ -18,6 +18,11 @@ static const struct cpumask *x2apic_target_cpus(void)
 	return cpu_online_mask;
 }
 
+static int x2apic_apic_id_valid(int apicid)
+{
+	return 1;
+}
+
 static int x2apic_apic_id_registered(void)
 {
 	return 1;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 406ed77..0f42c2f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -239,7 +239,7 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	if (!cpu_has_x2apic && (apic_id >= 0xff) && enabled)
+	if (!apic->apic_id_valid(apic_id) && enabled)
 		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 	else
 		acpi_register_lapic(apic_id, enabled);
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index d9ea5f3..899803e 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -229,11 +229,10 @@ static int __init numachip_system_init(void)
 }
 early_initcall(numachip_system_init);
 
-static int __cpuinit numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strncmp(oem_id, "NUMASC", 6)) {
 		numachip_system = 1;
-		setup_force_cpu_cap(X86_FEATURE_X2APIC);
 		return 1;
 	}
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 9193713..48f3103 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -213,7 +213,7 @@ static struct apic apic_x2apic_cluster = {
 	.name				= "cluster x2apic",
 	.probe				= x2apic_cluster_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
-	.apic_id_valid			= default_apic_id_valid,
+	.apic_id_valid			= x2apic_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index bcd1db6..8a778db 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -119,7 +119,7 @@ static struct apic apic_x2apic_phys = {
 	.name				= "physical x2apic",
 	.probe				= x2apic_phys_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
-	.apic_id_valid			= default_apic_id_valid,
+	.apic_id_valid			= x2apic_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index fc47714..87bfa69 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -266,6 +266,11 @@ static void uv_send_IPI_all(int vector)
 	uv_send_IPI_mask(cpu_online_mask, vector);
 }
 
+static int uv_apic_id_valid(int apicid)
+{
+	return 1;
+}
+
 static int uv_apic_id_registered(void)
 {
 	return 1;
@@ -351,7 +356,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.name				= "UV large system",
 	.probe				= uv_probe,
 	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
-	.apic_id_valid			= default_apic_id_valid,
+	.apic_id_valid			= uv_apic_id_valid,
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 1c1c4f4..7efd0c6 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -69,12 +69,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
-	apic_id = pa->apic_id;
-	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
-		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
-			 pxm, apic_id);
-		return;
-	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -82,6 +76,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 
+	apic_id = pa->apic_id;
 	if (apic_id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
-- 
1.7.4.1

