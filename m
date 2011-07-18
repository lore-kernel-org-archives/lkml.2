Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab1GRKHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:07:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44125 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753310Ab1GRKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:07:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regmap: Add I2C bus support
Date: Mon, 18 Jul 2011 19:07:41 +0900
Message-Id: <1310983663-6404-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310983663-6404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110718100444.GD423@opensource.wolfsonmicro.com>
 <1310983663-6404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/base/regmap/Kconfig      |    4 +
 drivers/base/regmap/Makefile     |    1 +
 drivers/base/regmap/regmap-i2c.c |  115 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h           |    2 +
 5 files changed, 123 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-i2c.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index fc0eb1d..c374375 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -4,3 +4,7 @@
 
 config REGMAP
 	bool
+
+config REGMAP_I2C
+	tristate
+	default I2C
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 7532e13..ee5109d 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_REGMAP) += regmap.o
+obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
new file mode 100644
index 0000000..6237003
--- /dev/null
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -0,0 +1,115 @@
+/*
+ * Register map access API - I2C support
+ *
+ * Copyright 2011 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/regmap.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+static int regmap_i2c_write(struct device *dev, const void *data, size_t count)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+	int ret;
+
+	ret = i2c_master_send(i2c, data, count);
+	if (ret == count)
+		return 0;
+	else if (ret < 0)
+		return ret;
+	else
+		return -EIO;
+}
+
+static int regmap_i2c_gather_write(struct device *dev,
+				   const void *reg, size_t reg_size,
+				   const void *val, size_t val_size)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+	struct i2c_msg xfer[2];
+	int ret;
+
+	/* If the I2C controller can't do a gather tell the core, it
+	 * will substitute in a linear write for us.
+	 */
+	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_PROTOCOL_MANGLING))
+		return -ENOTSUPP;
+
+	xfer[0].addr = i2c->addr;
+	xfer[0].flags = 0;
+	xfer[0].len = reg_size;
+	xfer[0].buf = (void *)reg;
+
+	xfer[1].addr = i2c->addr;
+	xfer[1].flags = I2C_M_NOSTART;
+	xfer[1].len = val_size;
+	xfer[1].buf = (void *)val;
+
+	ret = i2c_transfer(i2c->adapter, xfer, 2);
+	if (ret == 2)
+		return 0;
+	if (ret < 0)
+		return ret;
+	else
+		return -EIO;
+}
+
+static int regmap_i2c_read(struct device *dev,
+			   const void *reg, size_t reg_size,
+			   void *val, size_t val_size)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+	struct i2c_msg xfer[2];
+	int ret;
+
+	xfer[0].addr = i2c->addr;
+	xfer[0].flags = 0;
+	xfer[0].len = reg_size;
+	xfer[0].buf = (void *)reg;
+
+	xfer[1].addr = i2c->addr;
+	xfer[1].flags = I2C_M_RD;
+	xfer[1].len = val_size;
+	xfer[1].buf = val;
+
+	ret = i2c_transfer(i2c->adapter, xfer, 2);
+	if (ret == 2)
+		return 0;
+	else if (ret < 0)
+		return ret;
+	else
+		return -EIO;
+}
+
+static struct regmap_bus regmap_i2c = {
+	.type = &i2c_bus_type,
+	.write = regmap_i2c_write,
+	.gather_write = regmap_i2c_gather_write,
+	.read = regmap_i2c_read,
+	.owner = THIS_MODULE,
+};
+
+/**
+ * regmap_init_i2c(): Initialise register map
+ *
+ * @dev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_i2c(struct device *dev,
+			       const struct regmap_config *config)
+{
+	return regmap_init(dev, &regmap_i2c, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_i2c);
+
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a26c1d0..e509bac 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -59,6 +59,8 @@ struct regmap_bus {
 struct regmap *regmap_init(struct device *dev,
 			   const struct regmap_bus *bus,
 			   const struct regmap_config *config);
+struct regmap *regmap_init_i2c(struct device *dev,
+			       const struct regmap_config *config);
 void regmap_exit(struct regmap *map);
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
-- 
1.7.5.4

