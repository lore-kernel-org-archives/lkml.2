Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2F1NKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:10:10 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61839 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2F1NIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 13/23 v6] Input: atmel_mxt_ts - read ID information block in one i2c transaction
Date: Thu, 28 Jun 2012 21:08:14 +0800
Message-Id: <1340888904-15620-14-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
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
index 99d5210..fac3791 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -36,6 +36,7 @@
 #define MXT_FW_NAME		"maxtouch.fw"
 
 /* Registers */
+#define MXT_INFO		0x00
 #define MXT_FAMILY_ID		0x00
 #define MXT_VARIANT_ID		0x01
 #define MXT_VERSION		0x02
@@ -760,32 +761,11 @@ static int mxt_get_info(struct mxt_data *data)
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

