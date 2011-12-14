Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1LNPzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:55:10 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22887 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LNPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:55:06 -0500
X-SpamScore: 7
X-BigFish: VS7(zcb8kzzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
Subject: [RFC PATCH v2 3/4] ARM: imx6q: using pinmux subsystem
Date: Thu, 15 Dec 2011 00:03:41 +0800
Message-ID: <1323878622-26602-4-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323878622-26602-1-git-send-email-b29396@freescale.com>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shanw.guo@freescale.com>
---
 arch/arm/boot/dts/imx6q-sabreauto.dts |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/imx6q.dtsi          |    1 +
 arch/arm/mach-imx/Kconfig             |    1 +
 arch/arm/mach-imx/mach-imx6q.c        |    8 +++++++-
 4 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-sabreauto.dts b/arch/arm/boot/dts/imx6q-sabreauto.dts
index 072974e..1bd1ef9 100644
--- a/arch/arm/boot/dts/imx6q-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6q-sabreauto.dts
@@ -26,6 +26,28 @@
 	};
 
 	soc {
+		aips-bus@02000000 { /* AIPS1 */
+			iomuxc@020e0000 {
+				pinmux_uart4 {
+					func_name = "uart4";
+					grp_name = "uart4grp";
+					grp_pins = <107 108>;
+					num_pins = <2>;
+					grp_mux = <4 4>;
+					num_mux = <2>;
+				};
+
+				pinmux_sd4 {
+					func_name = "sd4";
+					grp_name = "sd4grp";
+					grp_pins = <170 171 180 181 182 183 184 185 186 187>;
+					num_pins = <10>;
+					grp_mux = <0 0 1 1 1 1 1 1 1 1>;
+					num_mux = <10>;
+				};
+			};
+		};
+
 		aips-bus@02100000 { /* AIPS2 */
 			enet@02188000 {
 				phy-mode = "rgmii";
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 7dda599..42499bb 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -386,6 +386,7 @@
 			};
 
 			iomuxc@020e0000 {
+				compatible = "fsl,imx6q-iomuxc";
 				reg = <0x020e0000 0x4000>;
 			};
 
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index c44aa97..1e0befa 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -602,6 +602,7 @@ config SOC_IMX6Q
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
+	select PINCTRL
 	select USE_OF
 
 	help
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 9cd860a..e12ae63 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/machine.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/hardware/gic.h>
 #include <asm/mach/arch.h>
@@ -23,10 +24,15 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 
+static struct pinmux_map imx6q_pinmux_map[] = {
+	PINMUX_MAP_PRIMARY("usdhc4", "sd4", "219c000.usdhc"),
+};
+
 static void __init imx6q_init_machine(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-
+	pinmux_register_mappings(imx6q_pinmux_map,
+				 ARRAY_SIZE(imx6q_pinmux_map));
 	imx6q_pm_init();
 }
 
-- 
1.7.0.4


