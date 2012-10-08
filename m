Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2JHNNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:13:13 -0400
Received: from zmc.proxad.net ([212.27.53.206]:32780 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab2JHNNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:13:08 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/32 v2] USB: OHCI: remove ohci-pcc-soc driver.
Date: Mon,  8 Oct 2012 15:11:16 +0200
Message-Id: <1349701906-16481-3-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349701906-16481-1-git-send-email-florian@openwrt.org>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is not registered by any in-tree users, and if really needed by
some out of tree user, the same functionnality can be restored using the
ohci-platform driver using the following platform_data parameters:
	big_endian_desc = 1
	big_endian_mmio = 1
	no_big_frame_no = 1

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since v1:
- removed USB_OHCI_HCD_PPC_SOC Kconfig symbol
- rebased against greg's latest usb-next

 drivers/usb/host/Kconfig        |   10 --
 drivers/usb/host/ohci-hcd.c     |    5 -
 drivers/usb/host/ohci-ppc-soc.c |  216 ---------------------------------------
 3 files changed, 231 deletions(-)
 delete mode 100644 drivers/usb/host/ohci-ppc-soc.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3f1431d..e6b64f6 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -333,16 +333,6 @@ config USB_OHCI_ATH79
 	  Enables support for the built-in OHCI controller present on the
 	  Atheros AR71XX/AR7240 SoCs.
 
-config USB_OHCI_HCD_PPC_SOC
-	bool "OHCI support for on-chip PPC USB controller"
-	depends on USB_OHCI_HCD && (STB03xxx || PPC_MPC52xx)
-	default y
-	select USB_OHCI_BIG_ENDIAN_DESC
-	select USB_OHCI_BIG_ENDIAN_MMIO
-	---help---
-	  Enables support for the USB controller on the MPC52xx or
-	  STB03xxx processor chip.  If unsure, say Y.
-
 config USB_OHCI_HCD_PPC_OF_BE
 	bool "OHCI support for OF platform bus (big endian)"
 	depends on USB_OHCI_HCD && PPC_OF
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 4a1d64d..fd97801 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1039,11 +1039,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_hcd_pnx8550_driver
 #endif
 
-#ifdef CONFIG_USB_OHCI_HCD_PPC_SOC
-#include "ohci-ppc-soc.c"
-#define PLATFORM_DRIVER		ohci_hcd_ppc_soc_driver
-#endif
-
 #ifdef CONFIG_ARCH_AT91
 #include "ohci-at91.c"
 #define PLATFORM_DRIVER		ohci_hcd_at91_driver
diff --git a/drivers/usb/host/ohci-ppc-soc.c b/drivers/usb/host/ohci-ppc-soc.c
deleted file mode 100644
index 185c39e..0000000
--- a/drivers/usb/host/ohci-ppc-soc.c
+++ /dev/null
@@ -1,216 +0,0 @@
-/*
- * OHCI HCD (Host Controller Driver) for USB.
- *
- * (C) Copyright 1999 Roman Weissgaerber <weissg@vienna.at>
- * (C) Copyright 2000-2002 David Brownell <dbrownell@users.sourceforge.net>
- * (C) Copyright 2002 Hewlett-Packard Company
- * (C) Copyright 2003-2005 MontaVista Software Inc.
- *
- * Bus Glue for PPC On-Chip OHCI driver
- * Tested on Freescale MPC5200 and IBM STB04xxx
- *
- * Modified by Dale Farnsworth <dale@farnsworth.org> from ohci-sa1111.c
- *
- * This file is licenced under the GPL.
- */
-
-#include <linux/platform_device.h>
-#include <linux/signal.h>
-
-/* configure so an HC device and id are always provided */
-/* always called with process context; sleeping is OK */
-
-/**
- * usb_hcd_ppc_soc_probe - initialize On-Chip HCDs
- * Context: !in_interrupt()
- *
- * Allocates basic resources for this USB host controller.
- *
- * Store this function in the HCD's struct pci_driver as probe().
- */
-static int usb_hcd_ppc_soc_probe(const struct hc_driver *driver,
-			  struct platform_device *pdev)
-{
-	int retval;
-	struct usb_hcd *hcd;
-	struct ohci_hcd	*ohci;
-	struct resource *res;
-	int irq;
-
-	pr_debug("initializing PPC-SOC USB Controller\n");
-
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		pr_debug("%s: no irq\n", __FILE__);
-		return -ENODEV;
-	}
-	irq = res->start;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		pr_debug("%s: no reg addr\n", __FILE__);
-		return -ENODEV;
-	}
-
-	hcd = usb_create_hcd(driver, &pdev->dev, "PPC-SOC USB");
-	if (!hcd)
-		return -ENOMEM;
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_debug("%s: request_mem_region failed\n", __FILE__);
-		retval = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		pr_debug("%s: ioremap failed\n", __FILE__);
-		retval = -ENOMEM;
-		goto err2;
-	}
-
-	ohci = hcd_to_ohci(hcd);
-	ohci->flags |= OHCI_QUIRK_BE_MMIO | OHCI_QUIRK_BE_DESC;
-
-#ifdef CONFIG_PPC_MPC52xx
-	/* MPC52xx doesn't need frame_no shift */
-	ohci->flags |= OHCI_QUIRK_FRAME_NO;
-#endif
-	ohci_hcd_init(ohci);
-
-	retval = usb_add_hcd(hcd, irq, 0);
-	if (retval == 0)
-		return retval;
-
-	pr_debug("Removing PPC-SOC USB Controller\n");
-
-	iounmap(hcd->regs);
- err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
- err1:
-	usb_put_hcd(hcd);
-	return retval;
-}
-
-
-/* may be called without controller electrically present */
-/* may be called with controller, bus, and devices active */
-
-/**
- * usb_hcd_ppc_soc_remove - shutdown processing for On-Chip HCDs
- * @pdev: USB Host Controller being removed
- * Context: !in_interrupt()
- *
- * Reverses the effect of usb_hcd_ppc_soc_probe().
- * It is always called from a thread
- * context, normally "rmmod", "apmd", or something similar.
- *
- */
-static void usb_hcd_ppc_soc_remove(struct usb_hcd *hcd,
-		struct platform_device *pdev)
-{
-	usb_remove_hcd(hcd);
-
-	pr_debug("stopping PPC-SOC USB Controller\n");
-
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	usb_put_hcd(hcd);
-}
-
-static int __devinit
-ohci_ppc_soc_start(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-	int		ret;
-
-	if ((ret = ohci_init(ohci)) < 0)
-		return ret;
-
-	if ((ret = ohci_run(ohci)) < 0) {
-		dev_err(hcd->self.controller, "can't start %s\n",
-			hcd->self.bus_name);
-		ohci_stop(hcd);
-		return ret;
-	}
-
-	return 0;
-}
-
-static const struct hc_driver ohci_ppc_soc_hc_driver = {
-	.description =		hcd_name,
-	.hcd_priv_size =	sizeof(struct ohci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq =			ohci_irq,
-	.flags =		HCD_USB11 | HCD_MEMORY,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.start =		ohci_ppc_soc_start,
-	.stop =			ohci_stop,
-	.shutdown =		ohci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue =		ohci_urb_enqueue,
-	.urb_dequeue =		ohci_urb_dequeue,
-	.endpoint_disable =	ohci_endpoint_disable,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number =	ohci_get_frame,
-
-	/*
-	 * root hub support
-	 */
-	.hub_status_data =	ohci_hub_status_data,
-	.hub_control =		ohci_hub_control,
-#ifdef	CONFIG_PM
-	.bus_suspend =		ohci_bus_suspend,
-	.bus_resume =		ohci_bus_resume,
-#endif
-	.start_port_reset =	ohci_start_port_reset,
-};
-
-static int ohci_hcd_ppc_soc_drv_probe(struct platform_device *pdev)
-{
-	int ret;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	ret = usb_hcd_ppc_soc_probe(&ohci_ppc_soc_hc_driver, pdev);
-	return ret;
-}
-
-static int ohci_hcd_ppc_soc_drv_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_hcd_ppc_soc_remove(hcd, pdev);
-	return 0;
-}
-
-static struct platform_driver ohci_hcd_ppc_soc_driver = {
-	.probe		= ohci_hcd_ppc_soc_drv_probe,
-	.remove		= ohci_hcd_ppc_soc_drv_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-#ifdef	CONFIG_PM
-	/*.suspend	= ohci_hcd_ppc_soc_drv_suspend,*/
-	/*.resume	= ohci_hcd_ppc_soc_drv_resume,*/
-#endif
-	.driver		= {
-		.name	= "ppc-soc-ohci",
-		.owner	= THIS_MODULE,
-	},
-};
-
-MODULE_ALIAS("platform:ppc-soc-ohci");
-- 
1.7.9.5

