Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2DSGkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:40:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54830 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab2DSGkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:40:03 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/2] i2c-eg20t: Merge 2 functions
Date: Thu, 19 Apr 2012 15:38:05 +0900
Message-Id: <1334817485-7121-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1334817485-7121-1-git-send-email-tomoya.rohm@gmail.com>
References: <1334817485-7121-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By previous patch(1/2), pch_i2c_wait_for_xfer_complete can be merged
to pch_i2c_wait_for_check_xfer.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/i2c/busses/i2c-eg20t.c |   65 +++++++++++++--------------------------
 1 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 72bd23c..c0dde69 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -310,33 +310,6 @@ static void pch_i2c_start(struct i2c_algo_pch_data *adap)
 }
 
 /**
- * pch_i2c_wait_for_xfer_complete() - initiates a wait for the tx complete event
- * @adap:	Pointer to struct i2c_algo_pch_data.
- */
-static s32 pch_i2c_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
-{
-	long ret;
-	ret = wait_event_timeout(pch_event,
-			(adap->pch_event_flag != 0), msecs_to_jiffies(1000));
-
-	if (ret == 0) {
-		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
-		adap->pch_event_flag = 0;
-		return -ETIMEDOUT;
-	}
-
-	if (adap->pch_event_flag & I2C_ERROR_MASK) {
-		pch_err(adap, "error bits set: %x\n", adap->pch_event_flag);
-		adap->pch_event_flag = 0;
-		return -EIO;
-	}
-
-	adap->pch_event_flag = 0;
-
-	return 0;
-}
-
-/**
  * pch_i2c_getack() - to confirm ACK/NACK
  * @adap:	Pointer to struct i2c_algo_pch_data.
  */
@@ -368,27 +341,33 @@ static void pch_i2c_stop(struct i2c_algo_pch_data *adap)
 
 static int pch_i2c_wait_for_check_xfer(struct i2c_algo_pch_data *adap)
 {
-	int rtn;
-
-	rtn = pch_i2c_wait_for_xfer_complete(adap);
-	if (rtn == 0) {
-		if (pch_i2c_getack(adap)) {
-			pch_dbg(adap, "Receive NACK for slave address"
-				"setting\n");
-			return -EIO;
-		}
-	} else if (rtn == -EIO) { /* Arbitration Lost */
+	long ret;
+
+	ret = wait_event_timeout(pch_event,
+			(adap->pch_event_flag != 0), msecs_to_jiffies(1000));
+	if (!ret) {
+		pch_err(adap, "%s:wait-event timeout\n", __func__);
+		adap->pch_event_flag = 0;
+		pch_i2c_stop(adap);
+		pch_i2c_init(adap);
+		return -ETIMEDOUT;
+	}
+
+	if (adap->pch_event_flag & I2C_ERROR_MASK) {
 		pch_err(adap, "Lost Arbitration\n");
+		adap->pch_event_flag = 0;
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
 		pch_i2c_init(adap);
 		return -EAGAIN;
-	} else { /* wait-event timeout */
-		pch_err(adap, "%s(L.%d):wait-event timeout\n",
-			__func__, __LINE__);
-		pch_i2c_stop(adap);
-		pch_i2c_init(adap);
-		return -ETIME;
+	}
+
+	adap->pch_event_flag = 0;
+
+	if (pch_i2c_getack(adap)) {
+		pch_dbg(adap, "Receive NACK for slave address"
+			"setting\n");
+		return -EIO;
 	}
 
 	return 0;
-- 
1.7.4.4

