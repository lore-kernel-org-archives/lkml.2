Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab1F3GB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:01:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54298 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752512Ab1F3GAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:00:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/8] regmap: Add I2C bus support
Date: Wed, 29 Jun 2011 23:00:30 -0700
Message-Id: <1309413636-1169-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309413636-1169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110630055844.GC796@opensource.wolfsonmicro.com>
 <1309413636-1169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We initialise at postcore_initcall() so that we are available before users
- some users such as PMICs initialise very early. We won't actually try to
use any of the bus until a device initialises a register map.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regmap/Makefile     |    2 +-
 drivers/regmap/regmap-i2c.c |  113 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 1 deletions(-)
 create mode 100644 drivers/regmap/regmap-i2c.c

diff --git a/drivers/regmap/Makefile b/drivers/regmap/Makefile
index 1e5037e..641c20a 100644
--- a/drivers/regmap/Makefile
+++ b/drivers/regmap/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_REGMAP) += regmap.o
-
+obj-$(CONFIG_I2C) += regmap-i2c.o
diff --git a/drivers/regmap/regmap-i2c.c b/drivers/regmap/regmap-i2c.c
new file mode 100644
index 0000000..19d0739
--- /dev/null
+++ b/drivers/regmap/regmap-i2c.c
@@ -0,0 +1,113 @@
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
+	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_PROTOCOL_MANGLING))
+		return -ENOTSUPP;
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
+static int __init regmap_i2c_init(void)
+{
+	regmap_add_bus(&regmap_i2c);
+	return 0;
+}
+postcore_initcall(regmap_i2c_init);
+
+static void __exit regmap_i2c_exit(void)
+{
+	regmap_del_bus(&regmap_i2c);
+}
+module_exit(regmap_i2c_exit);
-- 
1.7.5.4

