Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab1KRNd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:33:26 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:27350 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab1KRNdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:33:20 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <253dd34b96917c18228c379cf56f96fa1b757655.1321616787.git.n.voss@weinmann.de>
In-Reply-To: <cover.1321616787.git.n.voss@weinmann.de>
References: <cover.1321616787.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Fri, 18 Nov 2011 12:38:00 +0100
Subject: [PATCH v6 5/5] i2c-at91.c: add SMBUS_READ_BLOCK_DATA functionality
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMBus emulation uses I2C_M_RECV_LEN flag to indicate a SMBus block
read operation in which the length of a transfer is inicated by the
first received byte.

Make better use of clk_prepare()/clk_unprepare().

More sensible transfer timeout.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/i2c/busses/i2c-at91.c |   44 +++++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 9f4e0d0..96f33f9 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -32,7 +32,7 @@
 #include "i2c-at91.h"
 
 #define TWI_CLK_HZ		100000			/* max 400 Kbits/s */
-#define AT91_I2C_TIMEOUT	msecs_to_jiffies(10)	/* transfer timeout */
+#define AT91_I2C_TIMEOUT	msecs_to_jiffies(100)	/* transfer timeout */
 
 struct at91_twi_dev {
 	struct device		*dev;
@@ -41,6 +41,7 @@ struct at91_twi_dev {
 	struct clk		*clk;
 	u8			*buf;
 	size_t			buf_len;
+	struct i2c_msg		*msg;
 	int			irq;
 	unsigned		transfer_status;
 	struct i2c_adapter	adapter;
@@ -113,9 +114,18 @@ static void at91_twi_write_next_byte(struct at91_twi_dev *dev)
 static void at91_twi_read_next_byte(struct at91_twi_dev *dev)
 {
 	*dev->buf = at91_twi_read(dev, AT91_TWI_RHR) & 0xff;
+	--dev->buf_len;
+
+	/* handle I2C_SMBUS_BLOCK_DATA */
+	if (unlikely(dev->msg->flags & I2C_M_RECV_LEN)) {
+		dev->msg->flags &= ~I2C_M_RECV_LEN;
+		dev->buf_len += *dev->buf;
+		dev->msg->len = dev->buf_len + 1;
+		dev_dbg(dev->dev, "received block length %d\n", dev->buf_len);
+	}
 
 	/* send stop if second but last byte has been read */
-	if (--dev->buf_len == 1)
+	if (dev->buf_len == 1)
 		at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
 
 	dev_dbg(dev->dev, "read 0x%x, to go %d\n", *dev->buf, dev->buf_len);
@@ -144,17 +154,21 @@ static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int at91_do_twi_transfer(struct at91_twi_dev *dev, bool is_read)
+static int at91_do_twi_transfer(struct at91_twi_dev *dev)
 {
 	int ret;
 
+	dev_dbg(dev->dev, "transfer: %s %d bytes.\n",
+		(dev->msg->flags & I2C_M_RD) ? "read" : "write", dev->buf_len);
+
 	INIT_COMPLETION(dev->cmd_complete);
-	if (is_read) {
-		if (!dev->buf_len)
-			at91_twi_write(dev, AT91_TWI_CR,
-				       AT91_TWI_START | AT91_TWI_STOP);
-		else
-			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_START);
+	if (dev->msg->flags & I2C_M_RD) {
+		unsigned start_flags = AT91_TWI_START;
+
+		/* if only one byte is to be read, immediately stop transfer */
+		if (dev->buf_len <= 1 && !(dev->msg->flags & I2C_M_RECV_LEN))
+			start_flags |= AT91_TWI_STOP;
+		at91_twi_write(dev, AT91_TWI_CR, start_flags);
 		at91_twi_write(dev, AT91_TWI_IER,
 			       AT91_TWI_TXCOMP | AT91_TWI_RXRDY);
 	} else {
@@ -227,17 +241,17 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 
 	dev->buf_len = m_start->len;
 	dev->buf = m_start->buf;
+	dev->msg = m_start;
 
-	ret = at91_do_twi_transfer(dev, m_start->flags & I2C_M_RD);
-	if (ret < 0)
-		return ret;
+	ret = at91_do_twi_transfer(dev);
 
-	return num;
+	return (ret < 0) ? ret : num;
 }
 
 static u32 at91_twi_func(struct i2c_adapter *adapter)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL
+		| I2C_FUNC_SMBUS_READ_BLOCK_DATA;
 }
 
 static struct i2c_algorithm at91_twi_algorithm = {
@@ -324,6 +338,7 @@ err_unuse_clocks:
 	iounmap(dev->base);
 err_mem_ioremap:
 	clk_disable(dev->clk);
+	clk_unprepare(dev->clk);
 	clk_put(dev->clk);
 err_free_mem:
 	kfree(dev);
@@ -341,6 +356,7 @@ static int __devexit at91_twi_remove(struct platform_device *pdev)
 
 	rc = i2c_del_adapter(&dev->adapter);
 	clk_disable(dev->clk);
+	clk_unprepare(dev->clk);
 	clk_put(dev->clk);
 	free_irq(dev->irq, dev);
 	iounmap(dev->base);
-- 
1.7.5.4

