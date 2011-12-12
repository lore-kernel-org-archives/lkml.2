Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1LLEzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:55:49 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:52073
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab1LLEzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:55:46 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <Yuantian.tang@freescale.com>
To: <ben-linux@fluff.org>, <khali@linux-fr.org>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guenter.roeck@ericsson.com>, Tang Yuantian <B29983@freescale.com>,
        Tang Yuantian <Yuantian.Tang@freescale.com>
Subject: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Date: Mon, 12 Dec 2011 12:10:10 +0800
Message-ID: <1323663010-32223-1-git-send-email-Yuantian.tang@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Yuantian <B29983@freescale.com>

Add support for SMBUS_READ_BLOCK_DATA to the i2c-mpc bus driver.

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
tested on p1022ds

 drivers/i2c/busses/i2c-mpc.c |   63 ++++++++++++++++++++++++++++++++---------
 1 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 107397a..bba9a07 100644
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
@@ -479,17 +479,46 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
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
+		/*
+		 * Adjust length if first received byte is length.
+		 * The length is 1 length byte plus actually data length
+		 */
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
@@ -532,12 +561,17 @@ static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
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
@@ -545,7 +579,8 @@ static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 
 static u32 mpc_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL
+	  | I2C_FUNC_SMBUS_READ_BLOCK_DATA | I2C_FUNC_SMBUS_BLOCK_PROC_CALL;
 }
 
 static const struct i2c_algorithm mpc_algo = {
-- 
1.6.4


