Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1CABAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 20:00:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4218 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1CABAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 20:00:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Mon, 28 Feb 2011 17:00:03 -0800
From: rklein@nvidia.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/4] power: bq20z75: add i2c retry mechanism
Date: Mon, 28 Feb 2011 16:55:29 -0800
Message-Id: <1298940931-17552-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
References: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

With the support of platform data, now adding support for option i2c retries
on read/write failures. Ths is specified through the optional platform data.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c       |   37 +++++++++++++++++++++++++++++++------
 include/linux/power/bq20z75.h |    2 ++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index a51e98d..e82d10e 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -156,30 +156,55 @@ struct bq20z75_info {
 
 static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
 {
-	s32 ret;
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	s32 ret = 0;
+	int retries = 1;
+
+	if (bq20z75_device->pdata)
+		retries = max(bq20z75_device->pdata->i2c_retry_count + 1, 1);
+
+	while (retries > 0) {
+		ret = i2c_smbus_read_word_data(client, address);
+		if (ret >= 0)
+			break;
+		retries--;
+	}
 
-	ret = i2c_smbus_read_word_data(client, address);
 	if (ret < 0) {
-		dev_err(&client->dev,
+		dev_warn(&client->dev,
 			"%s: i2c read at address 0x%x failed\n",
 			__func__, address);
 		return ret;
 	}
+
 	return le16_to_cpu(ret);
 }
 
 static int bq20z75_write_word_data(struct i2c_client *client, u8 address,
 	u16 value)
 {
-	s32 ret;
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	s32 ret = 0;
+	int retries = 1;
+
+	if (bq20z75_device->pdata)
+		retries = max(bq20z75_device->pdata->i2c_retry_count + 1, 1);
+
+	while (retries > 0) {
+		ret = i2c_smbus_write_word_data(client, address,
+			le16_to_cpu(value));
+		if (ret >= 0)
+			break;
+		retries--;
+	}
 
-	ret = i2c_smbus_write_word_data(client, address, le16_to_cpu(value));
 	if (ret < 0) {
-		dev_err(&client->dev,
+		dev_warn(&client->dev,
 			"%s: i2c write to address 0x%x failed\n",
 			__func__, address);
 		return ret;
 	}
+
 	return 0;
 }
 
diff --git a/include/linux/power/bq20z75.h b/include/linux/power/bq20z75.h
index 0e1b8a2..b0843b6 100644
--- a/include/linux/power/bq20z75.h
+++ b/include/linux/power/bq20z75.h
@@ -28,10 +28,12 @@
  * struct bq20z75_platform_data - platform data for bq20z75 devices
  * @battery_detect:		GPIO which is used to detect battery presence
  * @battery_detect_present:	gpio state when battery is present (0 / 1)
+ * @i2c_retry_count:		# of times to retry on i2c IO failure
  */
 struct bq20z75_platform_data {
 	int battery_detect;
 	int battery_detect_present;
+	int i2c_retry_count;
 };
 
 #endif
-- 
1.7.0.4

