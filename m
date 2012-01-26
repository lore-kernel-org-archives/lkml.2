Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2AZKp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:45:57 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37210 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab2AZKpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:45:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] usb: musb: make modules behave better
Date: Thu, 26 Jan 2012 12:45:49 +0200
Message-Id: <1327574749-18552-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.2
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's really no point in doing all that
initcall trickery when we can safely let
udev handle module probing for us.

Remove all of that trickery, by moving everybody
to module_init() and making proper use of
platform_device_register() rather than
platform_device_probe().

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Because this falls into the "has never worked before" category
I will be sending this only on the next merge window. This
also gives people enough time to complain about any mistakes
on the patch.

 drivers/usb/musb/am35x.c     |   11 ++++++-----
 drivers/usb/musb/blackfin.c  |    9 +++++----
 drivers/usb/musb/da8xx.c     |   11 ++++++-----
 drivers/usb/musb/davinci.c   |   11 ++++++-----
 drivers/usb/musb/musb_core.c |   15 ++++++---------
 drivers/usb/musb/omap2430.c  |   11 ++++++-----
 drivers/usb/musb/tusb6010.c  |   11 ++++++-----
 drivers/usb/musb/ux500.c     |   11 ++++++-----
 8 files changed, 47 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index e233d2b..5285bda 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -456,7 +456,7 @@ static const struct musb_platform_ops am35x_ops = {
 
 static u64 am35x_dmamask = DMA_BIT_MASK(32);
 
-static int __init am35x_probe(struct platform_device *pdev)
+static int __devinit am35x_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
@@ -561,7 +561,7 @@ err0:
 	return ret;
 }
 
-static int __exit am35x_remove(struct platform_device *pdev)
+static int __devexit am35x_remove(struct platform_device *pdev)
 {
 	struct am35x_glue	*glue = platform_get_drvdata(pdev);
 
@@ -630,7 +630,8 @@ static struct dev_pm_ops am35x_pm_ops = {
 #endif
 
 static struct platform_driver am35x_driver = {
-	.remove		= __exit_p(am35x_remove),
+	.probe		= am35x_probe,
+	.remove		= __devexit_p(am35x_remove),
 	.driver		= {
 		.name	= "musb-am35x",
 		.pm	= DEV_PM_OPS,
@@ -643,9 +644,9 @@ MODULE_LICENSE("GPL v2");
 
 static int __init am35x_init(void)
 {
-	return platform_driver_probe(&am35x_driver, am35x_probe);
+	return platform_driver_register(&am35x_driver);
 }
-subsys_initcall(am35x_init);
+module_init(am35x_init);
 
 static void __exit am35x_exit(void)
 {
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 5e7cfba..261af34 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -463,7 +463,7 @@ static const struct musb_platform_ops bfin_ops = {
 
 static u64 bfin_dmamask = DMA_BIT_MASK(32);
 
-static int __init bfin_probe(struct platform_device *pdev)
+static int __devinit bfin_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
@@ -525,7 +525,7 @@ err0:
 	return ret;
 }
 
-static int __exit bfin_remove(struct platform_device *pdev)
+static int __devexit bfin_remove(struct platform_device *pdev)
 {
 	struct bfin_glue		*glue = platform_get_drvdata(pdev);
 
@@ -575,6 +575,7 @@ static struct dev_pm_ops bfin_pm_ops = {
 #endif
 
 static struct platform_driver bfin_driver = {
+	.probe		= bfin_probe,
 	.remove		= __exit_p(bfin_remove),
 	.driver		= {
 		.name	= "musb-blackfin",
@@ -588,9 +589,9 @@ MODULE_LICENSE("GPL v2");
 
 static int __init bfin_init(void)
 {
-	return platform_driver_probe(&bfin_driver, bfin_probe);
+	return platform_driver_register(&bfin_driver);
 }
-subsys_initcall(bfin_init);
+module_init(bfin_init);
 
 static void __exit bfin_exit(void)
 {
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 2613bfd..01c8f2e 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -478,7 +478,7 @@ static const struct musb_platform_ops da8xx_ops = {
 
 static u64 da8xx_dmamask = DMA_BIT_MASK(32);
 
-static int __init da8xx_probe(struct platform_device *pdev)
+static int __devinit da8xx_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
@@ -562,7 +562,7 @@ err0:
 	return ret;
 }
 
-static int __exit da8xx_remove(struct platform_device *pdev)
+static int __devexit da8xx_remove(struct platform_device *pdev)
 {
 	struct da8xx_glue		*glue = platform_get_drvdata(pdev);
 
@@ -576,7 +576,8 @@ static int __exit da8xx_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver da8xx_driver = {
-	.remove		= __exit_p(da8xx_remove),
+	.probe		= da8xx_probe,
+	.remove		= __devexit_p(da8xx_remove),
 	.driver		= {
 		.name	= "musb-da8xx",
 	},
@@ -588,9 +589,9 @@ MODULE_LICENSE("GPL v2");
 
 static int __init da8xx_init(void)
 {
-	return platform_driver_probe(&da8xx_driver, da8xx_probe);
+	return platform_driver_register(&da8xx_driver);
 }
-subsys_initcall(da8xx_init);
+module_init(da8xx_init);
 
 static void __exit da8xx_exit(void)
 {
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index f9a3f62..7802c7e 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -514,7 +514,7 @@ static const struct musb_platform_ops davinci_ops = {
 
 static u64 davinci_dmamask = DMA_BIT_MASK(32);
 
-static int __init davinci_probe(struct platform_device *pdev)
+static int __devinit davinci_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
@@ -597,7 +597,7 @@ err0:
 	return ret;
 }
 
-static int __exit davinci_remove(struct platform_device *pdev)
+static int __devexit davinci_remove(struct platform_device *pdev)
 {
 	struct davinci_glue		*glue = platform_get_drvdata(pdev);
 
@@ -611,7 +611,8 @@ static int __exit davinci_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver davinci_driver = {
-	.remove		= __exit_p(davinci_remove),
+	.probe		= davinci_probe,
+	.remove		= __devexit_p(davinci_remove),
 	.driver		= {
 		.name	= "musb-davinci",
 	},
@@ -623,9 +624,9 @@ MODULE_LICENSE("GPL v2");
 
 static int __init davinci_init(void)
 {
-	return platform_driver_probe(&davinci_driver, davinci_probe);
+	return platform_driver_register(&davinci_driver);
 }
-subsys_initcall(davinci_init);
+module_init(davinci_init);
 
 static void __exit davinci_exit(void)
 {
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 6a92985..bd54470 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2072,7 +2072,7 @@ fail0:
 static u64	*orig_dma_mask;
 #endif
 
-static int __init musb_probe(struct platform_device *pdev)
+static int __devinit musb_probe(struct platform_device *pdev)
 {
 	struct device	*dev = &pdev->dev;
 	int		irq = platform_get_irq_byname(pdev, "mc");
@@ -2101,7 +2101,7 @@ static int __init musb_probe(struct platform_device *pdev)
 	return status;
 }
 
-static int __exit musb_remove(struct platform_device *pdev)
+static int __devexit musb_remove(struct platform_device *pdev)
 {
 	struct musb	*musb = dev_to_musb(&pdev->dev);
 	void __iomem	*ctrl_base = musb->ctrl_base;
@@ -2361,7 +2361,8 @@ static struct platform_driver musb_driver = {
 		.owner		= THIS_MODULE,
 		.pm		= MUSB_DEV_PM_OPS,
 	},
-	.remove		= __exit_p(musb_remove),
+	.probe		= musb_probe,
+	.remove		= __devexit_p(musb_remove),
 	.shutdown	= musb_shutdown,
 };
 
@@ -2377,13 +2378,9 @@ static int __init musb_init(void)
 		", "
 		"otg (peripheral+host)",
 		musb_driver_name);
-	return platform_driver_probe(&musb_driver, musb_probe);
+	return platform_driver_register(&musb_driver);
 }
-
-/* make us init after usbcore and i2c (transceivers, regulators, etc)
- * and before usb gadget and host-side drivers start to register
- */
-fs_initcall(musb_init);
+module_init(musb_init);
 
 static void __exit musb_cleanup(void)
 {
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index c27bbbf..b254173 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -408,7 +408,7 @@ static const struct musb_platform_ops omap2430_ops = {
 
 static u64 omap2430_dmamask = DMA_BIT_MASK(32);
 
-static int __init omap2430_probe(struct platform_device *pdev)
+static int __devinit omap2430_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
@@ -471,7 +471,7 @@ err0:
 	return ret;
 }
 
-static int __exit omap2430_remove(struct platform_device *pdev)
+static int __devexit omap2430_remove(struct platform_device *pdev)
 {
 	struct omap2430_glue		*glue = platform_get_drvdata(pdev);
 
@@ -524,7 +524,8 @@ static struct dev_pm_ops omap2430_pm_ops = {
 #endif
 
 static struct platform_driver omap2430_driver = {
-	.remove		= __exit_p(omap2430_remove),
+	.probe		= omap2430_probe,
+	.remove		= __devexit_p(omap2430_remove),
 	.driver		= {
 		.name	= "musb-omap2430",
 		.pm	= DEV_PM_OPS,
@@ -537,9 +538,9 @@ MODULE_LICENSE("GPL v2");
 
 static int __init omap2430_init(void)
 {
-	return platform_driver_probe(&omap2430_driver, omap2430_probe);
+	return platform_driver_register(&omap2430_driver);
 }
-subsys_initcall(omap2430_init);
+module_init(omap2430_init);
 
 static void __exit omap2430_exit(void)
 {
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 1f40561..b387f12 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1165,7 +1165,7 @@ static const struct musb_platform_ops tusb_ops = {
 
 static u64 tusb_dmamask = DMA_BIT_MASK(32);
 
-static int __init tusb_probe(struct platform_device *pdev)
+static int __devinit tusb_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
@@ -1227,7 +1227,7 @@ err0:
 	return ret;
 }
 
-static int __exit tusb_remove(struct platform_device *pdev)
+static int __devexit tusb_remove(struct platform_device *pdev)
 {
 	struct tusb6010_glue		*glue = platform_get_drvdata(pdev);
 
@@ -1239,7 +1239,8 @@ static int __exit tusb_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver tusb_driver = {
-	.remove		= __exit_p(tusb_remove),
+	.probe		= tusb_probe,
+	.remove		= __devexit_p(tusb_remove),
 	.driver		= {
 		.name	= "musb-tusb",
 	},
@@ -1251,9 +1252,9 @@ MODULE_LICENSE("GPL v2");
 
 static int __init tusb_init(void)
 {
-	return platform_driver_probe(&tusb_driver, tusb_probe);
+	return platform_driver_register(&tusb_driver);
 }
-subsys_initcall(tusb_init);
+module_init(tusb_init);
 
 static void __exit tusb_exit(void)
 {
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index f7e04bf..bcfc48f 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -58,7 +58,7 @@ static const struct musb_platform_ops ux500_ops = {
 	.exit		= ux500_musb_exit,
 };
 
-static int __init ux500_probe(struct platform_device *pdev)
+static int __devinit ux500_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
@@ -141,7 +141,7 @@ err0:
 	return ret;
 }
 
-static int __exit ux500_remove(struct platform_device *pdev)
+static int __devexit ux500_remove(struct platform_device *pdev)
 {
 	struct ux500_glue	*glue = platform_get_drvdata(pdev);
 
@@ -194,7 +194,8 @@ static const struct dev_pm_ops ux500_pm_ops = {
 #endif
 
 static struct platform_driver ux500_driver = {
-	.remove		= __exit_p(ux500_remove),
+	.probe		= ux500_probe,
+	.remove		= __devexit_p(ux500_remove),
 	.driver		= {
 		.name	= "musb-ux500",
 		.pm	= DEV_PM_OPS,
@@ -207,9 +208,9 @@ MODULE_LICENSE("GPL v2");
 
 static int __init ux500_init(void)
 {
-	return platform_driver_probe(&ux500_driver, ux500_probe);
+	return platform_driver_register(&ux500_driver);
 }
-subsys_initcall(ux500_init);
+module_init(ux500_init);
 
 static void __exit ux500_exit(void)
 {
-- 
1.7.8.2

