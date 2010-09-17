Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0IQKTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 06:19:00 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42763 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0IQKS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 06:18:58 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        Changhwan Youn <chaos.youn@samsung.com>,
        Jeongbae Seo <jeongbae.seo@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] regulator: Add support samsung power domain
Date: Fri, 17 Sep 2010 18:58:52 +0900
Message-Id: <1284717532-9992-1-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changhwan Youn <chaos.youn@samsung.com>

This patch adds common regulator driver for samsung power domain.
A consumer of controlling power domain uses regulator framework API,
So new samsung pd driver is inserted into regulator directory.

Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Signed-off-by: Jeongbae Seo <jeongbae.seo@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/regulator/Kconfig            |    5 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/samsung_pd.c       |  169 ++++++++++++++++++++++++++++++++++
 include/linux/regulator/samsung_pd.h |   46 +++++++++
 4 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/samsung_pd.c
 create mode 100644 include/linux/regulator/samsung_pd.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 172951b..1ef8efe 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -235,5 +235,10 @@ config REGULATOR_TPS6586X
 	help
 	  This driver supports TPS6586X voltage regulator chips.
 
+config REGULATOR_SAMSUNG_POWER_DOMAIN
+	tristate "Samsung power domain support"
+	help
+	  This driver provides support for samsung power domain.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 8285fd8..30ae640 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -36,5 +36,6 @@ obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
+obj-$(CONFIG_REGULATOR_SAMSUNG_POWER_DOMAIN) += samsung_pd.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/samsung_pd.c b/drivers/regulator/samsung_pd.c
new file mode 100644
index 0000000..ef48f16
--- /dev/null
+++ b/drivers/regulator/samsung_pd.c
@@ -0,0 +1,169 @@
+/* linux/driver/regulator/samsung_pd.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Based on linux/driver/regulator/fixed.c
+ *
+ * Samsung power domain support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/samsung_pd.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+
+struct samsung_pd_data {
+	struct regulator_desc desc;
+	struct regulator_dev *dev;
+	unsigned startup_delay;
+	bool is_enabled;
+	int (*enable)(void);
+	int (*disable)(void);
+};
+
+static int samsung_pd_is_enabled(struct regulator_dev *dev)
+{
+	struct samsung_pd_data *data = rdev_get_drvdata(dev);
+
+	return data->is_enabled;
+}
+
+static int samsung_pd_enable(struct regulator_dev *dev)
+{
+	struct samsung_pd_data *data = rdev_get_drvdata(dev);
+	int ret;
+
+	ret = data->enable();
+	if (!ret)
+		data->is_enabled = true;
+
+	return ret;
+}
+
+static int samsung_pd_disable(struct regulator_dev *dev)
+{
+	struct samsung_pd_data *data = rdev_get_drvdata(dev);
+	int ret;
+
+	ret = data->disable();
+	if (!ret)
+		data->is_enabled = false;
+
+	return ret;
+}
+
+static int samsung_pd_enable_time(struct regulator_dev *dev)
+{
+	struct samsung_pd_data *data = rdev_get_drvdata(dev);
+
+	return data->startup_delay;
+}
+
+static struct regulator_ops samsung_pd_ops = {
+	.is_enabled	= samsung_pd_is_enabled,
+	.enable		= samsung_pd_enable,
+	.disable	= samsung_pd_disable,
+	.enable_time	= samsung_pd_enable_time,
+};
+
+static int __devinit reg_samsung_pd_probe(struct platform_device *pdev)
+{
+	struct samsung_pd_config *config = pdev->dev.platform_data;
+	struct samsung_pd_data *drvdata;
+	int ret;
+
+	drvdata = kzalloc(sizeof(struct samsung_pd_data), GFP_KERNEL);
+	if (drvdata == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate device data\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
+	if (drvdata->desc.name == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate supply name\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	drvdata->desc.type = REGULATOR_VOLTAGE;
+	drvdata->desc.owner = THIS_MODULE;
+	drvdata->desc.ops = &samsung_pd_ops;
+	drvdata->desc.n_voltages = 1;
+
+	drvdata->startup_delay = config->startup_delay;
+	drvdata->is_enabled = config->enabled_at_boot;
+	drvdata->enable = config->enable;
+	drvdata->disable = config->disable;
+
+	if (drvdata->is_enabled)
+		drvdata->enable();
+
+	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
+					  config->init_data, drvdata);
+	if (IS_ERR(drvdata->dev)) {
+		ret = PTR_ERR(drvdata->dev);
+		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
+		goto err_name;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+
+	dev_dbg(&pdev->dev, "%s registerd\n", drvdata->desc.name);
+
+	return 0;
+
+err_name:
+	kfree(drvdata->desc.name);
+err:
+	kfree(drvdata);
+	return ret;
+}
+
+static int __devexit reg_samsung_pd_remove(struct platform_device *pdev)
+{
+	struct samsung_pd_data *drvdata = platform_get_drvdata(pdev);
+
+	regulator_unregister(drvdata->dev);
+	kfree(drvdata->desc.name);
+	kfree(drvdata);
+
+	return 0;
+}
+
+static struct platform_driver regulator_samsung_pd_driver = {
+	.probe		= reg_samsung_pd_probe,
+	.remove		= __devexit_p(reg_samsung_pd_remove),
+	.driver		= {
+		.name		= "reg-samsung-pd",
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init regulator_samsung_pd_init(void)
+{
+	return platform_driver_register(&regulator_samsung_pd_driver);
+}
+subsys_initcall(regulator_samsung_pd_init);
+
+static void __exit regulator_samsung_pd_exit(void)
+{
+	platform_driver_unregister(&regulator_samsung_pd_driver);
+}
+module_exit(regulator_samsung_pd_exit);
+
+MODULE_AUTHOR("Changhwan Youn <chaos@samsung.com>");
+MODULE_AUTHOR("Jeongbae Seo <jeongbae.seo@samsung.com>");
+MODULE_DESCRIPTION("Samsung power domain regulator");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:reg-samsung-pd");
diff --git a/include/linux/regulator/samsung_pd.h b/include/linux/regulator/samsung_pd.h
new file mode 100644
index 0000000..505b458
--- /dev/null
+++ b/include/linux/regulator/samsung_pd.h
@@ -0,0 +1,46 @@
+/* linux/include/linux/regulator/samsung_pd.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Based on linux/include/linux/regulator/fixed.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __REGULATOR_SAMSUNG_PD_H
+#define __REGULATOR_SAMSUNG_PD_H __FILE__
+
+struct regulator_init_data;
+
+/*
+ * struct samsung_pd_config - samsung_pd_config structure
+ * @supply_name:	Name of the regulator supply
+ * @microvolts:		Output voltage of regulator
+ * @startup_delay:	Start-up time in microseconds
+ * @enabled_at_boot:	Whether regulator has been enabled at
+ *			boot or not. 1 = Yes, 0 = No
+ *			This is used to keep the regulator at
+ *			the default state
+ * @init_data:		regulator_init_data
+ * @enable:		regulator enable function
+ * @disable:		regulator disable function
+ *
+ * This structure contains samsung power domain regulator configuration
+ * information that must be passed by platform code to the samsung
+ * power domain regulator driver.
+ */
+
+struct samsung_pd_config {
+	const char *supply_name;
+	int microvolts;
+	unsigned startup_delay;
+	unsigned enabled_at_boot:1;
+	struct regulator_init_data *init_data;
+	int (*enable)(void);
+	int (*disable)(void);
+};
+
+#endif /* __REGULATOR_SAMSUNG_PD_H */
-- 
1.6.2.5

