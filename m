Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab2JCPOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:14:03 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36936 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab2JCPN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:57 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/25] USB: ohci: remove OHCI SH platform driver
Date: Wed,  3 Oct 2012 17:03:19 +0200
Message-Id: <1349276601-8371-25-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users have been converted to use the OHCI platform driver instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig    |    6 +-
 drivers/usb/host/ohci-hcd.c |    5 --
 drivers/usb/host/ohci-sh.c  |  141 -------------------------------------------
 3 files changed, 5 insertions(+), 147 deletions(-)
 delete mode 100644 drivers/usb/host/ohci-sh.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index e9c277b..437533e 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -397,9 +397,13 @@ config USB_OHCI_HCD_SSB
 	  If unsure, say N.
 
 config USB_OHCI_SH
-	bool "OHCI support for SuperH USB controller"
+	bool "OHCI support for SuperH USB controller (DEPRECATED)"
 	depends on USB_OHCI_HCD && SUPERH
+	select USB_OHCI_HCD_PLATFORM
 	---help---
+	  This option is deprecated now and the driver was removed, use
+	  USB_OHCI_HCD_PLATFORM instead.
+
 	  Enables support for the on-chip OHCI controller on the SuperH.
 	  If you use the PCI OHCI controller, this option is not necessary.
 
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 2cafe98..028f60d 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1054,11 +1054,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_hcd_da8xx_driver
 #endif
 
-#ifdef CONFIG_USB_OHCI_SH
-#include "ohci-sh.c"
-#define PLATFORM_DRIVER		ohci_hcd_sh_driver
-#endif
-
 
 #ifdef CONFIG_USB_OHCI_HCD_PPC_OF
 #include "ohci-ppc-of.c"
diff --git a/drivers/usb/host/ohci-sh.c b/drivers/usb/host/ohci-sh.c
deleted file mode 100644
index 76a20c2..0000000
--- a/drivers/usb/host/ohci-sh.c
+++ /dev/null
@@ -1,141 +0,0 @@
-/*
- * OHCI HCD (Host Controller Driver) for USB.
- *
- * Copyright (C) 2008 Renesas Solutions Corp.
- *
- * Author : Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- */
-
-#include <linux/platform_device.h>
-
-static int ohci_sh_start(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-
-	ohci_hcd_init(ohci);
-	ohci_init(ohci);
-	ohci_run(ohci);
-	return 0;
-}
-
-static const struct hc_driver ohci_sh_hc_driver = {
-	.description =		hcd_name,
-	.product_desc =		"SuperH OHCI",
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
-	.start =		ohci_sh_start,
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
-/*-------------------------------------------------------------------------*/
-
-static int ohci_hcd_sh_probe(struct platform_device *pdev)
-{
-	struct resource *res = NULL;
-	struct usb_hcd *hcd = NULL;
-	int irq = -1;
-	int ret;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "platform_get_resource error.\n");
-		return -ENODEV;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "platform_get_irq error.\n");
-		return -ENODEV;
-	}
-
-	/* initialize hcd */
-	hcd = usb_create_hcd(&ohci_sh_hc_driver, &pdev->dev, (char *)hcd_name);
-	if (!hcd) {
-		dev_err(&pdev->dev, "Failed to create hcd\n");
-		return -ENOMEM;
-	}
-
-	hcd->regs = (void __iomem *)res->start;
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "Failed to add hcd\n");
-		usb_put_hcd(hcd);
-		return ret;
-	}
-
-	return ret;
-}
-
-static int ohci_hcd_sh_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-	usb_put_hcd(hcd);
-
-	return 0;
-}
-
-static struct platform_driver ohci_hcd_sh_driver = {
-	.probe		= ohci_hcd_sh_probe,
-	.remove		= ohci_hcd_sh_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-	.driver		= {
-		.name	= "sh_ohci",
-		.owner	= THIS_MODULE,
-	},
-};
-
-MODULE_ALIAS("platform:sh_ohci");
-- 
1.7.9.5

