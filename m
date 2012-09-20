Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2ITWFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:05:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51855 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2ITWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:05:04 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regulator: deprecate regulator-compatible DT property
Date: Thu, 20 Sep 2012 16:04:57 -0600
Message-Id: <1348178697-26314-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

When the bindings for the TPS6586x regulator were being proposed, I
asserted that DT node naming rules for bus child nodes should also be
applied to nodes inside the TPS6586x regulator node itself. In other
words, that each node providing regulator init data should be named
after the type of object it represented ("regulator") and hence that
some other property was required to indicate which regulator the node
described ("regulator-compatible"). In turn this led to multiple nodes
having the same name, thus requiring node names to use a unit address
to make them unique, thus requiring reg properties within the nodes and

However, subsequent discussion indicates that the rules I was asserting
only applies to standardized bus nodes, and within a device's own node,
the binding can basically do anything sane that it wants.

Hence, this change deprecates the register-compatible property, and
instead uses node names to replace this functionality. This greatly
simplifies the device tree content, making them smaller and more legible.

The code is changed such that old device trees continue to work.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Mark, if this gets into 3.7, I can fix up all the Tegra .dts files during 3.8.

 .../devicetree/bindings/regulator/max8907.txt      |   24 +++-----
 .../devicetree/bindings/regulator/regulator.txt    |    5 +-
 .../devicetree/bindings/regulator/tps65217.txt     |   31 ++-------
 .../devicetree/bindings/regulator/tps6586x.txt     |   66 ++++++--------------
 drivers/regulator/of_regulator.c                   |   25 ++++----
 5 files changed, 50 insertions(+), 101 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/max8907.txt b/Documentation/devicetree/bindings/regulator/max8907.txt
index 51e683b..371eccd 100644
--- a/Documentation/devicetree/bindings/regulator/max8907.txt
+++ b/Documentation/devicetree/bindings/regulator/max8907.txt
@@ -12,15 +12,16 @@ Required properties:
 ...
 - in20-supply: The input supply for LDO20.
 - regulators: A node that houses a sub-node for each regulator within the
-  device. Each sub-node is identified using the regulator-compatible
-  property, with valid values listed below. The content of each sub-node
-  is defined by the standard binding for regulators; see regulator.txt.
+  device. Each sub-node is identified using the node's name (or the deprecated
+  regulator-compatible property if present), with valid values listed below.
+  The content of each sub-node is defined by the standard binding for
+  regulators; see regulator.txt.
 
 Optional properties:
 - maxim,system-power-controller: Boolean property indicating that the PMIC
   controls the overall system power.
 
-Valid regulator-compatible values are:
+The valid names for regulators are:
 
   sd1, sd2, sd3, ldo1, ldo2, ldo3, ldo4, ldo5, ldo6, ldo7, ldo8, ldo9, ldo10,
   ldo11, ldo12, ldo13, ldo14, ldo15, ldo16, ldo17, ldo18, ldo19, ldo20, out5v,
@@ -42,30 +43,21 @@ Example:
 			...
 
 			regulators {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				mbatt_reg: regulator@0 {
-					reg = <0>;
-					regulator-compatible = "mbatt";
+				mbatt_reg: mbatt {
 					regulator-name = "vbat_pmu";
 					regulator-min-microvolt = <5000000>;
 					regulator-max-microvolt = <5000000>;
 					regulator-always-on;
 				};
 
-				regulator@1 {
-					reg = <1>;
-					regulator-compatible = "sd1";
+				sd1 {
 					regulator-name = "nvvdd_sv1,vdd_cpu_pmu";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
 				};
 
-				regulator@2 {
-					reg = <2>;
-					regulator-compatible = "sd2";
+				sd2 {
 					regulator-name = "nvvdd_sv2,vdd_core";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 66ece3f..ecfc6cc 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -11,10 +11,13 @@ Optional properties:
 - regulator-boot-on: bootloader/firmware enabled regulator
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
+
+Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
   regulators, and if the chip's binding contains a child node that
   describes each regulator, then this property indicates which regulator
-  this child node is intended to configure.
+  this child node is intended to configure. If this property is missing,
+  the node's name will be used instead.
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/regulator/tps65217.txt b/Documentation/devicetree/bindings/regulator/tps65217.txt
index 0487e96..d316fb8 100644
--- a/Documentation/devicetree/bindings/regulator/tps65217.txt
+++ b/Documentation/devicetree/bindings/regulator/tps65217.txt
@@ -22,66 +22,49 @@ Example:
 		compatible = "ti,tps65217";
 
 		regulators {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			dcdc1_reg: regulator@0 {
-				reg = <0>;
-				regulator-compatible = "dcdc1";
+			dcdc1_reg: dcdc1 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			dcdc2_reg: regulator@1 {
-				reg = <1>;
-				regulator-compatible = "dcdc2";
+			dcdc2_reg: dcdc2 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			dcdc3_reg: regulator@2 {
-				reg = <2>;
-				regulator-compatible = "dcdc3";
+			dcdc3_reg: dcc3 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo1_reg: regulator@3 {
-				reg = <3>;
-				regulator-compatible = "ldo1";
+			ldo1_reg: ldo1 {
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo2_reg: regulator@4 {
-				reg = <4>;
-				regulator-compatible = "ldo2";
+			ldo2_reg: ldo2 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo3_reg: regulator@5 {
-				reg = <5>;
-				regulator-compatible = "ldo3";
+			ldo3_reg: ldo3 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo4_reg: regulator@6 {
-				reg = <6>;
-				regulator-compatible = "ldo4";
+			ldo4_reg: ldo4 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
index 9b05e24..8b40cac 100644
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
+++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -6,8 +6,11 @@ Required properties:
 - interrupts: the interrupt outputs of the controller
 - #gpio-cells: number of cells to describe a GPIO
 - gpio-controller: mark the device as a GPIO controller
-- regulators: list of regulators provided by this controller, must have
-  property "regulator-compatible" to match their hardware counterparts:
+- regulators: A node that houses a sub-node for each regulator within the
+  device. Each sub-node is identified using the node's name (or the deprecated
+  regulator-compatible property if present), with valid values listed below.
+  The content of each sub-node is defined by the standard binding for
+  regulators; see regulator.txt.
   sys, sm[0-2], ldo[0-9] and ldo_rtc
 - sys-supply: The input supply for SYS.
 - vin-sm0-supply: The input supply for the SM0.
@@ -51,111 +54,80 @@ Example:
 		vinldo9-supply = <...>;
 
 		regulators {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			sys_reg: regulator@0 {
-				reg = <0>;
-				regulator-compatible = "sys";
+			sys_reg: sys {
 				regulator-name = "vdd_sys";
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm0_reg: regulator@1 {
-				reg = <1>;
-				regulator-compatible = "sm0";
+			sm0_reg: sm0 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm1_reg: regulator@2 {
-				reg = <2>;
-				regulator-compatible = "sm1";
+			sm1_reg: sm1 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm2_reg: regulator@3 {
-				reg = <3>;
-				regulator-compatible = "sm2";
+			sm2_reg: sm2 {
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <4550000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo0_reg: regulator@4 {
-				reg = <4>;
-				regulator-compatible = "ldo0";
+			ldo0_reg: ldo0 {
 				regulator-name = "PCIE CLK";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo1_reg: regulator@5 {
-				reg = <5>;
-				regulator-compatible = "ldo1";
+			ldo1_reg: ldo1 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo2_reg: regulator@6 {
-				reg = <6>;
-				regulator-compatible = "ldo2";
+			ldo2_reg: ldo2 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo3_reg: regulator@7 {
-				reg = <7>;
-				regulator-compatible = "ldo3";
+			ldo3_reg: ldo3 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo4_reg: regulator@8 {
-				reg = <8>;
-				regulator-compatible = "ldo4";
+			ldo4_reg: ldo4 {
 				regulator-min-microvolt = <1700000>;
 				regulator-max-microvolt = <2475000>;
 			};
 
-			ldo5_reg: regulator@9 {
-				reg = <9>;
-				regulator-compatible = "ldo5";
+			ldo5_reg: ldo5 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo6_reg: regulator@10 {
-				reg = <10>;
-				regulator-compatible = "ldo6";
+			ldo6_reg: ldo6 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo7_reg: regulator@11 {
-				reg = <11>;
-				regulator-compatible = "ldo7";
+			ldo7_reg: ldo7 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo8_reg: regulator@12 {
-				reg = <12>;
-				regulator-compatible = "ldo8";
+			ldo8_reg: ldo8 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo9_reg: regulator@13 {
-				reg = <13>;
-				regulator-compatible = "ldo9";
+			ldo9_reg: ldo9 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 3e4106f..6f68491 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -92,16 +92,18 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
 
 /**
- * of_regulator_match - extract regulator init data when node
- * property "regulator-compatible" matches with the regulator name.
+ * of_regulator_match - extract multiple regulator init data from device tree.
  * @dev: device requesting the data
  * @node: parent device node of the regulators
  * @matches: match table for the regulators
  * @num_matches: number of entries in match table
  *
- * This function uses a match table specified by the regulator driver and
- * looks up the corresponding init data in the device tree  if
- * regulator-compatible matches. Note that the match table is modified
+ * This function uses a match table specified by the regulator driver to
+ * parse regulator init data from the device tree. @node is expected to
+ * contain a set of child nodes, each providing the init data for one
+ * regulator. The data parsed from a child node will be matched to a regulator
+ * based on either the deprecated property regulator-compatible if present,
+ * or otherwise the child node's name. Note that the match table is modified
  * in place.
  *
  * Returns the number of matches found or a negative error code on failure.
@@ -112,26 +114,23 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 {
 	unsigned int count = 0;
 	unsigned int i;
-	const char *regulator_comp;
+	const char *name;
 	struct device_node *child;
 
 	if (!dev || !node)
 		return -EINVAL;
 
 	for_each_child_of_node(node, child) {
-		regulator_comp = of_get_property(child,
+		name = of_get_property(child,
 					"regulator-compatible", NULL);
-		if (!regulator_comp) {
-			dev_err(dev, "regulator-compatible is missing for node %s\n",
-				child->name);
-			continue;
-		}
+		if (!name)
+			name = child->name;
 		for (i = 0; i < num_matches; i++) {
 			struct of_regulator_match *match = &matches[i];
 			if (match->of_node)
 				continue;
 
-			if (strcmp(match->name, regulator_comp))
+			if (strcmp(match->name, name))
 				continue;
 
 			match->init_data =
-- 
1.7.0.4

