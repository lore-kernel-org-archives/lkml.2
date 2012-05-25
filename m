Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab2EYC1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:27:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26074 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2EYC1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:27:31 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-8b-4fbeee0ca3cc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Donghwa Lee'" <dh09.lee@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 07/13] backlight: ld9040: use devm_ functions
Date: Fri, 25 May 2012 11:27:24 +0900
Message-id: <001201cd3a1d$ebcd5f20$c3681d60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06Heu0Oz3oUCxCQQa9pXHu58Rptg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAV3ed/v8Ddb1MVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MV2tfsBWsFqpYfeYEewNjA38XIyeHhICJRHfPR0YIW0ziwr31
	bF2MHBxCAosYJbqMuxi5gMzZTBLfV65iBalhE1CT+PLlMDuILSIQIdE8YxYziM0sUCLx+s9q
	RpBeYQFbiVnPjUHCLAKqEitX9IOFeYHCuy6GgIR5BQQlfky+xwLRqSWxeVsTK4QtL7F5zVtm
	kHIJAXWJR391IRbpSZxct5kdokREYt+Ld4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGcEA+k9rBuLLB4hCjAAejEg9v4Jt9/kKsiWXFlbmHGCU4mJVE
	eAUjgUK8KYmVValF+fFFpTmpxYcYpTlYlMR57Rbv8BcSSE8sSc1OTS1ILYLJMnFwSjUwmhS8
	4W08I+rDv6bk/USJn1GiNyyeLQs6s2D9uybGzwt5ll0U58yQDnV6s0x8aUTTySuG8/aEpJSs
	XLJ2zoU9XjxpuZGnG77l7aqY2qng2jZNxD4wUL42as0bjbq/rFdu/byWdy9XJ2blubdyM9x/
	Zz7xkSo0jVl7eOey46ocH+rPa2Uekw37rcRSnJFoqMVcVJwIADcIZ6JEAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 2ea06a5..58f517f 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -707,7 +707,7 @@ static int ld9040_probe(struct spi_device *spi)
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct ld9040), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ld9040), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -717,7 +717,7 @@ static int ld9040_probe(struct spi_device *spi)
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -726,7 +726,7 @@ static int ld9040_probe(struct spi_device *spi)
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	mutex_init(&lcd->lock);
@@ -734,13 +734,13 @@ static int ld9040_probe(struct spi_device *spi)
 	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
 	if (ret) {
 		dev_err(lcd->dev, "Failed to get regulators: %d\n", ret);
-		goto out_free_lcd;
+		return ret;
 	}
 
 	ld = lcd_device_register("ld9040", &spi->dev, lcd, &ld9040_lcd_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto out_free_lcd;
+		goto out_free_regulator;
 	}
 
 	lcd->ld = ld;
@@ -782,10 +782,9 @@ static int ld9040_probe(struct spi_device *spi)
 
 out_unregister_lcd:
 	lcd_device_unregister(lcd->ld);
-out_free_lcd:
+out_free_regulator:
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 
-	kfree(lcd);
 	return ret;
 }
 
@@ -797,7 +796,6 @@ static int __devexit ld9040_remove(struct spi_device *spi)
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	kfree(lcd);
 
 	return 0;
 }
-- 
1.7.1


