Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2HUTCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:02:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33801 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919Ab2HUTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:02:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Suppress needless calls to the primary IRQ
Date: Tue, 21 Aug 2012 20:02:03 +0100
Message-Id: <1345575723-15794-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can read back if the primary IRQ is asserted from the register map,
meaning that we can suppress polling of the interrupt status registers
when only the AoD IRQ domain is asserting.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 64940c6..a062153 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -94,6 +94,7 @@ static irqreturn_t arizona_ctrlif_err(int irq, void *data)
 static irqreturn_t arizona_irq_thread(int irq, void *data)
 {
 	struct arizona *arizona = data;
+	unsigned int val;
 	int i, ret;
 
 	ret = pm_runtime_get_sync(arizona->dev);
@@ -102,9 +103,20 @@ static irqreturn_t arizona_irq_thread(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	/* Check both domains */
-	for (i = 0; i < 2; i++)
-		handle_nested_irq(irq_find_mapping(arizona->virq, i));
+	/* Always handle the AoD domain */
+	handle_nested_irq(irq_find_mapping(arizona->virq, 0));
+
+	/*
+	 * Check if one of the main interrupts is asserted and only
+	 * check that domain if it is.
+	 */
+	ret = regmap_read(arizona->regmap, ARIZONA_IRQ_PIN_STATUS, &val);
+	if (ret == 0 && val & ARIZONA_IRQ1_STS) {
+		handle_nested_irq(irq_find_mapping(arizona->virq, 1));
+	} else if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read main IRQ status: %d\n",
+			ret);
+	}
 
 	pm_runtime_mark_last_busy(arizona->dev);
 	pm_runtime_put_autosuspend(arizona->dev);
-- 
1.7.10.4

