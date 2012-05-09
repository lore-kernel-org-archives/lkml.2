Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2EIJBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:01:41 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40552 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2EIJBi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 9 May 2012 05:01:38 -0400
Message-Id: <4FAA4AB20200007800082705@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 09:45:06 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>, "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/5, resend] x86: adjust quirk handler section
 annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation to adjust modpost to check section mismatches
on most of the .pci_fixup* sections:

.pci_fixup_final is only used from .init.text, and hence can (along
with the respective handler functions) reside in .init.*.

Several other .pci_fixup_* sections are needed only during boot and
suspend/resume, and can therefore be moved into .init.* if
!CONFIG_PM.

Handler (and eventual static data) section annotations need to/can be
changed accordingly.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

---
 arch/x86/kernel/pci-dma.c         |    2 +-
 arch/x86/kernel/quirks.c          |    2 +-
 arch/x86/pci/fixup.c              |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

--- 3.4-rc6/arch/x86/kernel/pci-dma.c
+++ 3.4-rc6-pci-fixup-sections/arch/x86/kernel/pci-dma.c
@@ -261,7 +261,7 @@ rootfs_initcall(pci_iommu_init);
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
-static __devinit void via_no_dac(struct pci_dev *dev)
+static __init void via_no_dac(struct pci_dev *dev)
 {
 	if (forbid_dac == 0) {
 		dev_info(&dev->dev, "disabling DAC on VIA PCI bridge\n");
--- 3.4-rc6/arch/x86/kernel/quirks.c
+++ 3.4-rc6-pci-fixup-sections/arch/x86/kernel/quirks.c
@@ -8,7 +8,7 @@
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 
-static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
+static void __init quirk_intel_irqbalance(struct pci_dev *dev)
 {
 	u8 config;
 	u16 word;
--- 3.4-rc6/arch/x86/pci/fixup.c
+++ 3.4-rc6-pci-fixup-sections/arch/x86/pci/fixup.c
@@ -249,7 +249,7 @@ static struct pci_ops quirk_pcie_aspm_op
  * the root port in an array for fast indexing. Replace the bus ops
  * with the modified one.
  */
-static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
+static void __init pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 {
 	int cap_base, i;
 	struct pci_bus  *pbus;
@@ -411,7 +411,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
  */
 static u16 toshiba_line_size;
 
-static const struct dmi_system_id __devinitconst toshiba_ohci1394_dmi_table[] = {
+static const struct dmi_system_id toshiba_ohci1394_dmi_table[] = {
 	{
 		.ident = "Toshiba PS5 based laptop",
 		.matches = {
@@ -447,7 +447,7 @@ static void __devinit pci_pre_fixup_tosh
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TI, 0x8032,
 			 pci_pre_fixup_toshiba_ohci1394);
 
-static void __devinit pci_post_fixup_toshiba_ohci1394(struct pci_dev *dev)
+static void pci_post_fixup_toshiba_ohci1394(struct pci_dev *dev)
 {
 	if (!dmi_check_system(toshiba_ohci1394_dmi_table))
 		return; /* only applies to certain Toshibas (so far) */



