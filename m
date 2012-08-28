Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2H1JbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 05:31:07 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:24109 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab2H1Jaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 05:30:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz154dMzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: [PATCH v3 5/7] ARM: imx6q: convert to use syscon to access anatop registers
Date: Tue, 28 Aug 2012 17:10:03 +0800
Message-ID: <1346145005-17961-6-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346145005-17961-1-git-send-email-b29396@freescale.com>
References: <1346145005-17961-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Using syscon to access anatop registers.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog v2->v3:
 * remove a few unneed codes
ChangeLog v1->v2:
 * update to use generic regmap api
---
 arch/arm/mach-imx/Kconfig      |    2 +-
 arch/arm/mach-imx/mach-imx6q.c |   47 +++++++++++++++------------------------
 2 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index afd542a..7bba253 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -839,7 +839,7 @@ config SOC_IMX6Q
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
 	select HAVE_SMP
-	select MFD_ANATOP
+	select MFD_SYSCON
 	select PINCTRL
 	select PINCTRL_IMX6Q
 
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 045b3f6..eaf56b4 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -24,8 +24,9 @@
 #include <linux/of_platform.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/phy.h>
+#include <linux/regmap.h>
 #include <linux/micrel_phy.h>
-#include <linux/mfd/anatop.h>
+#include <linux/mfd/syscon.h>
 #include <asm/cpuidle.h>
 #include <asm/smp_twd.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -120,20 +121,7 @@ static void __init imx6q_sabrelite_init(void)
 
 static void __init imx6q_usb_init(void)
 {
-	struct device_node *np;
-	struct platform_device *pdev = NULL;
-	struct anatop *adata = NULL;
-
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
-	if (np)
-		pdev = of_find_device_by_node(np);
-	if (pdev)
-		adata = platform_get_drvdata(pdev);
-	if (!adata) {
-		if (np)
-			of_node_put(np);
-		return;
-	}
+	struct regmap *anatop;
 
 #define HW_ANADIG_USB1_CHRG_DETECT		0x000001b0
 #define HW_ANADIG_USB2_CHRG_DETECT		0x00000210
@@ -141,20 +129,21 @@ static void __init imx6q_usb_init(void)
 #define BM_ANADIG_USB_CHRG_DETECT_EN_B		0x00100000
 #define BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B	0x00080000
 
-	/*
-	 * The external charger detector needs to be disabled,
-	 * or the signal at DP will be poor
-	 */
-	anatop_write_reg(adata, HW_ANADIG_USB1_CHRG_DETECT,
-			BM_ANADIG_USB_CHRG_DETECT_EN_B
-			| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
-			~0);
-	anatop_write_reg(adata, HW_ANADIG_USB2_CHRG_DETECT,
-			BM_ANADIG_USB_CHRG_DETECT_EN_B |
-			BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
-			~0);
-
-	of_node_put(np);
+	anatop = syscon_regmap_lookup_by_compatible("fsl,imx6q-anatop");
+	if (!IS_ERR(anatop)) {
+		/*
+		 * The external charger detector needs to be disabled,
+		 * or the signal at DP will be poor
+		 */
+		regmap_write(anatop, HW_ANADIG_USB1_CHRG_DETECT,
+				BM_ANADIG_USB_CHRG_DETECT_EN_B
+				| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
+		regmap_write(anatop, HW_ANADIG_USB2_CHRG_DETECT,
+				BM_ANADIG_USB_CHRG_DETECT_EN_B |
+				BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
+	} else {
+		pr_warn("failed to find fsl,imx6q-anatop regmap\n");
+	}
 }
 
 static void __init imx6q_init_machine(void)
-- 
1.7.0.4


