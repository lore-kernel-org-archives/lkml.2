Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab2GKTWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:22:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab2GKTWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:22:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] i2c-pnx: Use struct dev_pm_ops for power management
Date: Wed, 11 Jul 2012 21:25:17 +0200
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
Message-Id: <201207112125.18040.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the PNX I2C controller driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/i2c/busses/i2c-pnx.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: linux/drivers/i2c/busses/i2c-pnx.c
===================================================================
--- linux.orig/drivers/i2c/busses/i2c-pnx.c
+++ linux/drivers/i2c/busses/i2c-pnx.c
@@ -587,25 +587,27 @@ static struct i2c_algorithm pnx_algorith
 };
 
 #ifdef CONFIG_PM
-static int i2c_pnx_controller_suspend(struct platform_device *pdev,
-				      pm_message_t state)
+static int i2c_pnx_controller_suspend(struct device *dev)
 {
-	struct i2c_pnx_algo_data *alg_data = platform_get_drvdata(pdev);
+	struct i2c_pnx_algo_data *alg_data = dev_get_drvdata(dev);
 
 	clk_disable(alg_data->clk);
 
 	return 0;
 }
 
-static int i2c_pnx_controller_resume(struct platform_device *pdev)
+static int i2c_pnx_controller_resume(struct device *dev)
 {
-	struct i2c_pnx_algo_data *alg_data = platform_get_drvdata(pdev);
+	struct i2c_pnx_algo_data *alg_data = dev_get_drvdata(dev);
 
 	return clk_enable(alg_data->clk);
 }
+
+static SIMPLE_DEV_PM_OPS(i2c_pnx_pm,
+			 i2c_pnx_controller_suspend, i2c_pnx_controller_resume);
+#define PNX_I2C_PM	(&i2c_pnx_pm)
 #else
-#define i2c_pnx_controller_suspend	NULL
-#define i2c_pnx_controller_resume	NULL
+#define PNX_I2C_PM	NULL
 #endif
 
 static int __devinit i2c_pnx_probe(struct platform_device *pdev)
@@ -783,11 +785,10 @@ static struct platform_driver i2c_pnx_dr
 		.name = "pnx-i2c",
 		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(i2c_pnx_of_match),
+		.pm = PNX_I2C_PM,
 	},
 	.probe = i2c_pnx_probe,
 	.remove = __devexit_p(i2c_pnx_remove),
-	.suspend = i2c_pnx_controller_suspend,
-	.resume = i2c_pnx_controller_resume,
 };
 
 static int __init i2c_adap_pnx_init(void)

