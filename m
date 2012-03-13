Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2CMMGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:06:09 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:42881 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2CMMEc (ORCPT
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
Subject: [PATCH 11/20] Input: atmel_mxt_ts - refactor mxt_object_show
Date: Tue, 13 Mar 2012 20:04:14 +0800
Message-Id: <1331640263-18935-12-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read each object with a single i2c transaction instead of byte-by-byte.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   42 ++++++++++++-----------------
 1 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index ac8c50a..4363511 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -490,6 +490,13 @@ mxt_get_object(struct mxt_data *data, u8 type)
 	return NULL;
 }
 
+static int mxt_read_object(struct mxt_data *data, struct mxt_object *object,
+			   void *val)
+{
+	return mxt_read_reg(data->client, object->start_address, object->size,
+			    val);
+}
+
 static int mxt_read_message(struct mxt_data *data,
 				 struct mxt_message *message)
 {
@@ -505,20 +512,6 @@ static int mxt_read_message(struct mxt_data *data,
 			    message);
 }
 
-static int mxt_read_object(struct mxt_data *data,
-				u8 type, u8 offset, u8 *val)
-{
-	struct mxt_object *object;
-	u16 reg;
-
-	object = mxt_get_object(data, type);
-	if (!object)
-		return -EINVAL;
-
-	reg = object->start_address;
-	return mxt_read_reg(data->client, reg + offset, 1, val);
-}
-
 static int mxt_write_object(struct mxt_data *data,
 				 u8 type, u8 offset, u8 val)
 {
@@ -916,17 +909,16 @@ static void mxt_calc_resolution(struct mxt_data *data)
 }
 
 static ssize_t mxt_object_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+			       struct device_attribute *attr, char *buf)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
-	struct mxt_object *object;
 	int count = 0;
 	int i, j;
 	int error;
-	u8 val;
+	u8 obuf[256];
 
 	for (i = 0; i < data->info.object_num; i++) {
-		object = data->object_table + i;
+		struct mxt_object *object = &data->object_table[i];
 
 		count += snprintf(buf + count, PAGE_SIZE - count,
 				"Object[%d] (Type %d)\n",
@@ -936,20 +928,20 @@ static ssize_t mxt_object_show(struct device *dev,
 
 		if (!mxt_object_readable(object->type)) {
 			count += snprintf(buf + count, PAGE_SIZE - count,
-					"\n");
+					  "\n");
 			if (count >= PAGE_SIZE)
 				return PAGE_SIZE - 1;
 			continue;
 		}
 
-		for (j = 0; j < object->size; j++) {
-			error = mxt_read_object(data,
-						object->type, j, &val);
-			if (error)
-				return error;
+		error = mxt_read_object(data, object, obuf);
+		if (error)
+			return error;
 
+		for (j = 0; j < object->size; j++) {
 			count += snprintf(buf + count, PAGE_SIZE - count,
-					"\t[%2d]: %02x (%d)\n", j, val, val);
+					  "\t[%2d]: %02x (%d)\n", j, obuf[j],
+					  obuf[j]);
 			if (count >= PAGE_SIZE)
 				return PAGE_SIZE - 1;
 		}
-- 
1.7.7.3

