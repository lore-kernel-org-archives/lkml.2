Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1DTMLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:11:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9323 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1DTMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:11:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Apr 2011 05:10:46 -0700
From: wni@nvidia.com
To: khali@linux-fr.org, ben-linux@fluff.org, lucas.demarchi@profusion.mobi,
        ccross@android.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wei Ni <wni@nvidia.com>
Subject: [PATCH 2/2] i2c: tegra: use new i2c slave controller
Date: Wed, 20 Apr 2011 20:08:32 +0800
Message-Id: <1303301312-15302-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1303301312-15302-1-git-send-email-wni@nvidia.com>
References: <1303301312-15302-1-git-send-email-wni@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

tegra2 has an improved new i2c slave controller. This should be
used instead of the old i2c slave controller. With old i2c slave
controller, occasionally it generates spurious slave interrupts
causing disruptions in master i2c transfers.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   28 ++++++++++++++++++++++++++++
 include/linux/i2c-tegra.h      |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 4f5f7f2..0742468 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -41,8 +41,10 @@
 #define I2C_STATUS				0x01C
 #define I2C_STATUS_BUSY				(1<<8)
 #define I2C_SL_CNFG				0x020
+#define I2C_SL_CNFG_NACK			(1<<1)
 #define I2C_SL_CNFG_NEWSL			(1<<2)
 #define I2C_SL_ADDR1				0x02c
+#define I2C_SL_ADDR2 				0x030
 #define I2C_TX_FIFO				0x050
 #define I2C_RX_FIFO				0x054
 #define I2C_PACKET_TRANSFER_STATUS		0x058
@@ -97,6 +99,9 @@
 #define I2C_HEADER_MASTER_ADDR_SHIFT		12
 #define I2C_HEADER_SLAVE_ADDR_SHIFT		1
 
+#define SL_ADDR1(addr)				(addr & 0xff)
+#define SL_ADDR2(addr)				((addr >> 8) & 0xff)
+
 /**
  * struct tegra_i2c_dev	- per device i2c context
  * @dev: device reference for power management
@@ -126,6 +131,7 @@ struct tegra_i2c_dev {
 	int cont_id;
 	int irq;
 	int is_dvc;
+	bool is_slave;
 	struct completion msg_complete;
 	int msg_err;
 	u8 *msg_buf;
@@ -133,6 +139,7 @@ struct tegra_i2c_dev {
 	int msg_read;
 	unsigned long bus_clk_rate;
 	bool is_suspended;
+	u16 slave_addr;
 };
 
 static void dvc_writel(struct tegra_i2c_dev *i2c_dev, u32 val, unsigned long reg)
@@ -315,6 +322,20 @@ static void tegra_dvc_init(struct tegra_i2c_dev *i2c_dev)
 	dvc_writel(i2c_dev, val, DVC_CTRL_REG1);
 }
 
+static void tegra_i2c_slave_init(struct tegra_i2c_dev *i2c_dev)
+{
+	u32 val = I2C_SL_CNFG_NEWSL | I2C_SL_CNFG_NACK;
+
+	i2c_writel(i2c_dev, val, I2C_SL_CNFG);
+
+	if (i2c_dev->slave_addr) {
+		u16 addr = i2c_dev->slave_addr;
+
+		i2c_writel(i2c_dev, SL_ADDR1(addr), I2C_SL_ADDR1);
+		i2c_writel(i2c_dev, SL_ADDR2(addr), I2C_SL_ADDR2);
+	}
+}
+
 static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 {
 	u32 val;
@@ -338,6 +359,9 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 		0 << I2C_FIFO_CONTROL_RX_TRIG_SHIFT;
 	i2c_writel(i2c_dev, val, I2C_FIFO_CONTROL);
 
+	if (i2c_dev->is_slave)
+		tegra_i2c_slave_init(i2c_dev);
+
 	if (tegra_i2c_flush_fifos(i2c_dev))
 		err = -ETIMEDOUT;
 
@@ -585,11 +609,15 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	i2c_dev->cont_id = pdev->id;
 	i2c_dev->dev = &pdev->dev;
 	i2c_dev->bus_clk_rate = pdata ? pdata->bus_clk_rate : 100000;
+	i2c_dev->slave_addr = pdata->slave_addr;
 
 	if (pdev->id == 3)
 		i2c_dev->is_dvc = 1;
 	init_completion(&i2c_dev->msg_complete);
 
+	if (irq == INT_I2C || irq == INT_I2C2 || irq == INT_I2C3)
+		i2c_dev->is_slave = true;
+
 	platform_set_drvdata(pdev, i2c_dev);
 
 	ret = tegra_i2c_init(i2c_dev);
diff --git a/include/linux/i2c-tegra.h b/include/linux/i2c-tegra.h
index 8ee5b37..c15c166 100644
--- a/include/linux/i2c-tegra.h
+++ b/include/linux/i2c-tegra.h
@@ -22,6 +22,7 @@ struct tegra_i2c_platform_data {
 	unsigned long bus_clk_rate;
 	int retries;
 	int timeout;	/* in jiffies */
+	u16 slave_addr;
 };
 
 #endif /* _LINUX_I2C_TEGRA_H */
-- 
1.7.0

