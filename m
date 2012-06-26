Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab2FZHE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:04:57 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:45083 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2FZHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:04:56 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 10/21 v5] Input: atmel_mxt_ts - return errors from i2c layer
Date: Tue, 26 Jun 2012 14:56:58 +0800
Message-Id: <1340693829-18665-11-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c layer can report a variety of errors, including -ENXIO for an i2c
NAK.  Instead of treating them all as -EIO, pass the actual i2c layer
error up to the caller.

However, still report as -EIO the unlikely case that a transaction was
partially completed, and no error message was returned from i2c_*().

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 25d3dd5..3672553 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -396,6 +396,7 @@ static int __mxt_read_reg(struct i2c_client *client,
 {
 	struct i2c_msg xfer[2];
 	u8 buf[2];
+	int ret;
 
 	buf[0] = reg & 0xff;
 	buf[1] = (reg >> 8) & 0xff;
@@ -412,12 +413,17 @@ static int __mxt_read_reg(struct i2c_client *client,
 	xfer[1].len = len;
 	xfer[1].buf = val;
 
-	if (i2c_transfer(client->adapter, xfer, 2) != 2) {
-		dev_err(&client->dev, "%s: i2c transfer failed\n", __func__);
-		return -EIO;
+	ret = i2c_transfer(client->adapter, xfer, 2);
+	if (ret == 2) {
+		ret = 0;
+	} else {
+		if (ret >= 0)
+			ret = -EIO;
+		dev_err(&client->dev, "%s: i2c transfer failed (%d)\n",
+			__func__, ret);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mxt_read_reg(struct i2c_client *client, u16 reg, u8 *val)
@@ -428,17 +434,23 @@ static int mxt_read_reg(struct i2c_client *client, u16 reg, u8 *val)
 static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)
 {
 	u8 buf[3];
+	int ret;
 
 	buf[0] = reg & 0xff;
 	buf[1] = (reg >> 8) & 0xff;
 	buf[2] = val;
 
-	if (i2c_master_send(client, buf, 3) != 3) {
-		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
-		return -EIO;
+	ret = i2c_master_send(client, buf, 3);
+	if (ret == 3) {
+		ret = 0;
+	} else {
+		if (ret >= 0)
+			ret = -EIO;
+		dev_err(&client->dev, "%s: i2c send failed (%d)\n",
+			__func__, ret);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mxt_read_object_table(struct i2c_client *client,
-- 
1.7.7.3

