Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2BIMNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:13:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6645 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2BIMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:13:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Feb 2012 04:13:53 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] regmap: add bulk_write() for non-volatile register set
Date: Thu,  9 Feb 2012 17:42:11 +0530
Message-Id: <1328789531-10067-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding bulk write which is used for writing a large block of
data to the device.
If all registers which need to be written are volatile then all
data will be send in single transfer.
If any of the register is non-volatile and caching is enabled then
data will be written to device in single register wise and hence
complete transfer is done in multiple small transfer.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/base/regmap/regmap.c |   53 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |    2 +
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 80129c0..28dbe96 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -466,6 +466,59 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(regmap_raw_write);
 
+/*
+ * regmap_bulk_write(): Write multiple registers from the device
+ *
+ * @map: Register map to write to
+ * @reg: First register to be write from
+ * @val: Block of data to be written, laid out for direct transmission to
+ *       the device
+ * @val_count: Number of registers to write
+ *
+ * This function is intended to be used for writing a large block of
+ * data to be device either in single transfer or multiple transfer.
+ * If all registers which need to be written are volatile then all
+ * data will be send in single transfer. No data formatting is done in
+ * this case.
+ * If any of the register is non-volatile and caching is enabled then
+ * data will be written to device in single register wise and hence
+ * complete transfer is done in multiple small transfer. In this case,
+ * the register data will be formatted to device register value format.
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
+		     size_t val_count)
+{
+	int ret = 0, i;
+	unsigned int ival;
+	size_t val_bytes = map->format.val_bytes;
+	size_t reg_bytes = map->format.reg_bytes;
+	bool vol = regmap_volatile_range(map, reg, val_count);
+
+	if (!map->format.parse_val)
+		return -EINVAL;
+
+	mutex_lock(&map->lock);
+
+	if (vol || map->cache_type == REGCACHE_NONE) {
+		ret = _regmap_raw_write(map, reg, val, val_bytes * val_count);
+	} else {
+		for (i = 0; i < val_count; i++) {
+			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
+			ival = map->format.parse_val(map->work_buf);
+			ret = _regmap_write(map, reg + (i * reg_bytes), ival);
+			if (ret)
+				break;
+		}
+	}
+
+	mutex_unlock(&map->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_bulk_write);
+
 static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a6ed6e6..0925e24 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -135,6 +135,8 @@ int regmap_reinit_cache(struct regmap *map,
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
+int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
+			size_t val_count);
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
 int regmap_raw_read(struct regmap *map, unsigned int reg,
 		    void *val, size_t val_len);
-- 
1.7.1.1

