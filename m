Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1AGQhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:37:32 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:57477 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1AGQhb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 7 Jan 2011 11:37:31 -0500
Message-Id: <4D274F58020000780002B11D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 07 Jan 2011 16:37:28 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andreas Herrmann3" <Andreas.Herrmann3@amd.com>,
        "Joerg Roedel" <joerg.roedel@amd.com>,
        "Robert Richter" <robert.richter@amd.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH, tip] x86: use PCI method for enabling AMD extended
	 config space before MSR method
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While both methods should work equivalently well for the native case,
the Xen Dom0 case can't reliably work with the MSR one, since there's
no guarantee that the virtual CPUs it has available fully cover all
necessary physical ones.

As per the suggestion of Robert Richter the patch only adds the PCI
method, but leaves the MSR one as a fallback to cover new systems the
PCI IDs of which may not have got added to the code base yet.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Robert Richter <robert.richter@amd.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

---
 arch/x86/include/asm/amd_nb.h |    7 ++++++
 arch/x86/kernel/amd_nb.c      |    7 ++++++
 arch/x86/kernel/aperture_64.c |   44 +++++++++++++++---------------------------
 arch/x86/pci/amd_bus.c        |   30 ++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 28 deletions(-)

--- tip/arch/x86/include/asm/amd_nb.h
+++ tip-x86-amd-ecs/arch/x86/include/asm/amd_nb.h
@@ -3,7 +3,14 @@
 
 #include <linux/pci.h>
 
+struct amd_nb_bus_dev_range {
+	u8 bus;
+	u8 dev_base;
+	u8 dev_limit;
+};
+
 extern struct pci_device_id amd_nb_misc_ids[];
+extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
 extern int early_is_amd_nb(u32 value);
--- tip/arch/x86/kernel/amd_nb.c
+++ tip-x86-amd-ecs/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,13 @@ struct pci_device_id amd_nb_misc_ids[
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
+const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[] __initconst = {
+	{ 0x00, 0x18, 0x20 },
+	{ 0xff, 0x00, 0x20 },
+	{ 0xfe, 0x00, 0x20 },
+	{ }
+};
+
 struct amd_northbridge_info amd_northbridges;
 EXPORT_SYMBOL(amd_northbridges);
 
--- tip/arch/x86/kernel/aperture_64.c
+++ tip-x86-amd-ecs/arch/x86/kernel/aperture_64.c
@@ -39,18 +39,6 @@ int fallback_aper_force __initdata;
 
 int fix_aperture __initdata = 1;
 
-struct bus_dev_range {
-	int bus;
-	int dev_base;
-	int dev_limit;
-};
-
-static struct bus_dev_range bus_dev_ranges[] __initdata = {
-	{ 0x00, 0x18, 0x20},
-	{ 0xff, 0x00, 0x20},
-	{ 0xfe, 0x00, 0x20}
-};
-
 static struct resource gart_resource = {
 	.name	= "GART",
 	.flags	= IORESOURCE_MEM,
@@ -294,13 +282,13 @@ void __init early_gart_iommu_check(void)
 	search_agp_bridge(&agp_aper_order, &valid_agp);
 
 	fix = 0;
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus;
 		int dev_base, dev_limit;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
@@ -349,13 +337,13 @@ void __init early_gart_iommu_check(void)
 		return;
 
 	/* disable them all at first */
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; i < amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus;
 		int dev_base, dev_limit;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
@@ -390,14 +378,14 @@ int __init gart_iommu_hole_init(void)
 
 	fix = 0;
 	node = 0;
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; i < amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus;
 		int dev_base, dev_limit;
 		u32 ctl;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
@@ -505,7 +493,7 @@ out:
 	}
 
 	/* Fix up the north bridges */
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; i < amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus, dev_base, dev_limit;
 
 		/*
@@ -514,9 +502,9 @@ out:
 		 */
 		u32 ctl = DISTLBWALKPRB | aper_order << 1;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
--- tip/arch/x86/pci/amd_bus.c
+++ tip-x86-amd-ecs/arch/x86/pci/amd_bus.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/range.h>
 
+#include <asm/amd_nb.h>
 #include <asm/pci_x86.h>
 
 #include <asm/pci-direct.h>
@@ -386,6 +387,35 @@ static int __init pci_io_ecs_init(void)
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
+#ifdef CONFIG_AMD_NB
+	/* Try the PCI method first. */
+	if (early_pci_allowed()) {
+		unsigned int i, n;
+
+		for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
+			u8 bus = amd_nb_bus_dev_ranges[i].bus;
+			u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
+			u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
+
+			for (; slot < limit; ++slot) {
+				u32 val = read_pci_config(bus, slot, 3, 0);
+
+				if (!early_is_amd_nb(val))
+					continue;
+
+				val = read_pci_config(bus, slot, 3, 0x8c);
+				if (!(val & (ENABLE_CF8_EXT_CFG >> 32))) {
+					val |= ENABLE_CF8_EXT_CFG >> 32;
+					write_pci_config(bus, slot, 3, 0x8c,
+							 val);
+				}
+				++n;
+			}
+		}
+		pr_info("Extended Config Space enabled on %u nodes\n", n);
+	}
+#endif
+
 	register_cpu_notifier(&amd_cpu_notifier);
 	for_each_online_cpu(cpu)
 		amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,


