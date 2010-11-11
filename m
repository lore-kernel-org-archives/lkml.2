Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0KKOin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:38:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59478 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0KKOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:38:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qb1m6LttxOaaEj87V5O4AHDHsi9RQbqPwCLPH7X40eSNEJQ/nu+gqos8pLZurru3/t
         U/5VHSncqKpFFBwdee369wPhNBIJmZXPCCJdvV+F4iKz/L6jyB59v7XSmctGte48uRGP
         fjyyOYghqvXra6zSJZW+G+OSOI69BeBO4yOaQ=
Subject: [PATCH] backlight: l4f00242t03: full implement fb power states for
 this lcd
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Marek Vasut <marek.vasut@gmail.com>,
        Tejun Heo <tj@kernel.org>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 15:38:35 +0100
Message-ID: <1289486315.3049.101.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch complete the support of fb power states managing
correctly the regulators bound to this driver.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---

This patch follow the Marek work that resides in the broken-out
queue of the -mm tree:
http://userweb.kernel.org/~akpm/mmotm/broken-out/backlight-fix-blanking-for-l4f00242t03-lcd.patch

 drivers/video/backlight/l4f00242t03.c |   97 +++++++++++++++++++++++++--------
 1 files changed, 75 insertions(+), 22 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index c67801e..5d25743 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -25,7 +25,7 @@
 struct l4f00242t03_priv {
 	struct spi_device	*spi;
 	struct lcd_device	*ld;
-	int lcd_on:1;
+	int lcd_state;
 	struct regulator *io_reg;
 	struct regulator *core_reg;
 };
@@ -67,6 +67,29 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
 	spi_write(spi, (const u8 *)cmd, ARRAY_SIZE(cmd) * sizeof(u16));
 }
 
+static void l4f00242t03_lcd_powerdown(struct spi_device *spi)
+{
+	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "Powering down LCD\n");
+
+	gpio_set_value(pdata->data_enable_gpio, 0);
+
+	if (priv->io_reg)
+		regulator_disable(priv->io_reg);
+
+	if (priv->core_reg)
+		regulator_disable(priv->core_reg);
+}
+
+static int l4f00242t03_lcd_power_get(struct lcd_device *ld)
+{
+	struct l4f00242t03_priv *priv = lcd_get_data(ld);
+
+	return priv->lcd_state;
+}
+
 static int l4f00242t03_lcd_power_set(struct lcd_device *ld, int power)
 {
 	struct l4f00242t03_priv *priv = lcd_get_data(ld);
@@ -79,35 +102,52 @@ static int l4f00242t03_lcd_power_set(struct lcd_device *ld, int power)
 	const u16 disoff = 0x28;
 
 	if (power <= FB_BLANK_NORMAL) {
-		if (priv->lcd_on)
-			return 0;
-
-		dev_dbg(&spi->dev, "turning on LCD\n");
-
-		spi_write(spi, (const u8 *)&slpout, sizeof(u16));
-		msleep(60);
-		spi_write(spi, (const u8 *)&dison, sizeof(u16));
-
-		priv->lcd_on = 1;
+		if (priv->lcd_state <= FB_BLANK_NORMAL) {
+			/* Do nothing, the LCD is running */
+		} else if (priv->lcd_state < FB_BLANK_POWERDOWN) {
+			dev_dbg(&spi->dev, "Resuming LCD\n");
+
+			spi_write(spi, (const u8 *)&slpout, sizeof(u16));
+			msleep(60);
+			spi_write(spi, (const u8 *)&dison, sizeof(u16));
+		} else {
+			/* priv->lcd_state == FB_BLANK_POWERDOWN */
+			l4f00242t03_lcd_init(spi);
+			priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
+			l4f00242t03_lcd_power_set(priv->ld, power);
+		}
+	} else if (power < FB_BLANK_POWERDOWN) {
+		if (priv->lcd_state <= FB_BLANK_NORMAL) {
+			/* Send the display in standby */
+			dev_dbg(&spi->dev, "Standby the LCD\n");
+
+			spi_write(spi, (const u8 *)&disoff, sizeof(u16));
+			msleep(60);
+			spi_write(spi, (const u8 *)&slpin, sizeof(u16));
+		} else if (priv->lcd_state < FB_BLANK_POWERDOWN) {
+			/* Do nothing, the LCD is already in standby */
+		} else {
+			/* priv->lcd_state == FB_BLANK_POWERDOWN */
+			l4f00242t03_lcd_init(spi);
+			priv->lcd_state = FB_BLANK_UNBLANK;
+			l4f00242t03_lcd_power_set(ld, power);
+		}
 	} else {
-		if (!priv->lcd_on)
-			return 0;
-
-		dev_dbg(&spi->dev, "turning off LCD\n");
-
+		/* power == FB_BLANK_POWERDOWN */
+		/* Clear the screen before shutting down */
 		spi_write(spi, (const u8 *)&disoff, sizeof(u16));
 		msleep(60);
-		spi_write(spi, (const u8 *)&slpin, sizeof(u16));
-
-		priv->lcd_on = 0;
+		l4f00242t03_lcd_powerdown(spi);
 	}
 
+	priv->lcd_state = power;
+
 	return 0;
 }
 
 static struct lcd_ops l4f_ops = {
 	.set_power	= l4f00242t03_lcd_power_set,
-	.get_power	= NULL,
+	.get_power	= l4f00242t03_lcd_power_get,
 };
 
 static int __devinit l4f00242t03_probe(struct spi_device *spi)
@@ -187,7 +227,8 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 	/* Init the LCD */
 	l4f00242t03_reset(pdata->reset_gpio);
 	l4f00242t03_lcd_init(spi);
-	l4f00242t03_lcd_power_set(priv->ld, 1);
+	priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
+	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_UNBLANK);
 
 	dev_info(&spi->dev, "Epson l4f00242t03 lcd probed.\n");
 
@@ -214,9 +255,11 @@ static int __devexit l4f00242t03_remove(struct spi_device *spi)
 	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
 	struct l4f00242t03_pdata *pdata = priv->spi->dev.platform_data;
 
-	l4f00242t03_lcd_power_set(priv->ld, 0);
+	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
 
+	dev_set_drvdata(&spi->dev, NULL);
+
 	gpio_free(pdata->data_enable_gpio);
 	gpio_free(pdata->reset_gpio);
 
@@ -230,6 +273,15 @@ static int __devexit l4f00242t03_remove(struct spi_device *spi)
 	return 0;
 }
 
+static void l4f00242t03_shutdown(struct spi_device *spi)
+{
+	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+
+	if (priv)
+		l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
+
+}
+
 static struct spi_driver l4f00242t03_driver = {
 	.driver = {
 		.name	= "l4f00242t03",
@@ -237,6 +289,7 @@ static struct spi_driver l4f00242t03_driver = {
 	},
 	.probe		= l4f00242t03_probe,
 	.remove		= __devexit_p(l4f00242t03_remove),
+	.shutdown	= l4f00242t03_shutdown,
 };
 
 static __init int l4f00242t03_init(void)
-- 
1.6.3.3



