Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2CMMFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:05:08 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59895 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab2CMMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:33 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 19/20] Input: atmel_mxt_ts - remove mxt_make_highchg and parse T6 report
Date: Tue, 13 Mar 2012 20:04:22 +0800
Message-Id: <1331640263-18935-20-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function attempts to make the CHG pin high by reading a bunch of
messages until the device is happy.  Instead of just blindly trying to
read a fixed number of messages, let's actually read and process them.

It turns out that the messages after boot or nvupdates are T6 reports,
containing a status, and the config memory checksum.  So, let's parse
them and dump a useful info message.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   39 ++++++++++-------------------
 1 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index dafc030..c397a01 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -252,6 +252,7 @@ struct mxt_data {
 
 	/* Cached parameters from object table */
 	u16 T5_address;
+	u8 T6_reportid;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 	u16 T44_address;
@@ -591,8 +592,15 @@ static int mxt_proc_messages(struct mxt_data *data, u8 count)
 		mxt_dump_message(dev, msg);
 
 		if (msg->reportid >= data->T9_reportid_min &&
-		    msg->reportid <= data->T9_reportid_max)
+		    msg->reportid <= data->T9_reportid_max) {
 			mxt_input_touchevent(data, msg);
+		} else if (msg->reportid == data->T6_reportid) {
+			unsigned csum = msg->message[1] |
+					(msg->message[2] << 8) |
+					(msg->message[3] << 16);
+			dev_info(dev, "Status: %02x Config Checksum: %06x\n",
+				 msg->message[0], csum);
+		}
 	}
 
 	return 0;
@@ -657,28 +665,6 @@ static int mxt_check_reg_init(struct mxt_data *data)
 	return 0;
 }
 
-static int mxt_make_highchg(struct mxt_data *data)
-{
-	struct device *dev = &data->client->dev;
-	struct mxt_message message;
-	int count = 10;
-	int error;
-
-	/* Read dummy message to make high CHG pin */
-	do {
-		error = mxt_read_messages(data, 1, &message);
-		if (error)
-			return error;
-	} while (message.reportid != 0xff && --count);
-
-	if (!count) {
-		dev_err(dev, "CHG pin isn't cleared\n");
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 static void mxt_handle_pdata(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
@@ -770,6 +756,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_GEN_MESSAGE_T5:
 			data->T5_address = object->start_address;
 			break;
+		case MXT_GEN_COMMAND_T6:
+			data->T6_reportid = object->max_reportid;
+			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_max = object->max_reportid;
 			data->T9_reportid_min = data->T9_reportid_max -
@@ -1033,7 +1022,7 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 
 	enable_irq(data->irq);
 
-	error = mxt_make_highchg(data);
+	error = mxt_handle_messages(data);
 	if (error)
 		return error;
 
@@ -1155,7 +1144,7 @@ static int __devinit mxt_probe(struct i2c_client *client,
 		goto err_free_object;
 	}
 
-	error = mxt_make_highchg(data);
+	error = mxt_handle_messages(data);
 	if (error)
 		goto err_free_irq;
 
-- 
1.7.7.3

