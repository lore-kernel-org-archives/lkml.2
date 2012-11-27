Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2K0GF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:05:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2K0GF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:05:27 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, cbouatmailru@gmail.com, dwmw2@infradead.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/3] power: bq2415x_charger: Use devm_kzalloc()
Date: Tue, 27 Nov 2012 11:28:46 +0530
Message-Id: <1353995926-4621-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
References: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kzalloc is device managed and makes error handling
and code cleanup a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/bq2415x_charger.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 54c4ebf..f93359b 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1522,7 +1522,7 @@ static int bq2415x_probe(struct i2c_client *client,
 		goto error_1;
 	}
 
-	bq = kzalloc(sizeof(*bq), GFP_KERNEL);
+	bq = devm_kzalloc(&client->dev, sizeof(*bq), GFP_KERNEL);
 	if (!bq) {
 		dev_err(&client->dev, "failed to allocate device data\n");
 		ret = -ENOMEM;
@@ -1548,19 +1548,19 @@ static int bq2415x_probe(struct i2c_client *client,
 	ret = bq2415x_power_supply_init(bq);
 	if (ret) {
 		dev_err(bq->dev, "failed to register power supply: %d\n", ret);
-		goto error_3;
+		goto error_2;
 	}
 
 	ret = bq2415x_sysfs_init(bq);
 	if (ret) {
 		dev_err(bq->dev, "failed to create sysfs entries: %d\n", ret);
-		goto error_4;
+		goto error_3;
 	}
 
 	ret = bq2415x_set_defaults(bq);
 	if (ret) {
 		dev_err(bq->dev, "failed to set default values: %d\n", ret);
-		goto error_5;
+		goto error_4;
 	}
 
 	if (bq->init_data.set_mode_hook) {
@@ -1584,12 +1584,10 @@ static int bq2415x_probe(struct i2c_client *client,
 	dev_info(bq->dev, "driver registered\n");
 	return 0;
 
-error_5:
-	bq2415x_sysfs_exit(bq);
 error_4:
-	bq2415x_power_supply_exit(bq);
+	bq2415x_sysfs_exit(bq);
 error_3:
-	kfree(bq);
+	bq2415x_power_supply_exit(bq);
 error_2:
 	kfree(name);
 error_1:
@@ -1621,7 +1619,6 @@ static int bq2415x_remove(struct i2c_client *client)
 	dev_info(bq->dev, "driver unregistered\n");
 
 	kfree(bq->name);
-	kfree(bq);
 
 	return 0;
 }
-- 
1.7.4.1

