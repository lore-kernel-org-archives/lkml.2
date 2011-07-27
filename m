Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1G0WId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:08:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:36473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1G0VsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826285"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, david-b@pacbell.net,
        pali.rohar@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [20/99] OHCI: work around for nVidia shutdown problem
Message-Id: <20110727214818.A94E22403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

[ upstream commit 5f528de0ef9b3e092e276d95930830b847b33dc4 ]
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b upstream.

This patch (as1417) fixes a problem affecting some (or all) nVidia
chipsets.  When the computer is shut down, the OHCI controllers
continue to power the USB buses and evidently they drive a Reset
signal out all their ports.  This prevents attached devices from going
to low power.  Mouse LEDs stay on, for example, which is disconcerting
for users and a drain on laptop batteries.

The fix involves leaving each OHCI controller in the OPERATIONAL state
during system shutdown rather than putting it in the RESET state.
Although this nominally means the controller is running, in fact it's
not doing very much since all the schedules are all disabled.  However
there is ongoing DMA to the Host Controller Communications Area, so
the patch also disables the bus-master capability of all PCI USB
controllers after the shutdown routine runs.

The fix is applied only to nVidia-based PCI OHCI controllers, so it
shouldn't cause problems on systems using other hardware.  As an added
safety measure, in case the kernel encounters one of these running
controllers during boot, the patch changes quirk_usb_handoff_ohci()
(which runs early on during PCI discovery) to reset the controller
before anything bad can happen.

Reported-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: David Brownell <david-b@pacbell.net>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Index: linux-2.6.35.y/drivers/usb/core/hcd-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/hcd-pci.c
+++ linux-2.6.35.y/drivers/usb/core/hcd-pci.c
@@ -317,8 +317,10 @@ void usb_hcd_pci_shutdown(struct pci_dev
 	if (!hcd)
 		return;
 
-	if (hcd->driver->shutdown)
+	if (hcd->driver->shutdown) {
 		hcd->driver->shutdown(hcd);
+		pci_disable_device(dev);
+	}
 }
 EXPORT_SYMBOL_GPL(usb_hcd_pci_shutdown);
 
Index: linux-2.6.35.y/drivers/usb/host/ohci-hcd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ohci-hcd.c
+++ linux-2.6.35.y/drivers/usb/host/ohci-hcd.c
@@ -398,7 +398,14 @@ ohci_shutdown (struct usb_hcd *hcd)
 
 	ohci = hcd_to_ohci (hcd);
 	ohci_writel (ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
-	ohci_usb_reset (ohci);
+	ohci->hc_control = ohci_readl(ohci, &ohci->regs->control);
+
+	/* If the SHUTDOWN quirk is set, don't put the controller in RESET */
+	ohci->hc_control &= (ohci->flags & OHCI_QUIRK_SHUTDOWN ?
+			OHCI_CTRL_RWC | OHCI_CTRL_HCFS :
+			OHCI_CTRL_RWC);
+	ohci_writel(ohci, ohci->hc_control, &ohci->regs->control);
+
 	/* flush the writes */
 	(void) ohci_readl (ohci, &ohci->regs->control);
 }
Index: linux-2.6.35.y/drivers/usb/host/ohci-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ohci-pci.c
+++ linux-2.6.35.y/drivers/usb/host/ohci-pci.c
@@ -201,6 +201,20 @@ static int ohci_quirk_amd700(struct usb_
 	return 0;
 }
 
+/* nVidia controllers continue to drive Reset signalling on the bus
+ * even after system shutdown, wasting power.  This flag tells the
+ * shutdown routine to leave the controller OPERATIONAL instead of RESET.
+ */
+static int ohci_quirk_nvidia_shutdown(struct usb_hcd *hcd)
+{
+	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
+
+	ohci->flags |= OHCI_QUIRK_SHUTDOWN;
+	ohci_dbg(ohci, "enabled nVidia shutdown quirk\n");
+
+	return 0;
+}
+
 /*
  * The hardware normally enables the A-link power management feature, which
  * lets the system lower the power consumption in idle states.
@@ -332,6 +346,10 @@ static const struct pci_device_id ohci_p
 		PCI_DEVICE(PCI_VENDOR_ID_ATI, 0x4399),
 		.driver_data = (unsigned long)ohci_quirk_amd700,
 	},
+	{
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID),
+		.driver_data = (unsigned long) ohci_quirk_nvidia_shutdown,
+	},
 
 	/* FIXME for some of the early AMD 760 southbridges, OHCI
 	 * won't work at all.  blacklist them.
Index: linux-2.6.35.y/drivers/usb/host/ohci.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ohci.h
+++ linux-2.6.35.y/drivers/usb/host/ohci.h
@@ -403,6 +403,7 @@ struct ohci_hcd {
 #define	OHCI_QUIRK_HUB_POWER	0x100			/* distrust firmware power/oc setup */
 #define	OHCI_QUIRK_AMD_ISO	0x200			/* ISO transfers*/
 #define	OHCI_QUIRK_AMD_PREFETCH	0x400			/* pre-fetch for ISO transfer */
+#define	OHCI_QUIRK_SHUTDOWN	0x800			/* nVidia power bug */
 	// there are also chip quirks/bugs in init logic
 
 	struct work_struct	nec_work;	/* Worker for NEC quirk */
Index: linux-2.6.35.y/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6.35.y/drivers/usb/host/pci-quirks.c
@@ -169,6 +169,7 @@ static int __devinit mmio_resource_enabl
 static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
+	u32 control;
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
@@ -177,10 +178,14 @@ static void __devinit quirk_usb_handoff_
 	if (base == NULL)
 		return;
 
+	control = readl(base + OHCI_CONTROL);
+
 /* On PA-RISC, PDC can leave IR set incorrectly; ignore it there. */
-#ifndef __hppa__
-{
-	u32 control = readl(base + OHCI_CONTROL);
+#ifdef __hppa__
+#define	OHCI_CTRL_MASK		(OHCI_CTRL_RWC | OHCI_CTRL_IR)
+#else
+#define	OHCI_CTRL_MASK		OHCI_CTRL_RWC
+
 	if (control & OHCI_CTRL_IR) {
 		int wait_time = 500; /* arbitrary; 5 seconds */
 		writel(OHCI_INTR_OC, base + OHCI_INTRENABLE);
@@ -194,13 +199,12 @@ static void __devinit quirk_usb_handoff_
 			dev_warn(&pdev->dev, "OHCI: BIOS handoff failed"
 					" (BIOS bug?) %08x\n",
 					readl(base + OHCI_CONTROL));
-
-		/* reset controller, preserving RWC */
-		writel(control & OHCI_CTRL_RWC, base + OHCI_CONTROL);
 	}
-}
 #endif
 
+	/* reset controller, preserving RWC (and possibly IR) */
+	writel(control & OHCI_CTRL_MASK, base + OHCI_CONTROL);
+
 	/*
 	 * disable interrupts
 	 */
