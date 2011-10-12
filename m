Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1JLEN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:13:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:4824 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab1JLENX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:13:23 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        jeffchu@broadcom.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 7/7 v4] i2c-eg20t: Add initialize processing in case i2c-error occurs
Date: Wed, 12 Oct 2011 13:13:06 +0900
Message-Id: <1318392786-23610-7-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case disconnecting physical connection,
need to initialize i2c device for retry access.
This patch adds initialize process in case bus-idle fails and Lost arbitration.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index e25b8eb..5521099 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -292,6 +292,7 @@ static s32 pch_i2c_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
 
 	pch_dbg(adap, "I2CSR = %x\n", ioread32(p + PCH_I2CSR));
 	pch_err(adap, "%s: Timeout Error.return%d\n", __func__, -ETIME);
+	pch_i2c_init(adap);
 
 	return -ETIME;
 }
@@ -459,6 +460,7 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 		pch_err(adap, "Lost Arbitration\n");
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
+		pch_i2c_init(adap);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
 		pch_i2c_stop(adap);
@@ -637,6 +639,7 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		pch_err(adap, "Lost Arbitration\n");
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
+		pch_i2c_init(adap);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
 		pch_i2c_stop(adap);
-- 
1.7.4.4

