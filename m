Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2H3H4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 03:56:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59674 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2H3H4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 03:56:02 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v2 5/5] MFD: ti_tscadc: add suspend/resume functionality
Date: Thu, 30 Aug 2012 13:08:26 +0530
Message-ID: <1346312306-21082-6-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346312306-21082-1-git-send-email-rachna@ti.com>
References: <1346312306-21082-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for suspend/resume of
TSC/ADC MFDevice.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
Changes in v2:
	Added this patch newly in this patch series.

 drivers/iio/adc/ti_adc.c           |   32 ++++++++++++++++++++++++++++++++
 drivers/input/touchscreen/ti_tsc.c |   33 +++++++++++++++++++++++++++++++++
 drivers/mfd/ti_tscadc.c            |   33 ++++++++++++++++++++++++++++++++-
 include/linux/mfd/ti_tscadc.h      |    3 +++
 4 files changed, 100 insertions(+), 1 deletions(-)

diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c
index d2e621c..14601f0 100644
--- a/drivers/iio/adc/ti_adc.c
+++ b/drivers/iio/adc/ti_adc.c
@@ -200,6 +200,36 @@ static int __devexit tiadc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int adc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ti_tscadc_dev   *tscadc_dev = pdev->dev.platform_data;
+	struct adc_device	*adc_dev = tscadc_dev->adc;
+	unsigned int idle;
+
+	if (!device_may_wakeup(tscadc_dev->dev)) {
+		idle = adc_readl(adc_dev, REG_CTRL);
+		idle &= ~(CNTRLREG_TSCSSENB);
+		adc_writel(adc_dev, REG_CTRL, (idle |
+				CNTRLREG_POWERDOWN));
+	}
+	return 0;
+}
+
+static int adc_resume(struct platform_device *pdev)
+{
+	struct ti_tscadc_dev   *tscadc_dev = pdev->dev.platform_data;
+	struct adc_device	*adc_dev = tscadc_dev->adc;
+	unsigned int restore;
+
+	/* Make sure ADC is powered up */
+	restore = adc_readl(adc_dev, REG_CTRL);
+	restore &= ~(CNTRLREG_POWERDOWN);
+	adc_writel(adc_dev, REG_CTRL, restore);
+
+	adc_step_config(adc_dev);
+	return 0;
+}
+
 static struct platform_driver tiadc_driver = {
 	.driver = {
 		.name   = "tiadc",
@@ -207,6 +237,8 @@ static struct platform_driver tiadc_driver = {
 	},
 	.probe	= tiadc_probe,
 	.remove	= __devexit_p(tiadc_remove),
+	.suspend = adc_suspend,
+	.resume = adc_resume,
 };
 
 module_platform_driver(tiadc_driver);
diff --git a/drivers/input/touchscreen/ti_tsc.c b/drivers/input/touchscreen/ti_tsc.c
index ca8ce73..f103e5f 100644
--- a/drivers/input/touchscreen/ti_tsc.c
+++ b/drivers/input/touchscreen/ti_tsc.c
@@ -338,6 +338,37 @@ static int __devexit tscadc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int tsc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
+	struct tscadc		*ts_dev = tscadc_dev->tsc;
+	unsigned int idle;
+
+	if (device_may_wakeup(tscadc_dev->dev)) {
+		idle = tscadc_readl(ts_dev, REG_IRQENABLE);
+		tscadc_writel(ts_dev, REG_IRQENABLE,
+				(idle | IRQENB_HW_PEN));
+		tscadc_writel(ts_dev, REG_IRQWAKEUP, IRQWKUP_ENB);
+	}
+	return 0;
+}
+
+static int tsc_resume(struct platform_device *pdev)
+{
+	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
+	struct tscadc		*ts_dev = tscadc_dev->tsc;
+
+	if (device_may_wakeup(tscadc_dev->dev)) {
+		tscadc_writel(ts_dev, REG_IRQWAKEUP,
+				0x00);
+		tscadc_writel(ts_dev, REG_IRQCLR, IRQENB_HW_PEN);
+	}
+	tscadc_step_config(ts_dev);
+	tscadc_writel(ts_dev, REG_FIFO0THR,
+			ts_dev->steps_to_configure);
+	return 0;
+}
+
 static struct platform_driver ti_tsc_driver = {
 	.probe	= tscadc_probe,
 	.remove	= __devexit_p(tscadc_remove),
@@ -345,6 +376,8 @@ static struct platform_driver ti_tsc_driver = {
 		.name   = "tsc",
 		.owner	= THIS_MODULE,
 	},
+	.suspend = tsc_suspend,
+	.resume = tsc_resume,
 };
 module_platform_driver(ti_tsc_driver);
 
diff --git a/drivers/mfd/ti_tscadc.c b/drivers/mfd/ti_tscadc.c
index 9dbd6d0..2c84aed 100644
--- a/drivers/mfd/ti_tscadc.c
+++ b/drivers/mfd/ti_tscadc.c
@@ -170,6 +170,7 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_disable_clk;
 
+	device_init_wakeup(&pdev->dev, true);
 	platform_set_drvdata(pdev, tscadc);
 	return 0;
 
@@ -203,6 +204,35 @@ static int __devexit ti_tscadc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int tscadc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ti_tscadc_dev	*tscadc_dev = platform_get_drvdata(pdev);
+
+	tscadc_writel(tscadc_dev, REG_SE, 0x00);
+	pm_runtime_put_sync(&pdev->dev);
+	return 0;
+}
+
+static int tscadc_resume(struct platform_device *pdev)
+{
+	struct ti_tscadc_dev	*tscadc_dev = platform_get_drvdata(pdev);
+	unsigned int restore, ctrl;
+
+	pm_runtime_get_sync(&pdev->dev);
+
+	/* context restore */
+	ctrl = CNTRLREG_STEPCONFIGWRT | CNTRLREG_TSCENB |
+			CNTRLREG_STEPID | CNTRLREG_4WIRE;
+	tscadc_writel(tscadc_dev, REG_CTRL, ctrl);
+	tscadc_idle_config(tscadc_dev);
+	tscadc_writel(tscadc_dev, REG_SE, STPENB_STEPENB);
+	restore = tscadc_readl(tscadc_dev, REG_CTRL);
+	tscadc_writel(tscadc_dev, REG_CTRL,
+			(restore | CNTRLREG_TSCSSENB));
+
+	return 0;
+}
+
 static struct platform_driver ti_tscadc_driver = {
 	.driver = {
 		.name   = "ti_tscadc",
@@ -210,7 +240,8 @@ static struct platform_driver ti_tscadc_driver = {
 	},
 	.probe	= ti_tscadc_probe,
 	.remove	= __devexit_p(ti_tscadc_remove),
-
+	.suspend = tscadc_suspend,
+	.resume = tscadc_resume,
 };
 
 module_platform_driver(ti_tscadc_driver);
diff --git a/include/linux/mfd/ti_tscadc.h b/include/linux/mfd/ti_tscadc.h
index 3414883..e0a6437 100644
--- a/include/linux/mfd/ti_tscadc.h
+++ b/include/linux/mfd/ti_tscadc.h
@@ -40,6 +40,9 @@
 #define REG_FIFO1		0x200
 
 /*	Register Bitfields	*/
+/* IRQ wakeup enable */
+#define IRQWKUP_ENB		BIT(0)
+
 /* Step Enable */
 #define STEPENB_MASK		(0x1FFFF << 0)
 #define STEPENB(val)		((val) << 0)
-- 
1.7.1

