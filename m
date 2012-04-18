Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2DRNXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:23:21 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42958 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2DRNWF (ORCPT
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
Subject: [PATCH 07/14 v3] Input: atmel_mxt_ts - refactor mxt_object_show
Date: Wed, 18 Apr 2012 21:21:52 +0800
Message-Id: <1334755319-21365-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't read T5, since this is the message buffer.

 * read each object in a single i2c transaction instead of byte-by-byte
 * use scnprintf() like all well-behaved sysfs entries
 * don't read T5, the message processor object.  Reading it will
   only have two outcomes, neither of which is particularly useful:
   1) the message count decrements, and a valid message will be lost
   2) an invalid message will be read (reportid == 0xff)
 * read all instances of each object
 * conserve limited (PAGE_SIZE) sysfs output buffer space by only
   showing readable objects and not printing the object's index, which
   is not useful to userspace

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   77 +++++++++++------------------
 1 files changed, 29 insertions(+), 48 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 21957d0..03b292f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -262,7 +262,6 @@ struct mxt_data {
 static bool mxt_object_readable(unsigned int type)
 {
 	switch (type) {
-	case MXT_GEN_MESSAGE_T5:
 	case MXT_GEN_COMMAND_T6:
 	case MXT_GEN_POWER_T7:
 	case MXT_GEN_ACQUIRE_T8:
@@ -489,20 +488,6 @@ static int mxt_read_message(struct mxt_data *data,
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
@@ -902,50 +887,46 @@ static void mxt_calc_resolution(struct mxt_data *data)
 }
 
 static ssize_t mxt_object_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+			       struct device_attribute *attr, char *buf)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
-	struct mxt_object *object;
 	int count = 0;
-	int i, j;
-	int error;
-	u8 val;
+	size_t i, j, k;
+	int error = 0;
+	u8 *obuf = NULL;
+	char *buf_end = &buf[PAGE_SIZE];
 
-	for (i = 0; i < data->info.object_num; i++) {
-		object = data->object_table + i;
+	for (i = 0; i < data->info.object_num && buf_end - buf > 1; i++) {
+		struct mxt_object *object = &data->object_table[i];
+		size_t size;
 
-		count += snprintf(buf + count, PAGE_SIZE - count,
-				"Object[%d] (Type %d)\n",
-				i + 1, object->type);
-		if (count >= PAGE_SIZE)
-			return PAGE_SIZE - 1;
-
-		if (!mxt_object_readable(object->type)) {
-			count += snprintf(buf + count, PAGE_SIZE - count,
-					"\n");
-			if (count >= PAGE_SIZE)
-				return PAGE_SIZE - 1;
+		if (!mxt_object_readable(object->type))
 			continue;
-		}
 
-		for (j = 0; j < object->size + 1; j++) {
-			error = mxt_read_object(data,
-						object->type, j, &val);
-			if (error)
-				return error;
+		buf += scnprintf(buf, buf_end - buf, "\nType %u\n",
+				 object->type);
 
-			count += snprintf(buf + count, PAGE_SIZE - count,
-					"\t[%2d]: %02x (%d)\n", j, val, val);
-			if (count >= PAGE_SIZE)
-				return PAGE_SIZE - 1;
-		}
+		size = (object->size + 1) * (object->instances + 1);
+		obuf = krealloc(obuf, size, GFP_KERNEL);
+		error = mxt_read_reg(data->client, object->start_address, size,
+				     obuf);
 
-		count += snprintf(buf + count, PAGE_SIZE - count, "\n");
-		if (count >= PAGE_SIZE)
-			return PAGE_SIZE - 1;
+		if (error)
+			break;
+
+		for (j = 0; j < object->instances + 1; j++) {
+			if (object->instances > 0)
+				buf += scnprintf(buf, buf_end - buf,
+						 "Instance %zu\n", j);
+			for (k = 0; k < object->size + 1; k++)
+				buf += scnprintf(buf, buf_end - buf,
+						 "\t[%2zx] %02x (%d)\n",
+						 k, obuf[k], obuf[k]);
+		}
 	}
 
-	return count;
+	kfree(obuf);
+	return error ?: count;
 }
 
 static int mxt_load_fw(struct device *dev, const char *fn)
-- 
1.7.7.3

