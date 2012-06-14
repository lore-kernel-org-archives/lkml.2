Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2FNK0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:26:16 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52494 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595Ab2FNKXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:20 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 08/17] i2c: omap: switch over to do {} while loop
Date: Thu, 14 Jun 2012 13:20:41 +0300
Message-Id: <1339669250-9183-9-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this will make sure that we execute at least once.
No functional changes otherwise.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 381bb36..f978b14 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -870,20 +870,29 @@ omap_i2c_isr(int this_irq, void *dev_id)
 	struct omap_i2c_dev *dev = dev_id;
 	u16 bits;
 	u16 stat;
-	int err, count = 0;
+	int err = 0, count = 0;
 
 	if (pm_runtime_suspended(dev->dev))
 		return IRQ_NONE;
 
-	bits = omap_i2c_read_reg(dev, OMAP_I2C_IE_REG);
-	while ((stat = (omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG))) & bits) {
+	do {
+		bits = omap_i2c_read_reg(dev, OMAP_I2C_IE_REG);
+		stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
+		stat &= bits;
+
+		if (!stat) {
+			/* my work here is done */
+			omap_i2c_complete_cmd(dev, err);
+			return IRQ_HANDLED;
+		}
+
 		dev_dbg(dev->dev, "IRQ (ISR = 0x%04x)\n", stat);
 		if (count++ == 100) {
 			dev_warn(dev->dev, "Too much work in one IRQ\n");
-			break;
+			omap_i2c_complete_cmd(dev, err);
+			return IRQ_HANDLED;
 		}
 
-		err = 0;
 complete:
 		/*
 		 * Ack the stat in one go, but [R/X]DR and [R/X]RDY should be
@@ -987,7 +996,7 @@ complete:
 			dev_err(dev->dev, "Transmit underflow\n");
 			dev->cmd_err |= OMAP_I2C_STAT_XUDF;
 		}
-	}
+	} while (stat);
 
 	return count ? IRQ_HANDLED : IRQ_NONE;
 }
-- 
1.7.10.4

