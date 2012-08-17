Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2HQTUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:20:53 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12772 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2HQTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:20:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 17 Aug 2012 12:20:42 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <swarren@nvidia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <olof@lixom.net>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH REBASE 1/2] i2c: tegra: I2_M_NOSTART functionality not supported in Tegra20
Date: Sat, 18 Aug 2012 00:32:34 +0530
Message-ID: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra20 i2c controller does not support the continue transfer
which implements the I2C_M_NOSTART functionality of i2c
protocol mangling.
Removing the I2C_M_NOSTART functionality for Tegra20.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This is rebased on linux-next-20120816.

 drivers/i2c/busses/i2c-tegra.c |   73 +++++++++++++++++++++++++++++++--------
 1 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 7149625..554f713 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/i2c-tegra.h>
 #include <linux/of_i2c.h>
+#include <linux/of_device.h>
 #include <linux/module.h>
 
 #include <asm/unaligned.h>
@@ -114,6 +115,15 @@ enum msg_end_type {
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
  * @adapter: core i2c layer adapter information
@@ -148,6 +158,7 @@ struct tegra_i2c_dev {
 	int msg_read;
 	unsigned long bus_clk_rate;
 	bool is_suspended;
+	bool has_continue_xfer_support;
 };
 
 static void dvc_writel(struct tegra_i2c_dev *i2c_dev, u32 val, unsigned long reg)
@@ -563,7 +574,17 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	if (i2c_dev->is_suspended)
 		return -EBUSY;
 
-	clk_prepare_enable(i2c_dev->div_clk);
+	/* Support I2C_M_NOSTART only if HW support continue xfer. */
+	for (i = 0; i < num - 1; i++) {
+		if ((msgs[i + 1].flags & I2C_M_NOSTART) &&
+			!i2c_dev->has_continue_xfer_support) {
+			dev_err(i2c_dev->dev,
+				"mesg %d have illegal flag\n", i + 1);
+			return -EINVAL;
+		}
+	}
+
+	clk_prepare_enable(i2c_dev->clk);
 	for (i = 0; i < num; i++) {
 		enum msg_end_type end_type = MSG_END_STOP;
 		if (i < (num - 1)) {
@@ -582,8 +603,13 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 
 static u32 tegra_i2c_func(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
-		I2C_FUNC_PROTOCOL_MANGLING | I2C_FUNC_NOSTART;
+	struct tegra_i2c_dev *i2c_dev = i2c_get_adapdata(adap);
+	u32 ret = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
+				I2C_FUNC_PROTOCOL_MANGLING;
+
+	if (i2c_dev->has_continue_xfer_support)
+		ret |= I2C_FUNC_NOSTART;
+	return ret;
 }
 
 static const struct i2c_algorithm tegra_i2c_algo = {
@@ -591,6 +617,25 @@ static const struct i2c_algorithm tegra_i2c_algo = {
 	.functionality	= tegra_i2c_func,
 };
 
+static struct tegra_i2c_hw_feature tegra20_i2c_hw = {
+	.has_continue_xfer_support = false,
+};
+
+static struct tegra_i2c_hw_feature tegra30_i2c_hw = {
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
@@ -600,6 +645,7 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	struct clk *fast_clk;
 	const unsigned int *prop;
 	void __iomem *base;
+	const struct tegra_i2c_hw_feature *hw = &tegra20_i2c_hw;
 	int irq;
 	int ret = 0;
 
@@ -659,11 +705,18 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 			i2c_dev->bus_clk_rate = be32_to_cpup(prop);
 	}
 
-	if (pdev->dev.of_node)
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_device(of_match_ptr(tegra_i2c_of_match),
+						&pdev->dev);
+		hw = match->data;
 		i2c_dev->is_dvc = of_device_is_compatible(pdev->dev.of_node,
 						"nvidia,tegra20-i2c-dvc");
-	else if (pdev->id == 3)
+	} else if (pdev->id == 3) {
 		i2c_dev->is_dvc = 1;
+	}
+
+	i2c_dev->has_continue_xfer_support = hw->has_continue_xfer_support;
 	init_completion(&i2c_dev->msg_complete);
 
 	platform_set_drvdata(pdev, i2c_dev);
@@ -751,16 +804,6 @@ static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_suspend, tegra_i2c_resume);
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

