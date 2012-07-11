Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab2GKTY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:24:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab2GKTWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:22:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] i2c-bfin-twi: Use struct dev_pm_ops for power management
Date: Wed, 11 Jul 2012 21:23:31 +0200
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
Message-Id: <201207112123.31502.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the Blackfin On-Chip Two Wire Interface driver define its PM
callbacks through a struct dev_pm_ops object rather than by using
legacy PM hooks in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: linux/drivers/i2c/busses/i2c-bfin-twi.c
===================================================================
--- linux.orig/drivers/i2c/busses/i2c-bfin-twi.c
+++ linux/drivers/i2c/busses/i2c-bfin-twi.c
@@ -611,9 +611,9 @@ static struct i2c_algorithm bfin_twi_alg
 	.functionality = bfin_twi_functionality,
 };
 
-static int i2c_bfin_twi_suspend(struct platform_device *pdev, pm_message_t state)
+static int i2c_bfin_twi_suspend(struct device *dev)
 {
-	struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
+	struct bfin_twi_iface *iface = dev_get_drvdata(dev);
 
 	iface->saved_clkdiv = read_CLKDIV(iface);
 	iface->saved_control = read_CONTROL(iface);
@@ -626,14 +626,14 @@ static int i2c_bfin_twi_suspend(struct p
 	return 0;
 }
 
-static int i2c_bfin_twi_resume(struct platform_device *pdev)
+static int i2c_bfin_twi_resume(struct device *dev)
 {
-	struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
+	struct bfin_twi_iface *iface = dev_get_drvdata(dev);
 
 	int rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		0, pdev->name, iface);
+		0, to_platform_device(dev)->name, iface);
 	if (rc) {
-		dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
+		dev_err(dev, "Can't get IRQ %d !\n", iface->irq);
 		return -ENODEV;
 	}
 
@@ -646,6 +646,9 @@ static int i2c_bfin_twi_resume(struct pl
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(i2c_bfin_twi_pm,
+			 i2c_bfin_twi_suspend, i2c_bfin_twi_resume);
+
 static int i2c_bfin_twi_probe(struct platform_device *pdev)
 {
 	struct bfin_twi_iface *iface;
@@ -770,11 +773,10 @@ static int i2c_bfin_twi_remove(struct pl
 static struct platform_driver i2c_bfin_twi_driver = {
 	.probe		= i2c_bfin_twi_probe,
 	.remove		= i2c_bfin_twi_remove,
-	.suspend	= i2c_bfin_twi_suspend,
-	.resume		= i2c_bfin_twi_resume,
 	.driver		= {
 		.name	= "i2c-bfin-twi",
 		.owner	= THIS_MODULE,
+		.pm	= &i2c_bfin_twi_pm,
 	},
 };
 

