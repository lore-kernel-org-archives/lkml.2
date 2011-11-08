Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1KHRww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:52:52 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:46083 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751247Ab1KHRwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:52:51 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 12:52:51 EST
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] regmap: Add helper function for checking if a register range is volatile
Date: Tue, 8 Nov 2011 18:37:25 +0100
Message-ID: <1320773846-28635-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have the same code for checking whether a register range is volatile
in two different places. Instead of duplicating it once more  add a small helper
function for checking whether a register range is voltaile.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regmap.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bf441db..4016b00 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -64,6 +64,18 @@ bool regmap_precious(struct regmap *map, unsigned int reg)
 	return false;
 }
 
+static bool regmap_volatile_range(struct regmap *map, unsigned int reg,
+	unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		if (!regmap_volatile(map, reg + i))
+			return false;
+
+	return true;
+}
+
 static void regmap_format_4_12_write(struct regmap *map,
 				     unsigned int reg, unsigned int val)
 {
@@ -481,15 +493,11 @@ EXPORT_SYMBOL_GPL(regmap_read);
 int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 		    size_t val_len)
 {
+	size_t val_count = val_len / map->format.val_bytes;
 	int ret;
-	int i;
-	bool vol = true;
-
-	for (i = 0; i < val_len / map->format.val_bytes; i++)
-		if (!regmap_volatile(map, reg + i))
-			vol = false;
 
-	WARN_ON(!vol && map->cache_type != REGCACHE_NONE);
+	WARN_ON(!regmap_volatile_range(map, reg, val_count) &&
+		map->cache_type != REGCACHE_NONE);
 
 	mutex_lock(&map->lock);
 
@@ -517,16 +525,11 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 {
 	int ret, i;
 	size_t val_bytes = map->format.val_bytes;
-	bool vol = true;
+	bool vol = regmap_volatile_range(map, reg, val_count);
 
 	if (!map->format.parse_val)
 		return -EINVAL;
 
-	/* Is this a block of volatile registers? */
-	for (i = 0; i < val_count; i++)
-		if (!regmap_volatile(map, reg + i))
-			vol = false;
-
 	if (vol || map->cache_type == REGCACHE_NONE) {
 		ret = regmap_raw_read(map, reg, val, val_bytes * val_count);
 		if (ret != 0)
-- 
1.7.7


