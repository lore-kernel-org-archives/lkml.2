Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2C2QxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:53:02 -0400
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51827 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759756Ab2C2Qta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:49:30 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 04/16 v2] Input: atmel_mxt_ts - store actual size and instance
Date: Fri, 30 Mar 2012 00:49:14 +0800
Message-Id: <1333039766-8617-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two object table entry fields are reported 1 less than their value.
So add 1 once, when building the object table, instead of every time
these fields are accessed.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 971f9dc..920b35c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -225,8 +225,8 @@ struct mxt_info {
 struct mxt_object {
 	u8 type;
 	u16 start_address;
-	u8 size;
-	u8 instances;
+	u16 size;
+	u16 instances;
 	u8 num_report_ids;
 
 	/* to map object and message */
@@ -645,7 +645,7 @@ static int mxt_check_reg_init(struct mxt_data *data)
 	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
 	int index = 0;
-	int i, j, config_offset;
+	int i, j, config_offset, config_size;
 
 	if (!pdata->config) {
 		dev_dbg(dev, "No cfg data defined, skipping reg init\n");
@@ -658,9 +658,8 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		if (!mxt_object_writable(object->type))
 			continue;
 
-		for (j = 0;
-		     j < (object->size + 1) * (object->instances + 1);
-		     j++) {
+		config_size = object->size * object->instances;
+		for (j = 0; j < config_size; j++) {
 			config_offset = index + j;
 			if (config_offset > pdata->config_length) {
 				dev_err(dev, "Not enough config data!\n");
@@ -669,7 +668,7 @@ static int mxt_check_reg_init(struct mxt_data *data)
 			mxt_write_object(data, object->type, j,
 					 pdata->config[config_offset]);
 		}
-		index += (object->size + 1) * (object->instances + 1);
+		index += config_size;
 	}
 
 	return 0;
@@ -798,13 +797,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		object->type = buf[0];
 		object->start_address = (buf[2] << 8) | buf[1];
-		object->size = buf[3];
-		object->instances = buf[4];
+		object->size = buf[3] + 1;
+		object->instances = buf[4] + 1;
 		object->num_report_ids = buf[5];
 
 		if (object->num_report_ids) {
-			reportid += object->num_report_ids *
-					(object->instances + 1);
+			reportid += object->num_report_ids * object->instances;
 			object->max_reportid = reportid;
 		}
 	}
@@ -919,7 +917,7 @@ static ssize_t mxt_object_show(struct device *dev,
 			continue;
 		}
 
-		for (j = 0; j < object->size + 1; j++) {
+		for (j = 0; j < object->size; j++) {
 			error = mxt_read_object(data,
 						object->type, j, &val);
 			if (error)
-- 
1.7.7.3

