Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2EYCa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:30:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14510 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2EYCa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:30:57 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-a1-4fbeeee0c275
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Dmitry Baryshko'" <dbaryshkov@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 12/13] backlight: tosa_bl: use devm_ functions
Date: Fri, 25 May 2012 11:30:56 +0900
Message-id: <001701cd3a1e$69c59a00$3d50ce00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HmmsAKKMHL6KSSeOCCZCG16Vaw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd0H7/b5Gyy6IGZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyJv2bw1rwlKfixfl29gbGg1xdjJwcEgImEs1PTjFB2GISF+6t
	Z+ti5OIQEljEKLHh5BNWCGc2k8TKZ//BqtgE1CS+fDnMDmKLCERINM+YxQxiMwtUSMx+2MwC
	YgsL2Ek09LcxdjFycLAIqErMnegHYvIK2Eps/mcPUsErICjxY/I9FohOLYnN25pYIWx5ic1r
	3jKDlEsIqEs8+qsLsUhPYsL+/1AlIhL7XrxjnMAoMAvJpFlIJs1CMmkWkpYFjCyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYKD8pnUDsaVDRaHGAU4GJV4eAPf7PMXYk0sK67MPcQowcGs
	JMIrGAkU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzmu3eIe/kEB6YklqdmpqQWoRTJaJg1OqgXGb
	sINYxiT/6ks3NU1Ozvk2T/aQgHNns2K6GLd40LYJJe5+x6NfXH15XeiU2vc7XEdT1P+lnLtR
	Irbv0HLtonDxv0XV0UbTP+7+yu6cffnKP5tPm9ntQ++/FQmTfni15IDHs6dbDp2YMJMxp2PW
	Xu8tbtNWzPAJCDHON+r6/2WPpK3H/+OalX+UWIozEg21mIuKEwF8T+AARgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_bl.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 2b241ab..0d54e60 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -82,8 +82,11 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
 	struct backlight_properties props;
-	struct tosa_bl_data *data = kzalloc(sizeof(struct tosa_bl_data), GFP_KERNEL);
+	struct tosa_bl_data *data;
 	int ret = 0;
+
+	data = devm_kzalloc(&client->dev, sizeof(struct tosa_bl_data),
+				GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -92,7 +95,7 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 	ret = gpio_request(TOSA_GPIO_BL_C20MA, "backlight");
 	if (ret) {
 		dev_dbg(&data->bl->dev, "Unable to request gpio!\n");
-		goto err_gpio_bl;
+		return ret;
 	}
 	ret = gpio_direction_output(TOSA_GPIO_BL_C20MA, 0);
 	if (ret)
@@ -122,8 +125,6 @@ err_reg:
 	data->bl = NULL;
 err_gpio_dir:
 	gpio_free(TOSA_GPIO_BL_C20MA);
-err_gpio_bl:
-	kfree(data);
 	return ret;
 }
 
@@ -136,8 +137,6 @@ static int __devexit tosa_bl_remove(struct i2c_client *client)
 
 	gpio_free(TOSA_GPIO_BL_C20MA);
 
-	kfree(data);
-
 	return 0;
 }
 
-- 
1.7.1


