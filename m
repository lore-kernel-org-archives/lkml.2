Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1DSWPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:15:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10146 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1DSWPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:15:06 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Cc: Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] i2c: i2c-tegra: fix possible race condition after tx
Date: Tue, 19 Apr 2011 18:14:36 -0400
Message-Id: <1303251276-18768-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tegra_i2c_fill_tx_fifo, once we have finished pushing all the bytes
to the I2C hardware controller, the interrupt might happen before we
have updated i2c_dev->msg_buf_remaining at the end of the function.
Then, in tegra_i2c_isr, we will call again tegra_i2c_fill_tx_fifo
triggering weird behaviour.
Of course, this is unlikely since the I2C bus is slow and thus the ISR
is called several hundreds of microseconds after the last register
write.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/i2c/busses/i2c-tegra.c |   54 ++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index b4ab39b..c1b119b 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -125,7 +125,7 @@ struct tegra_i2c_dev {
 	struct completion msg_complete;
 	int msg_err;
 	u8 *msg_buf;
-	size_t msg_buf_remaining;
+	atomic_t msg_buf_remaining;
 	int msg_read;
 	unsigned long bus_clk_rate;
 	bool is_suspended;
@@ -213,38 +213,41 @@ static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
 	u32 val;
 	int rx_fifo_avail;
 	u8 *buf = i2c_dev->msg_buf;
-	size_t buf_remaining = i2c_dev->msg_buf_remaining;
 	int words_to_transfer;
+	int bytes_to_transfer;
 
 	val = i2c_readl(i2c_dev, I2C_FIFO_STATUS);
 	rx_fifo_avail = (val & I2C_FIFO_STATUS_RX_MASK) >>
 		I2C_FIFO_STATUS_RX_SHIFT;
 
 	/* Rounds down to not include partial word at the end of buf */
-	words_to_transfer = buf_remaining / BYTES_PER_FIFO_WORD;
+	words_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining) /
+		BYTES_PER_FIFO_WORD;
 	if (words_to_transfer > rx_fifo_avail)
 		words_to_transfer = rx_fifo_avail;
 
+	atomic_sub(words_to_transfer * BYTES_PER_FIFO_WORD,
+		&i2c_dev->msg_buf_remaining);
 	i2c_readsl(i2c_dev, buf, I2C_RX_FIFO, words_to_transfer);
 
 	buf += words_to_transfer * BYTES_PER_FIFO_WORD;
-	buf_remaining -= words_to_transfer * BYTES_PER_FIFO_WORD;
 	rx_fifo_avail -= words_to_transfer;
 
 	/*
 	 * If there is a partial word at the end of buf, handle it manually to
 	 * prevent overwriting past the end of buf
 	 */
-	if (rx_fifo_avail > 0 && buf_remaining > 0) {
-		BUG_ON(buf_remaining > 3);
+	bytes_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining);
+	if (rx_fifo_avail > 0 && bytes_to_transfer > 0) {
+		BUG_ON(bytes_to_transfer > 3);
+		atomic_set(&i2c_dev->msg_buf_remaining, 0);
 		val = i2c_readl(i2c_dev, I2C_RX_FIFO);
-		memcpy(buf, &val, buf_remaining);
-		buf_remaining = 0;
+		memcpy(buf, &val, bytes_to_transfer);
 		rx_fifo_avail--;
 	}
 
-	BUG_ON(rx_fifo_avail > 0 && buf_remaining > 0);
-	i2c_dev->msg_buf_remaining = buf_remaining;
+	BUG_ON(rx_fifo_avail > 0 &&
+		atomic_read(&i2c_dev->msg_buf_remaining) > 0);
 	i2c_dev->msg_buf = buf;
 	return 0;
 }
@@ -254,22 +257,24 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
 	u32 val;
 	int tx_fifo_avail;
 	u8 *buf = i2c_dev->msg_buf;
-	size_t buf_remaining = i2c_dev->msg_buf_remaining;
 	int words_to_transfer;
+	int bytes_to_transfer;
 
 	val = i2c_readl(i2c_dev, I2C_FIFO_STATUS);
 	tx_fifo_avail = (val & I2C_FIFO_STATUS_TX_MASK) >>
 		I2C_FIFO_STATUS_TX_SHIFT;
 
 	/* Rounds down to not include partial word at the end of buf */
-	words_to_transfer = buf_remaining / BYTES_PER_FIFO_WORD;
+	words_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining) /
+		BYTES_PER_FIFO_WORD;
 	if (words_to_transfer > tx_fifo_avail)
 		words_to_transfer = tx_fifo_avail;
 
+	atomic_sub(words_to_transfer * BYTES_PER_FIFO_WORD,
+		&i2c_dev->msg_buf_remaining);
 	i2c_writesl(i2c_dev, buf, I2C_TX_FIFO, words_to_transfer);
 
 	buf += words_to_transfer * BYTES_PER_FIFO_WORD;
-	buf_remaining -= words_to_transfer * BYTES_PER_FIFO_WORD;
 	tx_fifo_avail -= words_to_transfer;
 
 	/*
@@ -277,16 +282,17 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
 	 * prevent reading past the end of buf, which could cross a page
 	 * boundary and fault.
 	 */
-	if (tx_fifo_avail > 0 && buf_remaining > 0) {
-		BUG_ON(buf_remaining > 3);
-		memcpy(&val, buf, buf_remaining);
+	bytes_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining);
+	if (tx_fifo_avail > 0 && bytes_to_transfer > 0) {
+		BUG_ON(bytes_to_transfer > 3);
+		memcpy(&val, buf, bytes_to_transfer);
+		atomic_set(&i2c_dev->msg_buf_remaining, 0);
 		i2c_writel(i2c_dev, val, I2C_TX_FIFO);
-		buf_remaining = 0;
 		tx_fifo_avail--;
 	}
 
-	BUG_ON(tx_fifo_avail > 0 && buf_remaining > 0);
-	i2c_dev->msg_buf_remaining = buf_remaining;
+	BUG_ON(tx_fifo_avail > 0 &&
+		atomic_read(&i2c_dev->msg_buf_remaining) > 0);
 	i2c_dev->msg_buf = buf;
 	return 0;
 }
@@ -364,21 +370,21 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 	}
 
 	if (i2c_dev->msg_read && (status & I2C_INT_RX_FIFO_DATA_REQ)) {
-		if (i2c_dev->msg_buf_remaining)
+		if (atomic_read(&i2c_dev->msg_buf_remaining))
 			tegra_i2c_empty_rx_fifo(i2c_dev);
 		else
 			BUG();
 	}
 
 	if (!i2c_dev->msg_read && (status & I2C_INT_TX_FIFO_DATA_REQ)) {
-		if (i2c_dev->msg_buf_remaining)
+		if (atomic_read(&i2c_dev->msg_buf_remaining))
 			tegra_i2c_fill_tx_fifo(i2c_dev);
 		else
 			tegra_i2c_mask_irq(i2c_dev, I2C_INT_TX_FIFO_DATA_REQ);
 	}
 
 	if ((status & I2C_INT_PACKET_XFER_COMPLETE) &&
-			!i2c_dev->msg_buf_remaining)
+			!atomic_read(&i2c_dev->msg_buf_remaining))
 		complete(&i2c_dev->msg_complete);
 
 	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
@@ -408,7 +414,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 		return -EINVAL;
 
 	i2c_dev->msg_buf = msg->buf;
-	i2c_dev->msg_buf_remaining = msg->len;
+	atomic_set(&i2c_dev->msg_buf_remaining, msg->len);
 	i2c_dev->msg_err = I2C_ERR_NONE;
 	i2c_dev->msg_read = (msg->flags & I2C_M_RD);
 	INIT_COMPLETION(i2c_dev->msg_complete);
@@ -440,7 +446,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	int_mask = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST;
 	if (msg->flags & I2C_M_RD)
 		int_mask |= I2C_INT_RX_FIFO_DATA_REQ;
-	else if (i2c_dev->msg_buf_remaining)
+	else if (atomic_read(&i2c_dev->msg_buf_remaining))
 		int_mask |= I2C_INT_TX_FIFO_DATA_REQ;
 	tegra_i2c_unmask_irq(i2c_dev, int_mask);
 	dev_dbg(i2c_dev->dev, "unmasked irq: %02x\n",
-- 
1.7.3.1

