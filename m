Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2I0Hct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:32:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:26234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab2I0HcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:32:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="198436989"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
Date: Thu, 27 Sep 2012 10:31:59 +0300
Message-Id: <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

This is the PCI part of the DesignWare DMAC driver. The controller is usually
used in the Intel hardware such as Medfield.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/Kconfig       |    9 ++++
 drivers/dma/Makefile      |    1 +
 drivers/dma/dw_dmac_pci.c |  126 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)
 create mode 100644 drivers/dma/dw_dmac_pci.c

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index df32537..a5c7f64 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -89,6 +89,15 @@ config DW_DMAC
 	  Support the Synopsys DesignWare AHB DMA controller.  This
 	  can be integrated in chips such as the Atmel AT32ap7000.
 
+config DW_DMAC_PCI
+	tristate "Synopsys DesignWare AHB DMA support (PCI bus)"
+	depends on PCI
+	select DW_DMAC
+	help
+	  Support the Synopsys DesignWare AHB DMA controller on the platfroms
+	  that provide it as a PCI device. For example, Intel Medfield has
+	  integrated this GPDMA controller.
+
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
 	depends on ARCH_AT91
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 7428fea..15eef5f 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_FSL_DMA) += fsldma.o
 obj-$(CONFIG_MPC512X_DMA) += mpc512x_dma.o
 obj-$(CONFIG_MV_XOR) += mv_xor.o
 obj-$(CONFIG_DW_DMAC) += dw_dmac.o
+obj-$(CONFIG_DW_DMAC_PCI) += dw_dmac_pci.o
 obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw_dmac_pci.c
new file mode 100644
index 0000000..b7ad37f
--- /dev/null
+++ b/drivers/dma/dw_dmac_pci.c
@@ -0,0 +1,126 @@
+/*
+ * PCI driver for the Synopsys DesignWare DMA Controller
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/dw_dmac.h>
+
+static struct dw_dma_platform_data pdata = {
+	.is_private = 1,
+	.chan_allocation_order = CHAN_ALLOCATION_ASCENDING,
+	.chan_priority = CHAN_PRIORITY_ASCENDING,
+};
+
+static int __devinit dw_pci_probe(struct pci_dev *pdev,
+				  const struct pci_device_id *id)
+{
+	struct platform_device *pd;
+	struct resource r[2];
+	struct dw_dma_platform_data *driver = (void *)id->driver_data;
+	static int instance;
+	int ret;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
+
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret)
+		goto err0;
+
+	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret)
+		goto err0;
+
+	pd = platform_device_alloc("dw_dmac", instance);
+	if (!pd) {
+		dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	memset(r, 0, sizeof(r));
+
+	r[0].start = pci_resource_start(pdev, 0);
+	r[0].end = pci_resource_end(pdev, 0);
+	r[0].flags = IORESOURCE_MEM;
+
+	r[1].start = pdev->irq;
+	r[1].flags = IORESOURCE_IRQ;
+
+	ret = platform_device_add_resources(pd, r, ARRAY_SIZE(r));
+	if (ret) {
+		dev_err(&pdev->dev, "can't add resources to platform device\n");
+		goto err1;
+	}
+
+	ret = platform_device_add_data(pd, driver, sizeof(*driver));
+	if (ret)
+		goto err1;
+
+	dma_set_coherent_mask(&pd->dev, pdev->dev.coherent_dma_mask);
+	pd->dev.dma_mask = pdev->dev.dma_mask;
+	pd->dev.dma_parms = pdev->dev.dma_parms;
+	pd->dev.parent = &pdev->dev;
+
+	pci_set_drvdata(pdev, pd);
+
+	ret = platform_device_add(pd);
+	if (ret) {
+		dev_err(&pdev->dev, "platform_device_add failed\n");
+		goto err1;
+	}
+
+	instance++;
+	return 0;
+
+err1:
+	platform_device_put(pd);
+err0:
+	pci_disable_device(pdev);
+
+	return ret;
+}
+
+static void __devexit dw_pci_remove(struct pci_dev *pdev)
+{
+	struct platform_device *pd = pci_get_drvdata(pdev);
+
+	platform_device_unregister(pd);
+	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
+	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&pdata },
+	{ PCI_VDEVICE(INTEL, 0x0830), (kernel_ulong_t)&pdata },
+	{ PCI_VDEVICE(INTEL, 0x0f06), (kernel_ulong_t)&pdata },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, dw_pci_id_table);
+
+static struct pci_driver dw_pci_driver = {
+	.name		= "dw_dmac_pci",
+	.id_table	= dw_pci_id_table,
+	.probe		= dw_pci_probe,
+	.remove		= __devexit_p(dw_pci_remove),
+};
+
+module_pci_driver(dw_pci_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("DesignWare DMAC PCI driver");
+MODULE_AUTHOR("Heikki Krogerus <heikki.krogerus@linux.intel.com>");
+MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
-- 
1.7.10.4

