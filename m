Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062Ab2JAXXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:23:07 -0400
Received: from 1wt.eu ([62.212.114.60]:35346 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab2JAXBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:23 -0400
Message-Id: <20121001225200.785258736@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 075/180] PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/pci/quirks.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1e42381..d0959af 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2550,6 +2550,40 @@ static void __devinit fixup_ti816x_class(struct pci_dev* dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_TI, 0xb800, fixup_ti816x_class);
 
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
-- 
1.7.2.1.45.g54fbc



