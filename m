Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab1KPALa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:11:30 -0500
Received: from imr4.ericy.com ([198.24.6.9]:48274 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614Ab1KPAL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:11:29 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
CC: Tabi Timur <B04825@freescale.com>, Tang Yuantian <B29983@freescale.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Date: Tue, 15 Nov 2011 16:10:43 -0800
Message-ID: <1321402243-7353-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for SMBUS_READ_BLOCK_DATA to the i2c-mpc bus driver.
Required to support the PMBus zl6100 driver with i2c-mpc.

Reported-by: Tang Yuantian <B29983@freescale.com>
Cc: Tang Yuantian <B29983@freescale.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
v2:
  - renamed bool block --> bool recv_len
  - Added I2C_FUNC_SMBUS_BLOCK_PROC_CALL to list of supported features
  - Read data only after updating CCR register

I have not been able to test this patch yet.

 drivers/i2c/busses/i2c-mpc.c |   60 ++++++++++++++++++++++++++++++++----------
 1 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 107397a..74a2aa5 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -454,7 +454,7 @@ static int mpc_write(struct mpc_i2c *i2c, int target,
 }
 
 static int mpc_read(struct mpc_i2c *i2c, int target,
-		    u8 *data, int length, int restart)
+		    u8 *data, int length, int restart, bool recv_len)
 {
 	unsigned timeout = i2c->adap.timeout;
 	int i, result;
@@ -470,7 +470,7 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
 		return result;
 
 	if (length) {
-		if (length == 1)
+		if (length == 1 && !recv_len)
 			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_TXAK);
 		else
 			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA);
@@ -479,17 +479,43 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
 	}
 
 	for (i = 0; i < length; i++) {
+		u8 byte;
+
 		result = i2c_wait(i2c, timeout, 0);
 		if (result < 0)
 			return result;
 
-		/* Generate txack on next to last byte */
-		if (i == length - 2)
-			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_TXAK);
-		/* Do not generate stop on last byte */
-		if (i == length - 1)
-			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_MTX);
-		data[i] = readb(i2c->base + MPC_I2C_DR);
+		/*
+		 * For block reads, we have to know the total length (1st byte)
+		 * before we can determine if we are done.
+		 */
+		if (i || !recv_len) {
+			/* Generate txack on next to last byte */
+			if (i == length - 2)
+				writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA
+					 | CCR_TXAK);
+			/* Do not generate stop on last byte */
+			if (i == length - 1)
+				writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA
+					 | CCR_MTX);
+		}
+
+		byte = readb(i2c->base + MPC_I2C_DR);
+
+		/* Adjust length if first received byte is length */
+		if (i == 0 && recv_len) {
+			if (byte == 0 || byte > I2C_SMBUS_BLOCK_MAX)
+				return -EPROTO;
+			length += byte;
+			/*
+			 * For block reads, generate txack here if data length
+			 * is 1 byte (total length is 2 bytes).
+			 */
+			if (length == 2)
+				writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA
+					 | CCR_TXAK);
+		}
+		data[i] = byte;
 	}
 
 	return length;
@@ -532,12 +558,17 @@ static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			"Doing %s %d bytes to 0x%02x - %d of %d messages\n",
 			pmsg->flags & I2C_M_RD ? "read" : "write",
 			pmsg->len, pmsg->addr, i + 1, num);
-		if (pmsg->flags & I2C_M_RD)
-			ret =
-			    mpc_read(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
-		else
+		if (pmsg->flags & I2C_M_RD) {
+			bool recv_len = pmsg->flags & I2C_M_RECV_LEN;
+
+			ret = mpc_read(i2c, pmsg->addr, pmsg->buf, pmsg->len, i,
+				       recv_len);
+			if (recv_len && ret > 0)
+				pmsg->len = ret;
+		} else {
 			ret =
 			    mpc_write(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
+		}
 	}
 	mpc_i2c_stop(i2c);
 	return (ret < 0) ? ret : num;
@@ -545,7 +576,8 @@ static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 
 static u32 mpc_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL
+	  | I2C_FUNC_SMBUS_READ_BLOCK_DATA | I2C_FUNC_SMBUS_BLOCK_PROC_CALL;
 }
 
 static const struct i2c_algorithm mpc_algo = {
-- 
1.7.3.1

