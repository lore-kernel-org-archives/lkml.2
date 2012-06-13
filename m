Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2FMLTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:19:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45271 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2FMLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:19:48 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-85-4fd87752e6b0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Christian Gmeiner'" <christian.gmeiner@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: [PATCH 2/7] backlight: ot200_bl: use devm_gpio_request()
Date: Wed, 13 Jun 2012 20:19:46 +0900
Message-id: <000301cd4956$70714920$5153db60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JVnBZ+NHoIXcMR+WyzrsRxE91Yg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd2g8hv+BlNeGVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M/s99TAV3eSsOvVnL1sC4jbuLkZNDQsBEYs7ldiYIW0ziwr31
	bCC2kMAiRomfs+y7GLmA7NlMEuc3rgArYhNQk/jy5TA7iC0iECHRPGMWM4jNLLCEUeLYWrAa
	YQFHif3H+hhBbBYBVYl/XWfA4rwCthJLV01ng7AFJX5MvscC0aslsX7ncSYIW15i85q3QDM5
	gA5Sl3j0VxdilZ7Exb5LrBAlIhL7XrxjnMAoMAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPS
	cw31ihNzi0vz0vWS83M3MYLD8pnUDsaVDRaHGAU4GJV4eDcU3fAXYk0sK67MPcQowcGsJML7
	LBsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfJ+oK/kEB6YklqdmpqQWoRTJaJg1OqgZGp8mBO
	eXOVf//y8FWO7NPXaW84KFHx2OL6VN5DTn+/Bdu9vzf/oRurxF++eQvl7jFX9z3YxLi7//C/
	M8JNZ0tL+oqbt9+enXLqUPOJBNVeVbkdy4NNfdburtrNL663Zfuynll3DN9+S+iY9Pd78/E9
	s5fNvv3a/6/aot1PuTI6rvrf+HiJzeWYEktxRqKhFnNRcSIAo4X7+kcCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_gpio_request of these functions.

CC: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ot200_bl.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/ot200_bl.c b/drivers/video/backlight/ot200_bl.c
index ef637ff..469cf0f 100644
--- a/drivers/video/backlight/ot200_bl.c
+++ b/drivers/video/backlight/ot200_bl.c
@@ -84,7 +84,8 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 	int retval = 0;
 
 	/* request gpio */
-	if (gpio_request(GPIO_DIMM, "ot200 backlight dimmer") < 0) {
+	if (devm_gpio_request(&pdev->dev, GPIO_DIMM,
+				"ot200 backlight dimmer") < 0) {
 		dev_err(&pdev->dev, "failed to request GPIO %d\n", GPIO_DIMM);
 		return -ENODEV;
 	}
@@ -93,8 +94,7 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 	pwm_timer = cs5535_mfgpt_alloc_timer(7, MFGPT_DOMAIN_ANY);
 	if (!pwm_timer) {
 		dev_err(&pdev->dev, "MFGPT 7 not available\n");
-		retval = -ENODEV;
-		goto error_mfgpt_alloc;
+		return -ENODEV;
 	}
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
@@ -131,8 +131,6 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 
 error_devm_kzalloc:
 	cs5535_mfgpt_free_timer(pwm_timer);
-error_mfgpt_alloc:
-	gpio_free(GPIO_DIMM);
 	return retval;
 }
 
@@ -149,7 +147,6 @@ static int ot200_backlight_remove(struct platform_device *pdev)
 		MAX_COMP2 - dim_table[100]);
 
 	cs5535_mfgpt_free_timer(pwm_timer);
-	gpio_free(GPIO_DIMM);
 
 	return 0;
 }
-- 
1.7.1


