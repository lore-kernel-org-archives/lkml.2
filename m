Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1DFGvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:51:19 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:39303 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1DFGuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:50:52 -0400
X-ASG-Debug-ID: 1302072652-082d1f3e0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: haojian.zhuang@gmail.com, dmitry.torokhov@gmail.com, ddtor@mail.ru,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 6/6] mfd: pxa-w1: MFD driver for PXA 1wire control + DS1WM chip
Subject: [PATCH 6/6] mfd: pxa-w1: MFD driver for PXA 1wire control + DS1WM chip
Date: Wed,  6 Apr 2011 14:46:46 +0800
X-ASG-Orig-Subj: [PATCH 6/6] mfd: pxa-w1: MFD driver for PXA 1wire control + DS1WM chip
Message-Id: <1302072406-21459-6-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1302072406-21459-5-git-send-email-haojian.zhuang@marvell.com>
References: <2011040601>
 <1302072406-21459-1-git-send-email-haojian.zhuang@marvell.com>
 <1302072406-21459-2-git-send-email-haojian.zhuang@marvell.com>
 <1302072406-21459-3-git-send-email-haojian.zhuang@marvell.com>
 <1302072406-21459-4-git-send-email-haojian.zhuang@marvell.com>
 <1302072406-21459-5-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1302072652
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides registers and IRQ of PXA3xx chips to the ds1wm driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/Kconfig  |    7 ++
 drivers/mfd/Makefile |    1 +
 drivers/mfd/pxa-w1.c |  149 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/pxa-w1.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9a46d64..56a3c64 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -34,6 +34,13 @@ config MFD_88PM860X
 	  select individual components like voltage regulators, RTC and
 	  battery-charger under the corresponding menus.
 
+config MFD_PXA_DS1WM
+	tristate "Support DS1WM chip on Marvell silicons"
+	select MFD_CORE
+	help
+	  This core driver provides register access for PXA_DS1WM.
+	  Actual functionality is handled by the ds1wm drivers.
+
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
 	 ---help---
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index ef489f2..7999c56 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -4,6 +4,7 @@
 
 88pm860x-objs			:= 88pm860x-core.o 88pm860x-i2c.o
 obj-$(CONFIG_MFD_88PM860X)	+= 88pm860x.o
+obj-$(CONFIG_MFD_PXA_DS1WM)	+= pxa-w1.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 obj-$(CONFIG_MFD_SH_MOBILE_SDHI)		+= sh_mobile_sdhi.o
diff --git a/drivers/mfd/pxa-w1.c b/drivers/mfd/pxa-w1.c
new file mode 100644
index 0000000..1fb380f
--- /dev/null
+++ b/drivers/mfd/pxa-w1.c
@@ -0,0 +1,149 @@
+/*
+ * Core driver for PXA DS1WM chip.
+ *
+ * Copyright (C) 2010 Marvell  <jtzhou@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/ds1wm.h>
+
+struct pxa_w1_info {
+	struct clk *clk;
+};
+
+static int ds1wm_enable(struct platform_device *pdev)
+{
+	struct device *dev = pdev->dev.parent;
+	struct pxa_w1_info *info = dev_get_drvdata(dev);
+
+	clk_enable(info->clk);
+	dev_dbg(dev, "pxa DS1WM clk (active)\n");
+	return 0;
+}
+
+static int ds1wm_disable(struct platform_device *pdev)
+{
+	struct device *dev = pdev->dev.parent;
+	struct pxa_w1_info *info = dev_get_drvdata(dev);
+
+	clk_disable(info->clk);
+	dev_dbg(dev, "pxa DS1WM clk (in-active)\n");
+	return 0;
+}
+
+static struct resource ds1wm_resources[] __initdata = {
+	{0, 0, "ds1wm-mem", IORESOURCE_MEM,},
+	{0, 0, "ds1wm-irq", IORESOURCE_IRQ,},
+};
+
+static struct ds1wm_driver_data ds1wm_pdata;
+
+static struct mfd_cell ds1wm_cell __initdata = {
+	.name		= "ds1wm",
+	.enable		= ds1wm_enable,
+	.disable	= ds1wm_disable,
+	.mfd_data	= &ds1wm_pdata,
+	.num_resources	= ARRAY_SIZE(ds1wm_resources),
+	.resources	= ds1wm_resources,
+};
+
+static int __devinit pxa_w1_probe(struct platform_device *pdev)
+{
+	struct ds1wm_driver_data *pdata = pdev->dev.platform_data;
+	struct pxa_w1_info *info;
+	struct resource *r;
+	int ret, irq;
+
+	info = kzalloc(sizeof(struct pxa_w1_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (r == NULL) {
+		ret = -ENXIO;
+		goto out;
+	}
+	irq = r->start;
+	if (pdata)
+		ds1wm_pdata.active_high = pdata->active_high;
+	if (ds1wm_pdata.active_high)
+		ds1wm_resources[1].flags |= IORESOURCE_IRQ_HIGHEDGE;
+	else
+		ds1wm_resources[1].flags |= IORESOURCE_IRQ_LOWEDGE;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		ret = -ENXIO;
+		goto out;
+	}
+	ds1wm_resources[0].end = resource_size(r) - 1;
+
+	info->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(info->clk)) {
+		ret = PTR_ERR(info->clk);
+		goto out;
+	}
+	platform_set_drvdata(pdev, info);
+
+	ds1wm_pdata.clock_rate = clk_get_rate(info->clk);
+	ret = mfd_add_devices(&pdev->dev, pdev->id, &ds1wm_cell, 1, r, irq);
+	if (ret < 0)
+		dev_err(&pdev->dev, "failed to register pxa DS1WM\n");
+
+	return 0;
+out:
+	kfree(info);
+	return ret;
+}
+
+static int __devexit pxa_w1_remove(struct platform_device *pdev)
+{
+	struct pxa_w1_info *info = platform_get_drvdata(pdev);
+
+	mfd_remove_devices(&pdev->dev);
+	clk_put(info->clk);
+	kfree(info);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver pxa_w1_driver = {
+	.driver = {
+		   .name	= "pxa3xx-w1",
+		   .owner	= THIS_MODULE,
+	},
+	.probe		= pxa_w1_probe,
+	.remove		= __devexit_p(pxa_w1_remove),
+};
+
+static int __init pxa_w1_base_init(void)
+{
+	return platform_driver_register(&pxa_w1_driver);
+}
+
+static void __exit pxa_w1_base_exit(void)
+{
+	platform_driver_unregister(&pxa_w1_driver);
+}
+
+module_init(pxa_w1_base_init);
+module_exit(pxa_w1_base_exit);
+
+MODULE_AUTHOR("Jett Zhou <jtzhou@marvell.com>");
+MODULE_DESCRIPTION("one wire driver for PXA");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa-w1");
-- 
1.5.6.5

