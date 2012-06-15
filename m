Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2FOKr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:47:56 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:32666 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2FOKrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:47:55 -0400
Message-Id: <201206151046.q5FAke4x002812@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Fri, 15 Jun 2012 11:23:56 +0100
Subject: [PATCH 1/2 v2] regmap: Move lock out from internal function _regmap_update_bits().
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locks are moved to regmap_update_bits(), which allows to reenter internal
function _regmap_update_bits() from inside of regmap read/write routines.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/regmap.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0bcda48..ce35b8c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -980,11 +980,9 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 	int ret;
 	unsigned int tmp, orig;
 
-	map->lock(map);
-
 	ret = _regmap_read(map, reg, &orig);
 	if (ret != 0)
-		goto out;
+		return ret;
 
 	tmp = orig & ~mask;
 	tmp |= val & mask;
@@ -996,9 +994,6 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 		*change = false;
 	}
 
-out:
-	map->unlock(map);
-
 	return ret;
 }
 
@@ -1016,7 +1011,13 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
 	bool change;
-	return _regmap_update_bits(map, reg, mask, val, &change);
+	int ret;
+
+	map->lock(map);
+	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	map->unlock(map);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits);
 
@@ -1036,7 +1037,12 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change)
 {
-	return _regmap_update_bits(map, reg, mask, val, change);
+	int ret;
+
+	map->lock(map);
+	ret = _regmap_update_bits(map, reg, mask, val, change);
+	map->unlock(map);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
-- 
1.7.0.4

