Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab1F1Nr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:47:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab1F1NpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:45:14 -0400
Subject: [PATCH] drivers/vidfeo/backlight: ld9040 cleanups
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Donghwa Lee <dh09.lee@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 21:45:04 +0800
Message-ID: <1309268704.5925.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. Fix checking wrong return value for backlight_device_register.
2. Properly free allocated resources in ld9040_probe() error path
   and ld9040_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/ld9040.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 7281b25..62bcde3 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -701,9 +701,9 @@ static int ld9040_probe(struct spi_device *spi)
 
 	bd = backlight_device_register("ld9040-bl", &spi->dev,
 		lcd, &ld9040_backlight_ops, NULL);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_lcd;
+	if (IS_ERR(bd)) {
+		ret = PTR_ERR(bd);
+		goto out_unregister_lcd;
 	}
 
 	bd->props.max_brightness = MAX_BRIGHTNESS;
@@ -731,6 +731,8 @@ static int ld9040_probe(struct spi_device *spi)
 	dev_info(&spi->dev, "ld9040 panel driver has been probed.\n");
 	return 0;
 
+out_unregister_lcd:
+	lcd_device_unregister(lcd->ld);
 out_free_lcd:
 	kfree(lcd);
 	return ret;
@@ -741,6 +743,7 @@ static int __devexit ld9040_remove(struct spi_device *spi)
 	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
 
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
+	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	kfree(lcd);
 
-- 
1.7.4.1



