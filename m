Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3AGFRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:17:01 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54033 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3AGFQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:16:57 -0500
Message-ID: <1357535807.14526.1.camel@phoenix>
Subject: [PATCH] backlight: l4f00242t03: Convert to devm_regulator_get
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2013 13:16:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/video/backlight/l4f00242t03.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 9bef9cf..fb61557 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -190,27 +190,24 @@ static int l4f00242t03_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	priv->io_reg = regulator_get(&spi->dev, "vdd");
+	priv->io_reg = devm_regulator_get(&spi->dev, "vdd");
 	if (IS_ERR(priv->io_reg)) {
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
 		return PTR_ERR(priv->io_reg);
 	}
 
-	priv->core_reg = regulator_get(&spi->dev, "vcore");
+	priv->core_reg = devm_regulator_get(&spi->dev, "vcore");
 	if (IS_ERR(priv->core_reg)) {
-		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
-		goto err1;
+		return PTR_ERR(priv->core_reg);
 	}
 
 	priv->ld = lcd_device_register("l4f00242t03",
 					&spi->dev, priv, &l4f_ops);
-	if (IS_ERR(priv->ld)) {
-		ret = PTR_ERR(priv->ld);
-		goto err2;
-	}
+	if (IS_ERR(priv->ld))
+		return PTR_ERR(priv->ld);
 
 	/* Init the LCD */
 	l4f00242t03_lcd_init(spi);
@@ -220,13 +217,6 @@ static int l4f00242t03_probe(struct spi_device *spi)
 	dev_info(&spi->dev, "Epson l4f00242t03 lcd probed.\n");
 
 	return 0;
-
-err2:
-	regulator_put(priv->core_reg);
-err1:
-	regulator_put(priv->io_reg);
-
-	return ret;
 }
 
 static int l4f00242t03_remove(struct spi_device *spi)
@@ -235,12 +225,8 @@ static int l4f00242t03_remove(struct spi_device *spi)
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
-
 	spi_set_drvdata(spi, NULL);
 
-	regulator_put(priv->io_reg);
-	regulator_put(priv->core_reg);
-
 	return 0;
 }
 
-- 
1.7.9.5



