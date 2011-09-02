Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1IBPqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:46:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53655 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753227Ab1IBPqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:46:44 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 7/8] regmap: It is impossible to be given a NULL defaults cache
Date: Fri,  2 Sep 2011 16:46:14 +0100
Message-Id: <1314978375-11539-8-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the new regcache API, it is impossible to hand a NULL defaults
cache to any of the cache compression types.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-lzo.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 9e0d7be..18e1a8c 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -125,32 +125,17 @@ static int regcache_lzo_init(struct regmap *map)
 {
 	struct regcache_lzo_ctx **lzo_blocks;
 	size_t bmp_size;
-	int ret, tofree, i, blksize, blkcount;
+	int ret, i, blksize, blkcount;
 	const char *p, *end;
 	unsigned long *sync_bmp;
 
 	ret = 0;
 
-	/*
-	 * If we have not been given a default register cache
-	 * then allocate a dummy zero-ed out region, compress it
-	 * and remember to free it afterwards.
-	 */
-	tofree = 0;
-	if (!map->cache_defaults_raw) {
-		map->cache_defaults_raw = kzalloc(map->cache_size_raw, GFP_KERNEL);
-		if (!map->cache_defaults_raw)
-			return -ENOMEM;
-		tofree = 1;
-	}
-
 	blkcount = regcache_lzo_block_count();
 	map->cache = kzalloc(blkcount * sizeof *lzo_blocks,
 			     GFP_KERNEL);
-	if (!map->cache) {
-		ret = -ENOMEM;
-		goto err_tofree;
-	}
+	if (!map->cache)
+		return -ENOMEM;
 	lzo_blocks = map->cache;
 
 	/*
@@ -203,18 +188,9 @@ static int regcache_lzo_init(struct regmap *map)
 			lzo_blocks[i]->src_len;
 	}
 
-	if (tofree) {
-		kfree(map->cache_defaults_raw);
-		map->cache_defaults_raw = NULL;
-	}
 	return 0;
 err:
 	regcache_exit(map);
-err_tofree:
-	if (tofree) {
-		kfree(map->cache_defaults_raw);
-		map->cache_defaults_raw = NULL;
-	}
 	return ret;
 }
 
-- 
1.7.6.1

