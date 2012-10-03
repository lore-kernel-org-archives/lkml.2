Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab2JCPRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:17:54 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36931 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568Ab2JCPN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:56 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/25] USB: ehci: remove Octeon EHCI driver
Date: Wed,  3 Oct 2012 17:03:05 +0200
Message-Id: <1349276601-8371-11-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of this driver have been converted to use the ehci platform driver
instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig       |    8 +-
 drivers/usb/host/ehci-octeon.c |  203 ----------------------------------------
 2 files changed, 6 insertions(+), 205 deletions(-)
 delete mode 100644 drivers/usb/host/ehci-octeon.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index b1deb0f..18cf37f 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -627,11 +627,15 @@ config USB_IMX21_HCD
          module will be called "imx21-hcd".
 
 config USB_OCTEON_EHCI
-	bool "Octeon on-chip EHCI support"
-	depends on USB && USB_EHCI_HCD && CPU_CAVIUM_OCTEON
+	bool "Octeon on-chip EHCI support (DEPRECATED)"
+	depends on USB && CPU_CAVIUM_OCTEON
 	default n
 	select USB_EHCI_BIG_ENDIAN_MMIO
+	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
 	help
+	  This option is deprecated now and the driver was removed, use
+	  USB_EHCI_HCD_PLATFORM instead.
+
 	  Enable support for the Octeon II SOC's on-chip EHCI
 	  controller.  It is needed for high-speed (480Mbit/sec)
 	  USB 2.0 device support.  All CN6XXX based chips with USB are
diff --git a/drivers/usb/host/ehci-octeon.c b/drivers/usb/host/ehci-octeon.c
deleted file mode 100644
index ba26957a..0000000
--- a/drivers/usb/host/ehci-octeon.c
+++ /dev/null
@@ -1,203 +0,0 @@
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
-#define OCTEON_EHCI_HCD_NAME "octeon-ehci"
-
-/* Common clock init code.  */
-void octeon2_usb_clocks_start(void);
-void octeon2_usb_clocks_stop(void);
-
-static void ehci_octeon_start(void)
-{
-	union cvmx_uctlx_ehci_ctl ehci_ctl;
-
-	octeon2_usb_clocks_start();
-
-	ehci_ctl.u64 = cvmx_read_csr(CVMX_UCTLX_EHCI_CTL(0));
-	/* Use 64-bit addressing. */
-	ehci_ctl.s.ehci_64b_addr_en = 1;
-	ehci_ctl.s.l2c_addr_msb = 0;
-	ehci_ctl.s.l2c_buff_emod = 1; /* Byte swapped. */
-	ehci_ctl.s.l2c_desc_emod = 1; /* Byte swapped. */
-	cvmx_write_csr(CVMX_UCTLX_EHCI_CTL(0), ehci_ctl.u64);
-}
-
-static void ehci_octeon_stop(void)
-{
-	octeon2_usb_clocks_stop();
-}
-
-static const struct hc_driver ehci_octeon_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "Octeon EHCI",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset			= ehci_setup,
-	.start			= ehci_run,
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number	= ehci_get_frame,
-
-	/*
-	 * root hub support
-	 */
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
-};
-
-static u64 ehci_octeon_dma_mask = DMA_BIT_MASK(64);
-
-static int ehci_octeon_drv_probe(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd;
-	struct ehci_hcd *ehci;
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
-	/*
-	 * We can DMA from anywhere. But the descriptors must be in
-	 * the lower 4GB.
-	 */
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	pdev->dev.dma_mask = &ehci_octeon_dma_mask;
-
-	hcd = usb_create_hcd(&ehci_octeon_hc_driver, &pdev->dev, "octeon");
-	if (!hcd)
-		return -ENOMEM;
-
-	hcd->rsrc_start = res_mem->start;
-	hcd->rsrc_len = resource_size(res_mem);
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				OCTEON_EHCI_HCD_NAME)) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		ret = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err2;
-	}
-
-	ehci_octeon_start();
-
-	ehci = hcd_to_ehci(hcd);
-
-	/* Octeon EHCI matches CPU endianness. */
-#ifdef __BIG_ENDIAN
-	ehci->big_endian_mmio = 1;
-#endif
-
-	ehci->caps = hcd->regs;
-
-	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (ret) {
-		dev_dbg(&pdev->dev, "failed to add hcd with err %d\n", ret);
-		goto err3;
-	}
-
-	platform_set_drvdata(pdev, hcd);
-
-	/* root ports should always stay powered */
-	ehci_port_power(ehci, 1);
-
-	return 0;
-err3:
-	ehci_octeon_stop();
-
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err1:
-	usb_put_hcd(hcd);
-	return ret;
-}
-
-static int ehci_octeon_drv_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-
-	ehci_octeon_stop();
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	usb_put_hcd(hcd);
-
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-static struct platform_driver ehci_octeon_driver = {
-	.probe		= ehci_octeon_drv_probe,
-	.remove		= ehci_octeon_drv_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-	.driver = {
-		.name	= OCTEON_EHCI_HCD_NAME,
-		.owner	= THIS_MODULE,
-	}
-};
-
-MODULE_ALIAS("platform:" OCTEON_EHCI_HCD_NAME);
-- 
1.7.9.5

