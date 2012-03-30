Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab2C3LZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:25:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58264 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933693Ab2C3LZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:25:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Pull non-DT supply mapping into regulator_dev_lookup()
Date: Fri, 30 Mar 2012 12:25:03 +0100
Message-Id: <1333106703-12790-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we always apply the supply mapping when doing a lookup rather than
only doing it in non-DT cases, ensuring that regulators with supplies
specified in the regulator_desc can find their supplies on non-DT systems
and generally making the code more obvious.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bafbbb3..d6950c2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1174,6 +1174,8 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 {
 	struct regulator_dev *r;
 	struct device_node *node;
+	struct regulator_map *map;
+	const char *devname = NULL;
 
 	/* first do a dt based lookup */
 	if (dev && dev->of_node) {
@@ -1195,10 +1197,24 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 	}
 
 	/* if not found, try doing it non-dt way */
+	if (dev)
+		devname = dev_name(dev);
+
 	list_for_each_entry(r, &regulator_list, list)
 		if (strcmp(rdev_get_name(r), supply) == 0)
 			return r;
 
+	list_for_each_entry(map, &regulator_map_list, list) {
+		/* If the mapping has a device set up it must match */
+		if (map->dev_name &&
+		    (!devname || strcmp(map->dev_name, devname)))
+			continue;
+
+		if (strcmp(map->supply, supply) == 0)
+			return map->regulator;
+	}
+
+
 	return NULL;
 }
 
@@ -1207,7 +1223,6 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 					int exclusive)
 {
 	struct regulator_dev *rdev;
-	struct regulator_map *map;
 	struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
 	const char *devname = NULL;
 	int ret;
@@ -1226,18 +1241,6 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	if (rdev)
 		goto found;
 
-	list_for_each_entry(map, &regulator_map_list, list) {
-		/* If the mapping has a device set up it must match */
-		if (map->dev_name &&
-		    (!devname || strcmp(map->dev_name, devname)))
-			continue;
-
-		if (strcmp(map->supply, id) == 0) {
-			rdev = map->regulator;
-			goto found;
-		}
-	}
-
 	if (board_wants_dummy_regulator) {
 		rdev = dummy_regulator_rdev;
 		goto found;
-- 
1.7.9.1

