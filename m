Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2BQN3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:29:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10392 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2BQN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:29:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 17 Feb 2012 05:29:45 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        lars@metafoo.de, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] regmap: Bypassing cache when initializing cache
Date: Fri, 17 Feb 2012 18:57:26 +0530
Message-Id: <1329485246-14226-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During regcache_init, if client has not passed the
default data of cached register then it is directly
read from the hw to initialize cache. This hw register
read happens before cache ops are initialized and hence
avoiding register read to check for the data available
on cache or not by enabling flag of cache_bypass.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Observed that regcache_hw_init() is gettign called before
cache->ops->init() hapens. The function regcache_hw_init()
is calling the regmap_bulk_read() which internally calls the
regcache-read() and ending with cache->ops->read() and this
cause of system crash as the cache ops are not initialized.
With this patch, avoiding the regcache-read() from
regmap_bulk_read() by enabling cache bypass.


 drivers/base/regmap/regcache.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index a10e81c..853dfff 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -35,12 +35,17 @@ static int regcache_hw_init(struct regmap *map)
 		return -EINVAL;
 
 	if (!map->reg_defaults_raw) {
+		u32 cache_bypass = map->cache_bypass;
 		dev_warn(map->dev, "No cache defaults, reading back from HW\n");
+
+		/* Bypass the cache access till data read from HW*/
+		map->cache_bypass = 1;
 		tmp_buf = kmalloc(map->cache_size_raw, GFP_KERNEL);
 		if (!tmp_buf)
 			return -EINVAL;
 		ret = regmap_bulk_read(map, 0, tmp_buf,
 				       map->num_reg_defaults_raw);
+		map->cache_bypass = cache_bypass;
 		if (ret < 0) {
 			kfree(tmp_buf);
 			return ret;
-- 
1.7.1.1

