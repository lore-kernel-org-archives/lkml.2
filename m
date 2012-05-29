Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab2E2AAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 20:00:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41344 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2E2AAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 20:00:13 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-fb-4fc4118ccaa0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Christian Gmeiner'" <christian.gmeiner@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 2/3][RESEND] backlight: ot200_bl: use devm_ functions
Date: Tue, 29 May 2012 09:00:12 +0900
Message-id: <001c01cd3d2e$0505f980$0f11ec80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac09LgTpC8JRVfwgSUSLVwSYjO0zbA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd0ewSP+Bo+e61hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MSTvPsxR84au40RXZwLidp4uRk0NCwESi6c18RghbTOLCvfVs
	XYxcHEICixglFlxfxQLhzGaS2D3xDFgVm4CaxJcvh9lBbBGBCInmGbOYQYqYBZoZJVYu3whW
	JCzgIbHi3SQwm0VAVWLmjdNADRwcvAK2Ens6tEHCvAKCEj8m32MBsZkFtCTW7zzOBGHLS2xe
	85YZpFxCQF3i0V9diFV6EgtPHGeGKBGR2PfiHeMERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQ
	XFCclJ5rqFecmFtcmpeul5yfu4kRHJbPpHYwrmywOMQowMGoxMO7Y81hfyHWxLLiytxDjBIc
	zEoivO/7gUK8KYmVValF+fFFpTmpxYcYpTlYlMR57Rbv8BcSSE8sSc1OTS1ILYLJMnFwSjUw
	Olqz1yd/KE9htXcvPFXbyGPCxBtzejPrkSde6zawiPusOnyZ74BpxY63zd2TXFivcSz+UZpQ
	JRzzMbCBf6vU6i/533kK8rrvGZxJNWRvkuTYFiWyOk5jyQUfPVvvzyt3neJRzrx3aJvxo7pO
	1f85xpvOsiTsETlzx83b/3z+JN/9FxO+b21XYinOSDTUYi4qTgQAonZ5+0cCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions

Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ot200_bl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/ot200_bl.c b/drivers/video/backlight/ot200_bl.c
index f519d55..ef637ff 100644
--- a/drivers/video/backlight/ot200_bl.c
+++ b/drivers/video/backlight/ot200_bl.c
@@ -97,10 +97,10 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 		goto error_mfgpt_alloc;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		retval = -ENOMEM;
-		goto error_kzalloc;
+		goto error_devm_kzalloc;
 	}
 
 	/* setup gpio */
@@ -122,16 +122,14 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		retval = PTR_ERR(bl);
-		goto error_backlight_device_register;
+		goto error_devm_kzalloc;
 	}
 
 	platform_set_drvdata(pdev, bl);
 
 	return 0;
 
-error_backlight_device_register:
-	kfree(data);
-error_kzalloc:
+error_devm_kzalloc:
 	cs5535_mfgpt_free_timer(pwm_timer);
 error_mfgpt_alloc:
 	gpio_free(GPIO_DIMM);
@@ -141,7 +139,6 @@ error_mfgpt_alloc:
 static int ot200_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct ot200_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
 
@@ -154,7 +151,6 @@ static int ot200_backlight_remove(struct platform_device *pdev)
 	cs5535_mfgpt_free_timer(pwm_timer);
 	gpio_free(GPIO_DIMM);
 
-	kfree(data);
 	return 0;
 }
 
-- 
1.7.1


