Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2CKC2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 21:28:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2CKC1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 21:27:31 -0500
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, Marc Reilly <marc@cpdesign.com.au>
Subject: [PATCH v2 3/3] mfd: mc13xxx-core: Add i2c driver
Date: Sun, 11 Mar 2012 12:30:02 +1100
Message-Id: <1331429402-9639-4-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331429402-9639-1-git-send-email-marc@cpdesign.com.au>
References: <1331429402-9639-1-git-send-email-marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for mc13xxx family ICs connected via i2c.

Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/mfd/Kconfig       |    8 ++-
 drivers/mfd/Makefile      |    1 +
 drivers/mfd/mc13xxx-i2c.c |  143 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/mc13xxx.h     |    5 +-
 4 files changed, 155 insertions(+), 2 deletions(-)
 create mode 100644 drivers/mfd/mc13xxx-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 501fee5..3a039ff 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -573,7 +573,7 @@ config MFD_MC13783
 
 config MFD_MC13XXX
 	tristate "Support Freescale MC13783 and MC13892"
-	depends on SPI_MASTER
+	depends on SPI_MASTER || I2C
 	select MFD_CORE
 	select MFD_MC13783
 	help
@@ -590,6 +590,12 @@ config MFD_MC13XXX_SPI
 	help
 	  Select this if your MC13xxx is connected via an SPI bus.
 
+config MFD_MC13XXX_I2C
+	tristate "MC13xxx I2C interface" if I2C
+	default I2C
+	help
+	  Select this if your MC13xxx is connected via an I2C bus.
+
 endif
 
 config ABX500_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 2dc66ed..6d4566f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
 obj-$(CONFIG_MFD_MC13XXX_SPI)	+= mc13xxx-spi.o
+obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
new file mode 100644
index 0000000..100c9e6
--- /dev/null
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -0,0 +1,143 @@
+/*
+ * Copyright 2009-2010 Creative Product Design
+ * Marc Reilly marc@cpdesign.com.au
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
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/mc13xxx.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+
+#include "mc13xxx.h"
+
+static int mc13xxx_i2c_reg_read(struct mc13xxx *mc13xxx, unsigned int offset,
+		u32 *val)
+{
+	int ret;
+	unsigned char buf[3] = {0, 0, 0};
+
+	ret = i2c_smbus_read_i2c_block_data(mc13xxx->i2cclient,
+			offset, 3, buf);
+	*val = buf[0] << 16 | buf[1] << 8 | buf[2];
+
+	return ret == 3 ? 0 : ret;
+}
+
+static int mc13xxx_i2c_reg_write(struct mc13xxx *mc13xxx, unsigned int offset,
+		u32 val)
+{
+	int ret;
+	unsigned char buf[3];
+
+	buf[0] = (val >> 16) & 0xff;
+	buf[1] = (val >> 8) & 0xff;
+	buf[2] = val & 0xff;
+
+	ret = i2c_smbus_write_i2c_block_data(mc13xxx->i2cclient,
+			offset, 3, buf);
+
+	return ret;
+}
+
+static const struct i2c_device_id mc13xxx_i2c_device_id[] = {
+	{
+		.name = "mc13783",
+		.driver_data = MC13XXX_ID_MC13783
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
+static int mc13xxx_i2c_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	const struct of_device_id *of_id;
+	struct i2c_driver *idrv = to_i2c_driver(client->dev.driver);
+	struct mc13xxx *mc13xxx;
+	struct mc13xxx_platform_data *pdata = dev_get_platdata(&client->dev);
+	int ret;
+
+	of_id = of_match_device(mc13xxx_dt_ids, &client->dev);
+	if (of_id)
+		idrv->id_table =
+			&mc13xxx_i2c_device_id[(enum mc13xxx_id) of_id->data];
+
+	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
+	if (!mc13xxx)
+		return -ENOMEM;
+
+	dev_set_drvdata(&client->dev, mc13xxx);
+	mc13xxx->dev = &client->dev;
+	mc13xxx->i2cclient = client;
+	mc13xxx->read_dev = mc13xxx_i2c_reg_read;
+	mc13xxx->write_dev = mc13xxx_i2c_reg_write;
+
+	ret = mc13xxx_common_init(mc13xxx, pdata, client->irq);
+
+	if (ret == 0 && (id->driver_data != mc13xxx->ictype))
+		dev_warn(mc13xxx->dev,
+				"device id doesn't match auto detection!\n");
+
+	return ret;
+}
+
+static int __devexit mc13xxx_i2c_remove(struct i2c_client *client)
+{
+	struct mc13xxx *mc13xxx = dev_get_drvdata(&client->dev);
+
+	free_irq(client->irq, mc13xxx);
+
+	mfd_remove_devices(&client->dev);
+
+	kfree(mc13xxx);
+
+	return 0;
+}
+
+static struct i2c_driver mc13xxx_i2c_driver = {
+	.id_table = mc13xxx_i2c_device_id,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "mc13xxx",
+		.of_match_table = mc13xxx_dt_ids,
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
+MODULE_DESCRIPTION("i2c driver for Freescale MC13XXX PMIC");
+MODULE_AUTHOR("Marc Reilly <marc@cpdesign.com.au");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/mc13xxx.h b/drivers/mfd/mc13xxx.h
index fbec2d1..13f83ed 100644
--- a/drivers/mfd/mc13xxx.h
+++ b/drivers/mfd/mc13xxx.h
@@ -19,7 +19,10 @@ enum mc13xxx_id {
 };
 
 struct mc13xxx {
-	struct spi_device *spidev;
+	union {
+		struct spi_device *spidev;
+		struct i2c_client *i2cclient;
+	};
 
 	struct device *dev;
 	enum mc13xxx_id ictype;
-- 
1.7.3.4

