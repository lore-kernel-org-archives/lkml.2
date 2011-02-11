Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1BKOh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:37:29 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:32904 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1BKOh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:37:27 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Samuel Ortiz <sameo@linux.intel.com> (supporter:MULTIFUNCTION
	DEV...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 01/13] mfd: pruss mfd driver.
Date: Fri, 11 Feb 2011 20:21:20 +0530
Message-Id: <1297435892-28278-2-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pruss MFD driver and associated include files.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 drivers/mfd/Kconfig                     |   10 +
 drivers/mfd/Makefile                    |    1 +
 drivers/mfd/da8xx_pru.c                 |  446 +++++++++++++++++++++++++++++++
 include/linux/mfd/pruss/da8xx_pru.h     |  122 +++++++++
 include/linux/mfd/pruss/da8xx_prucore.h |   74 +++++
 5 files changed, 653 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/da8xx_pru.c
 create mode 100644 include/linux/mfd/pruss/da8xx_pru.h
 create mode 100644 include/linux/mfd/pruss/da8xx_prucore.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fd01836..6c437df 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -81,6 +81,16 @@ config MFD_DM355EVM_MSP
 	  boards.  MSP430 firmware manages resets and power sequencing,
 	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
 
+config MFD_DA8XX_PRUSS
+	tristate "Texas Instruments DA8XX PRUSS support"
+	depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
+	select MFD_CORE
+	help
+	    This driver provides support api's for the programmable
+		realtime unit (PRU) present on TI's da8xx processors. It
+		provides basic read, write, config, enable, disable
+		routines to facilitate devices emulated on it.
+
 config HTC_EGPIO
 	bool "HTC EGPIO support"
 	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index a54e2c7..670d6b0 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
 obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
 
 obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
+obj-$(CONFIG_MFD_DA8XX_PRUSS)	+= da8xx_pru.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
diff --git a/drivers/mfd/da8xx_pru.c b/drivers/mfd/da8xx_pru.c
new file mode 100644
index 0000000..f7868a4
--- /dev/null
+++ b/drivers/mfd/da8xx_pru.c
@@ -0,0 +1,446 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
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
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/mfd/pruss/da8xx_prucore.h>
+#include <linux/mfd/pruss/da8xx_pru.h>
+#include <linux/mfd/core.h>
+#include <linux/io.h>
+#include <mach/da8xx.h>
+
+struct da8xx_pruss {
+	struct device *dev;
+	struct resource *res;
+	struct clk *clk;
+	u32 clk_freq;
+	void __iomem *ioaddr;
+};
+
+u32 pruss_get_clk_freq(struct device *dev)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+
+	return pruss->clk_freq;
+}
+EXPORT_SYMBOL(pruss_get_clk_freq);
+
+u32 pruss_disable(struct device *dev, u8 pruss_num)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	da8xx_prusscore_regs h_pruss;
+	u32 temp_reg;
+
+	if (pruss_num == DA8XX_PRUCORE_0) {
+		/* Disable PRU0  */
+		h_pruss = (da8xx_prusscore_regs)
+			((u32) pruss->ioaddr + 0x7000);
+
+		temp_reg = __raw_readl(&h_pruss->CONTROL);
+		temp_reg = (temp_reg &
+				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
+				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
+				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
+				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
+		__raw_writel(temp_reg, &h_pruss->CONTROL);
+
+		temp_reg = __raw_readl(&h_pruss->CONTROL);
+		temp_reg = (temp_reg &
+				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
+				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
+				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
+				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
+		__raw_writel(temp_reg, &h_pruss->CONTROL);
+
+		/* Reset PRU0 */
+		__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
+				&h_pruss->CONTROL);
+	} else if (pruss_num == DA8XX_PRUCORE_1) {
+		/* Disable PRU1 */
+		h_pruss = (da8xx_prusscore_regs)
+		((u32) pruss->ioaddr + 0x7800);
+		temp_reg = __raw_readl(&h_pruss->CONTROL);
+		temp_reg = (temp_reg &
+				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
+				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
+				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
+				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
+		__raw_writel(temp_reg, &h_pruss->CONTROL);
+
+		temp_reg = __raw_readl(&h_pruss->CONTROL);
+		temp_reg = (temp_reg &
+				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
+				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
+				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
+				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
+		__raw_writel(temp_reg, &h_pruss->CONTROL);
+
+		/* Reset PRU1 */
+		__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL, &h_pruss->CONTROL);
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(pruss_disable);
+
+u32 pruss_enable(struct device *dev, u8 pruss_num)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	da8xx_prusscore_regs h_pruss;
+
+	if (pruss_num == DA8XX_PRUCORE_0) {
+		/* Reset PRU0 */
+		h_pruss = (da8xx_prusscore_regs)
+			((u32) pruss->ioaddr + 0x7000);
+		__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
+			&h_pruss->CONTROL);
+	} else if (pruss_num == DA8XX_PRUCORE_1) {
+		/* Reset PRU1  */
+		h_pruss = (da8xx_prusscore_regs)
+			((u32) pruss->ioaddr + 0x7800);
+		__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
+			&h_pruss->CONTROL);
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(pruss_enable);
+
+/* Load the specified PRU with code */
+u32 pruss_load(struct device *dev, u8 pruss_num,
+			u32 *pruss_code, u32 code_size_in_words)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	u32 *pruss_iram;
+	u32 i;
+
+	if (pruss_num == DA8XX_PRUCORE_0) {
+		pruss_iram = (u32 *) ((u32) pruss->ioaddr + 0x8000);
+	} else if (pruss_num == DA8XX_PRUCORE_1) {
+		pruss_iram = (u32 *) ((u32) pruss->ioaddr + 0xc000);
+	} else
+		return -EINVAL;
+
+	pruss_enable(dev, pruss_num);
+
+	/* Copy dMAX code to its instruction RAM  */
+	for (i = 0; i < code_size_in_words; i++) {
+		__raw_writel(pruss_code[i], (pruss_iram + i));
+	}
+	return 0;
+}
+EXPORT_SYMBOL(pruss_load);
+
+u32 pruss_run(struct device *dev, u8 pruss_num)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	da8xx_prusscore_regs h_pruss;
+
+	u32 temp_reg;
+
+	if (pruss_num == DA8XX_PRUCORE_0) {
+		/* DA8XX_PRUCORE_0_REGS; */
+		h_pruss = (da8xx_prusscore_regs)
+			((u32) pruss->ioaddr + 0x7000);
+	} else if (pruss_num == DA8XX_PRUCORE_1) {
+		/* DA8XX_PRUCORE_1_REGS; */
+		h_pruss = (da8xx_prusscore_regs)
+			((u32) pruss->ioaddr + 0x7800);
+	} else
+		return -EINVAL;
+
+	/* Enable dMAX, let it execute the code we just copied */
+	temp_reg = __raw_readl(&h_pruss->CONTROL);
+	temp_reg = (temp_reg &
+			~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
+			((DA8XX_PRUCORE_CONTROL_COUNTENABLE_ENABLE <<
+			DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
+			DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
+	__raw_writel(temp_reg, &h_pruss->CONTROL);
+
+	temp_reg = __raw_readl(&h_pruss->CONTROL);
+	temp_reg = (temp_reg &
+			~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
+			((DA8XX_PRUCORE_CONTROL_ENABLE_ENABLE <<
+			DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
+			DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
+	__raw_writel(temp_reg, &h_pruss->CONTROL);
+	return 0;
+}
+EXPORT_SYMBOL(pruss_run);
+
+u32 pruss_wait_for_halt(struct device *dev, u8 pruss_num, u32 timeout)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	da8xx_prusscore_regs h_pruss;
+	u32 temp_reg;
+	u32 cnt = timeout;
+
+	if (pruss_num == DA8XX_PRUCORE_0) {
+		/* DA8XX_PRUCORE_0_REGS; */
+		h_pruss = (da8xx_prusscore_regs)
+			((u32) pruss->ioaddr + 0x7000);
+	} else if (pruss_num == DA8XX_PRUCORE_1) {
+		/* DA8XX_PRUCORE_1_REGS; */
+		h_pruss = (da8xx_prusscore_regs)
+			((u32) pruss->ioaddr + 0x7800);
+	} else
+		return -EINVAL;
+
+	while (cnt--) {
+		temp_reg = __raw_readl(&h_pruss->CONTROL);
+		if (((temp_reg & DA8XX_PRUCORE_CONTROL_RUNSTATE_MASK) >>
+				DA8XX_PRUCORE_CONTROL_RUNSTATE_SHIFT) ==
+					DA8XX_PRUCORE_CONTROL_RUNSTATE_HALT)
+			break;
+	}
+	if (cnt == 0)
+		return -EBUSY;
+
+	return 0;
+}
+EXPORT_SYMBOL(pruss_wait_for_halt);
+
+s16 pruss_writeb(struct device *dev, u32 u32offset,
+		u8 *pu8datatowrite, u16 u16bytestowrite)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	u8 *pu8addresstowrite;
+	u16 u16loop;
+	u32offset = (u32)pruss->ioaddr + u32offset;
+	pu8addresstowrite = (u8 *) (u32offset);
+
+	for (u16loop = 0; u16loop < u16bytestowrite; u16loop++)
+		__raw_writeb(*pu8datatowrite++, pu8addresstowrite++);
+	return 0;
+}
+EXPORT_SYMBOL(pruss_writeb);
+
+s16 pruss_readb(struct device *dev, u32 u32offset,
+		u8 *pu8datatoread, u16 u16bytestoread)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	u8 *pu8addresstoread;
+	u16 u16loop;
+	u32offset = (u32)pruss->ioaddr + u32offset;
+	pu8addresstoread = (u8 *) (u32offset);
+
+	for (u16loop = 0; u16loop < u16bytestoread; u16loop++)
+		*pu8datatoread++ = __raw_readb(pu8addresstoread++);
+	return 0;
+}
+EXPORT_SYMBOL(pruss_readb);
+
+s16 pruss_writel(struct device *dev, u32 u32offset,
+		u32 *pu32datatowrite, s16 u16wordstowrite)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	u32 *pu32addresstowrite;
+	s16 u16loop;
+
+	/* TODO: Get all the driver API's fixed */
+	u32offset = (u32)pruss->ioaddr + u32offset;
+	pu32addresstowrite = (u32 *)(u32offset);
+
+	for (u16loop = 0; u16loop < u16wordstowrite; u16loop++)
+		__raw_writel(*pu32datatowrite++, pu32addresstowrite++);
+	return 0;
+}
+EXPORT_SYMBOL(pruss_writel);
+
+s16 pruss_readl(struct device *dev, u32 u32offset,
+		u32 *pu32datatoread, s16 u16wordstoread)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	u32 *pu32addresstoread;
+	s16 u16loop;
+
+	/* TODO: Get all the driver API's fixed */
+	u32offset = (u32)pruss->ioaddr + u32offset;
+	pu32addresstoread = (u32 *)(u32offset);
+
+	for (u16loop = 0; u16loop < u16wordstoread; u16loop++)
+		*pu32datatoread++ = __raw_readl(pu32addresstoread++);
+	return 0;
+}
+EXPORT_SYMBOL(pruss_readl);
+
+s16 pruss_writew(struct device *dev, u32 u32offset,
+		u16 *pu16datatowrite, s16 u16wordstowrite)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	u32 *pu32addresstowrite;
+	s16 u16loop;
+
+	/* TODO: Get all the driver API's fixed */
+	u32offset = (u32)pruss->ioaddr + u32offset;
+	pu32addresstowrite = (u32 *)(u32offset);
+
+	for (u16loop = 0; u16loop < u16wordstowrite; u16loop++) {
+		__raw_writew(*(pu16datatowrite++), (pu32addresstowrite++));
+	}
+	return 0;
+}
+EXPORT_SYMBOL(pruss_writew);
+
+s16 pruss_readw(struct device *dev, u32 u32offset,
+			u16 *pu16datatoread, s16 u16wordstoread)
+{
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
+	u32 *pu32addresstoread;
+	s16 u16loop;
+
+	/* TODO: Get all the driver API's fixed */
+	u32offset = (u32)pruss->ioaddr + u32offset;
+	pu32addresstoread = (u32 *)(u32offset);
+
+	for (u16loop = 0; u16loop < u16wordstoread; u16loop++)
+		*pu16datatoread++ = __raw_readw(pu32addresstoread++);
+	return 0;
+}
+EXPORT_SYMBOL(pruss_readw);
+
+static int pruss_mfd_add_devices(struct platform_device *pdev)
+{
+	struct da8xx_pruss_devices *dev_data = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct mfd_cell cell;
+	u32 err, count;
+
+	for (count = 0; (dev_data + count)->dev_name != NULL; count++) {
+		memset(&cell, 0, sizeof(struct mfd_cell));
+		cell.id			= count;
+		cell.name		= (dev_data + count)->dev_name;
+		cell.platform_data	= (dev_data + count)->pdata;
+		cell.data_size		= (dev_data + count)->pdata_size;
+
+		err = mfd_add_devices(dev, 0, &cell, 1, NULL, 0);
+		if (err) {
+			dev_err(dev, "cannot add mfd cells\n");
+			return err;
+		}
+	}
+	return err;
+}
+
+static int __devinit da8xx_pruss_probe(struct platform_device *pdev)
+{
+	struct da8xx_pruss *pruss_dev = NULL;
+	u32 err;
+
+	pruss_dev = kzalloc(sizeof(struct da8xx_pruss), GFP_KERNEL);
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
+	if (!request_mem_region(pruss_dev->res->start, resource_size(pruss_dev->res),
+		dev_name(&pdev->dev))) {
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
+
+	clk_enable(pruss_dev->clk);
+	pruss_dev->clk_freq = clk_get_rate(pruss_dev->clk);
+
+	err = pruss_mfd_add_devices(pdev);
+	if (err)
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
+	release_mem_region(pruss_dev->res->start, resource_size(pruss_dev->res));
+probe_exit_kfree:
+	kfree(pruss_dev);
+	return err;
+}
+
+static int __devexit da8xx_pruss_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct da8xx_pruss *pruss = dev_get_drvdata(dev);
+
+	mfd_remove_devices(dev);
+	clk_disable(pruss->clk);
+	clk_put(pruss->clk);
+	iounmap(pruss->ioaddr);
+	release_mem_region(pruss->res->start, resource_size(pruss->res));
+	kfree(pruss);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct platform_driver da8xx_pruss_driver = {
+	.probe	= da8xx_pruss_probe,
+	.remove	= __devexit_p(da8xx_pruss_remove),
+	.driver	= {
+		.name	= "da8xx_pruss",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init da8xx_pruss_init(void)
+{
+	return platform_driver_register(&da8xx_pruss_driver);
+}
+module_init(da8xx_pruss_init);
+
+static void __exit da8xx_pruss_exit(void)
+{
+	platform_driver_unregister(&da8xx_pruss_driver);
+}
+module_exit(da8xx_pruss_exit);
+
+MODULE_DESCRIPTION("Programmable Realtime Unit (PRU) Driver");
+MODULE_AUTHOR("Subhasish Ghosh");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/pruss/da8xx_pru.h b/include/linux/mfd/pruss/da8xx_pru.h
new file mode 100644
index 0000000..68d8421
--- /dev/null
+++ b/include/linux/mfd/pruss/da8xx_pru.h
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
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
+#include "da8xx_prucore.h"
+
+#define PRUSS_NUM0			DA8XX_PRUCORE_0
+#define PRUSS_NUM1			DA8XX_PRUCORE_1
+
+#define PRUSS_PRU0_BASE_ADDRESS		0
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
+#define PRU_INTC_CHAN_123_HOST		(0x03020100)
+#define PRU_INTC_CHAN_4567_HOST		(0x07060504)
+#define PRU_INTC_CHAN_89_HOST		(0x00000908)
+
+#define PRU_INTC_CHAN_0_SYSEVT_31	(0x00000000)
+#define PRU_INTC_CHAN_12_SYSEVT		(0x02020100)
+#define PRU_INTC_CHAN_34_SYSEVT_36_39	(0x04040303)
+#define PRU_INTC_CHAN_56_SYSEVT_40_43	(0x06060505)
+#define PRU_INTC_CHAN_78_SYSEVT_44_47	(0x08080707)
+#define PRU_INTC_CHAN_9_SYSEVT_48_49	(0x00010909)
+#define PRU_INTC_CHAN_0123_SYSEVT_32_35	(0x03020100)
+#define PRU_INTC_CHAN_4567_SYSEVT_36_39	(0x07060504)
+#define PRU_INTC_CHAN_8923_SYSEVT_40_43	(0x03020908)
+#define PRU_INTC_CHAN_4567_SYSEVT_44_47	(0x07060504)
+
+struct da8xx_pruss_devices {
+	const char *dev_name;
+	void *pdata;
+	size_t pdata_size;
+	int (*setup)(void);
+};
+
+u32 pruss_get_clk_freq(struct device *dev);
+
+u32 pruss_enable(struct device *dev, u8 pruss_num);
+
+u32 pruss_load(struct device *dev, u8 pruss_num, u32 *pruss_code,
+			u32 code_size_in_words);
+
+u32 pruss_run(struct device *dev, u8 pruss_num);
+
+u32 pruss_wait_for_halt(struct device *dev, u8 pruss_num, u32 timeout);
+
+u32 pruss_disable(struct device *dev, u8 pruss_num);
+
+s16 pruss_writeb(struct device *dev, u32 u32offset,
+			u8 *pu8datatowrite, u16 u16wordstowrite);
+
+s16 pruss_readb(struct device *dev, u32 u32offset,
+			u8 *pu8datatoread, u16 u16wordstoread);
+
+s16 pruss_readl(struct device *dev, u32 u32offset,
+			u32 *pu32datatoread, s16 s16wordstoread);
+
+s16 pruss_writel(struct device *dev, u32 u32offset,
+			u32 *pu32datatoread, s16 s16wordstoread);
+
+s16 pruss_writew(struct device *dev, u32 u32offset,
+			u16 *u16datatowrite, s16 u16wordstowrite);
+
+s16 pruss_readw(struct device *dev, u32 u32offset,
+			u16 *pu32datatoread, s16 u16wordstoread);
+#endif	/* End _PRUSS_H_ */
diff --git a/include/linux/mfd/pruss/da8xx_prucore.h b/include/linux/mfd/pruss/da8xx_prucore.h
new file mode 100644
index 0000000..81f2ff9
--- /dev/null
+++ b/include/linux/mfd/pruss/da8xx_prucore.h
@@ -0,0 +1,74 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
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
+#ifndef _DA8XX_PRUCORE_H_
+#define _DA8XX_PRUCORE_H_
+
+#include <linux/types.h>
+
+#define DA8XX_PRUCORE_0		(0)
+#define DA8XX_PRUCORE_1		(1)
+
+#define DA8XX_PRUCORE_CONTROL_PCRESETVAL_MASK			(0xFFFF0000u)
+#define DA8XX_PRUCORE_CONTROL_PCRESETVAL_SHIFT			(0x00000010u)
+#define DA8XX_PRUCORE_CONTROL_PCRESETVAL_RESETVAL		(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_RUNSTATE_MASK			(0x00008000u)
+#define DA8XX_PRUCORE_CONTROL_RUNSTATE_SHIFT			(0x0000000Fu)
+#define DA8XX_PRUCORE_CONTROL_RUNSTATE_RESETVAL			(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_RUNSTATE_HALT			(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_RUNSTATE_RUN			(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_MASK			(0x00000100u)
+#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_SHIFT			(0x00000008u)
+#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_RESETVAL		(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_FREERUN		(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_SINGLE			(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK			(0x00000008u)
+#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT			(0x00000003u)
+#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_RESETVAL		(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE		(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_ENABLE		(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_SLEEPING_MASK			(0x00000004u)
+#define DA8XX_PRUCORE_CONTROL_SLEEPING_SHIFT			(0x00000002u)
+#define DA8XX_PRUCORE_CONTROL_SLEEPING_RESETVAL			(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_SLEEPING_NOTASLEEP		(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_SLEEPING_ASLEEP			(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_ENABLE_MASK			(0x00000002u)
+#define DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT			(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_ENABLE_RESETVAL			(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE			(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_ENABLE_ENABLE			(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_SOFTRESET_MASK			(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_SOFTRESET_SHIFT			(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_SOFTRESET_RESETVAL		(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_SOFTRESET_RESET			(0x00000000u)
+#define DA8XX_PRUCORE_CONTROL_SOFTRESET_OUT_OF_RESET		(0x00000001u)
+#define DA8XX_PRUCORE_CONTROL_RESETVAL				(0x00000000u)
+
+typedef struct {
+	u32 CONTROL;
+	u32 STATUS;
+	u32 WAKEUP;
+	u32 CYCLECNT;
+	u32 STALLCNT;
+	u8  RSVD0[12];
+	u32 CONTABBLKIDX0;
+	u32 CONTABBLKIDX1;
+	u32 CONTABPROPTR0;
+	u32 CONTABPROPTR1;
+	u8  RSVD1[976];
+	u32 INTGPR[32];
+	u32 INTCTER[32];
+} *da8xx_prusscore_regs;
+
+#endif
-- 
1.7.2.3

