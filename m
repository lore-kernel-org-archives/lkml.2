Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2HILQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:16:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9442 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023Ab2HILQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:16:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 09 Aug 2012 04:16:11 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 3/3] ARM: tegra: cardhu: add dt entry for fixed regulators
Date: Thu, 9 Aug 2012 16:30:39 +0530
Message-ID: <1344510039-17754-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1344510039-17754-1-git-send-email-ldewangan@nvidia.com>
References: <1344510039-17754-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cadhu have multiple power rails which are controlled by
GPIOs. Add support of these power rail control through
fixed regulators. Add entry for all fixed regulators for
cardhu-a02 and a04.
The details are taken from downstream kernel.

Some points on this change are:

* Add the tps65910-LDO5 entry and make it always ON
 to supply power to SDMMC. Once the sd driver support
 regulator handling, this flag will be remove.

* Dropping registration of rail vdd_sdmmc1 as the gpio
  is used by sdhci power-gpio. This need to fix in
  sdhci driver and then need to add the registration
  mechanism. Just removing power-gpio and adding fixed
  regulator with this gpio is causing the sd  access to
  fail because first probe call of this regulator fails
  due to non-available of parent and so it calls
  gpio_free() which disable the pins in gpio mode make
  pin output to LOW causes power to OFF. In probe retry,
  it got success and it powered-on but it again need to
  do again numeration of card here.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1-->V2:
- Remove the vdd_sdmmc1 regulator registration.
- Fix the pex_hvdd_3v3 regulator registration.
- Set panel regulator to be always on.

 arch/arm/boot/dts/tegra30-cardhu-a02.dts |   76 +++++++++++++++
 arch/arm/boot/dts/tegra30-cardhu-a04.dts |   88 ++++++++++++++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi    |  147 ++++++++++++++++++++++++++++++
 3 files changed, 311 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu-a02.dts b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
index dd870b7..dd4222f 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a02.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
@@ -7,5 +7,81 @@
 / {
 	model = "NVIDIA Tegra30 Cardhu A02 evaluation board";
 	compatible = "nvidia,cardhu-a02", "nvidia,cardhu", "nvidia,tegra30";
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ddr_reg: regulator@100 {
+			compatible = "regulator-fixed";
+			reg = <100>;
+			regulator-name = "vdd_ddr";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&pmic 6 0>;
+		};
+
+		sys_3v3_reg: regulator@101 {
+			compatible = "regulator-fixed";
+			reg = <101>;
+			regulator-name = "sys_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&pmic 7 0>;
+		};
+
+		usb1_vbus_reg: regulator@102 {
+			compatible = "regulator-fixed";
+			reg = <102>;
+			regulator-name = "usb1_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 68 0>; /* GPIO PI4 */
+			gpio-open-drain;
+			vin-supply = <&vdd_5v0_reg>;
+		};
+
+		usb3_vbus_reg: regulator@103 {
+			compatible = "regulator-fixed";
+			reg = <103>;
+			regulator-name = "usb3_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 63 0>; /* GPIO PH7 */
+			gpio-open-drain;
+			vin-supply = <&vdd_5v0_reg>;
+		};
+
+		vdd_5v0_reg: regulator@104 {
+			compatible = "regulator-fixed";
+			reg = <104>;
+			regulator-name = "5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&pmic 2 0>;
+		};
+
+		vdd_bl_reg: regulator@105 {
+			compatible = "regulator-fixed";
+			reg = <105>;
+			regulator-name = "vdd_bl";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio 83 0>; /* GPIO PK3 */
+		};
+	};
 };
 
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a04.dts b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
index a4cae6c..0828f09 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a04.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
@@ -7,4 +7,92 @@
 / {
 	model = "NVIDIA Tegra30 Cardhu A04 (A05, A06, A07) evaluation board";
 	compatible = "nvidia,cardhu-a04", "nvidia,cardhu", "nvidia,tegra30";
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ddr_reg: regulator@100 {
+			compatible = "regulator-fixed";
+			regulator-name = "ddr";
+			reg = <100>;
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&pmic 7 0>;
+		};
+
+		sys_3v3_reg: regulator@101 {
+			compatible = "regulator-fixed";
+			reg = <101>;
+			regulator-name = "sys_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&pmic 6 0>;
+		};
+
+		usb1_vbus_reg: regulator@102 {
+			compatible = "regulator-fixed";
+			reg = <102>;
+			regulator-name = "usb1_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 238 0>; /* GPIO PDD6 */
+			gpio-open-drain;
+			vin-supply = <&vdd_5v0_reg>;
+		};
+
+		usb3_vbus_reg: regulator@103 {
+			compatible = "regulator-fixed";
+			reg = <103>;
+			regulator-name = "usb3_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 236 0>; /* GPIO PDD4 */
+			gpio-open-drain;
+			vin-supply = <&vdd_5v0_reg>;
+		};
+
+		vdd_5v0_reg: regulator@104 {
+			compatible = "regulator-fixed";
+			reg = <104>;
+			regulator-name = "5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&pmic 8 0>;
+		};
+
+		vdd_bl_reg: regulator@105 {
+			compatible = "regulator-fixed";
+			reg = <105>;
+			regulator-name = "vdd_bl";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio 234 0>; /* GPIO PDD2 */
+		};
+
+		vdd_bl2_reg: regulator@106 {
+			compatible = "regulator-fixed";
+			reg = <106>;
+			regulator-name = "vdd_bl2";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio 232 0>; /* GPIO PDD0 */
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index ba38527..4794693 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -162,6 +162,7 @@
 			vcc1-supply = <&vdd_ac_bat_reg>;
 			vcc2-supply = <&vdd_ac_bat_reg>;
 			vcc3-supply = <&vio_reg>;
+			vcc4-supply = <&vdd_5v0_reg>;
 			vcc5-supply = <&vdd_ac_bat_reg>;
 			vcc6-supply = <&vdd2_reg>;
 			vcc7-supply = <&vdd_ac_bat_reg>;
@@ -234,6 +235,15 @@
 					regulator-always-on;
 				};
 
+				ldo5_reg: regulator@8 {
+					reg = <8>;
+					regulator-compatible = "ldo5";
+					regulator-name = "vddio_sdmmc,avdd_vdac";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
 				ldo6_reg: regulator@9 {
 					reg = <9>;
 					regulator-compatible = "ldo6";
@@ -300,6 +310,143 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		cam_1v8_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "cam_1v8";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			enable-active-high;
+			gpio = <&gpio 220 0>; /* gpio PBB4 */
+			vin-supply = <&vio_reg>;
+		};
+
+		cp_5v_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "cp_5v";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-boot-on;
+			regulator-always-on;
+			enable-active-high;
+			gpio = <&pmic 0 0>; /* PMIC TPS65911 GPIO0 */
+		};
+
+		emmc_3v3_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "emmc_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio 25 0>; /* gpio PD1 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		modem_3v3_reg: regulator@4 {
+			compatible = "regulator-fixed";
+			reg = <4>;
+			regulator-name = "modem_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&gpio 30 0>; /* gpio PD6 */
+		};
+
+		pex_hvdd_3v3_reg: regulator@5 {
+			compatible = "regulator-fixed";
+			reg = <5>;
+			regulator-name = "pex_hvdd_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&gpio 95 0>; /* gpio PL7 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		vdd_cam1_ldo_reg: regulator@6 {
+			compatible = "regulator-fixed";
+			reg = <6>;
+			regulator-name = "vdd_cam1_ldo";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			enable-active-high;
+			gpio = <&gpio 142 0>; /* gpio PR6 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		vdd_cam2_ldo_reg: regulator@7 {
+			compatible = "regulator-fixed";
+			reg = <7>;
+			regulator-name = "vdd_cam2_ldo";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			enable-active-high;
+			gpio = <&gpio 143 0>; /* gpio PR7 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		vdd_cam3_ldo_reg: regulator@8 {
+			compatible = "regulator-fixed";
+			reg = <8>;
+			regulator-name = "vdd_cam3_ldo";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&gpio 144 0>; /* gpio PS0 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		vdd_com_reg: regulator@9 {
+			compatible = "regulator-fixed";
+			reg = <9>;
+			regulator-name = "vdd_com";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&gpio 24 0>; /* gpio PD0 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		vdd_fuse_3v3_reg: regulator@10 {
+			compatible = "regulator-fixed";
+			reg = <10>;
+			regulator-name = "vdd_fuse_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&gpio 94 0>; /* gpio PL6 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		vdd_pnl1_reg: regulator@11 {
+			compatible = "regulator-fixed";
+			reg = <11>;
+			regulator-name = "vdd_pnl1";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio 92 0>; /* gpio PL4 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
+		vdd_vid_reg: regulator@12 {
+			compatible = "regulator-fixed";
+			reg = <12>;
+			regulator-name = "vddio_vid";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 152 0>; /* GPIO PT0 */
+			gpio-open-drain;
+			vin-supply = <&vdd_5v0_reg>;
+		};
 	};
 
 	sound {
-- 
1.7.1.1

