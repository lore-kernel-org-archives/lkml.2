Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab2EYC0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:26:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12234 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2EYC0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:26:50 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-d7-4fbeede9f3e6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Alberto Panizzo'" <alberto@amarulasolutions.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 06/13] backlight: l4f00242t03: use devm_ functions
Date: Fri, 25 May 2012 11:26:49 +0900
Message-id: <001101cd3a1d$d6864a00$8392de00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HdZysy1Jpu61SDKQrtISPAbDtQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd2Xb/f5G8xrFLG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZH06uYS14I1bxprWFtYFxn1AXIyeHhICJxL5pzewQtpjEhXvr
	2boYuTiEBBYxSky9upMdwpnNJDHh7hJGkCo2ATWJL18Og3WICERINM+YxQxSxCzQxCjx9kUb
	G0hCWMBJ4vb3RywgNouAqsSzf42sIDavgK1E/98WKFtQ4sfke2A1zAJaEpu3NbFC2PISm9e8
	BRrKAXSSusSjv7oQu/QkTnevZoMoEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBc
	UJyUnmukV5yYW1yal66XnJ+7iREcms+kdzCuarA4xCjAwajEwxvwZp+/EGtiWXFl7iFGCQ5m
	JRFewUigEG9KYmVValF+fFFpTmrxIUZpDhYlcd4nS3b4CwmkJ5akZqemFqQWwWSZODilGhi7
	Ei/8SDfbeydQi/P87Vd7939XNhf3Zq1kNVHwczx5USesIEGqqG+XcnlNYsOa5zuafH5s8DhU
	dHnSicoZyt638h2kjK6+bfe6HmIutKgm4u/WbDntRkuBlz1NcX/4KxS8UqMPlsVnHm49e7Hj
	KsclzuetO1ziH1ZPkQl5q/onkj9+nUVMmBJLcUaioRZzUXEiAGKe+KBJAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Alberto Panizzo <alberto@amarulasolutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/l4f00242t03.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 6022b67..9ec3b3e 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -159,7 +159,8 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(struct l4f00242t03_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&spi->dev, sizeof(struct l4f00242t03_priv),
+				GFP_KERNEL);
 
 	if (priv == NULL) {
 		dev_err(&spi->dev, "No memory for this device.\n");
@@ -177,7 +178,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 reset gpio.\n");
-		goto err;
+		return ret;
 	}
 
 	ret = gpio_request_one(pdata->data_enable_gpio, GPIOF_OUT_INIT_LOW,
@@ -185,7 +186,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 data en gpio.\n");
-		goto err2;
+		goto err;
 	}
 
 	priv->io_reg = regulator_get(&spi->dev, "vdd");
@@ -193,7 +194,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 		ret = PTR_ERR(priv->io_reg);
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
-		goto err3;
+		goto err2;
 	}
 
 	priv->core_reg = regulator_get(&spi->dev, "vcore");
@@ -201,14 +202,14 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
-		goto err4;
+		goto err3;
 	}
 
 	priv->ld = lcd_device_register("l4f00242t03",
 					&spi->dev, priv, &l4f_ops);
 	if (IS_ERR(priv->ld)) {
 		ret = PTR_ERR(priv->ld);
-		goto err5;
+		goto err4;
 	}
 
 	/* Init the LCD */
@@ -220,16 +221,14 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 
 	return 0;
 
-err5:
-	regulator_put(priv->core_reg);
 err4:
-	regulator_put(priv->io_reg);
+	regulator_put(priv->core_reg);
 err3:
-	gpio_free(pdata->data_enable_gpio);
+	regulator_put(priv->io_reg);
 err2:
-	gpio_free(pdata->reset_gpio);
+	gpio_free(pdata->data_enable_gpio);
 err:
-	kfree(priv);
+	gpio_free(pdata->reset_gpio);
 
 	return ret;
 }
@@ -250,8 +249,6 @@ static int __devexit l4f00242t03_remove(struct spi_device *spi)
 	regulator_put(priv->io_reg);
 	regulator_put(priv->core_reg);
 
-	kfree(priv);
-
 	return 0;
 }
 
-- 
1.7.1


