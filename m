Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1LGVIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:08:16 -0500
Received: from re04.intra2net.com ([82.165.46.26]:59149 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1LGVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:08:15 -0500
Message-ID: <4EDFD5BB.1050906@intra2net.com>
Date: Wed, 07 Dec 2011 22:08:11 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: linux-pci@vger.kernel.org
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        Charlie Suffin <charlie.suffin@stratus.com>, stable@kernel.org
Subject: [PATCH] pci: Add quirk for still enabled interrupts on Intel Sandy
 Bridge GPUs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

Please CC: comments.

 drivers/pci/quirks.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6476547..78fda9c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2906,6 +2906,40 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f8, quirk_intel_mc_errata);
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
-- 
1.7.4.4
