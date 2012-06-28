Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2F1NKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:10:02 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:51281 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2F1NIb (ORCPT
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
Subject: [PATCH 23/23 v6] Input: atmel_mxt_ts - parse T6 reports
Date: Thu, 28 Jun 2012 21:08:24 +0800
Message-Id: <1340888904-15620-24-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The normal messages sent after boot or NVRAM update are T6 reports,
containing a status, and the config memory checksum.  Parse them and dump
a useful info message.

This patch tested on an MXT224E.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 4c9a06c..37190ab 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -248,6 +248,7 @@ struct mxt_data {
 	unsigned int max_y;
 
 	/* Cached parameters from object table */
+	u8 T6_reportid;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 };
@@ -549,6 +550,11 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	}
 }
 
+static unsigned mxt_extract_T6_csum(const u8 *csum)
+{
+	return csum[0] | (csum[1] << 8) | (csum[2] << 16);
+}
+
 static bool mxt_is_T9_message(struct mxt_data *data, struct mxt_message *msg)
 {
 	u8 id = msg->reportid;
@@ -559,8 +565,8 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 {
 	struct mxt_data *data = dev_id;
 	struct mxt_message message;
+	const u8 *payload = &message.message[0];
 	struct device *dev = &data->client->dev;
-	int id;
 	u8 reportid;
 	bool update_input = false;
 
@@ -572,9 +578,13 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 
 		reportid = message.reportid;
 
-		id = reportid - data->T9_reportid_min;
-
-		if (mxt_is_T9_message(data, &message)) {
+		if (reportid == data->T6_reportid) {
+			u8 status = payload[0];
+			unsigned csum = mxt_extract_T6_csum(&payload[1]);
+			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
+				status, csum);
+		} else if (mxt_is_T9_message(data, &message)) {
+			int id = reportid - data->T9_reportid_min;
 			mxt_input_touchevent(data, &message, id);
 			update_input = true;
 		} else {
@@ -749,6 +759,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 			object->instances + 1, min_id, max_id);
 
 		switch (object->type) {
+		case MXT_GEN_COMMAND_T6:
+			data->T6_reportid = min_id;
+			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
 			data->T9_reportid_max = max_id;
@@ -763,8 +776,10 @@ static void mxt_free_object_table(struct mxt_data *data)
 {
 	kfree(data->object_table);
 	data->object_table = NULL;
+	data->T6_reportid = 0;
 	data->T9_reportid_min = 0;
 	data->T9_reportid_max = 0;
+
 }
 
 static int mxt_initialize(struct mxt_data *data)
-- 
1.7.7.3

