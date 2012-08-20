Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2HTQls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:41:48 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:34554 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab2HTQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:41:45 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@gmail.com>
Subject: [PATCH v2] regulator: ab8500: provide per-regulator shift
Date: Mon, 20 Aug 2012 18:41:35 +0200
Message-ID: <1345480895-18278-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This encodes the voltage shifts (the number of bits to shift
the register to get to the selector) into the regulator info.
We have several new variants of the AB8500 so this varies a
lot.

Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab8500.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8807166..812611f 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -37,6 +37,7 @@
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
+ * @voltage_shift: shift to control regulator voltage
  * @delay: startup/set voltage delay in us
  */
 struct ab8500_regulator_info {
@@ -50,6 +51,7 @@ struct ab8500_regulator_info {
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
+	u8 voltage_shift;
 	unsigned int delay;
 };
 
@@ -195,17 +197,14 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
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
@@ -221,7 +220,7 @@ static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	}
 
 	/* set the registers for the request */
-	regval = (u8)selector;
+	regval = (u8)selector << info->voltage_shift;
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 			info->voltage_bank, info->voltage_reg,
 			info->voltage_mask, regval);
@@ -349,6 +348,7 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
+		.voltage_shift		= 3,
 	},
 
 	/*
-- 
1.7.11.3

