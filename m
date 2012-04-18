Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2DRN34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:29:56 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55097 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2DRN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:29:54 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 08/14 v3] Input: atmel_mxt_ts - optimize writing of object table entries
Date: Wed, 18 Apr 2012 21:21:53 +0800
Message-Id: <1334755319-21365-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write each object using a single bulk i2c write transfer.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   31 ++++++++++++++---------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 03b292f..1da814b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -636,34 +636,33 @@ end:
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
-	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
-	int index = 0;
-	int i, j, config_offset;
+	int i, offset;
+	int ret;
 
 	if (!pdata->config) {
 		dev_dbg(dev, "No cfg data defined, skipping reg init\n");
 		return 0;
 	}
 
-	for (i = 0; i < data->info.object_num; i++) {
-		object = data->object_table + i;
+	for (offset = 0, i = 0; i < data->info.object_num; i++) {
+		struct mxt_object *object = &data->object_table[i];
+		size_t config_size;
 
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
+		config_size = (object->size + 1) * (object->instances + 1);
+		if (offset + config_size > pdata->config_length) {
+			dev_err(dev, "Not enough config data!\n");
+			return -EINVAL;
 		}
-		index += (object->size + 1) * (object->instances + 1);
+
+		ret = mxt_write_reg(data->client, object->start_address,
+				    config_size, &pdata->config[offset]);
+		if (ret)
+			return ret;
+		offset += config_size;
 	}
 
 	return 0;
-- 
1.7.7.3

