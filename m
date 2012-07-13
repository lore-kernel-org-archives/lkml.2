Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2GMN7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:59:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17283 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab2GMN6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:58:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 13 Jul 2012 06:58:35 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <ccross@android.com>,
        <olof@lixom.net>, <swarren@wwwdotorg.org>, <lrg@ti.com>
CC: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: tps6586x: add support for input supply
Date: Fri, 13 Jul 2012 19:20:32 +0530
Message-ID: <1342187432-18668-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com>
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is multiple voltage input pins on device which
takes the voltage input for different voltage regulator.
Support to configure the voltage input supplied by
different regulator for each regulators.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../devicetree/bindings/regulator/tps6586x.txt     |   17 +++++++
 drivers/regulator/tps6586x-regulator.c             |   47 ++++++++++---------
 2 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
index ab17ef6..d156e1b 100644
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
+++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -9,6 +9,14 @@ Required properties:
 - regulators: list of regulators provided by this controller, must have
   property "regulator-compatible" to match their hardware counterparts:
   sm[0-2], ldo[0-9] and ldo_rtc
+- sm0-supply: The input supply for the SM0.
+- sm1-supply: The input supply for the SM1.
+- sm2-supply: The input supply for the SM2.
+- vinldo01-supply: The input supply for the LDO1 and LDO2
+- vinldo23-supply: The input supply for the LDO2 and LDO3
+- vinldo4-supply: The input supply for the LDO4
+- vinldo678-supply: The input supply for the LDO6, LDO7 and LDO8
+- vinldo9-supply: The input supply for the LDO9
 
 Each regulator is defined using the standard binding for regulators.
 
@@ -22,6 +30,15 @@ Example:
 		#gpio-cells = <2>;
 		gpio-controller;
 
+		sm0-supply = <&some_reg>;
+		sm1-supply = <&some_reg>;
+		sm2-supply = <&some_reg>;
+		vinldo01-supply = <...>;
+		vinldo23-supply = <...>;
+		vinldo4-supply = <...>;
+		vinldo678-supply = <...>;
+		vinldo9-supply = <...>;
+
 		regulators {
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index c0ac241..e6da90a 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -70,7 +70,7 @@ struct tps6586x_regulator {
 
 static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
 {
-	return rdev_get_dev(rdev)->parent->parent;
+	return rdev_get_dev(rdev)->parent;
 }
 
 static int tps6586x_set_voltage_sel(struct regulator_dev *rdev,
@@ -191,9 +191,10 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
 };
 
-#define TPS6586X_REGULATOR(_id, vdata, vreg, shift, nbits,		\
+#define TPS6586X_REGULATOR(_id, _pin_name, vdata, vreg, shift, nbits,	\
 			   ereg0, ebit0, ereg1, ebit1)			\
 	.desc	= {							\
+		.supply_name = _pin_name,				\
 		.name	= "REG-" #_id,					\
 		.ops	= &tps6586x_regulator_ops,			\
 		.type	= REGULATOR_VOLTAGE,				\
@@ -214,37 +215,39 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 	.go_reg = TPS6586X_##goreg,					\
 	.go_bit = (gobit),
 
-#define TPS6586X_LDO(_id, vdata, vreg, shift, nbits,			\
+#define TPS6586X_LDO(_id, _pname, vdata, vreg, shift, nbits,		\
 		     ereg0, ebit0, ereg1, ebit1)			\
 {									\
-	TPS6586X_REGULATOR(_id, vdata, vreg, shift, nbits,		\
+	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
 			   ereg0, ebit0, ereg1, ebit1)			\
 }
 
-#define TPS6586X_DVM(_id, vdata, vreg, shift, nbits,			\
+#define TPS6586X_DVM(_id, _pname, vdata, vreg, shift, nbits,		\
 		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
 {									\
-	TPS6586X_REGULATOR(_id, vdata, vreg, shift, nbits,		\
+	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
 			   ereg0, ebit0, ereg1, ebit1)			\
 	TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
 }
 
 static struct tps6586x_regulator tps6586x_regulator[] = {
-	TPS6586X_LDO(LDO_0, ldo0, SUPPLYV1, 5, 3, ENC, 0, END, 0),
-	TPS6586X_LDO(LDO_3, ldo, SUPPLYV4, 0, 3, ENC, 2, END, 2),
-	TPS6586X_LDO(LDO_5, ldo, SUPPLYV6, 0, 3, ENE, 6, ENE, 6),
-	TPS6586X_LDO(LDO_6, ldo, SUPPLYV3, 0, 3, ENC, 4, END, 4),
-	TPS6586X_LDO(LDO_7, ldo, SUPPLYV3, 3, 3, ENC, 5, END, 5),
-	TPS6586X_LDO(LDO_8, ldo, SUPPLYV2, 5, 3, ENC, 6, END, 6),
-	TPS6586X_LDO(LDO_9, ldo, SUPPLYV6, 3, 3, ENE, 7, ENE, 7),
-	TPS6586X_LDO(LDO_RTC, ldo, SUPPLYV4, 3, 3, V4, 7, V4, 7),
-	TPS6586X_LDO(LDO_1, dvm, SUPPLYV1, 0, 5, ENC, 1, END, 1),
-	TPS6586X_LDO(SM_2, sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
-
-	TPS6586X_DVM(LDO_2, dvm, LDO2BV1, 0, 5, ENA, 3, ENB, 3, VCC2, 6),
-	TPS6586X_DVM(LDO_4, ldo4, LDO4V1, 0, 5, ENC, 3, END, 3, VCC1, 6),
-	TPS6586X_DVM(SM_0, dvm, SM0V1, 0, 5, ENA, 1, ENB, 1, VCC1, 2),
-	TPS6586X_DVM(SM_1, dvm, SM1V1, 0, 5, ENA, 0, ENB, 0, VCC1, 0),
+	TPS6586X_LDO(LDO_0, "vinldo01", ldo0, SUPPLYV1, 5, 3, ENC, 0, END, 0),
+	TPS6586X_LDO(LDO_3, "vinldo23", ldo, SUPPLYV4, 0, 3, ENC, 2, END, 2),
+	TPS6586X_LDO(LDO_5, NULL, ldo, SUPPLYV6, 0, 3, ENE, 6, ENE, 6),
+	TPS6586X_LDO(LDO_6, "vinldo678", ldo, SUPPLYV3, 0, 3, ENC, 4, END, 4),
+	TPS6586X_LDO(LDO_7, "vinldo678", ldo, SUPPLYV3, 3, 3, ENC, 5, END, 5),
+	TPS6586X_LDO(LDO_8, "vinldo678", ldo, SUPPLYV2, 5, 3, ENC, 6, END, 6),
+	TPS6586X_LDO(LDO_9, "vinldo9", ldo, SUPPLYV6, 3, 3, ENE, 7, ENE, 7),
+	TPS6586X_LDO(LDO_RTC, NULL, ldo, SUPPLYV4, 3, 3, V4, 7, V4, 7),
+	TPS6586X_LDO(LDO_1, "vinldo01", dvm, SUPPLYV1, 0, 5, ENC, 1, END, 1),
+	TPS6586X_LDO(SM_2, "sm2", sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
+
+	TPS6586X_DVM(LDO_2, "vinldo23", dvm, LDO2BV1, 0, 5, ENA, 3,
+					ENB, 3, VCC2, 6),
+	TPS6586X_DVM(LDO_4, "vinldo4", ldo4, LDO4V1, 0, 5, ENC, 3,
+					END, 3, VCC1, 6),
+	TPS6586X_DVM(SM_0, "sm0", dvm, SM0V1, 0, 5, ENA, 1, ENB, 1, VCC1, 2),
+	TPS6586X_DVM(SM_1, "sm1", dvm, SM1V1, 0, 5, ENA, 0, ENB, 0, VCC1, 0),
 };
 
 /*
@@ -351,7 +354,7 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	config.dev = &pdev->dev;
+	config.dev = pdev->dev.parent;
 	config.of_node = pdev->dev.of_node;
 	config.init_data = pdev->dev.platform_data;
 	config.driver_data = ri;
-- 
1.7.1.1

