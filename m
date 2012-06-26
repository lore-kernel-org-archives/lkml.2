Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab2FZG6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:58:13 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62288 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab2FZG5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:21 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 21/21 v5] Input: atmel_mxt_ts - parse T6 reports
Date: Tue, 26 Jun 2012 14:57:09 +0800
Message-Id: <1340693829-18665-22-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The normal messages sent after boot or NVRAM update are T6 reports,
containing a status, and the config memory checksum.  Parse them and dump
a useful info message.

This patch tested on an MXT224E.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index f9a9be9..8350bcc 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -248,6 +248,7 @@ struct mxt_data {
 	unsigned int max_y;
 
 	/* Cached parameters from object table */
+	u8 T6_reportid;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 };
@@ -555,8 +556,6 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	struct device *dev = &data->client->dev;
 	int id;
 	u8 reportid;
-	u8 max_reportid;
-	u8 min_reportid;
 	bool update_input = false;
 
 	do {
@@ -567,11 +566,15 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 
 		reportid = message.reportid;
 
-		max_reportid = data->T9_reportid_max;
-		min_reportid = data->T9_reportid_min;
-		id = reportid - min_reportid;
-
-		if (reportid >= min_reportid && reportid <= max_reportid) {
+		if (reportid == data->T6_reportid) {
+			unsigned csum = message.message[1] |
+					(message.message[2] << 8) |
+					(message.message[3] << 16);
+			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
+				message.message[0], csum);
+		} else if (reportid >= data->T9_reportid_min &&
+			    reportid <= data->T9_reportid_max) {
+			id = reportid - data->T9_reportid_min;
 			mxt_input_touchevent(data, &message, id);
 			update_input = true;
 		} else {
@@ -749,6 +752,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 			 object->instances + 1, min_id, max_id);
 
 		switch (object->type) {
+		case MXT_GEN_COMMAND_T6:
+			data->T6_reportid = min_id;
+			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
 			data->T9_reportid_max = max_id;
@@ -1008,6 +1014,7 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		/* Destroy old object table and any cached fields */
 		kfree(data->object_table);
 		data->object_table = NULL;
+		data->T6_reportid = 0;
 		data->T9_reportid_min = 0;
 		data->T9_reportid_max = 0;
 
-- 
1.7.7.3

