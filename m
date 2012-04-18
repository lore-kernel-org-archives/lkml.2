Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2DRBek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:34:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33469 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2DRBej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:34:39 -0400
Message-ID: <1334712874.3020.5.camel@phoenix>
Subject: [PATCH 1/2] regulator: userspace-consumer: Convert to use devm_*
 APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 18 Apr 2012 09:34:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/userspace-consumer.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
index 518667e..a7c8deb 100644
--- a/drivers/regulator/userspace-consumer.c
+++ b/drivers/regulator/userspace-consumer.c
@@ -115,7 +115,9 @@ static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EINVAL;
 
-	drvdata = kzalloc(sizeof(struct userspace_consumer_data), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev,
+			       sizeof(struct userspace_consumer_data),
+			       GFP_KERNEL);
 	if (drvdata == NULL)
 		return -ENOMEM;
 
@@ -125,16 +127,16 @@ static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 
 	mutex_init(&drvdata->lock);
 
-	ret = regulator_bulk_get(&pdev->dev, drvdata->num_supplies,
-				 drvdata->supplies);
+	ret = devm_regulator_bulk_get(&pdev->dev, drvdata->num_supplies,
+				      drvdata->supplies);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to get supplies: %d\n", ret);
-		goto err_alloc_supplies;
+		return ret;
 	}
 
 	ret = sysfs_create_group(&pdev->dev.kobj, &attr_group);
 	if (ret != 0)
-		goto err_create_attrs;
+		return ret;
 
 	if (pdata->init_on) {
 		ret = regulator_bulk_enable(drvdata->num_supplies,
@@ -154,11 +156,6 @@ static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 err_enable:
 	sysfs_remove_group(&pdev->dev.kobj, &attr_group);
 
-err_create_attrs:
-	regulator_bulk_free(drvdata->num_supplies, drvdata->supplies);
-
-err_alloc_supplies:
-	kfree(drvdata);
 	return ret;
 }
 
@@ -171,9 +168,6 @@ static int regulator_userspace_consumer_remove(struct platform_device *pdev)
 	if (data->enabled)
 		regulator_bulk_disable(data->num_supplies, data->supplies);
 
-	regulator_bulk_free(data->num_supplies, data->supplies);
-	kfree(data);
-
 	return 0;
 }
 
-- 
1.7.5.4



