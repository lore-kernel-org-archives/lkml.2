Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab1C3Vsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:48:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089Ab1C3VHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735068"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, david-b@pacbell.net,
        pali.rohar@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [115/275] OHCI: work around for nVidia shutdown problem
Message-Id: <20110330210554.BE1633E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

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

---
 drivers/usb/core/hcd-pci.c    |    4 +++-
 drivers/usb/host/ohci-hcd.c   |    9 ++++++++-
 drivers/usb/host/ohci-pci.c   |   18 ++++++++++++++++++
 drivers/usb/host/ohci.h       |    1 +
 drivers/usb/host/pci-quirks.c |   18 +++++++++++-------
 5 files changed, 41 insertions(+), 9 deletions(-)

Index: linux-2.6.35.y/drivers/usb/core/hcd-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/hcd-pci.c	2011-03-29 22:51:22.609144656 -0700
+++ linux-2.6.35.y/drivers/usb/core/hcd-pci.c	2011-03-29 23:03:00.575285450 -0700
@@ -317,8 +317,10 @@
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
--- linux-2.6.35.y.orig/drivers/usb/host/ohci-hcd.c	2011-03-29 22:51:22.609144656 -0700
+++ linux-2.6.35.y/drivers/usb/host/ohci-hcd.c	2011-03-29 23:03:00.576285425 -0700
@@ -398,7 +398,14 @@
 
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
--- linux-2.6.35.y.orig/drivers/usb/host/ohci-pci.c	2011-03-29 22:51:22.609144656 -0700
+++ linux-2.6.35.y/drivers/usb/host/ohci-pci.c	2011-03-29 23:03:00.577285400 -0700
@@ -201,6 +201,20 @@
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
@@ -332,6 +346,10 @@
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
--- linux-2.6.35.y.orig/drivers/usb/host/ohci.h	2011-03-29 22:51:22.610144631 -0700
+++ linux-2.6.35.y/drivers/usb/host/ohci.h	2011-03-29 23:03:00.578285374 -0700
@@ -403,6 +403,7 @@
 #define	OHCI_QUIRK_HUB_POWER	0x100			/* distrust firmware power/oc setup */
 #define	OHCI_QUIRK_AMD_ISO	0x200			/* ISO transfers*/
 #define	OHCI_QUIRK_AMD_PREFETCH	0x400			/* pre-fetch for ISO transfer */
+#define	OHCI_QUIRK_SHUTDOWN	0x800			/* nVidia power bug */
 	// there are also chip quirks/bugs in init logic
 
 	struct work_struct	nec_work;	/* Worker for NEC quirk */
Index: linux-2.6.35.y/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/pci-quirks.c	2011-03-29 22:51:22.610144631 -0700
+++ linux-2.6.35.y/drivers/usb/host/pci-quirks.c	2011-03-29 23:03:00.579285348 -0700
@@ -169,6 +169,7 @@
 static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
+	u32 control;
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
@@ -177,10 +178,14 @@
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
@@ -194,13 +199,12 @@
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
