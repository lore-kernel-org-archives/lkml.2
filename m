Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1AKM2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:28:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:47409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab1AKM2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:28:15 -0500
Date: Tue, 11 Jan 2011 12:27:51 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        Andreas.Herrmann3@amd.com, joerg.roedel@amd.com, jeremy@goop.org,
        robert.richter@amd.com, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andreas.Herrmann3@amd.com, joerg.roedel@amd.com, jeremy@goop.org,
        robert.richter@amd.com, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D2B3FD7020000780002B67D@vpn.id2.novell.com>
References: <4D2B3FD7020000780002B67D@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Use PCI method for enabling AMD extended config space before MSR method
Message-ID: <tip-24d9b70b8c679264756a6980e668b96b3f964826@git.kernel.org>
Git-Commit-ID: 24d9b70b8c679264756a6980e668b96b3f964826
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 Jan 2011 12:27:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24d9b70b8c679264756a6980e668b96b3f964826
Gitweb:     http://git.kernel.org/tip/24d9b70b8c679264756a6980e668b96b3f964826
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Mon, 10 Jan 2011 16:20:23 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Jan 2011 12:43:41 +0100

x86: Use PCI method for enabling AMD extended config space before MSR method

While both methods should work equivalently well for the native
case, the Xen Dom0 case can't reliably work with the MSR one,
since there's no guarantee that the virtual CPUs it has
available fully cover all necessary physical ones.

As per the suggestion of Robert Richter the patch only adds the
PCI method, but leaves the MSR one as a fallback to cover new
systems the PCI IDs of which may not have got added to the code
base yet.

The only change in v2 is the breaking out of the new CPI
initialization method into a separate function, as requested by
Ingo.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Robert Richter <robert.richter@amd.com>
Cc: Andreas Herrmann3 <Andreas.Herrmann3@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
LKML-Reference: <4D2B3FD7020000780002B67D@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/amd_nb.h |    7 ++++++
 arch/x86/kernel/amd_nb.c      |    7 ++++++
 arch/x86/kernel/aperture_64.c |   44 ++++++++++++++--------------------------
 arch/x86/pci/amd_bus.c        |   33 ++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 980f225..64dc82e 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
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
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index affacb5..0a99f71 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,13 @@ struct pci_device_id amd_nb_misc_ids[] = {
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
 
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index dcd7c83..5955a78 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
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
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index fc1e8fe..e27dffb 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/range.h>
 
+#include <asm/amd_nb.h>
 #include <asm/pci_x86.h>
 
 #include <asm/pci-direct.h>
@@ -378,6 +379,34 @@ static struct notifier_block __cpuinitdata amd_cpu_notifier = {
 	.notifier_call	= amd_cpu_notify,
 };
 
+static void __init pci_enable_pci_io_ecs(void)
+{
+#ifdef CONFIG_AMD_NB
+	unsigned int i, n;
+
+	for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
+		u8 bus = amd_nb_bus_dev_ranges[i].bus;
+		u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
+		u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
+
+		for (; slot < limit; ++slot) {
+			u32 val = read_pci_config(bus, slot, 3, 0);
+
+			if (!early_is_amd_nb(val))
+				continue;
+
+			val = read_pci_config(bus, slot, 3, 0x8c);
+			if (!(val & (ENABLE_CF8_EXT_CFG >> 32))) {
+				val |= ENABLE_CF8_EXT_CFG >> 32;
+				write_pci_config(bus, slot, 3, 0x8c, val);
+			}
+			++n;
+		}
+	}
+	pr_info("Extended Config Space enabled on %u nodes\n", n);
+#endif
+}
+
 static int __init pci_io_ecs_init(void)
 {
 	int cpu;
@@ -386,6 +415,10 @@ static int __init pci_io_ecs_init(void)
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
+	/* Try the PCI method first. */
+	if (early_pci_allowed())
+		pci_enable_pci_io_ecs();
+
 	register_cpu_notifier(&amd_cpu_notifier);
 	for_each_online_cpu(cpu)
 		amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
