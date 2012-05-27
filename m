Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2E0BNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:13:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965494Ab2E0BNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:13:34 -0400
Message-Id: <20120527010437.002282573@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 94/94] i2c: tegra: notify transfer-complete after clearing status.
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Dewangan <ldewangan@nvidia.com>

commit c889e91d2cc22123f20f40dde0c0a91856a20eea upstream.

The notification of the transfer complete by calling complete()
should be done after clearing all interrupt status.
This avoids the race condition of misconfigure the i2c controller
in multi-core environment.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-tegra.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -401,8 +401,6 @@ static irqreturn_t tegra_i2c_isr(int irq
 			disable_irq_nosync(i2c_dev->irq);
 			i2c_dev->irq_disabled = 1;
 		}
-
-		complete(&i2c_dev->msg_complete);
 		goto err;
 	}
 
@@ -411,7 +409,6 @@ static irqreturn_t tegra_i2c_isr(int irq
 			i2c_dev->msg_err |= I2C_ERR_NO_ACK;
 		if (status & I2C_INT_ARBITRATION_LOST)
 			i2c_dev->msg_err |= I2C_ERR_ARBITRATION_LOST;
-		complete(&i2c_dev->msg_complete);
 		goto err;
 	}
 
@@ -429,14 +426,14 @@ static irqreturn_t tegra_i2c_isr(int irq
 			tegra_i2c_mask_irq(i2c_dev, I2C_INT_TX_FIFO_DATA_REQ);
 	}
 
+	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
+	if (i2c_dev->is_dvc)
+		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
+
 	if (status & I2C_INT_PACKET_XFER_COMPLETE) {
 		BUG_ON(i2c_dev->msg_buf_remaining);
 		complete(&i2c_dev->msg_complete);
 	}
-
-	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
-	if (i2c_dev->is_dvc)
-		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
 	return IRQ_HANDLED;
 err:
 	/* An error occurred, mask all interrupts */
@@ -446,6 +443,8 @@ err:
 	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
 	if (i2c_dev->is_dvc)
 		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
+
+	complete(&i2c_dev->msg_complete);
 	return IRQ_HANDLED;
 }
 


