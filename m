Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab2JCPVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:21:20 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36931 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab2JCPNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:51 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/25] USB: ohci: remove Alchemy OHCI platform driver.
Date: Wed,  3 Oct 2012 17:03:21 +0200
Message-Id: <1349276601-8371-27-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users have been converted to use the OHCI platform driver instead.
The driver was also doing quirky things with the internal OHCI hcd
structure during suspend/resume, work that is taken care of by the
core OHCI code in ohci-hub.c.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ohci-au1xxx.c |  234 ----------------------------------------
 drivers/usb/host/ohci-hcd.c    |    5 -
 2 files changed, 239 deletions(-)
 delete mode 100644 drivers/usb/host/ohci-au1xxx.c

diff --git a/drivers/usb/host/ohci-au1xxx.c b/drivers/usb/host/ohci-au1xxx.c
deleted file mode 100644
index c611699..0000000
--- a/drivers/usb/host/ohci-au1xxx.c
+++ /dev/null
@@ -1,234 +0,0 @@
-/*
- * OHCI HCD (Host Controller Driver) for USB.
- *
- * (C) Copyright 1999 Roman Weissgaerber <weissg@vienna.at>
- * (C) Copyright 2000-2002 David Brownell <dbrownell@users.sourceforge.net>
- * (C) Copyright 2002 Hewlett-Packard Company
- *
- * Bus Glue for AMD Alchemy Au1xxx
- *
- * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Russell King et al.
- *
- * Modified for LH7A404 from ohci-sa1111.c
- *  by Durgesh Pattamatta <pattamattad@sharpsec.com>
- * Modified for AMD Alchemy Au1xxx
- *  by Matt Porter <mporter@kernel.crashing.org>
- *
- * This file is licenced under the GPL.
- */
-
-#include <linux/platform_device.h>
-#include <linux/signal.h>
-
-#include <asm/mach-au1x00/au1000.h>
-
-
-extern int usb_disabled(void);
-
-static int __devinit ohci_au1xxx_start(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-	int ret;
-
-	ohci_dbg(ohci, "ohci_au1xxx_start, ohci:%p", ohci);
-
-	if ((ret = ohci_init(ohci)) < 0)
-		return ret;
-
-	if ((ret = ohci_run(ohci)) < 0) {
-		dev_err(hcd->self.controller, "can't start %s",
-			hcd->self.bus_name);
-		ohci_stop(hcd);
-		return ret;
-	}
-
-	return 0;
-}
-
-static const struct hc_driver ohci_au1xxx_hc_driver = {
-	.description =		hcd_name,
-	.product_desc =		"Au1xxx OHCI",
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
-	.start =		ohci_au1xxx_start,
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
-static int ohci_hcd_au1xxx_drv_probe(struct platform_device *pdev)
-{
-	int ret, unit;
-	struct usb_hcd *hcd;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	if (pdev->resource[1].flags != IORESOURCE_IRQ) {
-		pr_debug("resource[1] is not IORESOURCE_IRQ\n");
-		return -ENOMEM;
-	}
-
-	hcd = usb_create_hcd(&ohci_au1xxx_hc_driver, &pdev->dev, "au1xxx");
-	if (!hcd)
-		return -ENOMEM;
-
-	hcd->rsrc_start = pdev->resource[0].start;
-	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_debug("request_mem_region failed\n");
-		ret = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		pr_debug("ioremap failed\n");
-		ret = -ENOMEM;
-		goto err2;
-	}
-
-	unit = (hcd->rsrc_start == AU1300_USB_OHCI1_PHYS_ADDR) ?
-			ALCHEMY_USB_OHCI1 : ALCHEMY_USB_OHCI0;
-	if (alchemy_usb_control(unit, 1)) {
-		printk(KERN_INFO "%s: controller init failed!\n", pdev->name);
-		ret = -ENODEV;
-		goto err3;
-	}
-
-	ohci_hcd_init(hcd_to_ohci(hcd));
-
-	ret = usb_add_hcd(hcd, pdev->resource[1].start,
-			  IRQF_SHARED);
-	if (ret == 0) {
-		platform_set_drvdata(pdev, hcd);
-		return ret;
-	}
-
-	alchemy_usb_control(unit, 0);
-err3:
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err1:
-	usb_put_hcd(hcd);
-	return ret;
-}
-
-static int ohci_hcd_au1xxx_drv_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-	int unit;
-
-	unit = (hcd->rsrc_start == AU1300_USB_OHCI1_PHYS_ADDR) ?
-			ALCHEMY_USB_OHCI1 : ALCHEMY_USB_OHCI0;
-	usb_remove_hcd(hcd);
-	alchemy_usb_control(unit, 0);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	usb_put_hcd(hcd);
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int ohci_hcd_au1xxx_drv_suspend(struct device *dev)
-{
-	struct usb_hcd *hcd = dev_get_drvdata(dev);
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-	unsigned long flags;
-	int rc;
-
-	rc = 0;
-
-	/* Root hub was already suspended. Disable irq emission and
-	 * mark HW unaccessible, bail out if RH has been resumed. Use
-	 * the spinlock to properly synchronize with possible pending
-	 * RH suspend or resume activity.
-	 */
-	spin_lock_irqsave(&ohci->lock, flags);
-	if (ohci->rh_state != OHCI_RH_SUSPENDED) {
-		rc = -EINVAL;
-		goto bail;
-	}
-	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
-	(void)ohci_readl(ohci, &ohci->regs->intrdisable);
-
-	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-
-	alchemy_usb_control(ALCHEMY_USB_OHCI0, 0);
-bail:
-	spin_unlock_irqrestore(&ohci->lock, flags);
-
-	return rc;
-}
-
-static int ohci_hcd_au1xxx_drv_resume(struct device *dev)
-{
-	struct usb_hcd *hcd = dev_get_drvdata(dev);
-
-	alchemy_usb_control(ALCHEMY_USB_OHCI0, 1);
-
-	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-	ohci_finish_controller_resume(hcd);
-
-	return 0;
-}
-
-static const struct dev_pm_ops au1xxx_ohci_pmops = {
-	.suspend	= ohci_hcd_au1xxx_drv_suspend,
-	.resume		= ohci_hcd_au1xxx_drv_resume,
-};
-
-#define AU1XXX_OHCI_PMOPS &au1xxx_ohci_pmops
-
-#else
-#define AU1XXX_OHCI_PMOPS NULL
-#endif
-
-static struct platform_driver ohci_hcd_au1xxx_driver = {
-	.probe		= ohci_hcd_au1xxx_drv_probe,
-	.remove		= ohci_hcd_au1xxx_drv_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-	.driver		= {
-		.name	= "au1xxx-ohci",
-		.owner	= THIS_MODULE,
-		.pm	= AU1XXX_OHCI_PMOPS,
-	},
-};
-
-MODULE_ALIAS("platform:au1xxx-ohci");
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 028f60d..f0084c8 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1029,11 +1029,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_hcd_ep93xx_driver
 #endif
 
-#ifdef CONFIG_MIPS_ALCHEMY
-#include "ohci-au1xxx.c"
-#define PLATFORM_DRIVER		ohci_hcd_au1xxx_driver
-#endif
-
 #ifdef CONFIG_USB_OHCI_HCD_PPC_SOC
 #include "ohci-ppc-soc.c"
 #define PLATFORM_DRIVER		ohci_hcd_ppc_soc_driver
-- 
1.7.9.5

