Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab2IUAan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:30:43 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:60842 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608Ab2IUAaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:30:21 -0400
Date: Fri, 21 Sep 2012 00:30:20 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/9] ARM: OMAP3: hwmod data: add mmu data for iva and
 isp
In-Reply-To: <1347479152-588-3-git-send-email-omar.luna@linaro.org>
Message-ID: <alpine.DEB.2.00.1209210027050.6888@utopia.booyaka.com>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org> <1347479152-588-3-git-send-email-omar.luna@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, 12 Sep 2012, Omar Ramirez Luna wrote:

> Add mmu hwmod data for iva and isp.
> 
> Due to compatibility an ifdef CONFIG_OMAP_IOMMU_IVA2 needs to be
> propagated (previously on iommu resource info) to hwmod data in OMAP3,
> so users of iommu and tidspbridge can avoid issues of two modules
> managing mmu data/irqs/resets; this until tidspbridge can be migrated
> to iommu framework.
> 
> Cc: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>

During testing, this patch was found to cause boot warnings on
AM3517-based devices.  The ISP MMUs do not appear to be present on
those chips.  The patch has been modified to restrict these hwmods to
OMAP34xx/36xx chips; updated patch below.


- Paul

From: Paul Walmsley <paul@pwsan.com>
Date: Thu, 20 Sep 2012 18:23:22 -0600
Subject: [PATCH] ARM: OMAP3: hwmod data: add mmu data for iva and isp

Add mmu hwmod data for iva and isp.

Due to compatibility an ifdef CONFIG_OMAP_IOMMU_IVA2 needs to be
propagated (previously on iommu resource info) to hwmod data in OMAP3,
so users of iommu and tidspbridge can avoid issues of two modules
managing mmu data/irqs/resets; this until tidspbridge can be migrated
to iommu framework.

Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
[paul@pwsan.com: fixed some kerneldoc and whitespace; ISP MMUs not present
 on AM35xx so restricted these hwmods to 34xx/36xx]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  125 ++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/iommu.h    |   13 +++
 2 files changed, 138 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index f1328bc..11442d8 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -27,6 +27,7 @@
 #include <plat/mcbsp.h>
 #include <plat/mcspi.h>
 #include <plat/dmtimer.h>
+#include <plat/iommu.h>
 
 #include <mach/am35xx.h>
 
@@ -2858,6 +2859,122 @@ static struct omap_hwmod_ocp_if omap3xxx_l4_per__gpio3 = {
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
+	.da_start	= 0x0,
+	.da_end		= 0xfffff000,
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
+	.da_start	= 0x11000000,
+	.da_end		= 0xfffff000,
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
@@ -3407,6 +3524,10 @@ static struct omap_hwmod_ocp_if *omap34xx_hwmod_ocp_ifs[] __initdata = {
 	&omap3xxx_l4_core__mailbox,
 	&omap3xxx_l4_core__hdq1w,
 	&omap3xxx_sad2d__l3,
+	&omap3xxx_l4_core__mmu_isp,
+#ifdef CONFIG_OMAP_IOMMU_IVA2
+	&omap3xxx_l3_main__mmu_iva,
+#endif
 	NULL
 };
 
@@ -3428,6 +3549,10 @@ static struct omap_hwmod_ocp_if *omap36xx_hwmod_ocp_ifs[] __initdata = {
 	&omap3xxx_l4_core__es3plus_mmc2,
 	&omap3xxx_l4_core__hdq1w,
 	&omap3xxx_sad2d__l3,
+	&omap3xxx_l4_core__mmu_isp,
+#ifdef CONFIG_OMAP_IOMMU_IVA2
+	&omap3xxx_l3_main__mmu_iva,
+#endif
 	NULL
 };
 
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index e58d571..68b5f03 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -103,6 +103,19 @@ struct iommu_functions {
 	ssize_t (*dump_ctx)(struct omap_iommu *obj, char *buf, ssize_t len);
 };
 
+/**
+ * struct omap_mmu_dev_attr - OMAP mmu device attributes for omap_hwmod
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
1.7.10.4

