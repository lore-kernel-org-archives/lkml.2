Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2ILTsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:48:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58001 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2ILTqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:46:07 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 3/9] ARM: OMAP4: hwmod data: add mmu hwmod for ipu and dsp
Date: Wed, 12 Sep 2012 14:45:46 -0500
Message-Id: <1347479152-588-4-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mmu hwmod data for ipu and dsp.

Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  136 +++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 242aee4..c2cf25a 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -31,6 +31,7 @@
 #include <plat/mmc.h>
 #include <plat/dmtimer.h>
 #include <plat/common.h>
+#include <plat/iommu.h>
 
 #include "omap_hwmod_common_data.h"
 #include "cm1_44xx.h"
@@ -612,7 +613,6 @@ static struct omap_hwmod_irq_info omap44xx_dsp_irqs[] = {
 
 static struct omap_hwmod_rst_info omap44xx_dsp_resets[] = {
 	{ .name = "dsp", .rst_shift = 0 },
-	{ .name = "mmu_cache", .rst_shift = 1 },
 };
 
 static struct omap_hwmod omap44xx_dsp_hwmod = {
@@ -1632,7 +1632,6 @@ static struct omap_hwmod_irq_info omap44xx_ipu_irqs[] = {
 static struct omap_hwmod_rst_info omap44xx_ipu_resets[] = {
 	{ .name = "cpu0", .rst_shift = 0 },
 	{ .name = "cpu1", .rst_shift = 1 },
-	{ .name = "mmu_cache", .rst_shift = 2 },
 };
 
 static struct omap_hwmod omap44xx_ipu_hwmod = {
@@ -2439,6 +2438,137 @@ static struct omap_hwmod omap44xx_mmc5_hwmod = {
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
+/* mmu ipu */
+
+static struct omap_mmu_dev_attr mmu_ipu_dev_attr = {
+	.da_start = 0x0,
+	.da_end = 0xfffff000,
+	.nr_tlb_entries = 32,
+};
+
+static struct omap_hwmod omap44xx_mmu_ipu_hwmod;
+static struct omap_hwmod_irq_info omap44xx_mmu_ipu_irqs[] = {
+	{ .irq = 100 + OMAP44XX_IRQ_GIC_START, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_rst_info omap44xx_mmu_ipu_resets[] = {
+	{ .name = "mmu_cache", .rst_shift = 2 },
+};
+
+static struct omap_hwmod_addr_space omap44xx_mmu_ipu_addrs[] = {
+	{
+		.pa_start	= 0x55082000,
+		.pa_end		= 0x550820ff,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l3_main_2 -> mmu_ipu */
+static struct omap_hwmod_ocp_if omap44xx_l3_main_2__mmu_ipu = {
+	.master		= &omap44xx_l3_main_2_hwmod,
+	.slave		= &omap44xx_mmu_ipu_hwmod,
+	.clk		= "l3_div_ck",
+	.addr		= omap44xx_mmu_ipu_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod omap44xx_mmu_ipu_hwmod = {
+	.name		= "mmu_ipu",
+	.class		= &omap44xx_mmu_hwmod_class,
+	.clkdm_name	= "ducati_clkdm",
+	.mpu_irqs	= omap44xx_mmu_ipu_irqs,
+	.rst_lines	= omap44xx_mmu_ipu_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_mmu_ipu_resets),
+	.main_clk	= "ducati_clk_mux_ck",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_DUCATI_DUCATI_CLKCTRL_OFFSET,
+			.rstctrl_offs = OMAP4_RM_DUCATI_RSTCTRL_OFFSET,
+			.context_offs = OMAP4_RM_DUCATI_DUCATI_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+	.dev_attr	= &mmu_ipu_dev_attr,
+};
+
+/* mmu dsp */
+
+static struct omap_mmu_dev_attr mmu_dsp_dev_attr = {
+	.da_start = 0x0,
+	.da_end = 0xfffff000,
+	.nr_tlb_entries = 32,
+};
+
+static struct omap_hwmod omap44xx_mmu_dsp_hwmod;
+static struct omap_hwmod_irq_info omap44xx_mmu_dsp_irqs[] = {
+	{ .irq = 28 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_rst_info omap44xx_mmu_dsp_resets[] = {
+	{ .name = "mmu_cache", .rst_shift = 1 },
+};
+
+static struct omap_hwmod_addr_space omap44xx_mmu_dsp_addrs[] = {
+	{
+		.pa_start	= 0x4a066000,
+		.pa_end		= 0x4a0660ff,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l4_cfg -> dsp */
+static struct omap_hwmod_ocp_if omap44xx_l4_cfg__mmu_dsp = {
+	.master		= &omap44xx_l4_cfg_hwmod,
+	.slave		= &omap44xx_mmu_dsp_hwmod,
+	.clk		= "l4_div_ck",
+	.addr		= omap44xx_mmu_dsp_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod omap44xx_mmu_dsp_hwmod = {
+	.name		= "mmu_dsp",
+	.class		= &omap44xx_mmu_hwmod_class,
+	.clkdm_name	= "tesla_clkdm",
+	.mpu_irqs	= omap44xx_mmu_dsp_irqs,
+	.rst_lines	= omap44xx_mmu_dsp_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_mmu_dsp_resets),
+	.main_clk	= "dpll_iva_m4x2_ck",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_TESLA_TESLA_CLKCTRL_OFFSET,
+			.rstctrl_offs = OMAP4_RM_TESLA_RSTCTRL_OFFSET,
+			.context_offs = OMAP4_RM_TESLA_TESLA_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+	.dev_attr	= &mmu_dsp_dev_attr,
+};
+
+/*
  * 'mpu' class
  * mpu sub-system
  */
@@ -6092,6 +6222,8 @@ static struct omap_hwmod_ocp_if *omap44xx_hwmod_ocp_ifs[] __initdata = {
 	&omap44xx_l4_per__mmc3,
 	&omap44xx_l4_per__mmc4,
 	&omap44xx_l4_per__mmc5,
+	&omap44xx_l3_main_2__mmu_ipu,
+	&omap44xx_l4_cfg__mmu_dsp,
 	&omap44xx_l3_main_2__ocmc_ram,
 	&omap44xx_l4_cfg__ocp2scp_usb_phy,
 	&omap44xx_mpu_private__prcm_mpu,
-- 
1.7.9.5

