Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1DTMKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:10:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9276 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1DTMKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:10:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Apr 2011 05:10:36 -0700
From: wni@nvidia.com
To: khali@linux-fr.org, ben-linux@fluff.org, lucas.demarchi@profusion.mobi,
        ccross@android.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wei Ni <wni@nvidia.com>
Subject: [PATCH 1/2] i2c: tegra: Retry transfer when unexpected/no_ack status is detected
Date: Wed, 20 Apr 2011 20:08:31 +0800
Message-Id: <1303301312-15302-2-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1303301312-15302-1-git-send-email-wni@nvidia.com>
References: <1303301312-15302-1-git-send-email-wni@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

Sometimes unexpected status like I2C busy status, Tx FIFO interrupted
and wait on Rx data etc is seen. Add a code to detect such conditions
and return -EAGAIN from driver. This will cause the i2c-core to retry
the transmission as per the retry count and time-out specified by the
platform data of the adapter.
And for no_ack status, also retrun -EAGAIN to retry.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   29 ++++++++++++++++++++++++++---
 include/linux/i2c-tegra.h      |    2 ++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index b4ab39b..4f5f7f2 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -31,12 +31,15 @@
 
 #include <mach/clk.h>
 
-#define TEGRA_I2C_TIMEOUT (msecs_to_jiffies(1000))
-#define BYTES_PER_FIFO_WORD 4
+#define TEGRA_I2C_TIMEOUT			(msecs_to_jiffies(1000))
+#define TEGRA_I2C_RETRIES			3
+#define BYTES_PER_FIFO_WORD			4
 
 #define I2C_CNFG				0x000
 #define I2C_CNFG_PACKET_MODE_EN			(1<<10)
 #define I2C_CNFG_NEW_MASTER_FSM			(1<<11)
+#define I2C_STATUS				0x01C
+#define I2C_STATUS_BUSY				(1<<8)
 #define I2C_SL_CNFG				0x020
 #define I2C_SL_CNFG_NEWSL			(1<<2)
 #define I2C_SL_ADDR1				0x02c
@@ -77,6 +80,7 @@
 #define I2C_ERR_NONE				0x00
 #define I2C_ERR_NO_ACK				0x01
 #define I2C_ERR_ARBITRATION_LOST		0x02
+#define I2C_ERR_UNEXPECTED_STATUS		0x08
 
 #define PACKET_HEADER0_HEADER_SIZE_SHIFT	28
 #define PACKET_HEADER0_PACKET_ID_SHIFT		16
@@ -363,6 +367,15 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 		goto err;
 	}
 
+	if (unlikely((i2c_readl(i2c_dev, I2C_STATUS) & I2C_STATUS_BUSY)
+				&& (status == I2C_INT_TX_FIFO_DATA_REQ)
+				&& i2c_dev->msg_read
+				&& i2c_dev->msg_buf_remaining)) {
+		i2c_dev->msg_err |= I2C_ERR_UNEXPECTED_STATUS;
+		complete(&i2c_dev->msg_complete);
+		goto err;
+	}
+
 	if (i2c_dev->msg_read && (status & I2C_INT_RX_FIFO_DATA_REQ)) {
 		if (i2c_dev->msg_buf_remaining)
 			tegra_i2c_empty_rx_fifo(i2c_dev);
@@ -466,9 +479,12 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return 0;
-		return -EREMOTEIO;
+		return -EAGAIN;
 	}
 
+	if (i2c_dev->msg_err & I2C_ERR_UNEXPECTED_STATUS)
+		return -EAGAIN;
+
 	return -EIO;
 }
 
@@ -598,6 +614,13 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	i2c_dev->adapter.algo = &tegra_i2c_algo;
 	i2c_dev->adapter.dev.parent = &pdev->dev;
 	i2c_dev->adapter.nr = pdev->id;
+	if (pdata->retries)
+		i2c_dev->adapter.retries = pdata->retries;
+	else
+		i2c_dev->adapter.retries = TEGRA_I2C_RETRIES;
+
+	if (pdata->timeout)
+		i2c_dev->adapter.timeout = pdata->timeout;
 
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
diff --git a/include/linux/i2c-tegra.h b/include/linux/i2c-tegra.h
index 9c85da4..8ee5b37 100644
--- a/include/linux/i2c-tegra.h
+++ b/include/linux/i2c-tegra.h
@@ -20,6 +20,8 @@
 
 struct tegra_i2c_platform_data {
 	unsigned long bus_clk_rate;
+	int retries;
+	int timeout;	/* in jiffies */
 };
 
 #endif /* _LINUX_I2C_TEGRA_H */
-- 
1.7.0

