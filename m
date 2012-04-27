Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2D0MRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:17:12 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:59369 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757434Ab2D0MRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:17:08 -0400
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275ch8275bh8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>
Subject: [PATCH v4 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl subsystem
Date: Fri, 27 Apr 2012 20:26:18 +0800
Message-ID: <1335529578-14507-4-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335529578-14507-1-git-send-email-b29396@freescale.com>
References: <1335529578-14507-1-git-send-email-b29396@freescale.com>
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

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
This patch depends on:
pinctrl: add pinctrl_provide_dummies interface for platforms to use
http://www.spinics.net/lists/arm-kernel/msg171538.html

ChangeLog v3->v4:
 * call provide dummies in imx*_soc_init().
ChangeLog v2->v3:
 * patch name updated.
   v1 name is ARM: imx6q: switch to use pinctrl driver
 * using pinctrl dummy state to avoid breaking other platforms to use this
   driver.
ChangeLog v1->v2:
 * using updated binding

Signed-off-by: Dong Aisheng <b29396@freescale.com>
---
 arch/arm/boot/dts/imx6q-arm2.dts   |    4 ++++
 arch/arm/boot/dts/imx6q.dtsi       |   32 ++++++++++++++++++++++++++++++++
 arch/arm/mach-imx/Kconfig          |    2 ++
 arch/arm/mach-imx/imx51-dt.c       |    3 +++
 arch/arm/mach-imx/imx53-dt.c       |    3 +++
 arch/arm/mach-imx/mm-imx1.c        |    2 ++
 arch/arm/mach-imx/mm-imx21.c       |    2 ++
 arch/arm/mach-imx/mm-imx25.c       |    2 ++
 arch/arm/mach-imx/mm-imx27.c       |    2 ++
 arch/arm/mach-imx/mm-imx3.c        |    2 ++
 arch/arm/mach-imx/mm-imx5.c        |    2 ++
 drivers/mmc/host/sdhci-esdhc-imx.c |    9 +++++++++
 12 files changed, 65 insertions(+), 0 deletions(-)

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
diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index 5cca573..5f577fb 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -14,6 +14,7 @@
 #include <linux/irqdomain.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/machine.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 #include <mach/common.h>
@@ -81,6 +82,8 @@ static void __init imx51_dt_init(void)
 
 	of_irq_init(imx51_irq_match);
 
+	pinctrl_provide_dummies();
+
 	node = of_find_matching_node(NULL, imx51_iomuxc_of_match);
 	if (node) {
 		of_id = of_match_node(imx51_iomuxc_of_match, node);
diff --git a/arch/arm/mach-imx/imx53-dt.c b/arch/arm/mach-imx/imx53-dt.c
index 4172279..574eca4 100644
--- a/arch/arm/mach-imx/imx53-dt.c
+++ b/arch/arm/mach-imx/imx53-dt.c
@@ -15,6 +15,7 @@
 #include <linux/irqdomain.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/machine.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 #include <mach/common.h>
@@ -88,6 +89,8 @@ static void __init imx53_dt_init(void)
 
 	of_irq_init(imx53_irq_match);
 
+	pinctrl_provide_dummies();
+
 	node = of_find_matching_node(NULL, imx53_iomuxc_of_match);
 	if (node) {
 		of_id = of_match_node(imx53_iomuxc_of_match, node);
diff --git a/arch/arm/mach-imx/mm-imx1.c b/arch/arm/mach-imx/mm-imx1.c
index 2bded59..fcafd3d 100644
--- a/arch/arm/mach-imx/mm-imx1.c
+++ b/arch/arm/mach-imx/mm-imx1.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/mach/map.h>
 
@@ -58,4 +59,5 @@ void __init imx1_soc_init(void)
 						MX1_GPIO_INT_PORTC, 0);
 	mxc_register_gpio("imx1-gpio", 3, MX1_GPIO4_BASE_ADDR, SZ_256,
 						MX1_GPIO_INT_PORTD, 0);
+	pinctrl_provide_dummies();
 }
diff --git a/arch/arm/mach-imx/mm-imx21.c b/arch/arm/mach-imx/mm-imx21.c
index 14d540e..5f43905 100644
--- a/arch/arm/mach-imx/mm-imx21.c
+++ b/arch/arm/mach-imx/mm-imx21.c
@@ -20,6 +20,7 @@
 
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/pinctrl/machine.h>
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/devices-common.h>
@@ -88,6 +89,7 @@ void __init imx21_soc_init(void)
 	mxc_register_gpio("imx21-gpio", 4, MX21_GPIO5_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
 	mxc_register_gpio("imx21-gpio", 5, MX21_GPIO6_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
 
+	pinctrl_provide_dummies();
 	imx_add_imx_dma();
 	platform_device_register_simple("imx21-audmux", 0, imx21_audmux_res,
 					ARRAY_SIZE(imx21_audmux_res));
diff --git a/arch/arm/mach-imx/mm-imx25.c b/arch/arm/mach-imx/mm-imx25.c
index 153b457..6ff3714 100644
--- a/arch/arm/mach-imx/mm-imx25.c
+++ b/arch/arm/mach-imx/mm-imx25.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
@@ -95,6 +96,7 @@ void __init imx25_soc_init(void)
 	mxc_register_gpio("imx31-gpio", 2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
 	mxc_register_gpio("imx31-gpio", 3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
 
+	pinctrl_provide_dummies();
 	/* i.mx25 has the i.mx35 type sdma */
 	imx_add_imx_sdma("imx35-sdma", MX25_SDMA_BASE_ADDR, MX25_INT_SDMA, &imx25_sdma_pdata);
 	/* i.mx25 has the i.mx31 type audmux */
diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
index 8cb3f5e..2566255 100644
--- a/arch/arm/mach-imx/mm-imx27.c
+++ b/arch/arm/mach-imx/mm-imx27.c
@@ -20,6 +20,7 @@
 
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/pinctrl/machine.h>
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/devices-common.h>
@@ -89,6 +90,7 @@ void __init imx27_soc_init(void)
 	mxc_register_gpio("imx21-gpio", 4, MX27_GPIO5_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
 	mxc_register_gpio("imx21-gpio", 5, MX27_GPIO6_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
 
+	pinctrl_provide_dummies();
 	imx_add_imx_dma();
 	/* imx27 has the imx21 type audmux */
 	platform_device_register_simple("imx21-audmux", 0, imx27_audmux_res,
diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
index 7412738..9128d15 100644
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/pgtable.h>
 #include <asm/system_misc.h>
@@ -267,6 +268,7 @@ void __init imx35_soc_init(void)
 	mxc_register_gpio("imx31-gpio", 1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
 	mxc_register_gpio("imx31-gpio", 2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
 
+	pinctrl_provide_dummies();
 	if (to_version == 1) {
 		strncpy(imx35_sdma_pdata.fw_name, "sdma-imx35-to1.bin",
 			strlen(imx35_sdma_pdata.fw_name));
diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
index 05250ae..99de414 100644
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/clk.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/system_misc.h>
 #include <asm/mach/map.h>
@@ -223,6 +224,7 @@ void __init imx53_soc_init(void)
 	mxc_register_gpio("imx31-gpio", 5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
 	mxc_register_gpio("imx31-gpio", 6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
 
+	pinctrl_provide_dummies();
 	/* i.mx53 has the i.mx35 type sdma */
 	imx_add_imx_sdma("imx35-sdma", MX53_SDMA_BASE_ADDR, MX53_INT_SDMA, &imx53_sdma_pdata);
 
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


