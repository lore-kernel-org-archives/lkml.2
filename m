Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2ILTsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:48:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58001 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2ILTqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:46:04 -0400
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
Subject: [PATCH v2 2/9] ARM: OMAP3: hwmod data: add mmu data for iva and isp
Date: Wed, 12 Sep 2012 14:45:45 -0500
Message-Id: <1347479152-588-3-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mmu hwmod data for iva and isp.

Due to compatibility an ifdef CONFIG_OMAP_IOMMU_IVA2 needs to be
propagated (previously on iommu resource info) to hwmod data in OMAP3,
so users of iommu and tidspbridge can avoid issues of two modules
managing mmu data/irqs/resets; this until tidspbridge can be migrated
to iommu framework.

Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  121 ++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/iommu.h    |   13 +++
 2 files changed, 134 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index c9e3820..70f14f9 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -29,6 +29,7 @@
 #include <plat/mcbsp.h>
 #include <plat/mcspi.h>
 #include <plat/dmtimer.h>
+#include <plat/iommu.h>
 
 #include "omap_hwmod_common_data.h"
 #include "prm-regbits-34xx.h"
@@ -2814,6 +2815,122 @@ static struct omap_hwmod_ocp_if omap3xxx_l4_per__gpio3 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/*
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
+static struct omap_hwmod_class omap3xxx_mmu_hwmod_class = {
+	.name = "mmu",
+	.sysc = &mmu_sysc,
+};
+
+/* mmu isp */
+
+static struct omap_mmu_dev_attr mmu_isp_dev_attr = {
+	.da_start = 0x0,
+	.da_end = 0xfffff000,
+	.nr_tlb_entries = 8,
+};
+
+static struct omap_hwmod omap3xxx_mmu_isp_hwmod;
+static struct omap_hwmod_irq_info omap3xxx_mmu_isp_irqs[] = {
+	{ .irq = 24 },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_addr_space omap3xxx_mmu_isp_addrs[] = {
+	{
+		.pa_start	= 0x480bd400,
+		.pa_end		= 0x480bd47f,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l4_core -> mmu isp */
+static struct omap_hwmod_ocp_if omap3xxx_l4_core__mmu_isp = {
+	.master		= &omap3xxx_l4_core_hwmod,
+	.slave		= &omap3xxx_mmu_isp_hwmod,
+	.addr		= omap3xxx_mmu_isp_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod omap3xxx_mmu_isp_hwmod = {
+	.name		= "mmu_isp",
+	.class		= &omap3xxx_mmu_hwmod_class,
+	.mpu_irqs	= omap3xxx_mmu_isp_irqs,
+	.main_clk	= "cam_ick",
+	.dev_attr	= &mmu_isp_dev_attr,
+	.flags		= HWMOD_NO_IDLEST,
+};
+
+#ifdef CONFIG_OMAP_IOMMU_IVA2
+
+/* mmu iva */
+
+static struct omap_mmu_dev_attr mmu_iva_dev_attr = {
+	.da_start = 0x11000000,
+	.da_end = 0xfffff000,
+	.nr_tlb_entries = 32,
+};
+
+static struct omap_hwmod omap3xxx_mmu_iva_hwmod;
+static struct omap_hwmod_irq_info omap3xxx_mmu_iva_irqs[] = {
+	{ .irq = 28 },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_rst_info omap3xxx_mmu_iva_resets[] = {
+	{ .name = "mmu", .rst_shift = 1, .st_shift = 9 },
+};
+
+static struct omap_hwmod_addr_space omap3xxx_mmu_iva_addrs[] = {
+	{
+		.pa_start	= 0x5d000000,
+		.pa_end		= 0x5d00007f,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l3_main -> iva mmu */
+static struct omap_hwmod_ocp_if omap3xxx_l3_main__mmu_iva = {
+	.master		= &omap3xxx_l3_main_hwmod,
+	.slave		= &omap3xxx_mmu_iva_hwmod,
+	.addr		= omap3xxx_mmu_iva_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod omap3xxx_mmu_iva_hwmod = {
+	.name		= "mmu_iva",
+	.class		= &omap3xxx_mmu_hwmod_class,
+	.mpu_irqs	= omap3xxx_mmu_iva_irqs,
+	.rst_lines	= omap3xxx_mmu_iva_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(omap3xxx_mmu_iva_resets),
+	.main_clk	= "iva2_ck",
+	.prcm = {
+		.omap2 = {
+			.module_offs = OMAP3430_IVA2_MOD,
+		},
+	},
+	.dev_attr	= &mmu_iva_dev_attr,
+	.flags		= HWMOD_NO_IDLEST,
+};
+
+#endif
+
 /* l4_per -> gpio4 */
 static struct omap_hwmod_addr_space omap3xxx_gpio4_addrs[] = {
 	{
@@ -3312,6 +3429,10 @@ static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp_ifs[] __initdata = {
 	&omap34xx_l4_core__mcspi2,
 	&omap34xx_l4_core__mcspi3,
 	&omap34xx_l4_core__mcspi4,
+	&omap3xxx_l4_core__mmu_isp,
+#ifdef CONFIG_OMAP_IOMMU_IVA2
+	&omap3xxx_l3_main__mmu_iva,
+#endif
 	&omap3xxx_l4_wkup__counter_32k,
 	NULL,
 };
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index e58d571..44518cc 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -103,6 +103,19 @@ struct iommu_functions {
 	ssize_t (*dump_ctx)(struct omap_iommu *obj, char *buf, ssize_t len);
 };
 
+/**
+ * omap_mmu_dev_attr - OMAP mmu device attributes for omap_hwmod
+ * @da_start:		device address where the va space starts.
+ * @da_end:		device address where the va space ends.
+ * @nr_tlb_entries:	number of entries supported by the translation
+ *			look-aside buffer (TLB).
+ */
+struct omap_mmu_dev_attr {
+	u32 da_start;
+	u32 da_end;
+	int nr_tlb_entries;
+};
+
 struct iommu_platform_data {
 	const char *name;
 	const char *clk_name;
-- 
1.7.9.5

