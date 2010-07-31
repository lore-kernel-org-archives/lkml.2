Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0GaFpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 01:45:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42078 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0GaFpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 01:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Tf4kDGX0uT+Ms9QjdWyzFraTeEia18YVQp7m+vcmfIj4JWVRM9N1OYQ/AHlj/IZiox
         IorExDEybxDPWumtqrTJaqdSPgiq6vjp5j+TOBn8tTqbfErOw4YFB2DG2SlPPya5gRJG
         mxRmtVc4ZO1WMPSupEs0u8Rbfa9Hz6mVEYxTE=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: dmitry.torokhov@gmail.com, vapier@gentoo.org, pavel@ucw.cz,
        akpm@linux-foundation.org, khilman@deeprootsystems.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.y.miao@gmail.com, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] Input: Make ADS7846 independent on regulator
Date: Sat, 31 Jul 2010 07:45:08 +0200
Message-Id: <1280555108-27994-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case regulator was not found, ADS7846 failed to probe.

This fixes a problem on some Sharp Zaurus devices, where there is no regulator
present and yet the touchscreen is used.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/input/touchscreen/ads7846.c |   50 +++++++++++++++++++++++------------
 1 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index a9fdf55..dafaef6 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -791,7 +791,10 @@ static void ads7846_disable(struct ads7846 *ts)
 		}
 	}
 
-	regulator_disable(ts->reg);
+#ifdef	CONFIG_REGULATOR
+	if (ts->reg)
+		regulator_disable(ts->reg);
+#endif
 
 	/* we know the chip's in lowpower mode since we always
 	 * leave it that way after every request
@@ -804,7 +807,10 @@ static void ads7846_enable(struct ads7846 *ts)
 	if (!ts->disabled)
 		return;
 
-	regulator_enable(ts->reg);
+#ifdef	CONFIG_REGULATOR
+	if (ts->reg)
+		regulator_enable(ts->reg);
+#endif
 
 	ts->disabled = 0;
 	ts->irq_disabled = 0;
@@ -1161,18 +1167,21 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 
 	ts->last_msg = m;
 
+#ifdef	CONFIG_REGULATOR
 	ts->reg = regulator_get(&spi->dev, "vcc");
-	if (IS_ERR(ts->reg)) {
-		err = PTR_ERR(ts->reg);
-		dev_err(&spi->dev, "unable to get regulator: %d\n", err);
-		goto err_free_gpio;
-	}
-
-	err = regulator_enable(ts->reg);
-	if (err) {
-		dev_err(&spi->dev, "unable to enable regulator: %d\n", err);
-		goto err_put_regulator;
+	if (IS_ERR(ts->reg))
+		ts->reg = NULL;
+	else {
+		err = regulator_enable(ts->reg);
+		if (err) {
+			dev_err(&spi->dev, "unable to enable regulator: %d\n",
+				err);
+			goto err_put_regulator;
+		}
 	}
+#else
+	ts->reg = NULL;
+#endif
 
 	if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING,
 			spi->dev.driver->name, ts)) {
@@ -1218,10 +1227,13 @@ static int __devinit ads7846_probe(struct spi_device *spi)
  err_free_irq:
 	free_irq(spi->irq, ts);
  err_disable_regulator:
-	regulator_disable(ts->reg);
+#ifdef	CONFIG_REGULATOR
+	if (ts->reg)
+		regulator_disable(ts->reg);
  err_put_regulator:
-	regulator_put(ts->reg);
- err_free_gpio:
+	if (ts->reg)
+		regulator_put(ts->reg);
+#endif
 	if (ts->gpio_pendown != -1)
 		gpio_free(ts->gpio_pendown);
  err_cleanup_filter:
@@ -1251,8 +1263,12 @@ static int __devexit ads7846_remove(struct spi_device *spi)
 	/* suspend left the IRQ disabled */
 	enable_irq(ts->spi->irq);
 
-	regulator_disable(ts->reg);
-	regulator_put(ts->reg);
+#ifdef	CONFIG_REGULATOR
+	if (ts->reg) {
+		regulator_disable(ts->reg);
+		regulator_put(ts->reg);
+	}
+#endif
 
 	if (ts->gpio_pendown != -1)
 		gpio_free(ts->gpio_pendown);
-- 
1.7.1

