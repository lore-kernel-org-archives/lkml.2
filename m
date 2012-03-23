Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2CWTqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:46:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2CWTqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:46:11 -0400
Date: Fri, 23 Mar 2012 12:45:36 -0700
From: tip-bot for Steffen Persvold <sp@numascale.com>
Message-ID: <tip-b7157acf429e6aef690646ba964b9ebd25049ec2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, sp@numascale.com, steiner@sgi.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, sp@numascale.com, steiner@sgi.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        daniel@numascale-asia.com
In-Reply-To: <1331925935-13372-1-git-send-email-sp@numascale.com>
References: <1331925935-13372-1-git-send-email-sp@numascale.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/apic: Add separate apic_id_valid()
  functions for selected apic drivers
Git-Commit-ID: b7157acf429e6aef690646ba964b9ebd25049ec2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 12:45:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7157acf429e6aef690646ba964b9ebd25049ec2
Gitweb:     http://git.kernel.org/tip/b7157acf429e6aef690646ba964b9ebd25049ec2
Author:     Steffen Persvold <sp@numascale.com>
AuthorDate: Fri, 16 Mar 2012 20:25:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 23 Mar 2012 13:28:43 +0100

x86/apic: Add separate apic_id_valid() functions for selected apic drivers

As suggested by Suresh Siddha and Yinghai Lu:

For x2apic pre-enabled systems, apic driver is set already early
through early_acpi_boot_init()/early_acpi_process_madt()/
acpi_parse_madt()/default_acpi_madt_oem_check() path so that
apic_id_valid() checking will be sufficient during MADT and SRAT
parsing.

For non-x2apic pre-enabled systems, all apic ids should be less
than 255.

This allows us to substitute the checks in
arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic() and
arch/x86/mm/srat.c::acpi_numa_x2apic_affinity_init() with
apic->apic_id_valid().

In addition we can avoid feigning the x2apic cpu feature in the
NumaChip apic code.

The following apic drivers have separate apic_id_valid()
functions which will accept x2apic type IDs :

 x2apic_phys
 x2apic_cluster
 x2apic_uv_x
 apic_numachip

Signed-off-by: Steffen Persvold <sp@numascale.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>
Link: http://lkml.kernel.org/r/1331925935-13372-1-git-send-email-sp@numascale.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           |    2 +-
 arch/x86/include/asm/x2apic.h         |    5 +++++
 arch/x86/kernel/acpi/boot.c           |    2 +-
 arch/x86/kernel/apic/apic_numachip.c  |    3 +--
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    7 ++++++-
 arch/x86/mm/srat.c                    |    2 +-
 8 files changed, 17 insertions(+), 8 deletions(-)

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
index 1c1c4f4..efb5b4b 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -70,7 +70,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	pxm = pa->proximity_domain;
 	apic_id = pa->apic_id;
-	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
+	if (!apic->apic_id_valid(apic_id)) {
 		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
 			 pxm, apic_id);
 		return;
