Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2EYC3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:29:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27233 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2EYC33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:29:29 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-75-4fbeee888521
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'InKi Dae'" <inki.dae@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 10/13] backlight: s6e63m0: use devm_ functions
Date: Fri, 25 May 2012 11:29:27 +0900
Message-id: <001501cd3a1e$35310f90$9f932eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HjUalhNU9o+eR2SPNOUQgEl1WA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd2Od/v8Dfpe8Fhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MKa2XmQumCFTsvXCDvYFxIW8XIyeHhICJxJT/u5ggbDGJC/fW
	s3UxcnEICUxnlLjyYQsjhDObSeLcvlWsIFVsAmoSX74cZgexRQQiJJpnzGLuYuTgYBYolDiy
	vhwkLCxgJ7Fk8hwWEJtFQFXictNlNhCbV8BWYu+/DiYIW1Dix+R7YDXMAloSm7c1sULY8hKb
	17wFGykhoC7x6K8uxCY9iT0/HjFBlIhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQIDstnUjsYVzZYHGIU4GBU4uENfLPPX4g1say4MvcQowQH
	s5IIr2AkUIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv3eId/kIC6YklqdmpqQWpRTBZJg5OqQbG
	Sbe2ZmyzWncx9NSTVBPJWZGpTzhVdSceWTTxTVhcltFrK0MLdvHDtzgeb5gjdsWp3bN2jah0
	dPHaY+a+JgztDAa7S+c083/Xys85MCG1TeK0xfqJ6osCpjs/10+4HbX6lNvzlx7TZov7Rdiv
	Etp+KXyBd55sdkvQvwfihm+tHnxad2ym7N9ZSizFGYmGWsxFxYkAjbkZU0cCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: InKi Dae <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 3ed05c7..6437ae4 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -741,7 +741,7 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct s6e63m0), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct s6e63m0), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -751,7 +751,7 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -760,14 +760,12 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 	lcd->lcd_pd = (struct lcd_platform_data *)spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	ld = lcd_device_register("s6e63m0", &spi->dev, lcd, &s6e63m0_lcd_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_lcd;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	lcd->ld = ld;
 
@@ -824,8 +822,6 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 
 out_lcd_unregister:
 	lcd_device_unregister(ld);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -838,7 +834,6 @@ static int __devexit s6e63m0_remove(struct spi_device *spi)
 	device_remove_file(&spi->dev, &dev_attr_gamma_mode);
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd);
 
 	return 0;
 }
-- 
1.7.1


