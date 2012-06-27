Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2F0NzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:55:01 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57895 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2F0NyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:22 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 1/8 v3] i2c: i801: refactor use of LAST_BYTE i801_block_transaction_byte_by_byte
Date: Wed, 27 Jun 2012 21:54:08 +0800
Message-Id: <1340805255-8041-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a slight optimization, pull some logic out of the polling loop during
byte-by-byte transactions by just setting the I801_LAST_BYTE bit, as
defined in the i801 (PCH) datasheet, when reading the last byte of a
byte-by-byte I2C_SMBUS_READ.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ae2945a..51e11eb 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -117,8 +117,7 @@
 #define I801_PROC_CALL		0x10	/* unimplemented */
 #define I801_BLOCK_DATA		0x14
 #define I801_I2C_BLOCK_DATA	0x18	/* ICH5 and later */
-#define I801_BLOCK_LAST		0x34
-#define I801_I2C_BLOCK_LAST	0x38	/* ICH5 and later */
+#define I801_LAST_BYTE		0x20
 #define I801_START		0x40
 #define I801_PEC_EN		0x80	/* ICH3 and later */
 
@@ -338,6 +337,11 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 	return 0;
 }
 
+/*
+ * For "byte-by-byte" block transactions:
+ *   I2C write uses cmd=I801_BLOCK_DATA, I2C_EN=1
+ *   I2C read uses cmd=I801_I2C_BLOCK_DATA
+ */
 static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 					       union i2c_smbus_data *data,
 					       char read_write, int command,
@@ -360,19 +364,15 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 		outb_p(data->block[1], SMBBLKDAT(priv));
 	}
 
+	if (command == I2C_SMBUS_I2C_BLOCK_DATA &&
+	    read_write == I2C_SMBUS_READ)
+		smbcmd = I801_I2C_BLOCK_DATA;
+	else
+		smbcmd = I801_BLOCK_DATA;
+
 	for (i = 1; i <= len; i++) {
-		if (i == len && read_write == I2C_SMBUS_READ) {
-			if (command == I2C_SMBUS_I2C_BLOCK_DATA)
-				smbcmd = I801_I2C_BLOCK_LAST;
-			else
-				smbcmd = I801_BLOCK_LAST;
-		} else {
-			if (command == I2C_SMBUS_I2C_BLOCK_DATA
-			 && read_write == I2C_SMBUS_READ)
-				smbcmd = I801_I2C_BLOCK_DATA;
-			else
-				smbcmd = I801_BLOCK_DATA;
-		}
+		if (i == len && read_write == I2C_SMBUS_READ)
+			smbcmd |= I801_LAST_BYTE;
 		outb_p(smbcmd | ENABLE_INT9, SMBHSTCNT(priv));
 
 		if (i == 1)
-- 
1.7.7.3

