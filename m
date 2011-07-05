Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1GETuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:50:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46975 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1GETt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:49:59 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 4/5] MFD: twl6040: Demand valid interrupt configuration
Date: Tue, 5 Jul 2011 22:49:35 +0300
Message-ID: <1309895376-17446-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to operate correctly twl6040 needs correct
interrupt configuration.
The slave drivers (vibra, and ASoC codec) will refuse
to probe, if the interrupt configuration is not correct.
In this way some checks can be removed from the code.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |   42 +++++++++++++++++++++---------------------
 drivers/mfd/twl6040-irq.c  |   16 +---------------
 2 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 471f489..f71bb14 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -459,6 +459,12 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/* In order to operate correctly we need valid interrupt config */
+	if (!pdata->naudint_irq || !pdata->irq_base) {
+		dev_err(&pdev->dev, "Invalid IRQ configuration\n");
+		return -EINVAL;
+	}
+
 	twl6040 = kzalloc(sizeof(struct twl6040), GFP_KERNEL);
 	if (!twl6040)
 		return -ENOMEM;
@@ -491,20 +497,18 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	if (twl6040->rev == TWL6040_REV_ES1_0)
 		twl6040->audpwron = -EINVAL;
 
-	if (twl6040->irq) {
-		/* codec interrupt */
-		ret = twl6040_irq_init(twl6040);
-		if (ret)
-			goto gpio2_err;
-
-		ret = twl6040_request_irq(twl6040, TWL6040_IRQ_READY,
-					  twl6040_naudint_handler, 0,
-					  "twl6040_irq_ready", twl6040);
-		if (ret) {
-			dev_err(twl6040->dev, "READY IRQ request failed: %d\n",
-				ret);
-			goto irq_err;
-		}
+	/* codec interrupt */
+	ret = twl6040_irq_init(twl6040);
+	if (ret)
+		goto gpio2_err;
+
+	ret = twl6040_request_irq(twl6040, TWL6040_IRQ_READY,
+					twl6040_naudint_handler, 0,
+					"twl6040_irq_ready", twl6040);
+	if (ret) {
+		dev_err(twl6040->dev, "READY IRQ request failed: %d\n",
+			ret);
+		goto irq_err;
 	}
 
 	/* dual-access registers controlled by I2C only */
@@ -553,11 +557,9 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	return 0;
 
 mfd_err:
-	if (twl6040->irq)
-		twl6040_free_irq(twl6040, TWL6040_IRQ_READY, twl6040);
+	twl6040_free_irq(twl6040, TWL6040_IRQ_READY, twl6040);
 irq_err:
-	if (twl6040->irq)
-		twl6040_irq_exit(twl6040);
+	twl6040_irq_exit(twl6040);
 gpio2_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
@@ -579,9 +581,7 @@ static int __devexit twl6040_remove(struct platform_device *pdev)
 		gpio_free(twl6040->audpwron);
 
 	twl6040_free_irq(twl6040, TWL6040_IRQ_READY, twl6040);
-
-	if (twl6040->irq)
-		twl6040_irq_exit(twl6040);
+	twl6040_irq_exit(twl6040);
 
 	mfd_remove_devices(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
diff --git a/drivers/mfd/twl6040-irq.c b/drivers/mfd/twl6040-irq.c
index 9380535..b3f8dda 100644
--- a/drivers/mfd/twl6040-irq.c
+++ b/drivers/mfd/twl6040-irq.c
@@ -148,19 +148,6 @@ int twl6040_irq_init(struct twl6040 *twl6040)
 	twl6040->irq_masks_cache = TWL6040_ALLINT_MSK;
 	twl6040_reg_write(twl6040, TWL6040_REG_INTMR, TWL6040_ALLINT_MSK);
 
-	if (!twl6040->irq) {
-		dev_warn(twl6040->dev,
-			 "no interrupt specified, no interrupts\n");
-		twl6040->irq_base = 0;
-		return 0;
-	}
-
-	if (!twl6040->irq_base) {
-		dev_err(twl6040->dev,
-			"no interrupt base specified, no interrupts\n");
-		return 0;
-	}
-
 	/* Register them with genirq */
 	for (cur_irq = twl6040->irq_base;
 	     cur_irq < twl6040->irq_base + ARRAY_SIZE(twl6040_irqs);
@@ -199,7 +186,6 @@ EXPORT_SYMBOL(twl6040_irq_init);
 
 void twl6040_irq_exit(struct twl6040 *twl6040)
 {
-	if (twl6040->irq)
-		free_irq(twl6040->irq, twl6040);
+	free_irq(twl6040->irq, twl6040);
 }
 EXPORT_SYMBOL(twl6040_irq_exit);
-- 
1.7.6

