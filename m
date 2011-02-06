Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1BFTdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:33:25 -0500
Received: from smtp-out-015.synserver.de ([212.40.185.15]:1558 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753536Ab1BFTdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:33:24 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24265
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 06/14] POWER: bq27x00: Add bq27000 support
Date: Sun,  6 Feb 2011 01:48:03 +0100
Message-Id: <1296953291-10373-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the bq27000 battery to the bq27x00 driver.
The bq27000 is similar to the bq27200 except that it uses the HDQ bus instead
of I2C to communicate with the host system.

The driver is implemented as a platform driver. The driver expects to be
provided with a read callback function through its platform data. The read
function is assumed to do the lowlevel HDQ handling and read out the value of
a certain register.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/Kconfig                 |   14 +++
 drivers/power/bq27x00_battery.c       |  184 ++++++++++++++++++++++++++++++---
 include/linux/power/bq27x00_battery.h |   19 ++++
 3 files changed, 202 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/power/bq27x00_battery.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 61bf5d7..52a462f 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -117,10 +117,24 @@ config BATTERY_BQ20Z75
 
 config BATTERY_BQ27x00
 	tristate "BQ27x00 battery driver"
+	help
+	  Say Y here to enable support for batteries with BQ27x00 (I2C/HDQ) chips.
+
+config BATTERY_BQ27X00_I2C
+	bool "BQ27200/BQ27500 support"
+	depends on BATTERY_BQ27x00
 	depends on I2C
+	default y
 	help
 	  Say Y here to enable support for batteries with BQ27x00 (I2C) chips.
 
+config BATTERY_BQ27X00_PLATFORM
+	bool "BQ27000 support"
+	depends on BATTERY_BQ27x00
+	default y
+	help
+	  Say Y here to enable support for batteries with BQ27000 (HDQ) chips.
+
 config BATTERY_DA9030
 	tristate "DA9030 battery driver"
 	depends on PMIC_DA903X
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index eee0120..ae4677f 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
  * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
+ * Copyright (C) 2010-2011 Lars-Peter Clausen <lars@metafoo.de>
  *
  * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
  *
@@ -27,6 +28,8 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 
+#include <linux/power/bq27x00_battery.h>
+
 #define DRIVER_VERSION			"1.1.0"
 
 #define BQ27x00_REG_TEMP		0x06
@@ -46,12 +49,6 @@
 
 #define BQ27000_RS			20 /* Resistor sense */
 
-/* If the system has several batteries we need a different name for each
- * of them...
- */
-static DEFINE_IDR(battery_id);
-static DEFINE_MUTEX(battery_mutex);
-
 struct bq27x00_device_info;
 struct bq27x00_access_methods {
 	int (*read)(struct bq27x00_device_info *, u8 reg, int *rt_value,
@@ -317,9 +314,15 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 	return 0;
 }
 
-/*
- * i2c specific code
+
+/* i2c specific code */
+#ifdef CONFIG_BATTERY_BQ27X00_I2C
+
+/* If the system has several batteries we need a different name for each
+ * of them...
  */
+static DEFINE_IDR(battery_id);
+static DEFINE_MUTEX(battery_mutex);
 
 static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg,
 			int *rt_value, bool single)
@@ -434,10 +437,6 @@ static int bq27x00_battery_remove(struct i2c_client *client)
 	return 0;
 }
 
-/*
- * Module stuff
- */
-
 static const struct i2c_device_id bq27x00_id[] = {
 	{ "bq27200", BQ27000 },	/* bq27200 is same as bq27000, but with i2c */
 	{ "bq27500", BQ27500 },
@@ -453,13 +452,167 @@ static struct i2c_driver bq27x00_battery_driver = {
 	.id_table = bq27x00_id,
 };
 
+static inline int bq27x00_battery_i2c_init(void)
+{
+	int ret = i2c_add_driver(&bq27x00_battery_driver);
+	if (ret)
+		printk(KERN_ERR "Unable to register BQ27x00 i2c driver\n");
+
+	return ret;
+}
+
+static inline void bq27x00_battery_i2c_exit(void)
+{
+	i2c_del_driver(&bq27x00_battery_driver);
+}
+
+#else
+
+static inline int bq27x00_battery_i2c_init(void) { return 0; }
+static inline void bq27x00_battery_i2c_exit(void) {};
+
+#endif
+
+/* platform specific code */
+#ifdef CONFIG_BATTERY_BQ27X00_PLATFORM
+
+static int bq27000_read_platform(struct bq27x00_device_info *di, u8 reg,
+			int *rt_value, bool single)
+{
+	struct device *dev = di->dev;
+	struct bq27000_platform_data *pdata = dev->platform_data;
+	unsigned int timeout = 3;
+	int upper, lower;
+	int temp;
+
+	if (!single) {
+		/* Make sure the value has not changed in between reading the
+		 * lower and the upper part */
+		upper = pdata->read(dev, reg + 1);
+		do {
+			temp = upper;
+			if (upper < 0)
+				return upper;
+
+			lower = pdata->read(dev, reg);
+			if (lower < 0)
+				return lower;
+
+			upper = pdata->read(dev, reg + 1);
+		} while (temp != upper && --timeout);
+
+		if (timeout == 0)
+			return -EIO;
+
+		*rt_value = (upper << 8) | lower;
+	} else {
+		lower = pdata->read(dev, reg);
+		if (lower < 0)
+			return lower;
+		*rt_value = lower;
+	}
+	return 0;
+}
+
+static int __devinit bq27000_battery_probe(struct platform_device *pdev)
+{
+	struct bq27x00_device_info *di;
+	struct bq27000_platform_data *pdata = pdev->dev.platform_data;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform_data supplied\n");
+		return -EINVAL;
+	}
+
+	if (!pdata->read) {
+		dev_err(&pdev->dev, "no hdq read callback supplied\n");
+		return -EINVAL;
+	}
+
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "failed to allocate device info data\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, di);
+
+	di->dev = &pdev->dev;
+	di->chip = BQ27000;
+
+	di->bat.name = pdata->name ?: dev_name(&pdev->dev);
+	di->bus.read = &bq27000_read_platform;
+
+	ret = bq27x00_powersupply_init(di);
+	if (ret)
+		goto err_free;
+
+	return 0;
+
+err_free:
+	platform_set_drvdata(pdev, NULL);
+	kfree(di);
+
+	return ret;
+}
+
+static int __devexit bq27000_battery_remove(struct platform_device *pdev)
+{
+	struct bq27x00_device_info *di = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&di->bat);
+	platform_set_drvdata(pdev, NULL);
+	kfree(di);
+
+	return 0;
+}
+
+static struct platform_driver bq27000_battery_driver = {
+	.probe	= bq27000_battery_probe,
+	.remove = __devexit_p(bq27000_battery_remove),
+	.driver = {
+		.name = "bq27000-battery",
+		.owner = THIS_MODULE,
+	},
+};
+
+static inline int bq27x00_battery_platform_init(void)
+{
+	int ret = platform_driver_register(&bq27000_battery_driver);
+	if (ret)
+		printk(KERN_ERR "Unable to register BQ27000 platform driver\n");
+
+	return ret;
+}
+
+static inline void bq27x00_battery_platform_exit(void)
+{
+	platform_driver_unregister(&bq27000_battery_driver);
+}
+
+#else
+
+static inline int bq27x00_battery_platform_init(void) { return 0; }
+static inline void bq27x00_battery_platform_exit(void) {};
+
+#endif
+
+/*
+ * Module stuff
+ */
+
 static int __init bq27x00_battery_init(void)
 {
 	int ret;
 
-	ret = i2c_add_driver(&bq27x00_battery_driver);
+	ret = bq27x00_battery_i2c_init();
+	if (ret)
+		return ret;
+
+	ret = bq27x00_battery_platform_init();
 	if (ret)
-		printk(KERN_ERR "Unable to register BQ27x00 driver\n");
+		bq27x00_battery_i2c_exit();
 
 	return ret;
 }
@@ -467,7 +620,8 @@ module_init(bq27x00_battery_init);
 
 static void __exit bq27x00_battery_exit(void)
 {
-	i2c_del_driver(&bq27x00_battery_driver);
+	bq27x00_battery_platform_exit();
+	bq27x00_battery_i2c_exit();
 }
 module_exit(bq27x00_battery_exit);
 
diff --git a/include/linux/power/bq27x00_battery.h b/include/linux/power/bq27x00_battery.h
new file mode 100644
index 0000000..a857f71
--- /dev/null
+++ b/include/linux/power/bq27x00_battery.h
@@ -0,0 +1,19 @@
+#ifndef __LINUX_BQ27X00_BATTERY_H__
+#define __LINUX_BQ27X00_BATTERY_H__
+
+/**
+ * struct bq27000_plaform_data - Platform data for bq27000 devices
+ * @name: Name of the battery. If NULL the driver will fallback to "bq27000".
+ * @read: HDQ read callback.
+ *	This function should provide access to the HDQ bus the battery is
+ *	connected to.
+ *	The first parameter is a pointer to the battery device, the second the
+ *	register to be read. The return value should either be the content of
+ *	the passed register or an error value.
+ */
+struct bq27000_platform_data {
+	const char *name;
+	int (*read)(struct device *dev, unsigned int);
+};
+
+#endif
-- 
1.7.2.3

