Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab2JCPSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:18:55 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36944 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab2JCPNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:55 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/25] USB: ehci: remove Netlogic XLS EHCI driver
Date: Wed,  3 Oct 2012 17:03:00 +0200
Message-Id: <1349276601-8371-6-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform code has been migrated to use the ehci-platform driver.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ehci-hcd.c |    5 --
 drivers/usb/host/ehci-xls.c |  142 -------------------------------------------
 2 files changed, 147 deletions(-)
 delete mode 100644 drivers/usb/host/ehci-xls.c

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 2f517d9..f2a9982 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1309,11 +1309,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_grlib_driver
 #endif
 
-#ifdef CONFIG_CPU_XLR
-#include "ehci-xls.c"
-#define PLATFORM_DRIVER		ehci_xls_driver
-#endif
-
 #ifdef CONFIG_USB_EHCI_MV
 #include "ehci-mv.c"
 #define        PLATFORM_DRIVER         ehci_mv_driver
diff --git a/drivers/usb/host/ehci-xls.c b/drivers/usb/host/ehci-xls.c
deleted file mode 100644
index 8dc6a22..0000000
--- a/drivers/usb/host/ehci-xls.c
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * EHCI HCD for Netlogic XLS processors.
- *
- * (C) Copyright 2011 Netlogic Microsystems Inc.
- *
- *  Based on various ehci-*.c drivers
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive for
- * more details.
- */
-
-#include <linux/platform_device.h>
-
-static int ehci_xls_setup(struct usb_hcd *hcd)
-{
-	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
-
-	ehci->caps = hcd->regs;
-
-	return ehci_setup(hcd);
-}
-
-int ehci_xls_probe_internal(const struct hc_driver *driver,
-	struct platform_device *pdev)
-{
-	struct usb_hcd  *hcd;
-	struct resource *res;
-	int retval, irq;
-
-	/* Get our IRQ from an earlier registered Platform Resource */
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "Found HC with no IRQ. Check %s setup!\n",
-				dev_name(&pdev->dev));
-		return -ENODEV;
-	}
-
-	/* Get our Memory Handle */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Error: MMIO Handle %s setup!\n",
-				dev_name(&pdev->dev));
-		return -ENODEV;
-	}
-	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
-	if (!hcd) {
-		retval = -ENOMEM;
-		goto err1;
-	}
-
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				driver->description)) {
-		dev_dbg(&pdev->dev, "controller already in use\n");
-		retval = -EBUSY;
-		goto err2;
-	}
-	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
-
-	if (hcd->regs == NULL) {
-		dev_dbg(&pdev->dev, "error mapping memory\n");
-		retval = -EFAULT;
-		goto err3;
-	}
-
-	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (retval != 0)
-		goto err4;
-	return retval;
-
-err4:
-	iounmap(hcd->regs);
-err3:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err2:
-	usb_put_hcd(hcd);
-err1:
-	dev_err(&pdev->dev, "init %s fail, %d\n", dev_name(&pdev->dev),
-			retval);
-	return retval;
-}
-
-static struct hc_driver ehci_xls_hc_driver = {
-	.description	= hcd_name,
-	.product_desc	= "XLS EHCI Host Controller",
-	.hcd_priv_size	= sizeof(struct ehci_hcd),
-	.irq		= ehci_irq,
-	.flags		= HCD_USB2 | HCD_MEMORY,
-	.reset		= ehci_xls_setup,
-	.start		= ehci_run,
-	.stop		= ehci_stop,
-	.shutdown	= ehci_shutdown,
-
-	.urb_enqueue	= ehci_urb_enqueue,
-	.urb_dequeue	= ehci_urb_dequeue,
-	.endpoint_disable = ehci_endpoint_disable,
-	.endpoint_reset	= ehci_endpoint_reset,
-
-	.get_frame_number = ehci_get_frame,
-
-	.hub_status_data = ehci_hub_status_data,
-	.hub_control	= ehci_hub_control,
-	.bus_suspend	= ehci_bus_suspend,
-	.bus_resume	= ehci_bus_resume,
-	.relinquish_port = ehci_relinquish_port,
-	.port_handed_over = ehci_port_handed_over,
-
-	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
-};
-
-static int ehci_xls_probe(struct platform_device *pdev)
-{
-	if (usb_disabled())
-		return -ENODEV;
-
-	return ehci_xls_probe_internal(&ehci_xls_hc_driver, pdev);
-}
-
-static int ehci_xls_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	usb_put_hcd(hcd);
-	return 0;
-}
-
-MODULE_ALIAS("ehci-xls");
-
-static struct platform_driver ehci_xls_driver = {
-	.probe		= ehci_xls_probe,
-	.remove		= ehci_xls_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-	.driver		= {
-		.name = "ehci-xls",
-	},
-};
-- 
1.7.9.5

