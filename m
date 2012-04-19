Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2DSGkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:40:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54830 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2DSGkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:40:01 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/2] i2c-eg20t: add helper function for xfer check
Date: Thu, 19 Apr 2012 15:38:04 +0900
Message-Id: <1334817485-7121-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there are the same code for xfer complete check processing.
So, I add helper function pch_i2c_wait_for_check_xfer.

Reported-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/i2c/busses/i2c-eg20t.c |  226 ++++++++++++----------------------------
 1 files changed, 66 insertions(+), 160 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index ca9e579..72bd23c 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -366,6 +366,34 @@ static void pch_i2c_stop(struct i2c_algo_pch_data *adap)
 	pch_clrbit(adap->pch_base_address, PCH_I2CCTL, PCH_START);
 }
 
+static int pch_i2c_wait_for_check_xfer(struct i2c_algo_pch_data *adap)
+{
+	int rtn;
+
+	rtn = pch_i2c_wait_for_xfer_complete(adap);
+	if (rtn == 0) {
+		if (pch_i2c_getack(adap)) {
+			pch_dbg(adap, "Receive NACK for slave address"
+				"setting\n");
+			return -EIO;
+		}
+	} else if (rtn == -EIO) { /* Arbitration Lost */
+		pch_err(adap, "Lost Arbitration\n");
+		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
+		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
+		pch_i2c_init(adap);
+		return -EAGAIN;
+	} else { /* wait-event timeout */
+		pch_err(adap, "%s(L.%d):wait-event timeout\n",
+			__func__, __LINE__);
+		pch_i2c_stop(adap);
+		pch_i2c_init(adap);
+		return -ETIME;
+	}
+
+	return 0;
+}
+
 /**
  * pch_i2c_repstart() - generate repeated start condition in normal mode
  * @adap:	Pointer to struct i2c_algo_pch_data.
@@ -420,30 +448,12 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 		if (first)
 			pch_i2c_start(adap);
 
-		rtn = pch_i2c_wait_for_xfer_complete(adap);
-		if (rtn == 0) {
-			if (pch_i2c_getack(adap)) {
-				pch_dbg(adap, "Receive NACK for slave address"
-					"setting\n");
-				return -EIO;
-			}
-			addr_8_lsb = (addr & I2C_ADDR_MSK);
-			iowrite32(addr_8_lsb, p + PCH_I2CDR);
-		} else if (rtn == -EIO) { /* Arbitration Lost */
-			pch_err(adap, "Lost Arbitration\n");
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMAL_BIT);
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMIF_BIT);
-			pch_i2c_init(adap);
-			return -EAGAIN;
-		} else { /* wait-event timeout */
-			pch_err(adap, "%s(L.%d):wait-event timeout\n",
-				__func__, __LINE__);
-			pch_i2c_stop(adap);
-			pch_i2c_init(adap);
-			return -ETIME;
-		}
+		rtn = pch_i2c_wait_for_check_xfer(adap);
+		if (rtn)
+			return rtn;
+
+		addr_8_lsb = (addr & I2C_ADDR_MSK);
+		iowrite32(addr_8_lsb, p + PCH_I2CDR);
 	} else {
 		/* set 7 bit slave address and R/W bit as 0 */
 		iowrite32(addr << 1, p + PCH_I2CDR);
@@ -451,50 +461,21 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 			pch_i2c_start(adap);
 	}
 
-	rtn = pch_i2c_wait_for_xfer_complete(adap);
-	if (rtn == 0) {
-		if (pch_i2c_getack(adap)) {
-			pch_dbg(adap, "Receive NACK for slave address"
-				"setting\n");
-			return -EIO;
-		}
-	} else if (rtn == -EIO) { /* Arbitration Lost */
-		pch_err(adap, "Lost Arbitration\n");
-		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
-		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
-		pch_i2c_init(adap);
-		return -EAGAIN;
-	} else { /* wait-event timeout */
-		pch_err(adap, "%s(L.%d):wait-event timeout\n",
-			__func__, __LINE__);
-		pch_i2c_stop(adap);
-		pch_i2c_init(adap);
-		return -ETIME;
-	}
+	rtn = pch_i2c_wait_for_check_xfer(adap);
+	if (rtn)
+		return rtn;
 
 	for (wrcount = 0; wrcount < length; ++wrcount) {
 		/* write buffer value to I2C data register */
 		iowrite32(buf[wrcount], p + PCH_I2CDR);
 		pch_dbg(adap, "writing %x to Data register\n", buf[wrcount]);
 
-		rtn = pch_i2c_wait_for_xfer_complete(adap);
-		if (rtn == 0) {
-			if (pch_i2c_getack(adap)) {
-				pch_dbg(adap, "Receive NACK for slave address"
-					"setting\n");
-				return -EIO;
-			}
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMCF_BIT);
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMIF_BIT);
-		} else { /* wait-event timeout */
-			pch_err(adap, "%s(L.%d):wait-event timeout\n",
-				__func__, __LINE__);
-			pch_i2c_stop(adap);
-			pch_i2c_init(adap);
-			return -ETIME;
-		}
+		rtn = pch_i2c_wait_for_check_xfer(adap);
+		if (rtn)
+			return rtn;
+
+		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMCF_BIT);
+		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
 	}
 
 	/* check if this is the last message */
@@ -582,56 +563,21 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		if (first)
 			pch_i2c_start(adap);
 
-		rtn = pch_i2c_wait_for_xfer_complete(adap);
-		if (rtn == 0) {
-			if (pch_i2c_getack(adap)) {
-				pch_dbg(adap, "Receive NACK for slave address"
-					"setting\n");
-				return -EIO;
-			}
-			addr_8_lsb = (addr & I2C_ADDR_MSK);
-			iowrite32(addr_8_lsb, p + PCH_I2CDR);
-		} else if (rtn == -EIO) { /* Arbitration Lost */
-			pch_err(adap, "Lost Arbitration\n");
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMAL_BIT);
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMIF_BIT);
-			pch_i2c_init(adap);
-			return -EAGAIN;
-		} else { /* wait-event timeout */
-			pch_err(adap, "%s(L.%d):wait-event timeout\n",
-				__func__, __LINE__);
-			pch_i2c_stop(adap);
-			pch_i2c_init(adap);
-			return -ETIME;
-		}
+		rtn = pch_i2c_wait_for_check_xfer(adap);
+		if (rtn)
+			return rtn;
+
+		addr_8_lsb = (addr & I2C_ADDR_MSK);
+		iowrite32(addr_8_lsb, p + PCH_I2CDR);
+
 		pch_i2c_restart(adap);
-		rtn = pch_i2c_wait_for_xfer_complete(adap);
-		if (rtn == 0) {
-			if (pch_i2c_getack(adap)) {
-				pch_dbg(adap, "Receive NACK for slave address"
-					"setting\n");
-				return -EIO;
-			}
-			addr_2_msb |= I2C_RD;
-			iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK,
-				  p + PCH_I2CDR);
-		} else if (rtn == -EIO) { /* Arbitration Lost */
-			pch_err(adap, "Lost Arbitration\n");
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMAL_BIT);
-			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
-				   I2CMIF_BIT);
-			pch_i2c_init(adap);
-			return -EAGAIN;
-		} else { /* wait-event timeout */
-			pch_err(adap, "%s(L.%d):wait-event timeout\n",
-				__func__, __LINE__);
-			pch_i2c_stop(adap);
-			pch_i2c_init(adap);
-			return -ETIME;
-		}
+
+		rtn = pch_i2c_wait_for_check_xfer(adap);
+		if (rtn)
+			return rtn;
+
+		addr_2_msb |= I2C_RD;
+		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
 	} else {
 		/* 7 address bits + R/W bit */
 		addr = (((addr) << 1) | (I2C_RD));
@@ -642,26 +588,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	if (first)
 		pch_i2c_start(adap);
 
-	rtn = pch_i2c_wait_for_xfer_complete(adap);
-	if (rtn == 0) {
-		if (pch_i2c_getack(adap)) {
-			pch_dbg(adap, "Receive NACK for slave address"
-				"setting\n");
-			return -EIO;
-		}
-	} else if (rtn == -EIO) { /* Arbitration Lost */
-		pch_err(adap, "Lost Arbitration\n");
-		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
-		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
-		pch_i2c_init(adap);
-		return -EAGAIN;
-	} else { /* wait-event timeout */
-		pch_err(adap, "%s(L.%d):wait-event timeout\n",
-			__func__, __LINE__);
-		pch_i2c_stop(adap);
-		pch_i2c_init(adap);
-		return -ETIME;
-	}
+	rtn = pch_i2c_wait_for_check_xfer(adap);
+	if (rtn)
+		return rtn;
 
 	if (length == 0) {
 		pch_i2c_stop(adap);
@@ -680,21 +609,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 			if (loop != 1)
 				read_index++;
 
-			rtn = pch_i2c_wait_for_xfer_complete(adap);
-			if (rtn == 0) {
-				if (pch_i2c_getack(adap)) {
-					pch_dbg(adap, "Receive NACK for slave"
-						"address setting\n");
-					return -EIO;
-				}
-			} else { /* wait-event timeout */
-				pch_err(adap, "%s(L.%d):wait-event timeout\n",
-					__func__, __LINE__);
-				pch_i2c_stop(adap);
-				pch_i2c_init(adap);
-				return -ETIME;
-			}
-
+			rtn = pch_i2c_wait_for_check_xfer(adap);
+			if (rtn)
+				return rtn;
 		}	/* end for */
 
 		pch_i2c_sendnack(adap);
@@ -704,20 +621,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		if (length != 1)
 			read_index++;
 
-		rtn = pch_i2c_wait_for_xfer_complete(adap);
-		if (rtn == 0) {
-			if (pch_i2c_getack(adap)) {
-				pch_dbg(adap, "Receive NACK for slave"
-					"address setting\n");
-				return -EIO;
-			}
-		} else { /* wait-event timeout */
-			pch_err(adap, "%s(L.%d):wait-event timeout\n",
-				__func__, __LINE__);
-			pch_i2c_stop(adap);
-			pch_i2c_init(adap);
-			return -ETIME;
-		}
+		rtn = pch_i2c_wait_for_check_xfer(adap);
+		if (rtn)
+			return rtn;
 
 		if (last)
 			pch_i2c_stop(adap);
-- 
1.7.4.4

