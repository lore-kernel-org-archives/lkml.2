Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0KVQdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:33:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62218 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0KVQdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:33:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lpxiv+3efoKXKB6wakfH1vXlYGwfY1t/LDwnX917NWUUpmRNgmCFy/BzaLqpLL9K9p
         gOt4XowcrtuvYSP3Um1n4EfN1j/ZOKNcamNHmRqvLt6OVYNqBe9yTd+uF/zbsZUFSI+H
         u5J+xLnbLU18oUH/wO/HH4dQqmGFpaosvcvFY=
From: mkl0301@gmail.com
To: cbouatmailru@gmail.com, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Cc: Mac Lin <mkl0301@gmail.com>
Subject: [PATCH v2 3/3] USB: cns3xxx: Add EHCI and OHCI bus glue for cns3xxx SOCs
Date: Tue, 23 Nov 2010 00:32:45 +0800
Message-Id: <1290443565-20766-4-git-send-email-mkl0301@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mac Lin <mkl0301@gmail.com>

The CNS3XXX SOC has include USB EHCI and OHCI compatible controllers. This
patch adds the necessary glue logic to allow ehci-hcd and ohci-hcd drivers to
work on CNS3XXX

The EHCI and OHCI controllers share a common clock control and reset bit,
therefore additional check for the timming of enabling and disabling is
required. The USB bit of PLL Power Down Control is also shared by OTG, 24MHz
UART clock, Crypto clock, PCIe reference clock, and Clock Scale Generator.
Therefore we only ensure it is enabled, while not disabling it.

Signed-off-by: Mac Lin <mkl0301@gmail.com>
---
 drivers/usb/Kconfig             |    2 +
 drivers/usb/host/Kconfig        |   15 ++++
 drivers/usb/host/ehci-cns3xxx.c |  176 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c     |    5 +
 drivers/usb/host/ohci-cns3xxx.c |  171 +++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c     |    5 +
 6 files changed, 374 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/host/ehci-cns3xxx.c
 create mode 100644 drivers/usb/host/ohci-cns3xxx.c

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 67eb377..5a7c8f1 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -41,6 +41,7 @@ config USB_ARCH_HAS_OHCI
 	default y if MFD_TC6393XB
 	default y if ARCH_W90X900
 	default y if ARCH_DAVINCI_DA8XX
+	default y if ARCH_CNS3XXX
 	# PPC:
 	default y if STB03xxx
 	default y if PPC_MPC52xx
@@ -66,6 +67,7 @@ config USB_ARCH_HAS_EHCI
 	default y if ARCH_AT91SAM9G45
 	default y if ARCH_MXC
 	default y if ARCH_OMAP3
+	default y if ARCH_CNS3XXX
 	default PCI
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 6f4f8e6..f8970d1 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -147,6 +147,14 @@ config USB_W90X900_EHCI
 	---help---
 		Enables support for the W90X900 USB controller
 
+config USB_CNS3XXX_EHCI
+	bool "Cavium CNS3XXX EHCI Module"
+	depends on USB_EHCI_HCD && ARCH_CNS3XXX
+	---help---
+	  Enable support for the CNS3XXX SOC's on-chip EHCI controller.
+	  It is needed for high-speed (480Mbit/sec) USB 2.0 device
+	  support.
+
 config USB_OXU210HP_HCD
 	tristate "OXU210HP HCD support"
 	depends on USB
@@ -286,6 +294,13 @@ config USB_OHCI_HCD_SSB
 
 	  If unsure, say N.
 
+config USB_CNS3XXX_OHCI
+	bool "Cavium CNS3XXX OHCI Module"
+	depends on USB_OHCI_HCD && ARCH_CNS3XXX
+	---help---
+	  Enable support for the CNS3XXX SOC's on-chip OHCI controller.
+	  It is needed for low-speed USB 1.0 device support.
+
 config USB_OHCI_BIG_ENDIAN_DESC
 	bool
 	depends on USB_OHCI_HCD
diff --git a/drivers/usb/host/ehci-cns3xxx.c b/drivers/usb/host/ehci-cns3xxx.c
new file mode 100644
index 0000000..87c0ee8
--- /dev/null
+++ b/drivers/usb/host/ehci-cns3xxx.c
@@ -0,0 +1,176 @@
+/*
+ * Copyright 2008 Cavium Networks
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <asm/atomic.h>
+#include <mach/cns3xxx.h>
+#include <mach/pm.h>
+
+static int cns3xxx_ehci_init(struct usb_hcd *hcd)
+{
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	int retval = 0;
+
+	/* EHCI and OHCI share the same clock and power,
+	 * resetting twice would cause the 1st controller been reset.
+	 * Therefore only do power up  at the first up device, and
+	 * power down at the last down device.
+	 */
+	if (1 == atomic_inc_return(&usb_pwr_ref)) {
+		cns3xxx_pwr_power_up(1<<PM_PLL_HM_PD_CTRL_REG_OFFSET_PLL_USB);
+		cns3xxx_pwr_clk_en(1<<PM_CLK_GATE_REG_OFFSET_USB_HOST);
+		cns3xxx_pwr_soft_rst(1<<PM_SOFT_RST_REG_OFFST_USB_HOST);
+	}
+
+	ehci->caps = hcd->regs;
+	ehci->regs = hcd->regs
+		+ HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+
+	hcd->has_tt = 0;
+	ehci_reset(ehci);
+
+	retval = ehci_init(hcd);
+	if (retval)
+		return retval;
+
+	ehci_port_power(ehci, 0);
+
+	return retval;
+}
+
+static const struct hc_driver cns3xxx_ehci_hc_driver = {
+	.description		= hcd_name,
+	.product_desc		= "CNS3XXX EHCI Host Controller",
+	.hcd_priv_size		= sizeof(struct ehci_hcd),
+	.irq			= ehci_irq,
+	.flags			= HCD_MEMORY | HCD_USB2,
+	.reset			= cns3xxx_ehci_init,
+	.start			= ehci_run,
+	.stop			= ehci_stop,
+	.shutdown		= ehci_shutdown,
+	.urb_enqueue		= ehci_urb_enqueue,
+	.urb_dequeue		= ehci_urb_dequeue,
+	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
+	.get_frame_number	= ehci_get_frame,
+	.hub_status_data	= ehci_hub_status_data,
+	.hub_control		= ehci_hub_control,
+#ifdef CONFIG_PM
+	.bus_suspend		= ehci_bus_suspend,
+	.bus_resume		= ehci_bus_resume,
+#endif
+	.relinquish_port	= ehci_relinquish_port,
+	.port_handed_over	= ehci_port_handed_over,
+
+	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
+};
+
+static int cns3xxx_ehci_probe(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+	const struct hc_driver *driver = &cns3xxx_ehci_hc_driver;
+	struct resource *res;
+	int irq;
+	int retval;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(&pdev->dev,
+			"Found HC with no IRQ. Check %s setup!\n",
+			dev_name(&pdev->dev));
+		return -ENODEV;
+	}
+	irq = res->start;
+
+	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
+	if (!hcd)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev,
+			"Found HC with no register addr. Check %s setup!\n",
+			dev_name(&pdev->dev));
+		retval = -ENODEV;
+		goto err1;
+	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = res->end - res->start + 1;
+
+#ifdef CNS3XXX_USB_BASE_VIRT
+	hcd->regs = (void __iomem *) CNS3XXX_USB_BASE_VIRT;
+#else
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
+				driver->description)) {
+		dev_dbg(&pdev->dev, "controller already in use\n");
+		retval = -EBUSY;
+		goto err1;
+	}
+
+	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+
+	if (hcd->regs == NULL) {
+		dev_dbg(&pdev->dev, "error mapping memory\n");
+		retval = -EFAULT;
+		goto err2;
+	}
+#endif
+
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (retval == 0)
+		return retval;
+
+#ifndef CNS3XXX_USB_BASE_VIRT
+	iounmap(hcd->regs);
+err2:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+#endif
+err1:
+	usb_put_hcd(hcd);
+
+	return retval;
+}
+
+static int cns3xxx_ehci_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	usb_remove_hcd(hcd);
+#ifndef CNS3XXX_USB_BASE_VIRT
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+#endif
+
+	/* EHCI and OHCI share the same clock and power,
+	 * resetting twice would cause the 1st controller been reset.
+	 * Therefore only do power up  at the first up device, and
+	 * power down at the last down device.
+	 */
+	if (0 == atomic_dec_return(&usb_pwr_ref))
+		cns3xxx_pwr_clk_dis(1<<PM_CLK_GATE_REG_OFFSET_USB_HOST);
+
+	usb_put_hcd(hcd);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:cns3xxx-ehci");
+
+static struct platform_driver cns3xxx_ehci_driver = {
+	.probe = cns3xxx_ehci_probe,
+	.remove = cns3xxx_ehci_remove,
+	.driver = {
+		.name = "cns3xxx-ehci",
+	},
+};
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 502a7e6..c5dd1c3 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1216,6 +1216,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_octeon_driver
 #endif
 
+#ifdef CONFIG_USB_CNS3XXX_EHCI
+#include "ehci-cns3xxx.c"
+#define PLATFORM_DRIVER     cns3xxx_ehci_driver
+#endif
+
 #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
     !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER) && \
     !defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ohci-cns3xxx.c b/drivers/usb/host/ohci-cns3xxx.c
new file mode 100644
index 0000000..7617b8c
--- /dev/null
+++ b/drivers/usb/host/ohci-cns3xxx.c
@@ -0,0 +1,171 @@
+/*
+ * Copyright 2008 Cavium Networks
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <asm/atomic.h>
+#include <mach/cns3xxx.h>
+#include <mach/pm.h>
+
+static int __devinit
+cns3xxx_ohci_start(struct usb_hcd *hcd)
+{
+	struct ohci_hcd		*ohci = hcd_to_ohci(hcd);
+	int			ret;
+
+	/* EHCI and OHCI share the same clock and power,
+	 * resetting twice would cause the 1st controller been reset.
+	 * Therefore only do power up  at the first up device, and
+	 * power down at the last down device.
+	 */
+	if (1 == atomic_inc_return(&usb_pwr_ref)) {
+		cns3xxx_pwr_power_up(1<<PM_PLL_HM_PD_CTRL_REG_OFFSET_PLL_USB);
+		cns3xxx_pwr_clk_en(1<<PM_CLK_GATE_REG_OFFSET_USB_HOST);
+		cns3xxx_pwr_soft_rst(1<<PM_SOFT_RST_REG_OFFST_USB_HOST);
+	}
+
+	ret = ohci_init(ohci);
+	if (ret < 0)
+		return ret;
+
+	ohci->num_ports = 1;
+
+	ret = ohci_run(ohci);
+	if (ret < 0) {
+		err("can't start %s", hcd->self.bus_name);
+		ohci_stop(hcd);
+		return ret;
+	}
+	return 0;
+}
+
+static const struct hc_driver cns3xxx_ohci_hc_driver = {
+	.description		= hcd_name,
+	.product_desc		= "CNS3XXX OHCI Host controller",
+	.hcd_priv_size		= sizeof(struct ohci_hcd),
+	.irq			= ohci_irq,
+	.flags			= HCD_USB11 | HCD_MEMORY,
+	.start			= cns3xxx_ohci_start,
+	.stop			= ohci_stop,
+	.shutdown		= ohci_shutdown,
+	.urb_enqueue		= ohci_urb_enqueue,
+	.urb_dequeue		= ohci_urb_dequeue,
+	.endpoint_disable	= ohci_endpoint_disable,
+	.get_frame_number	= ohci_get_frame,
+	.hub_status_data	= ohci_hub_status_data,
+	.hub_control		= ohci_hub_control,
+#ifdef CONFIG_PM
+	.bus_suspend		= ohci_bus_suspend,
+	.bus_resume		= ohci_bus_resume,
+#endif
+	.start_port_reset	= ohci_start_port_reset,
+};
+
+static int cns3xxx_ohci_probe(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = NULL;
+	const struct hc_driver *driver = &cns3xxx_ohci_hc_driver;
+	struct resource *res;
+	int irq;
+	int retval;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(&pdev->dev,
+			"Found HC with no IRQ. Check %s setup!\n",
+			dev_name(&pdev->dev));
+		return -ENODEV;
+	}
+	irq = res->start;
+
+	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
+	if (!hcd)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev,
+			"Found HC with no register addr. Check %s setup!\n",
+			dev_name(&pdev->dev));
+		retval = -ENODEV;
+		goto err1;
+	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = res->end - res->start + 1;
+
+#ifdef CNS3XXX_USB_OHCI_BASE_VIRT
+	hcd->regs = (void __iomem *) CNS3XXX_USB_OHCI_BASE_VIRT;
+#else
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
+			driver->description)) {
+		dev_dbg(&pdev->dev, "controller already in use\n");
+		retval = -EBUSY;
+		goto err1;
+	}
+
+	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+
+	if (hcd->regs == NULL) {
+		dev_dbg(&pdev->dev, "error mapping memory\n");
+		retval = -EFAULT;
+		goto err2;
+	}
+#endif
+
+	ohci_hcd_init(hcd_to_ohci(hcd));
+
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (retval == 0)
+		return retval;
+
+#ifndef CNS3XXX_USB_OHCI_BASE_VIRT
+	iounmap(hcd->regs);
+err2:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+#endif
+err1:
+	usb_put_hcd(hcd);
+	return retval;
+}
+
+static int cns3xxx_ohci_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	usb_remove_hcd(hcd);
+#ifndef CNS3XXX_USB_OHCI_BASE_VIRT
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+#endif
+
+	/* EHCI and OHCI share the same clock and power,
+	 * resetting twice would cause the 1st controller been reset.
+	 * Therefore only do power up  at the first up device, and
+	 * power down at the last down device.
+	 */
+	if (0 == atomic_dec_return(&usb_pwr_ref))
+		cns3xxx_pwr_clk_dis(1<<PM_CLK_GATE_REG_OFFSET_USB_HOST);
+
+	usb_put_hcd(hcd);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:cns3xxx-ohci");
+
+static struct platform_driver ohci_hcd_cns3xxx_driver = {
+	.probe = cns3xxx_ohci_probe,
+	.remove = cns3xxx_ohci_remove,
+	.driver = {
+		.name = "cns3xxx-ohci",
+	},
+};
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 5179acb..5cb6731 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1111,6 +1111,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_octeon_driver
 #endif
 
+#ifdef CONFIG_USB_CNS3XXX_OHCI
+#include "ohci-cns3xxx.c"
+#define PLATFORM_DRIVER		ohci_hcd_cns3xxx_driver
+#endif
+
 #if	!defined(PCI_DRIVER) &&		\
 	!defined(PLATFORM_DRIVER) &&	\
 	!defined(OMAP1_PLATFORM_DRIVER) &&	\
-- 
1.7.3

