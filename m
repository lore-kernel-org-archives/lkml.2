Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1HEXPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 19:15:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47971 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab1HEXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 19:15:10 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Dilan Lee <dilee@nvidia.com>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
Date: Fri,  5 Aug 2011 17:15:02 -0600
Message-Id: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dilan Lee <dilee@nvidia.com>

We found the register settings of wm8903(an audio codec) can't be modified
in snd_soc_suspend since I2C bus has been suspended before snd_soc_suspend.

Pop noise will occur when system resume from LP0 if the register settings of wm8903
haven't be modified correctly in snd_soc_suspend.

So, we use the suspend_noirq/resume_noirq callbacks to make sure I2C bus still
operates while running snd_soc_suspend.

Signed-off-by: Dilan Lee <dilee@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
When applying this, you'll get a trivial merge conflict with the other
i2c-tegra.c patch I just reposted titled "i2c: Tegra: Add of_match_table".
Just add the two lines to tegra_i2c_driver.driver in whichever order you
prefer:-).

 drivers/i2c/busses/i2c-tegra.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 0c6e840..3d2bf19 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -687,8 +687,9 @@ static int tegra_i2c_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
+static int tegra_i2c_suspend_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 
 	i2c_lock_adapter(&i2c_dev->adapter);
@@ -698,8 +699,9 @@ static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int tegra_i2c_resume(struct platform_device *pdev)
+static int tegra_i2c_resume_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 	int ret;
 
@@ -718,18 +720,23 @@ static int tegra_i2c_resume(struct platform_device *pdev)
 
 	return 0;
 }
+
+static const struct dev_pm_ops tegra_i2c_dev_pm_ops = {
+	.suspend_noirq = tegra_i2c_suspend_noirq,
+	.resume_noirq = tegra_i2c_resume_noirq,
+};
+#define TEGRA_I2C_DEV_PM_OPS (&tegra_i2c_dev_pm_ops)
+#else
+#define TEGRA_I2C_DEV_PM_OPS NULL
 #endif
 
 static struct platform_driver tegra_i2c_driver = {
 	.probe   = tegra_i2c_probe,
 	.remove  = tegra_i2c_remove,
-#ifdef CONFIG_PM
-	.suspend = tegra_i2c_suspend,
-	.resume  = tegra_i2c_resume,
-#endif
 	.driver  = {
 		.name  = "tegra-i2c",
 		.owner = THIS_MODULE,
+		.pm    = TEGRA_I2C_DEV_PM_OPS,
 	},
 };
 
-- 
1.7.0.4

