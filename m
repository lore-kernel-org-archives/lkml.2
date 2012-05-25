Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2EYC2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:28:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8615 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2EYC2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:28:50 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-b3-4fbeee60335a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Haavard Skinnemoen'" <hskinnemoen@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 09/13] backlight: ltv350qv: use devm_ functions
Date: Fri, 25 May 2012 11:28:48 +0900
Message-id: <001401cd3a1e$1d95aa30$58c0fe90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06Hh16hO1wKgbpTgm9gihOCeX4nQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jQd2Ed/v8DZqnm1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M3a2HWArO8VU0H3zB1MDYwtPFyMEhIWAisb9LpouRE8gUk7hw
	bz1bFyMXh5DAdEaJba8vM0I4s5kkPk2bywJSxSagJvHly2F2EFtEIEKiecYsZpBBzAJ1Eps+
	p4OEhQXsJc5+PsYEYrMIqErc2jCPCaSEV8BWonOaMUiYV0BQ4sfke2ATmQW0JDZva2KFsOUl
	Nq95ywxxmrrEo7+6EIv0JE7c+c4OUSIise/FO8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOCSfSe9gXNVgcYhRgINRiYc34M0+fyHWxLLiytxDjBIc
	zEoivIKRQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8T5bs8BcSSE8sSc1OTS1ILYLJMnFwSjUw
	+orV667eH2kToFc7M05pxpoACU+vJvln8jM5zz04YRq4YA2buJ2D5dFjG9+qHZ29btXTlPTl
	vaaVjqzqrHnsU2seiV+sWMx9U2f79pWVHLXXw0zcPmhu07o99+kt/c3CCrree7z+8qY+rj5d
	/aW9Yv2tJ/VXzTp2iATHRW47F3KpNN5xtsYrJZbijERDLeai4kQAWde+a0UCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ltv350qv.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index d23922f..6c0f1ac 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -232,23 +232,20 @@ static int __devinit ltv350qv_probe(struct spi_device *spi)
 	struct lcd_device *ld;
 	int ret;
 
-	lcd = kzalloc(sizeof(struct ltv350qv), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ltv350qv), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
 	lcd->spi = spi;
 	lcd->power = FB_BLANK_POWERDOWN;
-	lcd->buffer = kzalloc(8, GFP_KERNEL);
-	if (!lcd->buffer) {
-		ret = -ENOMEM;
-		goto out_free_lcd;
-	}
+	lcd->buffer = devm_kzalloc(&spi->dev, 8, GFP_KERNEL);
+	if (!lcd->buffer)
+		return -ENOMEM;
 
 	ld = lcd_device_register("ltv350qv", &spi->dev, lcd, &ltv_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_buffer;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
+
 	lcd->ld = ld;
 
 	ret = ltv350qv_power(lcd, FB_BLANK_UNBLANK);
@@ -261,10 +258,6 @@ static int __devinit ltv350qv_probe(struct spi_device *spi)
 
 out_unregister:
 	lcd_device_unregister(ld);
-out_free_buffer:
-	kfree(lcd->buffer);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -274,8 +267,6 @@ static int __devexit ltv350qv_remove(struct spi_device *spi)
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd->buffer);
-	kfree(lcd);
 
 	return 0;
 }
-- 
1.7.1


