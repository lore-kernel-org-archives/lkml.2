Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3AEMG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 07:06:26 -0500
Received: from [216.228.121.35] ([216.228.121.35]:4505 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3AEMGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 07:06:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 05 Jan 2013 04:05:04 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>
CC: <swarren@nvidia.com>, <khali@linux-fr.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] i2c: tegra: add support for Tegra114 SoC
Date: Sat, 5 Jan 2013 17:34:46 +0530
Message-ID: <1357387486-25966-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 has following enhanced feature in i2c controller:
- Enable/disable control for per packet transfer complete interrupt.
  Earlier SoCs could not disable this.
- Single clock source for standard/fast and HS mode clock speed.
  The clock divisor for fast/standard mode is added into the i2c
  controller to meet the HS and standard/fast mode of clock speed
  from single source.

Add support for the above feature to make it functional on T114 SOCs.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   77 ++++++++++++++++++++++++++++++++-------
 1 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 7b38877..2dadb96 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -71,6 +71,8 @@
 #define I2C_INT_TX_FIFO_DATA_REQ		(1<<1)
 #define I2C_INT_RX_FIFO_DATA_REQ		(1<<0)
 #define I2C_CLK_DIVISOR				0x06c
+#define I2C_CLK_DIVISOR_STD_FAST_MODE_SHIFT	16
+#define I2C_CLK_MULTIPLIER_STD_FAST_MODE	8
 
 #define DVC_CTRL_REG1				0x000
 #define DVC_CTRL_REG1_INTR_EN			(1<<10)
@@ -117,10 +119,23 @@ enum msg_end_type {
 /**
  * struct tegra_i2c_hw_feature : Different HW support on Tegra
  * @has_continue_xfer_support: Continue transfer supports.
+ * @has_per_pkt_xfer_complete_irq: Has enable/disable capability for transfer
+ *		complete interrupt per packet basis.
+ * @has_single_clk_source: The i2c controller has single clock source. Tegra30
+ *		and earlier Socs has two clock sources i.e. div-clk and
+ *		fast-clk.
+ * @clk_divisor_hs_mode: Clock divisor in HS mode.
+ * @clk_divisor_std_fast_mode: Clock divisor in standard/fast mode. It is
+ *		applicable if there is no fast clock source i.e. single clock
+ *		source.
  */
 
 struct tegra_i2c_hw_feature {
 	bool has_continue_xfer_support;
+	bool has_per_pkt_xfer_complete_irq;
+	bool has_single_clk_source;
+	int clk_divisor_hs_mode;
+	int clk_divisor_std_fast_mode;
 };
 
 /**
@@ -366,11 +381,13 @@ static void tegra_dvc_init(struct tegra_i2c_dev *i2c_dev)
 static inline int tegra_i2c_clock_enable(struct tegra_i2c_dev *i2c_dev)
 {
 	int ret;
-	ret = clk_prepare_enable(i2c_dev->fast_clk);
-	if (ret < 0) {
-		dev_err(i2c_dev->dev,
-			"Enabling fast clk failed, err %d\n", ret);
-		return ret;
+	if (!i2c_dev->hw->has_single_clk_source) {
+		ret = clk_prepare_enable(i2c_dev->fast_clk);
+		if (ret < 0) {
+			dev_err(i2c_dev->dev,
+				"Enabling fast clk failed, err %d\n", ret);
+			return ret;
+		}
 	}
 	ret = clk_prepare_enable(i2c_dev->div_clk);
 	if (ret < 0) {
@@ -384,13 +401,16 @@ static inline int tegra_i2c_clock_enable(struct tegra_i2c_dev *i2c_dev)
 static inline void tegra_i2c_clock_disable(struct tegra_i2c_dev *i2c_dev)
 {
 	clk_disable_unprepare(i2c_dev->div_clk);
-	clk_disable_unprepare(i2c_dev->fast_clk);
+	if (!i2c_dev->hw->has_single_clk_source)
+		clk_disable_unprepare(i2c_dev->fast_clk);
 }
 
 static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 {
 	u32 val;
 	int err = 0;
+	int clk_multiplier = I2C_CLK_MULTIPLIER_STD_FAST_MODE;
+	u32 clk_divisor;
 
 	tegra_i2c_clock_enable(i2c_dev);
 
@@ -405,7 +425,15 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 		(0x2 << I2C_CNFG_DEBOUNCE_CNT_SHIFT);
 	i2c_writel(i2c_dev, val, I2C_CNFG);
 	i2c_writel(i2c_dev, 0, I2C_INT_MASK);
-	clk_set_rate(i2c_dev->div_clk, i2c_dev->bus_clk_rate * 8);
+
+	clk_multiplier *= (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
+	clk_set_rate(i2c_dev->div_clk, i2c_dev->bus_clk_rate * clk_multiplier);
+
+	/* Make sure clock divisor programmed correctly */
+	clk_divisor = i2c_dev->hw->clk_divisor_hs_mode;
+	clk_divisor |= i2c_dev->hw->clk_divisor_std_fast_mode <<
+					I2C_CLK_DIVISOR_STD_FAST_MODE_SHIFT;
+	i2c_writel(i2c_dev, clk_divisor, I2C_CLK_DIVISOR);
 
 	if (!i2c_dev->is_dvc) {
 		u32 sl_cfg = i2c_readl(i2c_dev, I2C_SL_CNFG);
@@ -547,6 +575,8 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 		tegra_i2c_fill_tx_fifo(i2c_dev);
 
 	int_mask = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST;
+	if (i2c_dev->hw->has_per_pkt_xfer_complete_irq)
+		int_mask |= I2C_INT_PACKET_XFER_COMPLETE;
 	if (msg->flags & I2C_M_RD)
 		int_mask |= I2C_INT_RX_FIFO_DATA_REQ;
 	else if (i2c_dev->msg_buf_remaining)
@@ -634,15 +664,32 @@ static const struct i2c_algorithm tegra_i2c_algo = {
 
 static const struct tegra_i2c_hw_feature tegra20_i2c_hw = {
 	.has_continue_xfer_support = false,
+	.has_per_pkt_xfer_complete_irq = false,
+	.has_single_clk_source = false,
+	.clk_divisor_hs_mode = 3,
+	.clk_divisor_std_fast_mode = 0,
 };
 
 static const struct tegra_i2c_hw_feature tegra30_i2c_hw = {
 	.has_continue_xfer_support = true,
+	.has_per_pkt_xfer_complete_irq = false,
+	.has_single_clk_source = false,
+	.clk_divisor_hs_mode = 3,
+	.clk_divisor_std_fast_mode = 0,
+};
+
+static const struct tegra_i2c_hw_feature tegra114_i2c_hw = {
+	.has_continue_xfer_support = true,
+	.has_per_pkt_xfer_complete_irq = true,
+	.has_single_clk_source = true,
+	.clk_divisor_hs_mode = 1,
+	.clk_divisor_std_fast_mode = 0x19,
 };
 
 #if defined(CONFIG_OF)
 /* Match table for of_platform binding */
 static const struct of_device_id tegra_i2c_of_match[] = {
+	{ .compatible = "nvidia,tegra114-i2c", .data = &tegra114_i2c_hw, },
 	{ .compatible = "nvidia,tegra30-i2c", .data = &tegra30_i2c_hw, },
 	{ .compatible = "nvidia,tegra20-i2c", .data = &tegra20_i2c_hw, },
 	{ .compatible = "nvidia,tegra20-i2c-dvc", .data = &tegra20_i2c_hw, },
@@ -688,12 +735,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(div_clk);
 	}
 
-	fast_clk = devm_clk_get(&pdev->dev, "fast-clk");
-	if (IS_ERR(fast_clk)) {
-		dev_err(&pdev->dev, "missing bus clock");
-		return PTR_ERR(fast_clk);
-	}
-
 	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
 	if (!i2c_dev) {
 		dev_err(&pdev->dev, "Could not allocate struct tegra_i2c_dev");
@@ -702,7 +743,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 
 	i2c_dev->base = base;
 	i2c_dev->div_clk = div_clk;
-	i2c_dev->fast_clk = fast_clk;
 	i2c_dev->adapter.algo = &tegra_i2c_algo;
 	i2c_dev->irq = irq;
 	i2c_dev->cont_id = pdev->id;
@@ -733,6 +773,15 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	}
 	init_completion(&i2c_dev->msg_complete);
 
+	if (!i2c_dev->hw->has_single_clk_source) {
+		fast_clk = devm_clk_get(&pdev->dev, "fast-clk");
+		if (IS_ERR(fast_clk)) {
+			dev_err(&pdev->dev, "missing fast clock");
+			return PTR_ERR(fast_clk);
+		}
+		i2c_dev->fast_clk = fast_clk;
+	}
+
 	platform_set_drvdata(pdev, i2c_dev);
 
 	ret = tegra_i2c_init(i2c_dev);
-- 
1.7.1.1

