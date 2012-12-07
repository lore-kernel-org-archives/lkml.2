Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2LGIpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:45:05 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36516 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab2LGIpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:45:04 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, sachin.kamat@linaro.org, patches@linaro.org,
        Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH 1/1] mfd: 88pm80x: Remove unnecessary exit APIs
Date: Fri,  7 Dec 2012 14:08:09 +0530
Message-Id: <1354869489-4054-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses devm_* APIs.
Thus explicit exit calls (regmap_exit and devm_kfree) are not needed
as they are device managed APIs.

Cc: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/88pm80x.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
index 1adb355..3288a4a 100644
--- a/drivers/mfd/88pm80x.c
+++ b/drivers/mfd/88pm80x.c
@@ -48,14 +48,12 @@ int pm80x_init(struct i2c_client *client,
 		ret = PTR_ERR(map);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n",
 			ret);
-		goto err_regmap_init;
+		return ret;
 	}
 
 	chip->id = id->driver_data;
-	if (chip->id < CHIP_PM800 || chip->id > CHIP_PM805) {
-		ret = -EINVAL;
-		goto err_chip_id;
-	}
+	if (chip->id < CHIP_PM800 || chip->id > CHIP_PM805)
+		return -EINVAL;
 
 	chip->client = client;
 	chip->regmap = map;
@@ -82,19 +80,11 @@ int pm80x_init(struct i2c_client *client,
 	}
 
 	return 0;
-
-err_chip_id:
-	regmap_exit(map);
-err_regmap_init:
-	devm_kfree(&client->dev, chip);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(pm80x_init);
 
 int pm80x_deinit(struct i2c_client *client)
 {
-	struct pm80x_chip *chip = i2c_get_clientdata(client);
-
 	/*
 	 * workaround: clear the dependency between pm800 and pm805.
 	 * would remove it after HW chip fixes the issue.
@@ -104,9 +94,6 @@ int pm80x_deinit(struct i2c_client *client)
 	else
 		g_pm80x_chip = NULL;
 
-	regmap_exit(chip->regmap);
-	devm_kfree(&client->dev, chip);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pm80x_deinit);
-- 
1.7.4.1

