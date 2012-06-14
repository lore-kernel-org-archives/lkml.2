Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2FNKXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:23:48 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:37612 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755742Ab2FNKXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:44 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 16/17] i2c: omap: simplify IRQ exit path
Date: Thu, 14 Jun 2012 13:20:49 +0300
Message-Id: <1339669250-9183-17-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of having multiple return points, use
a goto statement to make that clearer.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 5b78a73..6e75d03 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -889,33 +889,27 @@ omap_i2c_isr(int this_irq, void *dev_id)
 			stat &= ~(OMAP_I2C_STAT_RDR | OMAP_I2C_STAT_RRDY);
 		}
 
-		if (!stat) {
-			/* my work here is done */
-			omap_i2c_complete_cmd(dev, err);
-			return IRQ_HANDLED;
-		}
+		if (!stat)
+			goto out;
 
 		dev_dbg(dev->dev, "IRQ (ISR = 0x%04x)\n", stat);
 		if (count++ == 100) {
 			dev_warn(dev->dev, "Too much work in one IRQ\n");
-			omap_i2c_complete_cmd(dev, err);
-			return IRQ_HANDLED;
+			goto out;
 		}
 
 		if (stat & OMAP_I2C_STAT_NACK) {
 			dev_err(dev->dev, "No Acknowledge\n");
 			err |= OMAP_I2C_STAT_NACK;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
-			omap_i2c_complete_cmd(dev, err);
-			return IRQ_HANDLED;
+			goto out;
 		}
 
 		if (stat & OMAP_I2C_STAT_AL) {
 			dev_err(dev->dev, "Arbitration lost\n");
 			err |= OMAP_I2C_STAT_AL;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
-			omap_i2c_complete_cmd(dev, err);
-			return IRQ_HANDLED;
+			goto out;
 		}
 
 		/*
@@ -928,8 +922,7 @@ omap_i2c_isr(int this_irq, void *dev_id)
 						OMAP_I2C_STAT_XRDY |
 						OMAP_I2C_STAT_XDR |
 						OMAP_I2C_STAT_ARDY));
-			omap_i2c_complete_cmd(dev, err);
-			return IRQ_HANDLED;
+			goto out;
 		}
 
 		if (stat & OMAP_I2C_STAT_RDR) {
@@ -970,8 +963,7 @@ omap_i2c_isr(int this_irq, void *dev_id)
 				err |= OMAP_I2C_STAT_XUDF;
 				omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XUDF |
 						OMAP_I2C_STAT_XDR);
-				omap_i2c_complete_cmd(dev, err);
-				return IRQ_HANDLED;
+				goto out;
 			}
 
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XDR);
@@ -990,8 +982,7 @@ omap_i2c_isr(int this_irq, void *dev_id)
 				err |= OMAP_I2C_STAT_XUDF;
 				omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XUDF |
 						OMAP_I2C_STAT_XRDY);
-				omap_i2c_complete_cmd(dev, err);
-				return IRQ_HANDLED;
+				goto out;
 			}
 
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XRDY);
@@ -1002,19 +993,19 @@ omap_i2c_isr(int this_irq, void *dev_id)
 			dev_err(dev->dev, "Receive overrun\n");
 			err |= OMAP_I2C_STAT_ROVR;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_ROVR);
-			omap_i2c_complete_cmd(dev, err);
-			return IRQ_HANDLED;
+			goto out;
 		}
 
 		if (stat & OMAP_I2C_STAT_XUDF) {
 			dev_err(dev->dev, "Transmit underflow\n");
 			err |= OMAP_I2C_STAT_XUDF;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XUDF);
-			omap_i2c_complete_cmd(dev, err);
-			return IRQ_HANDLED;
+			goto out;
 		}
 	} while (stat);
 
+out:
+	omap_i2c_complete_cmd(dev, err);
 	return IRQ_HANDLED;
 }
 
-- 
1.7.10.4

