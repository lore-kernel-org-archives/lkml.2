Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1FPIaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:30:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58762 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1FPIaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:30:07 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-90-4df9bf0d4d98
Date: Thu, 16 Jun 2011 17:30:02 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/2] Samsung SoC ADC: use regulator (VDD for ADC).
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        dg77.kim@samsung.com
Message-id: <1308213003-6526-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 16 Jun 2011 08:29:52.0085 (UTC)
 FILETIME=[9014F850:01CC2BFF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the Samsung ADC driver to enable VDD regulator at
probe and resume and to disable at exit and suspend.
In a platform where ADC's VDD regulator is not "always-on", this control
is required although this patch does not provide fine-grained power
control (turning on the regulator only when being accessed).

However, if VDD regulator ("vdd" for the adc device) is not provided,
the regulator control will not be activated because there are platforms
that do not provide regulator for ADC device.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/adc.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index e8f2be2..a8499d8 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -21,6 +21,7 @@
 #include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/regulator/consumer.h>
 
 #include <plat/regs-adc.h>
 #include <plat/adc.h>
@@ -59,6 +60,8 @@ struct s3c_adc_client {
 			      unsigned *samples_left);
 };
 
+#define S3C_ADC_REGULATOR_NAME		"vdd"
+
 struct adc_device {
 	struct platform_device	*pdev;
 	struct platform_device	*owner;
@@ -71,6 +74,7 @@ struct adc_device {
 	unsigned int		 prescale;
 
 	int			 irq;
+	struct regulator	*vdd;
 };
 
 static struct adc_device *adc_dev;
@@ -338,6 +342,12 @@ static int s3c_adc_probe(struct platform_device *pdev)
 	adc->pdev = pdev;
 	adc->prescale = S3C2410_ADCCON_PRSCVL(49);
 
+	adc->vdd = regulator_get(dev, S3C_ADC_REGULATOR_NAME);
+	if (IS_ERR_OR_NULL(adc->vdd)) {
+		dev_dbg(dev, "operating without regulator %s.\n", S3C_ADC_REGULATOR_NAME);
+		adc->vdd = NULL; /* Do not control regulator */
+	}
+
 	adc->irq = platform_get_irq(pdev, 1);
 	if (adc->irq <= 0) {
 		dev_err(dev, "failed to get adc irq\n");
@@ -372,6 +382,8 @@ static int s3c_adc_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
+	if (adc->vdd)
+		regulator_enable(adc->vdd);
 	clk_enable(adc->clk);
 
 	tmp = adc->prescale | S3C2410_ADCCON_PRSCEN;
@@ -406,6 +418,8 @@ static int __devexit s3c_adc_remove(struct platform_device *pdev)
 	iounmap(adc->regs);
 	free_irq(adc->irq, adc);
 	clk_disable(adc->clk);
+	if (adc->vdd)
+		regulator_disable(adc->vdd);
 	clk_put(adc->clk);
 	kfree(adc);
 
@@ -428,6 +442,8 @@ static int s3c_adc_suspend(struct platform_device *pdev, pm_message_t state)
 	disable_irq(adc->irq);
 	spin_unlock_irqrestore(&adc->lock, flags);
 	clk_disable(adc->clk);
+	if (adc->vdd)
+		regulator_disable(adc->vdd);
 
 	return 0;
 }
@@ -436,6 +452,8 @@ static int s3c_adc_resume(struct platform_device *pdev)
 {
 	struct adc_device *adc = platform_get_drvdata(pdev);
 
+	if (adc->vdd)
+		regulator_enable(adc->vdd);
 	clk_enable(adc->clk);
 	enable_irq(adc->irq);
 
@@ -485,4 +503,4 @@ static int __init adc_init(void)
 	return ret;
 }
 
-arch_initcall(adc_init);
+module_init(adc_init);
-- 
1.7.4.1

