Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2F0NzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:55:13 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55385 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2F0NyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:22 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 6/8 v3] i2c: i801: drop ENABLE_INT9
Date: Wed, 27 Jun 2012 21:54:13 +0800
Message-Id: <1340805255-8041-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later patches enable interrupts.  This preliminary patch removes the older
unsupported ENABLE_INT9 flag.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index c57bb0c..6fa2a0b 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -104,7 +104,6 @@
 
 /* Other settings */
 #define MAX_RETRIES		400
-#define ENABLE_INT9		0	/* set to 0x01 to enable - untested */
 
 /* I801 command constants */
 #define I801_QUICK		0x00
@@ -289,7 +288,7 @@ static int i801_transaction(struct i801_priv *priv, int xact)
 		return result;
 
 	/* the current contents of SMBHSTCNT can be overwritten, since PEC,
-	 * INTREN, SMBSCMD are passed in xact */
+	 * SMBSCMD are passed in xact */
 	outb_p(xact | SMBHSTCNT_START, SMBHSTCNT(priv));
 
 	/* We will always wait for a fraction of a second! */
@@ -324,7 +323,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 			outb_p(data->block[i+1], SMBBLKDAT(priv));
 	}
 
-	status = i801_transaction(priv, I801_BLOCK_DATA | ENABLE_INT9 |
+	status = i801_transaction(priv, I801_BLOCK_DATA |
 				  SMBHSTCNT_PEC_EN * hwpec);
 	if (status)
 		return status;
@@ -377,7 +376,7 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 	for (i = 1; i <= len; i++) {
 		if (i == len && read_write == I2C_SMBUS_READ)
 			smbcmd |= SMBHSTCNT_LAST_BYTE;
-		outb_p(smbcmd | ENABLE_INT9, SMBHSTCNT(priv));
+		outb_p(smbcmd, SMBHSTCNT(priv));
 
 		if (i == 1)
 			outb_p(inb(SMBHSTCNT(priv)) | SMBHSTCNT_START,
@@ -567,7 +566,7 @@ static s32 i801_access(struct i2c_adapter *adap, u16 addr,
 		ret = i801_block_transaction(priv, data, read_write, size,
 					     hwpec);
 	else
-		ret = i801_transaction(priv, xact | ENABLE_INT9);
+		ret = i801_transaction(priv, xact);
 
 	/* Some BIOSes don't like it when PEC is enabled at reboot or resume
 	   time, so we forcibly disable it after every transaction. Turn off
-- 
1.7.7.3

