Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1IGQLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:11:48 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:48707 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1IGQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:11:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/6] regmap: Add a magic bus type to handle quirks of analog devices ADIS sensors.
Date: Wed,  7 Sep 2011 17:19:43 +0100
Message-Id: <1315412387-5765-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E679770.4090008@cam.ac.uk>
References: <4E679770.4090008@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These devices look like 8 bit registers for writes and 16 bit registers for
reads.  As you might imagine this causes some 'issues' hence this regmap
bus implementation claims they are always 16bit and does the mangling to
make the writes work.
---
 drivers/base/regmap/Kconfig          |    5 ++-
 drivers/base/regmap/Makefile         |    1 +
 drivers/base/regmap/regmap-spi-adi.c |   70 ++++++++++++++++++++++++++++++++++
 include/linux/regmap.h               |    2 +
 4 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index fabbf6c..e4991fe 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -3,7 +3,7 @@
 # subsystems should select the appropriate symbols.
 
 config REGMAP
-	default y if (REGMAP_I2C || REGMAP_SPI)
+	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPI_ADI)
 	bool
 
 config REGMAP_I2C
@@ -11,3 +11,6 @@ config REGMAP_I2C
 
 config REGMAP_SPI
 	tristate
+
+config REGMAP_SPI_ADI
+	tristate
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 057c13f..9e71bf8 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_REGMAP) += regmap.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
+obj-$(CONFIG_REGMAP_SPI_ADI) += regmap-spi-adi.o
diff --git a/drivers/base/regmap/regmap-spi-adi.c b/drivers/base/regmap/regmap-spi-adi.c
new file mode 100644
index 0000000..a98c000
--- /dev/null
+++ b/drivers/base/regmap/regmap-spi-adi.c
@@ -0,0 +1,70 @@
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
+#include <linux/module.h>
+
+static int regmap_spi_write(struct device *dev, const void *data, size_t count)
+{
+/* Now this only works for 8 bit addresss 16 bit register first byte of data
+ * is the lower address, second two the value */
+	struct spi_device *spi = to_spi_device(dev);
+	int ret;
+	u8 *rawdata = (u8 *)data;
+
+	BUG_ON(count != 3);
+	/* Fiddling needed as the value is bigendian */
+	rawdata[0] += 1;
+	ret = spi_write(spi, data, 2);
+	if (ret < 0)
+		return ret;
+
+	rawdata[1] = rawdata[0] - 1;
+	ret = spi_write(spi, data + 1, 2);
+	return ret;
+}
+
+static int regmap_spi_read(struct device *dev,
+			   const void *reg, size_t reg_size,
+			   void *val, size_t val_size)
+{
+	struct spi_device *spi = to_spi_device(dev);
+
+	BUG_ON(reg_size != 1 || val_size != 2);
+
+	return spi_write_then_read(spi, reg, 2, val, val_size);
+}
+
+static struct regmap_bus regmap_spi_adi = {
+	.write = regmap_spi_write,
+	.read = regmap_spi_read,
+};
+
+/**
+ * regmap_init_spi_adi(): Initialise register map
+ *
+ * @spi: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_spi_adi(struct spi_device *spi,
+				   const struct regmap_config *config)
+{
+	return regmap_init(&spi->dev, &regmap_spi_adi, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_spi_adi);
+
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 18d4afa..a827c30 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -111,6 +111,8 @@ struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config);
 struct regmap *regmap_init_spi(struct spi_device *dev,
 			       const struct regmap_config *config);
+struct regmap *regmap_init_spi_adi(struct spi_device *dev,
+			       const struct regmap_config *config);
 
 void regmap_exit(struct regmap *map);
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
-- 
1.7.3.4

