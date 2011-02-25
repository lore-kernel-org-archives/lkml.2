Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1BYIqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:46:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37269 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab1BYIqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:46:07 -0500
From: Pratheesh Gangadhar <pratheesh@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: hjk@hansjkoch.de, gregkh@suse.de, tglx@linutronix.de, sshtylyov@mvista.com,
        arnd@arndb.de, pratheesh@ti.com, amit.chatterjee@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 1/2] PRUSS UIO driver support
Date: Fri, 25 Feb 2011 14:15:29 +0530
Message-Id: <1298623530-10294-2-git-send-email-pratheesh@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1298623530-10294-1-git-send-email-pratheesh@ti.com>
References: <1298623530-10294-1-git-send-email-pratheesh@ti.com>
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
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/uio/Kconfig     |   17 ++++
 drivers/uio/Makefile    |    1 +
 drivers/uio/uio_pruss.c |  217 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 235 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_pruss.c

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
index 0000000..d17d3aa
--- /dev/null
+++ b/drivers/uio/uio_pruss.c
@@ -0,0 +1,217 @@
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
+#define MAX_PRUSS_EVT			8
+
+#define	PINTC_HIPIR			0x4900
+#define	HIPIR_NOPEND			0x80000000
+#define	PINTC_HIER			0x5500
+
+static struct clk *pruss_clk;
+static struct uio_info *info;
+static dma_addr_t ddr_paddr;
+static void *ddr_vaddr, *prussio_vaddr;
+
+static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
+{
+	void __iomem *base = dev_info->mem[0].internal_addr;
+	void __iomem *intren_reg = base + PINTC_HIER;
+	void __iomem *intrstat_reg = base + PINTC_HIPIR + ((irq - 1) << 2);
+	int val = ioread32(intren_reg), intr_mask = (1 << (irq - 1));
+
+	/* Is interrupt enabled and active ? */
+	if (!(val & intr_mask) && (ioread32(intrstat_reg) & HIPIR_NOPEND))
+		return IRQ_NONE;
+
+	/* Disable interrupt */
+	iowrite32((val & ~intr_mask), intren_reg);
+	return IRQ_HANDLED;
+}
+
+static void pruss_cleanup(struct platform_device *dev, struct uio_info *info)
+{
+	struct uio_info *p = info;
+	int cnt;
+
+	for (cnt = 0; cnt < MAX_PRUSS_EVT; cnt++, p++) {
+		uio_unregister_device(p);
+		kfree(p->name);
+	}
+	iounmap(prussio_vaddr);
+	if (ddr_vaddr) {
+		dma_free_coherent(&dev->dev, info->mem[2].size,
+			info->mem[2].internal_addr, info->mem[2].addr);
+	}
+	kfree(info);
+	clk_put(pruss_clk);
+}
+
+static int __devinit pruss_probe(struct platform_device *dev)
+{
+	struct uio_info *p;
+	int ret = -ENODEV, cnt = 0, len;
+	struct resource *regs_prussio, *regs_l3ram, *regs_ddr;
+
+	info = kzalloc(sizeof(struct uio_info) * MAX_PRUSS_EVT, GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	/* Power on PRU in case its not done as part of boot-loader */
+	pruss_clk = clk_get(&dev->dev, "pruss");
+	if (IS_ERR(pruss_clk)) {
+		dev_err(&dev->dev, "Failed to get clock\n");
+		kfree(info);
+		ret = PTR_ERR(pruss_clk);
+		return ret;
+	} else {
+		clk_enable(pruss_clk);
+	}
+
+	regs_prussio = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!regs_prussio) {
+		dev_err(&dev->dev, "No PRUSS I/O resource specified\n");
+		goto out_free;
+	}
+
+	regs_l3ram = platform_get_resource(dev, IORESOURCE_MEM, 1);
+	if (!regs_l3ram) {
+		dev_err(&dev->dev, "No L3 RAM resource specified\n");
+		goto out_free;
+	}
+
+	regs_ddr = platform_get_resource(dev, IORESOURCE_MEM, 2);
+	if (!regs_ddr) {
+		dev_err(&dev->dev, "No External RAM resource specified\n");
+		goto out_free;
+	}
+
+	if (!regs_prussio->start || !regs_l3ram->start) {
+		dev_err(&dev->dev, "Invalid memory resource\n");
+		goto out_free;
+	}
+	len = resource_size(regs_ddr);
+	ddr_vaddr = dma_alloc_coherent(&dev->dev, len, &ddr_paddr,
+				GFP_KERNEL | GFP_DMA);
+	if (!ddr_vaddr) {
+		dev_err(&dev->dev, "Could not allocate external memory\n");
+		goto out_free;
+	}
+	len = resource_size(regs_prussio);
+	prussio_vaddr = ioremap(regs_prussio->start, len);
+	if (!prussio_vaddr) {
+		dev_err(&dev->dev, "Can't remap PRUSS I/O  address range\n");
+		goto out_free;
+	}
+
+	for (cnt = 0, p = info; cnt < MAX_PRUSS_EVT; cnt++, p++) {
+		p->mem[0].internal_addr = prussio_vaddr;
+		p->mem[0].addr = regs_prussio->start;
+		p->mem[0].size = resource_size(regs_prussio);
+		p->mem[0].memtype = UIO_MEM_PHYS;
+
+		p->mem[1].addr = regs_l3ram->start;
+		p->mem[1].size = resource_size(regs_l3ram);
+		p->mem[1].memtype = UIO_MEM_PHYS;
+
+		p->mem[2].internal_addr = ddr_vaddr;
+		p->mem[2].addr = ddr_paddr;
+		p->mem[2].size = resource_size(regs_ddr);
+		p->mem[2].memtype = UIO_MEM_PHYS;
+
+		p->name = kasprintf(GFP_KERNEL, "pruss_evt%d", cnt);
+		p->version = "0.50";
+
+		/* Register PRUSS IRQ lines */
+		p->irq = IRQ_DA8XX_EVTOUT0 + cnt;
+		p->handler = pruss_handler;
+
+		ret = uio_register_device(&dev->dev, p);
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
+
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

