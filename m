Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2AYVH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:07:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33230 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab2AYVHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:07:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: Skip patch application when the cache is not dirty on sync
Date: Wed, 25 Jan 2012 21:07:20 +0000
Message-Id: <1327525640-32260-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
In-Reply-To: <1327525640-32260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1327525640-32260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the basis that if we don't actually need to resync the cache then the
patches are probably also already applied.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index bfe48e4..d103401 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -267,6 +267,9 @@ int regcache_sync(struct regmap *map)
 	name = map->cache_ops->name;
 	trace_regcache_sync(map->dev, name, "start");
 
+	if (!map->cache_dirty)
+		goto out;
+
 	/* Apply any patch first */
 	map->cache_bypass = 1;
 	for (i = 0; i < map->patch_regs; i++) {
@@ -279,8 +282,6 @@ int regcache_sync(struct regmap *map)
 	}
 	map->cache_bypass = 0;
 
-	if (!map->cache_dirty)
-		goto out;
 	if (map->cache_ops->sync) {
 		ret = map->cache_ops->sync(map);
 	} else {
-- 
1.7.9.rc1

