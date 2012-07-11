Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab2GKTWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:22:48 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066Ab2GKTWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:22:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] i2c-tegra: Use struct dev_pm_ops for power management
Date: Wed, 11 Jul 2012 21:27:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Peter Korsgaard <jacmet@sunsite.dk>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Vitaly Wool <vitalywool@gmail.com>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <201207112121.11046.rjw@sisk.pl>
In-Reply-To: <201207112121.11046.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207112127.31139.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the Tegra I2C controller driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/i2c/busses/i2c-tegra.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: linux/drivers/i2c/busses/i2c-tegra.c
===================================================================
--- linux.orig/drivers/i2c/busses/i2c-tegra.c
+++ linux/drivers/i2c/busses/i2c-tegra.c
@@ -717,9 +717,9 @@ static int __devexit tegra_i2c_remove(st
 }
 
 #ifdef CONFIG_PM
-static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
+static int tegra_i2c_suspend(struct device *dev)
 {
-	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
+	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 
 	i2c_lock_adapter(&i2c_dev->adapter);
 	i2c_dev->is_suspended = true;
@@ -728,9 +728,9 @@ static int tegra_i2c_suspend(struct plat
 	return 0;
 }
 
-static int tegra_i2c_resume(struct platform_device *pdev)
+static int tegra_i2c_resume(struct device *dev)
 {
-	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
+	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 	int ret;
 
 	i2c_lock_adapter(&i2c_dev->adapter);
@@ -748,6 +748,11 @@ static int tegra_i2c_resume(struct platf
 
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_suspend, tegra_i2c_resume);
+#define TEGRA_I2C_PM	(&tegra_i2c_pm)
+#else
+#define TEGRA_I2C_PM	NULL
 #endif
 
 #if defined(CONFIG_OF)
@@ -765,14 +770,11 @@ MODULE_DEVICE_TABLE(of, tegra_i2c_of_mat
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
 		.of_match_table = tegra_i2c_of_match,
+		.pm    = TEGRA_I2C_PM,
 	},
 };
 

