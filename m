Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1LVBq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:46:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:33181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab1LVBqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:46:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99039559"
Message-Id: <20111222014632.540896503@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 17:45:16 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, flyboy@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/5] x86, acpi: skip acpi x2apic entries if the x2apic feature is not present
References: <20111222014514.410584964@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=nox2apic_acpi_parsing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

If the x2apic feature is not present (either the cpu is not capable of it
or the user has disabled the feature using boot-parameter etc), ignore the
x2apic MADT and SRAT entries provided by the ACPI tables.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4558f0d..1c54a9e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -219,6 +219,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -227,6 +229,8 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -235,8 +239,10 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	acpi_register_lapic(processor->local_apic_id,	/* APIC ID */
-			    processor->lapic_flags & ACPI_MADT_ENABLED);
+	if (!cpu_has_x2apic && (apic_id >= 0xff) && enabled)
+		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
+	else
+		acpi_register_lapic(apic_id, enabled);
 #else
 	printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 #endif
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 81dbfde..6dd2b09 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -69,6 +69,12 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
+	apic_id = pa->apic_id;
+	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
+		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
+			 pxm, apic_id);
+		return;
+	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -76,7 +82,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 
-	apic_id = pa->apic_id;
 	if (apic_id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;


