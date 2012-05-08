Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2EHRPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:15:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33771 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756476Ab2EHRPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:15:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Implement dev_get_regmap()
Date: Tue,  8 May 2012 18:14:59 +0100
Message-Id: <1336497299-8164-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devres to implement dev_get_regmap(). This should mean that in almost
all cases devices wishing to take advantage of framework features based on
regmap shouldn't need to explicitly pass the regmap into the framework.
This simplifies device setup a bit.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regmap.c   |   61 +++++++++++++++++++++++++++++++++++++++-
 include/linux/regmap.h         |    8 ++++++
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 2eb7197..b986b86 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -45,6 +45,7 @@ struct regmap {
 	struct regmap_format format;  /* Buffer format */
 	const struct regmap_bus *bus;
 	void *bus_context;
+	const char *name;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 8a25006..567aa7a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -199,6 +199,15 @@ static void regmap_unlock_spinlock(struct regmap *map)
 	spin_unlock(&map->spinlock);
 }
 
+static void dev_get_regmap_release(struct device *dev, void *res)
+{
+	/*
+	 * We don't actually have anything to do here; the goal here
+	 * is not to manage the regmap but to provide a simple way to
+	 * get the regmap back given a struct device.
+	 */
+}
+
 /**
  * regmap_init(): Initialise register map
  *
@@ -216,7 +225,7 @@ struct regmap *regmap_init(struct device *dev,
 			   void *bus_context,
 			   const struct regmap_config *config)
 {
-	struct regmap *map;
+	struct regmap *map, **m;
 	int ret = -EINVAL;
 
 	if (!bus || !config)
@@ -256,6 +265,7 @@ struct regmap *regmap_init(struct device *dev,
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
 	map->cache_type = config->cache_type;
+	map->name = config->name;
 
 	if (config->read_flag_mask || config->write_flag_mask) {
 		map->read_flag_mask = config->read_flag_mask;
@@ -356,8 +366,19 @@ struct regmap *regmap_init(struct device *dev,
 	if (ret < 0)
 		goto err_free_workbuf;
 
+	/* Add a devres resource for dev_get_regmap() */
+	m = devres_alloc(dev_get_regmap_release, sizeof(*m), GFP_KERNEL);
+	if (!m) {
+		ret = -ENOMEM;
+		goto err_cache;
+	}
+	*m = map;
+	devres_add(dev, m);
+
 	return map;
 
+err_cache:
+	regcache_exit(map);
 err_free_workbuf:
 	kfree(map->work_buf);
 err_map:
@@ -461,6 +482,44 @@ void regmap_exit(struct regmap *map)
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
 
+static int dev_get_regmap_match(struct device *dev, void *res, void *data)
+{
+	struct regmap **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+
+	/* If the user didn't specify a name match any */
+	if (data)
+		return (*r)->name == data;
+	else
+		return 1;
+}
+
+/**
+ * dev_get_regmap(): Obtain the regmap (if any) for a device
+ *
+ * @dev: Device to retrieve the map for
+ * @name: Optional name for the register map, usually NULL.
+ *
+ * Returns the regmap for the device if one is present, or NULL.  If
+ * name is specified then it must match the name specified when
+ * registering the device, if it is NULL then the first regmap found
+ * will be used.  Devices with multiple register maps are very rare,
+ * generic code should normally not need to specify a name.
+ */
+struct regmap *dev_get_regmap(struct device *dev, const char *name)
+{
+	struct regmap **r = devres_find(dev, dev_get_regmap_release,
+					dev_get_regmap_match, (void *)name);
+
+	if (!r)
+		return NULL;
+	return *r;
+}
+EXPORT_SYMBOL_GPL(dev_get_regmap);
+
 static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			     const void *val, size_t val_len)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index ae797b1..9dbc9a1 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -170,6 +170,7 @@ struct regmap *devm_regmap_init_mmio(struct device *dev,
 void regmap_exit(struct regmap *map);
 int regmap_reinit_cache(struct regmap *map,
 			const struct regmap_config *config);
+struct regmap *dev_get_regmap(struct device *dev, const char *name);
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
@@ -354,6 +355,13 @@ static inline int regmap_register_patch(struct regmap *map,
 	return -EINVAL;
 }
 
+static inline struct regmap *dev_get_regmap(struct device *dev,
+					    const char *name)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return NULL;
+}
+
 #endif
 
 #endif
-- 
1.7.10

