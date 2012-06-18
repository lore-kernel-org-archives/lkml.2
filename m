Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2FREJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:09:26 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:42580 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2FREIu (ORCPT
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
Subject: [PATCH 09/22 v4] Input: atmel_mxt_ts - print all instances when dumping objects
Date: Mon, 18 Jun 2012 12:08:29 +0800
Message-Id: <1339992522-22073-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For objects with multiple instances, dump them all, prepending each with
its "Instance #".

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 65fd89b..281fcbd 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -882,7 +882,7 @@ static ssize_t mxt_object_show(struct device *dev,
 	struct mxt_data *data = dev_get_drvdata(dev);
 	struct mxt_object *object;
 	int count = 0;
-	int i, j;
+	int i, j, k;
 	int error;
 	u8 val;
 	u8 *obuf;
@@ -902,18 +902,30 @@ static ssize_t mxt_object_show(struct device *dev,
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				"T%u:\n", object->type);
 
-		error = __mxt_read_reg(data->client, object->start_address,
-				object->size + 1, obuf);
-		if (error)
-			break;
+		for (j = 0; j < object->instances + 1; j++) {
+			u16 size = object->size + 1;
+			u16 addr = object->start_address + j * size;
+
+			error = __mxt_read_reg(data->client, addr, size, obuf);
+			if (error)
+				break;
 
-		for (j = 0; j < object->size + 1; j++) {
-			val = obuf[j];
+			if (object->instances > 0)
+				count += scnprintf(buf + count,
+						PAGE_SIZE - count,
+						"Instance %u\n", j);
 
+			for (k = 0; k < object->size + 1; k++) {
+				val = obuf[k];
+
+				count += scnprintf(buf + count,
+						PAGE_SIZE - count,
+						"\t[%2u]: %02x (%d)\n",
+						k, val, val);
+			}
 			count += scnprintf(buf + count, PAGE_SIZE - count,
-					"\t[%2d]: %02x (%d)\n", j, val, val);
+					"\n");
 		}
-		count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
 	}
 
 	kfree(obuf);
-- 
1.7.7.3

