Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2A3UCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:02:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37746 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab2A3UCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:02:37 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Implement managed regmap_init()
Date: Mon, 30 Jan 2012 20:02:35 +0000
Message-Id: <1327953755-27246-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save error handling and unwinding code in drivers by providing managed
versions of the regmap init functions, simplifying usage.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-i2c.c |   17 ++++++++++++++++
 drivers/base/regmap/regmap-spi.c |   17 ++++++++++++++++
 drivers/base/regmap/regmap.c     |   39 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h           |    8 +++++++
 4 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 38621ec..9a3a8c5 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -111,4 +111,21 @@ struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 }
 EXPORT_SYMBOL_GPL(regmap_init_i2c);
 
+/**
+ * devm_regmap_init_i2c(): Initialise managed register map
+ *
+ * @i2c: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
+				    const struct regmap_config *config)
+{
+	return devm_regmap_init(&i2c->dev, &regmap_i2c, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_i2c);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 2560658..7c0c35a 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -70,4 +70,21 @@ struct regmap *regmap_init_spi(struct spi_device *spi,
 }
 EXPORT_SYMBOL_GPL(regmap_init_spi);
 
+/**
+ * devm_regmap_init_spi(): Initialise register map
+ *
+ * @spi: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The map will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_spi(struct spi_device *spi,
+				    const struct regmap_config *config)
+{
+	return devm_regmap_init(&spi->dev, &regmap_spi, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_spi);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a4e189c..1fc666c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -278,6 +278,45 @@ err:
 }
 EXPORT_SYMBOL_GPL(regmap_init);
 
+static void devm_regmap_release(struct device *dev, void *res)
+{
+	regmap_exit(*(struct regmap **)res);
+}
+
+/**
+ * devm_regmap_init(): Initialise managed register map
+ *
+ * @dev: Device that will be interacted with
+ * @bus: Bus-specific callbacks to use with device
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  This function should generally not be called
+ * directly, it should be called by bus-specific init functions.  The
+ * map will be automatically freed by the device management code.
+ */
+struct regmap *devm_regmap_init(struct device *dev,
+				const struct regmap_bus *bus,
+				const struct regmap_config *config)
+{
+	struct regmap **ptr, *regmap;
+
+	ptr = devres_alloc(devm_regmap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	regmap = regmap_init(dev, bus, config);
+	if (!IS_ERR(regmap)) {
+		*ptr = regmap;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return regmap;
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init);
+
 /**
  * regmap_reinit_cache(): Reinitialise the current register cache
  *
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e8a31a3..5d26599 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -129,6 +129,14 @@ struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 struct regmap *regmap_init_spi(struct spi_device *dev,
 			       const struct regmap_config *config);
 
+struct regmap *devm_regmap_init(struct device *dev,
+				const struct regmap_bus *bus,
+				const struct regmap_config *config);
+struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
+				    const struct regmap_config *config);
+struct regmap *devm_regmap_init_spi(struct spi_device *dev,
+				    const struct regmap_config *config);
+
 void regmap_exit(struct regmap *map);
 int regmap_reinit_cache(struct regmap *map,
 			const struct regmap_config *config);
-- 
1.7.9.rc1

