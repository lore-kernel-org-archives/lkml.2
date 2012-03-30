Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572Ab2C3Pvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:51:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54459 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2C3PuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:21 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 16/16] i2c: omap: make the read ready processing a separate function
Date: Fri, 30 Mar 2012 21:20:11 +0530
Message-ID: <1333122611-29953-17-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
References: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Makes the read ready processing a separate
function. This is to avoid extremely long level of indentation.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   86 +++++++++++++++++++++-------------------
 1 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 4d57569..1f63698 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -784,6 +784,49 @@ static int errata_omap3_1p153(struct omap_i2c_dev *dev, u16 *stat, int *err)
 	return 0;
 }
 
+static int process_read_rdy(struct omap_i2c_dev *dev)
+{
+	u8 num_bytes = 1;
+	u16 stat, w;
+
+	if (dev->errata & I2C_OMAP_ERRATA_I207)
+		i2c_omap_errata_i207(dev, stat);
+
+	if (dev->fifo_size) {
+		if (stat & OMAP_I2C_STAT_RRDY)
+			num_bytes = dev->fifo_size;
+		else    /* read RXSTAT on RDR interrupt */
+			num_bytes = (omap_i2c_read_reg(dev,
+					OMAP_I2C_BUFSTAT_REG) >> 8) & 0x3F;
+	}
+	while (num_bytes) {
+		num_bytes--;
+		w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
+		if (dev->buf_len) {
+			*dev->buf++ = w;
+			dev->buf_len--;
+			/*
+			 * Data reg in 2430, omap3 and omap4 is 8 bit wide
+			 */
+			if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
+				if (dev->buf_len) {
+					*dev->buf++ = w >> 8;
+					dev->buf_len--;
+				}
+			}
+		} else {
+			if (stat & OMAP_I2C_STAT_RRDY)
+				dev_err(dev->dev,
+					"RRDY IRQ while no data requested\n");
+			if (stat & OMAP_I2C_STAT_RDR)
+				dev_err(dev->dev,
+					"RDR IRQ while no data requested\n");
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
 static irqreturn_t
 omap_i2c_isr(int this_irq, void *dev_id)
 {
@@ -834,48 +877,9 @@ complete:
 			return IRQ_HANDLED;
 		}
 		if (stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR)) {
-			u8 num_bytes = 1;
-
-			if (dev->errata & I2C_OMAP_ERRATA_I207)
-				i2c_omap_errata_i207(dev, stat);
+			if (process_read_rdy(dev) == -EIO)
+				break;
 
-			if (dev->fifo_size) {
-				if (stat & OMAP_I2C_STAT_RRDY)
-					num_bytes = dev->fifo_size;
-				else    /* read RXSTAT on RDR interrupt */
-					num_bytes = (omap_i2c_read_reg(dev,
-							OMAP_I2C_BUFSTAT_REG)
-							>> 8) & 0x3F;
-			}
-			while (num_bytes) {
-				num_bytes--;
-				w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
-				if (dev->buf_len) {
-					*dev->buf++ = w;
-					dev->buf_len--;
-					/*
-					 * Data reg in 2430, omap3 and
-					 * omap4 is 8 bit wide
-					 */
-					if (dev->flags &
-						 OMAP_I2C_FLAG_16BIT_DATA_REG) {
-						if (dev->buf_len) {
-							*dev->buf++ = w >> 8;
-							dev->buf_len--;
-						}
-					}
-				} else {
-					if (stat & OMAP_I2C_STAT_RRDY)
-						dev_err(dev->dev,
-							"RRDY IRQ while no data"
-								" requested\n");
-					if (stat & OMAP_I2C_STAT_RDR)
-						dev_err(dev->dev,
-							"RDR IRQ while no data"
-								" requested\n");
-					break;
-				}
-			}
 			omap_i2c_ack_stat(dev,
 				stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR));
 			continue;
-- 
1.7.1

