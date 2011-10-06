Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab1JFLjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:39:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37180 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935288Ab1JFLjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:39:33 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>
Subject: [PATCH 2/5 v13] arm: omap: usb: ehci and ohci hwmod structures for omap3
Date: Thu, 6 Oct 2011 17:08:43 +0530
Message-ID: <1317901123-2546-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following 2 hwmod structures are added
    1. usb_host_hs
         The hwmod of usbhs with uhh, ehci and ohci base addresses
         functional clock and ehci, ohci irqs

    2. usb_tll_hs
          hwmod of usbhs with the TLL base address and irq.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  227 ++++++++++++++++++++++++++++
 1 files changed, 227 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 59fdb9f..b8ca690 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -84,6 +84,8 @@ static struct omap_hwmod omap3xxx_mcbsp4_hwmod;
 static struct omap_hwmod omap3xxx_mcbsp5_hwmod;
 static struct omap_hwmod omap3xxx_mcbsp2_sidetone_hwmod;
 static struct omap_hwmod omap3xxx_mcbsp3_sidetone_hwmod;
+static struct omap_hwmod omap34xx_usb_host_hs_hwmod;
+static struct omap_hwmod omap34xx_usb_tll_hs_hwmod;
 
 /* L3 -> L4_CORE interface */
 static struct omap_hwmod_ocp_if omap3xxx_l3_main__l4_core = {
@@ -3196,6 +3198,226 @@ static struct omap_hwmod omap3xxx_mmc3_hwmod = {
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
 };
 
+/*
+ * 'usb_host_hs' class
+ * high-speed multi-port usb host controller
+ */
+static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__l3_main_2 = {
+	.master		= &omap34xx_usb_host_hs_hwmod,
+	.slave		= &omap3xxx_l3_main_hwmod,
+	.clk		= "core_l3_ick",
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_class_sysconfig omap34xx_usb_host_hs_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_CLOCKACTIVITY |
+			   SYSC_HAS_SIDLEMODE | SYSC_HAS_ENAWAKEUP |
+			   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap34xx_usb_host_hs_hwmod_class = {
+	.name = "usb_host_hs",
+	.sysc = &omap34xx_usb_host_hs_sysc,
+};
+
+static struct omap_hwmod_ocp_if *omap34xx_usb_host_hs_masters[] = {
+	&omap34xx_usb_host_hs__l3_main_2,
+};
+
+static struct omap_hwmod_addr_space omap34xx_usb_host_hs_addrs[] = {
+	{
+		.name		= "uhh",
+		.pa_start	= 0x48064000,
+		.pa_end		= 0x480643ff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.name		= "ohci",
+		.pa_start	= 0x48064400,
+		.pa_end		= 0x480647ff,
+	},
+	{
+		.name		= "ehci",
+		.pa_start	= 0x48064800,
+		.pa_end		= 0x48064cff,
+	},
+	{}
+};
+
+static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__ick = {
+	.master         = &omap3xxx_l4_core_hwmod,
+	.slave          = &omap34xx_usb_host_hs_hwmod,
+	.clk		= "usbhost_ick",
+	.addr		= omap34xx_usb_host_hs_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+/*
+ * This clock should be on/off only with main clock; If auto idle is set,
+ * the usbhs controller prevents the omap to enter in to low power mode,
+ * hence don't use auto idle here.
+ */
+	.flags		= OCPIF_SWSUP_IDLE,
+};
+
+static struct omap_hwmod_ocp_if *omap34xx_usb_host_hs_slaves[] = {
+	&omap34xx_usb_host_hs__ick,
+};
+
+static struct omap_hwmod_opt_clk omap34xx_usb_host_hs_opt_clks[] = {
+	  { .role = "ehci_logic_fck", .clk = "usbhost_120m_fck", },
+};
+
+static struct omap_hwmod_irq_info omap34xx_usb_host_hs_irqs[] = {
+	{ .name = "ohci-irq", .irq = 76 },
+	{ .name = "ehci-irq", .irq = 77 },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod omap34xx_usb_host_hs_hwmod = {
+	.name		= "usb_host_hs",
+	.class		= &omap34xx_usb_host_hs_hwmod_class,
+	.clkdm_name	= "l3_init_clkdm",
+	.mpu_irqs	= omap34xx_usb_host_hs_irqs,
+	.main_clk	= "usbhost_48m_fck",
+	.prcm = {
+		.omap2 = {
+			.module_offs = OMAP3430ES2_USBHOST_MOD,
+			.prcm_reg_id = 1,
+			.module_bit = OMAP3430ES2_EN_USBHOST1_SHIFT,
+			.idlest_reg_id = 1,
+			.idlest_idle_bit = OMAP3430ES2_ST_USBHOST_IDLE_SHIFT,
+			.idlest_stdby_bit = OMAP3430ES2_ST_USBHOST_STDBY_SHIFT,
+		},
+	},
+	.opt_clks	= omap34xx_usb_host_hs_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(omap34xx_usb_host_hs_opt_clks),
+	.slaves		= omap34xx_usb_host_hs_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap34xx_usb_host_hs_slaves),
+	.masters	= omap34xx_usb_host_hs_masters,
+	.masters_cnt	= ARRAY_SIZE(omap34xx_usb_host_hs_masters),
+/*
+ *	Errata: USBHOST Configured In Smart-Idle Can Lead To a Deadlock
+ *	id: i660
+ *
+ *	Description:
+ *	In the following configuration :
+ *	- USBHOST module is set to smart-idle mode
+ *	- PRCM asserts idle_req to the USBHOST module ( This typically happens
+ *	  when the system is going to a low power mode : all ports have been
+ *	  suspended, the master part of the USBHOST module has entered the
+ *	  standby state, and SW has cut the functional clocks.)
+ *	- an USBHOST interrupt occurs before the module is able to answer
+ *	  idle_ack, typically a remote wakeup IRQ.
+ *	Then the USB HOST module will enter a deadlock situation where it is no
+ *	more accessible nor functional.
+ *
+ *	Workaround:
+ *	Don't use smart idle; use only force idle, hence HWMOD_SWSUP_SIDLE
+ */
+
+/*	Errata: USB host EHCI may stall when entering smart-standby mode
+ *	Id: i571
+ *
+ *	Description:
+ *	When the USBHOST module is set to smart-standby mode, and when it is
+ *	ready to enter the standby state (i.e. all ports are suspended and
+ *	all attached devices are in suspend mode), then it can wrongly assert
+ *	the Mstandby signal too early while there are still some residual OCP
+ *	transactions ongoing. If this condition occurs, the internal state
+ *	machine may go to an undefined state and the USB link may be stuck
+ *	upon the next resume.
+ *
+ *	Workaround:
+ *	Don't use smart standby; use only force standby,
+ *	hence HWMOD_SWSUP_MSTANDBY
+ */
+
+/*	During system boot; If the hwmod framework resets the module
+ *	the module will have smart idle settings; which can lead to deadlock
+ *	(above Errata Id:i660); so, dont reset the module during boot;
+ *	Use HWMOD_INIT_NO_RESET.
+ */
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
+			  HWMOD_INIT_NO_RESET,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+/*
+ * 'usb_tll_hs' class
+ * usb_tll_hs module is the adapter on the usb_host_hs ports
+ */
+static struct omap_hwmod_class_sysconfig omap34xx_usb_tll_hs_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+			   SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap34xx_usb_tll_hs_hwmod_class = {
+	.name = "usb_tll_hs",
+	.sysc = &omap34xx_usb_tll_hs_sysc,
+};
+
+static struct omap_hwmod_irq_info omap34xx_usb_tll_hs_irqs[] = {
+	{ .name = "tll-irq", .irq = 78 },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_addr_space omap34xx_usb_tll_hs_addrs[] = {
+	{
+		.name		= "tll",
+		.pa_start	= 0x48062000,
+		.pa_end		= 0x48062fff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{}
+};
+
+static struct omap_hwmod_ocp_if omap34xx_ick_cfg__usb_tll_hs = {
+	.clk		= "usbtll_ick",
+	.addr		= omap34xx_usb_tll_hs_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+/*
+ * This clock should be on/off only with main clock; If auto idle is set,
+ * the usbhs controller prevents the omap to enter in to low power mode,
+ * hence don't use auto idle here.
+ */
+	.flags		= OCPIF_SWSUP_IDLE,
+};
+
+static struct omap_hwmod_ocp_if *omap34xx_usb_tll_hs_slaves[] = {
+	&omap34xx_ick_cfg__usb_tll_hs,
+};
+
+static struct omap_hwmod omap34xx_usb_tll_hs_hwmod = {
+	.name		= "usb_tll_hs",
+	.class		= &omap34xx_usb_tll_hs_hwmod_class,
+	.clkdm_name	= "l3_init_clkdm",
+	.mpu_irqs	= omap34xx_usb_tll_hs_irqs,
+	.main_clk	= "usbtll_fck",
+	.prcm = {
+		.omap2 = {
+			.module_offs = CORE_MOD,
+			.prcm_reg_id = 3,
+			.module_bit = OMAP3430ES2_EN_USBTLL_SHIFT,
+			.idlest_reg_id = 3,
+			.idlest_idle_bit = OMAP3430ES2_ST_USBTLL_SHIFT,
+		},
+	},
+	.slaves		= omap34xx_usb_tll_hs_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap34xx_usb_tll_hs_slaves),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
 static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_l3_main_hwmod,
 	&omap3xxx_l4_core_hwmod,
@@ -3225,6 +3447,11 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_uart2_hwmod,
 	&omap3xxx_uart3_hwmod,
 	&omap3xxx_uart4_hwmod,
+
+	/* usb host class */
+	&omap34xx_usb_host_hs_hwmod,
+	&omap34xx_usb_tll_hs_hwmod,
+
 	/* dss class */
 	&omap3430es1_dss_core_hwmod,
 	&omap3xxx_dss_core_hwmod,
-- 
1.6.0.4

