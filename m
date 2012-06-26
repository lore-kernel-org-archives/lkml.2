Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2FZG7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:59:50 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:65431 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab2FZG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:20 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 13/21 v5] Input: atmel_mxt_ts - read ID information block in one i2c transaction
Date: Tue, 26 Jun 2012 14:57:01 +0800
Message-Id: <1340693829-18665-14-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the whole info block in one i2c transaction speeds up driver
probe significantly, especially on slower i2c busses.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   26 +++-----------------------
 1 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c16fd9c..07e0238 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -36,6 +36,7 @@
 #define MXT_FW_NAME		"maxtouch.fw"
 
 /* Registers */
+#define MXT_INFO		0x00
 #define MXT_FAMILY_ID		0x00
 #define MXT_VARIANT_ID		0x01
 #define MXT_VERSION		0x02
@@ -759,32 +760,11 @@ static int mxt_get_info(struct mxt_data *data)
 	struct i2c_client *client = data->client;
 	struct mxt_info *info = &data->info;
 	int error;
-	u8 val;
-
-	error = mxt_read_reg(client, MXT_FAMILY_ID, &val);
-	if (error)
-		return error;
-	info->family_id = val;
-
-	error = mxt_read_reg(client, MXT_VARIANT_ID, &val);
-	if (error)
-		return error;
-	info->variant_id = val;
-
-	error = mxt_read_reg(client, MXT_VERSION, &val);
-	if (error)
-		return error;
-	info->version = val;
-
-	error = mxt_read_reg(client, MXT_BUILD, &val);
-	if (error)
-		return error;
-	info->build = val;
 
-	error = mxt_read_reg(client, MXT_OBJECT_NUM, &val);
+	/* Read 7-byte info block starting at address 0 */
+	error = __mxt_read_reg(client, MXT_INFO, sizeof(*info), info);
 	if (error)
 		return error;
-	info->object_num = val;
 
 	return 0;
 }
-- 
1.7.7.3

