Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2HRTgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 15:36:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12320 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2HRTgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 15:36:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 18 Aug 2012 12:36:07 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <swarren@nvidia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/2] i2c: tegra: dynamically control fast clk
Date: Sun, 19 Aug 2012 00:47:47 +0530
Message-ID: <1345317467-22258-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1345317467-22258-1-git-send-email-ldewangan@nvidia.com>
References: <1345317467-22258-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra I2C driver enables the fast clock during initialization
and does not disable till driver removed.
Enable this clock before transfer and disable after transfer done.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
---

Changes from V1:
- Rebased again on patch 1.

 drivers/i2c/busses/i2c-tegra.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 2f74236..20c35fa 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -363,12 +363,36 @@ static void tegra_dvc_init(struct tegra_i2c_dev *i2c_dev)
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
@@ -399,7 +423,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	if (tegra_i2c_flush_fifos(i2c_dev))
 		err = -ETIMEDOUT;
 
-	clk_disable_unprepare(i2c_dev->div_clk);
+	tegra_i2c_clock_disable(i2c_dev);
 
 	if (i2c_dev->irq_disabled) {
 		i2c_dev->irq_disabled = 0;
@@ -575,7 +599,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	if (i2c_dev->is_suspended)
 		return -EBUSY;
 
-	clk_prepare_enable(i2c_dev->div_clk);
+	tegra_i2c_clock_enable(i2c_dev);
 	for (i = 0; i < num; i++) {
 		enum msg_end_type end_type = MSG_END_STOP;
 		if (i < (num - 1)) {
@@ -588,7 +612,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		if (ret)
 			break;
 	}
-	clk_disable_unprepare(i2c_dev->div_clk);
+	tegra_i2c_clock_disable(i2c_dev);
 	return ret ?: i;
 }
 
@@ -724,8 +748,6 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk_prepare_enable(i2c_dev->fast_clk);
-
 	i2c_set_adapdata(&i2c_dev->adapter, i2c_dev);
 	i2c_dev->adapter.owner = THIS_MODULE;
 	i2c_dev->adapter.class = I2C_CLASS_HWMON;
@@ -739,7 +761,6 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add I2C adapter\n");
-		clk_disable_unprepare(i2c_dev->fast_clk);
 		return ret;
 	}
 
-- 
1.7.1.1

