Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab1F3HuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:50:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46463 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab1F3Htj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:49:39 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-3e-4e0c2a8f130e
Date: Thu, 30 Jun 2011 16:49:32 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v3 3/6] Samsung SoC ADC: Revise PM for 12-bit ADC operations
In-reply-to: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        Seungwhan Youn <sw.youn@samsung.com>, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com
Message-id: <1309420175-10301-4-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 30 Jun 2011 07:49:50.0172 (UTC)
 FILETIME=[4A36A1C0:01CC36FA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fixed: 12bit precision is lost at suspend/resume
- Updated: use pm_dev_ops

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/adc.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index 45cc7e6..ee8deef 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -437,8 +437,10 @@ static int __devexit s3c_adc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int s3c_adc_suspend(struct platform_device *pdev, pm_message_t state)
+static int s3c_adc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
 	struct adc_device *adc = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u32 con;
@@ -457,10 +459,13 @@ static int s3c_adc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int s3c_adc_resume(struct platform_device *pdev)
+static int s3c_adc_resume(struct device *dev)
 {
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
 	struct adc_device *adc = platform_get_drvdata(pdev);
 	int ret;
+	unsigned long tmp;
 
 	ret = regulator_enable(adc->vdd);
 	if (ret)
@@ -468,8 +473,11 @@ static int s3c_adc_resume(struct platform_device *pdev)
 	clk_enable(adc->clk);
 	enable_irq(adc->irq);
 
-	writel(adc->prescale | S3C2410_ADCCON_PRSCEN,
-	       adc->regs + S3C2410_ADCCON);
+	tmp = adc->prescale | S3C2410_ADCCON_PRSCEN;
+	/* Enable 12-bit ADC resolution */
+	if (platform_get_device_id(pdev)->driver_data != TYPE_ADCV1)
+		tmp |= S3C64XX_ADCCON_RESSEL;
+	writel(tmp, adc->regs + S3C2410_ADCCON);
 
 	return 0;
 }
@@ -494,16 +502,20 @@ static struct platform_device_id s3c_adc_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, s3c_adc_driver_ids);
 
+static const struct dev_pm_ops adc_pm_ops = {
+	.suspend	= s3c_adc_suspend,
+	.resume		= s3c_adc_resume,
+};
+
 static struct platform_driver s3c_adc_driver = {
 	.id_table	= s3c_adc_driver_ids,
 	.driver		= {
 		.name	= "s3c-adc",
 		.owner	= THIS_MODULE,
+		.pm	= &adc_pm_ops,
 	},
 	.probe		= s3c_adc_probe,
 	.remove		= __devexit_p(s3c_adc_remove),
-	.suspend	= s3c_adc_suspend,
-	.resume		= s3c_adc_resume,
 };
 
 static int __init adc_init(void)
-- 
1.7.4.1

