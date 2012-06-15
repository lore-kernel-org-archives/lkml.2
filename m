Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2FOKuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:50:24 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:13322 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab2FOKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:50:22 -0400
Message-Id: <201206151049.q5FAn6bj003364@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Fri, 15 Jun 2012 11:23:56 +0100
Subject: [PATCH 2/2 v2] regmap: Add support for register indirect addressing.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices with register paging or indirectly accessed registers can configure
register mapping to map those on virtual address range. During access to
virtually mapped register range, indirect addressing is processed
automatically, in following steps:
  1. selector for page or indirect register is updated (when needed);
  2. register in data window is accessed.

Configuration should provide minimum and maximum register for virtual range,
details of selector field for page selection, minimum and maximum register of
data window for indirect access.

Virtual range registers are managed by cache as well as direct access
registers. In order to make indirect access more efficient, selector register
should be declared as non-volatile, if possible.

struct regmap_config is extended with the following:
struct regmap_range_cfg	*ranges;
unsigned int		n_ranges;

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/internal.h |   17 ++++
 drivers/base/regmap/regmap.c   |  195 +++++++++++++++++++++++++++++++++++++++-
 include/linux/regmap.h         |   39 ++++++++
 3 files changed, 249 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index b986b86..80f9ab9 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -95,6 +95,9 @@ struct regmap {
 
 	/* if set, converts bulk rw to single rw */
 	bool use_single_rw;
+
+	struct rb_root range_tree;
+	void *selector_work_buf;	/* Scratch buffer used for selector */
 };
 
 struct regcache_ops {
@@ -115,6 +118,20 @@ bool regmap_precious(struct regmap *map, unsigned int reg);
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val);
 
+struct regmap_range_node {
+	struct rb_node node;
+
+	unsigned int range_min;
+	unsigned int range_max;
+
+	unsigned int selector_reg;
+	unsigned int selector_mask;
+	int selector_shift;
+
+	unsigned int window_start;
+	unsigned int window_len;
+};
+
 #ifdef CONFIG_DEBUG_FS
 extern void regmap_debugfs_initcall(void);
 extern void regmap_debugfs_init(struct regmap *map, const char *name);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ce35b8c..078ee18 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,12 +15,17 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
+#include <linux/rbtree.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regmap.h>
 
 #include "internal.h"
 
+static int _regmap_update_bits(struct regmap *map, unsigned int reg,
+			       unsigned int mask, unsigned int val,
+			       bool *change);
+
 bool regmap_writeable(struct regmap *map, unsigned int reg)
 {
 	if (map->max_register && reg > map->max_register)
@@ -208,6 +213,67 @@ static void dev_get_regmap_release(struct device *dev, void *res)
 	 */
 }
 
+static bool _regmap_range_add(struct regmap *map,
+			      struct regmap_range_node *data)
+{
+	struct rb_root *root = &map->range_tree;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct regmap_range_node *this =
+			container_of(*new, struct regmap_range_node, node);
+
+		parent = *new;
+		if (data->range_max < this->range_min)
+			new = &((*new)->rb_left);
+		else if (data->range_min > this->range_max)
+			new = &((*new)->rb_right);
+		else
+			return false;
+	}
+
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+
+	return true;
+}
+
+static struct regmap_range_node *_regmap_range_lookup(struct regmap *map,
+						      unsigned int reg)
+{
+	struct rb_node *node = map->range_tree.rb_node;
+
+	while (node) {
+		struct regmap_range_node *this =
+			container_of(node, struct regmap_range_node, node);
+
+		if (reg < this->range_min)
+			node = node->rb_left;
+		else if (reg > this->range_max)
+			node = node->rb_right;
+		else
+			return this;
+	}
+
+	return NULL;
+}
+
+static void regmap_range_exit(struct regmap *map)
+{
+	struct rb_node *next;
+	struct regmap_range_node *range_node;
+
+	next = rb_first(&map->range_tree);
+	while (next) {
+		range_node = rb_entry(next, struct regmap_range_node, node);
+		next = rb_next(&range_node->node);
+		rb_erase(&range_node->node, &map->range_tree);
+		kfree(range_node);
+	}
+
+	kfree(map->selector_work_buf);
+}
+
 /**
  * regmap_init(): Initialise register map
  *
@@ -227,6 +293,7 @@ struct regmap *regmap_init(struct device *dev,
 {
 	struct regmap *map, **m;
 	int ret = -EINVAL;
+	int i, j;
 
 	if (!bus || !config)
 		goto err;
@@ -364,11 +431,71 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
+	map->range_tree = RB_ROOT;
+	for (i = 0; i < config->n_ranges; i++) {
+		const struct regmap_range_cfg *range_cfg = &config->ranges[i];
+		struct regmap_range_node *new;
+
+		/* Sanity check */
+		if (range_cfg->range_max < range_cfg->range_min ||
+		    range_cfg->range_max > map->max_register ||
+		    range_cfg->selector_reg > map->max_register ||
+		    range_cfg->window_len == 0)
+			goto err_range;
+
+		/* Make sure, that this register range has no selector
+		   or data window within its boundary */
+		for (j = 0; j < config->n_ranges; j++) {
+			unsigned sel_reg = config->ranges[j].selector_reg;
+			unsigned win_min = config->ranges[j].window_start;
+			unsigned win_max = win_min +
+					   config->ranges[j].window_len - 1;
+
+			if (range_cfg->range_min <= sel_reg &&
+			    sel_reg <= range_cfg->range_max) {
+				goto err_range;
+			}
+
+			if (!(win_max < range_cfg->range_min ||
+			      win_min > range_cfg->range_max)) {
+				goto err_range;
+			}
+		}
+
+		new = kzalloc(sizeof(*new), GFP_KERNEL);
+		if (new == NULL) {
+			ret = -ENOMEM;
+			goto err_range;
+		}
+
+		new->range_min = range_cfg->range_min;
+		new->range_max = range_cfg->range_max;
+		new->selector_reg = range_cfg->selector_reg;
+		new->selector_mask = range_cfg->selector_mask;
+		new->selector_shift = range_cfg->selector_shift;
+		new->window_start = range_cfg->window_start;
+		new->window_len = range_cfg->window_len;
+
+		if (_regmap_range_add(map, new) == false) {
+			kfree(new);
+			goto err_range;
+		}
+
+		if (map->selector_work_buf == NULL) {
+			map->selector_work_buf =
+				kzalloc(map->format.buf_size, GFP_KERNEL);
+			if (map->selector_work_buf == NULL) {
+				ret = -ENOMEM;
+				goto err_range;
+			}
+		}
+	}
+
 	regmap_debugfs_init(map, config->name);
 
 	ret = regcache_init(map, config);
 	if (ret < 0)
-		goto err_free_workbuf;
+		goto err_range;
 
 	/* Add a devres resource for dev_get_regmap() */
 	m = devres_alloc(dev_get_regmap_release, sizeof(*m), GFP_KERNEL);
@@ -383,7 +510,8 @@ struct regmap *regmap_init(struct device *dev,
 
 err_cache:
 	regcache_exit(map);
-err_free_workbuf:
+err_range:
+	regmap_range_exit(map);
 	kfree(map->work_buf);
 err_map:
 	kfree(map);
@@ -479,6 +607,7 @@ void regmap_exit(struct regmap *map)
 {
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
+	regmap_range_exit(map);
 	if (map->bus->free_context)
 		map->bus->free_context(map->bus_context);
 	kfree(map->work_buf);
@@ -524,6 +653,56 @@ struct regmap *dev_get_regmap(struct device *dev, const char *name)
 }
 EXPORT_SYMBOL_GPL(dev_get_regmap);
 
+static int _regmap_select_page(struct regmap *map, unsigned int *reg,
+			       unsigned int val_num)
+{
+	struct regmap_range_node *range;
+	void *orig_work_buf;
+	unsigned int win_offset;
+	unsigned int win_page;
+	bool page_chg;
+	int ret;
+
+	range = _regmap_range_lookup(map, *reg);
+	if (range) {
+		win_offset = (*reg - range->range_min) % range->window_len;
+		win_page = (*reg - range->range_min) / range->window_len;
+
+		if (val_num > 1) {
+			/* Bulk write shouldn't cross range boundary */
+			if (*reg + val_num - 1 > range->range_max)
+				return -EINVAL;
+
+			/* ... or single page boundary */
+			if (val_num > range->window_len - win_offset)
+				return -EINVAL;
+		}
+
+		/* It is possible to have selector register inside data window.
+		   In that case, selector register is located on every page and
+		   it needs no page switching, when accessed alone. */
+		if (val_num > 1 ||
+		    range->window_start + win_offset != range->selector_reg) {
+			/* Use separate work_buf during page switching */
+			orig_work_buf = map->work_buf;
+			map->work_buf = map->selector_work_buf;
+
+			ret = _regmap_update_bits(map, range->selector_reg,
+					range->selector_mask,
+					win_page << range->selector_shift,
+					&page_chg);
+			if (ret < 0)
+				return ret;
+
+			map->work_buf = orig_work_buf;
+		}
+
+		*reg = range->window_start + win_offset;
+	}
+
+	return 0;
+}
+
 static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			     const void *val, size_t val_len)
 {
@@ -561,6 +740,10 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		}
 	}
 
+	ret = _regmap_select_page(map, &reg, val_len / map->format.val_bytes);
+	if (ret < 0)
+		return ret;
+
 	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 
 	u8[0] |= map->write_flag_mask;
@@ -624,6 +807,10 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 	trace_regmap_reg_write(map->dev, reg, val);
 
 	if (map->format.format_write) {
+		ret = _regmap_select_page(map, &reg, 1);
+		if (ret < 0)
+			return ret;
+
 		map->format.format_write(map, reg, val);
 
 		trace_regmap_hw_write_start(map->dev, reg, 1);
@@ -781,6 +968,10 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	u8 *u8 = map->work_buf;
 	int ret;
 
+	ret = _regmap_select_page(map, &reg, val_len / map->format.val_bytes);
+	if (ret < 0)
+		return ret;
+
 	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 
 	/*
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 56af22e..5f69d4a 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -14,12 +14,14 @@
  */
 
 #include <linux/list.h>
+#include <linux/rbtree.h>
 
 struct module;
 struct device;
 struct i2c_client;
 struct spi_device;
 struct regmap;
+struct regmap_range_cfg;
 
 /* An enum of all the supported cache types */
 enum regcache_type {
@@ -84,6 +86,9 @@ struct reg_default {
  * @reg_defaults_raw: Power on reset values for registers (for use with
  *                    register cache support).
  * @num_reg_defaults_raw: Number of elements in reg_defaults_raw.
+ *
+ * @ranges: Array of configuration entries for virtual address ranges.
+ * @num_ranges: Number of range configuration entries.
  */
 struct regmap_config {
 	const char *name;
@@ -109,6 +114,40 @@ struct regmap_config {
 	u8 write_flag_mask;
 
 	bool use_single_rw;
+
+	const struct regmap_range_cfg *ranges;
+	unsigned int n_ranges;
+};
+
+/**
+ * Configuration for indirectly accessed or paged registers.
+ * Registers, mapped to this virtual range, are accessed in two steps:
+ *     1. page selector register update;
+ *     2. access through data window registers.
+ *
+ * @range_min: Address of the lowest register address in virtual range.
+ * @range_max: Address of the highest register in virtual range.
+ *
+ * @page_sel_reg: Register with selector field.
+ * @page_sel_mask: Bit shift for selector value.
+ * @page_sel_shift: Bit mask for selector value.
+ *
+ * @window_start: Address of first (lowest) register in data window.
+ * @window_len: Number of registers in data window.
+ */
+struct regmap_range_cfg {
+	/* Registers of virtual address range */
+	unsigned int range_min;
+	unsigned int range_max;
+
+	/* Page selector for indirect addressing */
+	unsigned int selector_reg;
+	unsigned int selector_mask;
+	int selector_shift;
+
+	/* Data window (per each page) */
+	unsigned int window_start;
+	unsigned int window_len;
 };
 
 typedef int (*regmap_hw_write)(void *context, const void *data,
-- 
1.7.0.4

