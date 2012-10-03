Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2JCMnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:43:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56179 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab2JCMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:43:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regmap: Factor out debugfs register read
Date: Wed,  3 Oct 2012 13:43:01 +0100
Message-Id: <1349268182-21804-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349268182-21804-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1349268182-21804-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow the use of the same code for reading register ranges.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index bb1ff17..25b6843 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -56,15 +56,15 @@ static const struct file_operations regmap_name_fops = {
 	.llseek = default_llseek,
 };
 
-static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
-				    size_t count, loff_t *ppos)
+static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
+				   unsigned int to, char __user *user_buf,
+				   size_t count, loff_t *ppos)
 {
 	int reg_len, val_len, tot_len;
 	size_t buf_pos = 0;
 	loff_t p = 0;
 	ssize_t ret;
 	int i;
-	struct regmap *map = file->private_data;
 	char *buf;
 	unsigned int val;
 
@@ -80,7 +80,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 	val_len = 2 * map->format.val_bytes;
 	tot_len = reg_len + val_len + 3;      /* : \n */
 
-	for (i = 0; i <= map->max_register; i += map->reg_stride) {
+	for (i = from; i <= to; i += map->reg_stride) {
 		if (!regmap_readable(map, i))
 			continue;
 
@@ -95,7 +95,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 
 			/* Format the register */
 			snprintf(buf + buf_pos, count - buf_pos, "%.*x: ",
-				 reg_len, i);
+				 reg_len, i - from);
 			buf_pos += reg_len + 2;
 
 			/* Format the value, write all X if we can't read */
@@ -126,6 +126,15 @@ out:
 	return ret;
 }
 
+static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct regmap *map = file->private_data;
+
+	return regmap_read_debugfs(map, 0, map->max_register, user_buf,
+				   count, ppos);
+}
+
 #undef REGMAP_ALLOW_WRITE_DEBUGFS
 #ifdef REGMAP_ALLOW_WRITE_DEBUGFS
 /*
-- 
1.7.10.4

