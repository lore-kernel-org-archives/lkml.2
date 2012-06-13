Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2FML0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:26:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20345 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2FML0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:26:06 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-6c-4fd878cdb2a7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Alberto Panizzo'" <alberto@amarulasolutions.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: [PATCH 7/7] backlight: l4f00242t03: use devm_gpio_request_one()
Date: Wed, 13 Jun 2012 20:26:04 +0900
Message-id: <000801cd4957$51ede520$f5c9af60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JV1HTnZsMBnu+TuK0CoJNHAdMng==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd2zFTf8Dd68YbO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZO85fYyt4JF6x6FobSwPjJuEuRk4OCQETiearp5khbDGJC/fW
	s3UxcnEICUxnlLj8/R0LhDObSWLOvBssIFVsAmoSX74cZgexRQQiJJpnzALrZhZYzCixc7s0
	iC0s4CGx+eAXsHoWAVWJ3t51jCA2r4CtxL51e1ggbEGJH5PvsUD0akms33mcCcKWl9i85i3Q
	TA6gi9QlHv3VhVilJ7Fl9iJGiBIRiX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXF
	Sem5hnrFibnFpXnpesn5uZsYwYH5TGoH48oGi0OMAhyMSjy8G4pu+AuxJpYVV+YeYpTgYFYS
	4X2WDRTiTUmsrEotyo8vKs1JLT7EKM3BoiTO22R9wV9IID2xJDU7NbUgtQgmy8TBKdXAePbH
	a8aPXBIxP8rT9/h+4rLp/rWs8fb1q0uL5Fo9xOO66gSaV3pNXmDnkjhrwr7OC0+MCnPerfq1
	bJPe7IScy78uLHsW8c7Pz/E5t4rNx1nHWRPvST5OdTJL8Sjpki6r2R/Sf10nauW1g7NYPpZu
	WKVyO0xbNa5b47mB5ZadNlE72ubylZRIKLEUZyQaajEXFScCAFvgqxlIAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_gpio_request_one of these functions.

Cc: Alberto Panizzo <alberto@amarulasolutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/l4f00242t03.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 40f606a..2d90c06 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -175,28 +175,27 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 
 	priv->spi = spi;
 
-	ret = gpio_request_one(pdata->reset_gpio, GPIOF_OUT_INIT_HIGH,
-						"lcd l4f00242t03 reset");
+	ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
+			GPIOF_OUT_INIT_HIGH, "lcd l4f00242t03 reset");
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 reset gpio.\n");
 		return ret;
 	}
 
-	ret = gpio_request_one(pdata->data_enable_gpio, GPIOF_OUT_INIT_LOW,
-						"lcd l4f00242t03 data enable");
+	ret = devm_gpio_request_one(&spi->dev, pdata->data_enable_gpio,
+			GPIOF_OUT_INIT_LOW, "lcd l4f00242t03 data enable");
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 data en gpio.\n");
-		goto err;
+		return ret;
 	}
 
 	priv->io_reg = regulator_get(&spi->dev, "vdd");
 	if (IS_ERR(priv->io_reg)) {
-		ret = PTR_ERR(priv->io_reg);
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
-		goto err2;
+		return PTR_ERR(priv->io_reg);
 	}
 
 	priv->core_reg = regulator_get(&spi->dev, "vcore");
@@ -204,14 +203,14 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
-		goto err3;
+		goto err1;
 	}
 
 	priv->ld = lcd_device_register("l4f00242t03",
 					&spi->dev, priv, &l4f_ops);
 	if (IS_ERR(priv->ld)) {
 		ret = PTR_ERR(priv->ld);
-		goto err4;
+		goto err2;
 	}
 
 	/* Init the LCD */
@@ -223,14 +222,10 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 
 	return 0;
 
-err4:
+err2:
 	regulator_put(priv->core_reg);
-err3:
+err1:
 	regulator_put(priv->io_reg);
-err2:
-	gpio_free(pdata->data_enable_gpio);
-err:
-	gpio_free(pdata->reset_gpio);
 
 	return ret;
 }
@@ -238,16 +233,12 @@ err:
 static int __devexit l4f00242t03_remove(struct spi_device *spi)
 {
 	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
-	struct l4f00242t03_pdata *pdata = priv->spi->dev.platform_data;
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
 
 	dev_set_drvdata(&spi->dev, NULL);
 
-	gpio_free(pdata->data_enable_gpio);
-	gpio_free(pdata->reset_gpio);
-
 	regulator_put(priv->io_reg);
 	regulator_put(priv->core_reg);
 
-- 
1.7.1


