Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2F1NO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:14:28 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41248 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2F1NI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:29 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 09/23 v6] Input: atmel_mxt_ts - print all instances when dumping objects
Date: Thu, 28 Jun 2012 21:08:10 +0800
Message-Id: <1340888904-15620-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For objects with multiple instances, dump them all, prepending each with
its "Instance #".

[rydberg@euromail.se: break out mxt_show_instance()]
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   36 +++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c8cfd7b..ee37b0b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -877,6 +877,24 @@ static void mxt_calc_resolution(struct mxt_data *data)
 	}
 }
 
+static ssize_t mxt_show_instance(char *buf, int count,
+				 struct mxt_object *object, int instance,
+				 const u8 *val)
+{
+	int i;
+
+	if (object->instances > 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Instance %u\n", instance);
+
+	for (i = 0; i < object->size + 1; i++)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				"\t[%2u]: %02x (%d)\n", i, val[i], val[i]);
+	count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
+
+	return count;
+}
+
 static ssize_t mxt_object_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -885,7 +903,6 @@ static ssize_t mxt_object_show(struct device *dev,
 	int count = 0;
 	int i, j;
 	int error;
-	u8 val;
 	u8 *obuf;
 
 	/* Pre-allocate buffer large enough to hold max sized object. */
@@ -903,20 +920,19 @@ static ssize_t mxt_object_show(struct device *dev,
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				"T%u:\n", object->type);
 
-		error = __mxt_read_reg(data->client, object->start_address,
-				object->size + 1, obuf);
-		if (error)
-			break;
+		for (j = 0; j < object->instances + 1; j++) {
+			u16 size = object->size + 1;
+			u16 addr = object->start_address + j * size;
 
-		for (j = 0; j < object->size + 1; j++) {
-			val = obuf[j];
+			error = __mxt_read_reg(data->client, addr, size, obuf);
+			if (error)
+				goto done;
 
-			count += scnprintf(buf + count, PAGE_SIZE - count,
-					"\t[%2d]: %02x (%d)\n", j, val, val);
+			count = mxt_show_instance(buf, count, object, j, obuf);
 		}
-		count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
 	}
 
+done:
 	kfree(obuf);
 	return error ?: count;
 }
-- 
1.7.7.3

