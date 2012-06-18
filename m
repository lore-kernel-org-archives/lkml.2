Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2FREJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:09:19 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36783 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2FREIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:08:50 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 07/22 v4] Input: atmel_mxt_ts - optimize reading objects in object sysfs entry
Date: Mon, 18 Jun 2012 12:08:27 +0800
Message-Id: <1339992522-22073-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read each object in a single i2c transaction instead of byte-by-byte

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   35 ++++++++++++-----------------
 1 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 472ab29..8c99d6d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -478,20 +478,6 @@ static int mxt_read_message(struct mxt_data *data,
 			sizeof(struct mxt_message), message);
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
-	return __mxt_read_reg(data->client, reg + offset, 1, val);
-}
-
 static int mxt_write_object(struct mxt_data *data,
 				 u8 type, u8 offset, u8 val)
 {
@@ -899,7 +885,14 @@ static ssize_t mxt_object_show(struct device *dev,
 	int i, j;
 	int error;
 	u8 val;
+	u8 *obuf;
+
+	/* Pre-allocate buffer large enough to hold max sized object. */
+	obuf = kmalloc(256, GFP_KERNEL);
+	if (!obuf)
+		return -ENOMEM;
 
+	error = 0;
 	for (i = 0; i < data->info.object_num; i++) {
 		object = data->object_table + i;
 
@@ -913,20 +906,22 @@ static ssize_t mxt_object_show(struct device *dev,
 			continue;
 		}
 
+		error = __mxt_read_reg(data->client, object->start_address,
+				object->size + 1, obuf);
+		if (error)
+			break;
+
 		for (j = 0; j < object->size + 1; j++) {
-			error = mxt_read_object(data,
-						object->type, j, &val);
-			if (error)
-				return error;
+			val = obuf[j];
 
 			count += scnprintf(buf + count, PAGE_SIZE - count,
 					"\t[%2d]: %02x (%d)\n", j, val, val);
 		}
-
 		count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
 	}
 
-	return count;
+	kfree(obuf);
+	return error ?: count;
 }
 
 static int mxt_load_fw(struct device *dev, const char *fn)
-- 
1.7.7.3

