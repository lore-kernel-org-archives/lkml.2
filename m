Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2C2Qvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:51:55 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34330 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759885Ab2C2Qtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:49:32 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 13/16 v2] Input: atmel_mxt_ts - cache T9 reportid range when reading object table
Date: Fri, 30 Mar 2012 00:49:23 +0800
Message-Id: <1333039766-8617-14-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Streamline interrupt processing by caching the T9 reportid range when
first reading the object table.

Note: the cached T9 reportid's are initialized to 0, which is an invalid
reportid.  Thus, the checks in the interrupt handler will always fail for
devices that do not support the T9 object.

One side effect of this is we can know the max number of contacts that
can be tracked, and therefore can properly report max number of MT-B slots
to userspace instead of assuming a fixed 10.

This patch tested on an MXT224E.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   67 +++++++++++++++--------------
 1 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 731293b..40dd3e6 100644
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
@@ -230,9 +228,6 @@ struct mxt_object {
 	u16 size;
 	u16 instances;
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
@@ -480,8 +479,7 @@ static int mxt_write_object(struct mxt_data *data,
 	return mxt_write_reg(data->client, reg + offset, 1, &val);
 }
 
-static void mxt_input_touchevent(struct mxt_data *data,
-				 struct mxt_message *message, int id)
+static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
 {
 	struct device *dev = &data->client->dev;
 	struct input_dev *input_dev = data->input_dev;
@@ -490,6 +488,9 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int y;
 	int area;
 	int amplitude;
+	int id;
+
+	id = message->reportid - data->T9_reportid_min;
 
 	status = message->message[0];
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
@@ -534,12 +535,7 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
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
@@ -547,22 +543,13 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
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
@@ -679,7 +666,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 	struct device *dev = &client->dev;
 	int error;
 	int i;
-	u8 reportid = 0;
+	u8 reportid;
 	u8 *buf;
 	size_t buf_size;
 
@@ -701,9 +688,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 	if (error)
 		goto done;
 
+	/* Valid Report IDs start counting from 1 */
+	reportid = 1;
 	for (i = 0; i < data->info.object_num; i++) {
 		struct mxt_object *object = &data->object_table[i];
 		u8 *obj_buf = &buf[i * MXT_OBJECT_SIZE];
+		u8 num_ids, min_id, max_id;
 
 		object->type = obj_buf[0];
 		object->start_address = (obj_buf[2] << 8) | obj_buf[1];
@@ -711,9 +701,21 @@ static int mxt_get_object_table(struct mxt_data *data)
 		object->instances = obj_buf[4] + 1;
 		object->num_report_ids = obj_buf[5];
 
-		if (object->num_report_ids) {
-			reportid += object->num_report_ids * object->instances;
-			object->max_reportid = reportid;
+		num_ids = object->num_report_ids * object->instances;
+		min_id = num_ids ? reportid : 0;
+		max_id = num_ids ? reportid + num_ids - 1 : 0;
+		reportid += num_ids;
+
+		dev_info(dev,
+			 "Type %2d Start %3d Size %3d Instances %2d ReportIDs %3u : %3u\n",
+			 object->type, object->start_address, object->size,
+			 object->instances, min_id, max_id);
+
+		switch (object->type) {
+		case MXT_TOUCH_MULTI_T9:
+			data->T9_reportid_min = min_id;
+			data->T9_reportid_max = max_id;
+			break;
 		}
 	}
 
@@ -1023,7 +1025,8 @@ static int __devinit mxt_probe(struct i2c_client *client,
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

