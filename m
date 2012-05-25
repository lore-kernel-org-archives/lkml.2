Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2EYCZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:25:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11427 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2EYCZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:25:10 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-93-4fbeed85d870
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Eric Miao'" <eric.y.miao@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 04/13] backlight: corgi_lcd: use devm_ functions
Date: Fri, 25 May 2012 11:25:09 +0900
Message-id: <000f01cd3a1d$9ae84bb0$d0b8e310$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HZrTojnQwGPqS8612SOnq8CQsQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jAd3Wt/v8Da5+kbC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZE+awFXzhrfhwZx5bA+MF7i5GDg4JAROJjXdKuhg5gUwxiQv3
	1rN1MXJxCAksYpTY/+kTI4Qzm0li7rpHjCBVbAJqEl++HGYHsUUEIiSaZ8xiBrGZBYolHra0
	gNUICzhI3LpxmAXEZhFQlejc/58VZBmvgK3E5C5tkDCvgKDEj8n3WCBatSQ2b2tihbDlJTav
	ecsMcZu6xKO/uhCb9CR23ulggigRkdj34h3jBEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERySz6R3MK5qsDjEKMDBqMTDG/Bmn78Qa2JZcWXuIUYJDmYl
	EV7BSKAQb0piZVVqUX58UWlOavEhRmkOFiVx3idLdvgLCaQnlqRmp6YWpBbBZJk4OKUaGDm1
	RdMCM8seH+G2/XHU63ODBnPqM4mGGSHJ65mPPWU74XSzedHjWTeexsz95ijIfGTLpkSpD3K3
	8mewmqjEuW3XFv/Bv9TyVtG+DLXGz/+Lf73qVOSvXH30/b0Cg5lvLLeFizH8Tpl7U0Q10jOq
	+O/ZW8Z1OXviLOYJ3k8s4elz0UreLNF6TImlOCPRUIu5qDgRAO/woWJFAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/corgi_lcd.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 6dab13f..23d7326 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -544,7 +544,7 @@ static int __devinit corgi_lcd_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	lcd = kzalloc(sizeof(struct corgi_lcd), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct corgi_lcd), GFP_KERNEL);
 	if (!lcd) {
 		dev_err(&spi->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -554,10 +554,9 @@ static int __devinit corgi_lcd_probe(struct spi_device *spi)
 
 	lcd->lcd_dev = lcd_device_register("corgi_lcd", &spi->dev,
 					lcd, &corgi_lcd_ops);
-	if (IS_ERR(lcd->lcd_dev)) {
-		ret = PTR_ERR(lcd->lcd_dev);
-		goto err_free_lcd;
-	}
+	if (IS_ERR(lcd->lcd_dev))
+		return PTR_ERR(lcd->lcd_dev);
+
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
@@ -591,8 +590,6 @@ err_unregister_bl:
 	backlight_device_unregister(lcd->bl_dev);
 err_unregister_lcd:
 	lcd_device_unregister(lcd->lcd_dev);
-err_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -613,7 +610,6 @@ static int __devexit corgi_lcd_remove(struct spi_device *spi)
 
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
-	kfree(lcd);
 
 	return 0;
 }
-- 
1.7.1


