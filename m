Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2BNLDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:03:46 -0500
Received: from skyrme.org ([193.175.80.135]:34711 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab2BNLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:35 -0500
Date: 14 Feb 2012 10:34:28 +0000
Message-Id: <1329215672-15706-4-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 3/7] mfd: add I2C handling to mc13xxx driver
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1329215672-15706-1-git-send-email-oskar@scara.com>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13xxx chips may be wired to SPI or I2C, alternatively.
Up to now, mc13xxx did support SPI wiring solely.
Add support for I2C wiring, make the two alternatives
separate menu option in configuration.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/mfd/Kconfig         |   11 +++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/mc13xxx-i2c.c   |  149 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/mc13xxx.h |    2 +
 4 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/mc13xxx-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 750b50c..1dd67da 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -576,6 +576,17 @@ config MFD_MC13XXX
 	select MFD_CORE
 	select MFD_MC13783
 
+config MFD_MC13XXX_I2C
+	tristate "Support Freescale MC13783 and MC13892 with I2C"
+	select MFD_MC13XXX
+	depends on I2C && GPIOLIB
+	help
+	  Support for the Freescale (Atlas) PMIC and audio CODECs
+	  MC13783 and MC13892, wired for I2C use.
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
 config MFD_MC13XXX_SPI
 	tristate "Support Freescale MC13783 and MC13892 with SPI"
 	select MFD_MC13XXX
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 2dc66ed..17129e0 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
+obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 obj-$(CONFIG_MFD_MC13XXX_SPI)	+= mc13xxx-spi.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
new file mode 100644
index 0000000..b7b16b8
--- /dev/null
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright 2012 Oskar Schirmer <oskar@scara.com>
+ *
+ * loosely based on drivers that have
+ * Copyright 2008-2010 Freescale Semiconductor, Inc.,
+ * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de> and
+ * Copyright 2011 Texas Instruments Inc.,
+ *                      Margarita Olaya Cabrera <magi@slimlogic.co.uk>
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
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/mc13xxx.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+
+static int mc13xxx_i2c_read(struct mc13xxx *mc13xxx,
+			unsigned int offset, u32 *val)
+{
+	struct i2c_client *i2c = mc13xxx->control.i2cdev;
+	unsigned char buf[3];
+	int ret;
+
+	memset(buf, 0, 3);
+	ret = i2c_smbus_read_i2c_block_data(i2c, offset, 3, buf);
+	if (ret != 3) {
+		dev_dbg(mc13xxx->dev, "24bit read error, ret = %d %s\n",
+				ret, i2c->name);
+		return ret;
+	}
+
+	*val = buf[0] << 16 | buf[1] << 8 | buf[2];
+
+	dev_vdbg(mc13xxx->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
+
+	return 0;
+}
+
+static int mc13xxx_i2c_write(struct mc13xxx *mc13xxx,
+			unsigned int offset, u32 val)
+{
+	struct i2c_client *i2c = mc13xxx->control.i2cdev;
+	unsigned char buf[3];
+	int ret;
+
+	buf[0] = (val >> 16) & 0xff;
+	buf[1] = (val >> 8) & 0xff;
+	buf[2] = val & 0xff;
+
+	ret = i2c_smbus_write_i2c_block_data(i2c, offset, 3, buf);
+	if (ret != 0) {
+		dev_dbg(mc13xxx->dev, "24bit write error, ret = %d %s\n",
+				ret, i2c->name);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct i2c_device_id mc13xxx_i2c_device_id[] = {
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
+MODULE_DEVICE_TABLE(i2c, mc13xxx_i2c_device_id);
+
+static const struct of_device_id mc13xxx_dt_ids[] = {
+	{ .compatible = "fsl,mc13783", .data = (void *) MC13XXX_ID_MC13783, },
+	{ .compatible = "fsl,mc13892", .data = (void *) MC13XXX_ID_MC13892, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
+
+static int mc13xxx_i2c_probe(struct i2c_client *i2c,
+			const struct i2c_device_id *id)
+{
+	const struct of_device_id *of_id;
+	struct i2c_driver *idrv = to_i2c_driver(i2c->dev.driver);
+	struct mc13xxx *mc13xxx;
+
+	of_id = of_match_device(mc13xxx_dt_ids, &i2c->dev);
+	if (of_id)
+		idrv->id_table =
+			&mc13xxx_i2c_device_id[(enum mc13xxx_id) of_id->data];
+
+	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
+	if (!mc13xxx)
+		return -ENOMEM;
+
+	mc13xxx->dev = &i2c->dev;
+	mc13xxx->control.i2cdev = i2c;
+	mc13xxx->read = mc13xxx_i2c_read;
+	mc13xxx->write = mc13xxx_i2c_write;
+	mc13xxx->irq = i2c->irq;
+
+	mc13xxx->driver_data = id ? &id->driver_data : NULL;
+
+	return mc13xxx_device_init(mc13xxx);
+}
+
+static int __devexit mc13xxx_i2c_remove(struct i2c_client *i2c)
+{
+	struct mc13xxx *mc13xxx = i2c_get_clientdata(i2c);
+
+	mc13xxx_device_exit(mc13xxx);
+
+	return 0;
+}
+
+static struct i2c_driver mc13xxx_i2c_driver = {
+	.id_table = mc13xxx_i2c_device_id,
+	.driver = {
+		.name = "mc13xxx",
+		.owner = THIS_MODULE,
+	},
+	.probe = mc13xxx_i2c_probe,
+	.remove = __devexit_p(mc13xxx_i2c_remove),
+};
+
+static int __init mc13xxx_i2c_init(void)
+{
+	return i2c_add_driver(&mc13xxx_i2c_driver);
+}
+subsys_initcall(mc13xxx_i2c_init);
+
+static void __exit mc13xxx_i2c_exit(void)
+{
+	i2c_del_driver(&mc13xxx_i2c_driver);
+}
+module_exit(mc13xxx_i2c_exit);
+
+MODULE_DESCRIPTION("I2C support for Freescale MC13XXX PMIC");
+MODULE_AUTHOR("Oskar Schirmer <oskar@scara.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index 9929a8e..31c925f 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -9,6 +9,7 @@
 #ifndef __LINUX_MFD_MC13XXX_H
 #define __LINUX_MFD_MC13XXX_H
 
+#include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/spi/spi.h>
 
@@ -45,6 +46,7 @@ enum mc13xxx_id {
 struct mc13xxx {
 	struct device *dev;
 	union {
+		struct i2c_client *i2cdev;
 		struct spi_device *spidev;
 	} control;
 	struct mutex lock;
-- 
1.7.5.4

