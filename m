Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2DRNXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:23:24 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:47450 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2DRNWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:22:05 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 11/14 v3] Input: atmel_mxt_ts - cache T9 reportid range when reading object table
Date: Wed, 18 Apr 2012 21:21:56 +0800
Message-Id: <1334755319-21365-12-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Streamline interrupt processing by caching the T9 reportid range when
first reading the object table.

In the process, refactor reading the object descriptor table.
First,  since the object_table entries are now exactly the same layout
in device memory and in the driver, allocate an appropriately sized
array and fetch the entire table directly into it in a single i2c
transaction.  Since a 6 byte table object requires 10 bytes to read,
doing this dramatically reduces overhead.

Note: The cached T9 reportid's are initialized to 0, which is an invalid
reportid.  Thus, the checks in the interrupt handler will always fail for
devices that do not support the T9 object.

One side effect of this is we can know the max number of contacts that
can be tracked, and therefore can properly report max number of MT-B slots
to userspace instead of assuming a fixed 10.

This patch tested on an MXT224E.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  129 +++++++++++++++---------------
 1 files changed, 63 insertions(+), 66 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bac20ec..77ea917 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -212,8 +212,6 @@
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
-#define MXT_MAX_FINGER		10
-
 struct mxt_info {
 	u8 family_id;
 	u8 variant_id;
@@ -227,12 +225,9 @@ struct mxt_info {
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
 };
 
 struct mxt_message {
@@ -250,6 +245,10 @@ struct mxt_data {
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
+
+	/* Cached parameters from object table */
+	u8 T9_reportid_min;
+	u8 T9_reportid_max;
 };
 
 static bool mxt_object_readable(unsigned int type)
@@ -444,14 +443,7 @@ static int mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
 	return (ret == count) ? 0 : ret;
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
@@ -495,8 +487,7 @@ static int mxt_write_object(struct mxt_data *data,
 	return mxt_write_reg(data->client, reg + offset, 1, &val);
 }
 
-static void mxt_input_touchevent(struct mxt_data *data,
-				 struct mxt_message *message, int id)
+static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
 {
 	struct device *dev = &data->client->dev;
 	struct input_dev *input_dev = data->input_dev;
@@ -505,6 +496,9 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int y;
 	int area;
 	int amplitude;
+	int id;
+
+	id = message->reportid - data->T9_reportid_min;
 
 	status = message->message[0];
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
@@ -549,12 +543,7 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 {
 	struct mxt_data *data = dev_id;
 	struct mxt_message message;
-	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
-	int id;
-	u8 reportid;
-	u8 max_reportid;
-	u8 min_reportid;
 
 	do {
 		if (mxt_read_message(data, &message)) {
@@ -562,22 +551,13 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 			goto end;
 		}
 
-		reportid = message.reportid;
-
-		/* whether reportid is thing of MXT_TOUCH_MULTI_T9 */
-		object = mxt_get_object(data, MXT_TOUCH_MULTI_T9);
-		if (!object)
-			goto end;
-
-		max_reportid = object->max_reportid;
-		min_reportid = max_reportid - object->num_report_ids + 1;
-		id = reportid - min_reportid;
-
-		if (reportid >= min_reportid && reportid <= max_reportid)
-			mxt_input_touchevent(data, &message, id);
-		else
+		if (message.reportid >= data->T9_reportid_min &&
+		    message.reportid <= data->T9_reportid_max) {
+			mxt_input_touch(data, &message);
+		} else {
 			mxt_dump_message(dev, &message);
-	} while (reportid != 0xff);
+		}
+	} while (message.reportid != 0xff);
 
 end:
 	return IRQ_HANDLED;
@@ -690,30 +670,57 @@ static void mxt_handle_pdata(struct mxt_data *data)
 
 static int mxt_get_object_table(struct mxt_data *data)
 {
+	struct i2c_client *client = data->client;
+	struct device *dev = &client->dev;
 	int error;
 	int i;
-	u16 reg;
-	u8 reportid = 0;
-	u8 buf[MXT_OBJECT_SIZE];
+	u8 reportid;
+	size_t table_size;
+
+	/* Initialized cached object fields to 0 */
+	data->T9_reportid_min = 0;
+	data->T9_reportid_max = 0;
+
+	/* Free old object table, if there was one. */
+	table_size = data->info.object_num * sizeof(struct mxt_object);
+	data->object_table = krealloc(data->object_table, table_size,
+				      GFP_KERNEL);
+	if (!data->object_table) {
+		dev_err(dev, "Failed to allocate object table\n");
+		return -ENOMEM;
+	}
 
+	error = mxt_read_reg(client, MXT_OBJECT_START, table_size,
+			     data->object_table);
+	if (error) {
+		kfree(data->object_table);
+		data->object_table = NULL;
+		return error;
+	}
+
+	/* Valid Report IDs start counting from 1 */
+	reportid = 1;
 	for (i = 0; i < data->info.object_num; i++) {
-		struct mxt_object *object = data->object_table + i;
+		struct mxt_object *object = &data->object_table[i];
+		u8 num_ids, min_id, max_id;
 
-		reg = MXT_OBJECT_START + MXT_OBJECT_SIZE * i;
-		error = mxt_read_object_table(data->client, reg, buf);
-		if (error)
-			return error;
+		le16_to_cpus(&object->start_address);
+
+		num_ids = object->num_report_ids * (object->instances + 1);
+		min_id = num_ids ? reportid : 0;
+		max_id = num_ids ? reportid + num_ids - 1 : 0;
+		reportid += num_ids;
 
-		object->type = buf[0];
-		object->start_address = (buf[2] << 8) | buf[1];
-		object->size = buf[3];
-		object->instances = buf[4];
-		object->num_report_ids = buf[5];
+		dev_info(dev,
+			 "Type %2d Start %3d Size %3d Instances %2d ReportIDs %3u : %3u\n",
+			 object->type, object->start_address, object->size + 1,
+			 object->instances + 1, min_id, max_id);
 
-		if (object->num_report_ids) {
-			reportid += object->num_report_ids *
-					(object->instances + 1);
-			object->max_reportid = reportid;
+		switch (object->type) {
+		case MXT_TOUCH_MULTI_T9:
+			data->T9_reportid_min = min_id;
+			data->T9_reportid_max = max_id;
+			break;
 		}
 	}
 
@@ -732,14 +739,6 @@ static int mxt_initialize(struct mxt_data *data)
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
@@ -926,9 +925,6 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		/* Wait for reset */
 		msleep(MXT_FWRESET_TIME);
 
-		kfree(data->object_table);
-		data->object_table = NULL;
-
 		mxt_initialize(data);
 	}
 
@@ -1029,7 +1025,8 @@ static int __devinit mxt_probe(struct i2c_client *client,
 			     0, 255, 0, 0);
 
 	/* For multi touch */
-	input_mt_init_slots(input_dev, MXT_MAX_FINGER);
+	input_mt_init_slots(input_dev,
+			    data->T9_reportid_max - data->T9_reportid_min + 1);
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			     0, MXT_MAX_AREA, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
-- 
1.7.7.3

