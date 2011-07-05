Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1GEEiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:38:00 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:32972 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1GEEh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:37:59 -0400
Subject: [PATCH] backlight: Set backlight type and max_brightness before
 backlights are registered
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Jingoo Han <jg1.han@samsung.com>,
        Donghwa Lee <dh09.lee@samsung.com>, InKi Dae <inki.dae@samsung.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 12:37:49 +0800
Message-ID: <1309840669.6072.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit a19a6ee "backlight: Allow properties to be passed at registration"
and commit bb7ca74 "backlight: add backlight type",
we can set backlight type and max_brightness before backlights are registered.
Some newly added drivers did not set it properly, let's fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |    9 ++++++---
 drivers/video/backlight/ld9040.c     |    8 ++++++--
 drivers/video/backlight/s6e63m0.c    |    9 ++++++---
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 6462d05..201a593 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -479,6 +479,7 @@ static int __init ams369fg06_probe(struct spi_device *spi)
 	struct ams369fg06 *lcd = NULL;
 	struct lcd_device *ld = NULL;
 	struct backlight_device *bd = NULL;
+	struct backlight_properties props;
 
 	lcd = kzalloc(sizeof(struct ams369fg06), GFP_KERNEL);
 	if (!lcd)
@@ -511,16 +512,18 @@ static int __init ams369fg06_probe(struct spi_device *spi)
 
 	lcd->ld = ld;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = MAX_BRIGHTNESS;
+
 	bd = backlight_device_register("ams369fg06-bl", &spi->dev, lcd,
-		&ams369fg06_backlight_ops, NULL);
+		&ams369fg06_backlight_ops, &props);
 	if (IS_ERR(bd)) {
 		ret =  PTR_ERR(bd);
 		goto out_lcd_unregister;
 	}
 
-	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = DEFAULT_BRIGHTNESS;
-	bd->props.type = BACKLIGHT_RAW;
 	lcd->bd = bd;
 
 	if (!lcd->lcd_pd->lcd_enabled) {
diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 62bcde3..5934655 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -668,6 +668,7 @@ static int ld9040_probe(struct spi_device *spi)
 	struct ld9040 *lcd = NULL;
 	struct lcd_device *ld = NULL;
 	struct backlight_device *bd = NULL;
+	struct backlight_properties props;
 
 	lcd = kzalloc(sizeof(struct ld9040), GFP_KERNEL);
 	if (!lcd)
@@ -699,14 +700,17 @@ static int ld9040_probe(struct spi_device *spi)
 
 	lcd->ld = ld;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = MAX_BRIGHTNESS;
+
 	bd = backlight_device_register("ld9040-bl", &spi->dev,
-		lcd, &ld9040_backlight_ops, NULL);
+		lcd, &ld9040_backlight_ops, &props);
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
 		goto out_unregister_lcd;
 	}
 
-	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = MAX_BRIGHTNESS;
 	lcd->bd = bd;
 
diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index e1803ba..694e5aa 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -738,6 +738,7 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 	struct s6e63m0 *lcd = NULL;
 	struct lcd_device *ld = NULL;
 	struct backlight_device *bd = NULL;
+	struct backlight_properties props;
 
 	lcd = kzalloc(sizeof(struct s6e63m0), GFP_KERNEL);
 	if (!lcd)
@@ -769,16 +770,18 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 
 	lcd->ld = ld;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = MAX_BRIGHTNESS;
+
 	bd = backlight_device_register("s6e63m0bl-bl", &spi->dev, lcd,
-		&s6e63m0_backlight_ops, NULL);
+		&s6e63m0_backlight_ops, &props);
 	if (IS_ERR(bd)) {
 		ret =  PTR_ERR(bd);
 		goto out_lcd_unregister;
 	}
 
-	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = MAX_BRIGHTNESS;
-	bd->props.type = BACKLIGHT_RAW;
 	lcd->bd = bd;
 
 	/*
-- 
1.7.4.1



