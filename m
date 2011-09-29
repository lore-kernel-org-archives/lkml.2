Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1I2OJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:09:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59797 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab1I2OJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:09:00 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>
Subject: [PATCH 1/5] arm: omap: usb: ehci and ohci hwmod structures for omap4
Date: Thu, 29 Sep 2011 19:37:17 +0530
Message-ID: <1317305241-611-2-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1317305241-611-1-git-send-email-keshava_mgowda@ti.com>
References: <1317305241-611-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Cousson <b-cousson@ti.com>

Following 2 hwmod structures are added
1. usb_host_hs
     The hwmod of usbhs with uhh, ehci and ohci base addresses
     functional clock and ehci, ohci irqs

2. usb_tll_hs
      hwmod of usbhs with the TLL base address and irq.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>

- rebased to kernel version 3.0

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  171 +++++++++++++++++++++++++++-
 1 files changed, 170 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 6201422..5e6e3c6 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -68,6 +68,8 @@ static struct omap_hwmod omap44xx_mmc2_hwmod;
 static struct omap_hwmod omap44xx_mpu_hwmod;
 static struct omap_hwmod omap44xx_mpu_private_hwmod;
 static struct omap_hwmod omap44xx_usb_otg_hs_hwmod;
+static struct omap_hwmod omap44xx_usb_host_hs_hwmod;
+static struct omap_hwmod omap44xx_usb_tll_hs_hwmod;
 
 /*
  * Interconnects omap_hwmod structures
@@ -5336,6 +5338,170 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod = {
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
 };
 
+/*
+ * 'usb_host_hs' class
+ * high-speed multi-port usb host controller
+ */
+static struct omap_hwmod_ocp_if omap44xx_usb_host_hs__l3_main_2 = {
+	.master		= &omap44xx_usb_host_hs_hwmod,
+	.slave		= &omap44xx_l3_main_2_hwmod,
+	.clk		= "l3_div_ck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
+	.idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class omap44xx_usb_host_hs_hwmod_class = {
+	.name = "usb_host_hs",
+	.sysc = &omap44xx_usb_host_hs_sysc,
+};
+
+static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_masters[] = {
+	&omap44xx_usb_host_hs__l3_main_2,
+};
+
+static struct omap_hwmod_addr_space omap44xx_usb_host_hs_addrs[] = {
+	{
+		.name		= "uhh",
+		.pa_start	= 0x4a064000,
+		.pa_end		= 0x4a0647ff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.name		= "ohci",
+		.pa_start	= 0x4a064800,
+		.pa_end		= 0x4a064bff,
+	},
+	{
+		.name		= "ehci",
+		.pa_start	= 0x4a064c00,
+		.pa_end		= 0x4a064fff,
+	},
+	{}
+};
+
+static struct omap_hwmod_irq_info omap44xx_usb_host_hs_irqs[] = {
+	{ .name = "ohci-irq", .irq = 76 + OMAP44XX_IRQ_GIC_START },
+	{ .name = "ehci-irq", .irq = 77 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_host_hs = {
+	.master		= &omap44xx_l4_cfg_hwmod,
+	.slave		= &omap44xx_usb_host_hs_hwmod,
+	.clk		= "l4_div_ck",
+	.addr		= omap44xx_usb_host_hs_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_slaves[] = {
+	&omap44xx_l4_cfg__usb_host_hs,
+};
+
+static struct omap_hwmod omap44xx_usb_host_hs_hwmod = {
+	.name		= "usb_host_hs",
+	.class		= &omap44xx_usb_host_hs_hwmod_class,
+	.clkdm_name	= "l3_init_clkdm",
+	.main_clk	= "usb_host_hs_fck",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_L3INIT_USB_HOST_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_L3INIT_USB_HOST_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+	.mpu_irqs	= omap44xx_usb_host_hs_irqs,
+	.slaves		= omap44xx_usb_host_hs_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_usb_host_hs_slaves),
+	.masters	= omap44xx_usb_host_hs_masters,
+	.masters_cnt	= ARRAY_SIZE(omap44xx_usb_host_hs_masters),
+/*
+ * The usbhs controller prevents the enter omap to low power mode
+ * if other than FORCE IDLE and FORCE STANDBY are used.
+ */
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
+};
+
+/*
+ * 'usb_tll_hs' class
+ * usb_tll_hs module is the adapter on the usb_host_hs ports
+ */
+static struct omap_hwmod_class_sysconfig omap44xx_usb_tll_hs_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_SOFTRESET | SYSC_HAS_ENAWAKEUP |
+			   SYSC_HAS_CLOCKACTIVITY),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap44xx_usb_tll_hs_hwmod_class = {
+	.name = "usb_tll_hs",
+	.sysc = &omap44xx_usb_tll_hs_sysc,
+};
+
+static struct omap_hwmod_irq_info omap44xx_usb_tll_hs_irqs[] = {
+	{ .name = "tll-irq", .irq = 78 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_addr_space omap44xx_usb_tll_hs_addrs[] = {
+	{
+		.name		= "tll",
+		.pa_start	= 0x4a062000,
+		.pa_end		= 0x4a063fff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{}
+};
+
+static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_tll_hs = {
+	.master		= &omap44xx_l4_cfg_hwmod,
+	.slave		= &omap44xx_usb_tll_hs_hwmod,
+	.clk		= "l4_div_ck",
+	.addr		= omap44xx_usb_tll_hs_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if *omap44xx_usb_tll_hs_slaves[] = {
+	&omap44xx_l4_cfg__usb_tll_hs,
+};
+
+static struct omap_hwmod omap44xx_usb_tll_hs_hwmod = {
+	.name		= "usb_tll_hs",
+	.class		= &omap44xx_usb_tll_hs_hwmod_class,
+	.clkdm_name	= "l3_init_clkdm",
+	.main_clk	= "usb_tll_hs_ick",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_L3INIT_USB_TLL_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_L3INIT_USB_TLL_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+	.mpu_irqs	= omap44xx_usb_tll_hs_irqs,
+	.slaves		= omap44xx_usb_tll_hs_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_usb_tll_hs_slaves),
+/*
+ * The usbhs controller prevents the enter omap to low power mode
+ * if other than FORCE IDLE for TLL mode too.
+ */
+	.flags		= HWMOD_SWSUP_SIDLE,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
+};
+
 static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 
 	/* dmm class */
@@ -5475,13 +5641,16 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	&omap44xx_uart3_hwmod,
 	&omap44xx_uart4_hwmod,
 
+	/* usb host class */
+	&omap44xx_usb_host_hs_hwmod,
+	&omap44xx_usb_tll_hs_hwmod,
+
 	/* usb_otg_hs class */
 	&omap44xx_usb_otg_hs_hwmod,
 
 	/* wd_timer class */
 	&omap44xx_wd_timer2_hwmod,
 	&omap44xx_wd_timer3_hwmod,
-
 	NULL,
 };
 
-- 
1.6.0.4

