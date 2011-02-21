Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1BURfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:35:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49789 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BURfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:35:41 -0500
From: Pratheesh Gangadhar <pratheesh@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: hjk@hansjkoch.de, gregkh@suse.de, pratheesh@ti.com, amit.chatterjee@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/2] PRUSS UIO driver support
Date: Mon, 21 Feb 2011 23:05:14 +0530
Message-Id: <1298309715-21362-2-git-send-email-pratheesh@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1298309715-21362-1-git-send-email-pratheesh@ti.com>
References: <1298309715-21362-1-git-send-email-pratheesh@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements PRUSS (Programmable Real-time Unit Sub System)
UIO driver which exports SOC resources associated with PRUSS like
I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
processors which is efficient in performing embedded tasks that
require manipulation of packed memory mapped data structures and
efficient in handling system events that have tight real time
constraints. This driver is currently supported on Texas Instruments
DA850, AM18xx and OMAPL1-38 devices.
For example, PRUSS runs firmware for real-time critical industrial
communication data link layer and communicates with application stack
running in user space via shared memory and IRQs.

Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
---
 drivers/uio/Kconfig     |    9 ++
 drivers/uio/Makefile    |    1 +
 drivers/uio/uio_pruss.c |  231 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_pruss.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index bb44079..f92f20d 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -94,4 +94,13 @@ config UIO_NETX
 	  To compile this driver as a module, choose M here; the module
 	  will be called uio_netx.
 
+config UIO_PRUSS
+	tristate "Texas Instruments PRUSS driver"
+	depends on ARCH_DAVINCI_DA850
+	help
+	  PRUSS driver for OMAPL138/DA850/AM18XX devices
+	  PRUSS driver requires user space components
+	  To compile this driver as a module, choose M here: the module
+	  will be called uio_pruss.
+
 endif
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index 18fd818..d4dd9a5 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
 obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
 obj-$(CONFIG_UIO_NETX)	+= uio_netx.o
+obj-$(CONFIG_UIO_PRUSS)         += uio_pruss.o
diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
new file mode 100644
index 0000000..b402197
--- /dev/null
+++ b/drivers/uio/uio_pruss.c
@@ -0,0 +1,231 @@
+/*
+ * Programmable Real-Time Unit Sub System (PRUSS) UIO driver (uio_pruss)
+ *
+ * This driver exports PRUSS host event out interrupts and PRUSS, L3 RAM,
+ * and DDR RAM to user space for applications interacting with PRUSS firmware
+ *
+ * Copyright (C) 2010-11 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/uio_driver.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+
+#define DRV_NAME "pruss"
+#define DRV_VERSION "0.50"
+
+/*
+ * Host event IRQ numbers from PRUSS - PRUSS can generate upto 8 interrupt
+ * events to AINTC of ARM host processor - which can be used for IPC b/w PRUSS
+ * firmware and user space application, async notification from PRU firmware
+ * to user space application
+ * 3	PRU_EVTOUT0
+ * 4	PRU_EVTOUT1
+ * 5	PRU_EVTOUT2
+ * 6	PRU_EVTOUT3
+ * 7	PRU_EVTOUT4
+ * 8	PRU_EVTOUT5
+ * 9	PRU_EVTOUT6
+ * 10	PRU_EVTOUT7
+*/
+
+#define MAX_PRUSS_EVTOUT_INSTANCE	8
+
+#define	PRUSS_INTC_HIPIR		0x4900
+#define	PRUSS_INTC_HIPIR_INTPEND_MASK	0x80000000
+#define	PRUSS_INTC_HIER			0x5500
+
+struct clk *pruss_clk;
+struct uio_info *info;
+void *ddr_virt_addr;
+dma_addr_t ddr_phy_addr;
+
+static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
+{
+	void __iomem *int_enable_reg = dev_info->mem[0].internal_addr
+					+ PRUSS_INTC_HIER;
+	void __iomem *int_status_reg = dev_info->mem[0].internal_addr
+					+ PRUSS_INTC_HIPIR+((irq-1) << 2);
+	/* Is interrupt enabled and active ? */
+	if (!(ioread32(int_enable_reg) & (1<<(irq-1))) &&
+		 (ioread32(int_status_reg) & PRUSS_INTC_HIPIR_INTPEND_MASK))
+		return IRQ_NONE;
+
+	/* Disable interrupt */
+	iowrite32(ioread32(int_enable_reg) & ~(1<<(irq-1)),
+		int_enable_reg);
+	return IRQ_HANDLED;
+}
+
+static void pruss_cleanup(struct platform_device *dev, struct uio_info *info)
+{
+	int count;
+	if (info) {
+		for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
+			uio_unregister_device(&info[count]);
+			kfree(info[count].name);
+			iounmap(info[count].mem[0].internal_addr);
+
+		}
+		if (ddr_virt_addr)
+			dma_free_coherent(&dev->dev, info[0].mem[2].size,
+					  info[0].mem[2].internal_addr,
+					  info[0].mem[2].addr);
+		kfree(info);
+	}
+	if (pruss_clk != NULL)
+		clk_put(pruss_clk);
+}
+
+static int __devinit pruss_probe(struct platform_device *dev)
+{
+	int ret = -ENODEV, count = 0;
+	struct resource *regs_pruram, *regs_l3ram, *regs_ddr;
+	char *string;
+
+	/* Power on PRU in case its not done as part of boot-loader */
+	pruss_clk = clk_get(&dev->dev, "pruss");
+	if (IS_ERR(pruss_clk)) {
+		dev_err(&dev->dev, "Failed to get clock\n");
+		ret = PTR_ERR(pruss_clk);
+		return ret;
+	} else {
+		clk_enable(pruss_clk);
+	}
+
+	info = kzalloc(sizeof(struct uio_info) * MAX_PRUSS_EVTOUT_INSTANCE,
+		       GFP_KERNEL);
+	if (info == NULL)
+		return -ENOMEM;
+
+	regs_pruram = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!regs_pruram) {
+		dev_err(&dev->dev, "No memory resource specified\n");
+		goto out_free;
+	}
+
+	regs_l3ram = platform_get_resource(dev, IORESOURCE_MEM, 1);
+	if (!regs_l3ram) {
+		dev_err(&dev->dev, "No memory resource specified\n");
+		goto out_free;
+	}
+
+	regs_ddr = platform_get_resource(dev, IORESOURCE_MEM, 2);
+	if (!regs_ddr) {
+		dev_err(&dev->dev, "No memory resource specified\n");
+		goto out_free;
+	}
+	ddr_virt_addr =
+	    dma_alloc_coherent(&dev->dev, regs_ddr->end - regs_ddr->start + 1,
+			       &ddr_phy_addr, GFP_KERNEL | GFP_DMA);
+	if (!ddr_virt_addr) {
+		dev_err(&dev->dev, "Could not allocate external memory\n");
+		goto out_free;
+	}
+
+	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
+		info[count].mem[0].addr = regs_pruram->start;
+		info[count].mem[0].size =
+		    regs_pruram->end - regs_pruram->start + 1;
+		if (!info[count].mem[0].addr ||
+			!(info[count].mem[0].size - 1)) {
+			dev_err(&dev->dev, "Invalid memory resource\n");
+			goto out_free;
+		}
+		info[count].mem[0].internal_addr =
+		    ioremap(regs_pruram->start, info[count].mem[0].size);
+		if (!info[count].mem[0].internal_addr) {
+			dev_err(&dev->dev,
+				"Can't remap memory address range\n");
+			goto out_free;
+		}
+		info[count].mem[0].memtype = UIO_MEM_PHYS;
+
+		info[count].mem[1].addr = regs_l3ram->start;
+		info[count].mem[1].size =
+		    regs_l3ram->end - regs_l3ram->start + 1;
+		if (!info[count].mem[1].addr ||
+			!(info[count].mem[1].size - 1)) {
+			dev_err(&dev->dev, "Invalid memory resource\n");
+			goto out_free;
+		}
+		info[count].mem[1].memtype = UIO_MEM_PHYS;
+
+		info[count].mem[2].internal_addr = ddr_virt_addr;
+		info[count].mem[2].addr = ddr_phy_addr;
+		info[count].mem[2].size = regs_ddr->end - regs_ddr->start + 1;
+		info[count].mem[2].memtype = UIO_MEM_PHYS;
+
+		string = kzalloc(20, GFP_KERNEL);
+		sprintf(string, "pruss_evt%d", count);
+		info[count].name = string;
+		info[count].version = "0.50";
+
+		/* Register PRUSS IRQ lines */
+		info[count].irq = IRQ_DA8XX_EVTOUT0 + count;
+
+		info[count].irq_flags = 0;
+		info[count].handler = pruss_handler;
+
+		ret = uio_register_device(&dev->dev, &info[count]);
+
+		if (ret < 0)
+			goto out_free;
+	}
+
+	platform_set_drvdata(dev, info);
+	return 0;
+
+out_free:
+	pruss_cleanup(dev, info);
+	return ret;
+}
+
+static int __devexit pruss_remove(struct platform_device *dev)
+{
+	struct uio_info *info = platform_get_drvdata(dev);
+	pruss_cleanup(dev, info);
+	platform_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct platform_driver pruss_driver = {
+	.probe = pruss_probe,
+	.remove = __devexit_p(pruss_remove),
+	.driver = {
+		   .name = DRV_NAME,
+		   .owner = THIS_MODULE,
+		   },
+};
+
+static int __init pruss_init_module(void)
+{
+	return platform_driver_register(&pruss_driver);
+}
+
+module_init(pruss_init_module);
+
+static void __exit pruss_exit_module(void)
+{
+	platform_driver_unregister(&pruss_driver);
+}
+
+module_exit(pruss_exit_module);
+
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRV_VERSION);
+MODULE_AUTHOR("Amit Chatterjee <amit.chatterjee@ti.com>");
+MODULE_AUTHOR("Pratheesh Gangadhar <pratheesh@ti.com>");
-- 
1.6.0.6

