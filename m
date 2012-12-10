Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2LJQZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:25:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47775 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab2LJQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:25:40 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regmap: debugfs: Factor out initial seek
Date: Tue, 11 Dec 2012 01:25:31 +0900
Message-Id: <1355156732-2943-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355156732-2943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1355156732-2943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for doing things a bit more quickly than a linear scan
factor out the initial seek from the debugfs register dump.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |   39 +++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 3df274e..749a1dc 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -56,16 +56,46 @@ static const struct file_operations regmap_name_fops = {
 	.llseek = default_llseek,
 };
 
+/*
+ * Work out where the start offset maps into register numbers, bearing
+ * in mind that we suppress hidden registers.
+ */
+static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
+						  unsigned int base,
+						  loff_t from,
+						  loff_t *pos)
+{
+	loff_t p = *pos;
+	unsigned int i;
+
+	for (i = base; i <= map->max_register; i += map->reg_stride) {
+		if (!regmap_readable(map, i))
+			continue;
+
+		if (regmap_precious(map, i))
+			continue;
+
+		if (i >= from) {
+			*pos = p;
+			return i;
+		}
+
+		p += map->debugfs_tot_len;
+	}
+
+	return base;
+}
+
 static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 				   unsigned int to, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
 	size_t buf_pos = 0;
-	loff_t p = 0;
+	loff_t p = *ppos;
 	ssize_t ret;
 	int i;
 	char *buf;
-	unsigned int val;
+	unsigned int val, start_reg;
 
 	if (*ppos < 0 || !count)
 		return -EINVAL;
@@ -83,7 +113,10 @@ static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 			map->debugfs_val_len + 3;      /* : \n */
 	}
 
-	for (i = from; i <= to; i += map->reg_stride) {
+	/* Work out which register we're starting at */
+	start_reg = regmap_debugfs_get_dump_start(map, from, *ppos, &p);
+
+	for (i = start_reg; i <= to; i += map->reg_stride) {
 		if (!regmap_readable(map, i))
 			continue;
 
-- 
1.7.10.4

