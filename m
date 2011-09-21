Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1IUHz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:55:28 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33217 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab1IUHyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:54:04 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Qi Wang <qi.wang@intel.com>, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 7/7] i2c-eg20t: Add initialize processing in case i2c-error occurs
Date: Wed, 21 Sep 2011 16:51:49 +0900
Message-Id: <1316591509-4433-7-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case disconnecting physical connection,
need to initialize i2c device for retry access.
This patch adds initialize process in case bus-idle fails and Lost arbitration.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 6d6baf0..b594378 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -288,6 +288,7 @@ static s32 pch_i2c_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
 
 	if (!ktime_lt(ktime_get(), ns_val)) {
 		pch_err(adap, "%s: Timeout Error.return%d\n", __func__, -ETIME);
+		pch_i2c_init(adap);
 		return -ETIME;
 	}
 
@@ -432,6 +433,7 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 		pch_err(adap, "Lost Arbitration\n");
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
+		pch_i2c_init(adap);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
 		pch_i2c_stop(adap);
@@ -548,6 +550,7 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		pch_err(adap, "Lost Arbitration\n");
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
+		pch_i2c_init(adap);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
 		pch_i2c_stop(adap);
-- 
1.7.4.4

