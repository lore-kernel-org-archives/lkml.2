Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2FPUtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:49:14 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:20848 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2FPUtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:49:12 -0400
Message-ID: <201206162049.q5GKnBsZ019487@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 16 Jun 2012 13:58:14 -0400
Subject: [PATCH 2/3] usb: add host support for the tilegx architecture
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
In-Reply-To: <201206162048.q5GKm1rt019464@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds OHCI and EHCI support for the tilegx's on-chip
USB hardware.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig              |   10 ++
 arch/tile/kernel/Makefile      |    1 +
 arch/tile/kernel/usb.c         |   69 +++++++++++++
 drivers/usb/host/ehci-hcd.c    |    5 +
 drivers/usb/host/ehci-tilegx.c |  214 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c    |    5 +
 drivers/usb/host/ohci-tilegx.c |  203 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/tilegx.h     |   34 +++++++
 8 files changed, 541 insertions(+)
 create mode 100644 arch/tile/kernel/usb.c
 create mode 100644 drivers/usb/host/ehci-tilegx.c
 create mode 100644 drivers/usb/host/ohci-tilegx.c
 create mode 100644 include/linux/usb/tilegx.h

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 557e3a3..cf4bb69e 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -396,6 +396,16 @@ config NO_IOPORT
 
 source "drivers/pci/Kconfig"
 
+config TILE_USB
+	tristate "Tilera USB host adapter support"
+	default y
+	depends on USB
+	depends on TILEGX
+	select TILE_GXIO_USB_HOST
+	---help---
+	  Provides USB host adapter support for the built-in EHCI and OHCI
+	  interfaces on TILE-Gx chips.
+
 config HOTPLUG
 	bool "Support for hot-pluggable devices"
 	---help---
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index 49d4ce3..5334be8 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_PCI)		+= pci_gx.o
 else
 obj-$(CONFIG_PCI)		+= pci.o
 endif
+obj-$(CONFIG_TILE_USB)		+= usb.o
diff --git a/arch/tile/kernel/usb.c b/arch/tile/kernel/usb.c
new file mode 100644
index 0000000..5af8deb
--- /dev/null
+++ b/arch/tile/kernel/usb.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Register the Tile-Gx USB interfaces as platform devices.
+ *
+ * The actual USB driver is just some glue (in
+ * drivers/usb/host/[eo]hci-tilegx.c) which makes the registers available
+ * to the standard kernel EHCI and OHCI drivers.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/usb/tilegx.h>
+#include <linux/types.h>
+
+static u64 ehci_dmamask = DMA_BIT_MASK(32);
+
+#define USB_HOST_DEF(unit, type, dmamask) \
+	static struct \
+	    tilegx_usb_platform_data tilegx_usb_platform_data_ ## type ## \
+		hci ## unit = { \
+		.dev_index = unit, \
+	}; \
+	\
+	static struct platform_device tilegx_usb_ ## type ## hci ## unit = { \
+		.name		= "tilegx-" #type "hci", \
+		.id		= unit, \
+		.dev = { \
+			.dma_mask		= dmamask, \
+			.coherent_dma_mask	= DMA_BIT_MASK(32), \
+			.platform_data = \
+				&tilegx_usb_platform_data_ ## type ## hci ## \
+				unit, \
+		}, \
+	};
+
+USB_HOST_DEF(0, e, &ehci_dmamask)
+USB_HOST_DEF(0, o, NULL)
+USB_HOST_DEF(1, e, &ehci_dmamask)
+USB_HOST_DEF(1, o, NULL)
+
+#undef USB_HOST_DEF
+
+static struct platform_device *tilegx_usb_devices[] __initdata = {
+	&tilegx_usb_ehci0,
+	&tilegx_usb_ehci1,
+	&tilegx_usb_ohci0,
+	&tilegx_usb_ohci1,
+};
+
+/** Add our set of possible USB devices. */
+static int __init tilegx_usb_init(void)
+{
+	platform_add_devices(tilegx_usb_devices,
+			     ARRAY_SIZE(tilegx_usb_devices));
+
+	return 0;
+}
+arch_initcall(tilegx_usb_init);
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b100f5f..d2739b1 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1347,6 +1347,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_msm_driver
 #endif
 
+#ifdef CONFIG_TILE_USB
+#include "ehci-tilegx.c"
+#define	PLATFORM_DRIVER		ehci_hcd_tilegx_driver
+#endif
+
 #ifdef CONFIG_USB_EHCI_HCD_PMC_MSP
 #include "ehci-pmcmsp.c"
 #define	PLATFORM_DRIVER		ehci_hcd_msp_driver
diff --git a/drivers/usb/host/ehci-tilegx.c b/drivers/usb/host/ehci-tilegx.c
new file mode 100644
index 0000000..1d215cd
--- /dev/null
+++ b/drivers/usb/host/ehci-tilegx.c
@@ -0,0 +1,214 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ * Tilera TILE-Gx USB EHCI host controller driver.
+ */
+
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/usb/tilegx.h>
+#include <linux/usb.h>
+
+#include <asm/homecache.h>
+
+#include <gxio/iorpc_usb_host.h>
+#include <gxio/usb_host.h>
+
+static void tilegx_start_ehc(void)
+{
+}
+
+static void tilegx_stop_ehc(void)
+{
+}
+
+static int tilegx_ehci_setup(struct usb_hcd *hcd)
+{
+	int ret = ehci_init(hcd);
+
+	/*
+	 * Some drivers do:
+	 *
+	 *   struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	 *   ehci->need_io_watchdog = 0;
+	 *
+	 * here, but since this is a new driver we're going to leave the
+	 * watchdog enabled.  Later we may try to turn it off and see
+	 * whether we run into any problems.
+	 */
+
+	return ret;
+}
+
+static const struct hc_driver ehci_tilegx_hc_driver = {
+	.description		= hcd_name,
+	.product_desc		= "Tile-Gx EHCI",
+	.hcd_priv_size		= sizeof(struct ehci_hcd),
+
+	/*
+	 * Generic hardware linkage.
+	 */
+	.irq			= ehci_irq,
+	.flags			= HCD_MEMORY | HCD_USB2,
+
+	/*
+	 * Basic lifecycle operations.
+	 */
+	.reset			= tilegx_ehci_setup,
+	.start			= ehci_run,
+	.stop			= ehci_stop,
+	.shutdown		= ehci_shutdown,
+
+	/*
+	 * Managing I/O requests and associated device resources.
+	 */
+	.urb_enqueue		= ehci_urb_enqueue,
+	.urb_dequeue		= ehci_urb_dequeue,
+	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
+
+	/*
+	 * Scheduling support.
+	 */
+	.get_frame_number	= ehci_get_frame,
+
+	/*
+	 * Root hub support.
+	 */
+	.hub_status_data	= ehci_hub_status_data,
+	.hub_control		= ehci_hub_control,
+	.bus_suspend		= ehci_bus_suspend,
+	.bus_resume		= ehci_bus_resume,
+	.relinquish_port	= ehci_relinquish_port,
+	.port_handed_over	= ehci_port_handed_over,
+
+	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
+};
+
+static int ehci_hcd_tilegx_drv_probe(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+	struct ehci_hcd *ehci;
+	struct tilegx_usb_platform_data *pdata = pdev->dev.platform_data;
+	pte_t pte = { 0 };
+	int my_cpu = smp_processor_id();
+	int ret;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	/*
+	 * Try to initialize our GXIO context; if we can't, the device
+	 * doesn't exist.
+	 */
+	if (gxio_usb_host_init(&pdata->usb_ctx, pdata->dev_index, 1) != 0)
+		return -ENXIO;
+
+	hcd = usb_create_hcd(&ehci_tilegx_hc_driver, &pdev->dev,
+			     dev_name(&pdev->dev));
+	if (!hcd)
+		return -ENOMEM;
+
+	/*
+	 * We don't use rsrc_start to map in our registers, but seems like
+	 * we ought to set it to something, so we use the register VA.
+	 */
+	hcd->rsrc_start =
+		(ulong) gxio_usb_host_get_reg_start(&pdata->usb_ctx);
+	hcd->rsrc_len = gxio_usb_host_get_reg_len(&pdata->usb_ctx);
+	hcd->regs = gxio_usb_host_get_reg_start(&pdata->usb_ctx);
+
+	tilegx_start_ehc();
+
+	ehci = hcd_to_ehci(hcd);
+	ehci->caps = hcd->regs;
+	ehci->regs =
+		hcd->regs + HC_LENGTH(ehci, readl(&ehci->caps->hc_capbase));
+	/* cache this readonly data; minimize chip reads */
+	ehci->hcs_params = readl(&ehci->caps->hcs_params);
+
+	/* Create our IRQs and register them. */
+	pdata->irq = create_irq();
+	if (pdata->irq < 0) {
+		ret = -ENXIO;
+		goto err_no_irq;
+	}
+
+	tile_irq_activate(pdata->irq, TILE_IRQ_PERCPU);
+
+	/* Configure interrupts. */
+	ret = gxio_usb_host_cfg_interrupt(&pdata->usb_ctx,
+					  cpu_x(my_cpu), cpu_y(my_cpu),
+					  KERNEL_PL, pdata->irq);
+	if (ret) {
+		ret = -ENXIO;
+		goto err_have_irq;
+	}
+
+	/* Register all of our memory. */
+	pte = pte_set_home(pte, PAGE_HOME_HASH);
+	ret = gxio_usb_host_register_client_memory(&pdata->usb_ctx, pte, 0);
+	if (ret) {
+		ret = -ENXIO;
+		goto err_have_irq;
+	}
+
+	ret = usb_add_hcd(hcd, pdata->irq, IRQF_SHARED);
+	if (ret == 0) {
+		platform_set_drvdata(pdev, hcd);
+		return ret;
+	}
+
+err_have_irq:
+	destroy_irq(pdata->irq);
+err_no_irq:
+	tilegx_stop_ehc();
+	usb_put_hcd(hcd);
+	gxio_usb_host_destroy(&pdata->usb_ctx);
+	return ret;
+}
+
+static int ehci_hcd_tilegx_drv_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct tilegx_usb_platform_data *pdata = pdev->dev.platform_data;
+
+	usb_remove_hcd(hcd);
+	usb_put_hcd(hcd);
+	tilegx_stop_ehc();
+	gxio_usb_host_destroy(&pdata->usb_ctx);
+	destroy_irq(pdata->irq);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static void ehci_hcd_tilegx_drv_shutdown(struct platform_device *pdev)
+{
+	usb_hcd_platform_shutdown(pdev);
+	ehci_hcd_tilegx_drv_remove(pdev);
+}
+
+static struct platform_driver ehci_hcd_tilegx_driver = {
+	.probe		= ehci_hcd_tilegx_drv_probe,
+	.remove		= ehci_hcd_tilegx_drv_remove,
+	.shutdown	= ehci_hcd_tilegx_drv_shutdown,
+	.driver = {
+		.name	= "tilegx-ehci",
+		.owner	= THIS_MODULE,
+	}
+};
+
+MODULE_ALIAS("platform:tilegx-ehci");
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index e0adf5c..2b1e8d8 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1100,6 +1100,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_octeon_driver
 #endif
 
+#ifdef CONFIG_TILE_USB
+#include "ohci-tilegx.c"
+#define PLATFORM_DRIVER		ohci_hcd_tilegx_driver
+#endif
+
 #ifdef CONFIG_USB_CNS3XXX_OHCI
 #include "ohci-cns3xxx.c"
 #define PLATFORM_DRIVER		ohci_hcd_cns3xxx_driver
diff --git a/drivers/usb/host/ohci-tilegx.c b/drivers/usb/host/ohci-tilegx.c
new file mode 100644
index 0000000..1ae7b28
--- /dev/null
+++ b/drivers/usb/host/ohci-tilegx.c
@@ -0,0 +1,203 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ * Tilera TILE-Gx USB OHCI host controller driver.
+ */
+
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/usb/tilegx.h>
+#include <linux/usb.h>
+
+#include <asm/homecache.h>
+
+#include <gxio/iorpc_usb_host.h>
+#include <gxio/usb_host.h>
+
+static void tilegx_start_ohc(void)
+{
+}
+
+static void tilegx_stop_ohc(void)
+{
+}
+
+static int tilegx_ohci_start(struct usb_hcd *hcd)
+{
+	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
+	int ret;
+
+	ret = ohci_init(ohci);
+	if (ret < 0)
+		return ret;
+
+	ret = ohci_run(ohci);
+	if (ret < 0) {
+		dev_err(hcd->self.controller, "can't start %s\n",
+			hcd->self.bus_name);
+		ohci_stop(hcd);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct hc_driver ohci_tilegx_hc_driver = {
+	.description		= hcd_name,
+	.product_desc		= "Tile-Gx OHCI",
+	.hcd_priv_size		= sizeof(struct ohci_hcd),
+
+	/*
+	 * Generic hardware linkage.
+	 */
+	.irq			= ohci_irq,
+	.flags			= HCD_MEMORY | HCD_LOCAL_MEM | HCD_USB11,
+
+	/*
+	 * Basic lifecycle operations.
+	 */
+	.start			= tilegx_ohci_start,
+	.stop			= ohci_stop,
+	.shutdown		= ohci_shutdown,
+
+	/*
+	 * Managing I/O requests and associated device resources.
+	 */
+	.urb_enqueue		= ohci_urb_enqueue,
+	.urb_dequeue		= ohci_urb_dequeue,
+	.endpoint_disable	= ohci_endpoint_disable,
+
+	/*
+	 * Scheduling support.
+	 */
+	.get_frame_number	= ohci_get_frame,
+
+	/*
+	 * Root hub support.
+	 */
+	.hub_status_data	= ohci_hub_status_data,
+	.hub_control		= ohci_hub_control,
+	.start_port_reset	= ohci_start_port_reset,
+};
+
+static int ohci_hcd_tilegx_drv_probe(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+	struct tilegx_usb_platform_data *pdata = pdev->dev.platform_data;
+	pte_t pte = { 0 };
+	int my_cpu = smp_processor_id();
+	int ret;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	/*
+	 * Try to initialize our GXIO context; if we can't, the device
+	 * doesn't exist.
+	 */
+	if (gxio_usb_host_init(&pdata->usb_ctx, pdata->dev_index, 0) != 0)
+		return -ENXIO;
+
+	hcd = usb_create_hcd(&ohci_tilegx_hc_driver, &pdev->dev,
+			     dev_name(&pdev->dev));
+	if (!hcd)
+		return -ENOMEM;
+
+	/*
+	 * We don't use rsrc_start to map in our registers, but seems like
+	 * we ought to set it to something, so we use the register VA.
+	 */
+	hcd->rsrc_start =
+		(ulong) gxio_usb_host_get_reg_start(&pdata->usb_ctx);
+	hcd->rsrc_len = gxio_usb_host_get_reg_len(&pdata->usb_ctx);
+	hcd->regs = gxio_usb_host_get_reg_start(&pdata->usb_ctx);
+
+	tilegx_start_ohc();
+
+	/* Create our IRQs and register them. */
+	pdata->irq = create_irq();
+	if (pdata->irq < 0) {
+		ret = -ENXIO;
+		goto err_no_irq;
+	}
+
+	tile_irq_activate(pdata->irq, TILE_IRQ_PERCPU);
+
+	/* Configure interrupts. */
+	ret = gxio_usb_host_cfg_interrupt(&pdata->usb_ctx,
+					  cpu_x(my_cpu), cpu_y(my_cpu),
+					  KERNEL_PL, pdata->irq);
+	if (ret) {
+		ret = -ENXIO;
+		goto err_have_irq;
+	}
+
+	/* Register all of our memory. */
+	pte = pte_set_home(pte, PAGE_HOME_HASH);
+	ret = gxio_usb_host_register_client_memory(&pdata->usb_ctx, pte, 0);
+	if (ret) {
+		ret = -ENXIO;
+		goto err_have_irq;
+	}
+
+	ohci_hcd_init(hcd_to_ohci(hcd));
+
+	ret = usb_add_hcd(hcd, pdata->irq, IRQF_SHARED);
+	if (ret == 0) {
+		platform_set_drvdata(pdev, hcd);
+		return ret;
+	}
+
+err_have_irq:
+	destroy_irq(pdata->irq);
+err_no_irq:
+	tilegx_stop_ohc();
+	usb_put_hcd(hcd);
+	gxio_usb_host_destroy(&pdata->usb_ctx);
+	return ret;
+}
+
+static int ohci_hcd_tilegx_drv_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct tilegx_usb_platform_data* pdata = pdev->dev.platform_data;
+
+	usb_remove_hcd(hcd);
+	usb_put_hcd(hcd);
+	tilegx_stop_ohc();
+	gxio_usb_host_destroy(&pdata->usb_ctx);
+	destroy_irq(pdata->irq);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static void ohci_hcd_tilegx_drv_shutdown(struct platform_device *pdev)
+{
+	usb_hcd_platform_shutdown(pdev);
+	ohci_hcd_tilegx_drv_remove(pdev);
+}
+
+static struct platform_driver ohci_hcd_tilegx_driver = {
+	.probe		= ohci_hcd_tilegx_drv_probe,
+	.remove		= ohci_hcd_tilegx_drv_remove,
+	.shutdown	= ohci_hcd_tilegx_drv_shutdown,
+	.driver = {
+		.name	= "tilegx-ohci",
+		.owner	= THIS_MODULE,
+	}
+};
+
+MODULE_ALIAS("platform:tilegx-ohci");
diff --git a/include/linux/usb/tilegx.h b/include/linux/usb/tilegx.h
new file mode 100644
index 0000000..2d65e34
--- /dev/null
+++ b/include/linux/usb/tilegx.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Structure to contain platform-specific data related to Tile-Gx USB
+ * controllers.
+ */
+
+#ifndef _LINUX_USB_TILEGX_H
+#define _LINUX_USB_TILEGX_H
+
+#include <gxio/usb_host.h>
+
+struct tilegx_usb_platform_data {
+	/* GXIO device index. */
+	int dev_index;
+
+	/* GXIO device context. */
+	gxio_usb_host_context_t usb_ctx;
+
+	/* Device IRQ. */
+	unsigned int irq;
+};
+
+#endif /* _LINUX_USB_TILEGX_H */
-- 
1.7.10.3

