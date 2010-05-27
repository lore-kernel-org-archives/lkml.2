Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab0E0MQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:16:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37367 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0E0MQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:16:12 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: sha@pengutronix.de
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Wolfram Sang <w.sang@pengutronix.de>, Richard Zhao <linuxzsc@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Arnaud Patard <apatard@mandriva.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH V2] i2c-imx: do not allow interruptions when waiting for I2C to complete
Date: Thu, 27 May 2010 14:16:01 +0200
Message-Id: <1274962561-17007-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_imx_trx_complete() function is using
wait_event_interruptible_timeout() to wait for the I2C controller to
signal that it has completed an I2C bus operation. If the process that
causes the I2C operation receives a signal, the wait will be
interrupted, returning an error. It is better to let the I2C operation
finished before handling the signal (i.e. returning into userspace).

It is safe to use wait_event_timeout() instead, because the timeout
will allow the process to exit if the I2C bus hangs. It's also better
to allow the I2C operation to finish, because unacknowledged I2C
operations can cause the I2C bus to hang.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
---

V2: Remove check for "result < 0" as commented by Wolfram Sang.

 drivers/i2c/busses/i2c-imx.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index d1ff940..58df809 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -161,13 +161,10 @@ static int i2c_imx_trx_complete(struct imx_i2c_struct *i2c_imx)
 {
 	int result;
 
-	result = wait_event_interruptible_timeout(i2c_imx->queue,
+	result = wait_event_timeout(i2c_imx->queue,
 		i2c_imx->i2csr & I2SR_IIF, HZ / 10);
 
-	if (unlikely(result < 0)) {
-		dev_dbg(&i2c_imx->adapter.dev, "<%s> result < 0\n", __func__);
-		return result;
-	} else if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
+	if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
 		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
 		return -ETIMEDOUT;
 	}
@@ -295,7 +292,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 		i2c_imx->i2csr = temp;
 		temp &= ~I2SR_IIF;
 		writeb(temp, i2c_imx->base + IMX_I2C_I2SR);
-		wake_up_interruptible(&i2c_imx->queue);
+		wake_up(&i2c_imx->queue);
 		return IRQ_HANDLED;
 	}
 
-- 
1.7.1

