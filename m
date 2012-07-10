Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2GJL2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:28:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6198 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2GJL2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:28:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 10 Jul 2012 04:27:23 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>, <khali@linux-fr.org>, <ben-linux@fluff.org>
CC: <swarren@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/5] i2c: tegra: Use struct dev_pm_ops for power management
Date: Tue, 10 Jul 2012 16:50:43 +0530
Message-ID: <1341919244-23327-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the tegra i2c driver define its PM callbacks through
struct dev_pm_ops objects rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 0792674..5f0572d 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -713,8 +713,9 @@ static int __devexit tegra_i2c_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
+static int tegra_i2c_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 
 	i2c_lock_adapter(&i2c_dev->adapter);
@@ -724,8 +725,9 @@ static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int tegra_i2c_resume(struct platform_device *pdev)
+static int tegra_i2c_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 	int ret;
 
@@ -744,6 +746,14 @@ static int tegra_i2c_resume(struct platform_device *pdev)
 
 	return 0;
 }
+
+static const struct dev_pm_ops tegra_i2c_dev_pm_ops = {
+	.suspend = tegra_i2c_suspend,
+	.resume = tegra_i2c_resume,
+};
+#define TEGRA_I2C_DEV_PM_OPS (&tegra_i2c_dev_pm_ops)
+#else
+#define TEGRA_I2C_DEV_PM_OPS NULL
 #endif
 
 #if defined(CONFIG_OF)
@@ -759,14 +769,11 @@ MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
 static struct platform_driver tegra_i2c_driver = {
 	.probe   = tegra_i2c_probe,
 	.remove  = __devexit_p(tegra_i2c_remove),
-#ifdef CONFIG_PM
-	.suspend = tegra_i2c_suspend,
-	.resume  = tegra_i2c_resume,
-#endif
 	.driver  = {
 		.name  = "tegra-i2c",
 		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(tegra_i2c_of_match),
+		.pm = TEGRA_I2C_DEV_PM_OPS,
 	},
 };
 
-- 
1.7.1.1

