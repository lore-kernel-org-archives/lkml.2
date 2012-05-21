Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2EUJT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:19:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29164 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab2EUJTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:19:24 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-55-4fba089b5af9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Christian Gmeiner'" <christian.gmeiner@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/3] backlight: ot200_bl: use devm_ functions
Date: Mon, 21 May 2012 18:19:22 +0900
Message-id: <002c01cd3732$cf4d3b10$6de7b130$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac03Ms7ncW6oyVVORvu5GLcF5syd9Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd3ZHLv8DS785ra4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZk3aeZyn4wldxoyuygXE7TxcjJ4eEgIlE9/SF7BC2mMSFe+vZ
	uhi5OIQEpjNKbD+ymRXCmc0kMWvzNGaQKjYBNYkvXw6DdYgIREg0z5jFDFLELNDMKLFy+UbG
	LkYODmEBW4m3ndUgNSwCqhIr595kBbF5gcJfn99jhLAFJX5MvscCYjMLaEms33mcCcKWl9i8
	5i0zyBgJAXWJR391IVbpSfw6+YodokREYt+Ld4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcFg+k9rBuLLB4hCjAAejEg/vzKc7/YVYE8uKK3MPMUpw
	MCuJ8N59CBTiTUmsrEotyo8vKs1JLT7EKM3BoiTOa7d4h7+QQHpiSWp2ampBahFMlomDU6qB
	USPg770AmRp/turPJj9YGS6lVOxLkFp7JKh83qftkZ0lUuXKorxneOaYpPs9c3jzOtzn8f3A
	71/5Ck1tmb0T7KP9WBVsvyjXvGC0qOrb9OUxo2fQqiszd7FPt5GbI1X7YbbxzO8ShoIdcxvE
	rWuXbp36+vkd4amVFt/mb2n72XDv9wqtm0+OKrEUZyQaajEXFScCAEuUE+xHAgAA
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


