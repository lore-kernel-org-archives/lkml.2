Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1IHMEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:04:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57335 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab1IHMEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:04:51 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <khilman@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v3 1/2] AM35x: Using OMAP3 generic hwmods
Date: Thu, 8 Sep 2011 17:34:40 +0530
Message-ID: <1315483480-17505-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables AM35x SoCs to use generic OMAP3 hwmods
(i,e. omap3xxx_hwmods) by allowing am35xx_init_early() to
disable the modules which are not present in AM3517.

Reviewed-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/io.c                     |   11 +++++++++++
 arch/arm/mach-omap2/omap_hwmod.c             |    3 ++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |   18 ++++++++++++++++++
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    3 +++
 4 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 132724c..135e894 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -239,6 +239,16 @@ static struct map_desc omap44xx_io_desc[] __initdata = {
 };
 #endif
 
+static char *am3517_unused_hwmods[] = {
+	"iva",
+	"sr1_hwmod",
+	"sr2_hwmod",
+	"mailbox",
+	"usb_otg_hs",
+	NULL,
+};
+
+
 static void __init _omap2_map_common_io(void)
 {
 	/* Normally devicemaps_init() would flush caches and tlb after
@@ -427,6 +437,7 @@ void __init omap3630_init_early(void)
 
 void __init am35xx_init_early(void)
 {
+	omap2_disable_unused_hwmods(am3517_unused_hwmods);
 	omap2_init_common_infrastructure();
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

