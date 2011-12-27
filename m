Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1L0OQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:16:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53683 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab1L0OQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:16:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/6] video: s3c-fb: Take a runtime PM reference when unblanked
Date: Tue, 27 Dec 2011 14:16:10 +0000
Message-Id: <1324995372-3410-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
 <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the framebuffer is unblanked hold a runtime PM reference. This
prevents us powering down when userspace has left an image on the
framebuffer and prepares the way for being able to power down the hardware
when an application still has the device open.

Since we now hold a runtime PM reference whenever the display is unblanked
there is no need for the runtime power management to disable and enable
the display, and doing so would lead to runtime PM trying to recurse into
itself when called from the blanking code, so split the runtime PM into
separate functions which only deal with the clocks.  The PM core will
runtime resume the device prior to system suspend.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/video/s3c-fb.c |   66 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 2e0eef0..688b9d8 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -192,6 +192,7 @@ struct s3c_fb_vsync {
  * @regs: The mapped hardware registers.
  * @variant: Variant information for this hardware.
  * @enabled: A bitmask of enabled hardware windows.
+ * @output_on: Flag if the physical output is enabled.
  * @pdata: The platform configuration data passed with the device.
  * @windows: The hardware windows that have been claimed.
  * @irq_no: IRQ line number
@@ -208,6 +209,7 @@ struct s3c_fb {
 	struct s3c_fb_variant	 variant;
 
 	unsigned char		 enabled;
+	bool			 output_on;
 
 	struct s3c_fb_platdata	*pdata;
 	struct s3c_fb_win	*windows[S3C_FB_MAX_WIN];
@@ -449,21 +451,28 @@ static void s3c_fb_enable(struct s3c_fb *sfb, int enable)
 {
 	u32 vidcon0 = readl(sfb->regs + VIDCON0);
 
-	if (enable)
+	if (enable && !sfb->output_on)
+		pm_runtime_get_sync(sfb->dev);
+
+	if (enable) {
 		vidcon0 |= VIDCON0_ENVID | VIDCON0_ENVID_F;
-	else {
+	} else {
 		/* see the note in the framebuffer datasheet about
 		 * why you cannot take both of these bits down at the
 		 * same time. */
 
-		if (!(vidcon0 & VIDCON0_ENVID))
-			return;
-
-		vidcon0 |= VIDCON0_ENVID;
-		vidcon0 &= ~VIDCON0_ENVID_F;
+		if (vidcon0 & VIDCON0_ENVID) {
+			vidcon0 |= VIDCON0_ENVID;
+			vidcon0 &= ~VIDCON0_ENVID_F;
+		}
 	}
 
 	writel(vidcon0, sfb->regs + VIDCON0);
+
+	if (!enable && sfb->output_on)
+		pm_runtime_put_sync(sfb->dev);
+
+	sfb->output_on = enable;
 }
 
 /**
@@ -1539,7 +1548,7 @@ static int __devexit s3c_fb_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int s3c_fb_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1609,11 +1618,40 @@ static int s3c_fb_resume(struct device *dev)
 
 	return 0;
 }
-#else
-#define s3c_fb_suspend NULL
-#define s3c_fb_resume  NULL
 #endif
 
+#ifdef CONFIG_PM_RUNTIME
+static int s3c_fb_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s3c_fb *sfb = platform_get_drvdata(pdev);
+
+	if (!sfb->variant.has_clksel)
+		clk_disable(sfb->lcd_clk);
+
+	clk_disable(sfb->bus_clk);
+
+	return 0;
+}
+
+static int s3c_fb_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s3c_fb *sfb = platform_get_drvdata(pdev);
+	struct s3c_fb_platdata *pd = sfb->pdata;
+
+	clk_enable(sfb->bus_clk);
+
+	if (!sfb->variant.has_clksel)
+		clk_enable(sfb->lcd_clk);
+
+	/* setup gpio and output polarity controls */
+	pd->setup_gpio();
+	writel(pd->vidcon1, sfb->regs + VIDCON1);
+
+	return 0;
+}
+#endif
 
 #define VALID_BPP124 (VALID_BPP(1) | VALID_BPP(2) | VALID_BPP(4))
 #define VALID_BPP1248 (VALID_BPP124 | VALID_BPP(8))
@@ -1936,7 +1974,11 @@ static struct platform_device_id s3c_fb_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, s3c_fb_driver_ids);
 
-static UNIVERSAL_DEV_PM_OPS(s3cfb_pm_ops, s3c_fb_suspend, s3c_fb_resume, NULL);
+static const struct dev_pm_ops s3cfb_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(s3c_fb_suspend, s3c_fb_resume)
+	SET_RUNTIME_PM_OPS(s3c_fb_runtime_suspend, s3c_fb_runtime_resume,
+			   NULL)
+};
 
 static struct platform_driver s3c_fb_driver = {
 	.probe		= s3c_fb_probe,
-- 
1.7.7.3

