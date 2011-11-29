Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab1K2UMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:12:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52525 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756206Ab1K2UMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:12:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Allow regmap_update_bits() users to detect changes
Date: Tue, 29 Nov 2011 20:11:46 +0000
Message-Id: <1322597506-22784-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users of regmap_update_bits() would like to be able to tell their
users if they actually did an update so provide a variant which also
returns a flag indicating if an update took place. We could return a
tristate in the return value of regmap_update_bits() but this makes the
API more cumbersome to use and doesn't fit with the general zero for
success idiom we have.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   58 ++++++++++++++++++++++++++++++++---------
 include/linux/regmap.h       |    3 ++
 2 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a862090..add5da6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -569,18 +569,9 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_read);
 
-/**
- * regmap_update_bits: Perform a read/modify/write cycle on the register map
- *
- * @map: Register map to update
- * @reg: Register to update
- * @mask: Bitmask to change
- * @val: New value for bitmask
- *
- * Returns zero for success, a negative number on error.
- */
-int regmap_update_bits(struct regmap *map, unsigned int reg,
-		       unsigned int mask, unsigned int val)
+static int _regmap_update_bits(struct regmap *map, unsigned int reg,
+			       unsigned int mask, unsigned int val,
+			       bool *change)
 {
 	int ret;
 	unsigned int tmp, orig;
@@ -594,16 +585,57 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 	tmp = orig & ~mask;
 	tmp |= val & mask;
 
-	if (tmp != orig)
+	if (tmp != orig) {
 		ret = _regmap_write(map, reg, tmp);
+		*change = true;
+	} else {
+		*change = false;
+	}
 
 out:
 	mutex_unlock(&map->lock);
 
 	return ret;
 }
+
+/**
+ * regmap_update_bits: Perform a read/modify/write cycle on the register map
+ *
+ * @map: Register map to update
+ * @reg: Register to update
+ * @mask: Bitmask to change
+ * @val: New value for bitmask
+ *
+ * Returns zero for success, a negative number on error.
+ */
+int regmap_update_bits(struct regmap *map, unsigned int reg,
+		       unsigned int mask, unsigned int val)
+{
+	bool change;
+	return _regmap_update_bits(map, reg, mask, val, &change);
+}
 EXPORT_SYMBOL_GPL(regmap_update_bits);
 
+/**
+ * regmap_update_bits_check: Perform a read/modify/write cycle on the
+ *                           register map and report if updated
+ *
+ * @map: Register map to update
+ * @reg: Register to update
+ * @mask: Bitmask to change
+ * @val: New value for bitmask
+ * @change: Boolean indicating if a write was done
+ *
+ * Returns zero for success, a negative number on error.
+ */
+int regmap_update_bits_check(struct regmap *map, unsigned int reg,
+			     unsigned int mask, unsigned int val,
+			     bool *change)
+{
+	return _regmap_update_bits(map, reg, mask, val, change);
+}
+EXPORT_SYMBOL_GPL(regmap_update_bits_check);
+
 static int __init regmap_initcall(void)
 {
 	regmap_debugfs_initcall();
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 81dfe0a..a83e4a0 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -138,6 +138,9 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 		     size_t val_count);
 int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val);
+int regmap_update_bits_check(struct regmap *map, unsigned int reg,
+			     unsigned int mask, unsigned int val,
+			     bool *change);
 
 int regcache_sync(struct regmap *map);
 void regcache_cache_only(struct regmap *map, bool enable);
-- 
1.7.7.3

