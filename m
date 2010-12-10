Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0LJKLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:11:17 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:50697 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271Ab0LJKLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:11:10 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 8/9] regulators: Removed macros for initialization of ab8500 regulators
Date: Fri, 10 Dec 2010 11:08:47 +0100
Message-ID: <1291975728-12525-9-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the macros for initializing the regulators.
The purpose is to remove one layer of abstraction and make the
code easier to read.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500.c |  241 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 179 insertions(+), 62 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 7d372b8..d9a052c 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -311,7 +311,7 @@ static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
 	return info->fixed_uV;
 }
 
-static struct regulator_ops ab8500_ldo_fixed_ops = {
+static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
 	.is_enabled	= ab8500_regulator_is_enabled,
@@ -319,79 +319,196 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 	.list_voltage	= ab8500_list_voltage,
 };
 
-#define AB8500_LDO(_id, _min_mV, _max_mV,			\
-	_u_bank, _u_reg, _u_mask, _u_val_enable,		\
-	_v_bank, _v_reg, _v_mask, _v_table, _v_table_len)	\
-[AB8500_LDO_##_id] = {						\
-	.desc	= {						\
-		.name		= "LDO-" #_id,			\
-		.ops		= &ab8500_regulator_ops,	\
-		.type		= REGULATOR_VOLTAGE,		\
-		.id		= AB8500_LDO_##_id,		\
-		.owner		= THIS_MODULE,			\
-	},							\
-	.min_uV			= (_min_mV) * 1000,		\
-	.max_uV			= (_max_mV) * 1000,		\
-	.update_bank		= _u_bank,			\
-	.update_reg		= _u_reg,			\
-	.update_mask		= _u_mask,			\
-	.update_val_enable	= _u_val_enable,		\
-	.voltage_bank		= _v_bank,			\
-	.voltage_reg		= _v_reg,			\
-	.voltage_mask		= _v_mask,			\
-	.voltages		= _v_table,			\
-	.voltages_len		= _v_table_len,			\
-	.fixed_uV		= 0,				\
-}
-
-#define AB8500_FIXED_LDO(_id, _fixed_mV,			\
-	_u_bank, _u_reg, _u_mask, _u_val_enable)		\
-[AB8500_LDO_##_id] = {						\
-	.desc	= {						\
-		.name		= "LDO-" #_id,			\
-		.ops		= &ab8500_ldo_fixed_ops,	\
-		.type		= REGULATOR_VOLTAGE,		\
-		.id		= AB8500_LDO_##_id,		\
-		.owner		= THIS_MODULE,			\
-	},							\
-	.fixed_uV		= (_fixed_mV) * 1000,		\
-	.update_bank		= _u_bank,			\
-	.update_reg		= _u_reg,			\
-	.update_mask		= _u_mask,			\
-	.update_val_enable	= _u_val_enable,		\
-}
-
-static struct ab8500_regulator_info ab8500_regulator_info[] = {
+static struct ab8500_regulator_info
+		ab8500_regulator_info[AB8500_NUM_REGULATORS] = {
 	/*
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
 	 *   volt bank, reg, mask, table, table length
 	 */
-	AB8500_LDO(AUX1, 1100, 3300,
-		0x04, 0x09, 0x03, 0x01, 0x04, 0x1f, 0x0f,
-		ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX2, 1100, 3300,
-		0x04, 0x09, 0x0c, 0x04, 0x04, 0x20, 0x0f,
-		ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX3, 1100, 3300,
-		0x04, 0x0a, 0x03, 0x01, 0x04, 0x21, 0x07,
-		ldo_vaux3_voltages, ARRAY_SIZE(ldo_vaux3_voltages)),
-	AB8500_LDO(INTCORE, 1100, 3300,
-		0x03, 0x80, 0x44, 0x04, 0x03, 0x80, 0x38,
-		ldo_vintcore_voltages, ARRAY_SIZE(ldo_vintcore_voltages)),
+	[AB8500_LDO_AUX1] = {
+		.desc = {
+			.name		= "LDO-AUX1",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x09,
+		.update_mask		= 0x03,
+		.update_val_enable	= 0x01,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x1f,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB8500_LDO_AUX2] = {
+		.desc = {
+			.name		= "LDO-AUX2",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x09,
+		.update_mask		= 0x0c,
+		.update_val_enable	= 0x04,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x20,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB8500_LDO_AUX3] = {
+		.desc = {
+			.name		= "LDO-AUX3",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX3,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x0a,
+		.update_mask		= 0x03,
+		.update_val_enable	= 0x01,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x21,
+		.voltage_mask		= 0x07,
+		.voltages		= ldo_vaux3_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
+	},
+	[AB8500_LDO_INTCORE] = {
+		.desc = {
+			.name		= "LDO-INTCORE",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_INTCORE,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x80,
+		.update_mask		= 0x44,
+		.update_val_enable	= 0x04,
+		.voltage_bank		= 0x03,
+		.voltage_reg		= 0x80,
+		.voltage_mask		= 0x38,
+		.voltages		= ldo_vintcore_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
+	},
 
 	/*
 	 * Fixed Voltage Regulators
 	 *   name, fixed mV,
 	 *   update bank, reg, mask, enable val
 	 */
-	AB8500_FIXED_LDO(TVOUT,	  2000, 0x03, 0x80, 0x82, 0x02),
-	AB8500_FIXED_LDO(AUDIO,   2000, 0x03, 0x83, 0x02, 0x02),
-	AB8500_FIXED_LDO(ANAMIC1, 2050, 0x03, 0x83, 0x08, 0x08),
-	AB8500_FIXED_LDO(ANAMIC2, 2050, 0x03, 0x83, 0x10, 0x10),
-	AB8500_FIXED_LDO(DMIC,    1800, 0x03, 0x83, 0x04, 0x04),
-	AB8500_FIXED_LDO(ANA,     1200, 0x04, 0x06, 0x0c, 0x04),
+	[AB8500_LDO_TVOUT] = {
+		.desc = {
+			.name		= "LDO-TVOUT",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_TVOUT,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2000000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x80,
+		.update_mask		= 0x82,
+		.update_val_enable	= 0x02,
+	},
+	[AB8500_LDO_AUDIO] = {
+		.desc = {
+			.name		= "LDO-AUDIO",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUDIO,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2000000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x02,
+		.update_val_enable	= 0x02,
+	},
+	[AB8500_LDO_ANAMIC1] = {
+		.desc = {
+			.name		= "LDO-ANAMIC1",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2050000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x08,
+		.update_val_enable	= 0x08,
+	},
+	[AB8500_LDO_ANAMIC2] = {
+		.desc = {
+			.name		= "LDO-ANAMIC2",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2050000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x10,
+		.update_val_enable	= 0x10,
+	},
+	[AB8500_LDO_DMIC] = {
+		.desc = {
+			.name		= "LDO-DMIC",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_DMIC,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1800000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x04,
+		.update_val_enable	= 0x04,
+	},
+	[AB8500_LDO_ANA] = {
+		.desc = {
+			.name		= "LDO-ANA",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANA,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1200000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x06,
+		.update_mask		= 0x0c,
+		.update_val_enable	= 0x04,
+	},
+
+
 };
 
 static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
-- 
1.7.2.2

