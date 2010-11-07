Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0KGQbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:31:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58581 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0KGQbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:31:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qXlPei5fISx40S4WtuaME6I2ERv72Y3KaXr6juZBOgO2OdikdV/d+aKkif3Qp42jTb
         o1iENf244yNUFJADRmVTH+rRDhxTZqls5JQmTQQLF5jb16uqeToimpliz8BfsjYM655c
         U5p71Ax6GMn9s2Fskcpwsj34TD5gOiaapfAb8=
From: Alexey Charkov <alchark@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Alexey Charkov <alchark@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6 v2] usb: Add support for VIA VT8500 and compatibles in EHCI HCD
Date: Sun,  7 Nov 2010 19:28:55 +0300
Message-Id: <1289147348-31969-4-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1289147348-31969-1-git-send-email-alchark@gmail.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VIA and WonderMedia Systems-on-Chip feature a standard EHCI host
controller. This adds necessary glue to use the standard driver
with these systems.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---

Please review and (if appropriate) commit to a relevant git tree for
further integration in 2.6.38.

Compared to the previous submission, this code just contains a rebase
against the latest changes introduced in 2.6.37 merge window.

Relevant platform definitions are introduced by PATCH 1/6 in this series,
so one would need that to make use of this code.

Due credits go to the community for providing feedback, advice and
testing.

 drivers/usb/Kconfig            |    1 +
 drivers/usb/host/ehci-hcd.c    |    5 +
 drivers/usb/host/ehci-vt8500.c |  172 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/host/ehci-vt8500.c

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 67eb377..7d13506 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -66,6 +66,7 @@ config USB_ARCH_HAS_EHCI
 	default y if ARCH_AT91SAM9G45
 	default y if ARCH_MXC
 	default y if ARCH_OMAP3
+	default y if ARCH_VT8500
 	default PCI
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 502a7e6..10f985d 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1216,6 +1216,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_octeon_driver
 #endif
 
+#ifdef CONFIG_ARCH_VT8500
+#include "ehci-vt8500.c"
+#define	PLATFORM_DRIVER		vt8500_ehci_driver
+#endif
+
 #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
     !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER) && \
     !defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci-vt8500.c b/drivers/usb/host/ehci-vt8500.c
new file mode 100644
index 0000000..2016806
--- /dev/null
+++ b/drivers/usb/host/ehci-vt8500.c
@@ -0,0 +1,172 @@
+/*
+ * drivers/usb/host/ehci-vt8500.c
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * Based on ehci-au1xxx.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/platform_device.h>
+
+static int ehci_update_device(struct usb_hcd *hcd, struct usb_device *udev)
+{
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	int rc = 0;
+
+	if (!udev->parent) /* udev is root hub itself, impossible */
+		rc = -1;
+	/* we only support lpm device connected to root hub yet */
+	if (ehci->has_lpm && !udev->parent->parent) {
+		rc = ehci_lpm_set_da(ehci, udev->devnum, udev->portnum);
+		if (!rc)
+			rc = ehci_lpm_check(ehci, udev->portnum);
+	}
+	return rc;
+}
+
+static const struct hc_driver vt8500_ehci_hc_driver = {
+	.description		= hcd_name,
+	.product_desc		= "VT8500 EHCI",
+	.hcd_priv_size		= sizeof(struct ehci_hcd),
+
+	/*
+	 * generic hardware linkage
+	 */
+	.irq			= ehci_irq,
+	.flags			= HCD_MEMORY | HCD_USB2,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset			= ehci_init,
+	.start			= ehci_run,
+	.stop			= ehci_stop,
+	.shutdown		= ehci_shutdown,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue		= ehci_urb_enqueue,
+	.urb_dequeue		= ehci_urb_dequeue,
+	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number	= ehci_get_frame,
+
+	/*
+	 * root hub support
+	 */
+	.hub_status_data	= ehci_hub_status_data,
+	.hub_control		= ehci_hub_control,
+	.bus_suspend		= ehci_bus_suspend,
+	.bus_resume		= ehci_bus_resume,
+	.relinquish_port	= ehci_relinquish_port,
+	.port_handed_over	= ehci_port_handed_over,
+
+	/*
+	 * call back when device connected and addressed
+	 */
+	.update_device =	ehci_update_device,
+
+	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
+};
+
+static int vt8500_ehci_drv_probe(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+	struct ehci_hcd *ehci;
+	struct resource *res;
+	int ret;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	if (pdev->resource[1].flags != IORESOURCE_IRQ) {
+		pr_debug("resource[1] is not IORESOURCE_IRQ");
+		return -ENOMEM;
+	}
+	hcd = usb_create_hcd(&vt8500_ehci_hc_driver, &pdev->dev, "VT8500");
+	if (!hcd)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
+
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
+		pr_debug("request_mem_region failed");
+		ret = -EBUSY;
+		goto err1;
+	}
+
+	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	if (!hcd->regs) {
+		pr_debug("ioremap failed");
+		ret = -ENOMEM;
+		goto err2;
+	}
+
+	ehci = hcd_to_ehci(hcd);
+	ehci->caps = hcd->regs;
+	ehci->regs = hcd->regs + HC_LENGTH(readl(&ehci->caps->hc_capbase));
+
+	dbg_hcs_params(ehci, "reset");
+	dbg_hcc_params(ehci, "reset");
+
+	/* cache this readonly data; minimize chip reads */
+	ehci->hcs_params = readl(&ehci->caps->hcs_params);
+
+	ehci_port_power(ehci, 1);
+
+	ret = usb_add_hcd(hcd, pdev->resource[1].start,
+			  IRQF_DISABLED | IRQF_SHARED);
+	if (ret == 0) {
+		platform_set_drvdata(pdev, hcd);
+		return ret;
+	}
+
+	iounmap(hcd->regs);
+err2:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+err1:
+	usb_put_hcd(hcd);
+	return ret;
+}
+
+static int vt8500_ehci_drv_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+	usb_put_hcd(hcd);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver vt8500_ehci_driver = {
+	.probe		= vt8500_ehci_drv_probe,
+	.remove		= vt8500_ehci_drv_remove,
+	.shutdown	= usb_hcd_platform_shutdown,
+	.driver = {
+		.name	= "vt8500-ehci",
+		.owner	= THIS_MODULE,
+	}
+};
+
+MODULE_ALIAS("platform:vt8500-ehci");
-- 
1.7.3.2

