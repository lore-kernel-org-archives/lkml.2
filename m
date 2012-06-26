Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2FZG5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:57:39 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34239 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab2FZG5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:22 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 18/21 v5] Input: atmel_mxt_ts - cache T9 reportid range when reading object table
Date: Tue, 26 Jun 2012 14:57:06 +0800
Message-Id: <1340693829-18665-19-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Streamline interrupt processing by caching the T9 reportid range when
first reading the object table.

In the process, refactor reading the object descriptor table.
First, since the object_table entries are now exactly the same layout
in device memory and in the driver, allocate an appropriately sized
array and fetch the entire table directly into it in a single i2c
transaction.  Since a 6 byte table object requires 10 bytes to read,
doing this dramatically reduces overhead.

Note: The cached T9 reportid's are initialized to 0, which is an invalid
reportid.  Thus, the checks in the interrupt handler will always fail for
devices that do not support the T9 object.  Therefore, after doing a
firmware update, the old object table is destroyed and all cached object
values are reset to 0, before reading the new object table, in case
the new firmware does not have the old objects.

This patch tested on an MXT224E.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   80 +++++++++++++++++-------------
 1 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 7b042e5..4da12a9 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -227,13 +227,10 @@ struct mxt_info {
 struct mxt_object {
 	u8 type;
 	u16 start_address;
-	u8 size;
-	u8 instances;
+	u8 size;		/* Size of each instance - 1 */
+	u8 instances;		/* Number of instances - 1 */
 	u8 num_report_ids;
-
-	/* to map object and message */
-	u8 max_reportid;
-};
+} __packed;
 
 struct mxt_message {
 	u8 reportid;
@@ -251,6 +248,10 @@ struct mxt_data {
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
+
+	/* Cached parameters from object table */
+	u8 T9_reportid_min;
+	u8 T9_reportid_max;
 };
 
 static bool mxt_object_readable(unsigned int type)
@@ -458,13 +459,6 @@ static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)
 	return __mxt_write_reg(client, reg, 1, &val);
 }
 
-static int mxt_read_object_table(struct i2c_client *client,
-				      u16 reg, u8 *object_buf)
-{
-	return __mxt_read_reg(client, reg, MXT_OBJECT_SIZE,
-				   object_buf);
-}
-
 static struct mxt_object *
 mxt_get_object(struct mxt_data *data, u8 type)
 {
@@ -563,7 +557,6 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 {
 	struct mxt_data *data = dev_id;
 	struct mxt_message message;
-	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
 	int id;
 	u8 reportid;
@@ -578,13 +571,8 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 
 		reportid = message.reportid;
 
-		/* whether reportid is thing of MXT_TOUCH_MULTI_T9 */
-		object = mxt_get_object(data, MXT_TOUCH_MULTI_T9);
-		if (!object)
-			goto end;
-
-		max_reportid = object->max_reportid;
-		min_reportid = max_reportid - object->num_report_ids + 1;
+		max_reportid = data->T9_reportid_max;
+		min_reportid = data->T9_reportid_min;
 		id = reportid - min_reportid;
 
 		if (reportid >= min_reportid && reportid <= max_reportid)
@@ -719,30 +707,49 @@ static int mxt_get_info(struct mxt_data *data)
 
 static int mxt_get_object_table(struct mxt_data *data)
 {
+	struct i2c_client *client = data->client;
+	size_t table_size;
 	int error;
 	int i;
-	u16 reg;
-	u8 reportid = 0;
-	u8 buf[MXT_OBJECT_SIZE];
+	u8 reportid;
 
+	table_size = data->info.object_num * sizeof(struct mxt_object);
+	error = __mxt_read_reg(client, MXT_OBJECT_START, table_size,
+			data->object_table);
+	if (error) {
+		kfree(data->object_table);
+		data->object_table = NULL;
+		return error;
+	}
+
+	/* Valid Report IDs start counting from 1 */
+	reportid = 1;
 	for (i = 0; i < data->info.object_num; i++) {
 		struct mxt_object *object = data->object_table + i;
+		u8 min_id, max_id;
 
-		reg = MXT_OBJECT_START + MXT_OBJECT_SIZE * i;
-		error = mxt_read_object_table(data->client, reg, buf);
-		if (error)
-			return error;
-
-		object->type = buf[0];
-		object->start_address = (buf[2] << 8) | buf[1];
-		object->size = buf[3];
-		object->instances = buf[4];
-		object->num_report_ids = buf[5];
+		le16_to_cpus(&object->start_address);
 
 		if (object->num_report_ids) {
+			min_id = reportid;
 			reportid += object->num_report_ids *
 					(object->instances + 1);
-			object->max_reportid = reportid;
+			max_id = reportid - 1;
+		} else {
+			min_id = 0;
+			max_id = 0;
+		}
+
+		dev_info(&data->client->dev,
+			 "Type %2d Start %3d Size %3d Instances %2d ReportIDs %3u : %3u\n",
+			 object->type, object->start_address, object->size + 1,
+			 object->instances + 1, min_id, max_id);
+
+		switch (object->type) {
+		case MXT_TOUCH_MULTI_T9:
+			data->T9_reportid_min = min_id;
+			data->T9_reportid_max = max_id;
+			break;
 		}
 	}
 
@@ -995,8 +1002,11 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		/* Wait for reset */
 		msleep(MXT_FWRESET_TIME);
 
+		/* Destroy old object table and any cached fields */
 		kfree(data->object_table);
 		data->object_table = NULL;
+		data->T9_reportid_min = 0;
+		data->T9_reportid_max = 0;
 
 		mxt_initialize(data);
 	}
-- 
1.7.7.3

