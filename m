Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab2JAXIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:08:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35786 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab2JAXH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:07:57 -0400
Message-Id: <20121001225159.055640879@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Borislav Petkov <borislav.petkov@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        stable@kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Jiri Slaby <jslaby@suse.cz>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 034/180] x86/PCI: amd: factor out MMCONFIG discovery
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 24d25dbfa63c376323096660bfa9ad45a08870ce upstream.

This factors out the AMD native MMCONFIG discovery so we can use it
outside amd_bus.c.

amd_bus.c reads AMD MSRs so it can remove the MMCONFIG area from the
PCI resources.  We may also need the MMCONFIG information to work
around BIOS defects in the ACPI MCFG table.

Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
[WT: this patch was initially not planned for 2.6.32 but is required by commit
 2215d910 merged into 2.6.32.55 and which relies on amd_get_mmconfig_range() ]
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/k8.h |    2 ++
 arch/x86/kernel/k8.c      |   31 +++++++++++++++++++++++++++++++
 arch/x86/pci/amd_bus.c    |   42 +++++++++++-------------------------------
 3 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index f0746f4..41845d2 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -1,11 +1,13 @@
 #ifndef _ASM_X86_K8_H
 #define _ASM_X86_K8_H
 
+#include <linux/ioport.h>
 #include <linux/pci.h>
 
 extern struct pci_device_id k8_nb_ids[];
 
 extern int early_is_k8_nb(u32 value);
+extern struct resource *amd_get_mmconfig_range(struct resource *res);
 extern struct pci_dev **k8_northbridges;
 extern int num_k8_northbridges;
 extern int cache_k8_northbridges(void);
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 9b89546..2831a32 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -87,6 +87,37 @@ int __init early_is_k8_nb(u32 device)
 	return 0;
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
+	if (boot_cpu_data.x86 < 0x10)
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
+                         FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+	res->flags = IORESOURCE_MEM;
+	res->start = base;
+	res->end = base + (1ULL<<(segn_busn_bits + 20)) - 1;
+	return res;
+}
+
 void k8_flush_garts(void)
 {
 	int flushed, i;
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 572ee97..cb34763 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -190,34 +190,6 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
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
 /**
  * early_fill_mp_bus_to_node()
  * called before pcibios_scan_root and pci_scan_bus
@@ -243,6 +215,9 @@ static int __init early_fill_mp_bus_info(void)
 	struct res_range range[RANGE_NUM];
 	u64 val;
 	u32 address;
+	struct resource fam10h_mmconf_res, *fam10h_mmconf;
+	u64 fam10h_mmconf_start;
+	u64 fam10h_mmconf_end;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -367,11 +342,16 @@ static int __init early_fill_mp_bus_info(void)
 		update_range(range, 0, end - 1);
 
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
 		update_range(range, fam10h_mmconf_start, fam10h_mmconf_end);
+	} else {
+		fam10h_mmconf_start = 0;
+		fam10h_mmconf_end = 0;
 	}
 
 	/* mmio resource */
-- 
1.7.2.1.45.g54fbc



