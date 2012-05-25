Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2EYC0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:26:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11817 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2EYC0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:26:02 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-6d-4fbeedb96b78
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 05/13] backlight: ili9320: use devm_ functions
Date: Fri, 25 May 2012 11:26:01 +0900
Message-id: <001001cd3a1d$ba3f0fd0$2ebd2f70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HboljXHqCOHfTVK6RA8ttywBvw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd2db/f5G0z+ZGZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyNn08xlSwj6fi5KW/TA2M87i6GDk5JARMJC7Nu8UCYYtJXLi3
	nq2LkYtDSGA6o8T5aTvYIZzZTBK7GlYygVSxCahJfPlymB3EFhGIkGieMYsZxGYWKJS48/sx
	2CRhATuJ1qdLwOIsAqoSi148A+rl4OAVsJU4cMYKJMwrICjxY/I9FohWLYnN25pYIWx5ic1r
	3jKDlEsIqEs8+qsLsUlP4uLmW4wQJSIS+168Y5zAKDALyaRZSCbNQjJpFpKWBYwsqxhFUwuS
	C4qT0nON9IoTc4tL89L1kvNzNzGCw/KZ9A7GVQ0WhxgFOBiVeHgD3uzzF2JNLCuuzD3EKMHB
	rCTCKxgJFOJNSaysSi3Kjy8qzUktPsQozcGiJM77ZMkOfyGB9MSS1OzU1ILUIpgsEwenVAPj
	xFaXWYu9b30Sb/ezLg7bZPg4avFJ5QUxy7VeXVsyva/h61LvnccUfHRWcxkIKkp8K6qJX2j4
	w74sT/1o1Ry31JolwuuaDu2Qnde+3+Dnla1NAp/Dgnzur/pz70zP6/eCR7tnPgx7wv9I3id4
	X+pGyb+nlFYJVDFzPP0kW1d4kNVLcbFWd/5HJZbijERDLeai4kQAVikxZ0cCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ili9320.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 5118a9f..6c93993 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -220,7 +220,7 @@ int __devinit ili9320_probe_spi(struct spi_device *spi,
 
 	/* allocate and initialse our state */
 
-	ili = kzalloc(sizeof(struct ili9320), GFP_KERNEL);
+	ili = devm_kzalloc(&spi->dev, sizeof(struct ili9320), GFP_KERNEL);
 	if (ili == NULL) {
 		dev_err(dev, "no memory for device\n");
 		return -ENOMEM;
@@ -240,8 +240,7 @@ int __devinit ili9320_probe_spi(struct spi_device *spi,
 	lcd = lcd_device_register("ili9320", dev, ili, &ili9320_ops);
 	if (IS_ERR(lcd)) {
 		dev_err(dev, "failed to register lcd device\n");
-		ret = PTR_ERR(lcd);
-		goto err_free;
+		return PTR_ERR(lcd);
 	}
 
 	ili->lcd = lcd;
@@ -259,9 +258,6 @@ int __devinit ili9320_probe_spi(struct spi_device *spi,
  err_unregister:
 	lcd_device_unregister(lcd);
 
- err_free:
-	kfree(ili);
-
 	return ret;
 }
 
@@ -272,7 +268,6 @@ int __devexit ili9320_remove(struct ili9320 *ili)
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
 
 	lcd_device_unregister(ili->lcd);
-	kfree(ili);
 
 	return 0;
 }
-- 
1.7.1


