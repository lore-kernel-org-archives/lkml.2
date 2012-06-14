Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2FNQ1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:27:34 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:44905 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604Ab2FNQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:27:27 -0400
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
Subject: [PATCH v2 17/17] i2c: omap: resize fifos before each message
Date: Thu, 14 Jun 2012 19:24:27 +0300
Message-Id: <1339691067-919-18-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339691067-919-1-git-send-email-balbi@ti.com>
References: <1339691067-919-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will try to avoid the usage of
draining feature by reconfiguring the FIFO
the start condition of each message based
on the message's size.

By doing that, we will be better utilizing
the FIFO when doing big transfers.

While at that also drop the now uneeded
check for dev->buf_len as we always know
the amount of data to be transmitted.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   83 +++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 82cb7d4..aa14e24 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -193,6 +193,7 @@ struct omap_i2c_dev {
 	u8			*regs;
 	size_t			buf_len;
 	struct i2c_adapter	adapter;
+	u8			threshold;
 	u8			fifo_size;	/* use as flag and value
 						 * fifo_size==0 implies no fifo
 						 * if set, should be trsh+1
@@ -459,13 +460,6 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 	omap_i2c_write_reg(dev, OMAP_I2C_SCLL_REG, scll);
 	omap_i2c_write_reg(dev, OMAP_I2C_SCLH_REG, sclh);
 
-	if (dev->fifo_size) {
-		/* Note: setup required fifo size - 1. RTRSH and XTRSH */
-		buf = (dev->fifo_size - 1) << 8 | OMAP_I2C_BUF_RXFIF_CLR |
-			(dev->fifo_size - 1) | OMAP_I2C_BUF_TXFIF_CLR;
-		omap_i2c_write_reg(dev, OMAP_I2C_BUF_REG, buf);
-	}
-
 	/* Take the I2C module out of reset: */
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, OMAP_I2C_CON_EN);
 
@@ -508,6 +502,45 @@ static int omap_i2c_wait_for_bb(struct omap_i2c_dev *dev)
 	return 0;
 }
 
+static void omap_i2c_resize_fifo(struct omap_i2c_dev *dev, u8 size, bool is_rx)
+{
+	u16		buf;
+
+	if (dev->flags & OMAP_I2C_FLAG_NO_FIFO)
+		return;
+
+	/*
+	 * Set up notification threshold based on message size. We're doing
+	 * this to try and avoid draining feature as much as possible. Whenever
+	 * we have big messages to transfer (bigger than our total fifo size)
+	 * then we might use draining feature to transfer the remaining bytes.
+	 */
+
+	dev->threshold = clamp(size, (u8) 1, dev->fifo_size);
+
+	buf = omap_i2c_read_reg(dev, OMAP_I2C_BUF_REG);
+
+	if (is_rx) {
+		/* Clear RX Threshold */
+		buf &= ~(0x3f << 8);
+		buf |= ((dev->threshold - 1) << 8) | OMAP_I2C_BUF_RXFIF_CLR;
+	} else {
+		/* Clear TX Threshold */
+		buf &= ~0x3f;
+		buf |= (dev->threshold - 1) | OMAP_I2C_BUF_TXFIF_CLR;
+	}
+
+	omap_i2c_write_reg(dev, OMAP_I2C_BUF_REG, buf);
+
+	if (dev->rev < OMAP_I2C_REV_ON_3530_4430)
+		dev->b_hw = 1; /* Enable hardware fixes */
+
+	/* calculate wakeup latency constraint for MPU */
+	if (dev->set_mpu_wkup_lat != NULL)
+		dev->latency = (1000000 * dev->threshold) /
+			(1000 * dev->speed / 8);
+}
+
 /*
  * Low level master read/write transaction.
  */
@@ -524,6 +557,9 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	if (msg->len == 0)
 		return -EINVAL;
 
+	dev->receiver = !!(msg->flags & I2C_M_RD);
+	omap_i2c_resize_fifo(dev, msg->len, dev->receiver);
+
 	omap_i2c_write_reg(dev, OMAP_I2C_SA_REG, msg->addr);
 
 	/* REVISIT: Could the STB bit of I2C_CON be used with probing? */
@@ -539,7 +575,6 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 
 	init_completion(&dev->cmd_complete);
 	dev->cmd_err = 0;
-	dev->receiver = !!(msg->flags & I2C_M_RD);
 
 	w = OMAP_I2C_CON_EN | OMAP_I2C_CON_MST | OMAP_I2C_CON_STT;
 
@@ -803,12 +838,6 @@ static void omap_i2c_receive_data(struct omap_i2c_dev *dev, u8 num_bytes,
 	u16		w;
 
 	while (num_bytes--) {
-		if (!dev->buf_len) {
-			dev_err(dev->dev, "%s without data",
-					is_rdr ? "RDR" : "RRDY");
-			break;
-		}
-
 		w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
 		*dev->buf++ = w;
 		dev->buf_len--;
@@ -818,10 +847,8 @@ static void omap_i2c_receive_data(struct omap_i2c_dev *dev, u8 num_bytes,
 		 * omap4 is 8 bit wide
 		 */
 		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
-			if (dev->buf_len) {
-				*dev->buf++ = w >> 8;
-				dev->buf_len--;
-			}
+			*dev->buf++ = w >> 8;
+			dev->buf_len--;
 		}
 	}
 }
@@ -832,12 +859,6 @@ static int omap_i2c_transmit_data(struct omap_i2c_dev *dev, u8 num_bytes,
 	u16		w;
 
 	while (num_bytes--) {
-		if (!dev->buf_len) {
-			dev_err(dev->dev, "%s without data",
-					is_xdr ? "XDR" : "XRDY");
-			break;
-		}
-
 		w = *dev->buf++;
 		dev->buf_len--;
 
@@ -846,10 +867,8 @@ static int omap_i2c_transmit_data(struct omap_i2c_dev *dev, u8 num_bytes,
 		 * omap4 is 8 bit wide
 		 */
 		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
-			if (dev->buf_len) {
-				w |= *dev->buf++ << 8;
-				dev->buf_len--;
-			}
+			w |= *dev->buf++ << 8;
+			dev->buf_len--;
 		}
 
 		if (dev->errata & I2C_OMAP3_1P153) {
@@ -942,8 +961,8 @@ omap_i2c_isr(int this_irq, void *dev_id)
 		if (stat & OMAP_I2C_STAT_RRDY) {
 			u8 num_bytes = 1;
 
-			if (dev->fifo_size)
-				num_bytes = dev->fifo_size;
+			if (dev->threshold)
+				num_bytes = dev->threshold;
 
 			omap_i2c_receive_data(dev, num_bytes, false);
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_RRDY);
@@ -973,8 +992,8 @@ omap_i2c_isr(int this_irq, void *dev_id)
 			int ret;
 			u8 num_bytes = 1;
 
-			if (dev->fifo_size)
-				num_bytes = dev->fifo_size;
+			if (dev->threshold)
+				num_bytes = dev->threshold;
 
 			ret = omap_i2c_transmit_data(dev, num_bytes, false);
 			if (ret < 0) {
-- 
1.7.10.4

