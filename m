Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2DXWvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:51:37 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640Ab2DXWgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:20 -0400
Message-Id: <20120424223245.986691967@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Charlie Suffin <charlie.suffin@stratus.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 47/62] PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

commit f67fd55fa96f7d7295b43ffbc4a97d8f55e473aa upstream.

Some BIOS implementations leave the Intel GPU interrupts enabled,
even though no one is handling them (f.e. i915 driver is never loaded).
Additionally the interrupt destination is not set up properly
and the interrupt ends up -somewhere-.

These spurious interrupts are "sticky" and the kernel disables
the (shared) interrupt line after 100.000+ generated interrupts.

Fix it by disabling the still enabled interrupts.
This resolves crashes often seen on monitor unplug.

Tested on the following boards:
- Intel DH61CR: Affected
- Intel DH67BL: Affected
- Intel S1200KP server board: Affected
- Asus P8H61-M LE: Affected, but system does not crash.
  Probably the IRQ ends up somewhere unnoticed.

According to reports on the net, the Intel DH61WW board is also affected.

Many thanks to Jesse Barnes from Intel for helping
with the register configuration and to Intel in general
for providing public hardware documentation.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Tested-by: Charlie Suffin <charlie.suffin@stratus.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2906,6 +2906,40 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f9, quirk_intel_mc_errata);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65fa, quirk_intel_mc_errata);
 
+/*
+ * Some BIOS implementations leave the Intel GPU interrupts enabled,
+ * even though no one is handling them (f.e. i915 driver is never loaded).
+ * Additionally the interrupt destination is not set up properly
+ * and the interrupt ends up -somewhere-.
+ *
+ * These spurious interrupts are "sticky" and the kernel disables
+ * the (shared) interrupt line after 100.000+ generated interrupts.
+ *
+ * Fix it by disabling the still enabled interrupts.
+ * This resolves crashes often seen on monitor unplug.
+ */
+#define I915_DEIER_REG 0x4400c
+static void __devinit disable_igfx_irq(struct pci_dev *dev)
+{
+	void __iomem *regs = pci_iomap(dev, 0, 0);
+	if (regs == NULL) {
+		dev_warn(&dev->dev, "igfx quirk: Can't iomap PCI device\n");
+		return;
+	}
+
+	/* Check if any interrupt line is still enabled */
+	if (readl(regs + I915_DEIER_REG) != 0) {
+		dev_warn(&dev->dev, "BIOS left Intel GPU interrupts enabled; "
+			"disabling\n");
+
+		writel(0, regs + I915_DEIER_REG);
+	}
+
+	pci_iounmap(dev, regs);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {


