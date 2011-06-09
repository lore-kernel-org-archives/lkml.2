Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1FITWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:22:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59617 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1FITW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qLEQTiYmQDI5o6jUy4g3OTNc6O1OQhw5c4CDmwmxheEPcuOQSkw6lPGkNkG2Sjg7mz
         Jj/gctfYO/2uaMDBnacn++IxETt6BjiHy4C3cLa1AGhN2sje4WC6WSVq2lQE7zdNtgP+
         7pkKlc1sv5fQHiXLj0BugV5S50/7X1g1Ffi4Q=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 01/13] i2c-designware: Use local version of readl & writel
Date: Thu,  9 Jun 2011 12:21:38 -0700
Message-Id: <1307647310-24332-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>

Use local versions of readl & writel, so per-access manipulations may be performed

Signed-off-by: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware.c |   88 +++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index b7a51c4..1afb8c0 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -220,6 +220,16 @@ struct dw_i2c_dev {
 	unsigned int		rx_fifo_depth;
 };
 
+static u32 dw_readl(struct dw_i2c_dev *dev, int offset)
+{
+	return readl(dev->base + offset);
+}
+
+static void dw_writel(struct dw_i2c_dev *dev, u32 b, int offset)
+{
+	writel(b, dev->base + offset);
+}
+
 static u32
 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 {
@@ -289,7 +299,7 @@ static void i2c_dw_init(struct dw_i2c_dev *dev)
 	u32 ic_con, hcnt, lcnt;
 
 	/* Disable the adapter */
-	writel(0, dev->base + DW_IC_ENABLE);
+	dw_writel(dev, 0, DW_IC_ENABLE);
 
 	/* set standard and fast speed deviders for high/low periods */
 
@@ -303,8 +313,8 @@ static void i2c_dw_init(struct dw_i2c_dev *dev)
 				47,	/* tLOW = 4.7 us */
 				3,	/* tf = 0.3 us */
 				0);	/* No offset */
-	writel(hcnt, dev->base + DW_IC_SS_SCL_HCNT);
-	writel(lcnt, dev->base + DW_IC_SS_SCL_LCNT);
+	dw_writel(dev, hcnt, DW_IC_SS_SCL_HCNT);
+	dw_writel(dev, lcnt, DW_IC_SS_SCL_LCNT);
 	dev_dbg(dev->dev, "Standard-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
 
 	/* Fast-mode */
@@ -317,18 +327,18 @@ static void i2c_dw_init(struct dw_i2c_dev *dev)
 				13,	/* tLOW = 1.3 us */
 				3,	/* tf = 0.3 us */
 				0);	/* No offset */
-	writel(hcnt, dev->base + DW_IC_FS_SCL_HCNT);
-	writel(lcnt, dev->base + DW_IC_FS_SCL_LCNT);
+	dw_writel(dev, hcnt, DW_IC_FS_SCL_HCNT);
+	dw_writel(dev, lcnt, DW_IC_FS_SCL_LCNT);
 	dev_dbg(dev->dev, "Fast-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
 
 	/* Configure Tx/Rx FIFO threshold levels */
-	writel(dev->tx_fifo_depth - 1, dev->base + DW_IC_TX_TL);
-	writel(0, dev->base + DW_IC_RX_TL);
+	dw_writel(dev, dev->tx_fifo_depth - 1, DW_IC_TX_TL);
+	dw_writel(dev, 0, DW_IC_RX_TL);
 
 	/* configure the i2c master */
 	ic_con = DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
 		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
-	writel(ic_con, dev->base + DW_IC_CON);
+	dw_writel(dev, ic_con, DW_IC_CON);
 }
 
 /*
@@ -338,7 +348,7 @@ static int i2c_dw_wait_bus_not_busy(struct dw_i2c_dev *dev)
 {
 	int timeout = TIMEOUT;
 
-	while (readl(dev->base + DW_IC_STATUS) & DW_IC_STATUS_ACTIVITY) {
+	while (dw_readl(dev, DW_IC_STATUS) & DW_IC_STATUS_ACTIVITY) {
 		if (timeout <= 0) {
 			dev_warn(dev->dev, "timeout waiting for bus ready\n");
 			return -ETIMEDOUT;
@@ -356,24 +366,24 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	u32 ic_con;
 
 	/* Disable the adapter */
-	writel(0, dev->base + DW_IC_ENABLE);
+	dw_writel(dev, 0, DW_IC_ENABLE);
 
 	/* set the slave (target) address */
-	writel(msgs[dev->msg_write_idx].addr, dev->base + DW_IC_TAR);
+	dw_writel(dev, msgs[dev->msg_write_idx].addr, DW_IC_TAR);
 
 	/* if the slave address is ten bit address, enable 10BITADDR */
-	ic_con = readl(dev->base + DW_IC_CON);
+	ic_con = dw_readl(dev, DW_IC_CON);
 	if (msgs[dev->msg_write_idx].flags & I2C_M_TEN)
 		ic_con |= DW_IC_CON_10BITADDR_MASTER;
 	else
 		ic_con &= ~DW_IC_CON_10BITADDR_MASTER;
-	writel(ic_con, dev->base + DW_IC_CON);
+	dw_writel(dev, ic_con, DW_IC_CON);
 
 	/* Enable the adapter */
-	writel(1, dev->base + DW_IC_ENABLE);
+	dw_writel(dev, 1, DW_IC_ENABLE);
 
 	/* Enable interrupts */
-	writel(DW_IC_INTR_DEFAULT_MASK, dev->base + DW_IC_INTR_MASK);
+	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
 }
 
 /*
@@ -420,15 +430,15 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 			buf_len = msgs[dev->msg_write_idx].len;
 		}
 
-		tx_limit = dev->tx_fifo_depth - readl(dev->base + DW_IC_TXFLR);
-		rx_limit = dev->rx_fifo_depth - readl(dev->base + DW_IC_RXFLR);
+		tx_limit = dev->tx_fifo_depth - dw_readl(dev, DW_IC_TXFLR);
+		rx_limit = dev->rx_fifo_depth - dw_readl(dev, DW_IC_RXFLR);
 
 		while (buf_len > 0 && tx_limit > 0 && rx_limit > 0) {
 			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
-				writel(0x100, dev->base + DW_IC_DATA_CMD);
+				dw_writel(dev, 0x100, DW_IC_DATA_CMD);
 				rx_limit--;
 			} else
-				writel(*buf++, dev->base + DW_IC_DATA_CMD);
+				dw_writel(dev, *buf++, DW_IC_DATA_CMD);
 			tx_limit--; buf_len--;
 		}
 
@@ -453,7 +463,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 	if (dev->msg_err)
 		intr_mask = 0;
 
-	writel(intr_mask, dev->base + DW_IC_INTR_MASK);
+	dw_writel(dev, intr_mask, DW_IC_INTR_MASK);
 }
 
 static void
@@ -477,10 +487,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)
 			buf = dev->rx_buf;
 		}
 
-		rx_valid = readl(dev->base + DW_IC_RXFLR);
+		rx_valid = dw_readl(dev, DW_IC_RXFLR);
 
 		for (; len > 0 && rx_valid > 0; len--, rx_valid--)
-			*buf++ = readl(dev->base + DW_IC_DATA_CMD);
+			*buf++ = dw_readl(dev, DW_IC_DATA_CMD);
 
 		if (len > 0) {
 			dev->status |= STATUS_READ_IN_PROGRESS;
@@ -563,7 +573,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	/* no error */
 	if (likely(!dev->cmd_err)) {
 		/* Disable the adapter */
-		writel(0, dev->base + DW_IC_ENABLE);
+		dw_writel(dev, 0, DW_IC_ENABLE);
 		ret = num;
 		goto done;
 	}
@@ -607,7 +617,7 @@ static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
 	 *
 	 * The raw version might be useful for debugging purposes.
 	 */
-	stat = readl(dev->base + DW_IC_INTR_STAT);
+	stat = dw_readl(dev, DW_IC_INTR_STAT);
 
 	/*
 	 * Do not use the IC_CLR_INTR register to clear interrupts, or
@@ -617,31 +627,31 @@ static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
 	 * Instead, use the separately-prepared IC_CLR_* registers.
 	 */
 	if (stat & DW_IC_INTR_RX_UNDER)
-		readl(dev->base + DW_IC_CLR_RX_UNDER);
+		dw_readl(dev, DW_IC_CLR_RX_UNDER);
 	if (stat & DW_IC_INTR_RX_OVER)
-		readl(dev->base + DW_IC_CLR_RX_OVER);
+		dw_readl(dev, DW_IC_CLR_RX_OVER);
 	if (stat & DW_IC_INTR_TX_OVER)
-		readl(dev->base + DW_IC_CLR_TX_OVER);
+		dw_readl(dev, DW_IC_CLR_TX_OVER);
 	if (stat & DW_IC_INTR_RD_REQ)
-		readl(dev->base + DW_IC_CLR_RD_REQ);
+		dw_readl(dev, DW_IC_CLR_RD_REQ);
 	if (stat & DW_IC_INTR_TX_ABRT) {
 		/*
 		 * The IC_TX_ABRT_SOURCE register is cleared whenever
 		 * the IC_CLR_TX_ABRT is read.  Preserve it beforehand.
 		 */
-		dev->abort_source = readl(dev->base + DW_IC_TX_ABRT_SOURCE);
-		readl(dev->base + DW_IC_CLR_TX_ABRT);
+		dev->abort_source = dw_readl(dev, DW_IC_TX_ABRT_SOURCE);
+		dw_readl(dev, DW_IC_CLR_TX_ABRT);
 	}
 	if (stat & DW_IC_INTR_RX_DONE)
-		readl(dev->base + DW_IC_CLR_RX_DONE);
+		dw_readl(dev, DW_IC_CLR_RX_DONE);
 	if (stat & DW_IC_INTR_ACTIVITY)
-		readl(dev->base + DW_IC_CLR_ACTIVITY);
+		dw_readl(dev, DW_IC_CLR_ACTIVITY);
 	if (stat & DW_IC_INTR_STOP_DET)
-		readl(dev->base + DW_IC_CLR_STOP_DET);
+		dw_readl(dev, DW_IC_CLR_STOP_DET);
 	if (stat & DW_IC_INTR_START_DET)
-		readl(dev->base + DW_IC_CLR_START_DET);
+		dw_readl(dev, DW_IC_CLR_START_DET);
 	if (stat & DW_IC_INTR_GEN_CALL)
-		readl(dev->base + DW_IC_CLR_GEN_CALL);
+		dw_readl(dev, DW_IC_CLR_GEN_CALL);
 
 	return stat;
 }
@@ -666,7 +676,7 @@ static irqreturn_t i2c_dw_isr(int this_irq, void *dev_id)
 		 * Anytime TX_ABRT is set, the contents of the tx/rx
 		 * buffers are flushed.  Make sure to skip them.
 		 */
-		writel(0, dev->base + DW_IC_INTR_MASK);
+		dw_writel(dev, 0, DW_IC_INTR_MASK);
 		goto tx_aborted;
 	}
 
@@ -747,14 +757,14 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 	{
-		u32 param1 = readl(dev->base + DW_IC_COMP_PARAM_1);
+		u32 param1 = dw_readl(dev, DW_IC_COMP_PARAM_1);
 
 		dev->tx_fifo_depth = ((param1 >> 16) & 0xff) + 1;
 		dev->rx_fifo_depth = ((param1 >> 8)  & 0xff) + 1;
 	}
 	i2c_dw_init(dev);
 
-	writel(0, dev->base + DW_IC_INTR_MASK); /* disable IRQ */
+	dw_writel(dev, 0, DW_IC_INTR_MASK); /* disable IRQ */
 	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
@@ -810,7 +820,7 @@ static int __devexit dw_i2c_remove(struct platform_device *pdev)
 	clk_put(dev->clk);
 	dev->clk = NULL;
 
-	writel(0, dev->base + DW_IC_ENABLE);
+	dw_writel(dev, 0, DW_IC_ENABLE);
 	free_irq(dev->irq, dev);
 	kfree(dev);
 
-- 
1.7.3.4

