Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2BTKQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:16:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64560 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2BTKQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:16:53 -0500
X-AuditID: cbfee61b-b7c62ae000000989-5e-4f421d940573
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: convert platform_lcd to dev_pm_ops
Date: Mon, 20 Feb 2012 19:16:51 +0900
Message-id: <017001ccefb8$c37e5880$4a7b0980$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczvuMM5kV+oeoJjST6nvn8WwDKHBQ==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/platform_lcd.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index f0bf491..b667234 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -121,9 +121,9 @@ static int __devexit platform_lcd_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int platform_lcd_suspend(struct platform_device *pdev, pm_message_t st)
+static int platform_lcd_suspend(struct device *dev)
 {
-	struct platform_lcd *plcd = platform_get_drvdata(pdev);
+	struct platform_lcd *plcd = dev_get_drvdata(dev);
 
 	plcd->suspended = 1;
 	platform_lcd_set_power(plcd->lcd, plcd->power);
@@ -131,29 +131,30 @@ static int platform_lcd_suspend(struct platform_device *pdev, pm_message_t st)
 	return 0;
 }
 
-static int platform_lcd_resume(struct platform_device *pdev)
+static int platform_lcd_resume(struct device *dev)
 {
-	struct platform_lcd *plcd = platform_get_drvdata(pdev);
+	struct platform_lcd *plcd = dev_get_drvdata(dev);
 
 	plcd->suspended = 0;
 	platform_lcd_set_power(plcd->lcd, plcd->power);
 
 	return 0;
 }
-#else
-#define platform_lcd_suspend NULL
-#define platform_lcd_resume NULL
+
+static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
+			platform_lcd_resume);
 #endif
 
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
 		.name	= "platform-lcd",
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &platform_lcd_pm_ops,
+#endif
 	},
 	.probe		= platform_lcd_probe,
 	.remove		= __devexit_p(platform_lcd_remove),
-	.suspend        = platform_lcd_suspend,
-	.resume         = platform_lcd_resume,
 };
 
 module_platform_driver(platform_lcd_driver);
-- 
1.7.1


