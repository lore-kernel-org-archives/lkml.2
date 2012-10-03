Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2JCPOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:14:04 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36949 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab2JCPN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:57 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/25] USB: ohci: remove CNS3xxx OHCI platform driver
Date: Wed,  3 Oct 2012 17:03:13 +0200
Message-Id: <1349276601-8371-19-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users have been converted to use the OHCI platform driver instead.
Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig        |    6 +-
 drivers/usb/host/ohci-cns3xxx.c |  166 ---------------------------------------
 drivers/usb/host/ohci-hcd.c     |    5 --
 3 files changed, 5 insertions(+), 172 deletions(-)
 delete mode 100644 drivers/usb/host/ohci-cns3xxx.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 0754dd1..3742f73 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -410,9 +410,13 @@ config USB_OHCI_EXYNOS
 	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
 
 config USB_CNS3XXX_OHCI
-	bool "Cavium CNS3XXX OHCI Module"
+	bool "Cavium CNS3XXX OHCI Module (DEPRECATED)"
 	depends on USB_OHCI_HCD && ARCH_CNS3XXX
+	select USB_OHCI_HCD_PLATFORM
 	---help---
+	  This option is deprecated now and the driver was removed, use
+	  USB_OHCI_HCD_PLATFORM instead.
+
 	  Enable support for the CNS3XXX SOC's on-chip OHCI controller.
 	  It is needed for low-speed USB 1.0 device support.
 
diff --git a/drivers/usb/host/ohci-cns3xxx.c b/drivers/usb/host/ohci-cns3xxx.c
deleted file mode 100644
index 2c9f233..0000000
--- a/drivers/usb/host/ohci-cns3xxx.c
+++ /dev/null
@@ -1,166 +0,0 @@
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
-static int __devinit
-cns3xxx_ohci_start(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-	int ret;
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
-	ret = ohci_init(ohci);
-	if (ret < 0)
-		return ret;
-
-	ohci->num_ports = 1;
-
-	ret = ohci_run(ohci);
-	if (ret < 0) {
-		dev_err(hcd->self.controller, "can't start %s\n",
-			hcd->self.bus_name);
-		ohci_stop(hcd);
-		return ret;
-	}
-	return 0;
-}
-
-static const struct hc_driver cns3xxx_ohci_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "CNS3XXX OHCI Host controller",
-	.hcd_priv_size		= sizeof(struct ohci_hcd),
-	.irq			= ohci_irq,
-	.flags			= HCD_USB11 | HCD_MEMORY,
-	.start			= cns3xxx_ohci_start,
-	.stop			= ohci_stop,
-	.shutdown		= ohci_shutdown,
-	.urb_enqueue		= ohci_urb_enqueue,
-	.urb_dequeue		= ohci_urb_dequeue,
-	.endpoint_disable	= ohci_endpoint_disable,
-	.get_frame_number	= ohci_get_frame,
-	.hub_status_data	= ohci_hub_status_data,
-	.hub_control		= ohci_hub_control,
-#ifdef CONFIG_PM
-	.bus_suspend		= ohci_bus_suspend,
-	.bus_resume		= ohci_bus_resume,
-#endif
-	.start_port_reset	= ohci_start_port_reset,
-};
-
-static int cns3xxx_ohci_probe(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct usb_hcd *hcd;
-	const struct hc_driver *driver = &cns3xxx_ohci_hc_driver;
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
-	hcd = usb_create_hcd(driver, dev, dev_name(dev));
-	if (!hcd)
-		return -ENOMEM;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "Found HC with no register addr.\n");
-		retval = -ENODEV;
-		goto err1;
-	}
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-			driver->description)) {
-		dev_dbg(dev, "controller already in use\n");
-		retval = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		dev_dbg(dev, "error mapping memory\n");
-		retval = -EFAULT;
-		goto err2;
-	}
-
-	ohci_hcd_init(hcd_to_ohci(hcd));
-
-	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (retval == 0)
-		return retval;
-
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err1:
-	usb_put_hcd(hcd);
-	return retval;
-}
-
-static int cns3xxx_ohci_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
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
-MODULE_ALIAS("platform:cns3xxx-ohci");
-
-static struct platform_driver ohci_hcd_cns3xxx_driver = {
-	.probe = cns3xxx_ohci_probe,
-	.remove = cns3xxx_ohci_remove,
-	.driver = {
-		.name = "cns3xxx-ohci",
-	},
-};
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 17ed0a8..5648f09 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1100,11 +1100,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_hcd_tilegx_driver
 #endif
 
-#ifdef CONFIG_USB_CNS3XXX_OHCI
-#include "ohci-cns3xxx.c"
-#define PLATFORM_DRIVER		ohci_hcd_cns3xxx_driver
-#endif
-
 #ifdef CONFIG_CPU_XLR
 #include "ohci-xls.c"
 #define PLATFORM_DRIVER		ohci_xls_driver
-- 
1.7.9.5

