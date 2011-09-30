Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1I3HMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:12:38 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:57575 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1I3HMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:12:36 -0400
Date: Fri, 30 Sep 2011 01:12:35 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v12] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <1317361216-28248-1-git-send-email-keshava_mgowda@ti.com>
Message-ID: <alpine.DEB.2.00.1109300107150.32653@utopia.booyaka.com>
References: <1317361216-28248-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

a few comments

On Fri, 30 Sep 2011, Keshava Munegowda wrote:

> Following 2 hwmod structures are added
>     1. usb_host_hs
>          The hwmod of usbhs with uhh, ehci and ohci base addresses
>          functional clock and ehci, ohci irqs
> 
>     2. usb_tll_hs
>           hwmod of usbhs with the TLL base address and irq.
> 
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> Reviewed-by: Partha Basak <parthab@india.ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  195 ++++++++++++++++++++++++++++
>  1 files changed, 195 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> index 59fdb9f..bc17493 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -84,6 +84,8 @@ static struct omap_hwmod omap3xxx_mcbsp4_hwmod;
>  static struct omap_hwmod omap3xxx_mcbsp5_hwmod;
>  static struct omap_hwmod omap3xxx_mcbsp2_sidetone_hwmod;
>  static struct omap_hwmod omap3xxx_mcbsp3_sidetone_hwmod;
> +static struct omap_hwmod omap34xx_usb_host_hs_hwmod;
> +static struct omap_hwmod omap34xx_usb_tll_hs_hwmod;
>  
>  /* L3 -> L4_CORE interface */
>  static struct omap_hwmod_ocp_if omap3xxx_l3_main__l4_core = {
> @@ -3196,6 +3198,194 @@ static struct omap_hwmod omap3xxx_mmc3_hwmod = {
>  	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
>  };
>  
> +/*
> + * 'usb_host_hs' class
> + * high-speed multi-port usb host controller
> + */
> +static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__l3_main_2 = {
> +	.master		= &omap34xx_usb_host_hs_hwmod,
> +	.slave		= &omap3xxx_l3_main_hwmod,
> +	.clk		= "core_l3_ick",
> +	.user		= OCP_USER_MPU,
> +};
> +
> +static struct omap_hwmod_class_sysconfig omap34xx_usb_host_hs_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),

This register has other bitfields.  Please include them.

> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> +			   MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
> +	.sysc_fields	= &omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class omap34xx_usb_host_hs_hwmod_class = {
> +	.name = "usb_host_hs",
> +	.sysc = &omap34xx_usb_host_hs_sysc,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap34xx_usb_host_hs_masters[] = {
> +	&omap34xx_usb_host_hs__l3_main_2,
> +};
> +
> +static struct omap_hwmod_addr_space omap34xx_usb_host_hs_addrs[] = {
> +	{
> +		.name		= "uhh",
> +		.pa_start	= 0x48064000,
> +		.pa_end		= 0x480643ff,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{
> +		.name		= "ohci",
> +		.pa_start	= 0x48064400,
> +		.pa_end		= 0x480647ff,
> +	},
> +	{
> +		.name		= "ehci",
> +		.pa_start	= 0x48064800,
> +		.pa_end		= 0x48064cff,
> +	},
> +	{}
> +};
> +
> +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usb_host_hs = {
> +	.master		= &omap3xxx_l4_core_hwmod,
> +	.slave		= &omap34xx_usb_host_hs_hwmod,
> +	.clk		= "l4_ick",
> +	.addr		= omap34xx_usb_host_hs_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__ick = {
> +	.clk		= "usbhost_ick",
> +	.user		= OCP_USER_MPU,
> +	.flags		= OCPIF_SWSUP_IDLE,

Does this really need OCPIF_SWSUP_IDLE?  If so, then there is a hardware 
bug, and some explanation is needed.

> +};
> +
> +static struct omap_hwmod_ocp_if *omap34xx_usb_host_hs_slaves[] = {
> +	&omap34xx_l4_cfg__usb_host_hs,
> +	&omap34xx_usb_host_hs__ick,
> +};
> +
> +static struct omap_hwmod_opt_clk omap34xx_usb_host_hs_opt_clks[] = {
> +	  { .role = "usbhost_fck2", .clk = "usbhost_120m_fck", },

The role here doesn't need "usbhost" in its name -- ideally it would be 
something like "120m_fck" or "ehci_logic_fck".

> +};
> +
> +static struct omap_hwmod_irq_info omap34xx_usb_host_hs_irqs[] = {
> +	{ .name = "ohci-irq", .irq = 76 },
> +	{ .name = "ehci-irq", .irq = 77 },
> +	{ .irq = -1 }
> +};
> +
> +static struct omap_hwmod omap34xx_usb_host_hs_hwmod = {
> +	.name		= "usb_host_hs",
> +	.class		= &omap34xx_usb_host_hs_hwmod_class,
> +	.clkdm_name	= "l3_init_clkdm",
> +	.mpu_irqs	= omap34xx_usb_host_hs_irqs,
> +	.main_clk	= "usbhost_48m_fck",
> +	.prcm = {
> +		.omap2 = {
> +			.module_offs = OMAP3430ES2_USBHOST_MOD,
> +			.prcm_reg_id = 1,
> +			.module_bit = OMAP3430ES2_EN_USBHOST1_SHIFT,
> +			.idlest_reg_id = 1,
> +			.idlest_idle_bit = OMAP3430ES2_ST_USBHOST_IDLE_SHIFT,
> +			.idlest_stdby_bit = OMAP3430ES2_ST_USBHOST_STDBY_SHIFT,
> +		},
> +	},
> +	.opt_clks	= omap34xx_usb_host_hs_opt_clks,
> +	.opt_clks_cnt	= ARRAY_SIZE(omap34xx_usb_host_hs_opt_clks),
> +	.slaves		= omap34xx_usb_host_hs_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap34xx_usb_host_hs_slaves),
> +	.masters	= omap34xx_usb_host_hs_masters,
> +	.masters_cnt	= ARRAY_SIZE(omap34xx_usb_host_hs_masters),
> +/*
> + * The usbhs controller prevents the enter omap to low power mode
> + * if other than FORCE IDLE and FORCE STANDBY are used.
> + */
> +	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
> +	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
> +};
> +
> +/*
> + * 'usb_tll_hs' class
> + * usb_tll_hs module is the adapter on the usb_host_hs ports
> + */
> +static struct omap_hwmod_class_sysconfig omap34xx_usb_tll_hs_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
> +			   SYSC_HAS_SOFTRESET | SYSC_HAS_ENAWAKEUP |
> +			   SYSC_HAS_CLOCKACTIVITY),
> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
> +	.sysc_fields	= &omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class omap34xx_usb_tll_hs_hwmod_class = {
> +	.name = "usb_tll_hs",
> +	.sysc = &omap34xx_usb_tll_hs_sysc,
> +};
> +
> +static struct omap_hwmod_irq_info omap34xx_usb_tll_hs_irqs[] = {
> +	{ .name = "tll-irq", .irq = 78 },
> +	{ .irq = -1 }
> +};
> +
> +static struct omap_hwmod_addr_space omap34xx_usb_tll_hs_addrs[] = {
> +	{
> +		.name		= "tll",
> +		.pa_start	= 0x48062000,
> +		.pa_end		= 0x48062fff,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{}
> +};
> +
> +static struct omap_hwmod_ocp_if omap34xx_f_cfg__usb_tll_hs = {
> +	.clk		= "usbtll_ick",
> +	.user		= OCP_USER_MPU,
> +	.flags		= OCPIF_SWSUP_IDLE,
> +};

Does this really need OCPIF_SWSUP_IDLE?  If so, then there is a hardware 
bug, and some explanation is needed.

> +
> +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usb_tll_hs = {
> +	.master		= &omap3xxx_l4_core_hwmod,
> +	.slave		= &omap34xx_usb_tll_hs_hwmod,
> +	.clk		= "l4_ick",
> +	.addr		= omap34xx_usb_tll_hs_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap34xx_usb_tll_hs_slaves[] = {
> +	&omap34xx_l4_cfg__usb_tll_hs,
> +	&omap34xx_f_cfg__usb_tll_hs,
> +};
> +
> +static struct omap_hwmod omap34xx_usb_tll_hs_hwmod = {
> +	.name		= "usb_tll_hs",
> +	.class		= &omap34xx_usb_tll_hs_hwmod_class,
> +	.clkdm_name	= "l3_init_clkdm",
> +	.mpu_irqs	= omap34xx_usb_tll_hs_irqs,
> +	.main_clk	= "usbtll_fck",
> +	.prcm = {
> +		.omap2 = {
> +			.module_offs = CORE_MOD,
> +			.prcm_reg_id = 3,
> +			.module_bit = OMAP3430ES2_EN_USBTLL_SHIFT,
> +			.idlest_reg_id = 3,
> +			.idlest_idle_bit = OMAP3430ES2_ST_USBTLL_SHIFT,
> +		},
> +	},
> +	.slaves		= omap34xx_usb_tll_hs_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap34xx_usb_tll_hs_slaves),
> +/*
> + * The usbhs controller prevents the enter omap to low power mode
> + * if other than FORCE IDLE for TLL mode too.
> + */
> +	.flags		= HWMOD_SWSUP_SIDLE,
> +	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
> +};
> +
>  static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>  	&omap3xxx_l3_main_hwmod,
>  	&omap3xxx_l4_core_hwmod,
> @@ -3225,6 +3415,11 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>  	&omap3xxx_uart2_hwmod,
>  	&omap3xxx_uart3_hwmod,
>  	&omap3xxx_uart4_hwmod,
> +
> +	/* usb host class */
> +	&omap34xx_usb_host_hs_hwmod,
> +	&omap34xx_usb_tll_hs_hwmod,
> +
>  	/* dss class */
>  	&omap3430es1_dss_core_hwmod,
>  	&omap3xxx_dss_core_hwmod,
> -- 
> 1.6.0.4
> 


- Paul
