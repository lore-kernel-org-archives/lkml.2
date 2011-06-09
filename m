Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1FICak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:30:40 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40606 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab1FICai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:30:38 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] i2c-eg20t : Support Combined R/W transfer mode
Date: Thu,  9 Jun 2011 11:29:29 +0900
Message-Id: <1307586569-14050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, Combined R/W transfer mode is not supported.
This patch enables Combined R/W transfer mode.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 838c21f..b2f94dc 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -672,25 +672,26 @@ static s32 pch_i2c_xfer(struct i2c_adapter *i2c_adap,
 	/* transfer not completed */
 	adap->pch_i2c_xfer_in_progress = true;
 
-	pmsg = &msgs[0];
-	pmsg->flags |= adap->pch_buff_mode_en;
-	status = pmsg->flags;
-	pch_dbg(adap,
-		"After invoking I2C_MODE_SEL :flag= 0x%x\n", status);
-	/* calculate sub address length and message length */
-	/* these are applicable only for buffer mode */
-	subaddrlen = pmsg->buf[0];
-	/* calculate actual message length excluding
-	 * the sub address fields */
-	msglen = (pmsg->len) - (subaddrlen + 1);
-	if (status & (I2C_M_RD)) {
-		pch_dbg(adap, "invoking pch_i2c_readbytes\n");
-		ret = pch_i2c_readbytes(i2c_adap, pmsg, (i + 1 == num),
-				   (i == 0));
-	} else {
-		pch_dbg(adap, "invoking pch_i2c_writebytes\n");
-		ret = pch_i2c_writebytes(i2c_adap, pmsg, (i + 1 == num),
-				    (i == 0));
+	for (i = 0; i < num; i++) {
+		pmsg = &msgs[i];
+		pmsg->flags |= adap->pch_buff_mode_en;
+		status = pmsg->flags;
+		pch_dbg(adap,
+			"After invoking I2C_MODE_SEL :flag= 0x%x\n", status);
+		/* calculate sub address length and message length */
+		/* these are applicable only for buffer mode */
+		subaddrlen = pmsg->buf[0];
+		/* calculate actual message length excluding
+		 * the sub address fields */
+		msglen = (pmsg->len) - (subaddrlen + 1);
+
+		if ((status & (I2C_M_RD)) != false) {
+			ret = pch_i2c_readbytes(i2c_adap, pmsg, (i + 1 == num),
+						(i == 0));
+		} else {
+			ret = pch_i2c_writebytes(i2c_adap, pmsg, (i + 1 == num),
+						 (i == 0));
+		}
 	}
 
 	adap->pch_i2c_xfer_in_progress = false;	/* transfer completed */
-- 
1.7.4

