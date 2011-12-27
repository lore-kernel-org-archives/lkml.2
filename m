Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1L0OQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:16:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53674 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359Ab1L0OQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:16:18 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] video: s3c-fb: Make runtime PM functional again
Date: Tue, 27 Dec 2011 14:16:07 +0000
Message-Id: <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20111227141550.GA3331@opensource.wolfsonmicro.com>
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change in "video: s3c-fb: modify runtime pm functions" (commit
35784b) renders the runtime power management for the device completely
ineffectual as while it leaves runtime power management notionally
enabled a runtime power reference is held for the entire time the device
is registered meaning it will never actually do anything.

A further issue is introduced as runtime power management is added
during the system suspend path which is not something which drivers are
supposed to do and would interact poorly if there were any operations
done in the runtime power management callbacks.

While this does make things simpler (the main motivation for the
original change) it will not only cause us to use more power in the
framebuffer controller but will also prevent us entering lower power
domain and SoC wide states as we can never power down the domain
containing the device.  Since neither of these things is desirable
revert the change.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/video/s3c-fb.c |   51 +++++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index a0b3fd6..b1a75a0 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1038,8 +1038,30 @@ static int s3c_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	return ret;
 }
 
+static int s3c_fb_open(struct fb_info *info, int user)
+{
+	struct s3c_fb_win *win = info->par;
+	struct s3c_fb *sfb = win->parent;
+
+	pm_runtime_get_sync(sfb->dev);
+
+	return 0;
+}
+
+static int s3c_fb_release(struct fb_info *info, int user)
+{
+	struct s3c_fb_win *win = info->par;
+	struct s3c_fb *sfb = win->parent;
+
+	pm_runtime_put_sync(sfb->dev);
+
+	return 0;
+}
+
 static struct fb_ops s3c_fb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_open	= s3c_fb_open,
+	.fb_release	= s3c_fb_release,
 	.fb_check_var	= s3c_fb_check_var,
 	.fb_set_par	= s3c_fb_set_par,
 	.fb_blank	= s3c_fb_blank,
@@ -1446,6 +1468,7 @@ static int __devinit s3c_fb_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, sfb);
+	pm_runtime_put_sync(sfb->dev);
 
 	return 0;
 
@@ -1485,6 +1508,8 @@ static int __devexit s3c_fb_remove(struct platform_device *pdev)
 	struct s3c_fb *sfb = platform_get_drvdata(pdev);
 	int win;
 
+	pm_runtime_get_sync(sfb->dev);
+
 	for (win = 0; win < S3C_FB_MAX_WIN; win++)
 		if (sfb->windows[win])
 			s3c_fb_release_win(sfb, sfb->windows[win]);
@@ -1510,7 +1535,7 @@ static int __devexit s3c_fb_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 static int s3c_fb_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1531,8 +1556,6 @@ static int s3c_fb_suspend(struct device *dev)
 		clk_disable(sfb->lcd_clk);
 
 	clk_disable(sfb->bus_clk);
-	pm_runtime_put_sync(sfb->dev);
-
 	return 0;
 }
 
@@ -1544,7 +1567,6 @@ static int s3c_fb_resume(struct device *dev)
 	struct s3c_fb_win *win;
 	int win_no;
 
-	pm_runtime_get_sync(sfb->dev);
 	clk_enable(sfb->bus_clk);
 
 	if (!sfb->variant.has_clksel)
@@ -1583,19 +1605,11 @@ static int s3c_fb_resume(struct device *dev)
 
 	return 0;
 }
+#else
+#define s3c_fb_suspend NULL
+#define s3c_fb_resume  NULL
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
-static int s3c_fb_runtime_suspend(struct device *dev)
-{
-	return 0;
-}
-
-static int s3c_fb_runtime_resume(struct device *dev)
-{
-	return 0;
-}
-#endif
 
 #define VALID_BPP124 (VALID_BPP(1) | VALID_BPP(2) | VALID_BPP(4))
 #define VALID_BPP1248 (VALID_BPP124 | VALID_BPP(8))
@@ -1918,10 +1932,7 @@ static struct platform_device_id s3c_fb_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, s3c_fb_driver_ids);
 
-static const struct dev_pm_ops s3c_fb_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(s3c_fb_suspend, s3c_fb_resume)
-	SET_RUNTIME_PM_OPS(s3c_fb_runtime_suspend, s3c_fb_runtime_resume, NULL)
-};
+static UNIVERSAL_DEV_PM_OPS(s3cfb_pm_ops, s3c_fb_suspend, s3c_fb_resume, NULL);
 
 static struct platform_driver s3c_fb_driver = {
 	.probe		= s3c_fb_probe,
@@ -1930,7 +1941,7 @@ static struct platform_driver s3c_fb_driver = {
 	.driver		= {
 		.name	= "s3c-fb",
 		.owner	= THIS_MODULE,
-		.pm	= &s3c_fb_pm_ops,
+		.pm	= &s3cfb_pm_ops,
 	},
 };
 
-- 
1.7.7.3

