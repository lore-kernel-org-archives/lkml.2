Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab2JCPVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:21:46 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36896 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab2JCPNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:50 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 11:13:49 EDT
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/25] USB: ohci: remove Octeon OHCI platform driver
Date: Wed,  3 Oct 2012 17:03:15 +0200
Message-Id: <1349276601-8371-21-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users have been converted to use the OHCI platform driver instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig       |    6 +-
 drivers/usb/host/ohci-hcd.c    |    5 -
 drivers/usb/host/ohci-octeon.c |  214 ----------------------------------------
 3 files changed, 5 insertions(+), 220 deletions(-)
 delete mode 100644 drivers/usb/host/ohci-octeon.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3742f73..e9c277b 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -650,12 +650,16 @@ config USB_OCTEON_EHCI
 	  supported.
 
 config USB_OCTEON_OHCI
-	bool "Octeon on-chip OHCI support"
+	bool "Octeon on-chip OHCI support (DEPRECATED)"
 	depends on USB && USB_OHCI_HCD && CPU_CAVIUM_OCTEON
 	default USB_OCTEON_EHCI
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	select USB_OHCI_LITTLE_ENDIAN
+	select USB_EHCI_HCD_PLATFORM if USB_OHCI_HCD
 	help
+	  This option is deprecated now and the driver was removed, use
+	  USB_OHCI_HCD_PLATFORM instead.
+
 	  Enable support for the Octeon II SOC's on-chip OHCI
 	  controller.  It is needed for low-speed USB 1.0 device
 	  support.  All CN6XXX based chips with USB are supported.
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 5648f09..b099024 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1090,11 +1090,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER	ohci_hcd_jz4740_driver
 #endif
 
-#ifdef CONFIG_USB_OCTEON_OHCI
-#include "ohci-octeon.c"
-#define PLATFORM_DRIVER		ohci_octeon_driver
-#endif
-
 #ifdef CONFIG_TILE_USB
 #include "ohci-tilegx.c"
 #define PLATFORM_DRIVER		ohci_hcd_tilegx_driver
diff --git a/drivers/usb/host/ohci-octeon.c b/drivers/usb/host/ohci-octeon.c
deleted file mode 100644
index d469bf9..0000000
--- a/drivers/usb/host/ohci-octeon.c
+++ /dev/null
@@ -1,214 +0,0 @@
-/*
- * EHCI HCD glue for Cavium Octeon II SOCs.
- *
- * Loosely based on ehci-au1xxx.c
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2010 Cavium Networks
- *
- */
-
-#include <linux/platform_device.h>
-
-#include <asm/octeon/octeon.h>
-#include <asm/octeon/cvmx-uctlx-defs.h>
-
-#define OCTEON_OHCI_HCD_NAME "octeon-ohci"
-
-/* Common clock init code.  */
-void octeon2_usb_clocks_start(void);
-void octeon2_usb_clocks_stop(void);
-
-static void ohci_octeon_hw_start(void)
-{
-	union cvmx_uctlx_ohci_ctl ohci_ctl;
-
-	octeon2_usb_clocks_start();
-
-	ohci_ctl.u64 = cvmx_read_csr(CVMX_UCTLX_OHCI_CTL(0));
-	ohci_ctl.s.l2c_addr_msb = 0;
-	ohci_ctl.s.l2c_buff_emod = 1; /* Byte swapped. */
-	ohci_ctl.s.l2c_desc_emod = 1; /* Byte swapped. */
-	cvmx_write_csr(CVMX_UCTLX_OHCI_CTL(0), ohci_ctl.u64);
-
-}
-
-static void ohci_octeon_hw_stop(void)
-{
-	/* Undo ohci_octeon_start() */
-	octeon2_usb_clocks_stop();
-}
-
-static int __devinit ohci_octeon_start(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-	int ret;
-
-	ret = ohci_init(ohci);
-
-	if (ret < 0)
-		return ret;
-
-	ret = ohci_run(ohci);
-
-	if (ret < 0) {
-		ohci_err(ohci, "can't start %s", hcd->self.bus_name);
-		ohci_stop(hcd);
-		return ret;
-	}
-
-	return 0;
-}
-
-static const struct hc_driver ohci_octeon_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "Octeon OHCI",
-	.hcd_priv_size		= sizeof(struct ohci_hcd),
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
-	.start =		ohci_octeon_start,
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
-
-	.start_port_reset =	ohci_start_port_reset,
-};
-
-static int ohci_octeon_drv_probe(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd;
-	struct ohci_hcd *ohci;
-	void *reg_base;
-	struct resource *res_mem;
-	int irq;
-	int ret;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "No irq assigned\n");
-		return -ENODEV;
-	}
-
-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res_mem == NULL) {
-		dev_err(&pdev->dev, "No register space assigned\n");
-		return -ENODEV;
-	}
-
-	/* Ohci is a 32-bit device. */
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-
-	hcd = usb_create_hcd(&ohci_octeon_hc_driver, &pdev->dev, "octeon");
-	if (!hcd)
-		return -ENOMEM;
-
-	hcd->rsrc_start = res_mem->start;
-	hcd->rsrc_len = resource_size(res_mem);
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				OCTEON_OHCI_HCD_NAME)) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		ret = -EBUSY;
-		goto err1;
-	}
-
-	reg_base = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!reg_base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err2;
-	}
-
-	ohci_octeon_hw_start();
-
-	hcd->regs = reg_base;
-
-	ohci = hcd_to_ohci(hcd);
-
-	/* Octeon OHCI matches CPU endianness. */
-#ifdef __BIG_ENDIAN
-	ohci->flags |= OHCI_QUIRK_BE_MMIO;
-#endif
-
-	ohci_hcd_init(ohci);
-
-	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (ret) {
-		dev_dbg(&pdev->dev, "failed to add hcd with err %d\n", ret);
-		goto err3;
-	}
-
-	platform_set_drvdata(pdev, hcd);
-
-	return 0;
-
-err3:
-	ohci_octeon_hw_stop();
-
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err1:
-	usb_put_hcd(hcd);
-	return ret;
-}
-
-static int ohci_octeon_drv_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-
-	ohci_octeon_hw_stop();
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	usb_put_hcd(hcd);
-
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-static struct platform_driver ohci_octeon_driver = {
-	.probe		= ohci_octeon_drv_probe,
-	.remove		= ohci_octeon_drv_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-	.driver = {
-		.name	= OCTEON_OHCI_HCD_NAME,
-		.owner	= THIS_MODULE,
-	}
-};
-
-MODULE_ALIAS("platform:" OCTEON_OHCI_HCD_NAME);
-- 
1.7.9.5

