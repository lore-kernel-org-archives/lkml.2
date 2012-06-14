Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2FNK0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:26:15 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:42661 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755672Ab2FNKXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:25 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/17] i2c: omap: get rid of the "complete" label
Date: Thu, 14 Jun 2012 13:20:43 +0300
Message-Id: <1339669250-9183-11-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can ack stat and complete the command from
the errata handling itself.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index c00ba7d..c20c45f 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -893,7 +893,6 @@ omap_i2c_isr(int this_irq, void *dev_id)
 			return IRQ_HANDLED;
 		}
 
-complete:
 		if (stat & OMAP_I2C_STAT_NACK) {
 			dev_err(dev->dev, "No Acknowledge\n");
 			err |= OMAP_I2C_STAT_NACK;
@@ -958,10 +957,12 @@ complete:
 				num_bytes = dev->fifo_size;
 
 			ret = omap_i2c_transmit_data(dev, num_bytes, true);
-			stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
 			if (ret < 0) {
 				err |= OMAP_I2C_STAT_XUDF;
-				goto complete;
+				omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XUDF |
+						OMAP_I2C_STAT_XDR);
+				omap_i2c_complete_cmd(dev, err);
+				return IRQ_HANDLED;
 			}
 
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XDR);
@@ -976,10 +977,12 @@ complete:
 				num_bytes = dev->fifo_size;
 
 			ret = omap_i2c_transmit_data(dev, num_bytes, false);
-			stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
 			if (ret < 0) {
 				err |= OMAP_I2C_STAT_XUDF;
-				goto complete;
+				omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XUDF |
+						OMAP_I2C_STAT_XRDY);
+				omap_i2c_complete_cmd(dev, err);
+				return IRQ_HANDLED;
 			}
 
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XRDY);
-- 
1.7.10.4

