Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2F1NO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:14:26 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40147 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2F1NI3 (ORCPT
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
Subject: [PATCH 12/23 v6] Input: atmel_mxt_ts - optimize writing of object table entries
Date: Thu, 28 Jun 2012 21:08:13 +0800
Message-Id: <1340888904-15620-13-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
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
index dd2577b..99d5210 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -655,7 +655,8 @@ static int mxt_check_reg_init(struct mxt_data *data)
 	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
 	int index = 0;
-	int i, j, config_offset;
+	int i, size;
+	int ret;
 
 	if (!pdata->config) {
 		dev_dbg(dev, "No cfg data defined, skipping reg init\n");
@@ -668,18 +669,17 @@ static int mxt_check_reg_init(struct mxt_data *data)
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

