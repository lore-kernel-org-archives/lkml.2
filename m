Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1JXGwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 02:52:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39794 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1JXGwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 02:52:07 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Vikram Pandita <vikram.pandita@ti.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH ] i2c: omap: recover from Bus Busy condition
Date: Mon, 24 Oct 2011 12:21:58 +0530
Message-ID: <1319439118-3800-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vikram Pandita <vikram.pandita@ti.com>

    In case a peripheral is holding the DATA bus low, provide a 400Khz
    constant clock output using the TEST register.

    Also soft reset the I2C controller so that there is no stale state
    left in the HW state machine.

    A WARN_ON() will be generated when a BB timeout happens.

Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 2dfb631..b6fcd08 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -143,7 +143,6 @@ enum {
 #define OMAP_I2C_SCLH_HSSCLH	8
 
 /* I2C System Test Register (OMAP_I2C_SYSTEST): */
-#ifdef DEBUG
 #define OMAP_I2C_SYSTEST_ST_EN		(1 << 15)	/* System test enable */
 #define OMAP_I2C_SYSTEST_FREE		(1 << 14)	/* Free running mode */
 #define OMAP_I2C_SYSTEST_TMODE_MASK	(3 << 12)	/* Test mode select */
@@ -152,7 +151,6 @@ enum {
 #define OMAP_I2C_SYSTEST_SCL_O		(1 << 2)	/* SCL line drive out */
 #define OMAP_I2C_SYSTEST_SDA_I		(1 << 1)	/* SDA line sense in */
 #define OMAP_I2C_SYSTEST_SDA_O		(1 << 0)	/* SDA line drive out */
-#endif
 
 /* OCP_SYSSTATUS bit definitions */
 #define SYSS_RESETDONE_MASK		(1 << 0)
@@ -641,10 +639,23 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	struct omap_i2c_dev *dev = i2c_get_adapdata(adap);
 	int i;
 	int r;
+	u16 val;
 
 	omap_i2c_unidle(dev);
 
 	r = omap_i2c_wait_for_bb(dev);
+	/* If timeout, try to again check after soft reset of I2C block */
+	if (WARN_ON(r == -ETIMEDOUT)) {
+		/* Provide a permanent clock to recover the peripheral */
+		val = omap_i2c_read_reg(dev, OMAP_I2C_SYSTEST_REG);
+		val |= (OMAP_I2C_SYSTEST_ST_EN |
+				OMAP_I2C_SYSTEST_FREE |
+				(2 << OMAP_I2C_SYSTEST_TMODE_SHIFT));
+		omap_i2c_write_reg(dev, OMAP_I2C_SYSTEST_REG, val);
+		msleep(1);
+		omap_i2c_init(dev);
+		r = omap_i2c_wait_for_bb(dev);
+	}
 	if (r < 0)
 		goto out;
 
-- 
1.7.1

