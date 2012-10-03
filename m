Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab2JCPUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:20:32 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36935 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab2JCPNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:52 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/25] USB: ehci: remove CNS3xxx EHCI platform driver
Date: Wed,  3 Oct 2012 17:03:07 +0200
Message-Id: <1349276601-8371-13-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The users have been converted to use the ehci platform driver instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig        |    6 +-
 drivers/usb/host/ehci-cns3xxx.c |  155 ---------------------------------------
 drivers/usb/host/ehci-hcd.c     |   10 ---
 3 files changed, 5 insertions(+), 166 deletions(-)
 delete mode 100644 drivers/usb/host/ehci-cns3xxx.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 18cf37f..0754dd1 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -215,9 +215,13 @@ config USB_W90X900_EHCI
 		Enables support for the W90X900 USB controller
 
 config USB_CNS3XXX_EHCI
-	bool "Cavium CNS3XXX EHCI Module"
+	bool "Cavium CNS3XXX EHCI Module (DEPRECATED)"
 	depends on USB_EHCI_HCD && ARCH_CNS3XXX
+	select USB_EHCI_HCD_PLATFORM
 	---help---
+	  This option is deprecated now and the driver was removed, use
+	  USB_EHCI_HCD_PLATFORM instead.
+
 	  Enable support for the CNS3XXX SOC's on-chip EHCI controller.
 	  It is needed for high-speed (480Mbit/sec) USB 2.0 device
 	  support.
diff --git a/drivers/usb/host/ehci-cns3xxx.c b/drivers/usb/host/ehci-cns3xxx.c
deleted file mode 100644
index d91708d..0000000
--- a/drivers/usb/host/ehci-cns3xxx.c
+++ /dev/null
@@ -1,155 +0,0 @@
-/*
- * Copyright 2008 Cavium Networks
- *
- * This file is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, Version 2, as
- * published by the Free Software Foundation.
- */
-
-#include <linux/platform_device.h>
-#include <linux/atomic.h>
-#include <mach/cns3xxx.h>
-#include <mach/pm.h>
-
-static int cns3xxx_ehci_init(struct usb_hcd *hcd)
-{
-	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
-	int retval;
-
-	/*
-	 * EHCI and OHCI share the same clock and power,
-	 * resetting twice would cause the 1st controller been reset.
-	 * Therefore only do power up  at the first up device, and
-	 * power down at the last down device.
-	 *
-	 * Set USB AHB INCR length to 16
-	 */
-	if (atomic_inc_return(&usb_pwr_ref) == 1) {
-		cns3xxx_pwr_power_up(1 << PM_PLL_HM_PD_CTRL_REG_OFFSET_PLL_USB);
-		cns3xxx_pwr_clk_en(1 << PM_CLK_GATE_REG_OFFSET_USB_HOST);
-		cns3xxx_pwr_soft_rst(1 << PM_SOFT_RST_REG_OFFST_USB_HOST);
-		__raw_writel((__raw_readl(MISC_CHIP_CONFIG_REG) | (0X2 << 24)),
-			MISC_CHIP_CONFIG_REG);
-	}
-
-	ehci->caps = hcd->regs;
-
-	hcd->has_tt = 0;
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
-static const struct hc_driver cns3xxx_ehci_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "CNS3XXX EHCI Host Controller",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2,
-	.reset			= cns3xxx_ehci_init,
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
-#ifdef CONFIG_PM
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-#endif
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
-};
-
-static int cns3xxx_ehci_probe(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct usb_hcd *hcd;
-	const struct hc_driver *driver = &cns3xxx_ehci_hc_driver;
-	struct resource *res;
-	int irq;
-	int retval;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(dev, "Found HC with no IRQ.\n");
-		return -ENODEV;
-	}
-	irq = res->start;
-
-	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
-	if (!hcd)
-		return -ENOMEM;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "Found HC with no register addr.\n");
-		retval = -ENODEV;
-		goto err1;
-	}
-
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (hcd->regs == NULL) {
-		dev_dbg(dev, "error mapping memory\n");
-		retval = -EFAULT;
-		goto err1;
-	}
-
-	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (retval == 0)
-		return retval;
-
-err1:
-	usb_put_hcd(hcd);
-
-	return retval;
-}
-
-static int cns3xxx_ehci_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-
-	/*
-	 * EHCI and OHCI share the same clock and power,
-	 * resetting twice would cause the 1st controller been reset.
-	 * Therefore only do power up  at the first up device, and
-	 * power down at the last down device.
-	 */
-	if (atomic_dec_return(&usb_pwr_ref) == 0)
-		cns3xxx_pwr_clk_dis(1 << PM_CLK_GATE_REG_OFFSET_USB_HOST);
-
-	usb_put_hcd(hcd);
-
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-MODULE_ALIAS("platform:cns3xxx-ehci");
-
-static struct platform_driver cns3xxx_ehci_driver = {
-	.probe = cns3xxx_ehci_probe,
-	.remove = cns3xxx_ehci_remove,
-	.driver = {
-		.name = "cns3xxx-ehci",
-	},
-};
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index a954a95..57b7bd0 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1254,16 +1254,6 @@ MODULE_LICENSE ("GPL");
 #define	PLATFORM_DRIVER		ehci_atmel_driver
 #endif
 
-#ifdef CONFIG_USB_OCTEON_EHCI
-#include "ehci-octeon.c"
-#define PLATFORM_DRIVER		ehci_octeon_driver
-#endif
-
-#ifdef CONFIG_USB_CNS3XXX_EHCI
-#include "ehci-cns3xxx.c"
-#define PLATFORM_DRIVER		cns3xxx_ehci_driver
-#endif
-
 #ifdef CONFIG_ARCH_VT8500
 #include "ehci-vt8500.c"
 #define	PLATFORM_DRIVER		vt8500_ehci_driver
-- 
1.7.9.5

