Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1EPSur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:50:47 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48957 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab1EPSup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:50:45 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 5/5] TPS65911: Comparator: Add comparator driver
Date: Mon, 16 May 2011 13:50:38 -0500
Message-Id: <BF3268B9-C656-45F3-87E2-70442ABE6794@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds functionality to the tps65911 chip driver.

Two of the comparators are configurable by software and measures
VCCS voltage to detect high or low voltage scenarios.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/mfd/Makefile              |    1 +
 drivers/mfd/tps65911-comparator.c |  188 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65910.h      |    4 +
 3 files changed, 193 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps65911-comparator.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c771eed..320de3e 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -89,3 +89,4 @@ obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
 obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-gpio.o tps65910-irq.o
+obj-$(CONFIG_TPS65911_COMP)	+= tps65911-comparator.o
diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
new file mode 100644
index 0000000..b8b985b
--- /dev/null
+++ b/drivers/mfd/tps65911-comparator.c
@@ -0,0 +1,188 @@
+/*
+ * tps65910.c  --  TI TPS6591x
+ *
+ * Copyright 2010 Texas Instruments Inc.
+ *
+ * Author: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/debugfs.h>
+#include <linux/gpio.h>
+#include <linux/mfd/tps65910.h>
+
+#define COMP					0
+#define COMP1					1
+#define COMP2					2
+
+/* Comparator 1 voltage selection table in milivolts */
+static const u16 COMP_VSEL_TABLE[] = {
+	0, 2500, 2500, 2500, 2500, 2550, 2600, 2650,
+	2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050,
+	3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450,
+	3500,
+};
+
+struct comparator {
+	const char *name;
+	int reg;
+	int uV_max;
+	const u16 *vsel_table;
+};
+
+static struct comparator tps_comparators[] = {
+	{
+		.name = "COMP1",
+		.reg = TPS65911_VMBCH,
+		.uV_max = 3500,
+		.vsel_table = COMP_VSEL_TABLE,
+	},
+	{
+		.name = "COMP2",
+		.reg = TPS65911_VMBCH2,
+		.uV_max = 3500,
+		.vsel_table = COMP_VSEL_TABLE,
+	},
+};
+
+static int comp_threshold_set(struct tps65910 *tps65910, int id, int voltage)
+{
+	struct comparator tps_comp = tps_comparators[id];
+	int curr_voltage = 0;
+	int ret;
+	u8 index = 0, val;
+
+	if (id == COMP)
+		return 0;
+
+	while (curr_voltage < tps_comp.uV_max) {
+		curr_voltage = tps_comp.vsel_table[index];
+		if (curr_voltage >= voltage)
+			break;
+		else if (curr_voltage < voltage)
+			index ++;
+	}
+
+	if (curr_voltage > tps_comp.uV_max)
+		return -EINVAL;
+	
+	val = index << 1;
+	ret = tps65910->write(tps65910, tps_comp.reg, 1, &val);
+
+	return ret;
+}
+
+static int comp_threshold_get(struct tps65910 *tps65910, int id)
+{
+	struct comparator tps_comp = tps_comparators[id];
+	int ret;
+	u8 val;
+
+	if (id == COMP)
+		return 0;
+
+	ret = tps65910->read(tps65910, tps_comp.reg, 1, &val);
+	if (ret < 0)
+		return ret;
+
+	val >>= 1;
+	return tps_comp.vsel_table[val];
+}
+
+static ssize_t comp_threshold_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct tps65910 *tps65910 = dev_get_drvdata(dev->parent);
+	struct attribute comp_attr = attr->attr;
+	int id, uVolt;
+
+	if (!strcmp(comp_attr.name, "comp1_threshold"))
+		id = COMP1;
+	else if (!strcmp(comp_attr.name, "comp2_threshold"))
+		id = COMP2;
+	else
+		return -EINVAL;
+
+	uVolt = comp_threshold_get(tps65910, id);
+
+	return sprintf(buf, "%d\n", uVolt);
+}
+
+static DEVICE_ATTR(comp1_threshold, S_IRUGO, comp_threshold_show, NULL);
+static DEVICE_ATTR(comp2_threshold, S_IRUGO, comp_threshold_show, NULL);
+
+static __devinit int tps65911_comparator_probe(struct platform_device *pdev)
+{
+	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
+	struct tps65910_platform_data *pdata = dev_get_platdata(tps65910->dev);
+	int ret;
+
+	ret = comp_threshold_set(tps65910, COMP1,  pdata->vmbch_threshold);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot set COMP1 threshold\n");
+		return ret;
+	}
+
+	ret = comp_threshold_set(tps65910, COMP2, pdata->vmbch2_threshold);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot set COMP2 theshold\n");
+		return ret;
+	}
+
+	/* Create sysfs entry */
+	ret = device_create_file(&pdev->dev, &dev_attr_comp1_threshold);
+	if (ret < 0)
+		dev_err(&pdev->dev, "failed to add COMP1 sysfs file\n");
+
+	ret = device_create_file(&pdev->dev, &dev_attr_comp2_threshold);
+	if (ret < 0)
+		dev_err(&pdev->dev, "failed to add COMP2 sysfs file\n");
+
+	return ret;
+}
+
+static __devexit int tps65911_comparator_remove(struct platform_device *pdev)
+{
+	struct tps65910 *tps65910;
+
+	tps65910 = dev_get_drvdata(pdev->dev.parent);
+
+	return 0;
+}
+
+static struct platform_driver tps65911_comparator_driver = {
+	.driver = {
+		.name = "tps65911-comparator",
+		.owner = THIS_MODULE,
+	},
+	.probe = tps65911_comparator_probe,
+	.remove = __devexit_p(tps65911_comparator_remove),
+};
+
+static int __init tps65911_comparator_init(void)
+{
+	return platform_driver_register(&tps65911_comparator_driver);
+}
+subsys_initcall(tps65911_comparator_init);
+
+static void __exit tps65911_comparator_exit(void)
+{
+	platform_driver_unregister(&tps65911_comparator_driver);
+}
+module_exit(tps65911_comparator_exit);
+
+MODULE_AUTHOR("Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>");
+MODULE_DESCRIPTION("TPS65911 comparator driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps65911-comparator");
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 5f77006..8bb85b9 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -121,6 +121,8 @@
 #define TPS65911_LDO6					0x35
 #define TPS65911_LDO4					0x36
 #define TPS65911_LDO3					0x37
+#define TPS65911_VMBCH					0x6A
+#define TPS65911_VMBCH2					0x6B
 
 /*
  * List of register bitfields for component TPS65910
@@ -746,6 +748,8 @@ struct tps65910_board {
 	int gpio_base;
 	int irq;
 	int irq_base;
+	int vmbch_threshold;
+	int vmbch2_threshold;
 	struct regulator_init_data *tps65910_pmic_init_data;
 };
 
-- 
1.7.1

