Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2E1Dd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:33:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52263 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab2E1D3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:49 -0400
Message-Id: <20120528031218.039014289@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 110/117] i2c: tegra: notify transfer-complete after clearing status.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-tegra.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 18067b3..8b2e555 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -401,8 +401,6 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 			disable_irq_nosync(i2c_dev->irq);
 			i2c_dev->irq_disabled = 1;
 		}
-
-		complete(&i2c_dev->msg_complete);
 		goto err;
 	}
 
@@ -411,7 +409,6 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 			i2c_dev->msg_err |= I2C_ERR_NO_ACK;
 		if (status & I2C_INT_ARBITRATION_LOST)
 			i2c_dev->msg_err |= I2C_ERR_ARBITRATION_LOST;
-		complete(&i2c_dev->msg_complete);
 		goto err;
 	}
 
@@ -429,14 +426,14 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
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
 


