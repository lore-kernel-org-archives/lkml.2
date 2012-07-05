Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2GED7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:59:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2GED72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:59:28 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 3/6] mfd: max77686: Allow to specify interrupt through DT or platform file also.
Date: Thu,  5 Jul 2012 09:28:22 +0530
Message-Id: <1341460705-10868-3-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presently driver expects irq_gpio pin in platform data and maps it to irq
itself. But we can also directly specify the interrupt in DT or platform file.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/mfd/max77686-irq.c |   33 ++++++++++++++++++++-------------
 drivers/mfd/max77686.c     |    1 +
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
index 0758fac..1fbbc64 100644
--- a/drivers/mfd/max77686-irq.c
+++ b/drivers/mfd/max77686-irq.c
@@ -252,21 +252,28 @@ int max77686_irq_init(struct max77686_dev *max77686)
 
 	mutex_init(&max77686->irqlock);
 
-	max77686->irq = gpio_to_irq(max77686->irq_gpio);
-
-	if (debug_mask & MAX77686_DEBUG_IRQ_INT) {
-		ret = gpio_request(max77686->irq_gpio, "pmic_irq");
-		if (ret < 0) {
-			dev_err(max77686->dev,
-				"Failed to request gpio %d with ret: %d\n",
-				max77686->irq_gpio, ret);
-			return IRQ_NONE;
+	if (max77686->irq_gpio && !max77686->irq) {
+		max77686->irq = gpio_to_irq(max77686->irq_gpio);
+
+		if (debug_mask & MAX77686_DEBUG_IRQ_INT) {
+			ret = gpio_request(max77686->irq_gpio, "pmic_irq");
+			if (ret < 0) {
+				dev_err(max77686->dev,
+					"Failed to request gpio %d with ret:"
+					"%d\n",	max77686->irq_gpio, ret);
+				return IRQ_NONE;
+			}
+
+			gpio_direction_input(max77686->irq_gpio);
+			val = gpio_get_value(max77686->irq_gpio);
+			gpio_free(max77686->irq_gpio);
+			pr_info("%s: gpio_irq=%x\n", __func__, val);
 		}
+	}
 
-		gpio_direction_input(max77686->irq_gpio);
-		val = gpio_get_value(max77686->irq_gpio);
-		gpio_free(max77686->irq_gpio);
-		pr_info("%s: gpio_irq=%x\n", __func__, val);
+	if (!max77686->irq) {
+		dev_err(max77686->dev, "irq is not specified\n");
+		return -ENODEV;
 	}
 
 	/* Mask individual interrupt sources */
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 11e5601..5c78e94 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -78,6 +78,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 
 	max77686->wakeup = pdata->wakeup;
 	max77686->irq_gpio = pdata->irq_gpio;
+	max77686->irq = i2c->irq;
 
 	mutex_init(&max77686->iolock);
 
-- 
1.7.0.4

