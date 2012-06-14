Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2FNKXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:23:16 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:58399 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496Ab2FNKXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:12 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 05/17] i2c: omap: split out [XR]DR and [XR]RDY
Date: Thu, 14 Jun 2012 13:20:38 +0300
Message-Id: <1339669250-9183-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While they do pretty much the same thing, there
are a few peculiarities. Specially WRT erratas,
it's best to split those out and re-factor the
read/write loop to another function which both
cases call.

This last part will be done on another patch.

While at that, also avoid an unncessary register
read since dev->fifo_len will always contain the
correct amount of data to be transferred.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |  126 ++++++++++++++++++++++++++++++-----------
 1 file changed, 92 insertions(+), 34 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index fa9ddb6..0661ca1 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -844,36 +844,62 @@ complete:
 			return IRQ_HANDLED;
 		}
 
-		if (stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR)) {
+		if (stat & OMAP_I2C_STAT_RDR) {
 			u8 num_bytes = 1;
 
+			if (dev->fifo_size)
+				num_bytes = dev->fifo_size;
+
+			while (num_bytes--) {
+				if (!dev->buf_len) {
+					dev_err(dev->dev,
+							"RDR IRQ while no data"
+							" requested\n");
+					break;
+				}
+
+				w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
+				*dev->buf++ = w;
+				dev->buf_len--;
+
+				/*
+				 * Data reg in 2430, omap3 and
+				 * omap4 is 8 bit wide
+				 */
+				if (dev->flags &
+						OMAP_I2C_FLAG_16BIT_DATA_REG) {
+					if (dev->buf_len) {
+						*dev->buf++ = w >> 8;
+						dev->buf_len--;
+					}
+				}
+			}
+
 			if (dev->errata & I2C_OMAP_ERRATA_I207)
 				i2c_omap_errata_i207(dev, stat);
 
-			if (dev->fifo_size) {
-				if (stat & OMAP_I2C_STAT_RRDY)
-					num_bytes = dev->fifo_size;
-				else    /* read RXSTAT on RDR interrupt */
-					num_bytes = (omap_i2c_read_reg(dev,
-							OMAP_I2C_BUFSTAT_REG)
-							>> 8) & 0x3F;
-			}
+			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_RDR);
+			continue;
+		}
+
+		if (stat & OMAP_I2C_STAT_RRDY) {
+			u8 num_bytes = 1;
+
+			if (dev->fifo_size)
+				num_bytes = dev->fifo_size;
+
 			while (num_bytes--) {
 				if (!dev->buf_len) {
-					if (stat & OMAP_I2C_STAT_RRDY)
-						dev_err(dev->dev,
+					dev_err(dev->dev,
 							"RRDY IRQ while no data"
-								" requested\n");
-					if (stat & OMAP_I2C_STAT_RDR)
-						dev_err(dev->dev,
-							"RDR IRQ while no data"
-								" requested\n");
+							" requested\n");
 					break;
 				}
 
 				w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
 				*dev->buf++ = w;
 				dev->buf_len--;
+
 				/*
 				 * Data reg in 2430, omap3 and
 				 * omap4 is 8 bit wide
@@ -886,36 +912,68 @@ complete:
 					}
 				}
 			}
-			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_RRDY |
-						OMAP_I2C_STAT_RDR));
+
+			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_RRDY);
 			continue;
 		}
 
-		if (stat & (OMAP_I2C_STAT_XRDY | OMAP_I2C_STAT_XDR)) {
+		if (stat & OMAP_I2C_STAT_XDR) {
 			u8 num_bytes = 1;
-			if (dev->fifo_size) {
-				if (stat & OMAP_I2C_STAT_XRDY)
-					num_bytes = dev->fifo_size;
-				else    /* read TXSTAT on XDR interrupt */
-					num_bytes = omap_i2c_read_reg(dev,
-							OMAP_I2C_BUFSTAT_REG)
-							& 0x3F;
+
+			if (dev->fifo_size)
+				num_bytes = dev->fifo_size;
+
+			while (num_bytes--) {
+				if (!dev->buf_len) {
+					dev_err(dev->dev,
+							"XDR IRQ while no "
+							"data to send\n");
+					break;
+				}
+
+				w = *dev->buf++;
+				dev->buf_len--;
+
+				/*
+				 * Data reg in 2430, omap3 and
+				 * omap4 is 8 bit wide
+				 */
+				if (dev->flags &
+						OMAP_I2C_FLAG_16BIT_DATA_REG) {
+					if (dev->buf_len) {
+						w |= *dev->buf++ << 8;
+						dev->buf_len--;
+					}
+				}
+
+				if ((dev->errata & I2C_OMAP3_1P153) &&
+				    errata_omap3_1p153(dev, &stat, &err))
+					goto complete;
+
+				omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
 			}
+
+			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XDR);
+			continue;
+		}
+
+		if (stat & OMAP_I2C_STAT_XRDY) {
+			u8 num_bytes = 1;
+
+			if (dev->fifo_size)
+				num_bytes = dev->fifo_size;
+
 			while (num_bytes--) {
 				if (!dev->buf_len) {
-					if (stat & OMAP_I2C_STAT_XRDY)
-						dev_err(dev->dev,
+					dev_err(dev->dev,
 							"XRDY IRQ while no "
 							"data to send\n");
-					if (stat & OMAP_I2C_STAT_XDR)
-						dev_err(dev->dev,
-							"XDR IRQ while no "
-							"data to send\n");
 					break;
 				}
 
 				w = *dev->buf++;
 				dev->buf_len--;
+
 				/*
 				 * Data reg in 2430, omap3 and
 				 * omap4 is 8 bit wide
@@ -934,8 +992,8 @@ complete:
 
 				omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
 			}
-			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_XRDY |
-						OMAP_I2C_STAT_XDR));
+
+			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XRDY);
 			continue;
 		}
 
-- 
1.7.10.4

