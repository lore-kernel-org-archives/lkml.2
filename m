Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2FMLS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:18:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17982 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2FMLSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:18:53 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-eb-4fd8771c7be3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: [PATCH 1/7] backlight: atmel-pwm-bl: use devm_gpio_request()
Date: Wed, 13 Jun 2012 20:18:51 +0900
Message-id: <000201cd4956$4fdc5fb0$ef951f10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JVk+FmcWUZ5YVRw2/7GzFDnpSBA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQV2Z8hv+BgcWcVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MjnuyBbcEK7a+/MHWwPiYr4uRk0NCwETiWOM8RghbTOLCvfVs
	XYxcHEIC0xklvve9YIFwZjNJbFh/GqyKTUBN4suXw+wgtohAhETzjFnMIEXMAosYJba86gZq
	5+AQFnCVaHipDFLDIqAqsXdTEwuIzStgK3Fm4j5GCFtQ4sfke2BxZgEtifU7jzNB2PISm9e8
	ZQYZIyGgLvHory7EKj2Jt3t+QJWLSOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECA7LZ9I7GFc1WBxiFOBgVOLh5Si94S/EmlhWXJl7iFGCg1lJ
	hPdZNlCINyWxsiq1KD++qDQntfgQozQHi5I4b5P1BX8hgfTEktTs1NSC1CKYLBMHp1QDo8zd
	pPQ1dUZdBmruJ7ufHFfnFVwgYrD5orvCZONX3/521uwXu+h/UX1n/9NVKzQMN+9tVpBZnHgy
	26Dk4aevgSYZTyXCvkvcL1pj3Dllk+CKWfumTZjWNr2+Mu74Qa4Urj2/RF7v3PDw5KdsJrnY
	KYxHt/BMmTjzdq3pm+6+PTwn5iQ/yJnU+E2JpTgj0VCLuag4EQDA6UBmRwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_gpio_request of these functions.

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/atmel-pwm-bl.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index cd64073..df1cbb7 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -155,7 +155,8 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 		goto err_free_mem;
 
 	if (pwmbl->gpio_on != -1) {
-		retval = gpio_request(pwmbl->gpio_on, "gpio_atmel_pwm_bl");
+		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
+					"gpio_atmel_pwm_bl");
 		if (retval) {
 			pwmbl->gpio_on = -1;
 			goto err_free_pwm;
@@ -165,7 +166,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 		retval = gpio_direction_output(pwmbl->gpio_on,
 				0 ^ pdata->on_active_low);
 		if (retval)
-			goto err_free_gpio;
+			goto err_free_pwm;
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -175,7 +176,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 					  &atmel_pwm_bl_ops, &props);
 	if (IS_ERR(bldev)) {
 		retval = PTR_ERR(bldev);
-		goto err_free_gpio;
+		goto err_free_pwm;
 	}
 
 	pwmbl->bldev = bldev;
@@ -197,9 +198,6 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 err_free_bl_dev:
 	platform_set_drvdata(pdev, NULL);
 	backlight_device_unregister(bldev);
-err_free_gpio:
-	if (pwmbl->gpio_on != -1)
-		gpio_free(pwmbl->gpio_on);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
 err_free_mem:
@@ -210,10 +208,8 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
-	if (pwmbl->gpio_on != -1) {
+	if (pwmbl->gpio_on != -1)
 		gpio_set_value(pwmbl->gpio_on, 0);
-		gpio_free(pwmbl->gpio_on);
-	}
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
 	backlight_device_unregister(pwmbl->bldev);
-- 
1.7.1


