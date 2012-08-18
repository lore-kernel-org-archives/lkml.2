Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2HRTg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 15:36:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2037 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2HRTg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 15:36:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 18 Aug 2012 12:36:04 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <swarren@nvidia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/2] i2c: tegra: I2_M_NOSTART functionality not supported in Tegra20
Date: Sun, 19 Aug 2012 00:47:46 +0530
Message-ID: <1345317467-22258-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra20 i2c controller does not support the continue transfer
which implements the I2C_M_NOSTART functionality of i2c
protocol mangling.
Removing the I2C_M_NOSTART functionality support for Tegra20.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- make the hw feature structure as part of tegra device structure in
  place of copying the member.
- Remove check for extra M_NOSTART flag if it is not supported in xfer function.

Please note that this should go on tegra common clock source tree to avoid conflicts.

 drivers/i2c/busses/i2c-tegra.c |   61 ++++++++++++++++++++++++++++++---------
 1 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 7149625..2f74236 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/i2c-tegra.h>
 #include <linux/of_i2c.h>
+#include <linux/of_device.h>
 #include <linux/module.h>
 
 #include <asm/unaligned.h>
@@ -114,8 +115,18 @@ enum msg_end_type {
 };
 
 /**
+ * struct tegra_i2c_hw_feature : Different HW support on Tegra
+ * @has_continue_xfer_support: Continue transfer supports.
+ */
+
+struct tegra_i2c_hw_feature {
+	bool has_continue_xfer_support;
+};
+
+/**
  * struct tegra_i2c_dev	- per device i2c context
  * @dev: device reference for power management
+ * @hw: Tegra i2c hw feature.
  * @adapter: core i2c layer adapter information
  * @div_clk: clock reference for div clock of i2c controller.
  * @fast_clk: clock reference for fast clock of i2c controller.
@@ -133,6 +144,7 @@ enum msg_end_type {
  */
 struct tegra_i2c_dev {
 	struct device *dev;
+	const struct tegra_i2c_hw_feature *hw;
 	struct i2c_adapter adapter;
 	struct clk *div_clk;
 	struct clk *fast_clk;
@@ -582,8 +594,13 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 
 static u32 tegra_i2c_func(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
-		I2C_FUNC_PROTOCOL_MANGLING | I2C_FUNC_NOSTART;
+	struct tegra_i2c_dev *i2c_dev = i2c_get_adapdata(adap);
+	u32 ret = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
+				I2C_FUNC_PROTOCOL_MANGLING;
+
+	if (i2c_dev->hw->has_continue_xfer_support)
+		ret |= I2C_FUNC_NOSTART;
+	return ret;
 }
 
 static const struct i2c_algorithm tegra_i2c_algo = {
@@ -591,6 +608,25 @@ static const struct i2c_algorithm tegra_i2c_algo = {
 	.functionality	= tegra_i2c_func,
 };
 
+static const struct tegra_i2c_hw_feature tegra20_i2c_hw = {
+	.has_continue_xfer_support = false,
+};
+
+static const struct tegra_i2c_hw_feature tegra30_i2c_hw = {
+	.has_continue_xfer_support = true,
+};
+
+#if defined(CONFIG_OF)
+/* Match table for of_platform binding */
+static const struct of_device_id tegra_i2c_of_match[] __devinitconst = {
+	{ .compatible = "nvidia,tegra30-i2c", .data = &tegra30_i2c_hw, },
+	{ .compatible = "nvidia,tegra20-i2c", .data = &tegra20_i2c_hw, },
+	{ .compatible = "nvidia,tegra20-i2c-dvc", .data = &tegra20_i2c_hw, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
+#endif
+
 static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 {
 	struct tegra_i2c_dev *i2c_dev;
@@ -659,11 +695,18 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 			i2c_dev->bus_clk_rate = be32_to_cpup(prop);
 	}
 
-	if (pdev->dev.of_node)
+	i2c_dev->hw = &tegra20_i2c_hw;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_device(of_match_ptr(tegra_i2c_of_match),
+						&pdev->dev);
+		i2c_dev->hw = match->data;
 		i2c_dev->is_dvc = of_device_is_compatible(pdev->dev.of_node,
 						"nvidia,tegra20-i2c-dvc");
-	else if (pdev->id == 3)
+	} else if (pdev->id == 3) {
 		i2c_dev->is_dvc = 1;
+	}
 	init_completion(&i2c_dev->msg_complete);
 
 	platform_set_drvdata(pdev, i2c_dev);
@@ -751,16 +794,6 @@ static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_suspend, tegra_i2c_resume);
 #define TEGRA_I2C_PM	NULL
 #endif
 
-#if defined(CONFIG_OF)
-/* Match table for of_platform binding */
-static const struct of_device_id tegra_i2c_of_match[] __devinitconst = {
-	{ .compatible = "nvidia,tegra20-i2c", },
-	{ .compatible = "nvidia,tegra20-i2c-dvc", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
-#endif
-
 static struct platform_driver tegra_i2c_driver = {
 	.probe   = tegra_i2c_probe,
 	.remove  = __devexit_p(tegra_i2c_remove),
-- 
1.7.1.1

