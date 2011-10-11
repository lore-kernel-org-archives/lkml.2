Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1JKHsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:48:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39334 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1JKHsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:48:42 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>
Subject: [PATCH 1/5 v14] arm: omap: usb: ehci and ohci hwmod structures for omap4
Date: Tue, 11 Oct 2011 13:18:43 +0530
Message-ID: <1318319323-20146-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
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
- Workarounds for hardware issues

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  221 +++++++++++++++++++++++++++-
 1 files changed, 220 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 6201422..f85de42 100644
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
@@ -5336,6 +5338,220 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod = {
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
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_SOFTRESET),
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
+
+	/*
+	 * Errata: USBHOST Configured In Smart-Idle Can Lead To a Deadlock
+	 * id: i660
+	 *
+	 * Description:
+	 * In the following configuration :
+	 * - USBHOST module is set to smart-idle mode
+	 * - PRCM asserts idle_req to the USBHOST module ( This typically
+	 *   happens when the system is going to a low power mode : all ports
+	 *   have been suspended, the master part of the USBHOST module has
+	 *   entered the standby state, and SW has cut the functional clocks)
+	 * - an USBHOST interrupt occurs before the module is able to answer
+	 *   idle_ack, typically a remote wakeup IRQ.
+	 * Then the USB HOST module will enter a deadlock situation where it
+	 * is no more accessible nor functional.
+	 *
+	 * Workaround:
+	 * Don't use smart idle; use only force idle, hence HWMOD_SWSUP_SIDLE
+	 */
+
+	/* Errata: USB host EHCI may stall when entering smart-standby mode
+	 * Id: i571
+	 *
+	 * Description:
+	 * When the USBHOST module is set to smart-standby mode, and when it is
+	 * ready to enter the standby state (i.e. all ports are suspended and
+	 * all attached devices are in suspend mode), then it can wrongly assert
+	 * the Mstandby signal too early while there are still some residual OCP
+	 * transactions ongoing. If this condition occurs, the internal state
+	 * machine may go to an undefined state and the USB link may be stuck
+	 * upon the next resume.
+	 *
+	 * Workaround:
+	 * Don't use smart standby; use only force standby,
+	 * hence HWMOD_SWSUP_MSTANDBY
+	 */
+
+	/* During system boot; If the hwmod framework resets the module
+	 * the module will have smart idle settings; which can lead to deadlock
+	 * (above Errata Id:i660); so, dont reset the module during boot;
+	 * Use HWMOD_INIT_NO_RESET.
+	 */
+
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
+			  HWMOD_INIT_NO_RESET,
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
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+			   SYSC_HAS_AUTOIDLE),
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
+static struct omap_hwmod_ocp_if omap44xx_usb_tll_hs__l3_main_2 = {
+	.master		= &omap44xx_usb_tll_hs_hwmod,
+	.slave		= &omap44xx_l3_main_2_hwmod,
+	.clk		= "l3_div_ck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if *omap44xx_usb_tll_hs_masters[] = {
+	&omap44xx_usb_tll_hs__l3_main_2,
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
+	.masters	= omap44xx_usb_tll_hs_masters,
+	.masters_cnt	= ARRAY_SIZE(omap44xx_usb_tll_hs_masters),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
+};
+
 static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 
 	/* dmm class */
@@ -5475,13 +5691,16 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
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

