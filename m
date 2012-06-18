Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2FREJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:09:18 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54731 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2FREIu (ORCPT
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
Subject: [PATCH 12/22 v4] Input: atmel_mxt_ts - optimize writing of object table entries
Date: Mon, 18 Jun 2012 12:08:32 +0800
Message-Id: <1339992522-22073-13-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write each object using a single bulk i2c write transfer.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 2e49488..efce50f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -653,7 +653,8 @@ static int mxt_check_reg_init(struct mxt_data *data)
 	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
 	int index = 0;
-	int i, j, config_offset;
+	int i, size;
+	int ret;
 
 	if (!pdata->config) {
 		dev_dbg(dev, "No cfg data defined, skipping reg init\n");
@@ -666,18 +667,17 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		if (!mxt_object_writable(object->type))
 			continue;
 
-		for (j = 0;
-		     j < (object->size + 1) * (object->instances + 1);
-		     j++) {
-			config_offset = index + j;
-			if (config_offset > pdata->config_length) {
-				dev_err(dev, "Not enough config data!\n");
-				return -EINVAL;
-			}
-			mxt_write_object(data, object->type, j,
-					 pdata->config[config_offset]);
+		size = (object->size + 1) * (object->instances + 1);
+		if (index + size > pdata->config_length) {
+			dev_err(dev, "Not enough config data!\n");
+			return -EINVAL;
 		}
-		index += (object->size + 1) * (object->instances + 1);
+
+		ret = __mxt_write_reg(data->client, object->start_address,
+				size, &pdata->config[index]);
+		if (ret)
+			return ret;
+		index += size;
 	}
 
 	return 0;
-- 
1.7.7.3

