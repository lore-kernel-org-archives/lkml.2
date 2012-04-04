Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab2DDVtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:49:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47099 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2DDVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:48:44 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/6] regmap: introduce explicit bus_context for bus callbacks
Date: Wed,  4 Apr 2012 15:48:30 -0600
Message-Id: <1333576113-13196-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The only context needed by I2C and SPI bus definitions is the device
itself; this can be converted to an i2c_client or spi_device in order
to perform IO on the device. However, other bus types may need more
context in order to perform IO. Enable this by having regmap_init accept
a bus_context parameter, and pass this to all bus callbacks. The
existing callbacks simply pass the struct device here. Future bus types
may pass something else.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/internal.h   |    1 +
 drivers/base/regmap/regmap-i2c.c |   13 ++++++++-----
 drivers/base/regmap/regmap-spi.c |   13 ++++++++-----
 drivers/base/regmap/regmap.c     |   19 +++++++++++++------
 include/linux/regmap.h           |   10 +++++++---
 5 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index d9ea8f5..9bc1d27 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -44,6 +44,7 @@ struct regmap {
 	void *work_buf;     /* Scratch buffer used to format I/O */
 	struct regmap_format format;  /* Buffer format */
 	const struct regmap_bus *bus;
+	void *bus_context;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 9a3a8c5..5f6b247 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -15,8 +15,9 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-static int regmap_i2c_write(struct device *dev, const void *data, size_t count)
+static int regmap_i2c_write(void *context, const void *data, size_t count)
 {
+	struct device *dev = context;
 	struct i2c_client *i2c = to_i2c_client(dev);
 	int ret;
 
@@ -29,10 +30,11 @@ static int regmap_i2c_write(struct device *dev, const void *data, size_t count)
 		return -EIO;
 }
 
-static int regmap_i2c_gather_write(struct device *dev,
+static int regmap_i2c_gather_write(void *context,
 				   const void *reg, size_t reg_size,
 				   const void *val, size_t val_size)
 {
+	struct device *dev = context;
 	struct i2c_client *i2c = to_i2c_client(dev);
 	struct i2c_msg xfer[2];
 	int ret;
@@ -62,10 +64,11 @@ static int regmap_i2c_gather_write(struct device *dev,
 		return -EIO;
 }
 
-static int regmap_i2c_read(struct device *dev,
+static int regmap_i2c_read(void *context,
 			   const void *reg, size_t reg_size,
 			   void *val, size_t val_size)
 {
+	struct device *dev = context;
 	struct i2c_client *i2c = to_i2c_client(dev);
 	struct i2c_msg xfer[2];
 	int ret;
@@ -107,7 +110,7 @@ static struct regmap_bus regmap_i2c = {
 struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config)
 {
-	return regmap_init(&i2c->dev, &regmap_i2c, config);
+	return regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
 }
 EXPORT_SYMBOL_GPL(regmap_init_i2c);
 
@@ -124,7 +127,7 @@ EXPORT_SYMBOL_GPL(regmap_init_i2c);
 struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config)
 {
-	return devm_regmap_init(&i2c->dev, &regmap_i2c, config);
+	return devm_regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
 }
 EXPORT_SYMBOL_GPL(devm_regmap_init_i2c);
 
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 7c0c35a..ffa46a9 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -15,17 +15,19 @@
 #include <linux/init.h>
 #include <linux/module.h>
 
-static int regmap_spi_write(struct device *dev, const void *data, size_t count)
+static int regmap_spi_write(void *context, const void *data, size_t count)
 {
+	struct device *dev = context;
 	struct spi_device *spi = to_spi_device(dev);
 
 	return spi_write(spi, data, count);
 }
 
-static int regmap_spi_gather_write(struct device *dev,
+static int regmap_spi_gather_write(void *context,
 				   const void *reg, size_t reg_len,
 				   const void *val, size_t val_len)
 {
+	struct device *dev = context;
 	struct spi_device *spi = to_spi_device(dev);
 	struct spi_message m;
 	struct spi_transfer t[2] = { { .tx_buf = reg, .len = reg_len, },
@@ -38,10 +40,11 @@ static int regmap_spi_gather_write(struct device *dev,
 	return spi_sync(spi, &m);
 }
 
-static int regmap_spi_read(struct device *dev,
+static int regmap_spi_read(void *context,
 			   const void *reg, size_t reg_size,
 			   void *val, size_t val_size)
 {
+	struct device *dev = context;
 	struct spi_device *spi = to_spi_device(dev);
 
 	return spi_write_then_read(spi, reg, reg_size, val, val_size);
@@ -66,7 +69,7 @@ static struct regmap_bus regmap_spi = {
 struct regmap *regmap_init_spi(struct spi_device *spi,
 			       const struct regmap_config *config)
 {
-	return regmap_init(&spi->dev, &regmap_spi, config);
+	return regmap_init(&spi->dev, &regmap_spi, &spi->dev, config);
 }
 EXPORT_SYMBOL_GPL(regmap_init_spi);
 
@@ -83,7 +86,7 @@ EXPORT_SYMBOL_GPL(regmap_init_spi);
 struct regmap *devm_regmap_init_spi(struct spi_device *spi,
 				    const struct regmap_config *config)
 {
-	return devm_regmap_init(&spi->dev, &regmap_spi, config);
+	return devm_regmap_init(&spi->dev, &regmap_spi, &spi->dev, config);
 }
 EXPORT_SYMBOL_GPL(devm_regmap_init_spi);
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 339b2c8..2b5e7ae 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -204,6 +204,7 @@ static void regmap_unlock_spinlock(struct regmap *map)
  *
  * @dev: Device that will be interacted with
  * @bus: Bus-specific callbacks to use with device
+ * @bus_context: Data passed to bus-specific callbacks
  * @config: Configuration for register map
  *
  * The return value will be an ERR_PTR() on error or a valid pointer to
@@ -212,6 +213,7 @@ static void regmap_unlock_spinlock(struct regmap *map)
  */
 struct regmap *regmap_init(struct device *dev,
 			   const struct regmap_bus *bus,
+			   void *bus_context,
 			   const struct regmap_config *config)
 {
 	struct regmap *map;
@@ -243,6 +245,7 @@ struct regmap *regmap_init(struct device *dev,
 	map->reg_shift = config->pad_bits % 8;
 	map->dev = dev;
 	map->bus = bus;
+	map->bus_context = bus_context;
 	map->max_register = config->max_register;
 	map->writeable_reg = config->writeable_reg;
 	map->readable_reg = config->readable_reg;
@@ -370,6 +373,7 @@ static void devm_regmap_release(struct device *dev, void *res)
  *
  * @dev: Device that will be interacted with
  * @bus: Bus-specific callbacks to use with device
+ * @bus_context: Data passed to bus-specific callbacks
  * @config: Configuration for register map
  *
  * The return value will be an ERR_PTR() on error or a valid pointer
@@ -379,6 +383,7 @@ static void devm_regmap_release(struct device *dev, void *res)
  */
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
+				void *bus_context,
 				const struct regmap_config *config)
 {
 	struct regmap **ptr, *regmap;
@@ -387,7 +392,7 @@ struct regmap *devm_regmap_init(struct device *dev,
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	regmap = regmap_init(dev, bus, config);
+	regmap = regmap_init(dev, bus, bus_context, config);
 	if (!IS_ERR(regmap)) {
 		*ptr = regmap;
 		devres_add(dev, ptr);
@@ -445,6 +450,8 @@ void regmap_exit(struct regmap *map)
 {
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
+	if (map->bus->free_context)
+		map->bus->free_context(map->bus_context);
 	kfree(map->work_buf);
 	kfree(map);
 }
@@ -498,12 +505,12 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	 */
 	if (val == (map->work_buf + map->format.pad_bytes +
 		    map->format.reg_bytes))
-		ret = map->bus->write(map->dev, map->work_buf,
+		ret = map->bus->write(map->bus_context, map->work_buf,
 				      map->format.reg_bytes +
 				      map->format.pad_bytes +
 				      val_len);
 	else if (map->bus->gather_write)
-		ret = map->bus->gather_write(map->dev, map->work_buf,
+		ret = map->bus->gather_write(map->bus_context, map->work_buf,
 					     map->format.reg_bytes +
 					     map->format.pad_bytes,
 					     val, val_len);
@@ -518,7 +525,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		memcpy(buf, map->work_buf, map->format.reg_bytes);
 		memcpy(buf + map->format.reg_bytes + map->format.pad_bytes,
 		       val, val_len);
-		ret = map->bus->write(map->dev, buf, len);
+		ret = map->bus->write(map->bus_context, buf, len);
 
 		kfree(buf);
 	}
@@ -552,7 +559,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 		trace_regmap_hw_write_start(map->dev, reg, 1);
 
-		ret = map->bus->write(map->dev, map->work_buf,
+		ret = map->bus->write(map->bus_context, map->work_buf,
 				      map->format.buf_size);
 
 		trace_regmap_hw_write_done(map->dev, reg, 1);
@@ -693,7 +700,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	trace_regmap_hw_read_start(map->dev, reg,
 				   val_len / map->format.val_bytes);
 
-	ret = map->bus->read(map->dev, map->work_buf,
+	ret = map->bus->read(map->bus_context, map->work_buf,
 			     map->format.reg_bytes + map->format.pad_bytes,
 			     val, val_len);
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 2fd41e3..3ff16f0 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -102,14 +102,15 @@ struct regmap_config {
 	u8 write_flag_mask;
 };
 
-typedef int (*regmap_hw_write)(struct device *dev, const void *data,
+typedef int (*regmap_hw_write)(void *context, const void *data,
 			       size_t count);
-typedef int (*regmap_hw_gather_write)(struct device *dev,
+typedef int (*regmap_hw_gather_write)(void *context,
 				      const void *reg, size_t reg_len,
 				      const void *val, size_t val_len);
-typedef int (*regmap_hw_read)(struct device *dev,
+typedef int (*regmap_hw_read)(void *context,
 			      const void *reg_buf, size_t reg_size,
 			      void *val_buf, size_t val_size);
+typedef void (*regmap_hw_free_context)(void *context);
 
 /**
  * Description of a hardware bus for the register map infrastructure.
@@ -129,11 +130,13 @@ struct regmap_bus {
 	regmap_hw_write write;
 	regmap_hw_gather_write gather_write;
 	regmap_hw_read read;
+	regmap_hw_free_context free_context;
 	u8 read_flag_mask;
 };
 
 struct regmap *regmap_init(struct device *dev,
 			   const struct regmap_bus *bus,
+			   void *bus_context,
 			   const struct regmap_config *config);
 struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config);
@@ -142,6 +145,7 @@ struct regmap *regmap_init_spi(struct spi_device *dev,
 
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
+				void *bus_context,
 				const struct regmap_config *config);
 struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config);
-- 
1.7.0.4

