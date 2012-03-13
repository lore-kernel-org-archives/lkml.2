Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2CMMIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:08:37 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63910 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2CMMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 05/20] Input: atmel_mxt_ts - dump mxt_read/write_reg
Date: Tue, 13 Mar 2012 20:04:08 +0800
Message-Id: <1331640263-18935-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For verbose on-the-wire debugging.
Prints DUMP_LEN bytes (in hex) per line.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   31 ++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index defd4e1..dd3919a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -397,6 +397,33 @@ static int mxt_fw_write(struct i2c_client *client,
 	return 0;
 }
 
+#ifdef DEBUG
+#define DUMP_LEN	16
+static void mxt_dump_xfer(struct device *dev, const char *func, u16 reg,
+			  u16 len, const u8 *val)
+{
+	/* Rough guess for string size */
+	char str[DUMP_LEN * 3 + 2];
+	int i;
+	size_t n;
+
+	for (i = 0, n = 0; i < len; i++) {
+		n += snprintf(&str[n], sizeof(str) - n, "%02x ", val[i]);
+		if ((i + 1) % DUMP_LEN == 0 || (i + 1) == len) {
+			dev_dbg(dev,
+				"%s(reg: %d len: %d offset: 0x%02x): %s\n",
+				func, reg, len, (i / DUMP_LEN) * DUMP_LEN,
+				str);
+			n = 0;
+		}
+	}
+}
+#undef DUMP_LEN
+#else
+static void mxt_dump_xfer(struct device *dev, const char *func, u16 reg,
+			  u16 len, const u8 *val) { }
+#endif
+
 static int mxt_read_reg(struct i2c_client *client, u16 reg, u16 len, void *val)
 {
 	struct i2c_msg xfer[2];
@@ -422,6 +449,8 @@ static int mxt_read_reg(struct i2c_client *client, u16 reg, u16 len, void *val)
 		return -EIO;
 	}
 
+	mxt_dump_xfer(&client->dev, __func__, reg, len, val);
+
 	return 0;
 }
 
@@ -435,6 +464,8 @@ static int mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
 	buf[1] = (reg >> 8) & 0xff;
 	memcpy(&buf[2], val, len);
 
+	mxt_dump_xfer(&client->dev, __func__, reg, len, val);
+
 	if (i2c_master_send(client, buf, count) != count) {
 		dev_err(&client->dev, "%s: i2c write failed\n", __func__);
 		return -EIO;
-- 
1.7.7.3

