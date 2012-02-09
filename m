Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab2BIOBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:01:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51424 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab2BIOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:01:40 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86, soc: Fix fallout from the previous changes
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 14:15:21 +0000
Message-ID: <20120209141517.26563.45774.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The PCI fixups get executed based upon whether they are linked in. We need
to avoid executing them if we boot a dual SoC/PC type kernel on a PC class
system.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/pci/mrst.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)


diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index c5e81a4..140942f 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -43,6 +43,8 @@
 #define PCI_FIXED_BAR_4_SIZE	0x14
 #define PCI_FIXED_BAR_5_SIZE	0x1c
 
+static int pci_soc_mode = 0;
+
 /**
  * fixed_bar_cap - return the offset of the fixed BAR cap if found
  * @bus: PCI bus
@@ -233,10 +235,11 @@ struct pci_ops pci_mrst_ops = {
  */
 int __init pci_mrst_init(void)
 {
-	printk(KERN_INFO "Moorestown platform detected, using MRST PCI ops\n");
+	printk(KERN_INFO "Intel MID platform detected, using MID PCI ops\n");
 	pci_mmcfg_late_init();
 	pcibios_enable_irq = mrst_pci_irq_enable;
 	pci_root_ops = pci_mrst_ops;
+	pci_soc_mode = 1;
 	/* Continue with standard init */
 	return 1;
 }
@@ -246,6 +249,10 @@ int __init pci_mrst_init(void)
  */
 static void __devinit pci_d3delay_fixup(struct pci_dev *dev)
 {
+	/* PCI fixups are effectively decided compile time. If we have a dual
+	   SoC/non-SoC kernel we don't want to mangle d3 on non SoC devices */
+        if (!pci_soc_mode)
+            return;
 	/* true pci devices in lincroft should allow type 1 access, the rest
 	 * are langwell fake pci devices.
 	 */
@@ -274,6 +281,9 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	u32 size;
 	int i;
 
+	if (!pci_soc_mode)
+		return;
+
 	/* Must have extended configuration space */
 	if (dev->cfg_size < PCIE_CAP_OFFSET + 4)
 		return;

