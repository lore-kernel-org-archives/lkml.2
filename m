Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2EKKza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:55:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34951 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab2EKKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:55:28 -0400
Subject: [PATCH] regmap: Add support for register paging
From: Krystian Garbaciak <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>
Content-Type: multipart/mixed; boundary="=-mbLr13TFIECbC2AmDpn8"
Date: Fri, 11 May 2012 12:55:24 +0200
Message-ID: <1336733724.5950.3.camel@sw-eng-lt-dc-vm2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mbLr13TFIECbC2AmDpn8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Devices, having register map split into pages, can initialize regmap to
switch between pages automatically. This simply makes the total number
of registers to be virtually expanded and multiplied by number of pages.

When driver defines non-zero number of bits for page selection, register
address passed for read or write should consist of total number of page
bits and register bits to form an address, where page bits are the most
significant ones.

In order to make page switching efficient, register used for page
selection should be declared as cacheable (when possible). Driver can
define pageable and non-pageable (page independent) registers, so that
page switching will be carried out for pageable registers only.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---

--=-mbLr13TFIECbC2AmDpn8
Content-Disposition: attachment; filename="regmap_paging.patch"
Content-Type: text/x-patch; name="regmap_paging.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 0f6c7fb..590d72c 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -16,3 +16,6 @@ config REGMAP_SPI
 
 config REGMAP_IRQ
 	bool
+
+config REGMAP_PAGING
+	bool
diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index fcafc5b..b7931e1 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -31,6 +31,18 @@ struct regmap_format {
 	unsigned int (*parse_val)(void *buf);
 };
 
+#ifdef CONFIG_REGMAP_PAGING
+struct regmap_paging {
+	unsigned int page_mask;
+	unsigned int reg_mask;
+	unsigned int reg_bits;
+	bool (*pageable_reg)(struct device *dev, unsigned int reg);
+	unsigned int sel_reg;
+	int sel_shift;
+	unsigned int sel_mask;
+};
+#endif
+
 struct regmap {
 	struct mutex lock;
 
@@ -79,6 +91,10 @@ struct regmap {
 
 	struct reg_default *patch;
 	int patch_regs;
+
+#ifdef CONFIG_REGMAP_PAGING
+	struct regmap_paging page;
+#endif
 };
 
 struct regcache_ops {
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7a3f535..45794cc 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -80,6 +80,24 @@ static bool regmap_volatile_range(struct regmap *map, unsigned int reg,
 	return true;
 }
 
+#ifdef CONFIG_REGMAP_PAGING
+static bool regmap_pageable_range(struct regmap *map, unsigned int reg,
+				  unsigned int num)
+{
+	if (map->page.pageable_reg) {
+		unsigned int i;
+
+		for (i = 0; i < num; i++)
+			if (map->page.pageable_reg(map->dev, reg))
+				return true;
+
+		return false;
+	}
+
+	return true;
+}
+#endif
+
 static void regmap_format_2_6_write(struct regmap *map,
 				     unsigned int reg, unsigned int val)
 {
@@ -199,6 +217,17 @@ struct regmap *regmap_init(struct device *dev,
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
 	map->cache_type = config->cache_type;
+#ifdef CONFIG_REGMAP_PAGING
+	map->page.page_mask = ((1 << config->page_bits) - 1) << config->reg_bits;
+	map->page.reg_mask = (1 << config->reg_bits) - 1;
+	map->page.reg_bits = config->reg_bits;
+	map->page.pageable_reg = config->pageable_reg;
+	map->page.sel_reg = config->page_sel_reg;
+	map->page.sel_shift = config->page_sel_shift;
+	map->page.sel_mask = ((1 << config->page_bits) - 1) <<
+			     config->page_sel_shift;
+#endif
+
 
 	if (config->read_flag_mask || config->write_flag_mask) {
 		map->read_flag_mask = config->read_flag_mask;
@@ -396,41 +425,66 @@ void regmap_exit(struct regmap *map)
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
 
-static int _regmap_raw_write(struct regmap *map, unsigned int reg,
-			     const void *val, size_t val_len)
-{
-	u8 *u8 = map->work_buf;
-	void *buf;
-	int ret = -ENOTSUPP;
-	size_t len;
-	int i;
+static int _regmap_update_bits(struct regmap *map, unsigned int reg,
+			       unsigned int mask, unsigned int val,
+			       bool *change);
 
-	/* Check for unwritable registers before we start */
-	if (map->writeable_reg)
-		for (i = 0; i < val_len / map->format.val_bytes; i++)
-			if (!map->writeable_reg(map->dev, reg + i))
-				return -EINVAL;
+#ifdef CONFIG_REGMAP_PAGING
+static int _regmap_paged_access(struct regmap *map,
+		int (*regmap_bus_access)(struct regmap *map, unsigned int reg,
+					 void *val, unsigned int val_len),
+		unsigned int reg, void *val, unsigned int val_len)
+{
+	unsigned int val_num = val_len / map->format.val_bytes;
+	u8 *_val = val;
+	unsigned int _reg = reg & map->page.reg_mask;
+	unsigned int _page = reg >> map->page.reg_bits;
+	unsigned int _num;
+	size_t _len;
+	bool change;
+	int ret;
 
-	if (!map->cache_bypass && map->format.parse_val) {
-		unsigned int ival;
-		int val_bytes = map->format.val_bytes;
-		for (i = 0; i < val_len / val_bytes; i++) {
-			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
-			ival = map->format.parse_val(map->work_buf);
-			ret = regcache_write(map, reg + i, ival);
-			if (ret) {
-				dev_err(map->dev,
-				   "Error in caching of register: %u ret: %d\n",
-					reg + i, ret);
+	/* Split write into separate blocks, one for each page */
+	while (val_num) {
+		if ((_reg + val_num  - 1) >> map->page.reg_bits != 0)
+			_num = (map->page.reg_mask - _reg + 1);
+		else
+			_num = val_num;
+
+		if (regmap_pageable_range(map, _reg, _num)) {
+			/* Update page selector, try to use cache.
+			   Page selector is in nonpageable register, so it is
+			   safe to reenter update function here. */
+			ret = _regmap_update_bits(map,
+						  map->page.sel_reg,
+						  map->page.sel_mask,
+						  _page << map->page.sel_shift,
+						  &change);
+			if (ret < 0)
 				return ret;
-			}
-		}
-		if (map->cache_only) {
-			map->cache_dirty = true;
-			return 0;
 		}
+
+		_len = _num * map->format.val_bytes;
+		ret = regmap_bus_access(map, _reg, _val, _len);
+		if (ret < 0)
+			return ret;
+
+		val_num -= _num;
+		_val += _len;
+		_reg = 0;
+		_page++;
 	}
 
+	return 0;
+}
+#endif /* CONFIG_REGMAP_PAGING */
+
+static int _regmap_bus_write(struct regmap *map, unsigned int reg,
+			     void *val, size_t val_len)
+{
+	u8 *u8 = map->work_buf;
+	int ret = -ENOTSUPP;
+
 	map->format.format_reg(map->work_buf, reg);
 
 	u8[0] |= map->write_flag_mask;
@@ -456,6 +510,9 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	/* If that didn't work fall back on linearising by hand. */
 	if (ret == -ENOTSUPP) {
+		void *buf;
+		size_t len;
+
 		len = map->format.reg_bytes + map->format.pad_bytes + val_len;
 		buf = kzalloc(len, GFP_KERNEL);
 		if (!buf)
@@ -475,6 +532,52 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
+static int _regmap_raw_write(struct regmap *map, unsigned int reg,
+			     const void *val, size_t val_len)
+{
+	void *_val = (void *)val;
+	int i;
+	int ret;
+
+	/* Check for unwritable registers before we start */
+	if (map->writeable_reg)
+		for (i = 0; i < val_len / map->format.val_bytes; i++)
+			if (!map->writeable_reg(map->dev, reg + i))
+				return -EINVAL;
+
+	if (!map->cache_bypass && map->format.parse_val) {
+		unsigned int ival;
+		int val_bytes = map->format.val_bytes;
+		for (i = 0; i < val_len / map->format.val_bytes; i++) {
+			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
+			ival = map->format.parse_val(map->work_buf);
+			ret = regcache_write(map, reg + i, ival);
+			if (ret) {
+				dev_err(map->dev,
+				   "Error in caching of register: %u ret: %d\n",
+					reg + i, ret);
+				return ret;
+			}
+		}
+		if (map->cache_only) {
+			map->cache_dirty = true;
+			return 0;
+		}
+	}
+
+#ifdef CONFIG_REGMAP_PAGING
+	/* Maintain paging, if enabled and register is page dependent */
+	if (map->page.page_mask &&
+	    !(map->page.sel_reg == reg &&
+	      val_len == map->format.val_bytes)) {
+		return _regmap_paged_access(map, &_regmap_bus_write,
+					    reg, _val, val_len);
+	}
+#endif /* CONFIG_REGMAP_PAGING */
+
+	return _regmap_bus_write(map, reg, _val, val_len);
+}
+
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val)
 {
@@ -494,6 +597,28 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 	trace_regmap_reg_write(map->dev, reg, val);
 
 	if (map->format.format_write) {
+#ifdef CONFIG_REGMAP_PAGING
+		/* Maintain paging, if enabled and register is page dependent */
+		if (map->page.page_mask &&
+		    map->page.sel_reg != reg &&
+		    (!map->page.pageable_reg ||
+		     map->page.pageable_reg(map->dev, reg))) {
+			unsigned int page = reg >> map->page.reg_bits;
+			bool change;
+
+			/* Update page selector, when needed.
+			   Page selector is in nonpageable register, so it is
+			   safe to reenter for its update in here. */
+			ret = _regmap_update_bits(map,
+						  map->page.sel_reg,
+						  map->page.sel_mask,
+						  page << map->page.sel_shift,
+						  &change);
+			if (ret < 0)
+				return ret;
+		}
+#endif
+
 		map->format.format_write(map, reg, val);
 
 		trace_regmap_hw_write_start(map->dev, reg, 1);
@@ -620,7 +745,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
-static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
+static int _regmap_bus_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
 	u8 *u8 = map->work_buf;
@@ -649,6 +774,21 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	return ret;
 }
 
+static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
+			    unsigned int val_len)
+{
+#ifdef CONFIG_REGMAP_PAGING
+	/* Maintain paging, if enabled and register is page dependent */
+	if (map->page.page_mask &&
+	    !(map->page.sel_reg == reg &&
+	      val_len == map->format.val_bytes))
+		return _regmap_paged_access(map, &_regmap_bus_read,
+					    reg, val, val_len);
+#endif /* CONFIG_REGMAP_PAGING */
+
+	return _regmap_bus_read(map, reg, val, val_len);
+}
+
 static int _regmap_read(struct regmap *map, unsigned int reg,
 			unsigned int *val)
 {
@@ -792,11 +932,9 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 	int ret;
 	unsigned int tmp, orig;
 
-	mutex_lock(&map->lock);
-
 	ret = _regmap_read(map, reg, &orig);
 	if (ret != 0)
-		goto out;
+		return ret;
 
 	tmp = orig & ~mask;
 	tmp |= val & mask;
@@ -808,9 +946,6 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 		*change = false;
 	}
 
-out:
-	mutex_unlock(&map->lock);
-
 	return ret;
 }
 
@@ -828,7 +963,12 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
 	bool change;
-	return _regmap_update_bits(map, reg, mask, val, &change);
+	int ret;
+
+	mutex_lock(&map->lock);
+	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	mutex_unlock(&map->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits);
 
@@ -848,7 +988,12 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change)
 {
-	return _regmap_update_bits(map, reg, mask, val, change);
+	int ret;
+
+	mutex_lock(&map->lock);
+	ret = _regmap_update_bits(map, reg, mask, val, change);
+	mutex_unlock(&map->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a90abb6..e4f9db0 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -50,6 +50,14 @@ struct reg_default {
  * @pad_bits: Number of bits of padding between register and value.
  * @val_bits: Number of bits in a register value, mandatory.
  *
+ * @page_bits: Number of address top-most bits designated to be page number.
+ *             These bits will be written to page selector, for page switch.
+ * @page_sel_reg: Register to update selected page in (available on any page).
+ * @page_sel_shift: Bit shift for page selector inside the register.
+ * @pageable_reg: Optional callback returning true, if a register needs
+ *                page switching (ie. it is page dependent). Register
+ *                in page_sel_reg is always considered as page independent.
+ *
  * @writeable_reg: Optional callback returning true if the register
  *                 can be written to.
  * @readable_reg: Optional callback returning true if the register
@@ -81,6 +89,13 @@ struct regmap_config {
 	int pad_bits;
 	int val_bits;
 
+#ifdef CONFIG_REGMAP_PAGING
+	int page_bits;
+	unsigned int page_sel_reg;
+	int page_sel_shift;
+	bool (*pageable_reg)(struct device *dev, unsigned int reg);
+#endif
+
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);

--=-mbLr13TFIECbC2AmDpn8--

