Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2BOVAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:00:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12890 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2BOVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:00:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 15 Feb 2012 13:00:49 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: Store mapping table as a list of chunks
Date: Wed, 15 Feb 2012 14:00:46 -0700
Message-Id: <1329339646-19472-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of storing a single array of mapping table entries, which
requires realloc()ing that array each time it's extended and copying
the new data, simply store a list of pointers to the individual chunks.
This also removes the need to copy the mapping table at all; a pointer
is maintained to the original table, this saving memory.

A macro for_each_maps() is introduced to hide the additional complexity
of iterating over the map entries.

This change will also simplify removing chunks of entries from the mapping
table. This isn't important right now, but will be in the future, when
mapping table entries are dynamically added when parsing them from the
device tree, and removed when drivers no longer need to interact with
pinctrl.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This depends on my previous patch "pinctrl: Make "hog" mapping table
entries work", since both touch the same line in pinctrl_hog_map.

 arch/arm/mach-u300/core.c |    2 +-
 drivers/pinctrl/core.c    |  104 +++++++++++++++++++++++++++-----------------
 2 files changed, 65 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index d66bc97..5af05fb 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1552,7 +1552,7 @@ static struct platform_device pinmux_device = {
 };
 
 /* Pinmux settings */
-static struct pinctrl_map __initdata u300_pinmux_map[] = {
+static struct pinctrl_map u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
 	PIN_MAP_SYS_HOG("POWER", "pinmux-u300", "power"),
 	PIN_MAP_SYS_HOG("EMIF0", "pinmux-u300", "emif0"),
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 8a91eb2..2a61b43 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -7,6 +7,8 @@
  *
  * Author: Linus Walleij <linus.walleij@linaro.org>
  *
+ * Copyright (C) 2012 NVIDIA CORPORATION. All rights reserved.
+ *
  * License terms: GNU General Public License (GPL) version 2
  */
 #define pr_fmt(fmt) "pinctrl core: " fmt
@@ -31,6 +33,18 @@
 #include "pinconf.h"
 
 /**
+ * struct pinctrl_maps - a list item containing part of the mapping table
+ * @node: mapping table list node
+ * @maps: array of mapping table entries
+ * @num_maps: the number of entries in @maps
+ */
+struct pinctrl_maps {
+	struct list_head node;
+	struct pinctrl_map const *maps;
+	unsigned num_maps;
+};
+
+/**
  * struct pinctrl_hog - a list item to stash control hogs
  * @node: pin control hog list node
  * @map: map entry responsible for this hogging
@@ -51,8 +65,14 @@ static DEFINE_MUTEX(pinctrl_list_mutex);
 static LIST_HEAD(pinctrl_list);
 
 /* Global pinctrl maps */
-static struct pinctrl_map *pinctrl_maps;
-static unsigned pinctrl_maps_num;
+static DEFINE_MUTEX(pinctrl_maps_mutex);
+static LIST_HEAD(pinctrl_maps);
+
+#define for_each_maps(_maps_node_, _i_, _map_) \
+	list_for_each_entry(_maps_node_, &pinctrl_maps, node) \
+		for (_i_ = 0, _map_ = &_maps_node_->maps[_i_]; \
+			_i_ < _maps_node_->num_maps; \
+			i++, _map_ = &_maps_node_->maps[_i_])
 
 const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev)
 {
@@ -455,22 +475,23 @@ int pinctrl_gpio_direction_output(unsigned gpio)
 EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 
 /**
- * pinctrl_get() - retrieves the pin controller handle for a certain device
+ * pinctrl_get_locked() - retrieves the pin controller handle for a certain device
  * @dev: the device to get the pin controller handle for
  * @name: an optional specific control mapping name or NULL, the name is only
  *	needed if you want to have more than one mapping per device, or if you
  *	need an anonymous pin control (not tied to any specific device)
  */
-struct pinctrl *pinctrl_get(struct device *dev, const char *name)
+struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 {
-	struct pinctrl_map const *map = NULL;
 	struct pinctrl_dev *pctldev = NULL;
 	const char *devname = NULL;
 	struct pinctrl *p;
 	bool found_map;
 	unsigned num_maps = 0;
 	int ret = -ENODEV;
+	struct pinctrl_maps *maps_node;
 	int i;
+	struct pinctrl_map const *map;
 
 	/* We must have dev or ID or both */
 	if (!dev && !name)
@@ -494,8 +515,7 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 	pinmux_init_pinctrl_handle(p);
 
 	/* Iterate over the pin control maps to locate the right ones */
-	for (i = 0; i < pinctrl_maps_num; i++) {
-		map = &pinctrl_maps[i];
+	for_each_maps(maps_node, i, map) {
 		found_map = false;
 
 		/*
@@ -515,7 +535,6 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 		pr_debug("in map, found pctldev %s to handle function %s",
 			 dev_name(pctldev->dev), map->function);
 
-
 		/*
 		 * If we're looking for a specific named map, this must match,
 		 * else we loop and look for the next.
@@ -574,6 +593,17 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 
 	return p;
 }
+
+struct pinctrl *pinctrl_get(struct device *dev, const char *name)
+{
+	struct pinctrl *p;
+
+	mutex_lock(&pinctrl_maps_mutex);
+	p = pinctrl_get_locked(dev, name);
+	mutex_unlock(&pinctrl_maps_mutex);
+
+	return p;
+}
 EXPORT_SYMBOL_GPL(pinctrl_get);
 
 /**
@@ -654,8 +684,8 @@ EXPORT_SYMBOL_GPL(pinctrl_disable);
 int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
 				     unsigned num_maps)
 {
-	void *tmp_maps;
 	int i;
+	struct pinctrl_maps *maps_node;
 
 	pr_debug("add %d pinmux maps\n", num_maps);
 
@@ -689,31 +719,17 @@ int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
 				 maps[i].function);
 	}
 
-	/*
-	 * Make a copy of the map array - string pointers will end up in the
-	 * kernel const section anyway so these do not need to be deep copied.
-	 */
-	if (!pinctrl_maps_num) {
-		/* On first call, just copy them */
-		tmp_maps = kmemdup(maps,
-				   sizeof(struct pinctrl_map) * num_maps,
-				   GFP_KERNEL);
-		if (!tmp_maps)
-			return -ENOMEM;
-	} else {
-		/* Subsequent calls, reallocate array to new size */
-		size_t oldsize = sizeof(struct pinctrl_map) * pinctrl_maps_num;
-		size_t newsize = sizeof(struct pinctrl_map) * num_maps;
+	maps_node = kzalloc(sizeof(*maps), GFP_KERNEL);
+	if (!maps_node)
+		return -ENOMEM;
 
-		tmp_maps = krealloc(pinctrl_maps,
-				    oldsize + newsize, GFP_KERNEL);
-		if (!tmp_maps)
-			return -ENOMEM;
-		memcpy((tmp_maps + oldsize), maps, newsize);
-	}
+	maps_node->maps = maps;
+	maps_node->num_maps = num_maps;
+
+	mutex_lock(&pinctrl_maps_mutex);
+	list_add(&maps_node->node, &pinctrl_maps);
+	mutex_unlock(&pinctrl_maps_mutex);
 
-	pinctrl_maps = tmp_maps;
-	pinctrl_maps_num += num_maps;
 	return 0;
 }
 
@@ -729,7 +745,7 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 	if (!hog)
 		return -ENOMEM;
 
-	p = pinctrl_get(pctldev->dev, map->name);
+	p = pinctrl_get_locked(pctldev->dev, map->name);
 	if (IS_ERR(p)) {
 		kfree(hog);
 		dev_err(pctldev->dev,
@@ -773,23 +789,28 @@ int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
 	struct device *dev = pctldev->dev;
 	const char *devname = dev_name(dev);
 	int ret;
+	struct pinctrl_maps *maps_node;
 	int i;
+	struct pinctrl_map const *map;
 
 	INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
 	mutex_init(&pctldev->pinctrl_hogs_lock);
 
-	for (i = 0; i < pinctrl_maps_num; i++) {
-		struct pinctrl_map const *map = &pinctrl_maps[i];
-
+	mutex_lock(&pinctrl_maps_mutex);
+	for_each_maps(maps_node, i, map) {
 		if (map->ctrl_dev_name &&
 		    !strcmp(map->ctrl_dev_name, devname) &&
 		    !strcmp(map->dev_name, devname)) {
 			/* OK time to hog! */
 			ret = pinctrl_hog_map(pctldev, map);
-			if (ret)
+			if (ret) {
+				mutex_unlock(&pinctrl_maps_mutex);
 				return ret;
+			}
 		}
 	}
+	mutex_unlock(&pinctrl_maps_mutex);
+
 	return 0;
 }
 
@@ -905,13 +926,14 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 
 static int pinctrl_maps_show(struct seq_file *s, void *what)
 {
+	struct pinctrl_maps *maps_node;
 	int i;
+	struct pinctrl_map const *map;
 
 	seq_puts(s, "Pinctrl maps:\n");
 
-	for (i = 0; i < pinctrl_maps_num; i++) {
-		struct pinctrl_map const *map = &pinctrl_maps[i];
-
+	mutex_lock(&pinctrl_maps_mutex);
+	for_each_maps(maps_node, i, map) {
 		seq_printf(s, "%s:\n", map->name);
 		if (map->dev_name)
 			seq_printf(s, "  device: %s\n",
@@ -924,6 +946,8 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 		seq_printf(s, "  group: %s\n", map->group ? map->group :
 			   "(default)");
 	}
+	mutex_unlock(&pinctrl_maps_mutex);
+
 	return 0;
 }
 
-- 
1.7.0.4

