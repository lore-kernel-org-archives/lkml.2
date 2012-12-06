Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2LFEke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 23:40:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37316 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974Ab2LFEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 23:40:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Cache register and value sizes for debugfs
Date: Thu,  6 Dec 2012 13:40:22 +0900
Message-Id: <1354768822-17626-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in calculating them every time.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       |    4 ++++
 drivers/base/regmap/regmap-debugfs.c |   24 ++++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 288e135..7cf8c64 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -48,6 +48,10 @@ struct regmap {
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
 	const char *debugfs_name;
+
+	unsigned int debugfs_reg_len;
+	unsigned int debugfs_val_len;
+	unsigned int debugfs_tot_len;
 #endif
 
 	unsigned int max_register;
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index f4b9dd0..00fbd58 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -60,7 +60,6 @@ static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 				   unsigned int to, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	int reg_len, val_len, tot_len;
 	size_t buf_pos = 0;
 	loff_t p = 0;
 	ssize_t ret;
@@ -76,9 +75,13 @@ static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 		return -ENOMEM;
 
 	/* Calculate the length of a fixed format  */
-	reg_len = regmap_calc_reg_len(map->max_register, buf, count);
-	val_len = 2 * map->format.val_bytes;
-	tot_len = reg_len + val_len + 3;      /* : \n */
+	if (!map->debugfs_tot_len) {
+		map->debugfs_reg_len = regmap_calc_reg_len(map->max_register,
+							   buf, count);
+		map->debugfs_val_len = 2 * map->format.val_bytes;
+		map->debugfs_tot_len = map->debugfs_reg_len +
+			map->debugfs_val_len + 3;      /* : \n */
+	}
 
 	for (i = from; i <= to; i += map->reg_stride) {
 		if (!regmap_readable(map, i))
@@ -90,26 +93,27 @@ static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 		/* If we're in the region the user is trying to read */
 		if (p >= *ppos) {
 			/* ...but not beyond it */
-			if (buf_pos >= count - 1 - tot_len)
+			if (buf_pos >= count - 1 - map->debugfs_tot_len)
 				break;
 
 			/* Format the register */
 			snprintf(buf + buf_pos, count - buf_pos, "%.*x: ",
-				 reg_len, i - from);
-			buf_pos += reg_len + 2;
+				 map->debugfs_reg_len, i - from);
+			buf_pos += map->debugfs_reg_len + 2;
 
 			/* Format the value, write all X if we can't read */
 			ret = regmap_read(map, i, &val);
 			if (ret == 0)
 				snprintf(buf + buf_pos, count - buf_pos,
-					 "%.*x", val_len, val);
+					 "%.*x", map->debugfs_val_len, val);
 			else
-				memset(buf + buf_pos, 'X', val_len);
+				memset(buf + buf_pos, 'X',
+				       map->debugfs_val_len);
 			buf_pos += 2 * map->format.val_bytes;
 
 			buf[buf_pos++] = '\n';
 		}
-		p += tot_len;
+		p += map->debugfs_tot_len;
 	}
 
 	ret = buf_pos;
-- 
1.7.10.4

