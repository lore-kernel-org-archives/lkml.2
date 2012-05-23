Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2EWWbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 18:31:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44725 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2EWWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 18:31:01 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: clean up debugfs if regmap_init fails
Date: Wed, 23 May 2012 16:30:53 -0600
Message-Id: <1337812253-7564-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

If debugfs isn't cleaned up, stale files will be left in the filesystem
which will cause an OOPS when accessed the first time, and hang the
accessing application when accessed again, presumably due to some lock
being left held.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0bcda48..2aa076e 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -368,7 +368,7 @@ struct regmap *regmap_init(struct device *dev,
 
 	ret = regcache_init(map, config);
 	if (ret < 0)
-		goto err_free_workbuf;
+		goto err_debugfs;
 
 	/* Add a devres resource for dev_get_regmap() */
 	m = devres_alloc(dev_get_regmap_release, sizeof(*m), GFP_KERNEL);
@@ -383,7 +383,8 @@ struct regmap *regmap_init(struct device *dev,
 
 err_cache:
 	regcache_exit(map);
-err_free_workbuf:
+err_debugfs:
+	regmap_debugfs_exit(map);
 	kfree(map->work_buf);
 err_map:
 	kfree(map);
-- 
1.7.0.4

