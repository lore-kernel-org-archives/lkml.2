Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2JDRg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:36:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932253Ab2JDRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:36:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regmap: Factor range lookup out of page selection
Date: Thu,  4 Oct 2012 18:36:14 +0100
Message-Id: <1349372177-18931-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will support a subsequent update to allow bulk writes to cross window
boundaries.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   91 +++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 40 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 366b629..4bb926c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -765,59 +765,57 @@ struct regmap *dev_get_regmap(struct device *dev, const char *name)
 EXPORT_SYMBOL_GPL(dev_get_regmap);
 
 static int _regmap_select_page(struct regmap *map, unsigned int *reg,
+			       struct regmap_range_node *range,
 			       unsigned int val_num)
 {
-	struct regmap_range_node *range;
 	void *orig_work_buf;
 	unsigned int win_offset;
 	unsigned int win_page;
 	bool page_chg;
 	int ret;
 
-	range = _regmap_range_lookup(map, *reg);
-	if (range) {
-		win_offset = (*reg - range->range_min) % range->window_len;
-		win_page = (*reg - range->range_min) / range->window_len;
+	win_offset = (*reg - range->range_min) % range->window_len;
+	win_page = (*reg - range->range_min) / range->window_len;
 
-		if (val_num > 1) {
-			/* Bulk write shouldn't cross range boundary */
-			if (*reg + val_num - 1 > range->range_max)
-				return -EINVAL;
+	if (val_num > 1) {
+		/* Bulk write shouldn't cross range boundary */
+		if (*reg + val_num - 1 > range->range_max)
+			return -EINVAL;
 
-			/* ... or single page boundary */
-			if (val_num > range->window_len - win_offset)
-				return -EINVAL;
-		}
+		/* ... or single page boundary */
+		if (val_num > range->window_len - win_offset)
+			return -EINVAL;
+	}
 
-		/* It is possible to have selector register inside data window.
-		   In that case, selector register is located on every page and
-		   it needs no page switching, when accessed alone. */
-		if (val_num > 1 ||
-		    range->window_start + win_offset != range->selector_reg) {
-			/* Use separate work_buf during page switching */
-			orig_work_buf = map->work_buf;
-			map->work_buf = map->selector_work_buf;
+	/* It is possible to have selector register inside data window.
+	   In that case, selector register is located on every page and
+	   it needs no page switching, when accessed alone. */
+	if (val_num > 1 ||
+	    range->window_start + win_offset != range->selector_reg) {
+		/* Use separate work_buf during page switching */
+		orig_work_buf = map->work_buf;
+		map->work_buf = map->selector_work_buf;
 
-			ret = _regmap_update_bits(map, range->selector_reg,
-					range->selector_mask,
-					win_page << range->selector_shift,
-					&page_chg);
+		ret = _regmap_update_bits(map, range->selector_reg,
+					  range->selector_mask,
+					  win_page << range->selector_shift,
+					  &page_chg);
 
-			map->work_buf = orig_work_buf;
+		map->work_buf = orig_work_buf;
 
-			if (ret < 0)
-				return ret;
-		}
-
-		*reg = range->window_start + win_offset;
+		if (ret < 0)
+			return ret;
 	}
 
+	*reg = range->window_start + win_offset;
+
 	return 0;
 }
 
 static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			     const void *val, size_t val_len)
 {
+	struct regmap_range_node *range;
 	u8 *u8 = map->work_buf;
 	void *buf;
 	int ret = -ENOTSUPP;
@@ -852,9 +850,13 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		}
 	}
 
-	ret = _regmap_select_page(map, &reg, val_len / map->format.val_bytes);
-	if (ret < 0)
-		return ret;
+	range = _regmap_range_lookup(map, reg);
+	if (range) {
+		ret = _regmap_select_page(map, &reg, range,
+					  val_len / map->format.val_bytes);
+		if (ret < 0)
+			return ret;
+	}
 
 	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 
@@ -903,6 +905,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val)
 {
+	struct regmap_range_node *range;
 	int ret;
 	BUG_ON(!map->format.format_write && !map->format.format_val);
 
@@ -924,9 +927,12 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 	trace_regmap_reg_write(map->dev, reg, val);
 
 	if (map->format.format_write) {
-		ret = _regmap_select_page(map, &reg, 1);
-		if (ret < 0)
-			return ret;
+		range = _regmap_range_lookup(map, reg);
+		if (range) {
+			ret = _regmap_select_page(map, &reg, range, 1);
+			if (ret < 0)
+				return ret;
+		}
 
 		map->format.format_write(map, reg, val);
 
@@ -1082,12 +1088,17 @@ EXPORT_SYMBOL_GPL(regmap_bulk_write);
 static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
+	struct regmap_range_node *range;
 	u8 *u8 = map->work_buf;
 	int ret;
 
-	ret = _regmap_select_page(map, &reg, val_len / map->format.val_bytes);
-	if (ret < 0)
-		return ret;
+	range = _regmap_range_lookup(map, reg);
+	if (range) {
+		ret = _regmap_select_page(map, &reg, range,
+					  val_len / map->format.val_bytes);
+		if (ret < 0)
+			return ret;
+	}
 
 	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 
-- 
1.7.10.4

