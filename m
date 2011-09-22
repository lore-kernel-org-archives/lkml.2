Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1IVN1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:27:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48016 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1IVN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:27:07 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <aneesh@ti.com>, <khilman@ti.com>,
        <santosh.shilimkar@ti.com>, <christian.gmeiner@gmail.com>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v4 1/3] AM35x: Using OMAP3 generic hwmods
Date: Thu, 22 Sep 2011 18:56:31 +0530
Message-ID: <1316697993-696-2-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1316697993-696-1-git-send-email-abhilash.kv@ti.com>
References: <1316697993-696-1-git-send-email-abhilash.kv@ti.com>
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
 arch/arm/mach-omap2/omap_hwmod.c             |    2 ++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |   18 ++++++++++++++++++
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    3 +++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 15f91c4..6a6e2cc 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -240,6 +240,16 @@ static struct map_desc omap44xx_io_desc[] __initdata = {
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
@@ -432,6 +442,7 @@ void __init omap3630_init_early(void)
 
 void __init am35xx_init_early(void)
 {
+	omap2_disable_unused_hwmods(am3517_unused_hwmods);
 	omap2_init_common_infrastructure();
 }
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index d713807..c7b0395 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -1954,6 +1954,8 @@ int __init omap_hwmod_register(struct omap_hwmod **ohs)
 
 	i = 0;
 	do {
+		if (ohs[i]->flags & HWMOD_UNUSED)
+			continue;
 		r = _register(ohs[i]);
 		WARN(r, "omap_hwmod: %s: _register returned %d\n", ohs[i]->name,
 		     r);
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 3008e16..682171c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3259,6 +3259,24 @@ static __initdata struct omap_hwmod *am35xx_hwmods[] = {
 	NULL
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
 	int r;
diff --git a/arch/arm/plat-omap/include/plat/omap_hwmod.h b/arch/arm/plat-omap/include/plat/omap_hwmod.h
index 5419f1a..96650f3 100644
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
@@ -612,5 +614,6 @@ extern int omap2420_hwmod_init(void);
 extern int omap2430_hwmod_init(void);
 extern int omap3xxx_hwmod_init(void);
 extern int omap44xx_hwmod_init(void);
+extern void omap2_disable_unused_hwmods(char *unused_hwmods[]);
 
 #endif
-- 
1.7.1

