Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2AEV1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:27:23 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64612 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2AEV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:27:20 -0500
Subject: [PATCH 1/2] x86, amd: factor out MMCONFIG discovery
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@kernel.org#2.6.34+, Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>
Date: Thu, 05 Jan 2012 14:27:19 -0700
Message-ID: <20120105212719.3965.40406.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This factors out the AMD native MMCONFIG discovery so we can use it
outside amd_bus.c.

amd_bus.c reads AMD MSRs so it can remove the MMCONFIG area from the
PCI resources.  We may also need the MMCONFIG information to work
around BIOS defects in the ACPI MCFG table.

Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org       # 2.6.34+
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/include/asm/amd_nb.h |    2 ++
 arch/x86/kernel/amd_nb.c      |   31 ++++++++++++++++++++++++++++++
 arch/x86/pci/amd_bus.c        |   42 +++++++++++------------------------------
 3 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 8e41071..49ad773 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_AMD_NB_H
 #define _ASM_X86_AMD_NB_H
 
+#include <linux/ioport.h>
 #include <linux/pci.h>
 
 struct amd_nb_bus_dev_range {
@@ -13,6 +14,7 @@ extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 
 extern bool early_is_amd_nb(u32 value);
+extern struct resource *amd_get_mmconfig_range(struct resource *res);
 extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_numa_init(void);
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4c39baa..bae1efe 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -119,6 +119,37 @@ bool __init early_is_amd_nb(u32 device)
 	return false;
 }
 
+struct resource *amd_get_mmconfig_range(struct resource *res)
+{
+	u32 address;
+	u64 base, msr;
+	unsigned segn_busn_bits;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return NULL;
+
+	/* assume all cpus from fam10h have mmconfig */
+        if (boot_cpu_data.x86 < 0x10)
+		return NULL;
+
+	address = MSR_FAM10H_MMIO_CONF_BASE;
+	rdmsrl(address, msr);
+
+	/* mmconfig is not enabled */
+	if (!(msr & FAM10H_MMIO_CONF_ENABLE))
+		return NULL;
+
+	base = msr & (FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT);
+
+	segn_busn_bits = (msr >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
+			 FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+	res->flags = IORESOURCE_MEM;
+	res->start = base;
+	res->end = base + (1ULL<<(segn_busn_bits + 20)) - 1;
+	return res;
+}
+
 int amd_get_subcaches(int cpu)
 {
 	struct pci_dev *link = node_to_amd_nb(amd_get_nb_id(cpu))->link;
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 026e493..385a940 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -30,34 +30,6 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
 };
 
-static u64 __initdata fam10h_mmconf_start;
-static u64 __initdata fam10h_mmconf_end;
-static void __init get_pci_mmcfg_amd_fam10h_range(void)
-{
-	u32 address;
-	u64 base, msr;
-	unsigned segn_busn_bits;
-
-	/* assume all cpus from fam10h have mmconf */
-        if (boot_cpu_data.x86 < 0x10)
-		return;
-
-	address = MSR_FAM10H_MMIO_CONF_BASE;
-	rdmsrl(address, msr);
-
-	/* mmconfig is not enable */
-	if (!(msr & FAM10H_MMIO_CONF_ENABLE))
-		return;
-
-	base = msr & (FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT);
-
-	segn_busn_bits = (msr >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
-			 FAM10H_MMIO_CONF_BUSRANGE_MASK;
-
-	fam10h_mmconf_start = base;
-	fam10h_mmconf_end = base + (1ULL<<(segn_busn_bits + 20)) - 1;
-}
-
 #define RANGE_NUM 16
 
 /**
@@ -85,6 +57,9 @@ static int __init early_fill_mp_bus_info(void)
 	u64 val;
 	u32 address;
 	bool found;
+	struct resource fam10h_mmconf_res, *fam10h_mmconf;
+	u64 fam10h_mmconf_start;
+	u64 fam10h_mmconf_end;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -211,12 +186,17 @@ static int __init early_fill_mp_bus_info(void)
 		subtract_range(range, RANGE_NUM, 0, end);
 
 	/* get mmconfig */
-	get_pci_mmcfg_amd_fam10h_range();
+	fam10h_mmconf = amd_get_mmconfig_range(&fam10h_mmconf_res);
 	/* need to take out mmconf range */
-	if (fam10h_mmconf_end) {
-		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n", fam10h_mmconf_start, fam10h_mmconf_end);
+	if (fam10h_mmconf) {
+		printk(KERN_DEBUG "Fam 10h mmconf %pR\n", fam10h_mmconf);
+		fam10h_mmconf_start = fam10h_mmconf->start;
+		fam10h_mmconf_end = fam10h_mmconf->end;
 		subtract_range(range, RANGE_NUM, fam10h_mmconf_start,
 				 fam10h_mmconf_end + 1);
+	} else {
+		fam10h_mmconf_start = 0;
+		fam10h_mmconf_end = 0;
 	}
 
 	/* mmio resource */

