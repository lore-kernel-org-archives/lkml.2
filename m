Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2FNKXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:23:21 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:47468 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755574Ab2FNKXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:17 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 07/17] i2c: omap: re-factor receive/transmit data loop
Date: Thu, 14 Jun 2012 13:20:40 +0300
Message-Id: <1339669250-9183-8-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

re-factor the common parts to a separate function,
so that code is easier to read and understand.

No functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |  208 +++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 124 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 52861c2..381bb36 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -795,12 +795,81 @@ static int errata_omap3_1p153(struct omap_i2c_dev *dev)
 	return 0;
 }
 
+static void omap_i2c_receive_data(struct omap_i2c_dev *dev, u8 num_bytes,
+		bool is_rdr)
+{
+	u16		w;
+
+	while (num_bytes--) {
+		if (!dev->buf_len) {
+			dev_err(dev->dev, "%s without data",
+					is_rdr ? "RDR" : "RRDY");
+			break;
+		}
+
+		w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
+		*dev->buf++ = w;
+		dev->buf_len--;
+
+		/*
+		 * Data reg in 2430, omap3 and
+		 * omap4 is 8 bit wide
+		 */
+		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
+			if (dev->buf_len) {
+				*dev->buf++ = w >> 8;
+				dev->buf_len--;
+			}
+		}
+	}
+}
+
+static int omap_i2c_transmit_data(struct omap_i2c_dev *dev, u8 num_bytes,
+		bool is_xdr)
+{
+	u16		w;
+
+	while (num_bytes--) {
+		if (!dev->buf_len) {
+			dev_err(dev->dev, "%s without data",
+					is_xdr ? "XDR" : "XRDY");
+			break;
+		}
+
+		w = *dev->buf++;
+		dev->buf_len--;
+
+		/*
+		 * Data reg in 2430, omap3 and
+		 * omap4 is 8 bit wide
+		 */
+		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
+			if (dev->buf_len) {
+				w |= *dev->buf++ << 8;
+				dev->buf_len--;
+			}
+		}
+
+		if (dev->errata & I2C_OMAP3_1P153) {
+			int ret;
+
+			ret = errata_omap3_1p153(dev);
+			if (ret < 0)
+				return ret;
+		}
+
+		omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
+	}
+
+	return 0;
+}
+
 static irqreturn_t
 omap_i2c_isr(int this_irq, void *dev_id)
 {
 	struct omap_i2c_dev *dev = dev_id;
 	u16 bits;
-	u16 stat, w;
+	u16 stat;
 	int err, count = 0;
 
 	if (pm_runtime_suspended(dev->dev))
@@ -853,30 +922,7 @@ complete:
 			if (dev->fifo_size)
 				num_bytes = dev->fifo_size;
 
-			while (num_bytes--) {
-				if (!dev->buf_len) {
-					dev_err(dev->dev,
-							"RDR IRQ while no data"
-							" requested\n");
-					break;
-				}
-
-				w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
-				*dev->buf++ = w;
-				dev->buf_len--;
-
-				/*
-				 * Data reg in 2430, omap3 and
-				 * omap4 is 8 bit wide
-				 */
-				if (dev->flags &
-						OMAP_I2C_FLAG_16BIT_DATA_REG) {
-					if (dev->buf_len) {
-						*dev->buf++ = w >> 8;
-						dev->buf_len--;
-					}
-				}
-			}
+			omap_i2c_receive_data(dev, num_bytes, true);
 
 			if (dev->errata & I2C_OMAP_ERRATA_I207)
 				i2c_omap_errata_i207(dev, stat);
@@ -891,78 +937,23 @@ complete:
 			if (dev->fifo_size)
 				num_bytes = dev->fifo_size;
 
-			while (num_bytes--) {
-				if (!dev->buf_len) {
-					dev_err(dev->dev,
-							"RRDY IRQ while no data"
-							" requested\n");
-					break;
-				}
-
-				w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
-				*dev->buf++ = w;
-				dev->buf_len--;
-
-				/*
-				 * Data reg in 2430, omap3 and
-				 * omap4 is 8 bit wide
-				 */
-				if (dev->flags &
-						OMAP_I2C_FLAG_16BIT_DATA_REG) {
-					if (dev->buf_len) {
-						*dev->buf++ = w >> 8;
-						dev->buf_len--;
-					}
-				}
-			}
-
+			omap_i2c_receive_data(dev, num_bytes, false);
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_RRDY);
 			continue;
 		}
 
 		if (stat & OMAP_I2C_STAT_XDR) {
+			int ret;
 			u8 num_bytes = 1;
 
 			if (dev->fifo_size)
 				num_bytes = dev->fifo_size;
 
-			while (num_bytes--) {
-				if (!dev->buf_len) {
-					dev_err(dev->dev,
-							"XDR IRQ while no "
-							"data to send\n");
-					break;
-				}
-
-				w = *dev->buf++;
-				dev->buf_len--;
-
-				/*
-				 * Data reg in 2430, omap3 and
-				 * omap4 is 8 bit wide
-				 */
-				if (dev->flags &
-						OMAP_I2C_FLAG_16BIT_DATA_REG) {
-					if (dev->buf_len) {
-						w |= *dev->buf++ << 8;
-						dev->buf_len--;
-					}
-				}
-
-				if (dev->errata & I2C_OMAP3_1P153) {
-					int ret;
-
-					ret = errata_omap3_1p153(dev);
-					stat = omap_i2c_read_reg(dev,
-							OMAP_I2C_STAT_REG);
-
-					if (ret < 0) {
-						err |= OMAP_I2C_STAT_XUDF;
-						goto complete;
-					}
-				}
-
-				omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
+			ret = omap_i2c_transmit_data(dev, num_bytes, true);
+			stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
+			if (ret < 0) {
+				err |= OMAP_I2C_STAT_XUDF;
+				goto complete;
 			}
 
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XDR);
@@ -970,48 +961,17 @@ complete:
 		}
 
 		if (stat & OMAP_I2C_STAT_XRDY) {
+			int ret;
 			u8 num_bytes = 1;
 
 			if (dev->fifo_size)
 				num_bytes = dev->fifo_size;
 
-			while (num_bytes--) {
-				if (!dev->buf_len) {
-					dev_err(dev->dev,
-							"XRDY IRQ while no "
-							"data to send\n");
-					break;
-				}
-
-				w = *dev->buf++;
-				dev->buf_len--;
-
-				/*
-				 * Data reg in 2430, omap3 and
-				 * omap4 is 8 bit wide
-				 */
-				if (dev->flags &
-						OMAP_I2C_FLAG_16BIT_DATA_REG) {
-					if (dev->buf_len) {
-						w |= *dev->buf++ << 8;
-						dev->buf_len--;
-					}
-				}
-
-				if (dev->errata & I2C_OMAP3_1P153) {
-					int ret;
-
-					ret = errata_omap3_1p153(dev);
-					stat = omap_i2c_read_reg(dev,
-							OMAP_I2C_STAT_REG);
-
-					if (ret < 0) {
-						err |= OMAP_I2C_STAT_XUDF;
-						goto complete;
-					}
-				}
-
-				omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
+			ret = omap_i2c_transmit_data(dev, num_bytes, false);
+			stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
+			if (ret < 0) {
+				err |= OMAP_I2C_STAT_XUDF;
+				goto complete;
 			}
 
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XRDY);
-- 
1.7.10.4

