Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2DQSvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:51:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40598 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2DQSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:51:03 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] ARM: dt: tegra: seaboard: instantiate pinctrl-based I2C bus mux
Date: Tue, 17 Apr 2012 12:50:54 -0600
Message-Id: <1334688655-8509-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Tegra's I2C2 controller can be routed to either the PTA or DDC pin group
on Seaboard. Define the pinctrl state nodes required to allow runtime
control of this routing. Instantiate a pinctrl-i2cmux I2C bus mux that
uses these pinctrl states.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Ben, Wolfram, I'll take this one patch through the Tegra tree at an
appropriate time. I'm including it here to give a good example.
---
 arch/arm/boot/dts/tegra-seaboard.dts |   57 +++++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index ed0a2f5..e1025e2 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -65,11 +65,6 @@
 				nvidia,pins = "dap4";
 				nvidia,function = "dap4";
 			};
-			ddc {
-				nvidia,pins = "ddc", "owc", "spdi", "spdo",
-					"uac";
-				nvidia,function = "rsvd2";
-			};
 			dta {
 				nvidia,pins = "dta", "dtb", "dtc", "dtd", "dte";
 				nvidia,function = "vi";
@@ -100,7 +95,7 @@
 			};
 			hdint {
 				nvidia,pins = "hdint", "lpw0", "lpw2", "lsc1",
-					"lsck", "lsda", "pta";
+					"lsck", "lsda";
 				nvidia,function = "hdmi";
 			};
 			i2cp {
@@ -130,6 +125,10 @@
 					"lspi", "lvp1", "lvs";
 				nvidia,function = "displaya";
 			};
+			owc {
+				nvidia,pins = "owc", "spdi", "spdo", "uac";
+				nvidia,function = "rsvd2";
+			};
 			pmc {
 				nvidia,pins = "pmc";
 				nvidia,function = "pwr_on";
@@ -173,7 +172,7 @@
 			conf_ata {
 				nvidia,pins = "ata", "atb", "atc", "atd",
 					"cdev1", "cdev2", "dap1", "dap2",
-					"dap4", "dtf", "gma", "gmc", "gmd",
+					"dap4", "ddc", "dtf", "gma", "gmc", "gmd",
 					"gme", "gpu", "gpu7", "i2cp", "irrx",
 					"irtx", "pta", "rm", "sdc", "sdd",
 					"slxd", "slxk", "spdi", "spdo", "uac",
@@ -182,7 +181,7 @@
 				nvidia,tristate = <0>;
 			};
 			conf_ate {
-				nvidia,pins = "ate", "csus", "dap3", "ddc",
+				nvidia,pins = "ate", "csus", "dap3",
 					"gpv", "owc", "slxc", "spib", "spid",
 					"spie";
 				nvidia,pull = <0>;
@@ -252,6 +251,28 @@
 				nvidia,slew-rate-falling = <3>;
 			};
 		};
+
+		state_i2cmux_ddc: pinmux_i2cmux_ddc {
+			ddc {
+				nvidia,pins = "ddc";
+				nvidia,function = "i2c2";
+			};
+			pta {
+				nvidia,pins = "pta";
+				nvidia,function = "rsvd4";
+			};
+		};
+
+		state_i2cmux_pta: pinmux_i2cmux_pta {
+			ddc {
+				nvidia,pins = "ddc";
+				nvidia,function = "rsvd4";
+			};
+			pta {
+				nvidia,pins = "pta";
+				nvidia,function = "i2c2";
+			};
+		};
 	};
 
 	i2c@7000c000 {
@@ -276,6 +297,26 @@
 		clock-frequency = <400000>;
 	};
 
+	i2cmux {
+		compatible = "pinctrl-i2cmux";
+
+		i2c-parent = <&{/i2c@7000c400}>;
+
+		pinctrl-names = "ddc", "pta";
+		pinctrl-0 = <&state_i2cmux_ddc>;
+		pinctrl-1 = <&state_i2cmux_pta>;
+
+		i2c-bus-ddc {
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c-bus-pta {
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+	};
+
 	i2c@7000c500 {
 		clock-frequency = <400000>;
 	};
-- 
1.7.0.4

