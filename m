Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1FVGBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:01:52 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53397 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1FVGBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:01:48 -0400
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 3/3] mfd: Add I2C control support for S5M8751
Date: Wed, 22 Jun 2011 14:53:57 +0900
Message-Id: <1308722037-6966-4-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the I2C control interface for the S5M8751.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/Kconfig       |    9 +++
 drivers/mfd/Makefile      |    2 +
 drivers/mfd/s5m8751-i2c.c |  141 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/s5m8751-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 85c91ac..4a8468c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -388,6 +388,15 @@ config MFD_WM831X_SPI
 config MFD_S5M8751
 	tristate
 
+config MFD_S5M8751_I2C
+	tristate "Support Samsung S5M8751 PMIC/Audio DAC with I2C"
+	select MFD_S5M8751
+	select MFD_CORE
+	depends on I2C
+	help
+	  S5M8751 is an advanced power management with AUDIO DAC. This option
+	  enables chip support for the S5M8751 with I2C as the control interface.
+
 config MFD_WM8350
 	bool
 	depends on GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 27f99bb..b94476e 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -96,3 +96,5 @@ obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
 s5m8751-objs			+= s5m8751-core.o
 obj-$(CONFIG_MFD_S5M8751)	+= s5m8751.o
+obj-$(CONFIG_MFD_S5M8751_I2C)	+= s5m8751-i2c.o
+
diff --git a/drivers/mfd/s5m8751-i2c.c b/drivers/mfd/s5m8751-i2c.c
new file mode 100644
index 0000000..4ca680b
--- /dev/null
+++ b/drivers/mfd/s5m8751-i2c.c
@@ -0,0 +1,141 @@
+/* linux/drivers/mfd/s5m8751-i2s.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * I2C driver for S5M8751
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/mfd/s5m8751.h>
+#include <linux/slab.h>
+
+static int s5m8751_i2c_read_device(struct s5m8751 *s5m8751, uint8_t reg,
+					uint8_t *val)
+{
+	int ret;
+	ret = i2c_smbus_read_byte_data(s5m8751->i2c_client, reg);
+	if (ret < 0) {
+		dev_err(s5m8751->dev, "failed reading at 0x%02x\n", reg);
+		return ret;
+	}
+	*val = (uint8_t)ret;
+	return 0;
+}
+
+static int s5m8751_i2c_write_device(struct s5m8751 *s5m8751, uint8_t reg,
+					uint8_t val)
+{
+	int ret;
+	ret = i2c_smbus_write_byte_data(s5m8751->i2c_client, reg, val);
+	if (ret < 0) {
+		dev_err(s5m8751->dev, "failed writing 0x%02x to 0x%02x\n",
+				val, reg);
+		return ret;
+	}
+	return 0;
+}
+
+static int s5m8751_i2c_write_block_device(struct s5m8751 *s5m8751, uint8_t reg,
+					int len, uint8_t *val)
+{
+	int ret;
+	ret = i2c_smbus_write_i2c_block_data(s5m8751->i2c_client, reg, len,
+									val);
+	if (ret < 0) {
+		dev_err(s5m8751->dev, "failed writings to 0x%02x\n", reg);
+		return ret;
+	}
+	return 0;
+}
+
+static int s5m8751_i2c_read_block_device(struct s5m8751 *s5m8751, uint8_t reg,
+					int len, uint8_t *val)
+{
+	int ret;
+	ret = i2c_smbus_read_i2c_block_data(s5m8751->i2c_client, reg, len, val);
+	if (ret < 0) {
+		dev_err(s5m8751->dev, "failed reading from 0x%02x\n", reg);
+		return ret;
+	}
+	return 0;
+}
+
+static int s5m8751_probe(struct i2c_client *i2c,
+				const struct i2c_device_id *id)
+{
+	struct s5m8751 *s5m8751;
+	int ret = 0;
+
+	s5m8751 = kzalloc(sizeof(struct s5m8751), GFP_KERNEL);
+	if (s5m8751 == NULL)
+		goto err;
+
+	i2c_set_clientdata(i2c, s5m8751);
+
+	s5m8751->dev = &i2c->dev;
+	s5m8751->i2c_client = i2c;
+	s5m8751->read_dev = s5m8751_i2c_read_device;
+	s5m8751->write_dev = s5m8751_i2c_write_device;
+	s5m8751->read_block_dev = s5m8751_i2c_read_block_device;
+	s5m8751->write_block_dev = s5m8751_i2c_write_block_device;
+
+	ret = s5m8751_device_init(s5m8751, i2c->irq, i2c->dev.platform_data);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static int s5m8751_remove(struct i2c_client *i2c)
+{
+	struct s5m8751 *s5m8751 = i2c_get_clientdata(i2c);
+
+	s5m8751_device_exit(s5m8751);
+
+	return 0;
+}
+
+static const struct i2c_device_id s5m8751_i2c_id[] = {
+	{ "s5m8751", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, s5m8751_i2c_id);
+
+static struct i2c_driver s5m8751_driver = {
+	.driver	= {
+		.name	= "s5m8751",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= s5m8751_probe,
+	.remove		= s5m8751_remove,
+	.id_table	= s5m8751_i2c_id,
+};
+
+static int __init s5m8751_init(void)
+{
+	return i2c_add_driver(&s5m8751_driver);
+}
+module_init(s5m8751_init);
+
+static void __exit s5m8751_exit(void)
+{
+	i2c_del_driver(&s5m8751_driver);
+}
+module_exit(s5m8751_exit);
+
+MODULE_DESCRIPTION("I2C Driver for Samsung S5M8751");
+MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.1

