Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2DZObP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:31:15 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:9338
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082Ab2DZObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:31:09 -0400
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275ch8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <cjb@laptop.org>, <b20223@freescale.com>
Subject: [PATCH v3 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl subsystem
Date: Thu, 26 Apr 2012 22:40:27 +0800
Message-ID: <1335451227-27709-4-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335451227-27709-1-git-send-email-b29396@freescale.com>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

This driver is shared between many platforms. Currently only imx6q has
pinctrl support, to avoid breaking other platforms that do not have pinctrl
support to run this driver, enable pinctrl dummy state for them before
they also convert to pinctrl subsystem.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
This patch depends on:
pinctrl: add pinctrl_provide_dummies interface for platforms to use
http://www.spinics.net/lists/arm-kernel/msg171538.html

ChangeLog v2->v3:
 * patch name updated.
   v1 name is ARM: imx6q: switch to use pinctrl driver
 * using pinctrl dummy state to avoid breaking other platforms to use this
   driver.

ChangeLog v1->v2:
 * using updated binding
---
 arch/arm/boot/dts/imx6q-arm2.dts               |    4 +++
 arch/arm/boot/dts/imx6q.dtsi                   |   32 ++++++++++++++++++++++++
 arch/arm/mach-imx/Kconfig                      |    2 +
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c |    2 +
 arch/arm/mach-imx/mach-cpuimx51.c              |    2 +
 arch/arm/mach-imx/mach-cpuimx51sd.c            |    2 +
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c       |    2 +
 arch/arm/mach-imx/mach-mx25_3ds.c              |    2 +
 arch/arm/mach-imx/mach-mx35_3ds.c              |    2 +
 arch/arm/mach-imx/mach-mx51_3ds.c              |    2 +
 arch/arm/mach-imx/mach-mx51_babbage.c          |    2 +
 arch/arm/mach-imx/mach-mx51_efikamx.c          |    2 +
 arch/arm/mach-imx/mach-mx51_efikasb.c          |    2 +
 arch/arm/mach-imx/mach-mx53_ard.c              |    2 +
 arch/arm/mach-imx/mach-mx53_evk.c              |    2 +
 arch/arm/mach-imx/mach-mx53_loco.c             |    2 +
 arch/arm/mach-imx/mach-mx53_smd.c              |    2 +
 arch/arm/mach-imx/mach-pcm043.c                |    2 +
 arch/arm/mach-imx/mach-vpr200.c                |    2 +
 drivers/mmc/host/sdhci-esdhc-imx.c             |    9 ++++++
 20 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-arm2.dts b/arch/arm/boot/dts/imx6q-arm2.dts
index ce1c823..34dd9cd 100644
--- a/arch/arm/boot/dts/imx6q-arm2.dts
+++ b/arch/arm/boot/dts/imx6q-arm2.dts
@@ -37,12 +37,16 @@
 				cd-gpios = <&gpio6 11 0>;
 				wp-gpios = <&gpio6 14 0>;
 				vmmc-supply = <&reg_3p3v>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_usdhc3_1>;
 				status = "okay";
 			};
 
 			usdhc@0219c000 { /* uSDHC4 */
 				fsl,card-wired;
 				vmmc-supply = <&reg_3p3v>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_usdhc4_1>;
 				status = "okay";
 			};
 
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 4905f51..a89f294 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -386,7 +386,39 @@
 			};
 
 			iomuxc@020e0000 {
+				compatible = "fsl,imx6q-iomuxc";
 				reg = <0x020e0000 0x4000>;
+
+				/* shared pinctrl settings */
+				usdhc3 {
+					pinctrl_usdhc3_1: usdhc3grp-1 {
+						fsl,pins = <1273 0x17059	/* MX6Q_PAD_SD3_CMD__USDHC3_CMD */
+							    1281 0x10059	/* MX6Q_PAD_SD3_CLK__USDHC3_CLK	*/
+							    1289 0x17059	/* MX6Q_PAD_SD3_DAT0__USDHC3_DAT0 */
+							    1297 0x17059	/* MX6Q_PAD_SD3_DAT1__USDHC3_DAT1 */
+							    1305 0x17059	/* MX6Q_PAD_SD3_DAT2__USDHC3_DAT2 */
+							    1312 0x17059	/* MX6Q_PAD_SD3_DAT3__USDHC3_DAT3 */
+							    1265 0x17059	/* MX6Q_PAD_SD3_DAT4__USDHC3_DAT4 */
+							    1257 0x17059	/* MX6Q_PAD_SD3_DAT5__USDHC3_DAT5 */
+							    1249 0x17059	/* MX6Q_PAD_SD3_DAT6__USDHC3_DAT6 */
+							    1241 0x17059>;	/* MX6Q_PAD_SD3_DAT7__USDHC3_DAT7 */
+					};
+				};
+
+				usdhc4 {
+					pinctrl_usdhc4_1: usdhc4grp-1 {
+						fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
+							    1392 0x10059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
+							    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
+							    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
+							    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
+							    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
+							    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
+							    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
+							    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
+							    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
+					};
+				};
 			};
 
 			dcic@020e4000 { /* DCIC1 */
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 7561eca..e0fc67c 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -842,6 +842,8 @@ config SOC_IMX6Q
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
 	select HAVE_SMP
+	select PINCTRL
+	select PINCTRL_IMX6Q
 	select USE_OF
 
 	help
diff --git a/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c b/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c
index fd8bf8a..12bbb62 100644
--- a/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c
+++ b/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c
@@ -25,6 +25,7 @@
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/leds.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <video/platform_lcd.h>
@@ -251,6 +252,7 @@ void __init eukrea_mbimxsd35_baseboard_init(void)
 			ARRAY_SIZE(eukrea_mbimxsd_pads)))
 		printk(KERN_ERR "error setting mbimxsd pads !\n");
 
+	pinctrl_provide_dummies();
 	imx35_add_imx_uart1(&uart_pdata);
 	imx35_add_ipu_core(&mx3_ipu_data);
 	imx35_add_mx3_sdc_fb(&mx3fb_pdata);
diff --git a/arch/arm/mach-imx/mach-cpuimx51.c b/arch/arm/mach-imx/mach-cpuimx51.c
index 944025d..2c67d7f 100644
--- a/arch/arm/mach-imx/mach-cpuimx51.c
+++ b/arch/arm/mach-imx/mach-cpuimx51.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
+#include <linux/pinctrl/machine.h>
 
 #include <mach/eukrea-baseboards.h>
 #include <mach/common.h>
@@ -243,6 +244,7 @@ static void __init eukrea_cpuimx51_init(void)
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx51_pads,
 					ARRAY_SIZE(eukrea_cpuimx51_pads));
 
+	pinctrl_provide_dummies();
 	imx51_add_imx_uart(0, &uart_pdata);
 	imx51_add_mxc_nand(&eukrea_cpuimx51_nand_board_info);
 
diff --git a/arch/arm/mach-imx/mach-cpuimx51sd.c b/arch/arm/mach-imx/mach-cpuimx51sd.c
index 9fbe923..5d5a872 100644
--- a/arch/arm/mach-imx/mach-cpuimx51sd.c
+++ b/arch/arm/mach-imx/mach-cpuimx51sd.c
@@ -25,6 +25,7 @@
 #include <linux/i2c-gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/can/platform/mcp251x.h>
+#include <linux/pinctrl/machine.h>
 
 #include <mach/eukrea-baseboards.h>
 #include <mach/common.h>
@@ -265,6 +266,7 @@ static void __init eukrea_cpuimx51sd_init(void)
 
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx51sd_pads,
 					ARRAY_SIZE(eukrea_cpuimx51sd_pads));
+	pinctrl_provide_dummies();
 
 #if defined(CONFIG_CPU_FREQ_IMX)
 	get_cpu_op = mx51_get_cpu_op;
diff --git a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
index 76a97a5..b90b795 100644
--- a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
+++ b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/platform_device.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
@@ -131,6 +132,7 @@ static void __init eukrea_cpuimx25_init(void)
 			ARRAY_SIZE(eukrea_cpuimx25_pads)))
 		printk(KERN_ERR "error setting cpuimx25 pads !\n");
 
+	pinctrl_provide_dummies();
 	imx25_add_imx_uart0(&uart_pdata);
 	imx25_add_mxc_nand(&eukrea_cpuimx25_nand_board_info);
 	imx25_add_imxdi_rtc(NULL);
diff --git a/arch/arm/mach-imx/mach-mx25_3ds.c b/arch/arm/mach-imx/mach-mx25_3ds.c
index f267342..347467c 100644
--- a/arch/arm/mach-imx/mach-mx25_3ds.c
+++ b/arch/arm/mach-imx/mach-mx25_3ds.c
@@ -29,6 +29,7 @@
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/usb/otg.h>
 
 #include <mach/hardware.h>
@@ -233,6 +234,7 @@ static void __init mx25pdk_init(void)
 	mxc_iomux_v3_setup_multiple_pads(mx25pdk_pads,
 			ARRAY_SIZE(mx25pdk_pads));
 
+	pinctrl_provide_dummies();
 	imx25_add_imx_uart0(&uart_pdata);
 	imx25_add_fsl_usb2_udc(&otg_device_pdata);
 	imx25_add_mxc_ehci_hs(&usbh2_pdata);
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 6ae51c6..b8cfc6a 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/memory.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/usb/otg.h>
 
 #include <linux/mtd/physmap.h>
@@ -380,6 +381,7 @@ static void __init mx35_3ds_init(void)
 
 	mxc_iomux_v3_setup_multiple_pads(mx35pdk_pads, ARRAY_SIZE(mx35pdk_pads));
 
+	pinctrl_provide_dummies();
 	imx35_add_fec(NULL);
 	imx35_add_imx2_wdt(NULL);
 	platform_add_devices(devices, ARRAY_SIZE(devices));
diff --git a/arch/arm/mach-imx/mach-mx51_3ds.c b/arch/arm/mach-imx/mach-mx51_3ds.c
index 83eab41..9a8a6f2 100644
--- a/arch/arm/mach-imx/mach-mx51_3ds.c
+++ b/arch/arm/mach-imx/mach-mx51_3ds.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -139,6 +140,7 @@ static void __init mx51_3ds_init(void)
 
 	mxc_iomux_v3_setup_multiple_pads(mx51_3ds_pads,
 					ARRAY_SIZE(mx51_3ds_pads));
+	pinctrl_provide_dummies();
 
 	imx51_add_imx_uart(0, &uart_pdata);
 	imx51_add_imx_uart(1, &uart_pdata);
diff --git a/arch/arm/mach-imx/mach-mx51_babbage.c b/arch/arm/mach-imx/mach-mx51_babbage.c
index e4b822e..9adc94b 100644
--- a/arch/arm/mach-imx/mach-mx51_babbage.c
+++ b/arch/arm/mach-imx/mach-mx51_babbage.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/input.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/spi/flash.h>
 #include <linux/spi/spi.h>
 
@@ -353,6 +354,7 @@ void __init imx51_babbage_common_init(void)
 {
 	mxc_iomux_v3_setup_multiple_pads(mx51babbage_pads,
 					 ARRAY_SIZE(mx51babbage_pads));
+	pinctrl_provide_dummies();
 }
 
 /*
diff --git a/arch/arm/mach-imx/mach-mx51_efikamx.c b/arch/arm/mach-imx/mach-mx51_efikamx.c
index 586e9f8..8486569 100644
--- a/arch/arm/mach-imx/mach-mx51_efikamx.c
+++ b/arch/arm/mach-imx/mach-mx51_efikamx.c
@@ -22,6 +22,7 @@
 #include <linux/input.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/spi/flash.h>
 #include <linux/spi/spi.h>
 #include <linux/mfd/mc13892.h>
@@ -237,6 +238,7 @@ static void __init mx51_efikamx_init(void)
 
 	mxc_iomux_v3_setup_multiple_pads(mx51efikamx_pads,
 					ARRAY_SIZE(mx51efikamx_pads));
+	pinctrl_provide_dummies();
 	efika_board_common_init();
 
 	mx51_efikamx_board_id();
diff --git a/arch/arm/mach-imx/mach-mx51_efikasb.c b/arch/arm/mach-imx/mach-mx51_efikasb.c
index 24aded9..dfd9952 100644
--- a/arch/arm/mach-imx/mach-mx51_efikasb.c
+++ b/arch/arm/mach-imx/mach-mx51_efikasb.c
@@ -22,6 +22,7 @@
 #include <linux/input.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/spi/flash.h>
 #include <linux/spi/spi.h>
 #include <linux/mfd/mc13892.h>
@@ -260,6 +261,7 @@ static void __init efikasb_board_init(void)
 
 	mxc_iomux_v3_setup_multiple_pads(mx51efikasb_pads,
 					ARRAY_SIZE(mx51efikasb_pads));
+	pinctrl_provide_dummies();
 	efika_board_common_init();
 
 	mx51_efikasb_board_id();
diff --git a/arch/arm/mach-imx/mach-mx53_ard.c b/arch/arm/mach-imx/mach-mx53_ard.c
index 0564198..d251da4 100644
--- a/arch/arm/mach-imx/mach-mx53_ard.c
+++ b/arch/arm/mach-imx/mach-mx53_ard.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/smsc911x.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
@@ -226,6 +227,7 @@ void __init imx53_ard_common_init(void)
 	mxc_iomux_v3_setup_multiple_pads(mx53_ard_pads,
 					 ARRAY_SIZE(mx53_ard_pads));
 	weim_cs_config();
+	pinctrl_provide_dummies();
 }
 
 static struct platform_device *devices[] __initdata = {
diff --git a/arch/arm/mach-imx/mach-mx53_evk.c b/arch/arm/mach-imx/mach-mx53_evk.c
index 5a72188..9ca7010 100644
--- a/arch/arm/mach-imx/mach-mx53_evk.c
+++ b/arch/arm/mach-imx/mach-mx53_evk.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/spi/flash.h>
 #include <linux/spi/spi.h>
 #include <mach/common.h>
@@ -134,6 +135,7 @@ void __init imx53_evk_common_init(void)
 {
 	mxc_iomux_v3_setup_multiple_pads(mx53_evk_pads,
 					 ARRAY_SIZE(mx53_evk_pads));
+	pinctrl_provide_dummies();
 }
 
 static void __init mx53_evk_board_init(void)
diff --git a/arch/arm/mach-imx/mach-mx53_loco.c b/arch/arm/mach-imx/mach-mx53_loco.c
index 37f67ca..4c11cc1 100644
--- a/arch/arm/mach-imx/mach-mx53_loco.c
+++ b/arch/arm/mach-imx/mach-mx53_loco.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
+#include <linux/pinctrl/machine.h>
 
 #include <mach/common.h>
 #include <mach/hardware.h>
@@ -266,6 +267,7 @@ void __init imx53_qsb_common_init(void)
 {
 	mxc_iomux_v3_setup_multiple_pads(mx53_loco_pads,
 					 ARRAY_SIZE(mx53_loco_pads));
+	pinctrl_provide_dummies();
 }
 
 static struct i2c_board_info mx53loco_i2c_devices[] = {
diff --git a/arch/arm/mach-imx/mach-mx53_smd.c b/arch/arm/mach-imx/mach-mx53_smd.c
index 8e972c5..d621022 100644
--- a/arch/arm/mach-imx/mach-mx53_smd.c
+++ b/arch/arm/mach-imx/mach-mx53_smd.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 
 #include <mach/common.h>
 #include <mach/hardware.h>
@@ -128,6 +129,7 @@ void __init imx53_smd_common_init(void)
 {
 	mxc_iomux_v3_setup_multiple_pads(mx53_smd_pads,
 					 ARRAY_SIZE(mx53_smd_pads));
+	pinctrl_provide_dummies();
 }
 
 static void __init mx53_smd_board_init(void)
diff --git a/arch/arm/mach-imx/mach-pcm043.c b/arch/arm/mach-imx/mach-pcm043.c
index 237474f..c0ec1b8 100644
--- a/arch/arm/mach-imx/mach-pcm043.c
+++ b/arch/arm/mach-imx/mach-pcm043.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
 
@@ -361,6 +362,7 @@ static void __init pcm043_init(void)
 
 	mxc_iomux_v3_setup_multiple_pads(pcm043_pads, ARRAY_SIZE(pcm043_pads));
 
+	pinctrl_provide_dummies();
 	imx35_add_fec(NULL);
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 	imx35_add_imx2_wdt(NULL);
diff --git a/arch/arm/mach-imx/mach-vpr200.c b/arch/arm/mach-imx/mach-vpr200.c
index 033257e..cf9afcb 100644
--- a/arch/arm/mach-imx/mach-vpr200.c
+++ b/arch/arm/mach-imx/mach-vpr200.c
@@ -23,6 +23,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/memory.h>
 #include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -271,6 +272,7 @@ static void __init vpr200_board_init(void)
 
 	mxc_iomux_v3_setup_multiple_pads(vpr200_pads, ARRAY_SIZE(vpr200_pads));
 
+	pinctrl_provide_dummies();
 	imx35_add_fec(NULL);
 	imx35_add_imx2_wdt(NULL);
 	imx_add_gpio_keys(&vpr200_gpio_keys_data);
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 6193a0d..039bc19 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
 #include <mach/esdhc.h>
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
@@ -68,6 +69,7 @@ struct pltfm_imx_data {
 	int flags;
 	u32 scratchpad;
 	enum imx_esdhc_type devtype;
+	struct pinctrl *pinctrl;
 	struct esdhc_platform_data boarddata;
 };
 
@@ -467,6 +469,12 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	clk_prepare_enable(clk);
 	pltfm_host->clk = clk;
 
+	imx_data->pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(imx_data->pinctrl)) {
+		err = PTR_ERR(imx_data->pinctrl);
+		goto pin_err;
+	}
+
 	if (!is_imx25_esdhc(imx_data))
 		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
@@ -559,6 +567,7 @@ no_card_detect_irq:
 		gpio_free(boarddata->wp_gpio);
 no_card_detect_pin:
 no_board_data:
+pin_err:
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 err_clk_get:
-- 
1.7.0.4


