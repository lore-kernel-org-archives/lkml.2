Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2DAHiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:38:01 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41533 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2DAHh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:37:56 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, alexg@meprolight.com,
        Marc Reilly <marc@cpdesign.com.au>
Subject: [PATCH v5 3/4] mfd: mc13xxx-core: Move spi specific code into separate module.
Date: Sun,  1 Apr 2012 16:41:38 +1000
Message-Id: <1333262499-25871-4-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All spi specific code is moved into a new module. The mc13xxx struct
moves to a new local include file by necessity.

A new config choice selects the SPI bus type support and by default is
value of SPI_MASTER to remain compatible with existing configs.

Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
---
 drivers/mfd/Kconfig        |   17 ++++-
 drivers/mfd/Makefile       |    1 +
 drivers/mfd/mc13xxx-core.c |  148 ++------------------------------------------
 drivers/mfd/mc13xxx-spi.c  |  140 +++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/mc13xxx.h      |   45 +++++++++++++
 5 files changed, 204 insertions(+), 147 deletions(-)
 create mode 100644 drivers/mfd/mc13xxx-spi.c
 create mode 100644 drivers/mfd/mc13xxx.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 4e92513..fe0a0ab 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -576,14 +576,23 @@ config MFD_MC13XXX
 	depends on SPI_MASTER
 	select MFD_CORE
 	select MFD_MC13783
-	select REGMAP_SPI
 	help
-	  Support for the Freescale (Atlas) PMIC and audio CODECs
-	  MC13783 and MC13892.
-	  This driver provides common support for accessing  the device,
+	  Enable support for the Freescale MC13783 and MC13892 PMICs.
+	  This driver provides common support for accessing the device,
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+if MFD_MC13XXX
+
+config MFD_MC13XXX_SPI
+	tristate "MC13xxx SPI interface" if SPI_MASTER
+	default SPI_MASTER
+	select REGMAP_SPI
+	help
+	  Select this if your MC13xxx is connected via an SPI bus.
+
+endif
+
 config ABX500_CORE
 	bool "ST-Ericsson ABX500 Mixed Signal Circuit register functions"
 	default y if ARCH_U300 || ARCH_U8500
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b953bab..2dc66ed 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
+obj-$(CONFIG_MFD_MC13XXX_SPI)	+= mc13xxx-spi.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 3223625..5a60273 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -15,36 +15,13 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/interrupt.h>
-#include <linux/spi/spi.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/mc13xxx.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
-#include <linux/regmap.h>
-#include <linux/err.h>
 
-enum mc13xxx_id {
-	MC13XXX_ID_MC13783,
-	MC13XXX_ID_MC13892,
-	MC13XXX_ID_INVALID,
-};
-
-struct mc13xxx {
-	struct regmap *regmap;
-
-	struct device *dev;
-	enum mc13xxx_id ictype;
-
-	struct mutex lock;
-	int irq;
-	int flags;
-
-	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
-	void *irqdata[MC13XXX_NUM_IRQ];
-
-	int adcflags;
-};
+#include "mc13xxx.h"
 
 #define MC13XXX_IRQSTAT0	0
 #define MC13XXX_IRQSTAT0_ADCDONEI	(1 << 0)
@@ -151,8 +128,6 @@ struct mc13xxx {
 
 #define MC13XXX_ADC2		45
 
-#define MC13XXX_NUMREGS 0x3f
-
 void mc13xxx_lock(struct mc13xxx *mc13xxx)
 {
 	if (!mutex_trylock(&mc13xxx->lock)) {
@@ -667,90 +642,7 @@ static inline int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 }
 #endif
 
-static const struct spi_device_id mc13xxx_device_id[] = {
-	{
-		.name = "mc13783",
-		.driver_data = MC13XXX_ID_MC13783,
-	}, {
-		.name = "mc13892",
-		.driver_data = MC13XXX_ID_MC13892,
-	}, {
-		/* sentinel */
-	}
-};
-MODULE_DEVICE_TABLE(spi, mc13xxx_device_id);
-
-static const struct of_device_id mc13xxx_dt_ids[] = {
-	{ .compatible = "fsl,mc13783", .data = (void *) MC13XXX_ID_MC13783, },
-	{ .compatible = "fsl,mc13892", .data = (void *) MC13XXX_ID_MC13892, },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
-
-static struct regmap_config mc13xxx_regmap_spi_config = {
-	.reg_bits = 7,
-	.pad_bits = 1,
-	.val_bits = 24,
-
-	.max_register = MC13XXX_NUMREGS,
-
-	.cache_type = REGCACHE_NONE,
-};
-
-static int mc13xxx_common_init(struct mc13xxx *mc13xxx,
-		struct mc13xxx_platform_data *pdata, int irq);
-
-static void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx);
-
-static int mc13xxx_spi_probe(struct spi_device *spi)
-{
-	const struct of_device_id *of_id;
-	struct spi_driver *sdrv = to_spi_driver(spi->dev.driver);
-	struct mc13xxx *mc13xxx;
-	struct mc13xxx_platform_data *pdata = dev_get_platdata(&spi->dev);
-	int ret;
-
-	of_id = of_match_device(mc13xxx_dt_ids, &spi->dev);
-	if (of_id)
-		sdrv->id_table = &mc13xxx_device_id[(enum mc13xxx_id) of_id->data];
-
-	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
-	if (!mc13xxx)
-		return -ENOMEM;
-
-	dev_set_drvdata(&spi->dev, mc13xxx);
-	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-	spi->bits_per_word = 32;
-
-	mc13xxx->dev = &spi->dev;
-	mutex_init(&mc13xxx->lock);
-
-	mc13xxx->regmap = regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
-	if (IS_ERR(mc13xxx->regmap)) {
-		ret = PTR_ERR(mc13xxx->regmap);
-		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
-				ret);
-		dev_set_drvdata(&spi->dev, NULL);
-		kfree(mc13xxx);
-		return ret;
-	}
-
-	ret = mc13xxx_common_init(mc13xxx, pdata, spi->irq);
-
-	if (ret) {
-		dev_set_drvdata(&spi->dev, NULL);
-	} else {
-		const struct spi_device_id *devid =
-			spi_get_device_id(spi);
-		if (!devid || devid->driver_data != mc13xxx->ictype)
-			dev_warn(mc13xxx->dev,
-				"device id doesn't match auto detection!\n");
-	}
-
-	return ret;
-}
-
-static int mc13xxx_common_init(struct mc13xxx *mc13xxx,
+int mc13xxx_common_init(struct mc13xxx *mc13xxx,
 		struct mc13xxx_platform_data *pdata, int irq)
 {
 	int ret;
@@ -815,17 +707,9 @@ err_revision:
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_common_init);
 
-static int __devexit mc13xxx_spi_remove(struct spi_device *spi)
-{
-	struct mc13xxx *mc13xxx = dev_get_drvdata(&spi->dev);
-
-	mc13xxx_common_cleanup(mc13xxx);
-
-	return 0;
-}
-
-static void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
+void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
 {
 	free_irq(mc13xxx->irq, mc13xxx);
 
@@ -835,29 +719,7 @@ static void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
 
 	kfree(mc13xxx);
 }
-
-static struct spi_driver mc13xxx_spi_driver = {
-	.id_table = mc13xxx_device_id,
-	.driver = {
-		.name = "mc13xxx",
-		.owner = THIS_MODULE,
-		.of_match_table = mc13xxx_dt_ids,
-	},
-	.probe = mc13xxx_spi_probe,
-	.remove = __devexit_p(mc13xxx_spi_remove),
-};
-
-static int __init mc13xxx_init(void)
-{
-	return spi_register_driver(&mc13xxx_spi_driver);
-}
-subsys_initcall(mc13xxx_init);
-
-static void __exit mc13xxx_exit(void)
-{
-	spi_unregister_driver(&mc13xxx_spi_driver);
-}
-module_exit(mc13xxx_exit);
+EXPORT_SYMBOL_GPL(mc13xxx_common_cleanup);
 
 MODULE_DESCRIPTION("Core driver for Freescale MC13XXX PMIC");
 MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
new file mode 100644
index 0000000..3fcdab3
--- /dev/null
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright 2009-2010 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * loosely based on an earlier driver that has
+ * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/mc13xxx.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/err.h>
+#include <linux/spi/spi.h>
+
+#include "mc13xxx.h"
+
+static const struct spi_device_id mc13xxx_device_id[] = {
+	{
+		.name = "mc13783",
+		.driver_data = MC13XXX_ID_MC13783,
+	}, {
+		.name = "mc13892",
+		.driver_data = MC13XXX_ID_MC13892,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(spi, mc13xxx_device_id);
+
+static const struct of_device_id mc13xxx_dt_ids[] = {
+	{ .compatible = "fsl,mc13783", .data = (void *) MC13XXX_ID_MC13783, },
+	{ .compatible = "fsl,mc13892", .data = (void *) MC13XXX_ID_MC13892, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
+
+static struct regmap_config mc13xxx_regmap_spi_config = {
+	.reg_bits = 7,
+	.pad_bits = 1,
+	.val_bits = 24,
+
+	.max_register = MC13XXX_NUMREGS,
+
+	.cache_type = REGCACHE_NONE,
+};
+
+static int mc13xxx_spi_probe(struct spi_device *spi)
+{
+	const struct of_device_id *of_id;
+	struct spi_driver *sdrv = to_spi_driver(spi->dev.driver);
+	struct mc13xxx *mc13xxx;
+	struct mc13xxx_platform_data *pdata = dev_get_platdata(&spi->dev);
+	int ret;
+
+	of_id = of_match_device(mc13xxx_dt_ids, &spi->dev);
+	if (of_id)
+		sdrv->id_table = &mc13xxx_device_id[(enum mc13xxx_id) of_id->data];
+
+	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
+	if (!mc13xxx)
+		return -ENOMEM;
+
+	dev_set_drvdata(&spi->dev, mc13xxx);
+	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
+	spi->bits_per_word = 32;
+
+	mc13xxx->dev = &spi->dev;
+	mutex_init(&mc13xxx->lock);
+
+	mc13xxx->regmap = regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
+	if (IS_ERR(mc13xxx->regmap)) {
+		ret = PTR_ERR(mc13xxx->regmap);
+		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
+				ret);
+		dev_set_drvdata(&spi->dev, NULL);
+		kfree(mc13xxx);
+		return ret;
+	}
+
+	ret = mc13xxx_common_init(mc13xxx, pdata, spi->irq);
+
+	if (ret) {
+		dev_set_drvdata(&spi->dev, NULL);
+	} else {
+		const struct spi_device_id *devid =
+			spi_get_device_id(spi);
+		if (!devid || devid->driver_data != mc13xxx->ictype)
+			dev_warn(mc13xxx->dev,
+				"device id doesn't match auto detection!\n");
+	}
+
+	return ret;
+}
+
+static int __devexit mc13xxx_spi_remove(struct spi_device *spi)
+{
+	struct mc13xxx *mc13xxx = dev_get_drvdata(&spi->dev);
+
+	mc13xxx_common_cleanup(mc13xxx);
+
+	return 0;
+}
+
+static struct spi_driver mc13xxx_spi_driver = {
+	.id_table = mc13xxx_device_id,
+	.driver = {
+		.name = "mc13xxx",
+		.owner = THIS_MODULE,
+		.of_match_table = mc13xxx_dt_ids,
+	},
+	.probe = mc13xxx_spi_probe,
+	.remove = __devexit_p(mc13xxx_spi_remove),
+};
+
+static int __init mc13xxx_init(void)
+{
+	return spi_register_driver(&mc13xxx_spi_driver);
+}
+subsys_initcall(mc13xxx_init);
+
+static void __exit mc13xxx_exit(void)
+{
+	spi_unregister_driver(&mc13xxx_spi_driver);
+}
+module_exit(mc13xxx_exit);
+
+MODULE_DESCRIPTION("Core driver for Freescale MC13XXX PMIC");
+MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/mc13xxx.h b/drivers/mfd/mc13xxx.h
new file mode 100644
index 0000000..bbba06f
--- /dev/null
+++ b/drivers/mfd/mc13xxx.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright 2012 Creative Product Design
+ * Marc Reilly <marc@cpdesign.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#ifndef __DRIVERS_MFD_MC13XXX_H
+#define __DRIVERS_MFD_MC13XXX_H
+
+#include <linux/mutex.h>
+#include <linux/regmap.h>
+#include <linux/mfd/mc13xxx.h>
+
+enum mc13xxx_id {
+	MC13XXX_ID_MC13783,
+	MC13XXX_ID_MC13892,
+	MC13XXX_ID_INVALID,
+};
+
+#define MC13XXX_NUMREGS 0x3f
+
+struct mc13xxx {
+	struct regmap *regmap;
+
+	struct device *dev;
+	enum mc13xxx_id ictype;
+
+	struct mutex lock;
+	int irq;
+	int flags;
+
+	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
+	void *irqdata[MC13XXX_NUM_IRQ];
+
+	int adcflags;
+};
+
+int mc13xxx_common_init(struct mc13xxx *mc13xxx,
+		struct mc13xxx_platform_data *pdata, int irq);
+
+void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx);
+
+#endif /* __DRIVERS_MFD_MC13XXX_H */
-- 
1.7.3.4

