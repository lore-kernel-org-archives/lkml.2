Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965143Ab1GOGXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:23:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51186 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965082Ab1GOGXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:23:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regmap: Add I2C bus support
Date: Fri, 15 Jul 2011 15:23:10 +0900
Message-Id: <1310710992-24462-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
 <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We initialise at postcore_initcall() so that we are available before users
- some users such as PMICs initialise very early. We won't actually try to
use any of the bus until a device initialises a register map.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/base/regmap/Makefile |    1 -
 drivers/i2c/Kconfig          |    4 ++
 drivers/i2c/Makefile         |    1 +
 drivers/i2c/i2c-regmap.c     |  111 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 116 insertions(+), 1 deletions(-)
 create mode 100644 drivers/i2c/i2c-regmap.c

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 1e5037e..7532e13 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,2 +1 @@
 obj-$(CONFIG_REGMAP) += regmap.o
-
diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 30f06e9..cba758b 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -6,6 +6,7 @@ menuconfig I2C
 	tristate "I2C support"
 	depends on HAS_IOMEM
 	select RT_MUTEXES
+	select I2C_REGMAP if REGMAP
 	---help---
 	  I2C (pronounce: I-square-C) is a slow serial bus protocol used in
 	  many micro controller applications and developed by Philips.  SMBus,
@@ -110,4 +111,7 @@ config I2C_DEBUG_BUS
 	  a problem with I2C support and want to see more of what is going
 	  on.
 
+config I2C_REGMAP
+	tristate
+
 endif # I2C
diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
index beee6b2..85d6699 100644
--- a/drivers/i2c/Makefile
+++ b/drivers/i2c/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_I2C)		+= i2c-core.o
 obj-$(CONFIG_I2C_SMBUS)		+= i2c-smbus.o
 obj-$(CONFIG_I2C_CHARDEV)	+= i2c-dev.o
 obj-$(CONFIG_I2C_MUX)		+= i2c-mux.o
+obj-$(CONFIG_I2C_REGMAP)	+= i2c-regmap.o
 obj-y				+= algos/ busses/ muxes/
 
 ccflags-$(CONFIG_I2C_DEBUG_CORE) := -DDEBUG
diff --git a/drivers/i2c/i2c-regmap.c b/drivers/i2c/i2c-regmap.c
new file mode 100644
index 0000000..6a60eb3
--- /dev/null
+++ b/drivers/i2c/i2c-regmap.c
@@ -0,0 +1,111 @@
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

