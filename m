Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2HTMS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:18:59 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:54760 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab2HTMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:18:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@gmail.com>
Subject: [PATCH] regulator: ab8500: fix voltage selector regression
Date: Mon, 20 Aug 2012 14:18:17 +0200
Message-ID: <1345465097-31576-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Commit 3bf6e90e476fb34ca47b6dda270f41d9cebcb1ac
"regulator: Convert ab8499 to use get_voltage_sel()"
and commit ae713d394d9e2aacaab620acd3212855f1f06b00
"regulator: Convert ab8500 to set_voltage_sel"
corrupted the voltage selector mechanism is two ways:

The function for getting the selector stopped respecting
the bit shift to get the selector out, and the function
for setting the selector hacked in a non-generic kludge
that does not scale. Besides, the regulator info struct
for the AB8500 already contains the proper shift values.

This sanitize the code so it works as expected again.

Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab8500.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8807166..c659127 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -195,17 +195,14 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 	}
 
 	dev_vdbg(rdev_get_dev(rdev),
-		"%s-get_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
-		" 0x%x\n",
-		info->desc.name, info->voltage_bank, info->voltage_reg,
-		info->voltage_mask, regval);
+		"%s-get_voltage (bank, reg, mask, shift, value): "
+		"0x%x, 0x%x, 0x%x, 0x%x, 0x%x\n",
+		info->desc.name, info->voltage_bank,
+		info->voltage_reg, info->voltage_mask,
+		info->voltage_shift, regval);
 
-	/* vintcore has a different layout */
 	val = regval & info->voltage_mask;
-	if (info->desc.id == AB8500_LDO_INTCORE)
-		return val >> 0x3;
-	else
-		return val;
+	return val >> info->voltage_shift;
 }
 
 static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
@@ -221,7 +218,7 @@ static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	}
 
 	/* set the registers for the request */
-	regval = (u8)selector;
+	regval = (u8)selector << info->voltage_shift;
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 			info->voltage_bank, info->voltage_reg,
 			info->voltage_mask, regval);
-- 
1.7.11.3

