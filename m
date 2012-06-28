Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2F1NKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:10:13 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51907 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2F1NIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 18/23 v6] Input: atmel_mxt_ts - refactor when and how object table is freed
Date: Thu, 28 Jun 2012 21:08:19 +0800
Message-Id: <1340888904-15620-19-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Object Table is freed in three cases:
  1) When the driver is being removed.
  2) In the error path of mxt_initialize().
  3) Just after a firmware update, when a new object table is
     about to be read.

For cases 2 & 3, the driver is not immediately unloaded, so this patch
refactors these cases to use a common cleanup function.  It also refactors
the mxt_initialize error paths to ensure that this cleanup happens.

Note: mxt_update_fw_store() does not handle errors during mxt_initialize().
A proposed fix for this is in a subsequent patchset.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d6b64a0f..488e3e8 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -750,6 +750,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 	return 0;
 }
 
+static void mxt_free_object_table(struct mxt_data *data)
+{
+	kfree(data->object_table);
+	data->object_table = NULL;
+}
+
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -772,12 +778,12 @@ static int mxt_initialize(struct mxt_data *data)
 	/* Get object table information */
 	error = mxt_get_object_table(data);
 	if (error)
-		return error;
+		goto err_free_object_table;
 
 	/* Check register init values */
 	error = mxt_check_reg_init(data);
 	if (error)
-		return error;
+		goto err_free_object_table;
 
 	mxt_handle_pdata(data);
 
@@ -795,12 +801,12 @@ static int mxt_initialize(struct mxt_data *data)
 	/* Update matrix size at info struct */
 	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
 	if (error)
-		return error;
+		goto err_free_object_table;
 	info->matrix_xsize = val;
 
 	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, &val);
 	if (error)
-		return error;
+		goto err_free_object_table;
 	info->matrix_ysize = val;
 
 	dev_info(&client->dev,
@@ -814,6 +820,10 @@ static int mxt_initialize(struct mxt_data *data)
 			info->object_num);
 
 	return 0;
+
+err_free_object_table:
+	mxt_free_object_table(data);
+	return error;
 }
 
 static void mxt_calc_resolution(struct mxt_data *data)
@@ -1000,8 +1010,7 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		/* Wait for reset */
 		msleep(MXT_FWRESET_TIME);
 
-		kfree(data->object_table);
-		data->object_table = NULL;
+		mxt_free_object_table(data);
 
 		mxt_initialize(data);
 	}
@@ -1128,7 +1137,7 @@ static int __devinit mxt_probe(struct i2c_client *client,
 
 	error = mxt_initialize(data);
 	if (error)
-		goto err_free_object;
+		goto err_free_mem;
 
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
 			pdata->irqflags, client->name, data);
-- 
1.7.7.3

