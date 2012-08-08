Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2HHIKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:10:01 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3692 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab2HHIHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:07:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 08 Aug 2012 01:01:38 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <w.sang@pengutronix.de>, <olof@lixom.net>,
        <khali@linux-fr.org>
CC: <ben-linux@fluff.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] i2c: tegra: pass proper name for getting clock
Date: Wed, 8 Aug 2012 13:21:32 +0530
Message-ID: <1344412294-2420-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
References: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra's i2c controller require two clock sources named as
div_clk and fast_clk.
This change make sure that driver pass the correct clock's
name when it acquires clock handle. Also change the
variable name to reflect the correct clock handles.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   46 ++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 66eb53f..7149625 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -117,8 +117,8 @@ enum msg_end_type {
  * struct tegra_i2c_dev	- per device i2c context
  * @dev: device reference for power management
  * @adapter: core i2c layer adapter information
- * @clk: clock reference for i2c controller
- * @i2c_clk: clock reference for i2c bus
+ * @div_clk: clock reference for div clock of i2c controller.
+ * @fast_clk: clock reference for fast clock of i2c controller.
  * @base: ioremapped registers cookie
  * @cont_id: i2c controller id, used for for packet header
  * @irq: irq number of transfer complete interrupt
@@ -134,8 +134,8 @@ enum msg_end_type {
 struct tegra_i2c_dev {
 	struct device *dev;
 	struct i2c_adapter adapter;
-	struct clk *clk;
-	struct clk *i2c_clk;
+	struct clk *div_clk;
+	struct clk *fast_clk;
 	void __iomem *base;
 	int cont_id;
 	int irq;
@@ -356,11 +356,11 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	u32 val;
 	int err = 0;
 
-	clk_prepare_enable(i2c_dev->clk);
+	clk_prepare_enable(i2c_dev->div_clk);
 
-	tegra_periph_reset_assert(i2c_dev->clk);
+	tegra_periph_reset_assert(i2c_dev->div_clk);
 	udelay(2);
-	tegra_periph_reset_deassert(i2c_dev->clk);
+	tegra_periph_reset_deassert(i2c_dev->div_clk);
 
 	if (i2c_dev->is_dvc)
 		tegra_dvc_init(i2c_dev);
@@ -369,7 +369,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 		(0x2 << I2C_CNFG_DEBOUNCE_CNT_SHIFT);
 	i2c_writel(i2c_dev, val, I2C_CNFG);
 	i2c_writel(i2c_dev, 0, I2C_INT_MASK);
-	clk_set_rate(i2c_dev->clk, i2c_dev->bus_clk_rate * 8);
+	clk_set_rate(i2c_dev->div_clk, i2c_dev->bus_clk_rate * 8);
 
 	if (!i2c_dev->is_dvc) {
 		u32 sl_cfg = i2c_readl(i2c_dev, I2C_SL_CNFG);
@@ -387,7 +387,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	if (tegra_i2c_flush_fifos(i2c_dev))
 		err = -ETIMEDOUT;
 
-	clk_disable_unprepare(i2c_dev->clk);
+	clk_disable_unprepare(i2c_dev->div_clk);
 
 	if (i2c_dev->irq_disabled) {
 		i2c_dev->irq_disabled = 0;
@@ -563,7 +563,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	if (i2c_dev->is_suspended)
 		return -EBUSY;
 
-	clk_prepare_enable(i2c_dev->clk);
+	clk_prepare_enable(i2c_dev->div_clk);
 	for (i = 0; i < num; i++) {
 		enum msg_end_type end_type = MSG_END_STOP;
 		if (i < (num - 1)) {
@@ -576,7 +576,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		if (ret)
 			break;
 	}
-	clk_disable_unprepare(i2c_dev->clk);
+	clk_disable_unprepare(i2c_dev->div_clk);
 	return ret ?: i;
 }
 
@@ -596,8 +596,8 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	struct tegra_i2c_dev *i2c_dev;
 	struct tegra_i2c_platform_data *pdata = pdev->dev.platform_data;
 	struct resource *res;
-	struct clk *clk;
-	struct clk *i2c_clk;
+	struct clk *div_clk;
+	struct clk *fast_clk;
 	const unsigned int *prop;
 	void __iomem *base;
 	int irq;
@@ -622,16 +622,16 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	}
 	irq = res->start;
 
-	clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk)) {
+	div_clk = devm_clk_get(&pdev->dev, "div-clk");
+	if (IS_ERR(div_clk)) {
 		dev_err(&pdev->dev, "missing controller clock");
-		return PTR_ERR(clk);
+		return PTR_ERR(div_clk);
 	}
 
-	i2c_clk = devm_clk_get(&pdev->dev, "i2c");
-	if (IS_ERR(i2c_clk)) {
+	fast_clk = devm_clk_get(&pdev->dev, "fast-clk");
+	if (IS_ERR(fast_clk)) {
 		dev_err(&pdev->dev, "missing bus clock");
-		return PTR_ERR(i2c_clk);
+		return PTR_ERR(fast_clk);
 	}
 
 	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
@@ -641,8 +641,8 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	}
 
 	i2c_dev->base = base;
-	i2c_dev->clk = clk;
-	i2c_dev->i2c_clk = i2c_clk;
+	i2c_dev->div_clk = div_clk;
+	i2c_dev->fast_clk = fast_clk;
 	i2c_dev->adapter.algo = &tegra_i2c_algo;
 	i2c_dev->irq = irq;
 	i2c_dev->cont_id = pdev->id;
@@ -681,7 +681,7 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk_prepare_enable(i2c_dev->i2c_clk);
+	clk_prepare_enable(i2c_dev->fast_clk);
 
 	i2c_set_adapdata(&i2c_dev->adapter, i2c_dev);
 	i2c_dev->adapter.owner = THIS_MODULE;
@@ -696,7 +696,7 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add I2C adapter\n");
-		clk_disable_unprepare(i2c_dev->i2c_clk);
+		clk_disable_unprepare(i2c_dev->fast_clk);
 		return ret;
 	}
 
-- 
1.7.1.1

