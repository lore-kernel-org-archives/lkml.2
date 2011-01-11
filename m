Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1AKA4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:56:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60426 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab1AKA4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:56:19 -0500
Message-ID: <4D2BAA75.60001@kernel.org>
Date: Mon, 10 Jan 2011 16:55:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3 1/4] pci, usb:  Make usb handoff func all take base remapping
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org> <4D2BA8FE.9090204@kernel.org>
In-Reply-To: <4D2BA8FE.9090204@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So later could reuse them to do usb handoff much early for x86.

will make arch early code get MMIO BAR and do remapping itself.

-v2: still keep pci_device *pdev as parameter according to BenH.
-v3: expose three functions that take *base instead of including .c file.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/usb/host/pci-quirks.c |  195 ++++++++++++++++++++++++------------------
 drivers/usb/host/pci-quirks.h |    6 +
 2 files changed, 120 insertions(+), 81 deletions(-)

Index: linux-2.6/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6/drivers/usb/host/pci-quirks.c
@@ -17,6 +17,19 @@
 #include "pci-quirks.h"
 #include "xhci-ext-caps.h"
 
+static void default_usb_handoff_udelay(unsigned long usecs)
+{
+	udelay(usecs);
+}
+
+static void __devinit default_usb_handoff_msleep(unsigned long msecs)
+{
+	msleep(msecs);
+}
+
+void (*usb_handoff_udelay)(unsigned long) = default_usb_handoff_udelay;
+void (*usb_handoff_msleep)(unsigned long) __devinitdata =
+			default_usb_handoff_msleep;
 
 #define UHCI_USBLEGSUP		0xc0		/* legacy support */
 #define UHCI_USBCMD		0		/* command register */
@@ -71,7 +84,7 @@ void uhci_reset_hc(struct pci_dev *pdev,
 	 */
 	outw(UHCI_USBCMD_HCRESET, base + UHCI_USBCMD);
 	mb();
-	udelay(5);
+	(*usb_handoff_udelay)(5);
 	if (inw(base + UHCI_USBCMD) & UHCI_USBCMD_HCRESET)
 		dev_warn(&pdev->dev, "HCRESET not completed yet!\n");
 
@@ -106,78 +119,38 @@ int uhci_check_and_reset_hc(struct pci_d
 	 */
 	pci_read_config_word(pdev, UHCI_USBLEGSUP, &legsup);
 	if (legsup & ~(UHCI_USBLEGSUP_RO | UHCI_USBLEGSUP_RWC)) {
-		dev_dbg(&pdev->dev, "%s: legsup = 0x%04x\n",
-				__func__, legsup);
+		dev_printk(KERN_DEBUG, &pdev->dev,
+				 "legsup = 0x%04x\n", legsup);
 		goto reset_needed;
 	}
 
 	cmd = inw(base + UHCI_USBCMD);
 	if ((cmd & UHCI_USBCMD_RUN) || !(cmd & UHCI_USBCMD_CONFIGURE) ||
 			!(cmd & UHCI_USBCMD_EGSM)) {
-		dev_dbg(&pdev->dev, "%s: cmd = 0x%04x\n",
-				__func__, cmd);
+		dev_printk(KERN_DEBUG, &pdev->dev, "cmd = 0x%04x\n", cmd);
 		goto reset_needed;
 	}
 
 	intr = inw(base + UHCI_USBINTR);
 	if (intr & (~UHCI_USBINTR_RESUME)) {
-		dev_dbg(&pdev->dev, "%s: intr = 0x%04x\n",
-				__func__, intr);
+		dev_printk(KERN_DEBUG, &pdev->dev, "intr = 0x%04x\n", intr);
 		goto reset_needed;
 	}
 	return 0;
 
 reset_needed:
-	dev_dbg(&pdev->dev, "Performing full reset\n");
+	dev_printk(KERN_DEBUG, &pdev->dev, "Performing full reset\n");
+
 	uhci_reset_hc(pdev, base);
+
 	return 1;
 }
 EXPORT_SYMBOL_GPL(uhci_check_and_reset_hc);
 
-static inline int io_type_enabled(struct pci_dev *pdev, unsigned int mask)
-{
-	u16 cmd;
-	return !pci_read_config_word(pdev, PCI_COMMAND, &cmd) && (cmd & mask);
-}
-
-#define pio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_IO)
-#define mmio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_MEMORY)
-
-static void __devinit quirk_usb_handoff_uhci(struct pci_dev *pdev)
-{
-	unsigned long base = 0;
-	int i;
-
-	if (!pio_enabled(pdev))
-		return;
-
-	for (i = 0; i < PCI_ROM_RESOURCE; i++)
-		if ((pci_resource_flags(pdev, i) & IORESOURCE_IO)) {
-			base = pci_resource_start(pdev, i);
-			break;
-		}
-
-	if (base)
-		uhci_check_and_reset_hc(pdev, base);
-}
-
-static int __devinit mmio_resource_enabled(struct pci_dev *pdev, int idx)
+void __devinit __usb_handoff_ohci(struct pci_dev *pdev, void __iomem *base)
 {
-	return pci_resource_start(pdev, idx) && mmio_enabled(pdev);
-}
-
-static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
-{
-	void __iomem *base;
 	u32 control;
 
-	if (!mmio_resource_enabled(pdev, 0))
-		return;
-
-	base = pci_ioremap_bar(pdev, 0);
-	if (base == NULL)
-		return;
-
 	control = readl(base + OHCI_CONTROL);
 
 /* On PA-RISC, PDC can leave IR set incorrectly; ignore it there. */
@@ -193,7 +166,7 @@ static void __devinit quirk_usb_handoff_
 		while (wait_time > 0 &&
 				readl(base + OHCI_CONTROL) & OHCI_CTRL_IR) {
 			wait_time -= 10;
-			msleep(10);
+			(*usb_handoff_msleep)(10);
 		}
 		if (wait_time <= 0)
 			dev_warn(&pdev->dev, "OHCI: BIOS handoff failed"
@@ -210,26 +183,17 @@ static void __devinit quirk_usb_handoff_
 	 */
 	writel(~(u32)0, base + OHCI_INTRDISABLE);
 	writel(~(u32)0, base + OHCI_INTRSTATUS);
-
-	iounmap(base);
 }
 
-static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
+void __devinit __usb_handoff_ehci(struct pci_dev *pdev, void __iomem *base)
 {
 	int wait_time, delta;
-	void __iomem *base, *op_reg_base;
+	void *op_reg_base;
 	u32	hcc_params, val;
 	u8	offset, cap_length;
 	int	count = 256/4;
 	int	tried_handoff = 0;
 
-	if (!mmio_resource_enabled(pdev, 0))
-		return;
-
-	base = pci_ioremap_bar(pdev, 0);
-	if (base == NULL)
-		return;
-
 	cap_length = readb(base);
 	op_reg_base = base + cap_length;
 
@@ -247,7 +211,8 @@ static void __devinit quirk_usb_disable_
 		switch (cap & 0xff) {
 		case 1:			/* BIOS/SMM/... handoff support */
 			if ((cap & EHCI_USBLEGSUP_BIOS)) {
-				dev_dbg(&pdev->dev, "EHCI: BIOS handoff\n");
+				dev_printk(KERN_DEBUG, &pdev->dev,
+						"EHCI: BIOS handoff\n");
 
 #if 0
 /* aleksey_gorelov@phoenix.com reports that some systems need SMI forced on,
@@ -279,7 +244,7 @@ static void __devinit quirk_usb_disable_
 			msec = 1000;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
-				msleep(10);
+				(*usb_handoff_msleep)(10);
 				msec -= 10;
 				pci_read_config_dword(pdev, offset, &cap);
 			}
@@ -330,18 +295,15 @@ static void __devinit quirk_usb_disable_
 		delta = 100;
 		do {
 			writel(0x3f, op_reg_base + EHCI_USBSTS);
-			udelay(delta);
+			(*usb_handoff_udelay)(delta);
 			wait_time -= delta;
 			val = readl(op_reg_base + EHCI_USBSTS);
-			if ((val == ~(u32)0) || (val & EHCI_USBSTS_HALTED)) {
+			if ((val == ~(u32)0) || (val & EHCI_USBSTS_HALTED))
 				break;
-			}
 		} while (wait_time > 0);
 	}
 	writel(0, op_reg_base + EHCI_USBINTR);
 	writel(0x3f, op_reg_base + EHCI_USBSTS);
-
-	iounmap(base);
 }
 
 /*
@@ -357,7 +319,7 @@ static void __devinit quirk_usb_disable_
  * Returns -ETIMEDOUT if this condition is not true after
  * wait_usec microseconds have passed.
  */
-static int handshake(void __iomem *ptr, u32 mask, u32 done,
+static int __devinit handshake(void __iomem *ptr, u32 mask, u32 done,
 		int wait_usec, int delay_usec)
 {
 	u32	result;
@@ -367,7 +329,7 @@ static int handshake(void __iomem *ptr,
 		result &= mask;
 		if (result == done)
 			return 0;
-		udelay(delay_usec);
+		(*usb_handoff_udelay)(delay_usec);
 		wait_usec -= delay_usec;
 	} while (wait_usec > 0);
 	return -ETIMEDOUT;
@@ -381,22 +343,13 @@ static int handshake(void __iomem *ptr,
  * and then waits 5 seconds for the BIOS to hand over control.
  * If we timeout, assume the BIOS is broken and take control anyway.
  */
-static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
+void __usb_handoff_xhci(struct pci_dev *pdev, void __iomem *base)
 {
-	void __iomem *base;
 	int ext_cap_offset;
 	void __iomem *op_reg_base;
 	u32 val;
 	int timeout;
 
-	if (!mmio_resource_enabled(pdev, 0))
-		return;
-
-	base = ioremap_nocache(pci_resource_start(pdev, 0),
-				pci_resource_len(pdev, 0));
-	if (base == NULL)
-		return;
-
 	/*
 	 * Find the Legacy Support Capability register -
 	 * this is optional for xHCI host controllers.
@@ -462,6 +415,86 @@ hc_init:
 				"xHCI HW did not halt within %d usec "
 				"status = 0x%x\n", XHCI_MAX_HALT_USEC, val);
 	}
+}
+
+static inline int io_type_enabled(struct pci_dev *pdev, unsigned int mask)
+{
+	u16 cmd;
+	return !pci_read_config_word(pdev, PCI_COMMAND, &cmd) && (cmd & mask);
+}
+
+#define pio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_IO)
+#define mmio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_MEMORY)
+
+static void __devinit quirk_usb_handoff_uhci(struct pci_dev *pdev)
+{
+	unsigned long base = 0;
+	int i;
+
+	if (!pio_enabled(pdev))
+		return;
+
+	for (i = 0; i < PCI_ROM_RESOURCE; i++)
+		if ((pci_resource_flags(pdev, i) & IORESOURCE_IO)) {
+			base = pci_resource_start(pdev, i);
+			break;
+		}
+
+	if (!base)
+		return;
+
+	uhci_check_and_reset_hc(pdev, base);
+}
+
+static int __devinit mmio_resource_enabled(struct pci_dev *pdev, int idx)
+{
+	return pci_resource_start(pdev, idx) && mmio_enabled(pdev);
+}
+
+static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
+{
+	void __iomem *base;
+
+	if (!mmio_resource_enabled(pdev, 0))
+		return;
+
+	base = pci_ioremap_bar(pdev, 0);
+	if (base == NULL)
+		return;
+
+	__usb_handoff_ohci(pdev, base);
+
+	iounmap(base);
+}
+
+static void __devinit quirk_usb_handoff_ehci(struct pci_dev *pdev)
+{
+	void __iomem *base;
+
+	if (!mmio_resource_enabled(pdev, 0))
+		return;
+
+	base = pci_ioremap_bar(pdev, 0);
+	if (base == NULL)
+		return;
+
+	__usb_handoff_ehci(pdev, base);
+
+	iounmap(base);
+}
+
+static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
+{
+	void __iomem *base;
+
+	if (!mmio_resource_enabled(pdev, 0))
+		return;
+
+	base = pci_ioremap_bar(pdev, 0);
+	if (base == NULL)
+		return;
+
+	__usb_handoff_xhci(pdev, base);
 
 	iounmap(base);
 }
@@ -473,7 +506,7 @@ static void __devinit quirk_usb_early_ha
 	else if (pdev->class == PCI_CLASS_SERIAL_USB_OHCI)
 		quirk_usb_handoff_ohci(pdev);
 	else if (pdev->class == PCI_CLASS_SERIAL_USB_EHCI)
-		quirk_usb_disable_ehci(pdev);
+		quirk_usb_handoff_ehci(pdev);
 	else if (pdev->class == PCI_CLASS_SERIAL_USB_XHCI)
 		quirk_usb_handoff_xhci(pdev);
 }
Index: linux-2.6/drivers/usb/host/pci-quirks.h
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.h
+++ linux-2.6/drivers/usb/host/pci-quirks.h
@@ -3,5 +3,11 @@
 
 void uhci_reset_hc(struct pci_dev *pdev, unsigned long base);
 int uhci_check_and_reset_hc(struct pci_dev *pdev, unsigned long base);
+void __usb_handoff_ohci(struct pci_dev *pdev, void __iomem *base);
+void __usb_handoff_ehci(struct pci_dev *pdev, void __iomem *base);
+void __usb_handoff_xhci(struct pci_dev *pdev, void __iomem *base);
+
+extern void (*usb_handoff_udelay)(unsigned long);
+extern void (*usb_handoff_msleep)(unsigned long);
 
 #endif  /*  __LINUX_USB_PCI_QUIRKS_H  */
