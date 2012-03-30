Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543Ab2C3Pup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:50:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54444 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934339Ab2C3PuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:17 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 02/16] OMAP : I2C : Remove reset at init
Date: Fri, 30 Mar 2012 21:19:57 +0530
Message-ID: <1333122611-29953-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
References: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset in the driver at init is not needed anymore as the
following patch has removed the HWMOD_INIT_NO_RESET flag.
6d3c55f [OMAP: hwmod: fix the i2c-reset timeout during bootup]

This patch does the following
-removes the reset from the probe and implements a omap_i2c_reset
 function to reset.
- Reset is removed from omap_i2c_init, which was called
 not only during probe, but also after time out and error handling.
 omap_i2c_reset is added in those places to effect the reset.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 4f4188d..a115d2c 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -269,15 +269,9 @@ static inline u16 omap_i2c_read_reg(struct omap_i2c_dev *i2c_dev, int reg)
 				(i2c_dev->regs[reg] << i2c_dev->reg_shift));
 }
 
-static int omap_i2c_init(struct omap_i2c_dev *dev)
+static int omap_i2c_reset(struct omap_i2c_dev *dev)
 {
-	u16 psc = 0, scll = 0, sclh = 0, buf = 0;
-	u16 fsscll = 0, fssclh = 0, hsscll = 0, hssclh = 0;
-	unsigned long fclk_rate = 12000000;
 	unsigned long timeout;
-	unsigned long internal_clk = 0;
-	struct clk *fclk;
-
 	if (dev->rev >= OMAP_I2C_OMAP1_REV_2) {
 		/* Disable I2C controller before soft reset */
 		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG,
@@ -325,6 +319,16 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 							dev->westate);
 		}
 	}
+}
+
+static int omap_i2c_init(struct omap_i2c_dev *dev)
+{
+	u16 psc = 0, scll = 0, sclh = 0, buf = 0;
+	u16 fsscll = 0, fssclh = 0, hsscll = 0, hssclh = 0;
+	unsigned long fclk_rate = 12000000;
+	unsigned long internal_clk = 0;
+	struct clk *fclk;
+
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
 
 	if (dev->flags & OMAP_I2C_FLAG_ALWAYS_ARMXOR_CLK) {
@@ -549,6 +553,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	if (r == 0) {
 		dev_err(dev->dev, "controller timed out\n");
 		omap_i2c_init(dev);
+		omap_i2c_reset(dev);
 		return -ETIMEDOUT;
 	}
 
@@ -559,6 +564,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	if (dev->cmd_err & (OMAP_I2C_STAT_AL | OMAP_I2C_STAT_ROVR |
 			    OMAP_I2C_STAT_XUDF)) {
 		omap_i2c_init(dev);
+		omap_i2c_reset(dev);
 		return -EIO;
 	}
 
-- 
1.7.1

