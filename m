Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab2CNHSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:18:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40919 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2CNHSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:18:46 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH] Move APIC ID validity check into platform APIC code
Date: Wed, 14 Mar 2012 15:17:34 +0800
Message-Id: <1331709454-27966-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331680589.18900.76.camel@sbsiddha-desk.sc.intel.com>
References: <1331680589.18900.76.camel@sbsiddha-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move APIC ID validity check into platform APIC code, so it can be
overridden when needed. For NumaChip systems, always trust MADT,
as it's constructed with high APIC IDs.

Behaviour verifies on standard x86 systems and on NumaChip systems
with this, and compile-tested with allyesconfig.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Reviewed-by: Steffen Persvold <sp@numascale.com>

---
 arch/x86/include/asm/apic.h           |    6 ++++++
 arch/x86/kernel/apic/apic_flat_64.c   |    2 ++
 arch/x86/kernel/apic/apic_noop.c      |    1 +
 arch/x86/kernel/apic/apic_numachip.c  |   10 +++++++++-
 arch/x86/kernel/apic/bigsmp_32.c      |    1 +
 arch/x86/kernel/apic/es7000_32.c      |    2 ++
 arch/x86/kernel/apic/numaq_32.c       |    1 +
 arch/x86/kernel/apic/probe_32.c       |    1 +
 arch/x86/kernel/apic/summit_32.c      |    1 +
 arch/x86/kernel/apic/x2apic_cluster.c |    1 +
 arch/x86/kernel/apic/x2apic_phys.c    |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c    |    1 +
 arch/x86/kernel/smpboot.c             |    2 +-
 13 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3ab9bdd..a9371c9 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -288,6 +288,7 @@ struct apic {
 
 	int (*probe)(void);
 	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
+	int (*apic_id_valid)(int apicid);
 	int (*apic_id_registered)(void);
 
 	u32 irq_delivery_mode;
@@ -532,6 +533,11 @@ static inline unsigned int read_apic_id(void)
 	return apic->get_apic_id(reg);
 }
 
+static inline int default_apic_id_valid(int apicid)
+{
+	return x2apic_mode || (apicid < 255);
+}
+
 extern void default_setup_apic_routing(void);
 
 extern struct apic apic_noop;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 8c3cdde..359b689 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -180,6 +180,7 @@ static struct apic apic_flat =  {
 	.name				= "flat",
 	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
@@ -337,6 +338,7 @@ static struct apic apic_physflat =  {
 	.name				= "physical flat",
 	.probe				= physflat_probe,
 	.acpi_madt_oem_check		= physflat_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 775b82b..634ae6c 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -124,6 +124,7 @@ struct apic apic_noop = {
 	.probe				= noop_probe,
 	.acpi_madt_oem_check		= NULL,
 
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= noop_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 09d3d8c..d9ea5f3 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -56,6 +56,12 @@ static unsigned int read_xapic_id(void)
 	return get_apic_id(apic_read(APIC_ID));
 }
 
+static int numachip_apic_id_valid(int apicid)
+{
+	/* Trust what bootloader passes in MADT */
+	return 1;
+}
+
 static int numachip_apic_id_registered(void)
 {
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
@@ -223,10 +229,11 @@ static int __init numachip_system_init(void)
 }
 early_initcall(numachip_system_init);
 
-static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __cpuinit numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strncmp(oem_id, "NUMASC", 6)) {
 		numachip_system = 1;
+		setup_force_cpu_cap(X86_FEATURE_X2APIC);
 		return 1;
 	}
 
@@ -238,6 +245,7 @@ static struct apic apic_numachip __refconst = {
 	.name				= "NumaConnect system",
 	.probe				= numachip_probe,
 	.acpi_madt_oem_check		= numachip_acpi_madt_oem_check,
+	.apic_id_valid			= numachip_apic_id_valid,
 	.apic_id_registered		= numachip_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 521bead..0cdec70 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -198,6 +198,7 @@ static struct apic apic_bigsmp = {
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,
 	.acpi_madt_oem_check		= NULL,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= bigsmp_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 5d513bc..e42d1d3b9 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -625,6 +625,7 @@ static struct apic __refdata apic_es7000_cluster = {
 	.name				= "es7000",
 	.probe				= probe_es7000,
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check_cluster,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= es7000_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
@@ -690,6 +691,7 @@ static struct apic __refdata apic_es7000 = {
 	.name				= "es7000",
 	.probe				= probe_es7000,
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= es7000_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index c4a61ca..00d2422 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -478,6 +478,7 @@ static struct apic __refdata apic_numaq = {
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
 	.acpi_madt_oem_check		= NULL,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= numaq_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 0787bb3..ff2c1b9 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -92,6 +92,7 @@ static struct apic apic_default = {
 	.name				= "default",
 	.probe				= probe_default,
 	.acpi_madt_oem_check		= NULL,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= default_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 1911442..fea000b 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -496,6 +496,7 @@ static struct apic apic_summit = {
 	.name				= "summit",
 	.probe				= probe_summit,
 	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= summit_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 5007958..9193713 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -213,6 +213,7 @@ static struct apic apic_x2apic_cluster = {
 	.name				= "cluster x2apic",
 	.probe				= x2apic_cluster_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f5373df..bcd1db6 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -119,6 +119,7 @@ static struct apic apic_x2apic_phys = {
 	.name				= "physical x2apic",
 	.probe				= x2apic_phys_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 79b05b8..fc47714 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -351,6 +351,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.name				= "UV large system",
 	.probe				= uv_probe,
 	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..d279e6e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -847,7 +847,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
 	    !physid_isset(apicid, phys_cpu_present_map) ||
-	    (!x2apic_mode && apicid >= 255)) {
+	    !apic->apic_id_valid(apicid)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
 		return -EINVAL;
 	}
-- 
1.7.5.4

