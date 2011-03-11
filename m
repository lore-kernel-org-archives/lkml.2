Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1CKP1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:27:25 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:47820 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab1CKP1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:27:24 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] regulator: switch the ab3100 to use enable_time()
Date: Fri, 11 Mar 2011 16:26:18 +0100
Message-ID: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This switches the ab3100 core to use the enable_time()
infrastructure from the regulator core.

Cc: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab3100.c |   51 ++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index ed6feaf..585e494 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -205,29 +205,6 @@ static int ab3100_enable_regulator(struct regulator_dev *reg)
 		return err;
 	}
 
-	/* Per-regulator power on delay from spec */
-	switch (abreg->regreg) {
-	case AB3100_LDO_A: /* Fallthrough */
-	case AB3100_LDO_C: /* Fallthrough */
-	case AB3100_LDO_D: /* Fallthrough */
-	case AB3100_LDO_E: /* Fallthrough */
-	case AB3100_LDO_H: /* Fallthrough */
-	case AB3100_LDO_K:
-		udelay(200);
-		break;
-	case AB3100_LDO_F:
-		udelay(600);
-		break;
-	case AB3100_LDO_G:
-		udelay(400);
-		break;
-	case AB3100_BUCK:
-		mdelay(1);
-		break;
-	default:
-		break;
-	}
-
 	return 0;
 }
 
@@ -449,11 +426,37 @@ static int ab3100_get_voltage_regulator_external(struct regulator_dev *reg)
 	return abreg->plfdata->external_voltage;
 }
 
+static int ab3100_enable_time_regulator(struct regulator_dev *reg)
+{
+	struct ab3100_regulator *abreg = reg->reg_data;
+
+	/* Per-regulator power on delay from spec */
+	switch (abreg->regreg) {
+	case AB3100_LDO_A: /* Fallthrough */
+	case AB3100_LDO_C: /* Fallthrough */
+	case AB3100_LDO_D: /* Fallthrough */
+	case AB3100_LDO_E: /* Fallthrough */
+	case AB3100_LDO_H: /* Fallthrough */
+	case AB3100_LDO_K:
+		return 200;
+	case AB3100_LDO_F:
+		return 600;
+	case AB3100_LDO_G:
+		return 400;
+	case AB3100_BUCK:
+		return 1000;
+	default:
+		break;
+	}
+	return 0;
+}
+
 static struct regulator_ops regulator_ops_fixed = {
 	.enable      = ab3100_enable_regulator,
 	.disable     = ab3100_disable_regulator,
 	.is_enabled  = ab3100_is_enabled_regulator,
 	.get_voltage = ab3100_get_voltage_regulator,
+	.enable_time = ab3100_enable_time_regulator,
 };
 
 static struct regulator_ops regulator_ops_variable = {
@@ -463,6 +466,7 @@ static struct regulator_ops regulator_ops_variable = {
 	.get_voltage = ab3100_get_voltage_regulator,
 	.set_voltage = ab3100_set_voltage_regulator,
 	.list_voltage = ab3100_list_voltage_regulator,
+	.enable_time = ab3100_enable_time_regulator,
 };
 
 static struct regulator_ops regulator_ops_variable_sleepable = {
@@ -473,6 +477,7 @@ static struct regulator_ops regulator_ops_variable_sleepable = {
 	.set_voltage = ab3100_set_voltage_regulator,
 	.set_suspend_voltage = ab3100_set_suspend_voltage_regulator,
 	.list_voltage = ab3100_list_voltage_regulator,
+	.enable_time = ab3100_enable_time_regulator,
 };
 
 /*
-- 
1.7.3.2

