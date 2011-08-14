Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1HNKul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 06:50:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36362 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753109Ab1HNKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 06:50:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regmap: Provide access information via debugfs
Date: Sun, 14 Aug 2011 19:50:25 +0900
Message-Id: <1313319025-5514-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313319025-5514-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1313319025-5514-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let userspace know what the access map for the device is. This is helpful
for verifying that the access map is correctly configured and could also
be useful for programs that try to work with the data. File format is:

register: R W V P

where R, W, V and P are 'y' or 'n' showing readable, writable, volatile
and precious respectively.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |   72 +++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index e541d7f4..7a8d675 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -109,6 +109,73 @@ static const struct file_operations regmap_map_fops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t regmap_access_read_file(struct file *file,
+				       char __user *user_buf, size_t count,
+				       loff_t *ppos)
+{
+	int reg_len, tot_len;
+	size_t buf_pos = 0;
+	loff_t p = 0;
+	ssize_t ret;
+	int i;
+	struct regmap *map = file->private_data;
+	char *buf;
+
+	if (*ppos < 0 || !count)
+		return -EINVAL;
+
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Calculate the length of a fixed format  */
+	reg_len = regmap_calc_reg_len(map->max_register, buf, count);
+	tot_len = reg_len + 10; /* ': R W V P\n' */
+
+	for (i = 0; i < map->max_register; i++) {
+		/* Ignore registers which are neither readable nor writable */
+		if (!regmap_readable(map, i) && !regmap_writeable(map, i))
+			continue;
+
+		/* If we're in the region the user is trying to read */
+		if (p >= *ppos) {
+			/* ...but not beyond it */
+			if (buf_pos >= count - 1 - tot_len)
+				break;
+
+			/* Format the register */
+			snprintf(buf + buf_pos, count - buf_pos,
+				 "%.*x: %c %c %c %c\n",
+				 reg_len, i,
+				 regmap_readable(map, i) ? 'y' : 'n',
+				 regmap_writeable(map, i) ? 'y' : 'n',
+				 regmap_volatile(map, i) ? 'y' : 'n',
+				 regmap_precious(map, i) ? 'y' : 'n');
+
+			buf_pos += tot_len;
+		}
+		p += tot_len;
+	}
+
+	ret = buf_pos;
+
+	if (copy_to_user(user_buf, buf, buf_pos)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	*ppos += buf_pos;
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations regmap_access_fops = {
+	.open = regmap_open_file,
+	.read = regmap_access_read_file,
+	.llseek = default_llseek,
+};
 
 void regmap_debugfs_init(struct regmap *map)
 {
@@ -119,9 +186,12 @@ void regmap_debugfs_init(struct regmap *map)
 		return;
 	}
 
-	if (map->max_register)
+	if (map->max_register) {
 		debugfs_create_file("registers", 0400, map->debugfs,
 				    map, &regmap_map_fops);
+		debugfs_create_file("access", 0400, map->debugfs,
+				    map, &regmap_access_fops);
+	}
 }
 
 void regmap_debugfs_exit(struct regmap *map)
-- 
1.7.5.4

