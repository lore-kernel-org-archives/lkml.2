Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2DMQIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:08:11 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:12535 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534Ab2DMQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:08:05 -0400
X-SpamScore: 5
X-BigFish: VS5(zz1102Ic8kzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>
Subject: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Date: Sat, 14 Apr 2012 00:18:33 +0800
Message-ID: <1334333915-1174-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The driver has mux and config support while the gpio is still
not supported.
For select input setting, the driver will handle it internally
and do not need user to take care of it.

The pinctrl-imx core driver will parse the dts file and dynamically
create the pinmux functions and groups.

Each IMX SoC pinctrl driver should register pins with a pin register map
including mux register and config register and select input map to core
for proper operations.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 .../bindings/pinctrl/fsl,imx6q-pinctrl.txt         |  201 ++++++
 drivers/pinctrl/Kconfig                            |    4 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-imx.c                      |  716 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx.h                      |  117 ++++
 5 files changed, 1039 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-imx.c
 create mode 100644 drivers/pinctrl/pinctrl-imx.h

diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
new file mode 100644
index 0000000..ff809fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
@@ -0,0 +1,201 @@
+* Freescale IOMUX Controller (IOMUXC) for i.MX
+
+The IOMUX Controller (IOMUXC), together with the IOMUX, enables the IC
+to share one PAD to several functional blocks. The sharing is done by
+multiplexing the PAD input/output signals. For each PAD there are up to
+8 muxing options (called ALT modes). Since different modules require
+different PAD settings (like pull up, keeper, etc) the IOMUXC controls
+also the PAD settings parameters.
+
+Required properties:
+
+- compatible: "fsl,imx6q-iomuxc"
+- fsl,pins : An array of strings. Each string represents the name of a pin.
+  Refer to the following table for the availabe pins of imx6q to use.
+- fsl,function: A string containing the name of the function to mux to the pin.
+
+Optinal properties:
+
+Below is pad config options:
+- fsl,hysteresis: Integer. Hysteresis Enable Field.
+    0: Hysteresis Disabled
+    1: Hysteresis Enabled
+- fsl,pull: Integer, representing the pull-down/up to apply to the pin.
+    0: 100KOhm Pull Down
+    1: 47KOhm Pull Up
+    2: 100KOhm Pull Up
+    3: 22KOhm Pull Up
+- fsl,pue: Pull / Keep Select Field
+    0: Keeper
+    1: Pull
+- fsl,pke: Pull / Keep Enable Field
+    0: Pull/Keeper Disabled
+    1: Pull/Keeper Enable
+- fsl,open-drain: Integer. Open Drain Enable Field.
+    0: Open Drain Disabled
+    1: Open Drain Enabled
+- fsl,speed: Integer. Speed Field.
+    0: TBD
+    1: low(50MHz)
+    2: medium(100MHz)
+    3: max(200MHz)
+- fsl,drive-strength: Integer. Drive Strength Field.
+    0: output driver disabled;
+    1: 240 Ohm
+    2: 120 Ohm
+    3: 80 Ohm
+    4: 60 Ohm
+    5: 48 Ohm
+    6: 40 Ohm
+    7: 34 Ohm
+- fsl,slew-rate: Integer. Slew Rate Field.
+    0: Slow Slew Rate
+    1: Fast Slew Rate
+
+Requirements to use pinctrl-imx driver based on dt:
+1. The pinmux function nodes should be defined under iomux controller node
+2. The pin group nodes should be defined under function node which this group
+   is intend to work on.
+
+The hierarchy is:
+iomuxc@020e0000 {
+	func-a {
+		group-a {
+			fsl,pins = "PIN_A",
+				   "PIN_B",
+				   ....
+			fsl,mux = <...>,
+			fsl,pull = <..>;
+			fsl,drive-strength = <..>;
+			...
+		};
+
+		group-b {
+			...
+		};
+		...
+	};
+
+	func-b {
+		...
+	};
+	...
+};
+
+The function node name will be parsed as the pinmux function node, the group
+node name will be parsed as the group name.
+
+Examples:
+usdhc@0219c000 { /* uSDHC4 */
+	fsl,card-wired;
+	vmmc-supply = <&reg_3p3v>;
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usdhc4_1>;
+};
+
+iomuxc@020e0000 {
+	compatible = "fsl,imx6q-iomuxc";
+	reg = <0x020e0000 0x4000>;
+
+	/* shared pinctrl settings */
+	usdhc4 {
+		pinctrl_usdhc4_1: usdhc4grp-1 {
+			fsl,pins =	"MX6Q_PAD_SD4_CMD",
+					"MX6Q_PAD_SD4_CLK",
+					"MX6Q_PAD_SD4_DAT0",
+					"MX6Q_PAD_SD4_DAT1",
+					"MX6Q_PAD_SD4_DAT2",
+					"MX6Q_PAD_SD4_DAT3",
+					"MX6Q_PAD_SD4_DAT4",
+					"MX6Q_PAD_SD4_DAT5",
+					"MX6Q_PAD_SD4_DAT6",
+					"MX6Q_PAD_SD4_DAT7";
+			fsl,mux = <0 0 1 1 1 1 1 1 1 1>;
+			fsl,pull = <1>;
+			fsl,pue = <1>;
+			fsl,pke = <1>;
+			fsl,speed = <1>;
+			fsl,drive-strength = <3>;
+			fsl,slew-rate = <1>;
+			fsl,hysteresis = <1>;
+		};
+	};
+	....
+};
+
+The available IMX6Q pins:
+MX6Q_PAD_SD2_DAT1, MX6Q_PAD_SD2_DAT2, MX6Q_PAD_SD2_DAT0, MX6Q_PAD_RGMII_TXC,
+MX6Q_PAD_RGMII_TD0, MX6Q_PAD_RGMII_TD1, MX6Q_PAD_RGMII_TD2, MX6Q_PAD_RGMII_TD3,
+MX6Q_PAD_RGMII_RX_CTL, MX6Q_PAD_RGMII_RD0, MX6Q_PAD_RGMII_TX_CTL, MX6Q_PAD_RGMII_RD1,
+MX6Q_PAD_RGMII_RD2, MX6Q_PAD_RGMII_RD3, MX6Q_PAD_RGMII_RXC, MX6Q_PAD_EIM_A25,
+MX6Q_PAD_EIM_EB2, MX6Q_PAD_EIM_D16, MX6Q_PAD_EIM_D17, MX6Q_PAD_EIM_D18, MX6Q_PAD_EIM_D19,
+MX6Q_PAD_EIM_D20, MX6Q_PAD_EIM_D21, MX6Q_PAD_EIM_D22, MX6Q_PAD_EIM_D23, MX6Q_PAD_EIM_EB3,
+MX6Q_PAD_EIM_D24, MX6Q_PAD_EIM_D25, MX6Q_PAD_EIM_D26, MX6Q_PAD_EIM_D27, MX6Q_PAD_EIM_D28,
+MX6Q_PAD_EIM_D29, MX6Q_PAD_EIM_D30, MX6Q_PAD_EIM_D31, MX6Q_PAD_EIM_A24, MX6Q_PAD_EIM_A23,
+MX6Q_PAD_EIM_A22, MX6Q_PAD_EIM_A21, MX6Q_PAD_EIM_A20, MX6Q_PAD_EIM_A19, MX6Q_PAD_EIM_A18,
+MX6Q_PAD_EIM_A17, MX6Q_PAD_EIM_A16, MX6Q_PAD_EIM_CS0, MX6Q_PAD_EIM_CS1, MX6Q_PAD_EIM_OE,
+MX6Q_PAD_EIM_RW, MX6Q_PAD_EIM_LBA, MX6Q_PAD_EIM_EB0, MX6Q_PAD_EIM_EB1, MX6Q_PAD_EIM_DA0,
+MX6Q_PAD_EIM_DA1, MX6Q_PAD_EIM_DA2, MX6Q_PAD_EIM_DA3, MX6Q_PAD_EIM_DA4, MX6Q_PAD_EIM_DA5,
+MX6Q_PAD_EIM_DA6, MX6Q_PAD_EIM_DA7, MX6Q_PAD_EIM_DA8, MX6Q_PAD_EIM_DA9, MX6Q_PAD_EIM_DA10,
+MX6Q_PAD_EIM_DA11, MX6Q_PAD_EIM_DA12, MX6Q_PAD_EIM_DA13, MX6Q_PAD_EIM_DA14, MX6Q_PAD_EIM_DA15,
+MX6Q_PAD_EIM_WAIT, MX6Q_PAD_EIM_BCLK, MX6Q_PAD_DI0_DISP_CLK, MX6Q_PAD_DI0_PIN15, MX6Q_PAD_DI0_PIN2,
+MX6Q_PAD_DI0_PIN3, MX6Q_PAD_DI0_PIN4, MX6Q_PAD_DISP0_DAT0, MX6Q_PAD_DISP0_DAT1, MX6Q_PAD_DISP0_DAT2,
+MX6Q_PAD_DISP0_DAT3, MX6Q_PAD_DISP0_DAT4, MX6Q_PAD_DISP0_DAT5, MX6Q_PAD_DISP0_DAT6,
+MX6Q_PAD_DISP0_DAT7, MX6Q_PAD_DISP0_DAT8, MX6Q_PAD_DISP0_DAT9, MX6Q_PAD_DISP0_DAT10,
+MX6Q_PAD_DISP0_DAT11, MX6Q_PAD_DISP0_DAT12, MX6Q_PAD_DISP0_DAT13, MX6Q_PAD_DISP0_DAT14,
+MX6Q_PAD_DISP0_DAT15, MX6Q_PAD_DISP0_DAT16, MX6Q_PAD_DISP0_DAT17, MX6Q_PAD_DISP0_DAT18,
+MX6Q_PAD_DISP0_DAT19, MX6Q_PAD_DISP0_DAT20, MX6Q_PAD_DISP0_DAT21, MX6Q_PAD_DISP0_DAT22,
+MX6Q_PAD_DISP0_DAT23, MX6Q_PAD_ENET_MDIO, MX6Q_PAD_ENET_REF_CLK, MX6Q_PAD_ENET_RX_ER,
+MX6Q_PAD_ENET_CRS_DV, MX6Q_PAD_ENET_RXD1, MX6Q_PAD_ENET_RXD0, MX6Q_PAD_ENET_TX_EN,
+MX6Q_PAD_ENET_TXD1, MX6Q_PAD_ENET_TXD0, MX6Q_PAD_ENET_MDC, MX6Q_PAD_DRAM_D40, MX6Q_PAD_DRAM_D41,
+MX6Q_PAD_DRAM_D42, MX6Q_PAD_DRAM_D43, MX6Q_PAD_DRAM_D44, MX6Q_PAD_DRAM_D45, MX6Q_PAD_DRAM_D46,
+MX6Q_PAD_DRAM_D47, MX6Q_PAD_DRAM_SDQS5, MX6Q_PAD_DRAM_DQM5, MX6Q_PAD_DRAM_D32, MX6Q_PAD_DRAM_D33,
+MX6Q_PAD_DRAM_D34, MX6Q_PAD_DRAM_D35, MX6Q_PAD_DRAM_D36, MX6Q_PAD_DRAM_D37, MX6Q_PAD_DRAM_D38,
+MX6Q_PAD_DRAM_D39, MX6Q_PAD_DRAM_DQM4, MX6Q_PAD_DRAM_SDQS4, MX6Q_PAD_DRAM_D24, MX6Q_PAD_DRAM_D25,
+MX6Q_PAD_DRAM_D26, MX6Q_PAD_DRAM_D27, MX6Q_PAD_DRAM_D28, MX6Q_PAD_DRAM_D29, MX6Q_PAD_DRAM_SDQS3,
+MX6Q_PAD_DRAM_D30, MX6Q_PAD_DRAM_D31, MX6Q_PAD_DRAM_DQM3, MX6Q_PAD_DRAM_D16, MX6Q_PAD_DRAM_D17,
+MX6Q_PAD_DRAM_D18, MX6Q_PAD_DRAM_D19, MX6Q_PAD_DRAM_D20, MX6Q_PAD_DRAM_D21, MX6Q_PAD_DRAM_D22,
+MX6Q_PAD_DRAM_SDQS2, MX6Q_PAD_DRAM_D23, MX6Q_PAD_DRAM_DQM2, MX6Q_PAD_DRAM_A0, MX6Q_PAD_DRAM_A1,
+MX6Q_PAD_DRAM_A2, MX6Q_PAD_DRAM_A3, MX6Q_PAD_DRAM_A4, MX6Q_PAD_DRAM_A5, MX6Q_PAD_DRAM_A6,
+MX6Q_PAD_DRAM_A7, MX6Q_PAD_DRAM_A8, MX6Q_PAD_DRAM_A9, MX6Q_PAD_DRAM_A10, MX6Q_PAD_DRAM_A11,
+MX6Q_PAD_DRAM_A12, MX6Q_PAD_DRAM_A13, MX6Q_PAD_DRAM_A14, MX6Q_PAD_DRAM_A15, MX6Q_PAD_DRAM_CAS,
+MX6Q_PAD_DRAM_CS0, MX6Q_PAD_DRAM_CS1, MX6Q_PAD_DRAM_RAS, MX6Q_PAD_DRAM_RESET, MX6Q_PAD_DRAM_SDBA0,
+MX6Q_PAD_DRAM_SDBA1, MX6Q_PAD_DRAM_SDCLK_0, MX6Q_PAD_DRAM_SDBA2, MX6Q_PAD_DRAM_SDCKE0,
+MX6Q_PAD_DRAM_SDCLK_1, MX6Q_PAD_DRAM_SDCKE1, MX6Q_PAD_DRAM_SDODT0, MX6Q_PAD_DRAM_SDODT1,
+MX6Q_PAD_DRAM_SDWE, MX6Q_PAD_DRAM_D0, MX6Q_PAD_DRAM_D1, MX6Q_PAD_DRAM_D2, MX6Q_PAD_DRAM_D3,
+MX6Q_PAD_DRAM_D4, MX6Q_PAD_DRAM_D5, MX6Q_PAD_DRAM_SDQS0, MX6Q_PAD_DRAM_D6, MX6Q_PAD_DRAM_D7,
+MX6Q_PAD_DRAM_DQM0, MX6Q_PAD_DRAM_D8, MX6Q_PAD_DRAM_D9, MX6Q_PAD_DRAM_D10, MX6Q_PAD_DRAM_D11,
+MX6Q_PAD_DRAM_D12, MX6Q_PAD_DRAM_D13, MX6Q_PAD_DRAM_D14, MX6Q_PAD_DRAM_SDQS1, MX6Q_PAD_DRAM_D15,
+MX6Q_PAD_DRAM_DQM1, MX6Q_PAD_DRAM_D48, MX6Q_PAD_DRAM_D49, MX6Q_PAD_DRAM_D50, MX6Q_PAD_DRAM_D51,
+MX6Q_PAD_DRAM_D52, MX6Q_PAD_DRAM_D53, MX6Q_PAD_DRAM_D54, MX6Q_PAD_DRAM_D55, MX6Q_PAD_DRAM_SDQS6,
+MX6Q_PAD_DRAM_DQM6, MX6Q_PAD_DRAM_D56, MX6Q_PAD_DRAM_SDQS7, MX6Q_PAD_DRAM_D57, MX6Q_PAD_DRAM_D58,
+MX6Q_PAD_DRAM_D59, MX6Q_PAD_DRAM_D60, MX6Q_PAD_DRAM_DQM7, MX6Q_PAD_DRAM_D61, MX6Q_PAD_DRAM_D62,
+MX6Q_PAD_DRAM_D63, MX6Q_PAD_KEY_COL0, MX6Q_PAD_KEY_ROW0, MX6Q_PAD_KEY_COL1, MX6Q_PAD_KEY_ROW1,
+MX6Q_PAD_KEY_COL2, MX6Q_PAD_KEY_ROW2, MX6Q_PAD_KEY_COL3, MX6Q_PAD_KEY_ROW3, MX6Q_PAD_KEY_COL4,
+MX6Q_PAD_KEY_ROW4, MX6Q_PAD_GPIO_0, MX6Q_PAD_GPIO_1, MX6Q_PAD_GPIO_9, MX6Q_PAD_GPIO_3,
+MX6Q_PAD_GPIO_6, MX6Q_PAD_GPIO_2, MX6Q_PAD_GPIO_4, MX6Q_PAD_GPIO_5, MX6Q_PAD_GPIO_7,
+MX6Q_PAD_GPIO_8, MX6Q_PAD_GPIO_16, MX6Q_PAD_GPIO_17, MX6Q_PAD_GPIO_18, MX6Q_PAD_GPIO_19,
+MX6Q_PAD_CSI0_PIXCLK, MX6Q_PAD_CSI0_MCLK, MX6Q_PAD_CSI0_DATA_EN, MX6Q_PAD_CSI0_VSYNC,
+MX6Q_PAD_CSI0_DAT4, MX6Q_PAD_CSI0_DAT5, MX6Q_PAD_CSI0_DAT6, MX6Q_PAD_CSI0_DAT7,
+MX6Q_PAD_CSI0_DAT8, MX6Q_PAD_CSI0_DAT9, MX6Q_PAD_CSI0_DAT10, MX6Q_PAD_CSI0_DAT11,
+MX6Q_PAD_CSI0_DAT12, MX6Q_PAD_CSI0_DAT13, MX6Q_PAD_CSI0_DAT14, MX6Q_PAD_CSI0_DAT15,
+MX6Q_PAD_CSI0_DAT16, MX6Q_PAD_CSI0_DAT17, MX6Q_PAD_CSI0_DAT18, MX6Q_PAD_CSI0_DAT19,
+MX6Q_PAD_JTAG_TMS, MX6Q_PAD_JTAG_MOD, MX6Q_PAD_JTAG_TRSTB, MX6Q_PAD_JTAG_TDI,
+MX6Q_PAD_JTAG_TCK, MX6Q_PAD_JTAG_TDO, MX6Q_PAD_LVDS1_TX3_P, MX6Q_PAD_LVDS1_TX2_P,
+MX6Q_PAD_LVDS1_CLK_P, MX6Q_PAD_LVDS1_TX1_P, MX6Q_PAD_LVDS1_TX0_P, MX6Q_PAD_LVDS0_TX3_P,
+MX6Q_PAD_LVDS0_CLK_P, MX6Q_PAD_LVDS0_TX2_P, MX6Q_PAD_LVDS0_TX1_P, MX6Q_PAD_LVDS0_TX0_P,
+MX6Q_PAD_TAMPER, MX6Q_PAD_PMIC_ON_REQ, MX6Q_PAD_PMIC_STBY_REQ, MX6Q_PAD_POR_B,
+MX6Q_PAD_BOOT_MODE1, MX6Q_PAD_RESET_IN_B, MX6Q_PAD_BOOT_MODE0, MX6Q_PAD_TEST_MODE,
+MX6Q_PAD_SD3_DAT7, MX6Q_PAD_SD3_DAT6, MX6Q_PAD_SD3_DAT5, MX6Q_PAD_SD3_DAT4,
+MX6Q_PAD_SD3_CMD, MX6Q_PAD_SD3_CLK, MX6Q_PAD_SD3_DAT0, MX6Q_PAD_SD3_DAT1,
+MX6Q_PAD_SD3_DAT2, MX6Q_PAD_SD3_DAT3, MX6Q_PAD_SD3_RST, MX6Q_PAD_NANDF_CLE,
+MX6Q_PAD_NANDF_ALE, MX6Q_PAD_NANDF_WP_B, MX6Q_PAD_NANDF_RB0, MX6Q_PAD_NANDF_CS0,
+MX6Q_PAD_NANDF_CS1, MX6Q_PAD_NANDF_CS2, MX6Q_PAD_NANDF_CS3, MX6Q_PAD_SD4_CMD,
+MX6Q_PAD_SD4_CLK, MX6Q_PAD_NANDF_D0, MX6Q_PAD_NANDF_D1, MX6Q_PAD_NANDF_D2,
+MX6Q_PAD_NANDF_D3, MX6Q_PAD_NANDF_D4, MX6Q_PAD_NANDF_D5, MX6Q_PAD_NANDF_D6,
+MX6Q_PAD_NANDF_D7, MX6Q_PAD_SD4_DAT0, MX6Q_PAD_SD4_DAT1, MX6Q_PAD_SD4_DAT2,
+MX6Q_PAD_SD4_DAT3, MX6Q_PAD_SD4_DAT4, MX6Q_PAD_SD4_DAT5, MX6Q_PAD_SD4_DAT6,
+MX6Q_PAD_SD4_DAT7, MX6Q_PAD_SD1_DAT1, MX6Q_PAD_SD1_DAT0, MX6Q_PAD_SD1_DAT3,
+MX6Q_PAD_SD1_CMD, MX6Q_PAD_SD1_DAT2, MX6Q_PAD_SD1_CLK, MX6Q_PAD_SD2_CLK,
+MX6Q_PAD_SD2_CMD, MX6Q_PAD_SD2_DAT3.
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f73a5ea..f48ef96 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -26,6 +26,10 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
+config PINCTRL_IMX
+	bool "Freescale IMX core pinctrl driver"
+	depends on ARCH_MXC
+
 config PINCTRL_PXA3xx
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 8e3c95a..917695e 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
+obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
new file mode 100644
index 0000000..9fa29d7
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -0,0 +1,716 @@
+/*
+ * Core driver for the imx pin controller
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/slab.h>
+
+#include "core.h"
+#include "pinctrl-imx.h"
+
+#define DRIVER_NAME "pinctrl-imx"
+
+#define IMX_PMX_DUMP(s, d, n)			\
+	{					\
+		int i;				\
+		printk("%s:\t", s);		\
+		for (i = 0; i < n; i++)		\
+			printk("%03d ", d[i]);	\
+		printk("\n");			\
+	}
+
+/**
+ * @dev: a pointer back to containing device
+ * @base: the offset to the controller in virtual memory
+ */
+struct imx_pmx {
+	struct device *dev;
+	struct pinctrl_dev *pctl;
+	void __iomem *base;
+	struct imx_pinctrl_info *info;
+};
+
+static const struct imx_pin_reg *imx_find_pin_reg(struct imx_pinctrl_info *info,
+				unsigned pin, bool is_mux, unsigned mux)
+{
+	const struct imx_pin_reg *pin_reg = NULL;
+	int i;
+
+	for (i = 0; i < info->npin_regs; i++) {
+		pin_reg = &info->pin_regs[i];
+		if (pin_reg->pid != pin)
+			continue;
+		if (!is_mux)
+			break;
+		else if (pin_reg->mux_mode == (mux & IMX_MUX_MASK))
+			break;
+	}
+
+	if (!pin_reg) {
+		dev_err(info->dev, "Pin(%s): unable to find pin reg map\n",
+			info->pins[pin].name);
+		return NULL;
+	}
+
+	return pin_reg;
+}
+
+static int imx_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	return info->ngroups;
+}
+
+static const char *imx_get_group_name(struct pinctrl_dev *pctldev,
+				       unsigned selector)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	if (selector >= info->ngroups)
+		return NULL;
+
+	return info->groups[selector].name;
+}
+
+static int imx_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			       const unsigned **pins,
+			       unsigned *num_pins)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	if (selector >= info->ngroups)
+		return -EINVAL;
+
+	*pins = info->groups[selector].pins;
+	*num_pins = info->groups[selector].num_pins;
+
+	return 0;
+}
+
+static void imx_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
+		   unsigned offset)
+{
+	seq_printf(s, " " DRIVER_NAME);
+}
+
+static int imx_dt_node_to_map(struct pinctrl_dev *pctldev,
+			struct device_node *np,
+			struct pinctrl_map **map, unsigned *num_maps)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+	const struct imx_config_properties *imx_config;
+	struct pinctrl_map *new_map;
+	struct device_node *parent;
+	u32 val, config, map_num;
+	void *new_config;
+	int i, ret;
+
+	/* first check if there's a config map */
+	config = 0;
+	for (i = 0; i < info->nconf_properties; i++) {
+		imx_config = &info->conf_properties[i];
+		ret = of_property_read_u32(np, imx_config->property, &val);
+		if (!ret) {
+			dev_dbg(info->dev, "config property %s: 0x%x\n",
+				imx_config->property, val);
+			if (val > imx_config->mask)
+				dev_warn(info->dev, "The config(%s) value 0x%x exceeds the range",
+					imx_config->property, val);
+			config |= val << imx_config->off;
+		}
+	}
+
+	map_num = config ? 2 : 1;
+	new_map = kmalloc(sizeof(struct pinctrl_map) * map_num, GFP_KERNEL);
+	if (!new_map)
+		return -ENOMEM;
+
+	/* generate mux map */
+	parent = of_get_parent(np);
+	if (!parent)
+		return -EINVAL;
+
+	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
+	new_map[0].data.mux.function = parent->name;
+	new_map[0].data.mux.group = np->name;
+
+	if (config) {
+		new_config = kmemdup(&config, sizeof(config), GFP_KERNEL);
+		/* generate config map */
+		new_map[1].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+		new_map[1].data.configs.group_or_pin = np->name;
+		new_map[1].data.configs.configs = (unsigned long *)new_config;
+		new_map[1].data.configs.num_configs = 1;
+	}
+
+	*map = new_map;
+	*num_maps = map_num;
+
+	dev_dbg(pctldev->dev, "map: num %d function %s group %s config 0x%x\n",
+		map_num, new_map->data.mux.function,
+		new_map->data.mux.group, config);
+
+	return 0;
+}
+
+static void imx_dt_free_map(struct pinctrl_dev *pctldev,
+				struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+
+static struct pinctrl_ops imx_pctrl_ops = {
+	.get_groups_count = imx_get_groups_count,
+	.get_group_name = imx_get_group_name,
+	.get_group_pins = imx_get_group_pins,
+	.pin_dbg_show = imx_pin_dbg_show,
+	.dt_node_to_map = imx_dt_node_to_map,
+	.dt_free_map = imx_dt_free_map,
+
+};
+
+static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
+			   unsigned group)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+	const struct imx_pin_reg *pin_reg;
+	const unsigned *pins, *mux;
+	unsigned int num_pins, pin_id;
+	int i;
+
+	/*
+	 * Configure the mux mode for each pin in the group for a specific
+	 * function.
+	 */
+	pins = info->groups[group].pins;
+	num_pins = info->groups[group].num_pins;
+	mux = info->groups[group].mux_mode;
+
+	WARN_ON(!pins || !num_pins || !mux);
+
+	dev_dbg(ipmx->dev, "enable function %s group %s\n",
+		info->functions[selector].name, info->groups[group].name);
+
+	for (i = 0; i < num_pins; i++) {
+		pin_id = pins[i];
+
+		pin_reg = imx_find_pin_reg(info, pin_id, 1, mux[i]);
+		if (!pin_reg)
+			return -EINVAL;
+
+		if (!pin_reg->mux_reg) {
+			dev_err(ipmx->dev, "Pin(%s) does not support mux function\n",
+				info->pins[pin_id].name);
+			return -EINVAL;
+		}
+
+		writel(mux[i], ipmx->base + pin_reg->mux_reg);
+		dev_dbg(ipmx->dev, "write: offset 0x%x val 0x%x\n",
+			pin_reg->mux_reg, mux[i]);
+
+		/* some pins also need select input setting, set it if found */
+		if (pin_reg->input_reg) {
+			writel(pin_reg->input_val, ipmx->base + pin_reg->input_reg);
+			dev_dbg(ipmx->dev,
+				"==>select_input: offset 0x%x val 0x%x\n",
+				pin_reg->input_reg, pin_reg->input_val);
+		}
+	}
+
+	return 0;
+}
+
+static void imx_pmx_disable(struct pinctrl_dev *pctldev, unsigned func_selector,
+			    unsigned group_selector)
+{
+	/* nothing to do here */
+}
+
+static int imx_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	return info->nfunctions;
+}
+
+static const char *imx_pmx_get_func_name(struct pinctrl_dev *pctldev,
+					  unsigned selector)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	return info->functions[selector].name;
+}
+
+static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
+			       const char * const **groups,
+			       unsigned * const num_groups)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	*groups = info->functions[selector].groups;
+	*num_groups = info->functions[selector].num_groups;
+
+	return 0;
+}
+
+static struct pinmux_ops imx_pmx_ops = {
+	.get_functions_count = imx_pmx_get_funcs_count,
+	.get_function_name = imx_pmx_get_func_name,
+	.get_function_groups = imx_pmx_get_groups,
+	.enable = imx_pmx_enable,
+	.disable = imx_pmx_disable,
+};
+
+static int imx_pinconf_get(struct pinctrl_dev *pctldev,
+			     unsigned pin_id, unsigned long *config)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+	const struct imx_pin_reg *pin_reg;
+
+	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
+	if (!pin_reg)
+		return -EINVAL;
+
+	if (!pin_reg->conf_reg) {
+		dev_err(info->dev, "Pin(%s) does not support config function\n",
+			info->pins[pin_id].name);
+		return -EINVAL;
+	}
+
+	*config = readl(ipmx->base + pin_reg->conf_reg);
+
+	return 0;
+}
+
+static int imx_pinconf_set(struct pinctrl_dev *pctldev,
+			     unsigned pin_id, unsigned long config)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+	const struct imx_pin_reg *pin_reg;
+
+	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
+	if (!pin_reg)
+		return -EINVAL;
+
+	if (!pin_reg->conf_reg) {
+		dev_err(info->dev, "Pin(%s) does not support config function\n",
+			info->pins[pin_id].name);
+		return -EINVAL;
+	}
+
+	writel(config, ipmx->base + pin_reg->conf_reg);
+
+	return 0;
+}
+
+static int imx_pinconf_group_get(struct pinctrl_dev *pctldev,
+				   unsigned group, unsigned long *config)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	*config = info->groups[group].config;
+	dev_dbg(ipmx->dev, "get group %s config 0x%lx\n",
+		info->groups[group].name, *config);
+
+	return 0;
+}
+
+static int imx_pinconf_group_set(struct pinctrl_dev *pctldev,
+				   unsigned group, unsigned long config)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+	const struct imx_pin_reg *pin_reg;
+	const unsigned *pins;
+	unsigned int num_pins, pin_id;
+	int i;
+
+	pins = info->groups[group].pins;
+	num_pins = info->groups[group].num_pins;
+
+	WARN_ON(!pins || !num_pins);
+
+	dev_dbg(ipmx->dev, "set group %s config 0x%lx\n",
+		info->groups[group].name, config);
+
+	for (i = 0; i < num_pins; i++) {
+		pin_id = pins[i];
+
+		pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
+		if (!pin_reg)
+			return -EINVAL;
+
+		if (!pin_reg->conf_reg) {
+			dev_err(ipmx->dev, "Pin(%s) does not support config function\n",
+				info->pins[pin_id].name);
+			return -EINVAL;
+		}
+
+		writel(config, ipmx->base + pin_reg->conf_reg);
+		dev_dbg(ipmx->dev, "write: offset 0x%x val 0x%lx\n",
+			pin_reg->conf_reg, config);
+	}
+
+	/* save the current group config value */
+	info->groups[group].config = config;
+
+	return 0;
+}
+
+static void imx_pinconf_dbg_show(struct pinctrl_dev *pctldev,
+				   struct seq_file *s, unsigned pin_id)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+	const struct imx_pin_reg *pin_reg;
+	unsigned long config;
+
+	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
+	if (!pin_reg) {
+		seq_printf(s, "N/A");
+		return;
+	}
+
+	config = readl(ipmx->base + pin_reg->conf_reg);
+	seq_printf(s, "0x%lx", config);
+}
+
+static void imx_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
+					 struct seq_file *s, unsigned group)
+{
+	unsigned long config;
+	int ret;
+
+	ret = imx_pinconf_group_get(pctldev, group, &config);
+	if (!ret)
+		seq_printf(s, "0x%lx", config);
+}
+
+struct pinconf_ops imx_pinconf_ops = {
+	.pin_config_get = imx_pinconf_get,
+	.pin_config_set = imx_pinconf_set,
+	.pin_config_group_get = imx_pinconf_group_get,
+	.pin_config_group_set = imx_pinconf_group_set,
+	.pin_config_dbg_show = imx_pinconf_dbg_show,
+	.pin_config_group_dbg_show = imx_pinconf_group_dbg_show,
+};
+
+static struct pinctrl_desc imx_pmx_desc = {
+	.name = DRIVER_NAME,
+	.pctlops = &imx_pctrl_ops,
+	.pmxops = &imx_pmx_ops,
+	.confops = &imx_pinconf_ops,
+	.owner = THIS_MODULE,
+};
+
+#ifdef CONFIG_OF
+static unsigned int imx_pmx_pin_name_to_id(struct imx_pinctrl_info *info,
+					const char *s)
+{
+	unsigned int i;
+	const struct pinctrl_pin_desc *desc;
+
+	BUG_ON(!info || !info->pins || !info->npins);
+
+	for (i = 0; i < info->npins; i++) {
+		desc = info->pins + i;
+		if (desc->name && !strcmp(s, desc->name))
+			return desc->number;
+	}
+
+	return -EINVAL;
+}
+
+static int __devinit imx_pmx_parse_groups(struct device_node *np,
+				struct imx_pin_group *grp,
+				struct imx_pinctrl_info *info, u32 index)
+{
+	struct property *prop;
+	const char *s;
+	int ret, len;
+	u32 i = 0;
+
+	dev_dbg(info->dev, "group(%d): %s\n", index, np->name);
+
+	/* Initialise group */
+	grp->name = np->name;
+	grp->num_pins = of_property_count_strings(np, "fsl,pins");
+	if (grp->num_pins < 0) {
+		dev_err(info->dev, "failed to get fsl,pins\n");
+		return grp->num_pins;
+	}
+
+	grp->pins = devm_kzalloc(info->dev, grp->num_pins * sizeof(unsigned int),
+				GFP_KERNEL);
+	grp->mux_mode = devm_kzalloc(info->dev, grp->num_pins * sizeof(unsigned int),
+				GFP_KERNEL);
+
+	of_property_for_each_string(np, "fsl,pins", prop, s) {
+		ret = imx_pmx_pin_name_to_id(info, s);
+		if (ret < 0) {
+			dev_err(info->dev, "failed to get pin: %s\n", s);
+			return ret;
+		}
+		grp->pins[i++] = ret;
+	}
+
+	if (i != grp->num_pins) {
+		dev_err(info->dev, "parsed wrong pins number?\n");
+		return -EINVAL;
+	}
+
+	/* group sanity check */
+	if (of_get_property(np, "fsl,mux", &len) &&
+		len != grp->num_pins * sizeof(unsigned int)) {
+		dev_err(info->dev, "fsl,mux length is not equal to fsl,pins\n");
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32_array(np, "fsl,mux",
+			grp->mux_mode, grp->num_pins);
+	if (ret) {
+		dev_err(info->dev, "failed to get fsl,mux\n");
+		return ret;
+	}
+
+#ifdef DEBUG
+	IMX_PMX_DUMP("pins", grp->pins, grp->num_pins);
+	IMX_PMX_DUMP("mux", grp->mux_mode, grp->num_pins);
+#endif
+	return 0;
+}
+
+static int __devinit imx_pmx_parse_functions(struct device_node *np,
+			struct imx_pinctrl_info *info, u32 index)
+{
+	struct device_node *child;
+	struct imx_pmx_func *func;
+	struct imx_pin_group *grp;
+	int ret;
+	static u32 grp_index;
+	u32 i = 0;
+
+	dev_dbg(info->dev, "parse function(%d): %s\n", index, np->name);
+
+	func = &info->functions[index];
+
+	/* Initialise function */
+	func->name = np->name;
+	func->num_groups = of_get_child_count(np);
+	if (func->num_groups <= 0) {
+		dev_err(info->dev, "no groups defined\n");
+		return -EINVAL;
+	}
+	func->groups = devm_kzalloc(info->dev,
+			func->num_groups * sizeof(char *), GFP_KERNEL);
+
+	for_each_child_of_node(np, child) {
+		func->groups[i] = child->name;
+		grp = &info->groups[grp_index++];
+		ret = imx_pmx_parse_groups(child, grp, info, i++);
+		if (ret)
+			return ret;
+	}
+
+	if (i != func->num_groups) {
+		dev_err(info->dev, "parsed wrong groups number?\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
+				struct imx_pinctrl_info *info)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *child;
+	int ret;
+	u32 nfuncs = 0;
+	u32 i = 0;
+
+	if (!np)
+		return -ENODEV;
+
+	nfuncs = of_get_child_count(np);
+	if (nfuncs <= 0) {
+		dev_err(&pdev->dev, "no functions defined\n");
+		return -EINVAL;
+	}
+
+	info->nfunctions = nfuncs;
+	info->functions = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pmx_func),
+					GFP_KERNEL);
+	if (!info->functions)
+		return -ENOMEM;
+
+	info->ngroups = 0;
+	for_each_child_of_node(np, child)
+		info->ngroups += of_get_child_count(child);
+	info->groups = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pin_group),
+					GFP_KERNEL);
+	if (!info->groups)
+		return -ENOMEM;
+
+	for_each_child_of_node(np, child) {
+		ret = imx_pmx_parse_functions(child, info, i++);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to parse function\n");
+			return ret;
+		}
+	}
+
+	if (i != info->nfunctions) {
+		dev_err(info->dev, "parsed wrong functions number?\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#else
+static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
+				struct imx_pinctrl_info *info)
+{
+	return -ENODEV;
+}
+#endif
+
+static inline void imx_pmx_desc_init(struct pinctrl_desc *pmx_desc,
+				const struct imx_pinctrl_info *info)
+{
+	pmx_desc->pins = info->pins;
+	pmx_desc->npins = info->npins;
+}
+
+static const struct of_device_id imx_pmx_dt_ids[] = {
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_pmx_dt_ids);
+
+static int __init imx_pmx_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id =
+			of_match_device(imx_pmx_dt_ids, &pdev->dev);
+	struct device *dev = &pdev->dev;
+	struct imx_pmx *ipmx;
+	struct resource *res;
+	struct imx_pinctrl_info *info;
+	resource_size_t res_size;
+	int ret;
+
+	info = of_id->data;
+	if (!info || !info->pins || !info->npins
+		  || !info->pin_regs || !info->npin_regs
+		  || !info->conf_properties || !info->nconf_properties) {
+		dev_err(&pdev->dev, "wrong pinctrl info\n");
+		return -EINVAL;
+	}
+	info->dev = &pdev->dev;
+
+	/* Create state holders etc for this driver */
+	ipmx = devm_kzalloc(&pdev->dev, sizeof(*ipmx), GFP_KERNEL);
+	if (!ipmx)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+
+	res_size = resource_size(res);
+	if (!devm_request_mem_region(dev, res->start, res_size, res->name))
+		return -EBUSY;
+
+	ipmx->base = devm_ioremap_nocache(dev, res->start, res_size);
+	if (!ipmx->base)
+		return -EBUSY;
+
+	imx_pmx_desc_init(&imx_pmx_desc, info);
+	ret = imx_pmx_probe_dt(pdev, info);
+	if (ret) {
+		dev_err(&pdev->dev, "fail to probe dt properties\n");
+		return ret;
+	}
+
+	ipmx->info = info;
+	ipmx->dev = info->dev;
+	platform_set_drvdata(pdev, ipmx);
+	ipmx->pctl = pinctrl_register(&imx_pmx_desc, &pdev->dev, ipmx);
+	if (!ipmx->pctl) {
+		dev_err(&pdev->dev, "could not register IMX pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	dev_info(&pdev->dev, "initialized IMX pinctrl driver\n");
+
+	return 0;
+}
+
+static int __exit imx_pmx_remove(struct platform_device *pdev)
+{
+	struct imx_pmx *ipmx = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(ipmx->pctl);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver imx_pmx_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = imx_pmx_dt_ids,
+	},
+	.remove = __exit_p(imx_pmx_remove),
+};
+
+static int __init imx_pmx_init(void)
+{
+	return platform_driver_probe(&imx_pmx_driver, imx_pmx_probe);
+}
+arch_initcall(imx_pmx_init);
+
+static void __exit imx_pmx_exit(void)
+{
+	platform_driver_unregister(&imx_pmx_driver);
+}
+module_exit(imx_pmx_exit);
+
+MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
+MODULE_DESCRIPTION("IMX Pin Control Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/pinctrl-imx.h
new file mode 100644
index 0000000..09e651f
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-imx.h
@@ -0,0 +1,117 @@
+/*
+ * IMX pinmux core definitions
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DRIVERS_PINCTRL_PINMUX_IMX_H
+#define __DRIVERS_PINCTRL_PINMUX_IMX_H
+
+/* Supported Pinctrl type */
+enum imx_pinctrl_type {
+	IMX6Q_PINCTRL,
+};
+
+/**
+ * struct imx_pin_group - describes an IMX pin group
+ * @name: the name of this specific pin group
+ * @pins: an array of discrete physical pins used in this group, taken
+ *	from the driver-local pin enumeration space
+ * @num_pins: the number of pins in this group array, i.e. the number of
+ *	elements in .pins so we can iterate over that array
+ * @mux_mode: the mux mode for each pins in this group. The size of this
+ *	array is the same as pins.
+ * @config: contain the pin config value for this group
+ */
+struct imx_pin_group {
+	const char *name;
+	unsigned int *pins;
+	unsigned num_pins;
+	unsigned int *mux_mode;
+	unsigned config;
+};
+
+/**
+ * struct imx_pmx_func - describes IMX pinmux functions
+ * @name: the name of this specific function
+ * @groups: corresponding pin groups
+ */
+struct imx_pmx_func {
+	const char *name;
+	const char **groups;
+	unsigned num_groups;
+};
+
+/**
+ * struct imx_pin_reg - describe a pin reg map
+ * The last 3 members are used for select input setting
+ * @pid: pin id
+ * @mux_reg: mux register offset
+ * @conf_reg: config register offset
+ * @mux: mux mode
+ * @input_reg: select input register offset for this mux if any
+ *  0 if no select input setting needed.
+ * @input_val: the value set to select input register
+ */
+struct imx_pin_reg {
+	unsigned int pid;
+	unsigned int mux_reg;
+	unsigned int conf_reg;
+	unsigned int mux_mode;
+	unsigned int input_reg;
+	unsigned int input_val;
+};
+
+/*
+ * struct imx_config_properties - describes the available dt pin config properties
+ * @property: the property name of a config
+ * @off: the bit offset of this config in pin config register
+ */
+struct imx_config_properties {
+	const char *property;
+	const unsigned int off;
+	const unsigned int mask;
+};
+
+struct imx_pinctrl_info {
+	struct device *dev;
+	u32 type;
+	const struct pinctrl_pin_desc *pins;
+	unsigned int npins;
+	const struct imx_pin_reg *pin_regs;
+	unsigned int npin_regs;
+	const struct imx_config_properties *conf_properties;
+	unsigned int nconf_properties;
+	struct imx_pin_group *groups;
+	unsigned int ngroups;
+	struct imx_pmx_func *functions;
+	unsigned int nfunctions;
+};
+
+#define NO_MUX		0x0
+#define NO_PAD		0x0
+
+#define IMX_PIN_REG(id, conf, mux, mode, input, val)	\
+	{						\
+		.pid = id,				\
+		.conf_reg = conf,			\
+		.mux_reg = mux,				\
+		.mux_mode  = mode,			\
+		.input_reg = input,			\
+		.input_val = val,			\
+	}
+
+#define IMX_PINCTRL_PIN(pin) PINCTRL_PIN(pin, #pin)
+
+#define PAD_CTL_MASK(len)	((1 << len) - 1)
+#define IMX_MUX_MASK	0x7
+
+#endif /* __DRIVERS_PINCTRL_PINMUX_IMX_H */
-- 
1.7.0.4


