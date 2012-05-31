Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2EaQSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:18:03 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:3636 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2EaQSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:18:01 -0400
Message-Id: <201205311616.q4VGGZjR014516@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 31 May 2012 16:19:36 +0200
Subject: [PATCH 2/4] regmap: Make internal read/write functions reentrant from themselves.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions _regmap_update_bits() and _regmap_write() are modified
so they can be recurrently entered from the inside.

The internal reading functions need no modification for current implementation
of indirect access.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/regmap.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a365aa8..7c5291e 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -515,12 +515,9 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 		return ret;
 	} else {
-		map->format.format_val(map->work_buf + map->format.reg_bytes
-				       + map->format.pad_bytes, val);
-		return _regmap_raw_write(map, reg,
-					 map->work_buf +
-					 map->format.reg_bytes +
-					 map->format.pad_bytes,
+		/* Using stack for value data, to make function reentrant */
+		map->format.format_val(&val, val);
+		return _regmap_raw_write(map, reg, &val,
 					 map->format.val_bytes);
 	}
 }
@@ -810,11 +807,9 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 	int ret;
 	unsigned int tmp, orig;
 
-	mutex_lock(&map->lock);
-
 	ret = _regmap_read(map, reg, &orig);
 	if (ret != 0)
-		goto out;
+		return ret;
 
 	tmp = orig & ~mask;
 	tmp |= val & mask;
@@ -826,9 +821,6 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 		*change = false;
 	}
 
-out:
-	mutex_unlock(&map->lock);
-
 	return ret;
 }
 
@@ -846,7 +838,12 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
 	bool change;
-	return _regmap_update_bits(map, reg, mask, val, &change);
+	int ret;
+
+	mutex_lock(&map->lock);
+	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	mutex_unlock(&map->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits);
 
@@ -866,7 +863,12 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change)
 {
-	return _regmap_update_bits(map, reg, mask, val, change);
+	int ret;
+
+	mutex_lock(&map->lock);
+	ret = _regmap_update_bits(map, reg, mask, val, change);
+	mutex_unlock(&map->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
-- 
1.7.0.4

