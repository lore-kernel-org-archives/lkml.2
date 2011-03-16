Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1CPVNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:13:34 -0400
Received: from kroah.org ([198.145.64.141]:60902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab1CPVMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pratheesh Gangadhar <pratheesh@ti.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/50] UIO: add PRUSS UIO driver support
Date: Wed, 16 Mar 2011 14:11:18 -0700
Message-Id: <1300309888-5028-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratheesh Gangadhar <pratheesh@ti.com>

This patch implements PRUSS (Programmable Real-time Unit Sub System)
UIO driver which exports SOC resources associated with PRUSS like
I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
processors which is efficient in performing embedded tasks that
require manipulation of packed memory mapped data structures and
handling system events that have tight real time constraints. This
driver is currently supported on Texas Instruments DA850, AM18xx and
OMAP-L138 devices.
For example, PRUSS runs firmware for real-time critical industrial
communication data link layer and communicates with application stack
running in user space via shared memory and IRQs.

Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig                     |   17 ++
 drivers/uio/Makefile                    |    1 +
 drivers/uio/uio_pruss.c                 |  247 +++++++++++++++++++++++++++++++
 include/linux/platform_data/uio_pruss.h |   25 +++
 4 files changed, 290 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_pruss.c
 create mode 100644 include/linux/platform_data/uio_pruss.h

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index bb44079..6f3ea9b 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -94,4 +94,21 @@ config UIO_NETX
 	  To compile this driver as a module, choose M here; the module
 	  will be called uio_netx.
 
+config UIO_PRUSS
+	tristate "Texas Instruments PRUSS driver"
+	depends on ARCH_DAVINCI_DA850
+	help
+	  PRUSS driver for OMAPL138/DA850/AM18XX devices
+	  PRUSS driver requires user space components, examples and user space
+	  driver is available from below SVN repo - you may use anonymous login
+
+	  https://gforge.ti.com/gf/project/pru_sw/
+
+	  More info on API is available at below wiki
+
+	  http://processors.wiki.ti.com/index.php/PRU_Linux_Application_Loader
+
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
index 0000000..daf6e77
--- /dev/null
+++ b/drivers/uio/uio_pruss.c
@@ -0,0 +1,247 @@
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
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/uio_driver.h>
+#include <linux/platform_data/uio_pruss.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <mach/sram.h>
+
+#define DRV_NAME "pruss_uio"
+#define DRV_VERSION "1.0"
+
+static int sram_pool_sz = SZ_16K;
+module_param(sram_pool_sz, int, 0);
+MODULE_PARM_DESC(sram_pool_sz, "sram pool size to allocate ");
+
+static int extram_pool_sz = SZ_256K;
+module_param(extram_pool_sz, int, 0);
+MODULE_PARM_DESC(extram_pool_sz, "external ram pool size to allocate");
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
+#define MAX_PRUSS_EVT	8
+
+#define PINTC_HIDISR	0x0038
+#define PINTC_HIPIR	0x0900
+#define HIPIR_NOPEND	0x80000000
+#define PINTC_HIER	0x1500
+
+struct uio_pruss_dev {
+	struct uio_info *info;
+	struct clk *pruss_clk;
+	dma_addr_t sram_paddr;
+	dma_addr_t ddr_paddr;
+	void __iomem *prussio_vaddr;
+	void *sram_vaddr;
+	void *ddr_vaddr;
+	unsigned int hostirq_start;
+	unsigned int pintc_base;
+};
+
+static irqreturn_t pruss_handler(int irq, struct uio_info *info)
+{
+	struct uio_pruss_dev *gdev = info->priv;
+	int intr_bit = (irq - gdev->hostirq_start + 2);
+	int val, intr_mask = (1 << intr_bit);
+	void __iomem *base = gdev->prussio_vaddr + gdev->pintc_base;
+	void __iomem *intren_reg = base + PINTC_HIER;
+	void __iomem *intrdis_reg = base + PINTC_HIDISR;
+	void __iomem *intrstat_reg = base + PINTC_HIPIR + (intr_bit << 2);
+
+	val = ioread32(intren_reg);
+	/* Is interrupt enabled and active ? */
+	if (!(val & intr_mask) && (ioread32(intrstat_reg) & HIPIR_NOPEND))
+		return IRQ_NONE;
+	/* Disable interrupt */
+	iowrite32(intr_bit, intrdis_reg);
+	return IRQ_HANDLED;
+}
+
+static void pruss_cleanup(struct platform_device *dev,
+			struct uio_pruss_dev *gdev)
+{
+	int cnt;
+	struct uio_info *p = gdev->info;
+
+	for (cnt = 0; cnt < MAX_PRUSS_EVT; cnt++, p++) {
+		uio_unregister_device(p);
+		kfree(p->name);
+	}
+	iounmap(gdev->prussio_vaddr);
+	if (gdev->ddr_vaddr) {
+		dma_free_coherent(&dev->dev, extram_pool_sz, gdev->ddr_vaddr,
+			gdev->ddr_paddr);
+	}
+	if (gdev->sram_vaddr)
+		sram_free(gdev->sram_vaddr, sram_pool_sz);
+	kfree(gdev->info);
+	clk_put(gdev->pruss_clk);
+	kfree(gdev);
+}
+
+static int __devinit pruss_probe(struct platform_device *dev)
+{
+	struct uio_info *p;
+	struct uio_pruss_dev *gdev;
+	struct resource *regs_prussio;
+	int ret = -ENODEV, cnt = 0, len;
+	struct uio_pruss_pdata *pdata = dev->dev.platform_data;
+
+	gdev = kzalloc(sizeof(struct uio_pruss_dev), GFP_KERNEL);
+	if (!gdev)
+		return -ENOMEM;
+
+	gdev->info = kzalloc(sizeof(*p) * MAX_PRUSS_EVT, GFP_KERNEL);
+	if (!gdev->info) {
+		kfree(gdev);
+		return -ENOMEM;
+	}
+	/* Power on PRU in case its not done as part of boot-loader */
+	gdev->pruss_clk = clk_get(&dev->dev, "pruss");
+	if (IS_ERR(gdev->pruss_clk)) {
+		dev_err(&dev->dev, "Failed to get clock\n");
+		kfree(gdev->info);
+		kfree(gdev);
+		ret = PTR_ERR(gdev->pruss_clk);
+		return ret;
+	} else {
+		clk_enable(gdev->pruss_clk);
+	}
+
+	regs_prussio = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!regs_prussio) {
+		dev_err(&dev->dev, "No PRUSS I/O resource specified\n");
+		goto out_free;
+	}
+
+	if (!regs_prussio->start) {
+		dev_err(&dev->dev, "Invalid memory resource\n");
+		goto out_free;
+	}
+
+	gdev->sram_vaddr = sram_alloc(sram_pool_sz, &(gdev->sram_paddr));
+	if (!gdev->sram_vaddr) {
+		dev_err(&dev->dev, "Could not allocate SRAM pool\n");
+		goto out_free;
+	}
+
+	gdev->ddr_vaddr = dma_alloc_coherent(&dev->dev, extram_pool_sz,
+				&(gdev->ddr_paddr), GFP_KERNEL | GFP_DMA);
+	if (!gdev->ddr_vaddr) {
+		dev_err(&dev->dev, "Could not allocate external memory\n");
+		goto out_free;
+	}
+
+	len = resource_size(regs_prussio);
+	gdev->prussio_vaddr = ioremap(regs_prussio->start, len);
+	if (!gdev->prussio_vaddr) {
+		dev_err(&dev->dev, "Can't remap PRUSS I/O  address range\n");
+		goto out_free;
+	}
+
+	gdev->pintc_base = pdata->pintc_base;
+	gdev->hostirq_start = platform_get_irq(dev, 0);
+
+	for (cnt = 0, p = gdev->info; cnt < MAX_PRUSS_EVT; cnt++, p++) {
+		p->mem[0].addr = regs_prussio->start;
+		p->mem[0].size = resource_size(regs_prussio);
+		p->mem[0].memtype = UIO_MEM_PHYS;
+
+		p->mem[1].addr = gdev->sram_paddr;
+		p->mem[1].size = sram_pool_sz;
+		p->mem[1].memtype = UIO_MEM_PHYS;
+
+		p->mem[2].addr = gdev->ddr_paddr;
+		p->mem[2].size = extram_pool_sz;
+		p->mem[2].memtype = UIO_MEM_PHYS;
+
+		p->name = kasprintf(GFP_KERNEL, "pruss_evt%d", cnt);
+		p->version = DRV_VERSION;
+
+		/* Register PRUSS IRQ lines */
+		p->irq = gdev->hostirq_start + cnt;
+		p->handler = pruss_handler;
+		p->priv = gdev;
+
+		ret = uio_register_device(&dev->dev, p);
+		if (ret < 0)
+			goto out_free;
+	}
+
+	platform_set_drvdata(dev, gdev);
+	return 0;
+
+out_free:
+	pruss_cleanup(dev, gdev);
+	return ret;
+}
+
+static int __devexit pruss_remove(struct platform_device *dev)
+{
+	struct uio_pruss_dev *gdev = platform_get_drvdata(dev);
+
+	pruss_cleanup(dev, gdev);
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
diff --git a/include/linux/platform_data/uio_pruss.h b/include/linux/platform_data/uio_pruss.h
new file mode 100644
index 0000000..f39140a
--- /dev/null
+++ b/include/linux/platform_data/uio_pruss.h
@@ -0,0 +1,25 @@
+/*
+ * include/linux/platform_data/uio_pruss.h
+ *
+ * Platform data for uio_pruss driver
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
+
+#ifndef _UIO_PRUSS_H_
+#define _UIO_PRUSS_H_
+
+/* To configure the PRUSS INTC base offset for UIO driver */
+struct uio_pruss_pdata {
+	u32	pintc_base;
+};
+#endif /* _UIO_PRUSS_H_ */
-- 
1.7.4.1

