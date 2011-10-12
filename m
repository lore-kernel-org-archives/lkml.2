Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab1JLEOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:14:40 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:4794 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab1JLENV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:13:21 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        jeffchu@broadcom.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 3/7 v2] i2c-eg20t: Fix 10bit access issue
Date: Wed, 12 Oct 2011 13:13:02 +0900
Message-Id: <1318392786-23610-3-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Jeffrey (Sheng-Hui) Chu <jeffchu@broadcom.com>
Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
V2: Update Jeffrey's comments.
---
 drivers/i2c/busses/i2c-eg20t.c |   65 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 5ecbee0..6ee719c 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -64,6 +64,7 @@
 #define TEN_BIT_ADDR_DEFAULT	0xF000
 #define TEN_BIT_ADDR_MASK	0xF0
 #define PCH_START		0x0020
+#define PCH_RESTART		0x0004
 #define PCH_ESR_START		0x0001
 #define PCH_BUFF_START		0x1
 #define PCH_REPSTART		0x0004
@@ -411,7 +412,7 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 	}
 
 	if (msgs->flags & I2C_M_TEN) {
-		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
+		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7) & 0x06;
 		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
 		if (first)
 			pch_i2c_start(adap);
@@ -483,6 +484,19 @@ static void pch_i2c_sendnack(struct i2c_algo_pch_data *adap)
 }
 
 /**
+ * pch_i2c_restart() - Generate I2C restart condition in normal mode.
+ * @adap:	Pointer to struct i2c_algo_pch_data.
+ *
+ * Generate I2C restart condition in normal mode by setting I2CCTL.I2CRSTA.
+ */
+static void pch_i2c_restart(struct i2c_algo_pch_data *adap)
+{
+	void __iomem *p = adap->pch_base_address;
+	pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
+	pch_setbit(adap->pch_base_address, PCH_I2CCTL, PCH_RESTART);
+}
+
+/**
  * pch_i2c_readbytes() - read data  from I2C bus in normal mode.
  * @i2c_adap:	Pointer to the struct i2c_adapter.
  * @msgs:	Pointer to i2c_msg structure.
@@ -499,6 +513,7 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	u32 length;
 	u32 addr;
 	u32 addr_2_msb;
+	u32 addr_8_lsb;
 	void __iomem *p = adap->pch_base_address;
 
 	length = msgs->len;
@@ -514,9 +529,55 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	}
 
 	if (msgs->flags & I2C_M_TEN) {
-		addr_2_msb = (((addr & I2C_MSB_2B_MSK) >> 7) | (I2C_RD));
+		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
 		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
+		if (first)
+			pch_i2c_start(adap);
 
+		rtn = pch_i2c_wait_for_xfer_complete(adap);
+		if (rtn == 0) {
+			if (pch_i2c_getack(adap)) {
+				pch_dbg(adap, "Receive NACK for slave address"
+					"setting\n");
+				return -EIO;
+			}
+			addr_8_lsb = (addr & I2C_ADDR_MSK);
+			iowrite32(addr_8_lsb, p + PCH_I2CDR);
+		} else if (rtn == -EIO) { /* Arbitration Lost */
+			pch_err(adap, "Lost Arbitration\n");
+			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
+				   I2CMAL_BIT);
+			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
+				   I2CMIF_BIT);
+			pch_i2c_init(adap);
+			return -EAGAIN;
+		} else { /* wait-event timeout */
+			pch_i2c_stop(adap);
+			return -ETIME;
+		}
+		pch_i2c_restart(adap);
+		rtn = pch_i2c_wait_for_xfer_complete(adap);
+		if (rtn == 0) {
+			if (pch_i2c_getack(adap)) {
+				pch_dbg(adap, "Receive NACK for slave address"
+					"setting\n");
+				return -EIO;
+			}
+			addr_2_msb |= I2C_RD;
+			iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK,
+				  p + PCH_I2CDR);
+		} else if (rtn == -EIO) { /* Arbitration Lost */
+			pch_err(adap, "Lost Arbitration\n");
+			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
+				   I2CMAL_BIT);
+			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
+				   I2CMIF_BIT);
+			pch_i2c_init(adap);
+			return -EAGAIN;
+		} else { /* wait-event timeout */
+			pch_i2c_stop(adap);
+			return -ETIME;
+		}
 	} else {
 		/* 7 address bits + R/W bit */
 		addr = (((addr) << 1) | (I2C_RD));
-- 
1.7.4.4

