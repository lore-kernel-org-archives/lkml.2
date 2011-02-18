Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1BRAfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:35:10 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60833 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1BRAfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:35:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6260"; a="74924420"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, dima@android.com
Cc: tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Kenneth Heitke <kheitke@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
Date: Thu, 17 Feb 2011 17:34:58 -0700
Message-Id: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSBI is the Qualcomm single-wire serial bus interface used to connect
the MSM devices to the PMIC and other devices.

Since SSBI only supports a single slave, the driver gets the name of the
slave device passed in from the board file through the master device's
platform data.

SSBI registers pretty early (postcore), so that the PMIC can come up
before the board init. This is useful if the board init requires the
use of gpios that are connected through the PMIC.

Based on a patch by Dima Zavin <dima@android.com> that can be found at:
http://android.git.kernel.org/?p=kernel/msm.git;a=commitdiff;h=eb060bac4

This patch adds PMIC Arbiter support for the MSM8660. The PMIC Arbiter
is a hardware wrapper around the SSBI 2.0 controller that is designed to
overcome concurrency issues and security limitations.  A controller_type
field is added to the platform data to specify the type of the SSBI
controller (1.0, 2.0, or PMIC Arbiter).

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                 |   16 ++
 arch/arm/mach-msm/Makefile                |    1 +
 arch/arm/mach-msm/include/mach/msm_ssbi.h |   38 +++
 arch/arm/mach-msm/ssbi.c                  |  376 +++++++++++++++++++++++++++++
 4 files changed, 431 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_ssbi.h
 create mode 100644 arch/arm/mach-msm/ssbi.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 997c5bd..f35c3d9 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -24,6 +24,7 @@ config ARCH_MSM7X30
 	select MSM_GPIOMUX
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
+	select HAS_MSM_SSBI
 
 config ARCH_QSD8X50
 	bool "QSD8X50"
@@ -46,6 +47,7 @@ config ARCH_MSM8X60
 	select MSM_V2_TLMM
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP
+	select HAS_MSM_SSBI
 
 config ARCH_MSM8960
 	bool "MSM8960"
@@ -56,6 +58,7 @@ config ARCH_MSM8960
 	select MSM_V2_TLMM
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP
+	select HAS_MSM_SSBI
 
 endchoice
 
@@ -190,6 +193,16 @@ choice
 endchoice
 endif
 
+config MSM_SSBI
+	bool "Qualcomm Single-wire Serial Bus Interface (SSBI)"
+	depends on HAS_MSM_SSBI
+	help
+	  If you say yes to this option, support will be included for the
+	  built-in SSBI interface on Qualcomm MSM family processors.
+
+	  This is required for communicating with Qualcomm PMICs and
+	  other devices that have the SSBI interface.
+
 config MSM_SMD_PKG3
 	bool
 
@@ -210,4 +223,7 @@ config IOMMU_API
 
 config MSM_SCM
 	bool
+
+config HAS_MSM_SSBI
+	bool
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 2099c97..94d46ff 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
 
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
+obj-$(CONFIG_MSM_SSBI) += ssbi.o
 
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
diff --git a/arch/arm/mach-msm/include/mach/msm_ssbi.h b/arch/arm/mach-msm/include/mach/msm_ssbi.h
new file mode 100644
index 0000000..d0ed277
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_ssbi.h
@@ -0,0 +1,38 @@
+/* Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ * Author: Dima Zavin <dima@android.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_SSBI_H
+#define __ARCH_ARM_MACH_MSM_SSBI_H
+
+#include <linux/types.h>
+
+struct msm_ssbi_slave_info {
+	const char	*name;
+	void		*platform_data;
+};
+
+enum msm_ssbi_controller_type {
+	MSM_SBI_CTRL_SSBI = 0,
+	MSM_SBI_CTRL_SSBI2,
+	MSM_SBI_CTRL_PMIC_ARBITER,
+};
+
+struct msm_ssbi_platform_data {
+	struct msm_ssbi_slave_info	slave;
+	enum msm_ssbi_controller_type controller_type;
+};
+
+int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len);
+int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len);
+#endif
diff --git a/arch/arm/mach-msm/ssbi.c b/arch/arm/mach-msm/ssbi.c
new file mode 100644
index 0000000..1de4faf
--- /dev/null
+++ b/arch/arm/mach-msm/ssbi.c
@@ -0,0 +1,376 @@
+/* Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2010, Google Inc.
+ *
+ * Original authors: Code Aurura Forum
+ *
+ * Author: Dima Zavin <dima@android.com>
+ *  - Largely rewritten from original to not be an i2c driver.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <mach/msm_ssbi.h>
+
+/* SSBI 2.0 controller registers */
+#define SSBI2_CMD			0x0008
+#define SSBI2_RD			0x0010
+#define SSBI2_STATUS			0x0014
+#define SSBI2_MODE2			0x001C
+
+/* SSBI_CMD fields */
+#define SSBI_CMD_RDWRN			(1 << 24)
+
+/* SSBI_STATUS fields */
+#define SSBI_STATUS_RD_READY		(1 << 2)
+#define SSBI_STATUS_READY		(1 << 1)
+#define SSBI_STATUS_MCHN_BUSY		(1 << 0)
+
+/* SSBI_MODE2 fields */
+#define SSBI_MODE2_REG_ADDR_15_8_SHFT	0x04
+#define SSBI_MODE2_REG_ADDR_15_8_MASK	(0x7f << SSBI_MODE2_REG_ADDR_15_8_SHFT)
+
+#define SET_SSBI_MODE2_REG_ADDR_15_8(MD, AD) \
+	(((MD) & 0x0F) | ((((AD) >> 8) << SSBI_MODE2_REG_ADDR_15_8_SHFT) & \
+	SSBI_MODE2_REG_ADDR_15_8_MASK))
+
+/* SSBI PMIC Arbiter command registers */
+#define SSBI_PA_CMD			0x0000
+#define SSBI_PA_RD_STATUS		0x0004
+
+/* SSBI_PA_CMD fields */
+#define SSBI_PA_CMD_RDWRN		(1 << 24)
+
+/* SSBI_PA_RD_STATUS fields */
+#define SSBI_PA_RD_STATUS_TRANS_DONE	(1 << 27)
+#define SSBI_PA_RD_STATUS_TRANS_DENIED	(1 << 26)
+
+#define SSBI_TIMEOUT_US			100
+
+struct msm_ssbi {
+	struct device		*dev;
+	struct device		*slave;
+	void __iomem		*base;
+	spinlock_t		lock;
+	enum msm_ssbi_controller_type controller_type;
+	int (*read)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
+	int (*write)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
+};
+
+#define to_msm_ssbi(dev)	platform_get_drvdata(to_platform_device(dev))
+
+static inline u32 ssbi_readl(struct msm_ssbi *ssbi, u32 reg)
+{
+	return readl(ssbi->base + reg);
+}
+
+static inline void ssbi_writel(struct msm_ssbi *ssbi, u32 val, u32 reg)
+{
+	writel(val, ssbi->base + reg);
+}
+
+static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
+{
+	u32 timeout = SSBI_TIMEOUT_US;
+	u32 val;
+
+	while (timeout--) {
+		val = ssbi_readl(ssbi, SSBI2_STATUS);
+		if (((val & set_mask) == set_mask) && ((val & clr_mask) == 0))
+			return 0;
+		udelay(1);
+	}
+
+	dev_err(ssbi->dev, "%s: timeout (status %x set_mask %x clr_mask %x)\n",
+		__func__, ssbi_readl(ssbi, SSBI2_STATUS), set_mask, clr_mask);
+	return -ETIMEDOUT;
+}
+
+static int
+msm_ssbi_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+{
+	u32 cmd = SSBI_CMD_RDWRN | ((addr & 0xff) << 16);
+	int ret = 0;
+
+	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
+		u32 mode2 = ssbi_readl(ssbi, SSBI2_MODE2);
+		mode2 = SET_SSBI_MODE2_REG_ADDR_15_8(mode2, addr);
+		ssbi_writel(ssbi, mode2, SSBI2_MODE2);
+	}
+
+	while (len) {
+		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_READY, 0);
+		if (ret)
+			goto err;
+
+		ssbi_writel(ssbi, cmd, SSBI2_CMD);
+		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_RD_READY, 0);
+		if (ret)
+			goto err;
+		*buf++ = ssbi_readl(ssbi, SSBI2_RD) & 0xff;
+		len--;
+	}
+
+err:
+	return ret;
+}
+
+static int
+msm_ssbi_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+{
+	int ret = 0;
+
+	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
+		u32 mode2 = ssbi_readl(ssbi, SSBI2_MODE2);
+		mode2 = SET_SSBI_MODE2_REG_ADDR_15_8(mode2, addr);
+		ssbi_writel(ssbi, mode2, SSBI2_MODE2);
+	}
+
+	while (len) {
+		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_READY, 0);
+		if (ret)
+			goto err;
+
+		ssbi_writel(ssbi, ((addr & 0xff) << 16) | *buf, SSBI2_CMD);
+		ret = ssbi_wait_mask(ssbi, 0, SSBI_STATUS_MCHN_BUSY);
+		if (ret)
+			goto err;
+		buf++;
+		len--;
+	}
+
+err:
+	return ret;
+}
+
+static inline int
+msm_ssbi_pa_transfer(struct msm_ssbi *ssbi, u32 cmd, u8 *data)
+{
+	u32 timeout = SSBI_TIMEOUT_US;
+	u32 rd_status;
+
+	ssbi_writel(ssbi, cmd, SSBI_PA_CMD);
+
+	while (timeout--) {
+		rd_status = ssbi_readl(ssbi, SSBI_PA_RD_STATUS);
+
+		if (rd_status & SSBI_PA_RD_STATUS_TRANS_DENIED) {
+			dev_err(ssbi->dev, "%s: transaction denied (0x%x)\n",
+					__func__, rd_status);
+			return -EPERM;
+		}
+
+		if (rd_status & SSBI_PA_RD_STATUS_TRANS_DONE) {
+			if (data)
+				*data = rd_status & 0xff;
+			return 0;
+		}
+		udelay(1);
+	}
+
+	dev_err(ssbi->dev, "%s: timeout, status 0x%x\n", __func__, rd_status);
+	return -ETIMEDOUT;
+}
+
+static int
+msm_ssbi_pa_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+{
+	u32 cmd;
+	int ret = 0;
+
+	cmd = SSBI_PA_CMD_RDWRN | (addr & 0x3fff) << 8;
+
+	while (len) {
+		ret = msm_ssbi_pa_transfer(ssbi, cmd, buf);
+		if (ret)
+			goto err;
+		buf++;
+		len--;
+	}
+
+err:
+	return ret;
+}
+
+static int
+msm_ssbi_pa_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+{
+	u32 cmd;
+	int ret = 0;
+
+	while (len) {
+		cmd = (addr & 0x3fff) << 8 | *buf;
+		ret = msm_ssbi_pa_transfer(ssbi, cmd, NULL);
+		if (ret)
+			goto err;
+		buf++;
+		len--;
+	}
+
+err:
+	return ret;
+}
+
+int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len)
+{
+	struct msm_ssbi *ssbi = to_msm_ssbi(dev);
+	unsigned long flags;
+	int ret;
+
+	BUG_ON(ssbi->dev != dev);
+
+	spin_lock_irqsave(&ssbi->lock, flags);
+	ret = ssbi->read(ssbi, addr, buf, len);
+	spin_unlock_irqrestore(&ssbi->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(msm_ssbi_read);
+
+int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
+{
+	struct msm_ssbi *ssbi = to_msm_ssbi(dev);
+	unsigned long flags;
+	int ret;
+
+	BUG_ON(ssbi->dev != dev);
+
+	spin_lock_irqsave(&ssbi->lock, flags);
+	ret = ssbi->write(ssbi, addr, buf, len);
+	spin_unlock_irqrestore(&ssbi->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(msm_ssbi_write);
+
+static int __init msm_ssbi_add_slave(struct msm_ssbi *ssbi,
+				     const struct msm_ssbi_slave_info *slave)
+{
+	struct platform_device *slave_pdev;
+	int ret;
+
+	if (ssbi->slave) {
+		pr_err("%s: slave already attached??\n", __func__);
+		return -EBUSY;
+	}
+
+	slave_pdev = platform_device_alloc(slave->name, -1);
+	if (!slave_pdev) {
+		pr_err("%s: cannot allocate pdev for slave '%s'", __func__,
+		       slave->name);
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	slave_pdev->dev.parent = ssbi->dev;
+	slave_pdev->dev.platform_data = slave->platform_data;
+
+	ret = platform_device_add(slave_pdev);
+	if (ret) {
+		pr_err("%s: cannot add slave platform device for '%s'\n",
+		       __func__, slave->name);
+		goto err;
+	}
+
+	ssbi->slave = &slave_pdev->dev;
+	return 0;
+
+err:
+	if (slave_pdev)
+		platform_device_put(slave_pdev);
+	return ret;
+}
+
+static int __init msm_ssbi_probe(struct platform_device *pdev)
+{
+	const struct msm_ssbi_platform_data *pdata = pdev->dev.platform_data;
+	struct resource *mem_res;
+	struct msm_ssbi *ssbi;
+	int ret = 0;
+
+	printk(KERN_INFO "%s: %s\n", __func__, pdata->slave.name);
+
+	if (!pdata) {
+		pr_err("%s: missing platform data\n", __func__);
+		return -EINVAL;
+	}
+
+	ssbi = kzalloc(sizeof(struct msm_ssbi), GFP_KERNEL);
+	if (!ssbi) {
+		pr_err("%s: cannot allocate ssbi_data\n", __func__);
+		return -ENOMEM;
+	}
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		pr_err("%s: missing mem resource\n", __func__);
+		ret = -EINVAL;
+		goto err_get_mem_res;
+	}
+
+	ssbi->base = ioremap(mem_res->start, resource_size(mem_res));
+	if (!ssbi->base) {
+		pr_err("%s: ioremap of 0x%p failed\n", __func__,
+		       (void *)mem_res->start);
+		ret = -EINVAL;
+		goto err_ioremap;
+	}
+	ssbi->dev = &pdev->dev;
+	platform_set_drvdata(pdev, ssbi);
+
+	ssbi->controller_type = pdata->controller_type;
+	if (ssbi->controller_type == MSM_SBI_CTRL_PMIC_ARBITER) {
+		ssbi->read = msm_ssbi_pa_read_bytes;
+		ssbi->write = msm_ssbi_pa_write_bytes;
+	} else {
+		ssbi->read = msm_ssbi_read_bytes;
+		ssbi->write = msm_ssbi_write_bytes;
+	}
+
+	spin_lock_init(&ssbi->lock);
+
+	ret = msm_ssbi_add_slave(ssbi, &pdata->slave);
+	if (ret)
+		goto err_ssbi_add_slave;
+
+	return 0;
+
+err_ssbi_add_slave:
+	platform_set_drvdata(pdev, NULL);
+	iounmap(ssbi->base);
+err_ioremap:
+err_get_mem_res:
+	kfree(ssbi);
+	return ret;
+}
+
+static struct platform_driver msm_ssbi_driver = {
+	.probe		= msm_ssbi_probe,
+	.driver		= {
+		.name	= "msm_ssbi",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init msm_ssbi_init(void)
+{
+	return platform_driver_register(&msm_ssbi_driver);
+}
+postcore_initcall(msm_ssbi_init);
+
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:msm_ssbi");
+MODULE_AUTHOR("Dima Zavin <dima@android.com>");
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
