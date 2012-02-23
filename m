Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2BWUMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:12:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38074 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab2BWUMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:12:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Skip hardware defaults for LZO caches
Date: Thu, 23 Feb 2012 20:12:34 +0000
Message-Id: <1330027955-30651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves some I/O when resyncing; we assume that syncs start from the device
reset state.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-lzo.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 5e964e9..77dc532 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -349,6 +349,12 @@ static int regcache_lzo_sync(struct regmap *map, unsigned int min,
 		ret = regcache_read(map, i, &val);
 		if (ret)
 			return ret;
+
+		/* Is this the hardware default?  If so skip. */
+		ret = regcache_lookup_reg(map, i);
+		if (ret > 0 && val == map->reg_defaults[ret].def)
+			continue;
+
 		map->cache_bypass = 1;
 		ret = _regmap_write(map, i, val);
 		map->cache_bypass = 0;
-- 
1.7.9.1

