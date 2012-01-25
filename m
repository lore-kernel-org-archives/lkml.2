Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2AYVHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:07:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab2AYVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:07:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Bypass the cache when applying patches
Date: Wed, 25 Jan 2012 21:07:19 +0000
Message-Id: <1327525640-32260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise any patch that affects a register which is writable may trash
cached values.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 0d54668..bfe48e4 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -268,6 +268,7 @@ int regcache_sync(struct regmap *map)
 	trace_regcache_sync(map->dev, name, "start");
 
 	/* Apply any patch first */
+	map->cache_bypass = 1;
 	for (i = 0; i < map->patch_regs; i++) {
 		ret = _regmap_write(map, map->patch[i].reg, map->patch[i].def);
 		if (ret != 0) {
@@ -276,6 +277,7 @@ int regcache_sync(struct regmap *map)
 			goto out;
 		}
 	}
+	map->cache_bypass = 0;
 
 	if (!map->cache_dirty)
 		goto out;
-- 
1.7.9.rc1

