Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2BTIOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:14:23 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:45243 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab2BTIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:14:21 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH v2] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to reduce wait time
Date: Mon, 20 Feb 2012 09:14:16 +0100
Message-Id: <1329725656-32715-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you insert several i2c transfers, the driver might start the next one
while the STOP bit of the previous transfer is still on the bus, marking
the bus as busy.
pch_i2c_wait_for_bus_idle does an msleep(20) delaying the next transfer
by >=20ms. Reduce wait time by actively waiting 5 us once, then using
usleep_range.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Changes in v2:
* Remove redundant code

 drivers/i2c/busses/i2c-eg20t.c |   42 ++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index ca88776..1eb60ca 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -271,30 +271,36 @@ static inline bool ktime_lt(const ktime_t cmp1, const ktime_t cmp2)
 /**
  * pch_i2c_wait_for_bus_idle() - check the status of bus.
  * @adap:	Pointer to struct i2c_algo_pch_data.
- * @timeout:	waiting time counter (us).
+ * @timeout:	waiting time counter (ms).
  */
 static s32 pch_i2c_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
 				     s32 timeout)
 {
 	void __iomem *p = adap->pch_base_address;
-	ktime_t ns_val;
+	int schedule = 0;
+	unsigned long end = jiffies + msecs_to_jiffies(timeout);
+
+	while (ioread32(p + PCH_I2CSR) & I2CMBB_BIT) {
+		if (time_after(jiffies, end)) {
+			pch_dbg(adap, "I2CSR = %x\n", ioread32(p + PCH_I2CSR));
+			pch_err(adap, "%s: Timeout Error.return%d\n",
+					__func__, -ETIME);
+			pch_i2c_init(adap);
 
-	if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
-		return 0;
+			return -ETIME;
+		}
 
-	/* MAX timeout value is timeout*1000*1000nsec */
-	ns_val = ktime_add_ns(ktime_get(), timeout*1000*1000);
-	do {
-		msleep(20);
-		if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
-			return 0;
-	} while (ktime_lt(ktime_get(), ns_val));
+		if (!schedule)
+			/* Retry after some usecs */
+			udelay(5);
+		else
+			/* Wait a bit more without consuming CPU */
+			usleep_range(20, 1000);
 
-	pch_dbg(adap, "I2CSR = %x\n", ioread32(p + PCH_I2CSR));
-	pch_err(adap, "%s: Timeout Error.return%d\n", __func__, -ETIME);
-	pch_i2c_init(adap);
+		schedule = 1;
+	}
 
-	return -ETIME;
+	return 0;
 }
 
 /**
-- 
1.7.3.4

