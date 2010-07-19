Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966461Ab0GSSnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:43:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:48730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965985Ab0GSSk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:27 -0400
Date: Mon, 19 Jul 2010 18:39:49 GMT
Message-Id: <201007191839.o6JIdn9C006732@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stephan Wolf <stephan@letzte-bankreihe.de>,
        Borislav Petkov <borislav.petkov@amd.com>, stable@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] (More) x86 fixes for 2.6.35-rc6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 19 Jul 2010 18:39:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 2f7989efd4398d92b8adffce2e07dd043a0895fe:
  Linus Torvalds (1):
        Merge master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Jacob Pan (1):
      x86, pci, mrst: Add extra sanity check in walking the PCI extended cap chain

Thomas Gleixner (1):
      x86: Force HPET readback_cmp for all ATI chipsets

Yinghai Lu (1):
      x86: Fix x2apic preenabled system with kexec

 arch/x86/kernel/apic/apic.c    |    2 +-
 arch/x86/kernel/early-quirks.c |   18 ++++++++++++++++++
 arch/x86/kernel/quirks.c       |    5 -----
 arch/x86/pci/mrst.c            |    7 ++++---
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c02cc69..a96489e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -921,7 +921,7 @@ void disable_local_APIC(void)
 	unsigned int value;
 
 	/* APIC hasn't been mapped yet */
-	if (!apic_phys)
+	if (!x2apic_mode && !apic_phys)
 		return;
 
 	clear_local_APIC();
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index ebdb85c..e5cc7e8 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -18,6 +18,7 @@
 #include <asm/apic.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/hpet.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -191,6 +192,21 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
+/*
+ * Force the read back of the CMP register in hpet_next_event()
+ * to work around the problem that the CMP register write seems to be
+ * delayed. See hpet_next_event() for details.
+ *
+ * We do this on all SMBUS incarnations for now until we have more
+ * information about the affected chipsets.
+ */
+static void __init ati_hpet_bugs(int num, int slot, int func)
+{
+#ifdef CONFIG_HPET_TIMER
+	hpet_readback_cmp = 1;
+#endif
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -220,6 +236,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
+	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_hpet_bugs },
 	{}
 };
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e72d3fc..939b9e9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -498,15 +498,10 @@ void force_hpet_resume(void)
  * See erratum #27 (Misinterpreted MSI Requests May Result in
  * Corrupted LPC DMA Data) in AMD Publication #46837,
  * "SB700 Family Product Errata", Rev. 1.0, March 2010.
- *
- * Also force the read back of the CMP register in hpet_next_event()
- * to work around the problem that the CMP register write seems to be
- * delayed. See hpet_next_event() for details.
  */
 static void force_disable_hpet_msi(struct pci_dev *unused)
 {
 	hpet_msi_disable = 1;
-	hpet_readback_cmp = 1;
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 7ef3a27..cb29191 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -66,8 +66,9 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 					  devfn, pos, 4, &pcie_cap))
 			return 0;
 
-		if (pcie_cap == 0xffffffff)
-			return 0;
+		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
+			PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
+			break;
 
 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
@@ -76,7 +77,7 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 				return pos;
 		}
 
-		pos = pcie_cap >> 20;
+		pos = PCI_EXT_CAP_NEXT(pcie_cap);
 	}
 
 	return 0;
