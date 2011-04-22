Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1DVLsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:48:47 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42830 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1DVLso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:48:44 -0400
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Samuel Ortiz <sameo@linux.intel.com> (supporter:MULTIFUNCTION
	DEV...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Fri, 22 Apr 2011 17:38:19 +0530
Message-Id: <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pruss MFD driver and associated include files.
For details regarding the PRUSS please refer the folowing link:
http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem

The rational behind the MFD driver being the fact that multiple devices can
be implemented on the cores independently. This is determined by the nature
of the program which is loaded into the PRU's instruction memory.
A device may be de-initialized and another loaded or two different devices
can be run simultaneously on the two cores.
It's also possible, as in our case, to implement a single device on both
the PRU's resulting in improved load sharing.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 drivers/mfd/Kconfig            |   10 +
 drivers/mfd/Makefile           |    1 +
 drivers/mfd/pruss.c            |  513 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/pruss.h      |  130 ++++++++++
 include/linux/mfd/pruss_core.h |  128 ++++++++++
 5 files changed, 782 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/pruss.c
 create mode 100644 include/linux/mfd/pruss.h
 create mode 100644 include/linux/mfd/pruss_core.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0284c53..41479e4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -92,6 +92,16 @@ config MFD_TI_SSP
 	  To compile this driver as a module, choose M here: the
 	  module will be called ti-ssp.
 
+config MFD_DA8XX_PRUSS
+	tristate "Texas Instruments DA8XX PRUSS support"
+	depends on ARCH_DAVINCI_DA850
+	select MFD_CORE
+	help
+	  This driver provides support API for the programmable
+	  realtime unit (PRU) present on TI's da8xx processors. It
+	  provides basic read, write, config, enable, disable
+	  routines to facilitate devices emulated on it.
+
 config HTC_EGPIO
 	bool "HTC EGPIO support"
 	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c56b6c7..8015dea 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
 obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
 
 obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
+obj-$(CONFIG_MFD_DA8XX_PRUSS)	+= pruss.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
 
diff --git a/drivers/mfd/pruss.c b/drivers/mfd/pruss.c
new file mode 100644
index 0000000..6836d5a
--- /dev/null
+++ b/drivers/mfd/pruss.c
@@ -0,0 +1,513 @@
+/*
+ * Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/mfd/pruss.h>
+#include <linux/mfd/core.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+
+struct pruss_priv {
+	struct device *dev;
+	spinlock_t lock;
+	struct resource *res;
+	struct clk *clk;
+	void __iomem *ioaddr;
+};
+
+s32 pruss_disable(struct device *dev, u8 pruss_num)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	struct prusscore_regs __iomem *h_pruss;
+	struct pruss_map __iomem *pruss_mmap = pruss->ioaddr;
+	u32 temp_reg;
+
+	if ((pruss_num != PRUCORE_0) && (pruss_num != PRUCORE_1))
+		return -EINVAL;
+
+	spin_lock(&pruss->lock);
+
+	/* pruss deinit */
+	iowrite32(0xFFFFFFFF, &pruss_mmap->intc.statclrint[pruss_num]);
+
+	/* Disable PRU */
+	h_pruss = &pruss_mmap->core[pruss_num];
+	temp_reg = ioread32(&h_pruss->control);
+	temp_reg = (temp_reg &
+			~PRUCORE_CONTROL_COUNTENABLE_MASK) |
+			((PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
+			PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
+			PRUCORE_CONTROL_COUNTENABLE_MASK);
+	iowrite32(temp_reg, &h_pruss->control);
+
+	temp_reg = ioread32(&h_pruss->control);
+	temp_reg = (temp_reg &
+		~PRUCORE_CONTROL_ENABLE_MASK) |
+		((PRUCORE_CONTROL_ENABLE_DISABLE <<
+		PRUCORE_CONTROL_ENABLE_SHIFT) &
+		PRUCORE_CONTROL_ENABLE_MASK);
+	iowrite32(temp_reg, &h_pruss->control);
+
+	/* Reset PRU */
+	iowrite32(PRUCORE_CONTROL_RESETVAL,
+				&h_pruss->control);
+	spin_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_disable);
+
+s32 pruss_enable(struct device *dev, u8 pruss_num)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	struct prusscore_regs __iomem *h_pruss;
+	struct pruss_map __iomem *pruss_mmap = pruss->ioaddr;
+	u32 i;
+
+	if ((pruss_num != PRUCORE_0) && (pruss_num != PRUCORE_1))
+		return -EINVAL;
+
+	h_pruss = &pruss_mmap->core[pruss_num];
+
+	/* Reset PRU  */
+	spin_lock(&pruss->lock);
+	iowrite32(PRUCORE_CONTROL_RESETVAL, &h_pruss->control);
+	spin_unlock(&pruss->lock);
+
+	/* Reset any garbage in the ram */
+	if (pruss_num == PRUCORE_0)
+		for (i = 0; i < PRUSS_PRU0_RAM_SZ; i++)
+			iowrite32(0x0, &pruss_mmap->dram0[i]);
+	else if (pruss_num == PRUCORE_1)
+		for (i = 0; i < PRUSS_PRU1_RAM_SZ; i++)
+			iowrite32(0x0, &pruss_mmap->dram1[i]);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_enable);
+
+/* Load the specified PRU with code */
+s32 pruss_load(struct device *dev, u8 pruss_num,
+			u32 *pruss_code, u32 code_size_in_words)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	struct pruss_map __iomem *pruss_mmap = pruss->ioaddr;
+	u32 __iomem *pruss_iram;
+	u32 i;
+
+	if (pruss_num == PRUCORE_0)
+		pruss_iram = (u32 __iomem *)&pruss_mmap->iram0;
+	else if (pruss_num == PRUCORE_1)
+		pruss_iram = (u32 __iomem *)&pruss_mmap->iram1;
+	else
+		return -EINVAL;
+
+	pruss_enable(dev, pruss_num);
+
+	spin_lock(&pruss->lock);
+	/* Copy dMAX code to its instruction RAM  */
+	for (i = 0; i < code_size_in_words; i++)
+		iowrite32(pruss_code[i], (pruss_iram + i));
+
+	spin_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_load);
+
+s32 pruss_run(struct device *dev, u8 pruss_num)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	struct prusscore_regs __iomem *h_pruss;
+	struct pruss_map __iomem *pruss_mmap = pruss->ioaddr;
+	u32 temp_reg;
+
+	if ((pruss_num != PRUCORE_0) && (pruss_num != PRUCORE_1))
+		return -EINVAL;
+
+	h_pruss = &pruss_mmap->core[pruss_num];
+
+	/* Enable dMAX, let it execute the code we just copied */
+	spin_lock(&pruss->lock);
+	temp_reg = ioread32(&h_pruss->control);
+	temp_reg = (temp_reg &
+			~PRUCORE_CONTROL_COUNTENABLE_MASK) |
+			((PRUCORE_CONTROL_COUNTENABLE_ENABLE <<
+			PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
+			PRUCORE_CONTROL_COUNTENABLE_MASK);
+	iowrite32(temp_reg, &h_pruss->control);
+
+	temp_reg = ioread32(&h_pruss->control);
+	temp_reg = (temp_reg &
+			~PRUCORE_CONTROL_ENABLE_MASK) |
+			((PRUCORE_CONTROL_ENABLE_ENABLE <<
+			PRUCORE_CONTROL_ENABLE_SHIFT) &
+			PRUCORE_CONTROL_ENABLE_MASK);
+	iowrite32(temp_reg, &h_pruss->control);
+	spin_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_run);
+
+s32 pruss_wait_for_halt(struct device *dev, u8 pruss_num, u32 timeout)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	struct prusscore_regs __iomem *h_pruss;
+	struct pruss_map __iomem *pruss_mmap = pruss->ioaddr;
+	u32 temp_reg;
+	u32 cnt = timeout;
+
+	if ((pruss_num != PRUCORE_0) && (pruss_num != PRUCORE_1))
+		return -EINVAL;
+
+	h_pruss = &pruss_mmap->core[pruss_num];
+
+	while (cnt--) {
+		temp_reg = ioread32(&h_pruss->control);
+		if (((temp_reg & PRUCORE_CONTROL_RUNSTATE_MASK) >>
+				PRUCORE_CONTROL_RUNSTATE_SHIFT) ==
+				PRUCORE_CONTROL_RUNSTATE_HALT)
+			break;
+	}
+	if (!cnt)
+		return -EBUSY;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_wait_for_halt);
+
+s32 pruss_writeb(struct device *dev, u32 offset, u8 pdatatowrite)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddresstowrite;
+
+	paddresstowrite = pruss->ioaddr + offset;
+	iowrite8(pdatatowrite, paddresstowrite);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_writeb);
+
+s32 pruss_rmwb(struct device *dev, u32 offset, u8 mask, u8 val)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddress;
+	u32 preg_data;
+
+	paddress = pruss->ioaddr + offset;
+
+	spin_lock(&pruss->lock);
+	preg_data = ioread8(paddress);
+	preg_data &= ~mask;
+	preg_data |= val;
+	iowrite8(preg_data, paddress);
+	spin_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_rmwb);
+
+s32 pruss_readb(struct device *dev, u32 offset, u8 *pdatatoread)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddresstoread;
+
+	paddresstoread = pruss->ioaddr + offset ;
+	*pdatatoread = ioread8(paddresstoread);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_readb);
+
+s32 pruss_readb_multi(struct device *dev, u32 offset,
+		u8 *pdatatoread, u16 bytestoread)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	u8 __iomem *paddresstoread;
+	u16 i;
+
+	paddresstoread = pruss->ioaddr + offset;
+
+	for (i = 0; i < bytestoread; i++)
+		*pdatatoread++ = ioread8(paddresstoread++);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_readb_multi);
+
+s32 pruss_writel(struct device *dev, u32 offset,
+		u32 pdatatowrite)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddresstowrite;
+
+	paddresstowrite = pruss->ioaddr + offset;
+	iowrite32(pdatatowrite, paddresstowrite);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_writel);
+
+s32 pruss_writel_multi(struct device *dev, u32 offset,
+		u32 *pdatatowrite, u16 wordstowrite)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	u32 __iomem *paddresstowrite;
+	u16 i;
+
+	paddresstowrite = pruss->ioaddr + offset;
+
+	for (i = 0; i < wordstowrite; i++)
+		iowrite32(*pdatatowrite++, paddresstowrite++);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_writel_multi);
+
+s32 pruss_rmwl(struct device *dev, u32 offset, u32 mask, u32 val)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddress;
+	u32 preg_data;
+
+	paddress = pruss->ioaddr + offset;
+
+	spin_lock(&pruss->lock);
+	preg_data = ioread32(paddress);
+	preg_data &= ~mask;
+	preg_data |= val;
+	iowrite32(preg_data, paddress);
+	spin_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_rmwl);
+
+s32 pruss_readl(struct device *dev, u32 offset, u32 *pdatatoread)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddresstoread;
+
+	paddresstoread = pruss->ioaddr + offset;
+	*pdatatoread = ioread32(paddresstoread);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_readl);
+
+s32 pruss_readl_multi(struct device *dev, u32 offset,
+		u32 *pdatatoread, u16 wordstoread)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	u32 __iomem *paddresstoread;
+	u16 i;
+
+	paddresstoread = pruss->ioaddr + offset;
+	for (i = 0; i < wordstoread; i++)
+		*pdatatoread++ = ioread32(paddresstoread++);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_readl_multi);
+
+s32 pruss_writew(struct device *dev, u32 offset, u16 pdatatowrite)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddresstowrite;
+
+	paddresstowrite = pruss->ioaddr + offset;
+	iowrite16(pdatatowrite, paddresstowrite);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_writew);
+
+s32 pruss_rmww(struct device *dev, u32 offset, u16 mask, u16 val)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddress;
+	u32 preg_data;
+
+	paddress = pruss->ioaddr + offset;
+
+	spin_lock(&pruss->lock);
+	preg_data = ioread16(paddress);
+	preg_data &= ~mask;
+	preg_data |= val;
+	iowrite16(preg_data, paddress);
+	spin_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_rmww);
+
+s32 pruss_readw(struct device *dev, u32 offset, u16 *pdatatoread)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddresstoread;
+
+	paddresstoread = pruss->ioaddr + offset;
+	*pdatatoread = ioread16(paddresstoread);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_readw);
+
+s32 pruss_idx_writel(struct device *dev, u32 offset, u32 value)
+{
+	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
+	void __iomem *paddresstowrite;
+
+	paddresstowrite = pruss->ioaddr + offset;
+	iowrite32(value, paddresstowrite);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_idx_writel);
+
+static int pruss_mfd_add_devices(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mfd_cell *cell = pdev->dev.platform_data;
+	s32 err, i, num_devices = 0;
+
+	for (i = 0; cell[i].name; i++) {
+		err = mfd_add_devices(dev, 0, &cell[i], 1, NULL, 0);
+		if (err) {
+			dev_err(dev, "cannot add mfd cell: %s\n",
+						cell[i].name);
+			continue;
+		}
+		num_devices++;
+		dev_info(dev, "mfd: added %s device\n", cell[i].name);
+	}
+
+	return num_devices;
+}
+
+static int __devinit pruss_probe(struct platform_device *pdev)
+{
+	struct pruss_priv *pruss_dev = NULL;
+	s32 err;
+
+	pruss_dev = kzalloc(sizeof(struct pruss_priv), GFP_KERNEL);
+	if (!pruss_dev)
+		return -ENOMEM;
+
+	pruss_dev->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pruss_dev->res) {
+		dev_err(&pdev->dev,
+		"unable to get pruss memory resources!\n");
+		err = -ENODEV;
+		goto probe_exit_kfree;
+	}
+
+	if (!request_mem_region(pruss_dev->res->start,
+		resource_size(pruss_dev->res), dev_name(&pdev->dev))) {
+		dev_err(&pdev->dev, "pruss memory region already claimed!\n");
+		err = -EBUSY;
+		goto probe_exit_kfree;
+	}
+
+	pruss_dev->ioaddr = ioremap(pruss_dev->res->start,
+	resource_size(pruss_dev->res));
+	if (!pruss_dev->ioaddr) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		err = -ENOMEM;
+		goto probe_exit_free_region;
+	}
+
+	pruss_dev->clk = clk_get(NULL, "pruss");
+	if (IS_ERR(pruss_dev->clk)) {
+		dev_err(&pdev->dev, "no clock available: pruss\n");
+		err = -ENODEV;
+		pruss_dev->clk = NULL;
+		goto probe_exit_iounmap;
+	}
+	spin_lock_init(&pruss_dev->lock);
+
+	clk_enable(pruss_dev->clk);
+
+	err = pruss_mfd_add_devices(pdev);
+	if (!err)
+		goto probe_exit_clock;
+
+	platform_set_drvdata(pdev, pruss_dev);
+	pruss_dev->dev = &pdev->dev;
+	return 0;
+
+probe_exit_clock:
+	clk_put(pruss_dev->clk);
+	clk_disable(pruss_dev->clk);
+probe_exit_iounmap:
+	iounmap(pruss_dev->ioaddr);
+probe_exit_free_region:
+	release_mem_region(pruss_dev->res->start,
+			resource_size(pruss_dev->res));
+probe_exit_kfree:
+	kfree(pruss_dev);
+	return err;
+}
+
+static int __devexit pruss_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct pruss_priv *pruss = dev_get_drvdata(dev);
+
+	mfd_remove_devices(dev);
+	pruss_disable(dev, PRUCORE_0);
+	pruss_disable(dev, PRUCORE_1);
+	clk_disable(pruss->clk);
+	clk_put(pruss->clk);
+	iounmap(pruss->ioaddr);
+	release_mem_region(pruss->res->start, resource_size(pruss->res));
+	kfree(pruss);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct platform_driver pruss_driver = {
+	.probe	= pruss_probe,
+	.remove	= __devexit_p(pruss_remove),
+	.driver	= {
+		.name	= "pruss_mfd",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init pruss_init(void)
+{
+	return platform_driver_register(&pruss_driver);
+}
+module_init(pruss_init);
+
+static void __exit pruss_exit(void)
+{
+	platform_driver_unregister(&pruss_driver);
+}
+module_exit(pruss_exit);
+
+MODULE_DESCRIPTION("Programmable Realtime Unit (PRU) Driver");
+MODULE_AUTHOR("Subhasish Ghosh");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/pruss.h b/include/linux/mfd/pruss.h
new file mode 100644
index 0000000..8ef25b3
--- /dev/null
+++ b/include/linux/mfd/pruss.h
@@ -0,0 +1,130 @@
+/*
+ * Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _PRUSS_H_
+#define _PRUSS_H_
+
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include "pruss_core.h"
+
+#define PRUSS_NUM0			PRUCORE_0
+#define PRUSS_NUM1			PRUCORE_1
+
+#define PRUSS_PRU0_RAM_SZ		512
+#define PRUSS_PRU1_RAM_SZ		512
+#define PRUSS_PRU0_BASE_ADDRESS		0
+#define PRUSS_PRU1_BASE_ADDRESS		0x2000
+#define PRUSS_INTC_BASE_ADDRESS		(PRUSS_PRU0_BASE_ADDRESS + 0x4000)
+#define PRUSS_INTC_GLBLEN		(PRUSS_INTC_BASE_ADDRESS + 0x10)
+#define PRUSS_INTC_GLBLNSTLVL		(PRUSS_INTC_BASE_ADDRESS + 0x1C)
+#define PRUSS_INTC_STATIDXSET		(PRUSS_INTC_BASE_ADDRESS + 0x20)
+#define PRUSS_INTC_STATIDXCLR		(PRUSS_INTC_BASE_ADDRESS + 0x24)
+#define PRUSS_INTC_ENIDXSET		(PRUSS_INTC_BASE_ADDRESS + 0x28)
+#define PRUSS_INTC_ENIDXCLR		(PRUSS_INTC_BASE_ADDRESS + 0x2C)
+#define PRUSS_INTC_HSTINTENIDXSET	(PRUSS_INTC_BASE_ADDRESS + 0x34)
+#define PRUSS_INTC_HSTINTENIDXCLR	(PRUSS_INTC_BASE_ADDRESS + 0x38)
+#define PRUSS_INTC_GLBLPRIIDX		(PRUSS_INTC_BASE_ADDRESS + 0x80)
+#define PRUSS_INTC_STATSETINT0		(PRUSS_INTC_BASE_ADDRESS + 0x200)
+#define PRUSS_INTC_STATSETINT1		(PRUSS_INTC_BASE_ADDRESS + 0x204)
+#define PRUSS_INTC_STATCLRINT0		(PRUSS_INTC_BASE_ADDRESS + 0x280)
+#define PRUSS_INTC_STATCLRINT1		(PRUSS_INTC_BASE_ADDRESS + 0x284)
+#define PRUSS_INTC_ENABLESET0		(PRUSS_INTC_BASE_ADDRESS + 0x300)
+#define PRUSS_INTC_ENABLESET1		(PRUSS_INTC_BASE_ADDRESS + 0x304)
+#define PRUSS_INTC_ENABLECLR0		(PRUSS_INTC_BASE_ADDRESS + 0x380)
+#define PRUSS_INTC_ENABLECLR1		(PRUSS_INTC_BASE_ADDRESS + 0x384)
+#define PRUSS_INTC_CHANMAP0		(PRUSS_INTC_BASE_ADDRESS + 0x400)
+#define PRUSS_INTC_CHANMAP1		(PRUSS_INTC_BASE_ADDRESS + 0x404)
+#define PRUSS_INTC_CHANMAP2		(PRUSS_INTC_BASE_ADDRESS + 0x408)
+#define PRUSS_INTC_CHANMAP3		(PRUSS_INTC_BASE_ADDRESS + 0x40C)
+#define PRUSS_INTC_CHANMAP4		(PRUSS_INTC_BASE_ADDRESS + 0x410)
+#define PRUSS_INTC_CHANMAP5		(PRUSS_INTC_BASE_ADDRESS + 0x414)
+#define PRUSS_INTC_CHANMAP6		(PRUSS_INTC_BASE_ADDRESS + 0x418)
+#define PRUSS_INTC_CHANMAP7		(PRUSS_INTC_BASE_ADDRESS + 0x41C)
+#define PRUSS_INTC_CHANMAP8		(PRUSS_INTC_BASE_ADDRESS + 0x420)
+#define PRUSS_INTC_CHANMAP9		(PRUSS_INTC_BASE_ADDRESS + 0x424)
+#define PRUSS_INTC_CHANMAP10		(PRUSS_INTC_BASE_ADDRESS + 0x428)
+#define PRUSS_INTC_CHANMAP11		(PRUSS_INTC_BASE_ADDRESS + 0x42C)
+#define PRUSS_INTC_CHANMAP12		(PRUSS_INTC_BASE_ADDRESS + 0x430)
+#define PRUSS_INTC_CHANMAP13		(PRUSS_INTC_BASE_ADDRESS + 0x434)
+#define PRUSS_INTC_CHANMAP14		(PRUSS_INTC_BASE_ADDRESS + 0x438)
+#define PRUSS_INTC_CHANMAP15		(PRUSS_INTC_BASE_ADDRESS + 0x43C)
+#define PRUSS_INTC_HOSTMAP0		(PRUSS_INTC_BASE_ADDRESS + 0x800)
+#define PRUSS_INTC_HOSTMAP1		(PRUSS_INTC_BASE_ADDRESS + 0x804)
+#define PRUSS_INTC_HOSTMAP2		(PRUSS_INTC_BASE_ADDRESS + 0x808)
+#define PRUSS_INTC_POLARITY0		(PRUSS_INTC_BASE_ADDRESS + 0xD00)
+#define PRUSS_INTC_POLARITY1		(PRUSS_INTC_BASE_ADDRESS + 0xD04)
+#define PRUSS_INTC_TYPE0		(PRUSS_INTC_BASE_ADDRESS + 0xD80)
+#define PRUSS_INTC_TYPE1		(PRUSS_INTC_BASE_ADDRESS + 0xD84)
+#define PRUSS_INTC_HOSTINTEN		(PRUSS_INTC_BASE_ADDRESS + 0x1500)
+#define PRUSS_INTC_HOSTINTLVL_MAX	9
+
+#define PRU_INTC_HOSTMAP0_CHAN		(0x03020100)
+#define PRU_INTC_HOSTMAP1_CHAN		(0x07060504)
+#define PRU_INTC_HOSTMAP2_CHAN		(0x00000908)
+
+#define PRU_INTC_CHANMAP7_SYS_EVT31	(0x00000000)
+#define PRU_INTC_CHANMAP8_FULL		(0x02020100)
+#define PRU_INTC_CHANMAP9_FULL		(0x04040303)
+#define PRU_INTC_CHANMAP10_FULL		(0x06060505)
+#define PRU_INTC_CHANMAP11_FULL		(0x08080707)
+#define PRU_INTC_CHANMAP12_FULL		(0x00010909)
+#define PRU_INTC_CHANMAP8_HALF		(0x03020100)
+#define PRU_INTC_CHANMAP9_HALF		(0x07060504)
+#define PRU_INTC_CHANMAP10_HALF		(0x03020908)
+#define PRU_INTC_CHANMAP11_HALF		(0x07060504)
+#define PRU_INTC_CHANMAP12_HALF		(0x00010908)
+#define PRU_INTC_REGMAP_MASK		(0xFFFFFFFF)
+
+s32 pruss_enable(struct device *dev, u8 pruss_num);
+
+s32 pruss_load(struct device *dev, u8 pruss_num,
+	u32 *pruss_code, u32 code_size_in_words);
+
+s32 pruss_run(struct device *dev, u8 pruss_num);
+
+s32 pruss_wait_for_halt(struct device *dev, u8 pruss_num, u32 timeout);
+
+s32 pruss_disable(struct device *dev, u8 pruss_num);
+
+s32 pruss_writeb(struct device *dev, u32 offset, u8 pdatatowrite);
+
+s32 pruss_rmwb(struct device *dev, u32 offset, u8 mask, u8 val);
+
+s32 pruss_readb(struct device *dev, u32 offset, u8 *pdatatoread);
+
+s32 pruss_readb_multi(struct device *dev, u32 offset,
+		u8 *pdatatoread, u16 bytestoread);
+
+s32 pruss_readl(struct device *dev, u32 offset, u32 *pdatatoread);
+
+s32 pruss_readl_multi(struct device *dev, u32 offset,
+		u32 *pdatatoread, u16 wordstoread);
+
+s32 pruss_writel(struct device *dev, u32 offset, u32 pdatatowrite);
+
+s32 pruss_writel_multi(struct device *dev, u32 offset,
+		u32 *pdatatowrite, u16 wordstowrite);
+
+s32 pruss_rmwl(struct device *dev, u32 offset, u32 mask, u32 val);
+
+s32 pruss_idx_writel(struct device *dev, u32 offset, u32 value);
+
+s32 pruss_writew(struct device *dev, u32 offset, u16 datatowrite);
+
+s32 pruss_rmww(struct device *dev, u32 offset, u16 mask, u16 val);
+
+s32 pruss_readw(struct device *dev, u32 offset, u16 *pdatatoread);
+
+#endif	/* End _PRUSS_H_ */
diff --git a/include/linux/mfd/pruss_core.h b/include/linux/mfd/pruss_core.h
new file mode 100644
index 0000000..48e2b99
--- /dev/null
+++ b/include/linux/mfd/pruss_core.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _PRUSS_CORE_H_
+#define _PRUSS_CORE_H_
+
+#include <linux/types.h>
+
+#define PRUCORE_0		(0)
+#define PRUCORE_1		(1)
+
+#define PRUCORE_CONTROL_PCRESETVAL_MASK			(0xFFFF0000u)
+#define PRUCORE_CONTROL_PCRESETVAL_SHIFT		(0x00000010u)
+#define PRUCORE_CONTROL_PCRESETVAL_RESETVAL		(0x00000000u)
+#define PRUCORE_CONTROL_RUNSTATE_MASK			(0x00008000u)
+#define PRUCORE_CONTROL_RUNSTATE_SHIFT			(0x0000000Fu)
+#define PRUCORE_CONTROL_RUNSTATE_RESETVAL		(0x00000000u)
+#define PRUCORE_CONTROL_RUNSTATE_HALT			(0x00000000u)
+#define PRUCORE_CONTROL_RUNSTATE_RUN			(0x00000001u)
+#define PRUCORE_CONTROL_SINGLESTEP_MASK			(0x00000100u)
+#define PRUCORE_CONTROL_SINGLESTEP_SHIFT		(0x00000008u)
+#define PRUCORE_CONTROL_SINGLESTEP_RESETVAL		(0x00000000u)
+#define PRUCORE_CONTROL_SINGLESTEP_FREERUN		(0x00000000u)
+#define PRUCORE_CONTROL_SINGLESTEP_SINGLE		(0x00000001u)
+#define PRUCORE_CONTROL_COUNTENABLE_MASK		(0x00000008u)
+#define PRUCORE_CONTROL_COUNTENABLE_SHIFT		(0x00000003u)
+#define PRUCORE_CONTROL_COUNTENABLE_RESETVAL		(0x00000000u)
+#define PRUCORE_CONTROL_COUNTENABLE_DISABLE		(0x00000000u)
+#define PRUCORE_CONTROL_COUNTENABLE_ENABLE		(0x00000001u)
+#define PRUCORE_CONTROL_SLEEPING_MASK			(0x00000004u)
+#define PRUCORE_CONTROL_SLEEPING_SHIFT			(0x00000002u)
+#define PRUCORE_CONTROL_SLEEPING_RESETVAL		(0x00000000u)
+#define PRUCORE_CONTROL_SLEEPING_NOTASLEEP		(0x00000000u)
+#define PRUCORE_CONTROL_SLEEPING_ASLEEP			(0x00000001u)
+#define PRUCORE_CONTROL_ENABLE_MASK			(0x00000002u)
+#define PRUCORE_CONTROL_ENABLE_SHIFT			(0x00000001u)
+#define PRUCORE_CONTROL_ENABLE_RESETVAL			(0x00000000u)
+#define PRUCORE_CONTROL_ENABLE_DISABLE			(0x00000000u)
+#define PRUCORE_CONTROL_ENABLE_ENABLE			(0x00000001u)
+#define PRUCORE_CONTROL_SOFTRESET_MASK			(0x00000001u)
+#define PRUCORE_CONTROL_SOFTRESET_SHIFT			(0x00000000u)
+#define PRUCORE_CONTROL_SOFTRESET_RESETVAL		(0x00000000u)
+#define PRUCORE_CONTROL_SOFTRESET_RESET			(0x00000000u)
+#define PRUCORE_CONTROL_SOFTRESET_OUT_OF_RESET		(0x00000001u)
+#define PRUCORE_CONTROL_RESETVAL			(0x00000000u)
+
+struct prusscore_regs {
+	u32 control;
+	u32 status;
+	u32 wakeup;
+	u32 cyclecnt;
+	u32 stallcnt;
+	u8  rsvd0[12];
+	u32 contabblkidx0;
+	u32 contabblkidx1;
+	u32 contabproptr0;
+	u32 contabproptr1;
+	u8  rsvd1[976];
+	u32 intgpr[32];
+	u32 intcter[32];
+	u8  rsvd2[768];
+};
+
+struct pruss_intc_regs {
+	u32 revid;
+	u32 control;
+	u8  res1[8];
+	u32 glblen;
+	u8  res2[8];
+	u32 glblnstlvl;
+	u32 statidxset;
+	u32 statidxclr;
+	u32 enidxset;
+	u32 enidxclr;
+	u8  res3[4];
+	u32 hostintenidxset;
+	u32 hostintenidxclr;
+	u8  res4[68];
+	u32 glblpriidx;
+	u8  res5[380];
+	u32 statsetint[2];
+	u8  res6[120];
+	u32 statclrint[2];
+	u8  res7[120];
+	u32 enableset[2];
+	u8  res8[120];
+	u32 enableclr[2];
+	u8  res9[120];
+	u32 chanmap[16];
+	u8  res10[960];
+	u32 hostmap[2];
+	u8  res11[248];
+	u32 hostintpriidx[10];
+	u8  res12[984];
+	u32 polarity[2];
+	u8  res13[120];
+	u32 type[2];
+	u8  res14[888];
+	u32 hostintnstlvl[10];
+	u8  res15[984];
+	u32 hostinten;
+	u8  res16[6907];
+};
+
+struct pruss_map {
+	u8 dram0[512];
+	u8 res1[7680];
+	u8 dram1[512];
+	u8 res2[7680];
+	struct pruss_intc_regs intc;
+	struct prusscore_regs core[2];
+	u8 iram0[4096];
+	u8 res3[12288];
+	u8 iram1[4096];
+	u8 res4[12288];
+};
+#endif
-- 
1.7.2.3

