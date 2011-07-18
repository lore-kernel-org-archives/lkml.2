Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1GRKIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:08:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44139 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753972Ab1GRKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:07:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regmap: Add SPI bus support
Date: Mon, 18 Jul 2011 19:07:42 +0900
Message-Id: <1310983663-6404-3-git-send-email-broonie@opensource.wolfsonmicro.com>
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
 drivers/base/regmap/Kconfig      |    4 ++
 drivers/base/regmap/Makefile     |    1 +
 drivers/base/regmap/regmap-spi.c |   73 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h           |    3 ++
 5 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-spi.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index c374375..54b5854 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -8,3 +8,7 @@ config REGMAP
 config REGMAP_I2C
 	tristate
 	default I2C
+
+config REGMAP_SPI
+	tristate
+	default SPI_MASTER
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index ee5109d..f476f45 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_REGMAP) += regmap.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
+obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
new file mode 100644
index 0000000..b994218
--- /dev/null
+++ b/drivers/base/regmap/regmap-spi.c
@@ -0,0 +1,73 @@
+/*
+ * Register map access API - SPI support
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
+#include <linux/spi/spi.h>
+#include <linux/init.h>
+
+static int regmap_spi_write(struct device *dev, const void *data, size_t count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+
+	return spi_write(spi, data, count);
+}
+
+static int regmap_spi_gather_write(struct device *dev,
+				   const void *reg, size_t reg_len,
+				   const void *val, size_t val_len)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct spi_message m;
+	struct spi_transfer t[2] = { { .tx_buf = reg, .len = reg_len, },
+				     { .tx_buf = val, .len = val_len, }, };
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t[0], &m);
+	spi_message_add_tail(&t[1], &m);
+
+	return spi_sync(spi, &m);
+}
+
+static int regmap_spi_read(struct device *dev,
+			   const void *reg, size_t reg_size,
+			   void *val, size_t val_size)
+{
+	struct spi_device *spi = to_spi_device(dev);
+
+	return spi_write_then_read(spi, reg, reg_size, val, val_size);
+}
+
+static struct regmap_bus regmap_spi = {
+	.type = &spi_bus_type,
+	.write = regmap_spi_write,
+	.gather_write = regmap_spi_gather_write,
+	.read = regmap_spi_read,
+	.owner = THIS_MODULE,
+	.read_flag_mask = 0x80,
+};
+
+/**
+ * regmap_init_spi(): Initialise register map
+ *
+ * @dev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_spi(struct device *dev,
+			       const struct regmap_config *config)
+{
+	return regmap_init(dev, &regmap_spi, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_spi);
+
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e509bac..c549632 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -61,6 +61,9 @@ struct regmap *regmap_init(struct device *dev,
 			   const struct regmap_config *config);
 struct regmap *regmap_init_i2c(struct device *dev,
 			       const struct regmap_config *config);
+struct regmap *regmap_init_spi(struct device *dev,
+			       const struct regmap_config *config);
+
 void regmap_exit(struct regmap *map);
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
-- 
1.7.5.4

