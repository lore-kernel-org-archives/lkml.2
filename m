Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1JFGvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:51:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:27121 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab1JFGvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:51:41 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/7 v3] i2c-eg20t: Fix bus-idle waiting issue
Date: Thu,  6 Oct 2011 15:56:25 +0900
Message-Id: <1317884192-10694-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when checking whether bus is idle or not,
if timeout occurs,
this function always returns success(zero).
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 6565009..35d819a 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -275,23 +275,23 @@ static s32 pch_i2c_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
 				     s32 timeout)
 {
 	void __iomem *p = adap->pch_base_address;
+	ktime_t ns_val;
+
+	if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
+		return 0;
 
 	/* MAX timeout value is timeout*1000*1000nsec */
-	ktime_t ns_val = ktime_add_ns(ktime_get(), timeout*1000*1000);
+	ns_val = ktime_add_ns(ktime_get(), timeout*1000*1000);
 	do {
-		if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
-			break;
 		msleep(20);
+		if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
+			return 0;
 	} while (ktime_lt(ktime_get(), ns_val));
 
 	pch_dbg(adap, "I2CSR = %x\n", ioread32(p + PCH_I2CSR));
+	pch_err(adap, "%s: Timeout Error.return%d\n", __func__, -ETIME);
 
-	if (timeout == 0) {
-		pch_err(adap, "%s: Timeout Error.return%d\n", __func__, -ETIME);
-		return -ETIME;
-	}
-
-	return 0;
+	return -ETIME;
 }
 
 /**
-- 
1.7.4.4

