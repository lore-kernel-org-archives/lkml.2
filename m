Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1GKB5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 21:57:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45129 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1GKB5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 21:57:50 -0400
Subject: [PATCH] regulator: tps65910: Fix array access out of bounds bug
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 09:57:43 +0800
Message-ID: <1310349463.2316.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For tps65910, the number of regulator is 13. ( ARRAY_SIZE(tps65910_regs) is 13)
For tps65911, the number of regulator is 12. ( ARRAY_SIZE(tps65911_regs) is 12)
If we are using this driver for tps65911,
we hit array access out of bounds bug in tps65910_probe() because
current implementation always assume the number of regulator is 13 and
thus it will access tps65911_regs[12].

Fix it by setting correct num_regulators for both chips in tps65910_probe(),
and allocated neccessay memory accordingly.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
hi Graeme, Jorge,
I don't have this hardware and cannot test it.
I appreciate if you can help to test this patch.

Regards,
Axel

 drivers/regulator/tps65910-regulator.c |   55 +++++++++++++++++++++++++-------
 1 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 8e0edab..66d2d60 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -49,7 +49,6 @@
 #define TPS65911_REG_LDO7		11
 #define TPS65911_REG_LDO8		12
 
-#define TPS65910_NUM_REGULATOR		13
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
 
 /* supported VIO voltages in milivolts */
@@ -264,11 +263,12 @@ static struct tps_info tps65911_regs[] = {
 };
 
 struct tps65910_reg {
-	struct regulator_desc desc[TPS65910_NUM_REGULATOR];
+	struct regulator_desc *desc;
 	struct tps65910 *mfd;
-	struct regulator_dev *rdev[TPS65910_NUM_REGULATOR];
-	struct tps_info *info[TPS65910_NUM_REGULATOR];
+	struct regulator_dev **rdev;
+	struct tps_info **info;
 	struct mutex mutex;
+	int num_regulators;
 	int mode;
 	int  (*get_ctrl_reg)(int);
 };
@@ -902,10 +902,12 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	switch(tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
+		pmic->num_regulators = ARRAY_SIZE(tps65910_regs);
 		info = tps65910_regs;
 		break;
 	case TPS65911:
 		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
+		pmic->num_regulators = ARRAY_SIZE(tps65911_regs);
 		info = tps65911_regs;
 		break;
 	default:
@@ -914,7 +916,28 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	for (i = 0; i < TPS65910_NUM_REGULATOR; i++, info++, reg_data++) {
+	pmic->desc = kcalloc(pmic->num_regulators,
+			sizeof(struct regulator_desc), GFP_KERNEL);
+	if (!pmic->desc) {
+		err = -ENOMEM;
+		goto err_free_pmic;
+	}
+
+	pmic->info = kcalloc(pmic->num_regulators,
+			sizeof(struct tps_info *), GFP_KERNEL);
+	if (!pmic->info) {
+		err = -ENOMEM;
+		goto err_free_desc;
+	}
+
+	pmic->rdev = kcalloc(pmic->num_regulators,
+			sizeof(struct regulator_dev *), GFP_KERNEL);
+	if (!pmic->rdev) {
+		err = -ENOMEM;
+		goto err_free_info;
+	}
+
+	for (i = 0; i < pmic->num_regulators; i++, info++, reg_data++) {
 		/* Register the regulators */
 		pmic->info[i] = info;
 
@@ -946,7 +969,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 				"failed to register %s regulator\n",
 				pdev->name);
 			err = PTR_ERR(rdev);
-			goto err;
+			goto err_unregister_regulator;
 		}
 
 		/* Save regulator for cleanup */
@@ -954,23 +977,31 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	}
 	return 0;
 
-err:
+err_unregister_regulator:
 	while (--i >= 0)
 		regulator_unregister(pmic->rdev[i]);
-
+	kfree(pmic->rdev);
+err_free_info:
+	kfree(pmic->info);
+err_free_desc:
+	kfree(pmic->desc);
+err_free_pmic:
 	kfree(pmic);
 	return err;
 }
 
 static int __devexit tps65910_remove(struct platform_device *pdev)
 {
-	struct tps65910_reg *tps65910_reg = platform_get_drvdata(pdev);
+	struct tps65910_reg *pmic = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < TPS65910_NUM_REGULATOR; i++)
-		regulator_unregister(tps65910_reg->rdev[i]);
+	for (i = 0; i < pmic->num_regulators; i++)
+		regulator_unregister(pmic->rdev[i]);
 
-	kfree(tps65910_reg);
+	kfree(pmic->rdev);
+	kfree(pmic->info);
+	kfree(pmic->desc);
+	kfree(pmic);
 	return 0;
 }
 
-- 
1.7.4.1



