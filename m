Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2EaNVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:21:47 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:52936 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab2EaNVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:21:45 -0400
Message-Id: <201205311320.q4VDKFdi014419@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 31 May 2012 12:14:33 +0200
Subject: [PATCH 2/2] regmap: Add support for register indirect addressing.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices, having indirectly accessed registers or register paging implemented,
can configure register mapping to map indirectly accessible registers on
virtual address range. During access to virtually mapped register, indirect
addressing is processed automatically, depending on configuration. Other
registers are accessed directly.

Range configuration should contain base, number of virtual registers,
information about addressing/paging field and translation function defined.
translate_reg function should take virtual register and return indirect
address/page number and data register address for proper read.

Nesting of indirectly accessible register ranges is supported and will be
automatically carried out. For example, addressing/paging register and data
register of one address range can be located in another virtual address range,
that yet requires paging.

Caching for virtual register range is also supported and can be defined in
regmap configuration. In order to make indirect access more efficient, register
used for indirect addressing/paging should not be declared as volatile, when
possible.

struct regmap_config is extended with the following:
	struct regmap_range_cfg	*ranges;
	unsigned int		n_ranges;

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/internal.h |   17 ++++
 drivers/base/regmap/regmap.c   |  172 ++++++++++++++++++++++++++++++++++++++--
 include/linux/regmap.h         |   37 +++++++++
 3 files changed, 220 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index fcafc5b..0220e4c 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -79,6 +79,8 @@ struct regmap {
 
 	struct reg_default *patch;
 	int patch_regs;
+
+	struct list_head range_list;
 };
 
 struct regcache_ops {
@@ -99,6 +101,21 @@ bool regmap_precious(struct regmap *map, unsigned int reg);
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val);
 
+struct regmap_range {
+	struct list_head list;
+
+	unsigned int base_reg;
+	unsigned int max_reg;
+
+	void (*translate_reg)(struct device *dev, unsigned int virtual_reg,
+			      unsigned int *page, unsigned int *reg);
+	unsigned int page_sel_reg;
+	unsigned int page_sel_mask;
+	int page_sel_shift;
+
+	bool busy;
+};
+
 #ifdef CONFIG_DEBUG_FS
 extern void regmap_debugfs_initcall(void);
 extern void regmap_debugfs_init(struct regmap *map);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7c5291e..7581ad9 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -175,6 +175,12 @@ struct regmap *regmap_init(struct device *dev,
 {
 	struct regmap *map;
 	int ret = -EINVAL;
+	unsigned int range_base;
+	unsigned int min_base;
+	const struct regmap_range_cfg *range_cfg;
+	struct regmap_range *range;
+	struct list_head *entry, *entry_tmp;
+	int n;
 
 	if (!bus || !config)
 		goto err;
@@ -283,10 +289,74 @@ struct regmap *regmap_init(struct device *dev,
 	    !(map->format.format_reg && map->format.format_val))
 		goto err_map;
 
+	/* For some formats, indirect addressing is not supported. */
+	if (map->format.format_write && config->n_ranges != 0)
+		goto err_map;
+
+	/* Partition all accessible registers on address ranges,
+	   either to be accessed directly or indirectly. Arrange range
+	   list by ascending addresses. */
+	INIT_LIST_HEAD(&map->range_list);
+	range_base = 0;
+	do {
+		range_cfg = NULL;
+		for (n = 0, min_base = UINT_MAX; n < config->n_ranges; n++)
+			if (range_base <= config->ranges[n].base_reg &&
+			    config->ranges[n].base_reg <= min_base)
+				range_cfg = &config->ranges[n];
+
+		if (!range_cfg || range_cfg->base_reg > range_base) {
+			/* Range of registers for direct access */
+			range = kzalloc(sizeof(*range), GFP_KERNEL);
+			if (range == NULL) {
+				ret = -ENOMEM;
+				goto err_range;
+			}
+			range->base_reg = range_base;
+			if (range_cfg)
+				range->max_reg = range_cfg->base_reg - 1;
+			else
+				range->max_reg = UINT_MAX;
+			list_add_tail(&range->list, &map->range_list);
+		}
+
+		if (range_cfg) {
+			unsigned int range_max_reg = range_cfg->base_reg +
+						     range_cfg->num_regs - 1;
+
+			/* Sanity check for range configuration */
+			if (range_cfg->num_regs == 0 ||
+			    range_max_reg < range_cfg->base_reg ||
+			    range_max_reg > map->max_register ||
+			    range_cfg->translate_reg == NULL ||
+			    (range_cfg->base_reg <= range_cfg->page_sel_reg &&
+			     range_cfg->page_sel_reg <= range_max_reg)) {
+				ret = -EINVAL;
+				goto err_range;
+			}
+
+			/* Range of registers for indirect access */
+			range = kzalloc(sizeof(*range), GFP_KERNEL);
+			if (range == NULL) {
+				ret = -ENOMEM;
+				goto err_range;
+			}
+			range->base_reg = range_cfg->base_reg;
+			range->max_reg = range_max_reg;
+			range->translate_reg = range_cfg->translate_reg;
+			range->page_sel_reg = range_cfg->page_sel_reg;
+			range->page_sel_mask = range_cfg->page_sel_mask;
+			range->page_sel_shift = range_cfg->page_sel_shift;
+			list_add_tail(&range->list, &map->range_list);
+
+			range_base = range->max_reg + 1;
+		}
+	} while (range_cfg != NULL);
+
 	map->work_buf = kzalloc(map->format.buf_size, GFP_KERNEL);
 	if (map->work_buf == NULL) {
 		ret = -ENOMEM;
-		goto err_map;
+		goto err_range;
 	}
 
 	regmap_debugfs_init(map);
@@ -299,6 +369,9 @@ struct regmap *regmap_init(struct device *dev,
 
 err_free_workbuf:
 	kfree(map->work_buf);
+err_range:
+	list_for_each_safe(entry, entry_tmp, &map->range_list)
+		kfree(entry_tmp);
 err_map:
 	kfree(map);
 err:
@@ -389,13 +462,98 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
  */
 void regmap_exit(struct regmap *map)
 {
+	struct regmap_range *range, *range_tmp;
+
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 	kfree(map->work_buf);
+	list_for_each_entry_safe(range, range_tmp, &map->range_list, list)
+		kfree(range_tmp);
 	kfree(map);
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
 
+static int _regmap_update_bits(struct regmap *map, unsigned int reg,
+			       unsigned int mask, unsigned int val,
+			       bool *change);
+
+static int
+_regmap_range_access(int (*regmap_bus_access)(struct regmap *map,
+					      unsigned int reg,
+					      void *val, unsigned int val_len),
+		     struct regmap *map, unsigned int reg,
+		     void *val, unsigned int val_num)
+{
+	struct regmap_range *range;
+	bool change;
+	unsigned int _page, _p;
+	unsigned int _reg, _r;
+	unsigned int _num;
+	u8 *_val = val;
+	int ret;
+
+	/* Search for range to write to. Should always find one. */
+	list_for_each_entry_reverse(range, &map->range_list, list) {
+		if (range->base_reg <= reg)
+			break;
+	}
+	BUG_ON(&range->list == &map->range_list);
+
+	/* Bulk write should not cross single range boundaries */
+	if (val_num != 0 &&
+	    reg + val_num - 1 > range->max_reg)
+		return -EINVAL;
+
+	if (range->translate_reg) {
+		/* One virtual range can be accessed through another range.
+		   Make sure, that there is no loops during indirect access. */
+		if (range->busy)
+			return -EBUSY;
+
+		range->busy = 1;
+
+		/* Split bulk write to pages */
+		range->translate_reg(map->dev, reg, &_page, &_reg);
+		while (val_num) {
+			for (_num = 1; _num < val_num; _num++) {
+				range->translate_reg(map->dev, reg + _num,
+						     &_p, &_r);
+				if (_p != _page ||
+				    _r != _reg + _num)
+					break;
+			}
+
+			/* Update page register (may use caching) */
+			ret = _regmap_update_bits(map, range->page_sel_reg,
+						range->page_sel_mask,
+						_page << range->page_sel_shift,
+						&change);
+			if (ret < 0)
+				return ret;
+
+			/* There is no point to pass cache for data
+			   registers, as they should be volatile anyway */
+			ret = _regmap_range_access(regmap_bus_access,
+						   map, _reg, _val, _num);
+			if (ret < 0)
+				return ret;
+
+			val_num -= _num;
+			_val += _num * map->format.val_bytes;
+			_page = _p;
+			_reg = _r;
+		}
+
+		range->busy = 0;
+
+		return 0;
+
+	} else {
+		return regmap_bus_access(map, reg, val,
+					 val_num * map->format.val_bytes);
+	}
+}
+
 static int _regmap_bus_write(struct regmap *map, unsigned int reg,
 			     void *val, size_t val_len)
 {
@@ -452,20 +610,20 @@ static int _regmap_bus_write(struct regmap *map, unsigned int reg,
 static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			     const void *val, size_t val_len)
 {
-	void *_val = (void *)val;
 	int i;
 	int ret;
+	unsigned int val_num = val_len / map->format.val_bytes;
 
 	/* Check for unwritable registers before we start */
 	if (map->writeable_reg)
-		for (i = 0; i < val_len / map->format.val_bytes; i++)
+		for (i = 0; i < val_num; i++)
 			if (!map->writeable_reg(map->dev, reg + i))
 				return -EINVAL;
 
 	if (!map->cache_bypass && map->format.parse_val) {
 		unsigned int ival;
 		int val_bytes = map->format.val_bytes;
-		for (i = 0; i < val_len / map->format.val_bytes; i++) {
+		for (i = 0; i < val_num; i++) {
 			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
 			ival = map->format.parse_val(map->work_buf);
 			ret = regcache_write(map, reg + i, ival);
@@ -482,7 +640,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		}
 	}
 
-	return _regmap_bus_write(map, reg, _val, val_len);
+	return _regmap_range_access(_regmap_bus_write,
+				    map, reg, (void *)val, val_num);
 }
 
 int _regmap_write(struct regmap *map, unsigned int reg,
@@ -659,7 +818,8 @@ static int _regmap_bus_read(struct regmap *map, unsigned int reg, void *val,
 static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
-	return _regmap_bus_read(map, reg, val, val_len);
+	return _regmap_range_access(_regmap_bus_read, map, reg, val,
+				    val_len / map->format.val_bytes);
 }
 
 static int _regmap_read(struct regmap *map, unsigned int reg,
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a90abb6..fdedf34 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -20,6 +20,7 @@ struct device;
 struct i2c_client;
 struct spi_device;
 struct regmap;
+struct regmap_range;
 
 /* An enum of all the supported cache types */
 enum regcache_type {
@@ -50,6 +51,9 @@ struct reg_default {
  * @pad_bits: Number of bits of padding between register and value.
  * @val_bits: Number of bits in a register value, mandatory.
  *
+ * @ranges: Array of virtual address range descriptors.
+ * @num_ranges: Descriptor array size.
+ *
  * @writeable_reg: Optional callback returning true if the register
  *                 can be written to.
  * @readable_reg: Optional callback returning true if the register
@@ -81,6 +85,9 @@ struct regmap_config {
 	int pad_bits;
 	int val_bits;
 
+	const struct regmap_range_cfg *ranges;
+	unsigned int n_ranges;
+
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
@@ -97,6 +104,36 @@ struct regmap_config {
 	u8 write_flag_mask;
 };
 
+/**
+ * Configuration for indirect accessed register range.
+ * Indirect or paged registers, can be defined with one or more structures.
+ * Registers out of such defined ranges are accessed directly.
+ *
+ * @base_reg: Register address of first register in virtual address range.
+ * @num_regs: Number of registers asigned to this range.
+ *
+ * @translate_reg: Function should return indirect address/page number and
+ *                 register number (out of this range) matching virtual_reg.
+ *
+ * @page_sel_reg: Register with selector for indirect address/page update.
+ * @page_sel_shift: Bit mask for selector.
+ * @page_sel_mask: Bit shift for selector.
+ */
+struct regmap_range_cfg {
+	/* Registers of virtual address range */
+	unsigned int base_reg;
+	unsigned int num_regs;
+
+	/* Registers translation function handler */
+	void (*translate_reg)(struct device *dev, unsigned int virtual_reg,
+			      unsigned int *page, unsigned int *reg);
+
+	/* Description of page selector for indirect addressing */
+	unsigned int page_sel_reg;
+	unsigned int page_sel_mask;
+	int page_sel_shift;
+};
+
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
 			       size_t count);
 typedef int (*regmap_hw_gather_write)(struct device *dev,
-- 
1.7.0.4

