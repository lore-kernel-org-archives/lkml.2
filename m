Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2KINFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:05:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2KINEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:04:54 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: tegra: tamonten: Add DDC/PTA pinmux
Date: Fri,  9 Nov 2012 14:04:50 +0100
Message-Id: <1352466291-27333-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:TenjQ+St8eSjjeJP/u8+pbBMkO+ccB5aV3PIAU+mN4m
 ooUBowfvt/YQf2FF64/6HxVADXuxgnOp31Sq/J1Wigg5eC0TXe
 NijNBfPzPZIRA+QmvSVSGrt9XXhQU/Npv6IwNzRLv2axpp3gkl
 cHeQJLB+RP3Jl8lgU+zmu2jznWfbYtMGr7zYeK9UGrKjToydrk
 BO4T6fbkIGVw9bLljCLOx/e1SpVNAcJ0/R4pJNh5Zo6incmkLV
 k06Inbm0LeATHpHMUYhry5yw+0w7NnTrDig56PhSg/uvrNFmzK
 9VBecfuKnlH78dSefQrjeTRvRN0ZZPiJ1FfnA0zCjgSs2rmphl
 CIsYRIIVltmr+Y1zwVprle5LvioQmz88O5+I40qjEGQXXEnUAe
 PtjwWTdZPHVUoZebsf+ZZYMmtLkF20wkqMcio+1hhYTXhONYMW
 rRnsP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit allows the I2C2 controller on Tegra20 to be routed either to
the DDC or the PTA pin group at runtime. On Tamonten this allows the I2C
bus to be used for the DDC of the HDMI connector or to access I2C chips
on the carrier board.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-tamonten.dtsi | 69 ++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 5b3d8b1..c3540e0 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -62,10 +62,6 @@
 				nvidia,pins = "dap4";
 				nvidia,function = "dap4";
 			};
-			ddc {
-				nvidia,pins = "ddc";
-				nvidia,function = "i2c2";
-			};
 			dta {
 				nvidia,pins = "dta", "dtd";
 				nvidia,function = "sdio2";
@@ -91,7 +87,7 @@
 				nvidia,function = "pcie";
 			};
 			hdint {
-				nvidia,pins = "hdint", "pta";
+				nvidia,pins = "hdint";
 				nvidia,function = "hdmi";
 			};
 			i2cp {
@@ -230,6 +226,39 @@
 				nvidia,pull = <1>;
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
+
+		state_i2cmux_idle: pinmux_i2cmux_idle {
+			ddc {
+				nvidia,pins = "ddc";
+				nvidia,function = "rsvd4";
+			};
+			pta {
+				nvidia,pins = "pta";
+				nvidia,function = "rsvd4";
+			};
+		};
 	};
 
 	i2s@70002800 {
@@ -246,6 +275,36 @@
 		status = "okay";
 	};
 
+	i2c@7000c400 {
+		clock-frequency = <100000>;
+		status = "okay";
+	};
+
+	i2cmux {
+		compatible = "i2c-mux-pinctrl";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@7000c400}>;
+
+		pinctrl-names = "ddc", "pta", "idle";
+		pinctrl-0 = <&state_i2cmux_ddc>;
+		pinctrl-1 = <&state_i2cmux_pta>;
+		pinctrl-2 = <&state_i2cmux_idle>;
+
+		i2c@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c@1 {
+			reg = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+	};
+
 	i2c@7000d000 {
 		clock-frequency = <400000>;
 		status = "okay";
-- 
1.8.0

