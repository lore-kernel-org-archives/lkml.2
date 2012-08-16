Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2HPGIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:08:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16951 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2HPGIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:08:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 15 Aug 2012 23:08:00 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 3/3] tegra: add pwm backlight device tree nodes
Date: Thu, 16 Aug 2012 15:08:57 +0900
Message-ID: <1345097337-24170-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts | 58 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi        |  2 +-
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index be90544..b253697 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -317,6 +317,64 @@
 		bus-width = <8>;
 	};
 
+	backlight {
+		compatible = "pwm-backlight";
+		brightness-levels = <0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 255>;
+		default-brightness-level = <12>;
+
+		/* resources used by the power sequences */
+		pwms = <&pwm 2 5000000>;
+		pwm-names = "backlight";
+		power-supply = <&backlight_reg>;
+		enable-gpio = <&gpio 28 0>;
+
+		power-on-sequence {
+			step0 {
+				regulator = "power";
+				enable;
+			};
+			step1 {
+				delay = <10000>;
+			};
+			step2 {
+				pwm = "backlight";
+				enable;
+			};
+			step3 {
+				gpio = "enable";
+				enable;
+			};
+		};
+		power-off-sequence {
+			step0 {
+				gpio = "enable";
+				disable;
+			};
+			step1 {
+				pwm = "backlight";
+				disable;
+			};
+			step2 {
+				delay = <10000>;
+			};
+			step3 {
+				regulator = "power";
+				disable;
+			};
+		};
+	};
+
+	backlight_reg: fixedregulator@176 {
+		compatible = "regulator-fixed";
+		regulator-name = "backlight_regulator";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		gpio = <&gpio 176 0>;
+		startup-delay-us = <0>;
+		enable-active-high;
+		regulator-boot-off;
+	};
+
 	sound {
 		compatible = "nvidia,tegra-audio-wm8903-ventana",
 			     "nvidia,tegra-audio-wm8903";
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 405d167..67a6cd9 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -123,7 +123,7 @@
 		status = "disabled";
 	};
 
-	pwm {
+	pwm: pwm {
 		compatible = "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
-- 
1.7.11.4

