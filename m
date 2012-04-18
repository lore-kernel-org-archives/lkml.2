Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2DRNYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:24:39 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51518 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2DRNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:22:03 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 03/14 v3] Input: atmel_mxt_ts - refactor mxt_read/write_reg to take a length
Date: Wed, 18 Apr 2012 21:21:48 +0800
Message-Id: <1334755319-21365-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c bus requires 5 bytes to do a 1 byte read (1-byte i2c address + 2
byte offset + 1-byte i2c address + 1 byte data), or 4 bytes to do a
1-byte write (1 byte i2c address + 2 byte offset + 1 byte data).

By taking a length with reads and writes, the driver can amortize
transaction overhead by performing larger transactions where appropriate.

This patch just sets up the new API.  Later patches refactor reads/writes
to take advantage of the larger transactions.

These functions are also now return any errors reported by the i2c layer.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   72 +++++++++++++++++-------------
 1 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 15ae6fd..517bb96 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -397,11 +397,11 @@ static int mxt_fw_write(struct i2c_client *client,
 	return 0;
 }
 
-static int __mxt_read_reg(struct i2c_client *client,
-			       u16 reg, u16 len, void *val)
+static int mxt_read_reg(struct i2c_client *client, u16 reg, u16 len, void *val)
 {
 	struct i2c_msg xfer[2];
 	u8 buf[2];
+	int ret;
 
 	buf[0] = reg & 0xff;
 	buf[1] = (reg >> 8) & 0xff;
@@ -418,40 +418,50 @@ static int __mxt_read_reg(struct i2c_client *client,
 	xfer[1].len = len;
 	xfer[1].buf = val;
 
-	if (i2c_transfer(client->adapter, xfer, 2) != 2) {
-		dev_err(&client->dev, "%s: i2c transfer failed\n", __func__);
-		return -EIO;
+	ret = i2c_transfer(client->adapter, xfer, 2);
+	if (ret != 2) {
+		dev_err(&client->dev, "i2c read reg failed (%d)\n", ret);
+		if (ret >= 0)
+			ret = -EIO;
 	}
 
-	return 0;
+	return (ret == 2) ? 0 : ret;
 }
 
-static int mxt_read_reg(struct i2c_client *client, u16 reg, u8 *val)
+static int mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
+			 const void *val)
 {
-	return __mxt_read_reg(client, reg, 1, val);
-}
+	size_t count = 2 + len;		/* + 2-byte offset */
+	u8 *buf;
+	int ret;
 
-static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)
-{
-	u8 buf[3];
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	buf[0] = reg & 0xff;
 	buf[1] = (reg >> 8) & 0xff;
-	buf[2] = val;
-
-	if (i2c_master_send(client, buf, 3) != 3) {
-		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
-		return -EIO;
+	memcpy(&buf[2], val, len);
+
+	/*
+	 * i2c_master_send returns number of bytes written,
+	 * but we return 0 on success, iff all bytes were written.
+	 */
+	ret = i2c_master_send(client, buf, count);
+	if (ret != count) {
+		dev_err(&client->dev, "i2c write reg failed (%d)\n", ret);
+		if (ret >= 0)
+			ret = -EIO;
 	}
 
-	return 0;
+	kfree(buf);
+	return (ret == count) ? 0 : ret;
 }
 
 static int mxt_read_object_table(struct i2c_client *client,
 				      u16 reg, u8 *object_buf)
 {
-	return __mxt_read_reg(client, reg, MXT_OBJECT_SIZE,
-				   object_buf);
+	return mxt_read_reg(client, reg, MXT_OBJECT_SIZE, object_buf);
 }
 
 static struct mxt_object *
@@ -481,8 +491,8 @@ static int mxt_read_message(struct mxt_data *data,
 		return -EINVAL;
 
 	reg = object->start_address;
-	return __mxt_read_reg(data->client, reg,
-			sizeof(struct mxt_message), message);
+	return mxt_read_reg(data->client, reg, sizeof(struct mxt_message),
+			    message);
 }
 
 static int mxt_read_object(struct mxt_data *data,
@@ -496,7 +506,7 @@ static int mxt_read_object(struct mxt_data *data,
 		return -EINVAL;
 
 	reg = object->start_address;
-	return __mxt_read_reg(data->client, reg + offset, 1, val);
+	return mxt_read_reg(data->client, reg + offset, 1, val);
 }
 
 static int mxt_write_object(struct mxt_data *data,
@@ -510,7 +520,7 @@ static int mxt_write_object(struct mxt_data *data,
 		return -EINVAL;
 
 	reg = object->start_address;
-	return mxt_write_reg(data->client, reg + offset, val);
+	return mxt_write_reg(data->client, reg + offset, 1, &val);
 }
 
 static void mxt_input_report(struct mxt_data *data, int single_id)
@@ -757,27 +767,27 @@ static int mxt_get_info(struct mxt_data *data)
 	int error;
 	u8 val;
 
-	error = mxt_read_reg(client, MXT_FAMILY_ID, &val);
+	error = mxt_read_reg(client, MXT_FAMILY_ID, 1, &val);
 	if (error)
 		return error;
 	info->family_id = val;
 
-	error = mxt_read_reg(client, MXT_VARIANT_ID, &val);
+	error = mxt_read_reg(client, MXT_VARIANT_ID, 1, &val);
 	if (error)
 		return error;
 	info->variant_id = val;
 
-	error = mxt_read_reg(client, MXT_VERSION, &val);
+	error = mxt_read_reg(client, MXT_VERSION, 1, &val);
 	if (error)
 		return error;
 	info->version = val;
 
-	error = mxt_read_reg(client, MXT_BUILD, &val);
+	error = mxt_read_reg(client, MXT_BUILD, 1, &val);
 	if (error)
 		return error;
 	info->build = val;
 
-	error = mxt_read_reg(client, MXT_OBJECT_NUM, &val);
+	error = mxt_read_reg(client, MXT_OBJECT_NUM, 1, &val);
 	if (error)
 		return error;
 	info->object_num = val;
@@ -860,12 +870,12 @@ static int mxt_initialize(struct mxt_data *data)
 	msleep(MXT_RESET_TIME);
 
 	/* Update matrix size at info struct */
-	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
+	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, 1, &val);
 	if (error)
 		return error;
 	info->matrix_xsize = val;
 
-	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, &val);
+	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, 1, &val);
 	if (error)
 		return error;
 	info->matrix_ysize = val;
-- 
1.7.7.3

