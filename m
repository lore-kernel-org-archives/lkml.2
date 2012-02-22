Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2BVMoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:44:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41419 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783Ab2BVMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:44:36 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] regmap: Add support for writing to regmap `registers'
Date: Wed, 22 Feb 2012 12:43:50 +0000
Message-Id: <1329914630-17624-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To enable writing to the regmap `registers' file, users will
need to modify the source directly and #define REGMAP_ALLOW_WRITE_DEBUGFS.
The reason for this is that it is dangerous to expose this
functionality in general where clients could potentially be PMICs.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |   39 ++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index f4ac8d6..656e81f 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -103,9 +103,48 @@ out:
 	return ret;
 }
 
+#undef REGMAP_ALLOW_WRITE_DEBUGFS
+#ifdef REGMAP_ALLOW_WRITE_DEBUGFS
+/* This can be dangerous especially when we have clients such as
+ * PMICs, therefore don't provide any real compile time configuration option
+ * for this feature, people who want to use this will need to modify
+ * the source code directly. */
+static ssize_t regmap_map_write_file(struct file *file, const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	char buf[32];
+	size_t buf_size;
+	char *start = buf;
+	unsigned long reg, value;
+	struct regmap *map = file->private_data;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	while (*start == ' ')
+		start++;
+	reg = simple_strtoul(start, &start, 16);
+	while (*start == ' ')
+		start++;
+	if (strict_strtoul(start, 16, &value))
+		return -EINVAL;
+
+	/* Userspace has been fiddling around behind the kernel's back */
+	add_taint(TAINT_USER);
+
+	regmap_write(map, reg, value);
+	return buf_size;
+}
+#endif
+
 static const struct file_operations regmap_map_fops = {
 	.open = regmap_open_file,
 	.read = regmap_map_read_file,
+#ifdef REGMAP_ALLOW_WRITE_DEBUGFS
+	.write = regmap_map_write_file,
+#endif
 	.llseek = default_llseek,
 };
 
-- 
1.7.9.1

