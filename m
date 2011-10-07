Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab1JGJEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:04:52 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:44069 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1JGJEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:04:49 -0400
Date: Fri, 7 Oct 2011 03:04:48 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <CAP05o4Kfo2fjkaSmhu1wERN4BsznMo3EFe9VMLm9gVA9iXcBzg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110070303250.4611@utopia.booyaka.com>
References: <1317901123-2546-1-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1110061030490.4611@utopia.booyaka.com> <CAP05o4Kfo2fjkaSmhu1wERN4BsznMo3EFe9VMLm9gVA9iXcBzg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, 7 Oct 2011, Munegowda, Keshava wrote:

> Thanks paul;
> Now I am seeing that  without  OCPIF_SWSUP_IDLE the system is going to
> low power mode but after
> adding HWMOD_INIT_NO_RESET flag ;  After adding this flag; I dint
> check the system without this flag;
> so, PRCM automatically idle this interface clock if UHH target port is
> forced idle and force standby.
> I can remove it now.  :-)

Great.  So I've cleaned up a few other issues in your patch, and the 
following is what I plan to submit for upstream.  Please review it to see 
if there are any more changes which are needed.

regards

- Paul

From: Keshava Munegowda <keshava_mgowda@ti.com>
Date: Fri, 7 Oct 2011 02:40:51 -0600
Subject: [PATCH] arm: omap: usb: ehci and ohci hwmod structures for omap3

Following 2 hwmod structures are added
    1. usb_host_hs
         The hwmod of usbhs with uhh, ehci and ohci base addresses
         functional clock and ehci, ohci irqs

    2. usb_tll_hs
          hwmod of usbhs with the TLL base address and irq.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
[paul@pwsan.com: dropped OCPIF_SWSUP_IDLE from interfaces; fixed whitespace;
 updated to apply on Tony's cleanup branch; don't register on OMAP3430ES1;
 rename 34xx in names to 3xxx; fixed multi-line comment style]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  217 ++++++++++++++++++++++++++++
 1 files changed, 217 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index ab35acb..27d0ec4 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -84,6 +84,8 @@ static struct omap_hwmod omap3xxx_mcbsp4_hwmod;
 static struct omap_hwmod omap3xxx_mcbsp5_hwmod;
 static struct omap_hwmod omap3xxx_mcbsp2_sidetone_hwmod;
 static struct omap_hwmod omap3xxx_mcbsp3_sidetone_hwmod;
+static struct omap_hwmod omap3xxx_usb_host_hs_hwmod;
+static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod;
 
 /* L3 -> L4_CORE interface */
 static struct omap_hwmod_ocp_if omap3xxx_l3_main__l4_core = {
@@ -3123,6 +3125,214 @@ static struct omap_hwmod omap3xxx_mmc3_hwmod = {
 	.class		= &omap34xx_mmc_class,
 };
 
+/*
+ * 'usb_host_hs' class
+ * high-speed multi-port usb host controller
+ */
+static struct omap_hwmod_ocp_if omap3xxx_usb_host_hs__l3_main_2 = {
+	.master		= &omap3xxx_usb_host_hs_hwmod,
+	.slave		= &omap3xxx_l3_main_hwmod,
+	.clk		= "core_l3_ick",
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_class_sysconfig omap3xxx_usb_host_hs_sysc = {
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
+static struct omap_hwmod_class omap3xxx_usb_host_hs_hwmod_class = {
+	.name = "usb_host_hs",
+	.sysc = &omap3xxx_usb_host_hs_sysc,
+};
+
+static struct omap_hwmod_ocp_if *omap3xxx_usb_host_hs_masters[] = {
+	&omap3xxx_usb_host_hs__l3_main_2,
+};
+
+static struct omap_hwmod_addr_space omap3xxx_usb_host_hs_addrs[] = {
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
+static struct omap_hwmod_ocp_if omap3xxx_usb_host_hs__ick = {
+	.master		= &omap3xxx_l4_core_hwmod,
+	.slave		= &omap3xxx_usb_host_hs_hwmod,
+	.clk		= "usbhost_ick",
+	.addr		= omap3xxx_usb_host_hs_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if *omap3xxx_usb_host_hs_slaves[] = {
+	&omap3xxx_usb_host_hs__ick,
+};
+
+static struct omap_hwmod_opt_clk omap3xxx_usb_host_hs_opt_clks[] = {
+	  { .role = "ehci_logic_fck", .clk = "usbhost_120m_fck", },
+};
+
+static struct omap_hwmod_irq_info omap3xxx_usb_host_hs_irqs[] = {
+	{ .name = "ohci-irq", .irq = 76 },
+	{ .name = "ehci-irq", .irq = 77 },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
+	.name		= "usb_host_hs",
+	.class		= &omap3xxx_usb_host_hs_hwmod_class,
+	.clkdm_name	= "l3_init_clkdm",
+	.mpu_irqs	= omap3xxx_usb_host_hs_irqs,
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
+	.opt_clks	= omap3xxx_usb_host_hs_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(omap3xxx_usb_host_hs_opt_clks),
+	.slaves		= omap3xxx_usb_host_hs_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap3xxx_usb_host_hs_slaves),
+	.masters	= omap3xxx_usb_host_hs_masters,
+	.masters_cnt	= ARRAY_SIZE(omap3xxx_usb_host_hs_masters),
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
+/*
+ *	Errata: USB host EHCI may stall when entering smart-standby mode
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
+/*
+ *	During system boot; If the hwmod framework resets the module
+ *	the module will have smart idle settings; which can lead to deadlock
+ *	(above Errata Id:i660); so, dont reset the module during boot;
+ *	Use HWMOD_INIT_NO_RESET.
+ */
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
+			  HWMOD_INIT_NO_RESET,
+};
+
+/*
+ * 'usb_tll_hs' class
+ * usb_tll_hs module is the adapter on the usb_host_hs ports
+ */
+static struct omap_hwmod_class_sysconfig omap3xxx_usb_tll_hs_sysc = {
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
+static struct omap_hwmod_class omap3xxx_usb_tll_hs_hwmod_class = {
+	.name = "usb_tll_hs",
+	.sysc = &omap3xxx_usb_tll_hs_sysc,
+};
+
+static struct omap_hwmod_irq_info omap3xxx_usb_tll_hs_irqs[] = {
+	{ .name = "tll-irq", .irq = 78 },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_addr_space omap3xxx_usb_tll_hs_addrs[] = {
+	{
+		.name		= "tll",
+		.pa_start	= 0x48062000,
+		.pa_end		= 0x48062fff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{}
+};
+
+static struct omap_hwmod_ocp_if omap3xxx_ick_cfg__usb_tll_hs = {
+	.clk		= "usbtll_ick",
+	.addr		= omap3xxx_usb_tll_hs_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if *omap3xxx_usb_tll_hs_slaves[] = {
+	&omap3xxx_ick_cfg__usb_tll_hs,
+};
+
+static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod = {
+	.name		= "usb_tll_hs",
+	.class		= &omap3xxx_usb_tll_hs_hwmod_class,
+	.clkdm_name	= "l3_init_clkdm",
+	.mpu_irqs	= omap3xxx_usb_tll_hs_irqs,
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
+	.slaves		= omap3xxx_usb_tll_hs_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap3xxx_usb_tll_hs_slaves),
+};
+
 static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_l3_main_hwmod,
 	&omap3xxx_l4_core_hwmod,
@@ -3151,6 +3361,7 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_uart1_hwmod,
 	&omap3xxx_uart2_hwmod,
 	&omap3xxx_uart3_hwmod,
+
 	/* dss class */
 	&omap3xxx_dss_dispc_hwmod,
 	&omap3xxx_dss_dsi1_hwmod,
@@ -3206,6 +3417,8 @@ static __initdata struct omap_hwmod *omap3430es1_hwmods[] = {
 static __initdata struct omap_hwmod *omap3430es2plus_hwmods[] = {
 	&omap3xxx_dss_core_hwmod,
 	&omap3xxx_usbhsotg_hwmod,
+	&omap3xxx_usb_host_hs_hwmod,
+	&omap3xxx_usb_tll_hs_hwmod,
 	NULL
 };
 
@@ -3223,12 +3436,16 @@ static __initdata struct omap_hwmod *omap36xx_hwmods[] = {
 	&omap36xx_sr1_hwmod,
 	&omap36xx_sr2_hwmod,
 	&omap3xxx_usbhsotg_hwmod,
+	&omap3xxx_usb_host_hs_hwmod,
+	&omap3xxx_usb_tll_hs_hwmod,
 	NULL
 };
 
 static __initdata struct omap_hwmod *am35xx_hwmods[] = {
 	&omap3xxx_dss_core_hwmod, /* XXX ??? */
 	&am35xx_usbhsotg_hwmod,
+	&omap3xxx_usb_host_hs_hwmod,
+	&omap3xxx_usb_tll_hs_hwmod,
 	NULL
 };
 
-- 
1.7.6.3

