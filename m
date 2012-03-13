Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab2CMMLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:11:09 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:42166 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab2CMMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:11:04 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 08:11:03 EDT
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 15/20] Input: atmel_mxt_ts - optimize writing of object table entries
Date: Tue, 13 Mar 2012 20:04:18 +0800
Message-Id: <1331640263-18935-16-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write each object using a single bulk i2c write transfer.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 9e1ce03..0277381 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -609,33 +609,33 @@ end:
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
-	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
-	int index = 0;
-	int i, j, config_offset, config_size;
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
 
 		config_size = object->size * object->instances;
-		for (j = 0; j < config_size; j++) {
-			config_offset = index + j;
-			if (config_offset > pdata->config_length) {
-				dev_err(dev, "Not enough config data!\n");
-				return -EINVAL;
-			}
-			mxt_write_object(data, object->type, j,
-					 pdata->config[config_offset]);
+		if (offset + config_size > pdata->config_length) {
+			dev_err(dev, "Not enough config data!\n");
+			return -EINVAL;
 		}
-		index += config_size;
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

