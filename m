Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1KAWPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 18:15:48 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38101 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259Ab1KAWPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 18:15:41 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, lm <linux-media@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH v3 2/4] OMAP4: hwmod data: add mmu hwmod for ipu and dsp
Date: Tue,  1 Nov 2011 17:15:50 -0500
Message-Id: <1320185752-568-3-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mmu hwmod data for ipu and dsp.

Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  154 +++++++++++++++++++++++++--
 1 files changed, 142 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 393afac..096b9a7 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -30,6 +30,7 @@
 #include <plat/mmc.h>
 #include <plat/i2c.h>
 #include <plat/dmtimer.h>
+#include <plat/iommu.h>
 
 #include "omap_hwmod_common_data.h"
 
@@ -1101,10 +1102,6 @@ static struct omap_hwmod_irq_info omap44xx_dsp_irqs[] = {
 	{ .irq = -1 }
 };
 
-static struct omap_hwmod_rst_info omap44xx_dsp_resets[] = {
-	{ .name = "mmu_cache", .rst_shift = 1 },
-};
-
 static struct omap_hwmod_rst_info omap44xx_dsp_c0_resets[] = {
 	{ .name = "dsp", .rst_shift = 0 },
 };
@@ -1156,8 +1153,6 @@ static struct omap_hwmod omap44xx_dsp_hwmod = {
 	.class		= &omap44xx_dsp_hwmod_class,
 	.clkdm_name	= "tesla_clkdm",
 	.mpu_irqs	= omap44xx_dsp_irqs,
-	.rst_lines	= omap44xx_dsp_resets,
-	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_dsp_resets),
 	.main_clk	= "dsp_fck",
 	.prcm = {
 		.omap4 = {
@@ -2507,10 +2502,6 @@ static struct omap_hwmod_rst_info omap44xx_ipu_c1_resets[] = {
 	{ .name = "cpu1", .rst_shift = 1 },
 };
 
-static struct omap_hwmod_rst_info omap44xx_ipu_resets[] = {
-	{ .name = "mmu_cache", .rst_shift = 2 },
-};
-
 /* ipu master ports */
 static struct omap_hwmod_ocp_if *omap44xx_ipu_masters[] = {
 	&omap44xx_ipu__l3_main_2,
@@ -2564,8 +2555,6 @@ static struct omap_hwmod omap44xx_ipu_hwmod = {
 	.class		= &omap44xx_ipu_hwmod_class,
 	.clkdm_name	= "ducati_clkdm",
 	.mpu_irqs	= omap44xx_ipu_irqs,
-	.rst_lines	= omap44xx_ipu_resets,
-	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_ipu_resets),
 	.main_clk	= "ipu_fck",
 	.prcm = {
 		.omap4 = {
@@ -3932,6 +3921,143 @@ static struct omap_hwmod omap44xx_mpu_hwmod = {
 };
 
 /*
+ * 'mmu' class
+ * The memory management unit performs virtual to physical address translation
+ * for its requestors.
+ */
+
+static struct omap_hwmod_class_sysconfig mmu_sysc = {
+	.rev_offs	= 0x000,
+	.sysc_offs	= 0x010,
+	.syss_offs	= 0x014,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap44xx_mmu_hwmod_class = {
+	.name = "mmu",
+	.sysc = &mmu_sysc,
+};
+
+/* ipu mmu */
+
+static struct omap_mmu_dev_attr ipu_mmu_dev_attr = {
+	.da_start = 0x0,
+	.da_end = 0xfffff000,
+	.nr_tlb_entries = 32,
+};
+
+static struct omap_hwmod omap44xx_ipu_mmu_hwmod;
+static struct omap_hwmod_irq_info omap44xx_ipu_mmu_irqs[] = {
+	{ .irq = 100 + OMAP44XX_IRQ_GIC_START, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_rst_info omap44xx_ipu_mmu_resets[] = {
+	{ .name = "mmu_cache", .rst_shift = 2 },
+};
+
+static struct omap_hwmod_addr_space omap44xx_ipu_mmu_addrs[] = {
+	{
+		.pa_start	= 0x55082000,
+		.pa_end		= 0x550820ff,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l3_main_1 -> ipu mmu */
+static struct omap_hwmod_ocp_if omap44xx_l3_main_1__ipu_mmu = {
+	.master		= &omap44xx_l3_main_1_hwmod,
+	.slave		= &omap44xx_ipu_mmu_hwmod,
+	.addr		= omap44xx_ipu_mmu_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* ipu mmu slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_ipu_mmu_slaves[] = {
+	&omap44xx_l3_main_1__ipu_mmu,
+};
+
+static struct omap_hwmod omap44xx_ipu_mmu_hwmod = {
+	.name		= "ipu_mmu",
+	.class		= &omap44xx_mmu_hwmod_class,
+	.mpu_irqs	= omap44xx_ipu_mmu_irqs,
+	.rst_lines	= omap44xx_ipu_mmu_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_ipu_mmu_resets),
+	.main_clk	= "ipu_fck",
+	.prcm = {
+		.omap4 = {
+			.rstctrl_offs = OMAP4_RM_DUCATI_RSTCTRL_OFFSET,
+		},
+	},
+	.dev_attr	= &ipu_mmu_dev_attr,
+	.slaves		= omap44xx_ipu_mmu_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_ipu_mmu_slaves),
+	.flags		= HWMOD_INIT_NO_RESET,
+};
+
+/* dsp mmu */
+
+static struct omap_mmu_dev_attr dsp_mmu_dev_attr = {
+	.da_start = 0x0,
+	.da_end = 0xfffff000,
+	.nr_tlb_entries = 32,
+};
+
+static struct omap_hwmod omap44xx_dsp_mmu_hwmod;
+static struct omap_hwmod_irq_info omap44xx_dsp_mmu_irqs[] = {
+	{ .irq = 28 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_rst_info omap44xx_dsp_mmu_resets[] = {
+	{ .name = "mmu_cache", .rst_shift = 1 },
+};
+
+static struct omap_hwmod_addr_space omap44xx_dsp_mmu_addrs[] = {
+	{
+		.pa_start	= 0x4a066000,
+		.pa_end		= 0x4a0660ff,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l3_main_1 -> dsp mmu */
+static struct omap_hwmod_ocp_if omap44xx_l3_main_1__dsp_mmu = {
+	.master		= &omap44xx_l3_main_1_hwmod,
+	.slave		= &omap44xx_dsp_mmu_hwmod,
+	.addr		= omap44xx_dsp_mmu_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* dsp mmu slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_dsp_mmu_slaves[] = {
+	&omap44xx_l3_main_1__dsp_mmu,
+};
+
+static struct omap_hwmod omap44xx_dsp_mmu_hwmod = {
+	.name		= "dsp_mmu",
+	.class		= &omap44xx_mmu_hwmod_class,
+	.mpu_irqs	= omap44xx_dsp_mmu_irqs,
+	.rst_lines	= omap44xx_dsp_mmu_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_dsp_mmu_resets),
+	.main_clk	= "dsp_fck",
+	.prcm = {
+		.omap4 = {
+			.rstctrl_offs = OMAP4_RM_TESLA_RSTCTRL_OFFSET,
+		},
+	},
+	.dev_attr	= &dsp_mmu_dev_attr,
+	.slaves		= omap44xx_dsp_mmu_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_dsp_mmu_slaves),
+	.flags		= HWMOD_INIT_NO_RESET,
+};
+
+/*
  * 'smartreflex' class
  * smartreflex module (monitor silicon performance and outputs a measure of
  * performance error)
@@ -5388,6 +5514,10 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	/* mpu class */
 	&omap44xx_mpu_hwmod,
 
+	/* mmu class */
+	&omap44xx_ipu_mmu_hwmod,
+	&omap44xx_dsp_mmu_hwmod,
+
 	/* smartreflex class */
 	&omap44xx_smartreflex_core_hwmod,
 	&omap44xx_smartreflex_iva_hwmod,
-- 
1.7.0.4

