Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab2HVHib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:38:31 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:5991
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757671Ab2HVHi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:38:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah107ah1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>,
        <paul.liu@linaro.org>
Subject: [PATCH 5/7] ARM: imx6q: convert to use imx-syscon to access anatop registers
Date: Wed, 22 Aug 2012 15:18:46 +0800
Message-ID: <1345619928-15446-6-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345619928-15446-1-git-send-email-b29396@freescale.com>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Using standard imx syscon API to access anatop registers.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 arch/arm/mach-imx/Kconfig      |    2 +-
 arch/arm/mach-imx/mach-imx6q.c |   25 ++++++-------------------
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index afd542a..c7b2adb 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -839,7 +839,7 @@ config SOC_IMX6Q
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
 	select HAVE_SMP
-	select MFD_ANATOP
+	select MFD_IMX_SYSCON
 	select PINCTRL
 	select PINCTRL_IMX6Q
 
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 5ec0608..32a9c9e 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -24,8 +24,9 @@
 #include <linux/of_platform.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/phy.h>
+#include <linux/regmap.h>
 #include <linux/micrel_phy.h>
-#include <linux/mfd/anatop.h>
+#include <linux/mfd/imx-syscon.h>
 #include <asm/cpuidle.h>
 #include <asm/smp_twd.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -121,20 +122,8 @@ static void __init imx6q_sabrelite_init(void)
 static void __init imx6q_usb_init(void)
 {
 	struct device_node *np;
-	struct platform_device *pdev = NULL;
-	struct anatop *adata = NULL;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
-	if (np)
-		pdev = of_find_device_by_node(np);
-	if (pdev)
-		adata = platform_get_drvdata(pdev);
-	if (!adata) {
-		if (np)
-			of_node_put(np);
-		return;
-	}
-
 #define HW_ANADIG_USB1_CHRG_DETECT		0x000001b0
 #define HW_ANADIG_USB2_CHRG_DETECT		0x00000210
 
@@ -145,14 +134,12 @@ static void __init imx6q_usb_init(void)
 	 * The external charger detector needs to be disabled,
 	 * or the signal at DP will be poor
 	 */
-	anatop_write_reg(adata, HW_ANADIG_USB1_CHRG_DETECT,
+	imx_syscon_write(np, HW_ANADIG_USB1_CHRG_DETECT,
 			BM_ANADIG_USB_CHRG_DETECT_EN_B
-			| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
-			~0);
-	anatop_write_reg(adata, HW_ANADIG_USB2_CHRG_DETECT,
+			| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
+	imx_syscon_write(np, HW_ANADIG_USB2_CHRG_DETECT,
 			BM_ANADIG_USB_CHRG_DETECT_EN_B |
-			BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
-			~0);
+			BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
 
 	of_node_put(np);
 }
-- 
1.7.0.4


