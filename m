Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1HWNVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:21:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50866 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab1HWNV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:21:27 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v2 1/2] AM35x: Using OMAP3 generic hwmods
Date: Tue, 23 Aug 2011 18:51:13 +0530
Message-ID: <1314105673-17390-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables AM35x SoCs to use generic OMAP3 hwmods
(i,e. omap3xxx_hwmods) by allowing board-am3517evm.c to
disable the modules which are not present in AM3517.

Reviewed-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/board-am3517evm.c        |   11 +++++++++++
 arch/arm/mach-omap2/omap_hwmod.c             |    3 ++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |   18 ++++++++++++++++++
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    3 +++
 4 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index f3006c3..8a5f232 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -34,6 +34,7 @@
 #include <plat/board.h>
 #include <plat/common.h>
 #include <plat/usb.h>
+#include <plat/omap_hwmod.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-generic-dpi.h>
 
@@ -359,11 +360,21 @@ static struct omap_dss_board_info am3517_evm_dss_data = {
 	.default_device	= &am3517_evm_lcd_device,
 };
 
+static char *am3517_unused_hwmods[] = {
+	"iva",
+	"sr1_hwmod",
+	"sr2_hwmod",
+	"mailbox",
+	"usb_otg_hs",
+	NULL,
+};
+
 /*
  * Board initialization
  */
 static void __init am3517_evm_init_early(void)
 {
+	omap2_disable_unused_hwmods(am3517_unused_hwmods);
 	omap2_init_common_infrastructure();
 	omap2_init_common_devices(NULL, NULL);
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 84cc0bd..bb765b5 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -1954,7 +1954,8 @@ int __init omap_hwmod_register(struct omap_hwmod **ohs)
 
 	i = 0;
 	do {
-		if (!omap_chip_is(ohs[i]->omap_chip))
+		if (!omap_chip_is(ohs[i]->omap_chip)
+			|| (ohs[i]->flags & HWMOD_UNUSED))
 			continue;
 
 		r = _register(ohs[i]);
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 25bf43b..5c282bb 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3281,6 +3281,24 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	NULL,
 };
 
+void __init omap2_disable_unused_hwmods(char *unused_hwmods[])
+{
+	int index;
+
+	for (index = 0; omap3xxx_hwmods[index]; index++) {
+		char **hwmods = unused_hwmods;
+		while (*hwmods) {
+			if (strcmp(omap3xxx_hwmods[index]->name,
+					*hwmods) == 0) {
+				omap3xxx_hwmods[index]->flags
+							= HWMOD_UNUSED;
+				break;
+			}
+			hwmods++;
+		}
+	}
+}
+
 int __init omap3xxx_hwmod_init(void)
 {
 	return omap_hwmod_register(omap3xxx_hwmods);
diff --git a/arch/arm/plat-omap/include/plat/omap_hwmod.h b/arch/arm/plat-omap/include/plat/omap_hwmod.h
index 0e329ca..490a95a 100644
--- a/arch/arm/plat-omap/include/plat/omap_hwmod.h
+++ b/arch/arm/plat-omap/include/plat/omap_hwmod.h
@@ -398,6 +398,7 @@ struct omap_hwmod_omap4_prcm {
  *     in order to complete the reset. Optional clocks will be disabled
  *     again after the reset.
  * HWMOD_16BIT_REG: Module has 16bit registers
+ * HWMOD_UNUSED: The IP for this module is unused or disabled on current SoC
  */
 #define HWMOD_SWSUP_SIDLE			(1 << 0)
 #define HWMOD_SWSUP_MSTANDBY			(1 << 1)
@@ -408,6 +409,7 @@ struct omap_hwmod_omap4_prcm {
 #define HWMOD_NO_IDLEST				(1 << 6)
 #define HWMOD_CONTROL_OPT_CLKS_IN_RESET		(1 << 7)
 #define HWMOD_16BIT_REG				(1 << 8)
+#define HWMOD_UNUSED				(1 << 9)
 
 /*
  * omap_hwmod._int_flags definitions
@@ -615,5 +617,6 @@ extern int omap2420_hwmod_init(void);
 extern int omap2430_hwmod_init(void);
 extern int omap3xxx_hwmod_init(void);
 extern int omap44xx_hwmod_init(void);
+extern void omap2_disable_unused_hwmods(char *unused_hwmods[]);
 
 #endif
-- 
1.7.1

