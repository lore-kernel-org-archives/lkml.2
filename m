Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1IERya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:54:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37053 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752056Ab1IERyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:54:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regmap: Remove bitrotted module_put()s
Date: Mon,  5 Sep 2011 10:54:08 -0700
Message-Id: <1315245250-24292-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion to per bus type registration functions means we don't need
to do module_get()s to hold the bus types in memory (their users will link
to them) so we removed all those calls. This left module_put() calls in
the cleanup paths which aren't needed and which cause unbalanced puts if
we ever try to unload anything.

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fa2bd89..86b1847 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -198,15 +198,13 @@ struct regmap *regmap_init(struct device *dev,
 	map->work_buf = kmalloc(map->format.buf_size, GFP_KERNEL);
 	if (map->work_buf == NULL) {
 		ret = -ENOMEM;
-		goto err_bus;
+		goto err_map;
 	}
 
 	regmap_debugfs_init(map);
 
 	return map;
 
-err_bus:
-	module_put(map->bus->owner);
 err_map:
 	kfree(map);
 err:
@@ -221,7 +219,6 @@ void regmap_exit(struct regmap *map)
 {
 	regmap_debugfs_exit(map);
 	kfree(map->work_buf);
-	module_put(map->bus->owner);
 	kfree(map);
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
-- 
1.7.5.4

