Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2FNQ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:26:55 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:36046 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570Ab2FNQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:26:52 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 06/17] i2c: omap: improve 1p153 errata handling
Date: Thu, 14 Jun 2012 19:24:16 +0300
Message-Id: <1339691067-919-7-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339691067-919-1-git-send-email-balbi@ti.com>
References: <1339691067-919-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it not depend on ISR's local variables
in order to make it easier to re-factor the
transmit data loop.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   45 ++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 0661ca1..41cec32 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -768,21 +768,24 @@ omap_i2c_omap1_isr(int this_irq, void *dev_id)
  * data to DATA_REG. Otherwise some data bytes can be lost while transferring
  * them from the memory to the I2C interface.
  */
-static int errata_omap3_1p153(struct omap_i2c_dev *dev, u16 *stat, int *err)
+static int errata_omap3_1p153(struct omap_i2c_dev *dev)
 {
 	unsigned long timeout = 10000;
+	u16 stat;
 
-	while (--timeout && !(*stat & OMAP_I2C_STAT_XUDF)) {
-		if (*stat & (OMAP_I2C_STAT_NACK | OMAP_I2C_STAT_AL)) {
+	do {
+		stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
+		if (stat & OMAP_I2C_STAT_XUDF)
+			break;
+
+		if (stat & (OMAP_I2C_STAT_NACK | OMAP_I2C_STAT_AL)) {
 			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_XRDY |
 					OMAP_I2C_STAT_XDR));
-			*err |= OMAP_I2C_STAT_XUDF;
 			return -ETIMEDOUT;
 		}
 
 		cpu_relax();
-		*stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
-	}
+	} while (--timeout);
 
 	if (!timeout) {
 		dev_err(dev->dev, "timeout waiting on XUDF bit\n");
@@ -946,9 +949,18 @@ complete:
 					}
 				}
 
-				if ((dev->errata & I2C_OMAP3_1P153) &&
-				    errata_omap3_1p153(dev, &stat, &err))
-					goto complete;
+				if (dev->errata & I2C_OMAP3_1P153) {
+					int ret;
+
+					ret = errata_omap3_1p153(dev);
+					stat = omap_i2c_read_reg(dev,
+							OMAP_I2C_STAT_REG);
+
+					if (ret < 0) {
+						err |= OMAP_I2C_STAT_XUDF;
+						goto complete;
+					}
+				}
 
 				omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
 			}
@@ -986,9 +998,18 @@ complete:
 					}
 				}
 
-				if ((dev->errata & I2C_OMAP3_1P153) &&
-				    errata_omap3_1p153(dev, &stat, &err))
-					goto complete;
+				if (dev->errata & I2C_OMAP3_1P153) {
+					int ret;
+
+					ret = errata_omap3_1p153(dev);
+					stat = omap_i2c_read_reg(dev,
+							OMAP_I2C_STAT_REG);
+
+					if (ret < 0) {
+						err |= OMAP_I2C_STAT_XUDF;
+						goto complete;
+					}
+				}
 
 				omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
 			}
-- 
1.7.10.4

