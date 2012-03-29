Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab2C2QuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:50:21 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:54734 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871Ab2C2Qtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:49:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 10/16 v2] Input: atmel_mxt_ts - refactor get info
Date: Fri, 30 Mar 2012 00:49:20 +0800
Message-Id: <1333039766-8617-11-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read whole info block in one i2c transaction.
And then re-read the matrix size after applying pdata config, since
it may have changed.
Note, however, that the matrix x & y size are just displayed for
information purposes.  They aren't actually used by the driver itself.

Also, parse and info print the firmware major and minor version numbers.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   65 +++++------------------------
 1 files changed, 12 insertions(+), 53 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 3abc5b0..9d88faf 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -36,6 +36,7 @@
 #define MXT_FW_NAME		"maxtouch.fw"
 
 /* Registers */
+#define MXT_INFO		0x00
 #define MXT_FAMILY_ID		0x00
 #define MXT_VARIANT_ID		0x01
 #define MXT_VERSION		0x02
@@ -730,41 +731,6 @@ static void mxt_handle_pdata(struct mxt_data *data)
 	}
 }
 
-static int mxt_get_info(struct mxt_data *data)
-{
-	struct i2c_client *client = data->client;
-	struct mxt_info *info = &data->info;
-	int error;
-	u8 val;
-
-	error = mxt_read_reg(client, MXT_FAMILY_ID, 1, &val);
-	if (error)
-		return error;
-	info->family_id = val;
-
-	error = mxt_read_reg(client, MXT_VARIANT_ID, 1, &val);
-	if (error)
-		return error;
-	info->variant_id = val;
-
-	error = mxt_read_reg(client, MXT_VERSION, 1, &val);
-	if (error)
-		return error;
-	info->version = val;
-
-	error = mxt_read_reg(client, MXT_BUILD, 1, &val);
-	if (error)
-		return error;
-	info->build = val;
-
-	error = mxt_read_reg(client, MXT_OBJECT_NUM, 1, &val);
-	if (error)
-		return error;
-	info->object_num = val;
-
-	return 0;
-}
-
 static int mxt_get_object_table(struct mxt_data *data)
 {
 	int error;
@@ -799,11 +765,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
+	struct device *dev = &client->dev;
 	struct mxt_info *info = &data->info;
 	int error;
-	u8 val;
 
-	error = mxt_get_info(data);
+	/* Read 7-byte info block starting at address 0 */
+	error = mxt_read_reg(client, MXT_INFO, sizeof(*info), info);
 	if (error)
 		return error;
 
@@ -838,26 +805,18 @@ static int mxt_initialize(struct mxt_data *data)
 			MXT_COMMAND_RESET, 1);
 	msleep(MXT_RESET_TIME);
 
-	/* Update matrix size at info struct */
-	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, 1, &val);
-	if (error)
-		return error;
-	info->matrix_xsize = val;
-
-	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, 1, &val);
+	/* Update matrix size, since it may have been modified by pdata */
+	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, 2,
+			     &info->matrix_xsize);
 	if (error)
 		return error;
-	info->matrix_ysize = val;
 
-	dev_info(&client->dev,
-			"Family ID: %d Variant ID: %d Version: %d Build: %d\n",
-			info->family_id, info->variant_id, info->version,
-			info->build);
+	dev_info(dev, "Family ID: %d Variant ID: %d Major.Minor.Build: %d.%d.%d\n",
+		 info->family_id, info->variant_id, info->version >> 4,
+		 info->version & 0xf, info->build);
 
-	dev_info(&client->dev,
-			"Matrix X Size: %d Matrix Y Size: %d Object Num: %d\n",
-			info->matrix_xsize, info->matrix_ysize,
-			info->object_num);
+	dev_info(dev, "Matrix X Size: %d Matrix Y Size: %d Object Num: %d\n",
+		 info->matrix_xsize, info->matrix_ysize, info->object_num);
 
 	return 0;
 }
-- 
1.7.7.3

