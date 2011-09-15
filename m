Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab1IOTlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:41:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12625 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:41:06 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH] Input: atmel_mxt_ts - Use snprintf for sysfs attribute show method
Date: Thu, 15 Sep 2011 12:40:47 -0700
Message-Id: <1316115647-1244-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs attribute show methods are always passed a buffer of length
PAGE_SIZE.  To keep from overwriting this buffer and causing havoc, use
snprintf() to guarantee we never write more than the buffer can hold.

In addition, at least for my touchscreen, the number and size of objects
was far too big to fit in a single 4K page.  Therefore, this patch also
trims some redundant framing text to leave more room for actual data.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index f5d6685..a596c27 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -910,12 +910,17 @@ static ssize_t mxt_object_show(struct device *dev,
 	for (i = 0; i < data->info.object_num; i++) {
 		object = data->object_table + i;
 
-		count += sprintf(buf + count,
-				"Object Table Element %d(Type %d)\n",
+		count += snprintf(buf + count, PAGE_SIZE - count,
+				"Object[%d] (Type %d)\n",
 				i + 1, object->type);
+		if (count >= PAGE_SIZE)
+			return PAGE_SIZE - 1;
 
 		if (!mxt_object_readable(object->type)) {
-			count += sprintf(buf + count, "\n");
+			count += snprintf(buf + count, PAGE_SIZE - count,
+					"\n");
+			if (count >= PAGE_SIZE)
+				return PAGE_SIZE - 1;
 			continue;
 		}
 
@@ -925,11 +930,15 @@ static ssize_t mxt_object_show(struct device *dev,
 			if (error)
 				return error;
 
-			count += sprintf(buf + count,
-					"  Byte %d: 0x%x (%d)\n", j, val, val);
+			count += snprintf(buf + count, PAGE_SIZE - count,
+					"\t[%2d]: %02x (%d)\n", j, val, val);
+			if (count >= PAGE_SIZE)
+				return PAGE_SIZE - 1;
 		}
 
-		count += sprintf(buf + count, "\n");
+		count += snprintf(buf + count, PAGE_SIZE - count, "\n");
+		if (count >= PAGE_SIZE)
+			return PAGE_SIZE - 1;
 	}
 
 	return count;
-- 
1.7.3.1

