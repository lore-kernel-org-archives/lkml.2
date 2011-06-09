Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1FITYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:24:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59617 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab1FITWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EYwIjpFLL0y2ObSPSlaaTMHWGquswSEE50uTxFPy9i6UW8KQ2OSuTD8YpimRd8gwr1
         BakVpVRcrEFZEcrYc02d9AdlLe7fwNaoVcNB/77j9D4S+EVU4jtsAyDoQSCNULNu0h6k
         2ts9mSj2W5gwe9JOZ1grc8GsJRNwx//rL8nUg=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 11/13] i2c-designware: Add support for Designware core behind PCI devices.
Date: Thu,  9 Jun 2011 12:21:48 -0700
Message-Id: <1307647310-24332-12-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/Kconfig                 |   10 +
 drivers/i2c/busses/Makefile                |    2 +
 drivers/i2c/busses/i2c-designware-core.h   |    1 +
 drivers/i2c/busses/i2c-designware-pcidrv.c |  316 ++++++++++++++++++++++++++++
 4 files changed, 329 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-designware-pcidrv.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index e6f6e88..1d7ce9c 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -360,6 +360,16 @@ config I2C_DESIGNWARE_PLATFORM
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-designware-platform.
 
+config I2C_DESIGNWARE_PCI
+	tristate "Synopsys DesignWare PCI"
+	depends on PCI
+	help
+	  If you say yes to this option, support will be included for the
+	  Synopsys DesignWare I2C adapter. Only master mode is supported.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-designware-pci.
+
 config I2C_GPIO
 	tristate "GPIO-based bitbanging I2C"
 	depends on GENERIC_GPIO
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index d7fe55f..fba6da6 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -35,6 +35,8 @@ obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
 obj-$(CONFIG_I2C_DESIGNWARE_PLATFORM)	+= i2c-designware-platform.o
 i2c-designware-platform-objs := i2c-designware-platdrv.o i2c-designware-core.o
+obj-$(CONFIG_I2C_DESIGNWARE_PCI)	+= i2c-designware-pci.o
+i2c-designware-pci-objs := i2c-designware-pcidrv.o i2c-designware-core.o
 obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
 obj-$(CONFIG_I2C_HIGHLANDER)	+= i2c-highlander.o
 obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 697f12c..6450a6a 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -68,6 +68,7 @@ struct dw_i2c_dev {
 	struct mutex		lock;
 	struct clk		*clk;
 	u32			(*get_clk_rate_khz) (struct dw_i2c_dev *dev);
+	struct dw_pci_controller *controller;
 	int			cmd_err;
 	struct i2c_msg		*msgs;
 	int			msgs_num;
diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
new file mode 100644
index 0000000..83307ef
--- /dev/null
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -0,0 +1,316 @@
+/*
+ * Synopsys DesignWare I2C adapter driver (master only).
+ *
+ * Based on the TI DAVINCI I2C adapter driver.
+ *
+ * Copyright (C) 2006 Texas Instruments.
+ * Copyright (C) 2007 MontaVista Software Inc.
+ * Copyright (C) 2009 Provigent Ltd.
+ * Copyright (C) 2011 Intel corporation.
+ *
+ * ----------------------------------------------------------------------------
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * ----------------------------------------------------------------------------
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include "i2c-designware-core.h"
+
+#define DRIVER_NAME "i2c-designware-pci"
+
+enum dw_pci_ctl_id_t {
+	moorestown_0,
+	moorestown_1,
+	moorestown_2,
+
+	medfield_0,
+	medfield_1,
+	medfield_2,
+	medfield_3,
+	medfield_4,
+	medfield_5,
+};
+
+struct dw_pci_controller {
+	u32 bus_num;
+	u32 bus_cfg;
+	u32 tx_fifo_depth;
+	u32 rx_fifo_depth;
+	u32 clk_khz;
+};
+
+#define INTEL_MID_STD_CFG  (DW_IC_CON_MASTER |			\
+				DW_IC_CON_SLAVE_DISABLE |	\
+				DW_IC_CON_RESTART_EN)
+
+static struct  dw_pci_controller  dw_pci_controllers[] = {
+	[moorestown_0] = {
+		.bus_num     = 0,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[moorestown_1] = {
+		.bus_num     = 1,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[moorestown_2] = {
+		.bus_num     = 2,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[medfield_0] = {
+		.bus_num     = 0,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[medfield_1] = {
+		.bus_num     = 1,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[medfield_2] = {
+		.bus_num     = 2,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[medfield_3] = {
+		.bus_num     = 3,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_STD,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[medfield_4] = {
+		.bus_num     = 4,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[medfield_5] = {
+		.bus_num     = 5,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+};
+static struct i2c_algorithm i2c_dw_algo = {
+	.master_xfer	= i2c_dw_xfer,
+	.functionality	= i2c_dw_func,
+};
+
+static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
+{
+	return dev->controller->clk_khz;
+}
+
+static int __devinit i2c_dw_pci_probe(struct pci_dev *pdev,
+const struct pci_device_id *id)
+{
+	struct dw_i2c_dev *dev;
+	struct i2c_adapter *adap;
+	unsigned long start, len;
+	void __iomem *base;
+	int r;
+	struct  dw_pci_controller *controller;
+
+	if (id->driver_data >= ARRAY_SIZE(dw_pci_controllers)) {
+		printk(KERN_ERR "dw_i2c_pci_probe: invalid driver data %ld\n",
+			id->driver_data);
+		return -EINVAL;
+	}
+
+	controller = &dw_pci_controllers[id->driver_data];
+
+	r = pci_enable_device(pdev);
+	if (r) {
+		dev_err(&pdev->dev, "Failed to enable I2C PCI device (%d)\n",
+			r);
+		goto exit;
+	}
+
+	/* Determine the address of the I2C area */
+	start = pci_resource_start(pdev, 0);
+	len = pci_resource_len(pdev, 0);
+	if (!start || len == 0) {
+		dev_err(&pdev->dev, "base address not set\n");
+		r = -ENODEV;
+		goto exit;
+	}
+
+	r = pci_request_region(pdev, 0, DRIVER_NAME);
+	if (r) {
+		dev_err(&pdev->dev, "failed to request I2C region "
+			"0x%lx-0x%lx\n", start,
+			(unsigned long)pci_resource_end(pdev, 0));
+		goto exit;
+	}
+
+	base = ioremap_nocache(start, len);
+	if (!base) {
+		dev_err(&pdev->dev, "I/O memory remapping failed\n");
+		r = -ENOMEM;
+		goto err_release_region;
+	}
+
+
+	dev = kzalloc(sizeof(struct dw_i2c_dev), GFP_KERNEL);
+	if (!dev) {
+		r = -ENOMEM;
+		goto err_release_region;
+	}
+
+	init_completion(&dev->cmd_complete);
+	mutex_init(&dev->lock);
+	dev->clk = NULL;
+	dev->controller = controller;
+	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
+	dev->base = base;
+	dev->dev = get_device(&pdev->dev);
+	dev->functionality =
+		I2C_FUNC_I2C |
+		I2C_FUNC_SMBUS_BYTE |
+		I2C_FUNC_SMBUS_BYTE_DATA |
+		I2C_FUNC_SMBUS_WORD_DATA |
+		I2C_FUNC_SMBUS_I2C_BLOCK;
+	dev->master_cfg =  controller->bus_cfg;
+
+	pci_set_drvdata(pdev, dev);
+
+	dev->tx_fifo_depth = controller->tx_fifo_depth;
+	dev->rx_fifo_depth = controller->rx_fifo_depth;
+	r = i2c_dw_init(dev);
+	if (r)
+		goto err_iounmap;
+
+	adap = &dev->adapter;
+	i2c_set_adapdata(adap, dev);
+	adap->owner = THIS_MODULE;
+	adap->class = 0;
+	adap->algo = &i2c_dw_algo;
+	adap->dev.parent = &pdev->dev;
+	adap->nr = controller->bus_num;
+	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci-%d",
+		adap->nr);
+
+	r = request_irq(pdev->irq, i2c_dw_isr, IRQF_SHARED, adap->name, dev);
+	if (r) {
+		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
+		goto err_iounmap;
+	}
+
+	i2c_dw_disable_int(dev);
+	i2c_dw_clear_int(dev);
+	r = i2c_add_numbered_adapter(adap);
+	if (r) {
+		dev_err(&pdev->dev, "failure adding adapter\n");
+		goto err_free_irq;
+	}
+
+	return 0;
+
+err_free_irq:
+	free_irq(pdev->irq, dev);
+err_iounmap:
+	iounmap(dev->base);
+	pci_set_drvdata(pdev, NULL);
+	put_device(&pdev->dev);
+	kfree(dev);
+err_release_region:
+	pci_release_region(pdev, 0);
+exit:
+	return r;
+}
+
+static void __devexit i2c_dw_pci_remove(struct pci_dev *pdev)
+{
+	struct dw_i2c_dev *dev = pci_get_drvdata(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+	i2c_del_adapter(&dev->adapter);
+	put_device(&pdev->dev);
+
+	free_irq(dev->irq, dev);
+	kfree(dev);
+	pci_release_region(pdev, 0);
+}
+
+/* work with hotplug and coldplug */
+MODULE_ALIAS("i2c_designware-pci");
+
+DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
+	/* Moorestown */
+	{ PCI_VDEVICE(INTEL, 0x0802), moorestown_0 },
+	{ PCI_VDEVICE(INTEL, 0x0803), moorestown_1 },
+	{ PCI_VDEVICE(INTEL, 0x0804), moorestown_2 },
+	/* Medfield */
+	{ PCI_VDEVICE(INTEL, 0x0817), medfield_3,},
+	{ PCI_VDEVICE(INTEL, 0x0818), medfield_4 },
+	{ PCI_VDEVICE(INTEL, 0x0819), medfield_5 },
+	{ PCI_VDEVICE(INTEL, 0x082C), medfield_0 },
+	{ PCI_VDEVICE(INTEL, 0x082D), medfield_1 },
+	{ PCI_VDEVICE(INTEL, 0x082E), medfield_2 },
+	{ 0,}
+};
+MODULE_DEVICE_TABLE(pci, i2_designware_pci_ids);
+
+static struct pci_driver dw_i2c_driver = {
+	.name		= DRIVER_NAME,
+	.id_table	= i2_designware_pci_ids,
+	.probe		= i2c_dw_pci_probe,
+	.remove		= __devexit_p(i2c_dw_pci_remove),
+};
+
+static int __init dw_i2c_init_driver(void)
+{
+	return  pci_register_driver(&dw_i2c_driver);
+}
+module_init(dw_i2c_init_driver);
+
+static void __exit dw_i2c_exit_driver(void)
+{
+	pci_unregister_driver(&dw_i2c_driver);
+}
+module_exit(dw_i2c_exit_driver);
+
+MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
+MODULE_DESCRIPTION("Synopsys DesignWare PCI I2C bus adapter");
+MODULE_LICENSE("GPL");
-- 
1.7.3.4

