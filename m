Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2IDDmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:42:47 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:30793
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154Ab2IDDmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:42:42 -0400
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
Subject: [PATCH v5 3/4] regulator: anatop-regulator: convert to use syscon to access anatop register
Date: Tue, 4 Sep 2012 11:20:10 +0800
Message-ID: <1346728811-25788-4-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346728811-25788-1-git-send-email-b29396@freescale.com>
References: <1346728811-25788-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Using syscon to access anatop register.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog v4->v5:
 * merge patch 3,4,5,6 to avoid break bisect.
ChangeLog v2->v3:
 * update to use syscon_node_to_regmap and use of_get_parent to get anatop node.
ChangeLog v1-v2:
 * update to use generic regmap api
---
 arch/arm/boot/dts/imx6q.dtsi         |    4 +-
 arch/arm/mach-imx/Kconfig            |    2 +-
 arch/arm/mach-imx/mach-imx6q.c       |   47 +++++++++++++---------------------
 drivers/regulator/Kconfig            |    2 +-
 drivers/regulator/anatop-regulator.c |   30 ++++++++++++++-------
 5 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index bea21bc..52ed4d1 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -378,8 +378,8 @@
 				interrupts = <0 87 0x04 0 88 0x04>;
 			};
 
-			anatop@020c8000 {
-				compatible = "fsl,imx6q-anatop";
+			anatop: anatop@020c8000 {
+				compatible = "fsl,imx6q-anatop", "syscon", "simple-bus";
 				reg = <0x020c8000 0x1000>;
 				interrupts = <0 49 0x04 0 54 0x04 0 127 0x04>;
 
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index afd542a..7bba253 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -839,7 +839,7 @@ config SOC_IMX6Q
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
 	select HAVE_SMP
-	select MFD_ANATOP
+	select MFD_SYSCON
 	select PINCTRL
 	select PINCTRL_IMX6Q
 
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 045b3f6..eaf56b4 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -24,8 +24,9 @@
 #include <linux/of_platform.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/phy.h>
+#include <linux/regmap.h>
 #include <linux/micrel_phy.h>
-#include <linux/mfd/anatop.h>
+#include <linux/mfd/syscon.h>
 #include <asm/cpuidle.h>
 #include <asm/smp_twd.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -120,20 +121,7 @@ static void __init imx6q_sabrelite_init(void)
 
 static void __init imx6q_usb_init(void)
 {
-	struct device_node *np;
-	struct platform_device *pdev = NULL;
-	struct anatop *adata = NULL;
-
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
-	if (np)
-		pdev = of_find_device_by_node(np);
-	if (pdev)
-		adata = platform_get_drvdata(pdev);
-	if (!adata) {
-		if (np)
-			of_node_put(np);
-		return;
-	}
+	struct regmap *anatop;
 
 #define HW_ANADIG_USB1_CHRG_DETECT		0x000001b0
 #define HW_ANADIG_USB2_CHRG_DETECT		0x00000210
@@ -141,20 +129,21 @@ static void __init imx6q_usb_init(void)
 #define BM_ANADIG_USB_CHRG_DETECT_EN_B		0x00100000
 #define BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B	0x00080000
 
-	/*
-	 * The external charger detector needs to be disabled,
-	 * or the signal at DP will be poor
-	 */
-	anatop_write_reg(adata, HW_ANADIG_USB1_CHRG_DETECT,
-			BM_ANADIG_USB_CHRG_DETECT_EN_B
-			| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
-			~0);
-	anatop_write_reg(adata, HW_ANADIG_USB2_CHRG_DETECT,
-			BM_ANADIG_USB_CHRG_DETECT_EN_B |
-			BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
-			~0);
-
-	of_node_put(np);
+	anatop = syscon_regmap_lookup_by_compatible("fsl,imx6q-anatop");
+	if (!IS_ERR(anatop)) {
+		/*
+		 * The external charger detector needs to be disabled,
+		 * or the signal at DP will be poor
+		 */
+		regmap_write(anatop, HW_ANADIG_USB1_CHRG_DETECT,
+				BM_ANADIG_USB_CHRG_DETECT_EN_B
+				| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
+		regmap_write(anatop, HW_ANADIG_USB2_CHRG_DETECT,
+				BM_ANADIG_USB_CHRG_DETECT_EN_B |
+				BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
+	} else {
+		pr_warn("failed to find fsl,imx6q-anatop regmap\n");
+	}
 }
 
 static void __init imx6q_init_machine(void)
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
index ce0fe72..346e5f6 100644
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
@@ -43,7 +44,8 @@ struct anatop_regulator {
 	struct regulator_init_data *initdata;
 };
 
-static int anatop_set_voltage_sel(struct regulator_dev *reg, unsigned selector)
+static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
+					unsigned selector)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
 	u32 val, mask;
@@ -56,12 +58,13 @@ static int anatop_set_voltage_sel(struct regulator_dev *reg, unsigned selector)
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
@@ -69,7 +72,7 @@ static int anatop_get_voltage_sel(struct regulator_dev *reg)
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
-	val = anatop_read_reg(anatop_reg->mfd, anatop_reg->control_reg);
+	regmap_read(anatop_reg->anatop, anatop_reg->control_reg, &val);
 	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
 		anatop_reg->vol_bit_shift;
 	val = (val & mask) >> anatop_reg->vol_bit_shift;
@@ -78,8 +81,8 @@ static int anatop_get_voltage_sel(struct regulator_dev *reg)
 }
 
 static struct regulator_ops anatop_rops = {
-	.set_voltage_sel = anatop_set_voltage_sel,
-	.get_voltage_sel = anatop_get_voltage_sel,
+	.set_voltage_sel = anatop_regmap_set_voltage_sel,
+	.get_voltage_sel = anatop_regmap_get_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 };
@@ -88,11 +91,11 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
+	struct device_node *anatop_np;
 	struct regulator_desc *rdesc;
 	struct regulator_dev *rdev;
 	struct anatop_regulator *sreg;
 	struct regulator_init_data *initdata;
-	struct anatop *anatopmfd = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	int ret = 0;
 
@@ -109,7 +112,14 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
 	rdesc->ops = &anatop_rops;
 	rdesc->type = REGULATOR_VOLTAGE;
 	rdesc->owner = THIS_MODULE;
-	sreg->mfd = anatopmfd;
+
+	anatop_np = of_get_parent(np);
+	if (!anatop_np)
+		return -ENODEV;
+	sreg->anatop = syscon_node_to_regmap(anatop_np);
+	if (IS_ERR(sreg->anatop))
+		return PTR_ERR(sreg->anatop);
+
 	ret = of_property_read_u32(np, "anatop-reg-offset",
 				   &sreg->control_reg);
 	if (ret) {
-- 
1.7.0.4


