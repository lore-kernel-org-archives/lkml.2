Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1LISMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:12:12 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48025 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1LISKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:10:49 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v2 1/6] max17042: Move power suppply registration to a worker thread
Date: Fri,  9 Dec 2011 10:08:43 -0800
Message-Id: <1323454129-7444-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323454129-7444-1-git-send-email-dirk.brandewie@gmail.com>
References: <1323454129-7444-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch move the final registration of the battery to a worker
thread in preperation for adding the POR proceedure recommended by
maxim. This is needed since the Maxim init proceedure requires two
long delays totaling 850ms. This patch will reduce the impact on
system boot time.  The battery will not be available to the power
supply subsystem until the init proceedure is complete

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/power/max17042_battery.c |   48 ++++++++++++++++++++++++++------------
 1 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 9f0183c..16f3934 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -34,6 +34,8 @@ struct max17042_chip {
 	struct i2c_client *client;
 	struct power_supply battery;
 	struct max17042_platform_data *pdata;
+	struct work_struct work;
+	int    init_complete;
 };
 
 static int max17042_write_reg(struct i2c_client *client, u8 reg, u16 value)
@@ -86,6 +88,9 @@ static int max17042_get_property(struct power_supply *psy,
 	struct max17042_chip *chip = container_of(psy,
 				struct max17042_chip, battery);
 
+	if (!chip->init_complete)
+		return -EAGAIN;
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = max17042_read_reg(chip->client,
@@ -180,6 +185,31 @@ static int max17042_get_property(struct power_supply *psy,
 	return 0;
 }
 
+static void max17042_init_worker(struct work_struct *work)
+{
+	struct max17042_chip *chip = container_of(work,
+				struct max17042_chip, work);
+	struct i2c_client *client = chip->client;
+	int ret;
+
+
+	/* Initialize registers according to values from the platform data */
+	if (chip->pdata->init_data)
+		max17042_set_reg(client, chip->pdata->init_data,
+				 chip->pdata->num_init_data);
+
+	if (!chip->pdata->enable_current_sense) {
+		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
+		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
+		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
+	} else {
+		if (chip->pdata->r_sns == 0)
+			chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
+	}
+
+	chip->init_complete = 1;
+}
+
 static int __devinit max17042_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -214,24 +244,12 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	if (ret) {
 		dev_err(&client->dev, "failed: power supply register\n");
 		kfree(chip);
-		return ret;
-	}
-
-	/* Initialize registers according to values from the platform data */
-	if (chip->pdata->init_data)
-		max17042_set_reg(client, chip->pdata->init_data,
-				 chip->pdata->num_init_data);
-
-	if (!chip->pdata->enable_current_sense) {
-		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
-		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
-		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
 	} else {
-		if (chip->pdata->r_sns == 0)
-			chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
+		INIT_WORK(&chip->work, max17042_init_worker);
+		schedule_work(&chip->work);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int __devexit max17042_remove(struct i2c_client *client)
-- 
1.7.7.3

