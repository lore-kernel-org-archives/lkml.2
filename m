Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2EYCYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:24:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11192 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2EYCYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:24:34 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-e9-4fbeed61c1d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 03/13] backlight: ams369fg06: use devm_ functions
Date: Fri, 25 May 2012 11:24:33 +0900
Message-id: <000e01cd3a1d$85aa5e50$90ff1af0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HYWXdZX/WcBjT5iy65lR+ipSXw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd3Et/v8Dd4+1bC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZm7c2shZ846+4/rmbuYGxjbeLkZNDQsBEYkrvAjYIW0ziwr31
	QDYXh5DAIkaJSZ/mskA4s5kkFn3qZwSpYhNQk/jy5TA7iC0iECHRPGMWcxcjBwezgI/E5lma
	IKawgKPEh+4qkAoWAVWJA81/WEFsXgFbiXO9B5khbEGJH5PvsYDYzAJaEpu3NbFC2PISm9e8
	BZsoIaAu8eivLsQiPYnnU/cxQpSISOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECA7KZ9I7GFc1WBxiFOBgVOLhDXizz1+INbGsuDL3EKMEB7OS
	CK9gJFCINyWxsiq1KD++qDQntfgQozQHi5I475MlO/yFBNITS1KzU1MLUotgskwcnFINjBtc
	XjjddK2ewaelLbTpb/mblRELDdfP/uWY7X1Yfd3Ch43hv8JqXEpsQ3W4T3rIya7dumNiUGRN
	iWGPo8HJl8+N6yznlb3OuyP2+MXHzvWZv9/d65777G6pwPkbp+1tPXs0311i5ZbRmTP/S+3z
	n+v1M+QenIxZwfwuKUXhwuIlOVe6eY1mn1FiKc5INNRiLipOBABWHcfpRgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index d2494c5..3729238 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -482,7 +482,7 @@ static int __devinit ams369fg06_probe(struct spi_device *spi)
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct ams369fg06), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ams369fg06), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -492,7 +492,7 @@ static int __devinit ams369fg06_probe(struct spi_device *spi)
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -501,15 +501,13 @@ static int __devinit ams369fg06_probe(struct spi_device *spi)
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
 		&ams369fg06_lcd_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_lcd;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	lcd->ld = ld;
 
@@ -547,8 +545,6 @@ static int __devinit ams369fg06_probe(struct spi_device *spi)
 
 out_lcd_unregister:
 	lcd_device_unregister(ld);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -559,7 +555,6 @@ static int __devexit ams369fg06_remove(struct spi_device *spi)
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd);
 
 	return 0;
 }
-- 
1.7.1


