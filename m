Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1AJIoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:44:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18416 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1AJIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:44:16 -0500
Message-ID: <4D2AC6C9.1050306@kernel.org>
Date: Mon, 10 Jan 2011 00:43:53 -0800
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
Subject: [PATCH -v2 1/4] pci, usb: Seperate usb handoff func to another file
References: <4D2A1382.7010407@kernel.org> <4D2AC584.6010004@kernel.org>
In-Reply-To: <4D2AC584.6010004@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So later could reuse them to do usb handoff much early for x86.

will make arch early code get MMIO BAR and do remapping itself.

-v2: still keep pci_device *pdev as parameter according to BenH.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/usb/host/pci-quirks.c  |  382 +-------------------------------------
 drivers/usb/host/usb_handoff.c |  402 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 420 insertions(+), 364 deletions(-)

Index: linux-2.6/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6/drivers/usb/host/pci-quirks.c
@@ -15,122 +15,28 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include "pci-quirks.h"
-#include "xhci-ext-caps.h"
 
+static void usb_handoff_udelay(unsigned long usecs)
+{
+	udelay(usecs);
+}
+
+static void usb_handoff_msleep(unsigned long msecs)
+{
+	msleep(msecs);
+}
+
+#include "usb_handoff.c"
 
-#define UHCI_USBLEGSUP		0xc0		/* legacy support */
-#define UHCI_USBCMD		0		/* command register */
-#define UHCI_USBINTR		4		/* interrupt register */
-#define UHCI_USBLEGSUP_RWC	0x8f00		/* the R/WC bits */
-#define UHCI_USBLEGSUP_RO	0x5040		/* R/O and reserved bits */
-#define UHCI_USBCMD_RUN		0x0001		/* RUN/STOP bit */
-#define UHCI_USBCMD_HCRESET	0x0002		/* Host Controller reset */
-#define UHCI_USBCMD_EGSM	0x0008		/* Global Suspend Mode */
-#define UHCI_USBCMD_CONFIGURE	0x0040		/* Config Flag */
-#define UHCI_USBINTR_RESUME	0x0002		/* Resume interrupt enable */
-
-#define OHCI_CONTROL		0x04
-#define OHCI_CMDSTATUS		0x08
-#define OHCI_INTRSTATUS		0x0c
-#define OHCI_INTRENABLE		0x10
-#define OHCI_INTRDISABLE	0x14
-#define OHCI_OCR		(1 << 3)	/* ownership change request */
-#define OHCI_CTRL_RWC		(1 << 9)	/* remote wakeup connected */
-#define OHCI_CTRL_IR		(1 << 8)	/* interrupt routing */
-#define OHCI_INTR_OC		(1 << 30)	/* ownership change */
-
-#define EHCI_HCC_PARAMS		0x08		/* extended capabilities */
-#define EHCI_USBCMD		0		/* command register */
-#define EHCI_USBCMD_RUN		(1 << 0)	/* RUN/STOP bit */
-#define EHCI_USBSTS		4		/* status register */
-#define EHCI_USBSTS_HALTED	(1 << 12)	/* HCHalted bit */
-#define EHCI_USBINTR		8		/* interrupt register */
-#define EHCI_CONFIGFLAG		0x40		/* configured flag register */
-#define EHCI_USBLEGSUP		0		/* legacy support register */
-#define EHCI_USBLEGSUP_BIOS	(1 << 16)	/* BIOS semaphore */
-#define EHCI_USBLEGSUP_OS	(1 << 24)	/* OS semaphore */
-#define EHCI_USBLEGCTLSTS	4		/* legacy control/status */
-#define EHCI_USBLEGCTLSTS_SOOE	(1 << 13)	/* SMI on ownership change */
-
-
-/*
- * Make sure the controller is completely inactive, unable to
- * generate interrupts or do DMA.
- */
 void uhci_reset_hc(struct pci_dev *pdev, unsigned long base)
 {
-	/* Turn off PIRQ enable and SMI enable.  (This also turns off the
-	 * BIOS's USB Legacy Support.)  Turn off all the R/WC bits too.
-	 */
-	pci_write_config_word(pdev, UHCI_USBLEGSUP, UHCI_USBLEGSUP_RWC);
-
-	/* Reset the HC - this will force us to get a
-	 * new notification of any already connected
-	 * ports due to the virtual disconnect that it
-	 * implies.
-	 */
-	outw(UHCI_USBCMD_HCRESET, base + UHCI_USBCMD);
-	mb();
-	udelay(5);
-	if (inw(base + UHCI_USBCMD) & UHCI_USBCMD_HCRESET)
-		dev_warn(&pdev->dev, "HCRESET not completed yet!\n");
-
-	/* Just to be safe, disable interrupt requests and
-	 * make sure the controller is stopped.
-	 */
-	outw(0, base + UHCI_USBINTR);
-	outw(0, base + UHCI_USBCMD);
+	__uhci_reset_hc(pdev, base);
 }
 EXPORT_SYMBOL_GPL(uhci_reset_hc);
 
-/*
- * Initialize a controller that was newly discovered or has just been
- * resumed.  In either case we can't be sure of its previous state.
- *
- * Returns: 1 if the controller was reset, 0 otherwise.
- */
 int uhci_check_and_reset_hc(struct pci_dev *pdev, unsigned long base)
 {
-	u16 legsup;
-	unsigned int cmd, intr;
-
-	/*
-	 * When restarting a suspended controller, we expect all the
-	 * settings to be the same as we left them:
-	 *
-	 *	PIRQ and SMI disabled, no R/W bits set in USBLEGSUP;
-	 *	Controller is stopped and configured with EGSM set;
-	 *	No interrupts enabled except possibly Resume Detect.
-	 *
-	 * If any of these conditions are violated we do a complete reset.
-	 */
-	pci_read_config_word(pdev, UHCI_USBLEGSUP, &legsup);
-	if (legsup & ~(UHCI_USBLEGSUP_RO | UHCI_USBLEGSUP_RWC)) {
-		dev_dbg(&pdev->dev, "%s: legsup = 0x%04x\n",
-				__func__, legsup);
-		goto reset_needed;
-	}
-
-	cmd = inw(base + UHCI_USBCMD);
-	if ((cmd & UHCI_USBCMD_RUN) || !(cmd & UHCI_USBCMD_CONFIGURE) ||
-			!(cmd & UHCI_USBCMD_EGSM)) {
-		dev_dbg(&pdev->dev, "%s: cmd = 0x%04x\n",
-				__func__, cmd);
-		goto reset_needed;
-	}
-
-	intr = inw(base + UHCI_USBINTR);
-	if (intr & (~UHCI_USBINTR_RESUME)) {
-		dev_dbg(&pdev->dev, "%s: intr = 0x%04x\n",
-				__func__, intr);
-		goto reset_needed;
-	}
-	return 0;
-
-reset_needed:
-	dev_dbg(&pdev->dev, "Performing full reset\n");
-	uhci_reset_hc(pdev, base);
-	return 1;
+	return	__uhci_check_and_reset_hc(pdev, base);
 }
 EXPORT_SYMBOL_GPL(uhci_check_and_reset_hc);
 
@@ -169,7 +75,6 @@ static int __devinit mmio_resource_enabl
 static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
-	u32 control;
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
@@ -178,50 +83,14 @@ static void __devinit quirk_usb_handoff_
 	if (base == NULL)
 		return;
 
-	control = readl(base + OHCI_CONTROL);
-
-/* On PA-RISC, PDC can leave IR set incorrectly; ignore it there. */
-#ifdef __hppa__
-#define	OHCI_CTRL_MASK		(OHCI_CTRL_RWC | OHCI_CTRL_IR)
-#else
-#define	OHCI_CTRL_MASK		OHCI_CTRL_RWC
-
-	if (control & OHCI_CTRL_IR) {
-		int wait_time = 500; /* arbitrary; 5 seconds */
-		writel(OHCI_INTR_OC, base + OHCI_INTRENABLE);
-		writel(OHCI_OCR, base + OHCI_CMDSTATUS);
-		while (wait_time > 0 &&
-				readl(base + OHCI_CONTROL) & OHCI_CTRL_IR) {
-			wait_time -= 10;
-			msleep(10);
-		}
-		if (wait_time <= 0)
-			dev_warn(&pdev->dev, "OHCI: BIOS handoff failed"
-					" (BIOS bug?) %08x\n",
-					readl(base + OHCI_CONTROL));
-	}
-#endif
-
-	/* reset controller, preserving RWC (and possibly IR) */
-	writel(control & OHCI_CTRL_MASK, base + OHCI_CONTROL);
-
-	/*
-	 * disable interrupts
-	 */
-	writel(~(u32)0, base + OHCI_INTRDISABLE);
-	writel(~(u32)0, base + OHCI_INTRSTATUS);
+	__usb_handoff_ohci(pdev, base);
 
 	iounmap(base);
 }
 
 static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
 {
-	int wait_time, delta;
-	void __iomem *base, *op_reg_base;
-	u32	hcc_params, val;
-	u8	offset, cap_length;
-	int	count = 256/4;
-	int	tried_handoff = 0;
+	void __iomem *base;
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
@@ -230,238 +99,23 @@ static void __devinit quirk_usb_disable_
 	if (base == NULL)
 		return;
 
-	cap_length = readb(base);
-	op_reg_base = base + cap_length;
-
-	/* EHCI 0.96 and later may have "extended capabilities"
-	 * spec section 5.1 explains the bios handoff, e.g. for
-	 * booting from USB disk or using a usb keyboard
-	 */
-	hcc_params = readl(base + EHCI_HCC_PARAMS);
-	offset = (hcc_params >> 8) & 0xff;
-	while (offset && --count) {
-		u32		cap;
-		int		msec;
-
-		pci_read_config_dword(pdev, offset, &cap);
-		switch (cap & 0xff) {
-		case 1:			/* BIOS/SMM/... handoff support */
-			if ((cap & EHCI_USBLEGSUP_BIOS)) {
-				dev_dbg(&pdev->dev, "EHCI: BIOS handoff\n");
-
-#if 0
-/* aleksey_gorelov@phoenix.com reports that some systems need SMI forced on,
- * but that seems dubious in general (the BIOS left it off intentionally)
- * and is known to prevent some systems from booting.  so we won't do this
- * unless maybe we can determine when we're on a system that needs SMI forced.
- */
-				/* BIOS workaround (?): be sure the
-				 * pre-Linux code receives the SMI
-				 */
-				pci_read_config_dword(pdev,
-						offset + EHCI_USBLEGCTLSTS,
-						&val);
-				pci_write_config_dword(pdev,
-						offset + EHCI_USBLEGCTLSTS,
-						val | EHCI_USBLEGCTLSTS_SOOE);
-#endif
-
-				/* some systems get upset if this semaphore is
-				 * set for any other reason than forcing a BIOS
-				 * handoff..
-				 */
-				pci_write_config_byte(pdev, offset + 3, 1);
-			}
-
-			/* if boot firmware now owns EHCI, spin till
-			 * it hands it over.
-			 */
-			msec = 1000;
-			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
-				tried_handoff = 1;
-				msleep(10);
-				msec -= 10;
-				pci_read_config_dword(pdev, offset, &cap);
-			}
-
-			if (cap & EHCI_USBLEGSUP_BIOS) {
-				/* well, possibly buggy BIOS... try to shut
-				 * it down, and hope nothing goes too wrong
-				 */
-				dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
-						" (BIOS bug?) %08x\n", cap);
-				pci_write_config_byte(pdev, offset + 2, 0);
-			}
-
-			/* just in case, always disable EHCI SMIs */
-			pci_write_config_dword(pdev,
-					offset + EHCI_USBLEGCTLSTS,
-					0);
-
-			/* If the BIOS ever owned the controller then we
-			 * can't expect any power sessions to remain intact.
-			 */
-			if (tried_handoff)
-				writel(0, op_reg_base + EHCI_CONFIGFLAG);
-			break;
-		case 0:			/* illegal reserved capability */
-			cap = 0;
-			/* FALLTHROUGH */
-		default:
-			dev_warn(&pdev->dev, "EHCI: unrecognized capability "
-					"%02x\n", cap & 0xff);
-			break;
-		}
-		offset = (cap >> 8) & 0xff;
-	}
-	if (!count)
-		dev_printk(KERN_DEBUG, &pdev->dev, "EHCI: capability loop?\n");
-
-	/*
-	 * halt EHCI & disable its interrupts in any case
-	 */
-	val = readl(op_reg_base + EHCI_USBSTS);
-	if ((val & EHCI_USBSTS_HALTED) == 0) {
-		val = readl(op_reg_base + EHCI_USBCMD);
-		val &= ~EHCI_USBCMD_RUN;
-		writel(val, op_reg_base + EHCI_USBCMD);
-
-		wait_time = 2000;
-		delta = 100;
-		do {
-			writel(0x3f, op_reg_base + EHCI_USBSTS);
-			udelay(delta);
-			wait_time -= delta;
-			val = readl(op_reg_base + EHCI_USBSTS);
-			if ((val == ~(u32)0) || (val & EHCI_USBSTS_HALTED)) {
-				break;
-			}
-		} while (wait_time > 0);
-	}
-	writel(0, op_reg_base + EHCI_USBINTR);
-	writel(0x3f, op_reg_base + EHCI_USBSTS);
+	__usb_handoff_ehci(pdev, base);
 
 	iounmap(base);
 }
 
-/*
- * handshake - spin reading a register until handshake completes
- * @ptr: address of hc register to be read
- * @mask: bits to look at in result of read
- * @done: value of those bits when handshake succeeds
- * @wait_usec: timeout in microseconds
- * @delay_usec: delay in microseconds to wait between polling
- *
- * Polls a register every delay_usec microseconds.
- * Returns 0 when the mask bits have the value done.
- * Returns -ETIMEDOUT if this condition is not true after
- * wait_usec microseconds have passed.
- */
-static int handshake(void __iomem *ptr, u32 mask, u32 done,
-		int wait_usec, int delay_usec)
-{
-	u32	result;
-
-	do {
-		result = readl(ptr);
-		result &= mask;
-		if (result == done)
-			return 0;
-		udelay(delay_usec);
-		wait_usec -= delay_usec;
-	} while (wait_usec > 0);
-	return -ETIMEDOUT;
-}
-
-/**
- * PCI Quirks for xHCI.
- *
- * Takes care of the handoff between the Pre-OS (i.e. BIOS) and the OS.
- * It signals to the BIOS that the OS wants control of the host controller,
- * and then waits 5 seconds for the BIOS to hand over control.
- * If we timeout, assume the BIOS is broken and take control anyway.
- */
 static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
 {
 	void __iomem *base;
-	int ext_cap_offset;
-	void __iomem *op_reg_base;
-	u32 val;
-	int timeout;
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
 
-	base = ioremap_nocache(pci_resource_start(pdev, 0),
-				pci_resource_len(pdev, 0));
+	base = pci_ioremap_bar(pdev, 0);
 	if (base == NULL)
 		return;
 
-	/*
-	 * Find the Legacy Support Capability register -
-	 * this is optional for xHCI host controllers.
-	 */
-	ext_cap_offset = xhci_find_next_cap_offset(base, XHCI_HCC_PARAMS_OFFSET);
-	do {
-		if (!ext_cap_offset)
-			/* We've reached the end of the extended capabilities */
-			goto hc_init;
-		val = readl(base + ext_cap_offset);
-		if (XHCI_EXT_CAPS_ID(val) == XHCI_EXT_CAPS_LEGACY)
-			break;
-		ext_cap_offset = xhci_find_next_cap_offset(base, ext_cap_offset);
-	} while (1);
-
-	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
-	if (val & XHCI_HC_BIOS_OWNED) {
-		writel(val & XHCI_HC_OS_OWNED, base + ext_cap_offset);
-
-		/* Wait for 5 seconds with 10 microsecond polling interval */
-		timeout = handshake(base + ext_cap_offset, XHCI_HC_BIOS_OWNED,
-				0, 5000, 10);
-
-		/* Assume a buggy BIOS and take HC ownership anyway */
-		if (timeout) {
-			dev_warn(&pdev->dev, "xHCI BIOS handoff failed"
-					" (BIOS bug ?) %08x\n", val);
-			writel(val & ~XHCI_HC_BIOS_OWNED, base + ext_cap_offset);
-		}
-	}
-
-	/* Disable any BIOS SMIs */
-	writel(XHCI_LEGACY_DISABLE_SMI,
-			base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
-
-hc_init:
-	op_reg_base = base + XHCI_HC_LENGTH(readl(base));
-
-	/* Wait for the host controller to be ready before writing any
-	 * operational or runtime registers.  Wait 5 seconds and no more.
-	 */
-	timeout = handshake(op_reg_base + XHCI_STS_OFFSET, XHCI_STS_CNR, 0,
-			5000, 10);
-	/* Assume a buggy HC and start HC initialization anyway */
-	if (timeout) {
-		val = readl(op_reg_base + XHCI_STS_OFFSET);
-		dev_warn(&pdev->dev,
-				"xHCI HW not ready after 5 sec (HC bug?) "
-				"status = 0x%x\n", val);
-	}
-
-	/* Send the halt and disable interrupts command */
-	val = readl(op_reg_base + XHCI_CMD_OFFSET);
-	val &= ~(XHCI_CMD_RUN | XHCI_IRQS);
-	writel(val, op_reg_base + XHCI_CMD_OFFSET);
-
-	/* Wait for the HC to halt - poll every 125 usec (one microframe). */
-	timeout = handshake(op_reg_base + XHCI_STS_OFFSET, XHCI_STS_HALT, 1,
-			XHCI_MAX_HALT_USEC, 125);
-	if (timeout) {
-		val = readl(op_reg_base + XHCI_STS_OFFSET);
-		dev_warn(&pdev->dev,
-				"xHCI HW did not halt within %d usec "
-				"status = 0x%x\n", XHCI_MAX_HALT_USEC, val);
-	}
+	__usb_handoff_xhci(pdev, base);
 
 	iounmap(base);
 }
Index: linux-2.6/drivers/usb/host/usb_handoff.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/usb/host/usb_handoff.c
@@ -0,0 +1,402 @@
+/*
+ * This file contains code to reset and initialize USB host controllers.
+ * Some of it includes work-arounds for PCI hardware and BIOS quirks.
+ * It may need to run early during booting -- before USB would normally
+ * initialize -- to ensure that Linux doesn't use any legacy modes.
+ *
+ *  Copyright (c) 1999 Martin Mares <mj@ucw.cz>
+ *  (and others)
+ */
+
+#include "xhci-ext-caps.h"
+
+#define UHCI_USBLEGSUP		0xc0		/* legacy support */
+#define UHCI_USBCMD		0		/* command register */
+#define UHCI_USBINTR		4		/* interrupt register */
+#define UHCI_USBLEGSUP_RWC	0x8f00		/* the R/WC bits */
+#define UHCI_USBLEGSUP_RO	0x5040		/* R/O and reserved bits */
+#define UHCI_USBCMD_RUN		0x0001		/* RUN/STOP bit */
+#define UHCI_USBCMD_HCRESET	0x0002		/* Host Controller reset */
+#define UHCI_USBCMD_EGSM	0x0008		/* Global Suspend Mode */
+#define UHCI_USBCMD_CONFIGURE	0x0040		/* Config Flag */
+#define UHCI_USBINTR_RESUME	0x0002		/* Resume interrupt enable */
+
+#define OHCI_CONTROL		0x04
+#define OHCI_CMDSTATUS		0x08
+#define OHCI_INTRSTATUS		0x0c
+#define OHCI_INTRENABLE		0x10
+#define OHCI_INTRDISABLE	0x14
+#define OHCI_OCR		(1 << 3)	/* ownership change request */
+#define OHCI_CTRL_RWC		(1 << 9)	/* remote wakeup connected */
+#define OHCI_CTRL_IR		(1 << 8)	/* interrupt routing */
+#define OHCI_INTR_OC		(1 << 30)	/* ownership change */
+
+#define EHCI_HCC_PARAMS		0x08		/* extended capabilities */
+#define EHCI_USBCMD		0		/* command register */
+#define EHCI_USBCMD_RUN		(1 << 0)	/* RUN/STOP bit */
+#define EHCI_USBSTS		4		/* status register */
+#define EHCI_USBSTS_HALTED	(1 << 12)	/* HCHalted bit */
+#define EHCI_USBINTR		8		/* interrupt register */
+#define EHCI_CONFIGFLAG		0x40		/* configured flag register */
+#define EHCI_USBLEGSUP		0		/* legacy support register */
+#define EHCI_USBLEGSUP_BIOS	(1 << 16)	/* BIOS semaphore */
+#define EHCI_USBLEGSUP_OS	(1 << 24)	/* OS semaphore */
+#define EHCI_USBLEGCTLSTS	4		/* legacy control/status */
+#define EHCI_USBLEGCTLSTS_SOOE	(1 << 13)	/* SMI on ownership change */
+
+/*
+ * Make sure the controller is completely inactive, unable to
+ * generate interrupts or do DMA.
+ */
+static void __uhci_reset_hc(struct pci_dev *pdev, unsigned long base)
+{
+	/* Turn off PIRQ enable and SMI enable.  (This also turns off the
+	 * BIOS's USB Legacy Support.)  Turn off all the R/WC bits too.
+	 */
+	pci_write_config_word(pdev, UHCI_USBLEGSUP, UHCI_USBLEGSUP_RWC);
+
+	/* Reset the HC - this will force us to get a
+	 * new notification of any already connected
+	 * ports due to the virtual disconnect that it
+	 * implies.
+	 */
+	outw(UHCI_USBCMD_HCRESET, base + UHCI_USBCMD);
+	mb();
+	usb_handoff_udelay(5);
+	if (inw(base + UHCI_USBCMD) & UHCI_USBCMD_HCRESET)
+		dev_warn(&pdev->dev, "HCRESET not completed yet!\n");
+
+	/* Just to be safe, disable interrupt requests and
+	 * make sure the controller is stopped.
+	 */
+	outw(0, base + UHCI_USBINTR);
+	outw(0, base + UHCI_USBCMD);
+}
+
+/*
+ * Initialize a controller that was newly discovered or has just been
+ * resumed.  In either case we can't be sure of its previous state.
+ *
+ * Returns: 1 if the controller was reset, 0 otherwise.
+ */
+static inline int
+__uhci_check_and_reset_hc(struct pci_dev *pdev, unsigned long base)
+{
+	u16 legsup;
+	unsigned int cmd, intr;
+
+	/*
+	 * When restarting a suspended controller, we expect all the
+	 * settings to be the same as we left them:
+	 *
+	 *	PIRQ and SMI disabled, no R/W bits set in USBLEGSUP;
+	 *	Controller is stopped and configured with EGSM set;
+	 *	No interrupts enabled except possibly Resume Detect.
+	 *
+	 * If any of these conditions are violated we do a complete reset.
+	 */
+	pci_read_config_word(pdev, UHCI_USBLEGSUP, &legsup);
+	if (legsup & ~(UHCI_USBLEGSUP_RO | UHCI_USBLEGSUP_RWC)) {
+		dev_printk(KERN_DEBUG, &pdev->dev,
+			 ": legsup = 0x%04x\n", legsup);
+		goto reset_needed;
+	}
+
+	cmd = inw(base + UHCI_USBCMD);
+	if ((cmd & UHCI_USBCMD_RUN) || !(cmd & UHCI_USBCMD_CONFIGURE) ||
+			!(cmd & UHCI_USBCMD_EGSM)) {
+		dev_printk(KERN_DEBUG, &pdev->dev, ": cmd = 0x%04x\n", cmd);
+		goto reset_needed;
+	}
+
+	intr = inw(base + UHCI_USBINTR);
+	if (intr & (~UHCI_USBINTR_RESUME)) {
+		dev_printk(KERN_DEBUG, &pdev->dev, ": intr = 0x%04x\n",intr);
+		goto reset_needed;
+	}
+	return 0;
+
+reset_needed:
+	dev_printk(KERN_DEBUG, &pdev->dev, "Performing full reset\n");
+
+	__uhci_reset_hc(pdev, base);
+
+	return 1;
+}
+
+static inline void
+__usb_handoff_ohci(struct pci_dev *pdev, void __iomem *base)
+{
+	u32 control;
+
+	control = readl(base + OHCI_CONTROL);
+
+/* On PA-RISC, PDC can leave IR set incorrectly; ignore it there. */
+#ifdef __hppa__
+#define	OHCI_CTRL_MASK		(OHCI_CTRL_RWC | OHCI_CTRL_IR)
+#else
+#define	OHCI_CTRL_MASK		OHCI_CTRL_RWC
+
+	if (control & OHCI_CTRL_IR) {
+		int wait_time = 500; /* arbitrary; 5 seconds */
+		writel(OHCI_INTR_OC, base + OHCI_INTRENABLE);
+		writel(OHCI_OCR, base + OHCI_CMDSTATUS);
+		while (wait_time > 0 &&
+				readl(base + OHCI_CONTROL) & OHCI_CTRL_IR) {
+			wait_time -= 1;
+			usb_handoff_msleep(1);
+		}
+		if (wait_time <= 0)
+			dev_warn(&pdev->dev,
+				 "OHCI: BIOS handoff failed (BIOS bug?) %08x\n",
+						readl(base + OHCI_CONTROL));
+	}
+#endif
+
+	/* reset controller, preserving RWC (and possibly IR) */
+	writel(control & OHCI_CTRL_MASK, base + OHCI_CONTROL);
+
+	/*
+	 * disable interrupts
+	 */
+	writel(~(u32)0, base + OHCI_INTRDISABLE);
+	writel(~(u32)0, base + OHCI_INTRSTATUS);
+}
+
+static inline void
+__usb_handoff_ehci(struct pci_dev *pdev, void __iomem *base)
+{
+	int wait_time, delta;
+	void *op_reg_base;
+	u32	hcc_params, val;
+	u8	offset, cap_length;
+	int	count = 256/4;
+	int	tried_handoff = 0;
+
+	cap_length = readb(base);
+	op_reg_base = base + cap_length;
+
+	/* EHCI 0.96 and later may have "extended capabilities"
+	 * spec section 5.1 explains the bios handoff, e.g. for
+	 * booting from USB disk or using a usb keyboard
+	 */
+	hcc_params = readl(base + EHCI_HCC_PARAMS);
+	offset = (hcc_params >> 8) & 0xff;
+	while (offset && --count) {
+		u32		cap;
+		int		msec;
+
+		pci_read_config_dword(pdev, offset, &cap);
+		switch (cap & 0xff) {
+		case 1:			/* BIOS/SMM/... handoff support */
+			if ((cap & EHCI_USBLEGSUP_BIOS)) {
+				dev_printk(KERN_DEBUG, &pdev->dev,
+						"EHCI: BIOS handoff\n");
+
+#if 0
+/* aleksey_gorelov@phoenix.com reports that some systems need SMI forced on,
+ * but that seems dubious in general (the BIOS left it off intentionally)
+ * and is known to prevent some systems from booting.  so we won't do this
+ * unless maybe we can determine when we're on a system that needs SMI forced.
+ */
+				/* BIOS workaround (?): be sure the
+				 * pre-Linux code receives the SMI
+				 */
+				pci_read_config_dword(pdev,
+						offset + EHCI_USBLEGCTLSTS,
+						&val);
+				pci_write_config_dword(pdev,
+						offset + EHCI_USBLEGCTLSTS,
+						val | EHCI_USBLEGCTLSTS_SOOE);
+#endif
+
+				/* some systems get upset if this semaphore is
+				 * set for any other reason than forcing a BIOS
+				 * handoff..
+				 */
+				pci_write_config_byte(pdev, offset + 3, 1);
+			}
+
+			/* if boot firmware now owns EHCI, spin till
+			 * it hands it over.
+			 */
+			msec = 1000;
+			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
+				tried_handoff = 1;
+				usb_handoff_msleep(1);
+				msec -= 1;
+				pci_read_config_dword(pdev, offset, &cap);
+			}
+
+			if (cap & EHCI_USBLEGSUP_BIOS) {
+				/* well, possibly buggy BIOS... try to shut
+				 * it down, and hope nothing goes too wrong
+				 */
+				dev_warn(&pdev->dev,
+				 "EHCI: BIOS handoff failed (BIOS bug?) %08x\n",
+							cap);
+				pci_write_config_byte(pdev, offset + 2, 0);
+			}
+
+			/* just in case, always disable EHCI SMIs */
+			pci_write_config_dword(pdev,
+					offset + EHCI_USBLEGCTLSTS,
+						0);
+
+			/* If the BIOS ever owned the controller then we
+			 * can't expect any power sessions to remain intact.
+			 */
+			if (tried_handoff)
+				writel(0, op_reg_base + EHCI_CONFIGFLAG);
+			break;
+		case 0:			/* illegal reserved capability */
+			cap = 0;
+			/* FALLTHROUGH */
+		default:
+			dev_warn(&pdev->dev,
+				 "EHCI: unrecognized capability %02x\n",
+						cap & 0xff);
+			break;
+		}
+		offset = (cap >> 8) & 0xff;
+	}
+	if (!count)
+			dev_printk(KERN_DEBUG, &pdev->dev,
+					"EHCI: capability loop?\n");
+
+	/*
+	 * halt EHCI & disable its interrupts in any case
+	 */
+	val = readl(op_reg_base + EHCI_USBSTS);
+	if ((val & EHCI_USBSTS_HALTED) == 0) {
+		val = readl(op_reg_base + EHCI_USBCMD);
+		val &= ~EHCI_USBCMD_RUN;
+		writel(val, op_reg_base + EHCI_USBCMD);
+
+		wait_time = 2000;
+		delta = 10;
+		do {
+			writel(0x3f, op_reg_base + EHCI_USBSTS);
+			usb_handoff_udelay(delta);
+			wait_time -= delta;
+			val = readl(op_reg_base + EHCI_USBSTS);
+			if ((val == ~(u32)0) || (val & EHCI_USBSTS_HALTED))
+				break;
+		} while (wait_time > 0);
+	}
+	writel(0, op_reg_base + EHCI_USBINTR);
+	writel(0x3f, op_reg_base + EHCI_USBSTS);
+}
+
+/*
+ * handshake - spin reading a register until handshake completes
+ * @ptr: address of hc register to be read
+ * @mask: bits to look at in result of read
+ * @done: value of those bits when handshake succeeds
+ * @wait_usec: timeout in microseconds
+ * @delay_usec: delay in microseconds to wait between polling
+ *
+ * Polls a register every delay_usec microseconds.
+ * Returns 0 when the mask bits have the value done.
+ * Returns -ETIMEDOUT if this condition is not true after
+ * wait_usec microseconds have passed.
+ */
+static int handshake(void __iomem *ptr, u32 mask, u32 done,
+		int wait_usec, int delay_usec)
+{
+	u32	result;
+
+	do {
+		result = readl(ptr);
+		result &= mask;
+		if (result == done)
+			return 0;
+		usb_handoff_udelay(delay_usec);
+		wait_usec -= delay_usec;
+	} while (wait_usec > 0);
+	return -ETIMEDOUT;
+}
+
+/**
+ * PCI Quirks for xHCI.
+ *
+ * Takes care of the handoff between the Pre-OS (i.e. BIOS) and the OS.
+ * It signals to the BIOS that the OS wants control of the host controller,
+ * and then waits 5 seconds for the BIOS to hand over control.
+ * If we timeout, assume the BIOS is broken and take control anyway.
+ */
+static inline void
+__usb_handoff_xhci(struct pci_dev *pdev, void __iomem *base)
+{
+	int ext_cap_offset;
+	void __iomem *op_reg_base;
+	u32 val;
+	int timeout;
+
+	/*
+	 * Find the Legacy Support Capability register -
+	 * this is optional for xHCI host controllers.
+	 */
+	ext_cap_offset = xhci_find_next_cap_offset(base, XHCI_HCC_PARAMS_OFFSET);
+	do {
+		if (!ext_cap_offset)
+			/* We've reached the end of the extended capabilities */
+			goto hc_init;
+		val = readl(base + ext_cap_offset);
+		if (XHCI_EXT_CAPS_ID(val) == XHCI_EXT_CAPS_LEGACY)
+			break;
+		ext_cap_offset = xhci_find_next_cap_offset(base, ext_cap_offset);
+	} while (1);
+
+	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
+	if (val & XHCI_HC_BIOS_OWNED) {
+		writel(val & XHCI_HC_OS_OWNED, base + ext_cap_offset);
+
+		/* Wait for 5 seconds with 10 microsecond polling interval */
+		timeout = handshake(base + ext_cap_offset, XHCI_HC_BIOS_OWNED,
+				0, 5000, 10);
+
+		/* Assume a buggy BIOS and take HC ownership anyway */
+		if (timeout) {
+			dev_warn(&pdev->dev,
+				 "xHCI BIOS handoff failed (BIOS bug ?) %08x\n",
+						val);
+			writel(val & ~XHCI_HC_BIOS_OWNED, base + ext_cap_offset);
+		}
+	}
+
+	/* Disable any BIOS SMIs */
+	writel(XHCI_LEGACY_DISABLE_SMI,
+			base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
+
+hc_init:
+	op_reg_base = base + XHCI_HC_LENGTH(readl(base));
+
+	/* Wait for the host controller to be ready before writing any
+	 * operational or runtime registers.  Wait 5 seconds and no more.
+	 */
+	timeout = handshake(op_reg_base + XHCI_STS_OFFSET, XHCI_STS_CNR, 0,
+			5000, 10);
+	/* Assume a buggy HC and start HC initialization anyway */
+	if (timeout) {
+		val = readl(op_reg_base + XHCI_STS_OFFSET);
+		dev_warn(&pdev->dev,
+			"xHCI HW not ready after 5 sec (HC bug?) status = 0x%x\n",
+				val);
+	}
+
+	/* Send the halt and disable interrupts command */
+	val = readl(op_reg_base + XHCI_CMD_OFFSET);
+	val &= ~(XHCI_CMD_RUN | XHCI_IRQS);
+	writel(val, op_reg_base + XHCI_CMD_OFFSET);
+
+	/* Wait for the HC to halt - poll every 125 usec (one microframe). */
+	timeout = handshake(op_reg_base + XHCI_STS_OFFSET, XHCI_STS_HALT, 1,
+			XHCI_MAX_HALT_USEC, 125);
+	if (timeout) {
+		val = readl(op_reg_base + XHCI_STS_OFFSET);
+		dev_warn(&pdev->dev,
+				"xHCI HW did not halt within %d usec status = 0x%x\n",
+				 XHCI_MAX_HALT_USEC, val);
+	}
+}
