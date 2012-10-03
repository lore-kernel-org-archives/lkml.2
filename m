Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2JCLSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:18:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45876 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab2JCLST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:18:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: When we sanity check during range adds say what errors we find
Date: Wed,  3 Oct 2012 12:18:14 +0100
Message-Id: <1349263094-9021-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than just returning a single error code for every possible thing we
can notice print an error message saying what the problem was. This makes
it very much easier to figure out what's wrong and fix it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ea9d6eb..0544f63 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -524,11 +524,29 @@ struct regmap *regmap_init(struct device *dev,
 		struct regmap_range_node *new;
 
 		/* Sanity check */
-		if (range_cfg->range_max < range_cfg->range_min ||
-		    range_cfg->range_max > map->max_register ||
-		    range_cfg->selector_reg > map->max_register ||
-		    range_cfg->window_len == 0)
+		if (range_cfg->range_max < range_cfg->range_min) {
+			dev_err(map->dev, "Invalid range %d: %d < %d\n", i,
+				range_cfg->range_max, range_cfg->range_min);
 			goto err_range;
+		}
+
+		if (range_cfg->range_max > map->max_register) {
+			dev_err(map->dev, "Invalid range %d: %d > %d\n", i,
+				range_cfg->range_max, map->max_register);
+			goto err_range;
+		}
+
+		if (range_cfg->selector_reg > map->max_register) {
+			dev_err(map->dev,
+				"Invalid range %d: selector out of map\n", i);
+			goto err_range;
+		}
+
+		if (range_cfg->window_len == 0) {
+			dev_err(map->dev, "Invalid range %d: window_len 0\n",
+				i);
+			goto err_range;
+		}
 
 		/* Make sure, that this register range has no selector
 		   or data window within its boundary */
@@ -540,11 +558,17 @@ struct regmap *regmap_init(struct device *dev,
 
 			if (range_cfg->range_min <= sel_reg &&
 			    sel_reg <= range_cfg->range_max) {
+				dev_err(map->dev,
+					"Range %d: selector for %d in window\n",
+					i, j);
 				goto err_range;
 			}
 
 			if (!(win_max < range_cfg->range_min ||
 			      win_min > range_cfg->range_max)) {
+				dev_err(map->dev,
+					"Range %d: window for %d in window\n",
+					i, j);
 				goto err_range;
 			}
 		}
@@ -564,6 +588,7 @@ struct regmap *regmap_init(struct device *dev,
 		new->window_len = range_cfg->window_len;
 
 		if (_regmap_range_add(map, new) == false) {
+			dev_err(map->dev, "Failed to add range %d\n", i);
 			kfree(new);
 			goto err_range;
 		}
-- 
1.7.10.4

