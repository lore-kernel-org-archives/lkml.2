Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab2CMMME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:12:04 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44751 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2CMML7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:11:59 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 20/20] Input: atmel_mxt_ts - send all MT-B slots in one input report
Date: Tue, 13 Mar 2012 20:04:23 +0800
Message-Id: <1331640263-18935-21-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each interrupt contains information for all contacts with changing
properties.  Process all of this information at once, and send it all in a
a single input report (ie input events ending in EV_SYN/SYN_REPORT).

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c397a01..dae8318 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -516,8 +516,7 @@ static int mxt_read_messages(struct mxt_data *data, u8 count,
 			    sizeof(struct mxt_message) * count, messages);
 }
 
-static void mxt_input_touchevent(struct mxt_data *data,
-				 struct mxt_message *message)
+static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
 {
 	struct device *dev = &data->client->dev;
 	struct input_dev *input_dev = data->input_dev;
@@ -571,9 +570,6 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
 		/* TODO: Use vector to report ORIENTATION & TOUCH_MINOR */
 	}
-
-	input_mt_report_pointer_emulation(input_dev, false);
-	input_sync(input_dev);
 }
 
 static int mxt_proc_messages(struct mxt_data *data, u8 count)
@@ -581,6 +577,7 @@ static int mxt_proc_messages(struct mxt_data *data, u8 count)
 	struct device *dev = &data->client->dev;
 	struct mxt_message messages[count], *msg;
 	int ret;
+	bool update_input;
 
 	ret = mxt_read_messages(data, count, messages);
 	if (ret) {
@@ -588,12 +585,14 @@ static int mxt_proc_messages(struct mxt_data *data, u8 count)
 		return ret;
 	}
 
+	update_input = false;
 	for (msg = messages; msg < &messages[count]; msg++) {
 		mxt_dump_message(dev, msg);
 
 		if (msg->reportid >= data->T9_reportid_min &&
 		    msg->reportid <= data->T9_reportid_max) {
-			mxt_input_touchevent(data, msg);
+			mxt_input_touch(data, msg);
+			update_input = true;
 		} else if (msg->reportid == data->T6_reportid) {
 			unsigned csum = msg->message[1] |
 					(msg->message[2] << 8) |
@@ -603,6 +602,11 @@ static int mxt_proc_messages(struct mxt_data *data, u8 count)
 		}
 	}
 
+	if (update_input) {
+		input_mt_report_pointer_emulation(data->input_dev, false);
+		input_sync(data->input_dev);
+	}
+
 	return 0;
 }
 
-- 
1.7.7.3

