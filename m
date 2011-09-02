Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1IBPrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:47:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53666 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753195Ab1IBPqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:46:45 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 8/8] regmap: Support NULL cache_defaults_raw
Date: Fri,  2 Sep 2011 16:46:15 +0100
Message-Id: <1314978375-11539-9-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IC's like PMIC's tend not to have cache defaults.  Support this
by reading back from the hardware using the bulk read operation the values
of all registers and constructing the cache defaults manually.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    2 ++
 drivers/base/regmap/regcache.c |   27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 9f228c7..f8b6219 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -65,6 +65,8 @@ struct regmap {
 	unsigned int cache_only:1;
 	/* if set, only the HW is modified not the cache */
 	unsigned int cache_bypass:1;
+	/* if set, remember to free cache_defaults_raw */
+	unsigned int cache_free:1;
 
 	struct reg_default *cache_defaults;
 	const void *cache_defaults_raw;
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 6346d77..fb35fc4 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -31,7 +31,9 @@ int regcache_init(struct regmap *map)
 {
 	int i, j;
 	int count;
+	int ret;
 	unsigned int val;
+	void *tmp_buf;
 
 	if (map->cache_type == REGCACHE_NONE)
 		return 0;
@@ -51,9 +53,25 @@ int regcache_init(struct regmap *map)
 	if (!map->cache_ops->name)
 		return -EINVAL;
 
-	if (!map->cache_defaults_raw || !map->num_cache_defaults_raw) {
-		dev_err(map->dev, "Client has not provided a defaults cache\n");
-		return -EINVAL;
+	/* Some devices such as PMIC's don't have cache defaults,
+	 * we cope with this by reading back the HW registers and
+	 * crafting the cache defaults by hand.
+	 */
+	if (!map->cache_defaults_raw) {
+		if (!map->num_cache_defaults_raw)
+			return -EINVAL;
+		dev_warn(map->dev, "No cache defaults, reading back from HW\n");
+		tmp_buf = kmalloc(map->cache_size_raw, GFP_KERNEL);
+		if (!tmp_buf)
+			return -EINVAL;
+		ret = regmap_bulk_read(map, 0, tmp_buf,
+				       map->num_cache_defaults_raw);
+		if (ret < 0) {
+			kfree(tmp_buf);
+			return ret;
+		}
+		map->cache_defaults_raw = tmp_buf;
+		map->cache_free = 1;
 	}
 
 	/* calculate the size of cache_defaults */
@@ -98,6 +116,9 @@ void regcache_exit(struct regmap *map)
 	BUG_ON(!map->cache_ops);
 
 	kfree(map->cache_defaults);
+	if (map->cache_free)
+		kfree(map->cache_defaults_raw);
+
 	if (map->cache_ops->exit) {
 		dev_dbg(map->dev, "Destroying %s cache\n",
 			map->cache_ops->name);
-- 
1.7.6.1

