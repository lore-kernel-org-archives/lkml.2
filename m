Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab2GKTWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:22:24 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35961 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab2GKTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:22:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] i2c-at91: Use struct dev_pm_ops for power management
Date: Wed, 11 Jul 2012 21:22:47 +0200
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
Message-Id: <201207112122.47495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the AT91 Two-Wire Interface driver define its PM callbacks
through a struct dev_pm_ops object rather than by using legacy PM
hooks in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/i2c/busses/i2c-at91.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/drivers/i2c/busses/i2c-at91.c
===================================================================
--- linux.orig/drivers/i2c/busses/i2c-at91.c
+++ linux/drivers/i2c/busses/i2c-at91.c
@@ -279,30 +279,31 @@ static int __devexit at91_i2c_remove(str
 
 /* NOTE: could save a few mA by keeping clock off outside of at91_xfer... */
 
-static int at91_i2c_suspend(struct platform_device *pdev, pm_message_t mesg)
+static int at91_i2c_suspend(struct device *dev)
 {
 	clk_disable(twi_clk);
 	return 0;
 }
 
-static int at91_i2c_resume(struct platform_device *pdev)
+static int at91_i2c_resume(struct device *dev)
 {
 	return clk_enable(twi_clk);
 }
 
+static SIMPLE_DEV_PM_OPS(at91_i2c_pm, at91_i2c_suspend, at91_i2c_resume);
+#define AT91_I2C_PM	(&at91_i2c_pm)
+
 #else
-#define at91_i2c_suspend	NULL
-#define at91_i2c_resume		NULL
+#define AT91_I2C_PM	NULL
 #endif
 
 static struct platform_driver at91_i2c_driver = {
 	.probe		= at91_i2c_probe,
 	.remove		= __devexit_p(at91_i2c_remove),
-	.suspend	= at91_i2c_suspend,
-	.resume		= at91_i2c_resume,
 	.driver		= {
 		.name	= "at91_i2c",
 		.owner	= THIS_MODULE,
+		.pm	= AT91_I2C_PM,
 	},
 };
 

