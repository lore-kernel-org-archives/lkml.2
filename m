Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2EaQX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:23:28 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:42420 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2EaQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:23:26 -0400
Message-Id: <201205311622.q4VGMHGe015484@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 31 May 2012 17:11:38 +0200
Subject: [PATCH 4/4] regmap: Minor optimisation for _regmap_raw_write().
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to make things simplier inside the function.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/regmap.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c32d1a6..7581ad9 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -612,17 +612,18 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int i;
 	int ret;
+	unsigned int val_num = val_len / map->format.val_bytes;
 
 	/* Check for unwritable registers before we start */
 	if (map->writeable_reg)
-		for (i = 0; i < val_len / map->format.val_bytes; i++)
+		for (i = 0; i < val_num; i++)
 			if (!map->writeable_reg(map->dev, reg + i))
 				return -EINVAL;
 
 	if (!map->cache_bypass && map->format.parse_val) {
 		unsigned int ival;
 		int val_bytes = map->format.val_bytes;
-		for (i = 0; i < val_len / map->format.val_bytes; i++) {
+		for (i = 0; i < val_num; i++) {
 			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
 			ival = map->format.parse_val(map->work_buf);
 			ret = regcache_write(map, reg + i, ival);
@@ -639,8 +640,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		}
 	}
 
-	return _regmap_range_access(_regmap_bus_write, map, reg, (void *)val,
-				    val_len / map->format.val_bytes);
+	return _regmap_range_access(_regmap_bus_write,
+				    map, reg, (void *)val, val_num);
 }
 
 int _regmap_write(struct regmap *map, unsigned int reg,
-- 
1.7.0.4

