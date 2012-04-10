Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2DJIBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:01:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41928 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2DJIBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:01:39 -0400
Date: Tue, 10 Apr 2012 01:01:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: ep93xx_keypad - switch to using dev_pm_ops
Message-ID: <20120410080134.GA19114@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/ep93xx_keypad.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index 0ba69f3..d6cd634 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -182,16 +182,16 @@ static void ep93xx_keypad_close(struct input_dev *pdev)
 }
 
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /*
  * NOTE: I don't know if this is correct, or will work on the ep93xx.
  *
  * None of the existing ep93xx drivers have power management support.
  * But, this is basically what the pxa27x_keypad driver does.
  */
-static int ep93xx_keypad_suspend(struct platform_device *pdev,
-				 pm_message_t state)
+static int ep93xx_keypad_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct ep93xx_keypad *keypad = platform_get_drvdata(pdev);
 	struct input_dev *input_dev = keypad->input_dev;
 
@@ -210,8 +210,9 @@ static int ep93xx_keypad_suspend(struct platform_device *pdev,
 	return 0;
 }
 
-static int ep93xx_keypad_resume(struct platform_device *pdev)
+static int ep93xx_keypad_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct ep93xx_keypad *keypad = platform_get_drvdata(pdev);
 	struct input_dev *input_dev = keypad->input_dev;
 
@@ -232,10 +233,10 @@ static int ep93xx_keypad_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#else	/* !CONFIG_PM */
-#define ep93xx_keypad_suspend	NULL
-#define ep93xx_keypad_resume	NULL
-#endif	/* !CONFIG_PM */
+#endif
+
+static SIMPLE_DEV_PM_OPS(ep93xx_keypad_pm_ops,
+			 ep93xx_keypad_suspend, ep93xx_keypad_resume);
 
 static int __devinit ep93xx_keypad_probe(struct platform_device *pdev)
 {
@@ -384,11 +385,10 @@ static struct platform_driver ep93xx_keypad_driver = {
 	.driver		= {
 		.name	= "ep93xx-keypad",
 		.owner	= THIS_MODULE,
+		.pm	= &ep93xx_keypad_pm_ops,
 	},
 	.probe		= ep93xx_keypad_probe,
 	.remove		= __devexit_p(ep93xx_keypad_remove),
-	.suspend	= ep93xx_keypad_suspend,
-	.resume		= ep93xx_keypad_resume,
 };
 module_platform_driver(ep93xx_keypad_driver);
 
-- 
1.7.7.6


-- 
Dmitry
