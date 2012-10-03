Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab2JCPQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:16:21 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36963 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab2JCPN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:58 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/25] USB: ehci: remove IXP4xx EHCI driver
Date: Wed,  3 Oct 2012 17:02:56 +0200
Message-Id: <1349276601-8371-2-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is not registered by any in-tree user. If needed it can easily
be registered using the ehci-platform driver with caps_offset set to 0x100.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ehci-hcd.c    |    5 --
 drivers/usb/host/ehci-ixp4xx.c |  139 ----------------------------------------
 2 files changed, 144 deletions(-)
 delete mode 100644 drivers/usb/host/ehci-ixp4xx.c

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 6bf6c42..442f774 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1249,11 +1249,6 @@ MODULE_LICENSE ("GPL");
 #define	PLATFORM_DRIVER		ehci_orion_driver
 #endif
 
-#ifdef CONFIG_ARCH_IXP4XX
-#include "ehci-ixp4xx.c"
-#define	PLATFORM_DRIVER		ixp4xx_ehci_driver
-#endif
-
 #ifdef CONFIG_USB_W90X900_EHCI
 #include "ehci-w90x900.c"
 #define	PLATFORM_DRIVER		ehci_hcd_w90x900_driver
diff --git a/drivers/usb/host/ehci-ixp4xx.c b/drivers/usb/host/ehci-ixp4xx.c
deleted file mode 100644
index f224c0a..0000000
--- a/drivers/usb/host/ehci-ixp4xx.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * IXP4XX EHCI Host Controller Driver
- *
- * Author: Vladimir Barinov <vbarinov@embeddedalley.com>
- *
- * Based on "ehci-fsl.c" by Randy Vinson <rvinson@mvista.com>
- *
- * 2007 (c) MontaVista Software, Inc. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-
-#include <linux/platform_device.h>
-
-static int ixp4xx_ehci_init(struct usb_hcd *hcd)
-{
-	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
-	int retval = 0;
-
-	ehci->big_endian_desc = 1;
-	ehci->big_endian_mmio = 1;
-
-	ehci->caps = hcd->regs + 0x100;
-
-	hcd->has_tt = 1;
-
-	retval = ehci_setup(hcd);
-	if (retval)
-		return retval;
-
-	ehci_port_power(ehci, 0);
-
-	return retval;
-}
-
-static const struct hc_driver ixp4xx_ehci_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "IXP4XX EHCI Host Controller",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2,
-	.reset			= ixp4xx_ehci_init,
-	.start			= ehci_run,
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
-	.get_frame_number	= ehci_get_frame,
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-#if defined(CONFIG_PM)
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-#endif
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
-};
-
-static int ixp4xx_ehci_probe(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd;
-	const struct hc_driver *driver = &ixp4xx_ehci_hc_driver;
-	struct resource *res;
-	int irq;
-	int retval;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(&pdev->dev,
-			"Found HC with no IRQ. Check %s setup!\n",
-			dev_name(&pdev->dev));
-		return -ENODEV;
-	}
-	irq = res->start;
-
-	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
-	if (!hcd) {
-		retval = -ENOMEM;
-		goto fail_create_hcd;
-	}
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev,
-			"Found HC with no register addr. Check %s setup!\n",
-			dev_name(&pdev->dev));
-		retval = -ENODEV;
-		goto fail_request_resource;
-	}
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (hcd->regs == NULL) {
-		dev_dbg(&pdev->dev, "error mapping memory\n");
-		retval = -EFAULT;
-		goto fail_request_resource;
-	}
-
-	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (retval)
-		goto fail_request_resource;
-
-	return retval;
-
-fail_request_resource:
-	usb_put_hcd(hcd);
-fail_create_hcd:
-	dev_err(&pdev->dev, "init %s fail, %d\n", dev_name(&pdev->dev), retval);
-	return retval;
-}
-
-static int ixp4xx_ehci_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-	usb_put_hcd(hcd);
-
-	return 0;
-}
-
-MODULE_ALIAS("platform:ixp4xx-ehci");
-
-static struct platform_driver ixp4xx_ehci_driver = {
-	.probe = ixp4xx_ehci_probe,
-	.remove = ixp4xx_ehci_remove,
-	.driver = {
-		.name = "ixp4xx-ehci",
-	},
-};
-- 
1.7.9.5

