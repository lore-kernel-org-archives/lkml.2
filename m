Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2HQTVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:21:03 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4039 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2HQTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:20:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 17 Aug 2012 12:20:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <swarren@nvidia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <olof@lixom.net>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH REBASE 2/2] i2c: tegra: dynamically control fast clk
Date: Sat, 18 Aug 2012 00:32:35 +0530
Message-ID: <1345230155-4252-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
References: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra I2C driver enables the fast clock during initialization
and does not disable till driver removed.
Enable this clock before transfer and disable after transfer done.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This is rebased on linux-next-20120816.

 drivers/i2c/busses/i2c-tegra.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 554f713..24f7cee 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -362,12 +362,36 @@ static void tegra_dvc_init(struct tegra_i2c_dev *i2c_dev)
 	dvc_writel(i2c_dev, val, DVC_CTRL_REG1);
 }
 
+static inline int tegra_i2c_clock_enable(struct tegra_i2c_dev *i2c_dev)
+{
+	int ret;
+	ret = clk_prepare_enable(i2c_dev->fast_clk);
+	if (ret < 0) {
+		dev_err(i2c_dev->dev,
+			"Enabling fast clk failed, err %d\n", ret);
+		return ret;
+	}
+	ret = clk_prepare_enable(i2c_dev->div_clk);
+	if (ret < 0) {
+		dev_err(i2c_dev->dev,
+			"Enabling div clk failed, err %d\n", ret);
+		clk_disable_unprepare(i2c_dev->fast_clk);
+	}
+	return ret;
+}
+
+static inline void tegra_i2c_clock_disable(struct tegra_i2c_dev *i2c_dev)
+{
+	clk_disable_unprepare(i2c_dev->div_clk);
+	clk_disable_unprepare(i2c_dev->fast_clk);
+}
+
 static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 {
 	u32 val;
 	int err = 0;
 
-	clk_prepare_enable(i2c_dev->div_clk);
+	tegra_i2c_clock_enable(i2c_dev);
 
 	tegra_periph_reset_assert(i2c_dev->div_clk);
 	udelay(2);
@@ -398,7 +422,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	if (tegra_i2c_flush_fifos(i2c_dev))
 		err = -ETIMEDOUT;
 
-	clk_disable_unprepare(i2c_dev->div_clk);
+	tegra_i2c_clock_disable(i2c_dev);
 
 	if (i2c_dev->irq_disabled) {
 		i2c_dev->irq_disabled = 0;
@@ -584,7 +608,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		}
 	}
 
-	clk_prepare_enable(i2c_dev->clk);
+	tegra_i2c_clock_enable(i2c_dev);
 	for (i = 0; i < num; i++) {
 		enum msg_end_type end_type = MSG_END_STOP;
 		if (i < (num - 1)) {
@@ -597,7 +621,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		if (ret)
 			break;
 	}
-	clk_disable_unprepare(i2c_dev->div_clk);
+	tegra_i2c_clock_disable(i2c_dev);
 	return ret ?: i;
 }
 
@@ -734,8 +758,6 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk_prepare_enable(i2c_dev->fast_clk);
-
 	i2c_set_adapdata(&i2c_dev->adapter, i2c_dev);
 	i2c_dev->adapter.owner = THIS_MODULE;
 	i2c_dev->adapter.class = I2C_CLASS_HWMON;
@@ -749,7 +771,6 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add I2C adapter\n");
-		clk_disable_unprepare(i2c_dev->fast_clk);
 		return ret;
 	}
 
-- 
1.7.1.1

