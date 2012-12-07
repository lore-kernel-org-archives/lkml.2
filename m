Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740Ab2LGMA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 07:00:26 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38701 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2LGMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 07:00:24 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, cbou@mail.ru, anton.vorontsov@linaro.org,
        sachin.kamat@linaro.org, patches@linaro.org,
        Arun R Murthy <arun.murthy@stericsson.com>
Subject: [PATCH 1/1] power/ab8500_charger: Use devm_regulator_get API
Date: Fri,  7 Dec 2012 17:23:28 +0530
Message-Id: <1354881208-9930-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_regulator_get() is device managed and makes error handling
and code cleanup simpler.

Cc: Arun R Murthy <arun.murthy@stericsson.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Compile tested using linux-next.
---
 drivers/power/ab8500_charger.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 3be9c0e..5062023 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2509,9 +2509,6 @@ static int ab8500_charger_remove(struct platform_device *pdev)
 		free_irq(irq, di);
 	}
 
-	/* disable the regulator */
-	regulator_put(di->regu);
-
 	/* Backup battery voltage and current disable */
 	ret = abx500_mask_and_set_register_interruptible(di->dev,
 		AB8500_RTC, AB8500_RTC_CTRL_REG, RTC_BUP_CH_ENA, 0);
@@ -2665,7 +2662,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	 * is a charger connected to avoid erroneous BTEMP_HIGH/LOW
 	 * interrupts during charging
 	 */
-	di->regu = regulator_get(di->dev, "vddadc");
+	di->regu = devm_regulator_get(di->dev, "vddadc");
 	if (IS_ERR(di->regu)) {
 		ret = PTR_ERR(di->regu);
 		dev_err(di->dev, "failed to get vddadc regulator\n");
@@ -2677,14 +2674,14 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	ret = ab8500_charger_init_hw_registers(di);
 	if (ret) {
 		dev_err(di->dev, "failed to initialize ABB registers\n");
-		goto free_regulator;
+		goto free_charger_wq;
 	}
 
 	/* Register AC charger class */
 	ret = power_supply_register(di->dev, &di->ac_chg.psy);
 	if (ret) {
 		dev_err(di->dev, "failed to register AC charger\n");
-		goto free_regulator;
+		goto free_charger_wq;
 	}
 
 	/* Register USB charger class */
@@ -2758,8 +2755,6 @@ free_usb:
 	power_supply_unregister(&di->usb_chg.psy);
 free_ac:
 	power_supply_unregister(&di->ac_chg.psy);
-free_regulator:
-	regulator_put(di->regu);
 free_charger_wq:
 	destroy_workqueue(di->charger_wq);
 	return ret;
-- 
1.7.4.1

