Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2BTGr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19495 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2BTGrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 19 Feb 2012 22:46:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 03/20] pinctrl: Store mapping table as a list of chunks
Date: Sun, 19 Feb 2012 23:45:43 -0700
Message-Id: <1329720360-23227-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
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
v2: Fixed kzalloc size parameter in pinctrl_register_mappings(),
    add pr_error on kzalloc() failure, keep pinctrl_get() docs with
    pinctrl_get() not pinctrl_get_locked(), make pinctrl_get_locked()
    static, use list_add_tail instead of list_add, continue to duplicate
    mapping table, don't remove __initdata from u300 mapping table.
---
 drivers/pinctrl/core.c |  120 ++++++++++++++++++++++++++++++------------------
 1 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index feadf1c..50bcc51 100644
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
@@ -454,23 +474,17 @@ int pinctrl_gpio_direction_output(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 
-/**
- * pinctrl_get() - retrieves the pin controller handle for a certain device
- * @dev: the device to get the pin controller handle for
- * @name: an optional specific control mapping name or NULL, the name is only
- *	needed if you want to have more than one mapping per device, or if you
- *	need an anonymous pin control (not tied to any specific device)
- */
-struct pinctrl *pinctrl_get(struct device *dev, const char *name)
+static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
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
@@ -494,8 +508,7 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 	pinmux_init_pinctrl_handle(p);
 
 	/* Iterate over the pin control maps to locate the right ones */
-	for (i = 0; i < pinctrl_maps_num; i++) {
-		map = &pinctrl_maps[i];
+	for_each_maps(maps_node, i, map) {
 		found_map = false;
 
 		/*
@@ -515,7 +528,6 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 		pr_debug("in map, found pctldev %s to handle function %s",
 			 dev_name(pctldev->dev), map->function);
 
-
 		/*
 		 * If we're looking for a specific named map, this must match,
 		 * else we loop and look for the next.
@@ -574,6 +586,24 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 
 	return p;
 }
+
+/**
+ * pinctrl_get() - retrieves the pin controller handle for a certain device
+ * @dev: the device to get the pin controller handle for
+ * @name: an optional specific control mapping name or NULL, the name is only
+ *	needed if you want to have more than one mapping per device, or if you
+ *	need an anonymous pin control (not tied to any specific device)
+ */
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
@@ -649,8 +679,8 @@ EXPORT_SYMBOL_GPL(pinctrl_disable);
 int pinctrl_register_mappings(struct pinctrl_map const *maps,
 			      unsigned num_maps)
 {
-	void *tmp_maps;
 	int i;
+	struct pinctrl_maps *maps_node;
 
 	pr_debug("add %d pinmux maps\n", num_maps);
 
@@ -684,31 +714,23 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
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
+	maps_node = kzalloc(sizeof(*maps_node), GFP_KERNEL);
+	if (!maps_node) {
+		pr_err("failed to alloc struct pinctrl_maps\n");
+		return -ENOMEM;
+	}
 
-		tmp_maps = krealloc(pinctrl_maps,
-				    oldsize + newsize, GFP_KERNEL);
-		if (!tmp_maps)
-			return -ENOMEM;
-		memcpy((tmp_maps + oldsize), maps, newsize);
+	maps_node->num_maps = num_maps;
+	maps_node->maps = kmemdup(maps, sizeof(*maps) * num_maps, GFP_KERNEL);
+	if (!maps_node->maps) {
+		kfree(maps_node);
+		return -ENOMEM;
 	}
 
-	pinctrl_maps = tmp_maps;
-	pinctrl_maps_num += num_maps;
+	mutex_lock(&pinctrl_maps_mutex);
+	list_add_tail(&maps_node->node, &pinctrl_maps);
+	mutex_unlock(&pinctrl_maps_mutex);
+
 	return 0;
 }
 
@@ -724,7 +746,7 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 	if (!hog)
 		return -ENOMEM;
 
-	p = pinctrl_get(pctldev->dev, map->name);
+	p = pinctrl_get_locked(pctldev->dev, map->name);
 	if (IS_ERR(p)) {
 		kfree(hog);
 		dev_err(pctldev->dev,
@@ -768,23 +790,28 @@ int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
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
 
@@ -900,13 +927,14 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 
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
@@ -919,6 +947,8 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 		seq_printf(s, "  group: %s\n", map->group ? map->group :
 			   "(default)");
 	}
+	mutex_unlock(&pinctrl_maps_mutex);
+
 	return 0;
 }
 
-- 
1.7.5.4

