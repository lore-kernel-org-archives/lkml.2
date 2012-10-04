Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2JDDQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 23:16:06 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44594 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2JDDP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 23:15:58 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 5/6] power: da9052-battery: Convert to the new da9052 interrupt functions
Date: Thu,  4 Oct 2012 00:15:08 -0300
Message-Id: <1349320509-26930-5-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349320509-26930-1-git-send-email-festevam@gmail.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Convert to the new da9052 interrupt functions, so that we can get rid of 
irq_base references.

Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Build tested only.
 drivers/power/da9052-battery.c |   44 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index d9d034d..73cec97 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -440,8 +440,10 @@ static int da9052_bat_check_health(struct da9052_battery *bat, int *health)
 static irqreturn_t da9052_bat_irq(int irq, void *data)
 {
 	struct da9052_battery *bat = data;
+	int virq;
 
-	irq -= bat->da9052->irq_base;
+	virq = regmap_irq_get_virq(bat->da9052->irq_data, irq);
+	irq -= virq;
 
 	if (irq == DA9052_IRQ_CHGEND)
 		bat->status = POWER_SUPPLY_STATUS_FULL;
@@ -567,7 +569,7 @@ static struct power_supply template_battery = {
 	.get_property	= da9052_bat_get_property,
 };
 
-static const char *const da9052_bat_irqs[] = {
+static char *da9052_bat_irqs[] = {
 	"BATT TEMP",
 	"DCIN DET",
 	"DCIN REM",
@@ -576,12 +578,20 @@ static const char *const da9052_bat_irqs[] = {
 	"CHG END",
 };
 
+static int da9052_bat_irq_bits[] = {
+	DA9052_IRQ_TBAT,
+	DA9052_IRQ_DCIN,
+	DA9052_IRQ_DCINREM,
+	DA9052_IRQ_VBUS,
+	DA9052_IRQ_VBUSREM,
+	DA9052_IRQ_CHGEND,
+};
+
 static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
 {
 	struct da9052_pdata *pdata;
 	struct da9052_battery *bat;
 	int ret;
-	int irq;
 	int i;
 
 	bat = kzalloc(sizeof(struct da9052_battery), GFP_KERNEL);
@@ -602,15 +612,14 @@ static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
 		bat->psy.use_for_apm = 1;
 
 	for (i = 0; i < ARRAY_SIZE(da9052_bat_irqs); i++) {
-		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
-		ret = request_threaded_irq(bat->da9052->irq_base + irq,
-					   NULL, da9052_bat_irq,
-					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-					   da9052_bat_irqs[i], bat);
+		ret = da9052_request_irq(bat->da9052,
+				da9052_bat_irq_bits[i], da9052_bat_irqs[i],
+				da9052_bat_irq, bat);
+
 		if (ret != 0) {
 			dev_err(bat->da9052->dev,
-				"DA9052 failed to request %s IRQ %d: %d\n",
-				da9052_bat_irqs[i], irq, ret);
+				"DA9052 failed to request %s IRQ: %d\n",
+				da9052_bat_irqs[i], ret);
 			goto err;
 		}
 	}
@@ -623,23 +632,20 @@ static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	while (--i >= 0) {
-		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
-		free_irq(bat->da9052->irq_base + irq, bat);
-	}
+	while (--i >= 0)
+		da9052_free_irq(bat->da9052, da9052_bat_irq_bits[i], bat);
+
 	kfree(bat);
 	return ret;
 }
 static int __devexit da9052_bat_remove(struct platform_device *pdev)
 {
 	int i;
-	int irq;
 	struct da9052_battery *bat = platform_get_drvdata(pdev);
 
-	for (i = 0; i < ARRAY_SIZE(da9052_bat_irqs); i++) {
-		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
-		free_irq(bat->da9052->irq_base + irq, bat);
-	}
+	for (i = 0; i < ARRAY_SIZE(da9052_bat_irqs); i++)
+		da9052_free_irq(bat->da9052, da9052_bat_irq_bits[i], bat);
+
 	power_supply_unregister(&bat->psy);
 	kfree(bat);
 
-- 
1.7.9.5

