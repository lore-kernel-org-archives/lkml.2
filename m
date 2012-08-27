Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2H0HpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:45:25 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:42659
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525Ab2H0HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:45:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah107ah1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: [PATCH v2 4/7] regulator: anatop-regulator: convert to use syscon to access anatop register
Date: Mon, 27 Aug 2012 15:24:42 +0800
Message-ID: <1346052285-4344-5-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346052285-4344-1-git-send-email-b29396@freescale.com>
References: <1346052285-4344-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Using syscon to access anatop register.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog v1-v2:
 * update to use generic regmap api
---
 arch/arm/boot/dts/imx6q.dtsi         |    6 ++++++
 drivers/regulator/Kconfig            |    2 +-
 drivers/regulator/anatop-regulator.c |   25 +++++++++++++++----------
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index db3fa15..da2bb71 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -395,6 +395,7 @@
 					anatop-min-bit-val = <4>;
 					anatop-min-voltage = <800000>;
 					anatop-max-voltage = <1375000>;
+					fsl,anatop = <&anatop>;
 				};
 
 				regulator-3p0@120 {
@@ -409,6 +410,7 @@
 					anatop-min-bit-val = <0>;
 					anatop-min-voltage = <2625000>;
 					anatop-max-voltage = <3400000>;
+					fsl,anatop = <&anatop>;
 				};
 
 				regulator-2p5@130 {
@@ -423,6 +425,7 @@
 					anatop-min-bit-val = <0>;
 					anatop-min-voltage = <2000000>;
 					anatop-max-voltage = <2750000>;
+					fsl,anatop = <&anatop>;
 				};
 
 				regulator-vddcore@140 {
@@ -437,6 +440,7 @@
 					anatop-min-bit-val = <1>;
 					anatop-min-voltage = <725000>;
 					anatop-max-voltage = <1450000>;
+					fsl,anatop = <&anatop>;
 				};
 
 				regulator-vddpu@140 {
@@ -451,6 +455,7 @@
 					anatop-min-bit-val = <1>;
 					anatop-min-voltage = <725000>;
 					anatop-max-voltage = <1450000>;
+					fsl,anatop = <&anatop>;
 				};
 
 				regulator-vddsoc@140 {
@@ -465,6 +470,7 @@
 					anatop-min-bit-val = <1>;
 					anatop-min-voltage = <725000>;
 					anatop-max-voltage = <1450000>;
+					fsl,anatop = <&anatop>;
 				};
 			};
 
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 4e932cc..2ae1d97 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -112,7 +112,7 @@ config REGULATOR_DA9052
 
 config REGULATOR_ANATOP
 	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
-	depends on MFD_ANATOP
+	depends on MFD_SYSCON
 	help
 	  Say y here to support Freescale i.MX on-chip ANATOP LDOs
 	  regulators. It is recommended that this option be
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index ce0fe72..71586a7 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -21,19 +21,20 @@
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/mfd/syscon.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/mfd/anatop.h>
+#include <linux/regmap.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 
 struct anatop_regulator {
 	const char *name;
 	u32 control_reg;
-	struct anatop *mfd;
+	struct regmap *anatop;
 	int vol_bit_shift;
 	int vol_bit_width;
 	int min_bit_val;
@@ -43,7 +44,7 @@ struct anatop_regulator {
 	struct regulator_init_data *initdata;
 };
 
-static int anatop_set_voltage_sel(struct regulator_dev *reg, unsigned selector)
+static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg, unsigned selector)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
 	u32 val, mask;
@@ -56,12 +57,13 @@ static int anatop_set_voltage_sel(struct regulator_dev *reg, unsigned selector)
 	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
 		anatop_reg->vol_bit_shift;
 	val <<= anatop_reg->vol_bit_shift;
-	anatop_write_reg(anatop_reg->mfd, anatop_reg->control_reg, val, mask);
+	regmap_update_bits(anatop_reg->anatop, anatop_reg->control_reg,
+				mask, val);
 
 	return 0;
 }
 
-static int anatop_get_voltage_sel(struct regulator_dev *reg)
+static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
 	u32 val, mask;
@@ -69,7 +71,7 @@ static int anatop_get_voltage_sel(struct regulator_dev *reg)
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
-	val = anatop_read_reg(anatop_reg->mfd, anatop_reg->control_reg);
+	regmap_read(anatop_reg->anatop, anatop_reg->control_reg, &val);
 	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
 		anatop_reg->vol_bit_shift;
 	val = (val & mask) >> anatop_reg->vol_bit_shift;
@@ -78,8 +80,8 @@ static int anatop_get_voltage_sel(struct regulator_dev *reg)
 }
 
 static struct regulator_ops anatop_rops = {
-	.set_voltage_sel = anatop_set_voltage_sel,
-	.get_voltage_sel = anatop_get_voltage_sel,
+	.set_voltage_sel = anatop_regmap_set_voltage_sel,
+	.get_voltage_sel = anatop_regmap_get_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 };
@@ -92,7 +94,6 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	struct anatop_regulator *sreg;
 	struct regulator_init_data *initdata;
-	struct anatop *anatopmfd = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	int ret = 0;
 
@@ -109,7 +110,11 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
 	rdesc->ops = &anatop_rops;
 	rdesc->type = REGULATOR_VOLTAGE;
 	rdesc->owner = THIS_MODULE;
-	sreg->mfd = anatopmfd;
+
+	sreg->anatop = syscon_regmap_lookup_by_phandle(np, "fsl,anatop");
+	if (IS_ERR(sreg->anatop))
+		return PTR_ERR(sreg->anatop);
+
 	ret = of_property_read_u32(np, "anatop-reg-offset",
 				   &sreg->control_reg);
 	if (ret) {
-- 
1.7.0.4


