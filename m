Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2CMMGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:06:07 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42616 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2CMMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:32 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 17/20] Input: atmel_mxt_ts - use cached T9 reportid range in isr
Date: Tue, 13 Mar 2012 20:04:20 +0800
Message-Id: <1331640263-18935-18-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Streamline interrupt processing by caching the T9 reportid range when
first initializing the object table.

Note: the cached T9 reportid's are initialized to 0, which is an invalid
reportid.  Thus, the checks in the interrupt handler will always fail
for devices that do not support the T9 object.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   45 ++++++++++++++++-------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 1a9ed26..88a474e 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -249,6 +249,10 @@ struct mxt_data {
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
+
+	/* Cached parameters from object table */
+	u8 T9_reportid_min;
+	u8 T9_reportid_max;
 };
 
 static bool mxt_object_readable(unsigned int type)
@@ -512,7 +516,7 @@ static int mxt_write_object(struct mxt_data *data,
 }
 
 static void mxt_input_touchevent(struct mxt_data *data,
-				 struct mxt_message *message, int id)
+				 struct mxt_message *message)
 {
 	struct device *dev = &data->client->dev;
 	struct input_dev *input_dev = data->input_dev;
@@ -522,6 +526,9 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int area;
 	int amplitude;
 	int vector1, vector2;
+	int id;
+
+	id = message->reportid - data->T9_reportid_min;
 
 	status = message->message[0];
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
@@ -572,12 +579,7 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
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
@@ -585,22 +587,12 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
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
+		if (message.reportid >= data->T9_reportid_min &&
+		    message.reportid <= data->T9_reportid_max)
+			mxt_input_touchevent(data, &message);
 		else
 			mxt_dump_message(dev, &message);
-	} while (reportid != 0xff);
+	} while (message.reportid != 0xff);
 
 end:
 	return IRQ_HANDLED;
@@ -744,6 +736,19 @@ static int mxt_get_object_table(struct mxt_data *data)
 			reportid += object->num_report_ids * object->instances;
 			object->max_reportid = reportid;
 		}
+
+		dev_info(dev, "Type %2d Start %3d Size %3d Max ReportID %3d Instances %2d\n",
+			 object->type, object->start_address, object->size,
+			 object->max_reportid, object->instances);
+
+		/* Save data for objects used when processing interrupts */
+		switch (object->type) {
+		case MXT_TOUCH_MULTI_T9:
+			data->T9_reportid_max = object->max_reportid;
+			data->T9_reportid_min = data->T9_reportid_max -
+						object->num_report_ids + 1;
+			break;
+		}
 	}
 
 	return 0;
-- 
1.7.7.3

