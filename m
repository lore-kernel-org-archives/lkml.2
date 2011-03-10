Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1CJASj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:18:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9385 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab1CJASi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:18:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Mar 2011 16:18:37 -0800
From: rklein@nvidia.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH] power: bq20z75: fix issues with present and suspend
Date: Wed,  9 Mar 2011 16:18:02 -0800
Message-Id: <1299716282-21857-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

There are a few issues found around the battery not being present. If the
battery isn't present, then a few undesirable things happen. The first was
excessive reporting of failed properties. This was fixed by instead returning
ENODATA for all properties other than PRESENT if the battery isn't present.
That way the callers can identify the difference between a failure and the
battery not being there.

The next issue was in the suspend logic. It was found that if the battery wasn't
present, then it would return a failure, preventing the system from going into
suspend. If there is no battery present, the io is expected to fail, so in that
case, we shouldn't return the failure and just acknowledge that it was expected.

I also found that when a gpio was used, i didn't maintain the internal
is_present state properly. I added a set of that to fix that.

Lastly, the code to see io's fail and figure out that the battery isn't present
when not using a gpio had a problem. In that code, it looked for the read to
fail and if it did, then handled it. The problem is that in function to get the
property, it first writes a value and that write can fail, causing the code
to never reach the logic after the read. Fix is to move the logic till after
the write.

Change-Id: I09c9a9f0c1f0bcbad2308b6ffc65f6823d6a7ad0
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 8018e8c..5615c92 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -171,7 +171,7 @@ static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
 	}
 
 	if (ret < 0) {
-		dev_warn(&client->dev,
+		dev_dbg(&client->dev,
 			"%s: i2c read at address 0x%x failed\n",
 			__func__, address);
 		return ret;
@@ -199,7 +199,7 @@ static int bq20z75_write_word_data(struct i2c_client *client, u8 address,
 	}
 
 	if (ret < 0) {
-		dev_warn(&client->dev,
+		dev_dbg(&client->dev,
 			"%s: i2c write to address 0x%x failed\n",
 			__func__, address);
 		return ret;
@@ -223,6 +223,7 @@ static int bq20z75_get_battery_presence_and_health(
 			val->intval = 1;
 		else
 			val->intval = 0;
+		bq20z75_device->is_present = val->intval;
 		return ret;
 	}
 
@@ -232,18 +233,17 @@ static int bq20z75_get_battery_presence_and_health(
 	ret = bq20z75_write_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr,
 		MANUFACTURER_ACCESS_STATUS);
-	if (ret < 0)
-		return ret;
-
-
-	ret = bq20z75_read_word_data(client,
-		bq20z75_data[REG_MANUFACTURER_DATA].addr);
 	if (ret < 0) {
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
 			val->intval = 0; /* battery removed */
 		return ret;
 	}
 
+	ret = bq20z75_read_word_data(client,
+		bq20z75_data[REG_MANUFACTURER_DATA].addr);
+	if (ret < 0)
+		return ret;
+
 	if (ret < bq20z75_data[REG_MANUFACTURER_DATA].min_value ||
 	    ret > bq20z75_data[REG_MANUFACTURER_DATA].max_value) {
 		val->intval = 0;
@@ -455,6 +455,8 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_PRESENT:
 	case POWER_SUPPLY_PROP_HEALTH:
 		ret = bq20z75_get_battery_presence_and_health(client, psp, val);
+		if (psp == POWER_SUPPLY_PROP_PRESENT)
+			return 0;
 		break;
 
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
@@ -516,9 +518,16 @@ done:
 	}
 
 	dev_dbg(&client->dev,
-		"%s: property = %d, value = %d\n", __func__, psp, val->intval);
+		"%s: property = %d, value = %x\n", __func__, psp, val->intval);
+
+	if (ret && bq20z75_device->is_present)
+		return ret;
+
+	/* battery not present, so return NODATA for properties */
+	if (ret)
+		return -ENODATA;
 
-	return ret;
+	return 0;
 }
 
 static irqreturn_t bq20z75_irq(int irq, void *devid)
@@ -643,13 +652,14 @@ static int __devexit bq20z75_remove(struct i2c_client *client)
 static int bq20z75_suspend(struct i2c_client *client,
 	pm_message_t state)
 {
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
 	s32 ret;
 
 	/* write to manufacturer access with sleep command */
 	ret = bq20z75_write_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr,
 		MANUFACTURER_ACCESS_SLEEP);
-	if (ret < 0)
+	if (bq20z75_device->is_present && ret < 0)
 		return ret;
 
 	return 0;
-- 
1.7.0.4

