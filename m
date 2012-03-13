Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2CMMIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:08:31 -0400
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57209 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2CMMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 14/20] Input: atmel_mxt_ts - refactor reading object table
Date: Tue, 13 Mar 2012 20:04:17 +0800
Message-Id: <1331640263-18935-15-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reading each object separately, fetch the whole table in one
large i2c transaction.  A 6 byte table object requires 10 bytes to read,
so doing this dramatically reduces overhead.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   50 ++++++++++++-----------------
 1 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e05540d..9e1ce03 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -460,14 +460,7 @@ static int mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
 	return 0;
 }
 
-static int mxt_read_object_table(struct i2c_client *client,
-				      u16 reg, u8 *object_buf)
-{
-	return mxt_read_reg(client, reg, MXT_OBJECT_SIZE, object_buf);
-}
-
-static struct mxt_object *
-mxt_get_object(struct mxt_data *data, u8 type)
+static struct mxt_object *mxt_get_object(struct mxt_data *data, u8 type)
 {
 	struct mxt_object *object;
 	int i;
@@ -755,25 +748,32 @@ static int mxt_get_info(struct mxt_data *data)
 
 static int mxt_get_object_table(struct mxt_data *data)
 {
+	struct i2c_client *client = data->client;
+	struct device *dev = &client->dev;
 	int error;
 	int i;
-	u16 reg;
 	u8 reportid = 0;
-	u8 buf[MXT_OBJECT_SIZE];
+	u8 buf[data->info.object_num][MXT_OBJECT_SIZE];
 
-	for (i = 0; i < data->info.object_num; i++) {
-		struct mxt_object *object = data->object_table + i;
+	data->object_table = kcalloc(data->info.object_num,
+				     sizeof(struct mxt_object), GFP_KERNEL);
+	if (!data->object_table) {
+		dev_err(dev, "Failed to allocate object table\n");
+		return -ENOMEM;
+	}
 
-		reg = MXT_OBJECT_START + MXT_OBJECT_SIZE * i;
-		error = mxt_read_object_table(data->client, reg, buf);
-		if (error)
-			return error;
+	error = mxt_read_reg(client, MXT_OBJECT_START, sizeof(buf), buf);
+	if (error)
+		return error;
+
+	for (i = 0; i < data->info.object_num; i++) {
+		struct mxt_object *object = &data->object_table[i];
 
-		object->type = buf[0];
-		object->start_address = (buf[2] << 8) | buf[1];
-		object->size = buf[3] + 1;
-		object->instances = buf[4] + 1;
-		object->num_report_ids = buf[5];
+		object->type = buf[i][0];
+		object->start_address = (buf[i][2] << 8) | buf[i][1];
+		object->size = buf[i][3] + 1;
+		object->instances = buf[i][4] + 1;
+		object->num_report_ids = buf[i][5];
 
 		if (object->num_report_ids) {
 			reportid += object->num_report_ids * object->instances;
@@ -795,14 +795,6 @@ static int mxt_initialize(struct mxt_data *data)
 	if (error)
 		return error;
 
-	data->object_table = kcalloc(info->object_num,
-				     sizeof(struct mxt_object),
-				     GFP_KERNEL);
-	if (!data->object_table) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
-		return -ENOMEM;
-	}
-
 	/* Get object table information */
 	error = mxt_get_object_table(data);
 	if (error)
-- 
1.7.7.3

