Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1HNKuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 06:50:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36361 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753047Ab1HNKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 06:50:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regmap: Add functions to check for access on registers
Date: Sun, 14 Aug 2011 19:50:23 +0900
Message-Id: <1313319025-5514-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to be using these in quite a few places so factor out the
readable/writable/volatile/precious checks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       |    5 ++++
 drivers/base/regmap/regmap-debugfs.c |    6 +---
 drivers/base/regmap/regmap.c         |   44 ++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index a67dc68..5ab3fef 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -48,6 +48,11 @@ struct regmap {
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 };
 
+bool regmap_writeable(struct regmap *map, unsigned int reg);
+bool regmap_readable(struct regmap *map, unsigned int reg);
+bool regmap_volatile(struct regmap *map, unsigned int reg);
+bool regmap_precious(struct regmap *map, unsigned int reg);
+
 #ifdef CONFIG_DEBUG_FS
 extern void regmap_debugfs_initcall(void);
 extern void regmap_debugfs_init(struct regmap *map);
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 6e304a4..fff8e83 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -52,12 +52,10 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 	tot_len = reg_len + val_len + 3;      /* : \n */
 
 	for (i = 0; i < map->max_register; i++) {
-		if (map->readable_reg &&
-		    !map->readable_reg(map->dev, i))
+		if (!regmap_readable(map, i))
 			continue;
 
-		if (map->precious_reg &&
-		    map->precious_reg(map->dev, i))
+		if (regmap_precious(map, i))
 			continue;
 
 		/* If we're in the region the user is trying to read */
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d74d306..fa2bd89 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -20,6 +20,50 @@
 
 #include "internal.h"
 
+bool regmap_writeable(struct regmap *map, unsigned int reg)
+{
+	if (map->max_register && reg > map->max_register)
+		return false;
+
+	if (map->writeable_reg)
+		return map->writeable_reg(map->dev, reg);
+
+	return true;
+}
+
+bool regmap_readable(struct regmap *map, unsigned int reg)
+{
+	if (map->max_register && reg > map->max_register)
+		return false;
+
+	if (map->readable_reg)
+		return map->readable_reg(map->dev, reg);
+
+	return true;
+}
+
+bool regmap_volatile(struct regmap *map, unsigned int reg)
+{
+	if (map->max_register && reg > map->max_register)
+		return false;
+
+	if (map->volatile_reg)
+		return map->volatile_reg(map->dev, reg);
+
+	return true;
+}
+
+bool regmap_precious(struct regmap *map, unsigned int reg)
+{
+	if (map->max_register && reg > map->max_register)
+		return false;
+
+	if (map->precious_reg)
+		return map->precious_reg(map->dev, reg);
+
+	return false;
+}
+
 static void regmap_format_4_12_write(struct regmap *map,
 				     unsigned int reg, unsigned int val)
 {
-- 
1.7.5.4

