Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2FMLZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:25:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36353 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2FMLZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:25:22 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-fd-4fd878a11f5b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Eric Miao'" <eric.y.miao@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: [PATCH 6/7] backlight: corgi_lcd: use devm_gpio_request()
Date: Wed, 13 Jun 2012 20:25:20 +0900
Message-id: <000701cd4957$37c74100$a755c300$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JVzewKAm3MmUDR6iY4MwCl8lT+A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2FFTf8Df5v47W4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZO7/sZi3oE6p4MfEFawPjEv4uRk4OCQETiSff5jJB2GISF+6t
	Z+ti5OIQEljEKHF15lImCGc2k8SjW1tZQKrYBNQkvnw5zA5iiwhESDTPmMUMUsQsMIVR4vi5
	7YwgCWEBJ4n3TSeBijg4WARUJZZ1yIKEeQVsJZa+u8QKYQtK/Jh8D2wms4CWxPqdx5kgbHmJ
	zWveMoO0SgioSzz6qwuxSk9i0aYuqHIRiX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwYH5TGoH48oGi0OMAhyMSjy8G4pu+AuxJpYVV+YeYpTg
	YFYS4X2WDRTiTUmsrEotyo8vKs1JLT7EKM3BoiTO22R9wV9IID2xJDU7NbUgtQgmy8TBKdXA
	OPmz7rc5r//27G3kv/Ts1e76nf2n8xIDAmsyVUqMD0nOFTxyK2jflv3f1a5IGkzY3za/tsDw
	mNN2NrE7fldtP0c9WPDBLGpdwRvf7MorPb2RITVLV8U9ydk863eOcbWCntmsE7mbC98uP/1e
	zn+eS8alA5IrPkzhFa9M/3CyUXZeDsMy2VWXuZRYijMSDbWYi4oTAQWoVZ1IAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_gpio_request of these functions.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/corgi_lcd.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 23d7326..c781768 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -492,7 +492,8 @@ static int setup_gpio_backlight(struct corgi_lcd *lcd,
 	lcd->gpio_backlight_cont = -1;
 
 	if (gpio_is_valid(pdata->gpio_backlight_on)) {
-		err = gpio_request(pdata->gpio_backlight_on, "BL_ON");
+		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_on,
+					"BL_ON");
 		if (err) {
 			dev_err(&spi->dev, "failed to request GPIO%d for "
 				"backlight_on\n", pdata->gpio_backlight_on);
@@ -504,11 +505,12 @@ static int setup_gpio_backlight(struct corgi_lcd *lcd,
 	}
 
 	if (gpio_is_valid(pdata->gpio_backlight_cont)) {
-		err = gpio_request(pdata->gpio_backlight_cont, "BL_CONT");
+		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_cont,
+					"BL_CONT");
 		if (err) {
 			dev_err(&spi->dev, "failed to request GPIO%d for "
 				"backlight_cont\n", pdata->gpio_backlight_cont);
-			goto err_free_backlight_on;
+			return err;
 		}
 
 		lcd->gpio_backlight_cont = pdata->gpio_backlight_cont;
@@ -525,11 +527,6 @@ static int setup_gpio_backlight(struct corgi_lcd *lcd,
 		}
 	}
 	return 0;
-
-err_free_backlight_on:
-	if (gpio_is_valid(lcd->gpio_backlight_on))
-		gpio_free(lcd->gpio_backlight_on);
-	return err;
 }
 
 static int __devinit corgi_lcd_probe(struct spi_device *spi)
@@ -602,12 +599,6 @@ static int __devexit corgi_lcd_remove(struct spi_device *spi)
 	backlight_update_status(lcd->bl_dev);
 	backlight_device_unregister(lcd->bl_dev);
 
-	if (gpio_is_valid(lcd->gpio_backlight_on))
-		gpio_free(lcd->gpio_backlight_on);
-
-	if (gpio_is_valid(lcd->gpio_backlight_cont))
-		gpio_free(lcd->gpio_backlight_cont);
-
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
 
-- 
1.7.1


