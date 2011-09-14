Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1INQuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:50:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34765 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998Ab1INQuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:50:44 -0400
Message-ID: <4E70DB58.9070901@ti.com>
Date: Wed, 14 Sep 2011 18:50:32 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>, "paul@pwsan.com" <paul@pwsan.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>,
        "Quadros, Roger" <rogerq@ti.com>
Subject: Re: [PATCH 1/5 v8] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
References: <1314255697-15411-1-git-send-email-keshava_mgowda@ti.com> <1314255697-15411-2-git-send-email-keshava_mgowda@ti.com>
In-Reply-To: <1314255697-15411-2-git-send-email-keshava_mgowda@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On 8/25/2011 9:01 AM, Munegowda, Keshava wrote:
> From: Benoit Cousson<b-cousson@ti.com>
> 
> Following 4 hwmod structures are added:
> UHH hwmod of usbhs with uhh base address and functional clock,
> EHCI hwmod with irq and base address,
> OHCI hwmod with irq and base address,
> TLL hwmod of usbhs with the TLL base address and irq.
> 
> Signed-off-by: Benoit Cousson<b-cousson@ti.com>

That version is really different compared to my original patch, so you should highlight the diff you introduced.

> Signed-off-by: Keshava Munegowda<keshava_mgowda@ti.com>
> ---
>   arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  247 ++++++++++++++++++++++++++++
>   1 files changed, 247 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> index 6201422..0bc01dd 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -68,6 +68,10 @@ static struct omap_hwmod omap44xx_mmc2_hwmod;
>   static struct omap_hwmod omap44xx_mpu_hwmod;
>   static struct omap_hwmod omap44xx_mpu_private_hwmod;
>   static struct omap_hwmod omap44xx_usb_otg_hs_hwmod;
> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod;
> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod;
> +static struct omap_hwmod omap44xx_usbhs_ehci_hwmod;
> +static struct omap_hwmod omap44xx_usb_tll_hs_hwmod;

None of the 3 last entries are master, and thus should not need any backward declaration.

>   /*
>    * Interconnects omap_hwmod structures
> @@ -5336,6 +5340,245 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod = {
>   	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>   };
> 
> +/*
> + * 'usb_host_hs' class
> + * high-speed multi-port usb host controller
> + */
> +static struct omap_hwmod_ocp_if omap44xx_usb_host_hs__l3_main_2 = {
> +	.master		=&omap44xx_usb_host_hs_hwmod,
> +	.slave		=&omap44xx_l3_main_2_hwmod,
> +	.clk		= "l3_div_ck",
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> +				SIDLE_SMART_WKUP | MSTANDBY_FORCE |
> +				MSTANDBY_NO | MSTANDBY_SMART |
> +				MSTANDBY_SMART_WKUP),

Minor, but it should be:
+       .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+                          SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+                          MSTANDBY_SMART | MSTANDBY_SMART_WKUP),

> +	.sysc_fields	=&omap_hwmod_sysc_type2,
> +};
> +
> +static struct omap_hwmod_class omap44xx_usb_host_hs_hwmod_class = {
> +	.name = "usbhs_uhh",
> +	.sysc =&omap44xx_usb_host_hs_sysc,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_masters[] = {
> +	&omap44xx_usb_host_hs__l3_main_2,
> +};
> +
> +static struct omap_hwmod_addr_space omap44xx_usb_host_hs_addrs[] = {
> +	{
> +		.name		= "uhh",

In general, there is no name for unique entry. And if you need a name, you should find something relevant considering this is local to the hwmod.

> +		.pa_start	= 0x4a064000,
> +		.pa_end		= 0x4a0647ff,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{} /* Terminating Entry */

That comment is useless. Paul added one space inside the terminator as well.

> +};
> +
> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_host_hs = {
> +	.master		=&omap44xx_l4_cfg_hwmod,
> +	.slave		=&omap44xx_usb_host_hs_hwmod,
> +	.clk		= "l4_div_ck",
> +	.addr		= omap44xx_usb_host_hs_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_slaves[] = {
> +	&omap44xx_l4_cfg__usb_host_hs,
> +};
> +
> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod = {
> +	.name		= "usbhs_uhh",
> +	.class		=&omap44xx_usb_host_hs_hwmod_class,
> +	.clkdm_name	= "l3_init_clkdm",
> +	.main_clk	= "usb_host_hs_fck",
> +	.prcm = {
> +		.omap4 = {
> +			.clkctrl_offs = OMAP4_CM_L3INIT_USB_HOST_CLKCTRL_OFFSET,
> +			.context_offs = OMAP4_RM_L3INIT_USB_HOST_CONTEXT_OFFSET,
> +			.modulemode   = MODULEMODE_SWCTRL,
> +		},
> +	},
> +	.slaves		= omap44xx_usb_host_hs_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap44xx_usb_host_hs_slaves),
> +	.masters	= omap44xx_usb_host_hs_masters,
> +	.masters_cnt	= ARRAY_SIZE(omap44xx_usb_host_hs_masters),
> +	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
> +	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
> +};
> +
> +/* 'usbhs_ohci' class */
> +static struct omap_hwmod_class omap44xx_usbhs_ohci_hwmod_class = {
> +	.name = "usbhs_ohci",

In the context of devicetree and considering what Felipe did for the USB3, I'm wondering if you should define hwmods for ohci and ehci.
I'm not 100% sure it will apply here, but cannot you add the register entries inside the usb_host_hs hwmod and create the devices using that?

There is no PRCM entry for them so they do not need to be omap_device.

> +};
> +
> +static struct omap_hwmod_irq_info omap44xx_usbhs_ohci_irqs[] = {
> +	{ .name = "ohci-irq", .irq = 76 + OMAP44XX_IRQ_GIC_START },

Same comment that before about address space name.

> +	{ .irq = -1 } /* Terminating IRQ */
> +};
> +
> +static struct omap_hwmod_addr_space omap44xx_usbhs_ohci_addrs[] = {
> +	{
> +		.name		= "ohci",

Same comment than before.

> +		.pa_start	= 0x4A064800,
> +		.pa_end		= 0x4A064BFF,
> +		.flags		= ADDR_MAP_ON_INIT

Why do you need that flag?

> +	},
> +	{}
> +};
> +
> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usbhs_ohci = {
> +	.master		=&omap44xx_l4_cfg_hwmod,
> +	.slave		=&omap44xx_usbhs_ohci_hwmod,
> +	.clk		= "l4_div_ck",
> +	.addr		= omap44xx_usbhs_ohci_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ohci_slaves[] = {
> +	&omap44xx_l4_cfg__usbhs_ohci,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ohci_masters[] = {
> +	&omap44xx_usb_host_hs__l3_main_2,
> +};
> +
> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod = {
> +	.name		= "usbhs_ohci",
> +	.class		=&omap44xx_usbhs_ohci_hwmod_class,
> +	.clkdm_name	= "l3_init_clkdm",
> +	.mpu_irqs	= omap44xx_usbhs_ohci_irqs,
> +	.slaves		= omap44xx_usbhs_ohci_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap44xx_usbhs_ohci_slaves),
> +	.masters	= omap44xx_usbhs_ohci_masters,
> +	.masters_cnt	= ARRAY_SIZE(omap44xx_usbhs_ohci_masters),

Assuming you need hwmod entries for that, these master entries are useless and probably wrong.
The TRM just documents 2 ports for usb_host_hs and 1 port for usb_tll_hs.

You will still need the slave for the address space.

> +	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
> +	.flags		= HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
> +};
> +
> +/* 'usbhs_ehci' class */
> +static struct omap_hwmod_class omap44xx_usbhs_ehci_hwmod_class = {
> +	.name = "usbhs_ehci",
> +};
> +
> +static struct omap_hwmod_irq_info omap44xx_usbhs_ehci_irqs[] = {
> +	{ .name = "ehci-irq", .irq = 77 + OMAP44XX_IRQ_GIC_START },
> +	{ .irq = -1 } /* Terminating IRQ */
> +};
> +
> +static struct omap_hwmod_addr_space omap44xx_usbhs_ehci_addrs[] = {
> +	{
> +		.name		= "ehci",
> +		.pa_start	= 0x4A064C00,
> +		.pa_end		= 0x4A064FFF,
> +		.flags		= ADDR_MAP_ON_INIT
> +	},
> +	{} /* Terminating Entry */
> +};
> +
> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usbhs_ehci = {
> +	.master		=&omap44xx_l4_cfg_hwmod,
> +	.slave		=&omap44xx_usbhs_ehci_hwmod,
> +	.clk		= "l4_div_ck",
> +	.addr		= omap44xx_usbhs_ehci_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ehci_slaves[] = {
> +	&omap44xx_l4_cfg__usbhs_ehci,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ehci_masters[] = {
> +	&omap44xx_usb_host_hs__l3_main_2,
> +};
> +
> +
> +static struct omap_hwmod omap44xx_usbhs_ehci_hwmod = {
> +	.name		= "usbhs_ehci",
> +	.class		=&omap44xx_usbhs_ehci_hwmod_class,
> +	.clkdm_name	= "l3_init_clkdm",
> +	.mpu_irqs	= omap44xx_usbhs_ehci_irqs,
> +	.slaves		= omap44xx_usbhs_ehci_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap44xx_usbhs_ehci_slaves),
> +	.masters	= omap44xx_usbhs_ehci_masters,
> +	.masters_cnt	= ARRAY_SIZE(omap44xx_usbhs_ehci_masters),
> +	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
> +	.flags		= HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
> +};
> +
> +/*
> + * 'usb_tll_hs' class
> + * usb_tll_hs module is the adapter on the usb_host_hs ports
> + */
> +static struct omap_hwmod_class_sysconfig omap44xx_usb_tll_hs_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
> +				SYSC_HAS_SOFTRESET | SYSC_HAS_ENAWAKEUP	|
> +				SYSC_HAS_CLOCKACTIVITY),
> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
> +	.sysc_fields	=&omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class omap44xx_usb_tll_hs_hwmod_class = {
> +	.name = "usbhs_tll",
> +	.sysc =&omap44xx_usb_tll_hs_sysc,
> +};
> +
> +static struct omap_hwmod_irq_info omap44xx_usb_tll_hs_irqs[] = {
> +	{ .name = "tll-irq", .irq = 78 + OMAP44XX_IRQ_GIC_START },
> +	{ .irq = -1 } /* Terminating IRQ */
> +};
> +
> +static struct omap_hwmod_addr_space omap44xx_usb_tll_hs_addrs[] = {
> +	{
> +		.name		= "tll",
> +		.pa_start	= 0x4a062000,
> +		.pa_end		= 0x4a063fff,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{} /* Terminating Entry */
> +};
> +
> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_tll_hs = {
> +	.master		=&omap44xx_l4_cfg_hwmod,
> +	.slave		=&omap44xx_usb_tll_hs_hwmod,
> +	.clk		= "l4_div_ck",
> +	.addr		= omap44xx_usb_tll_hs_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if *omap44xx_usb_tll_hs_slaves[] = {
> +	&omap44xx_l4_cfg__usb_tll_hs,
> +};
> +
> +static struct omap_hwmod omap44xx_usb_tll_hs_hwmod = {
> +	.name		= "usbhs_tll",
> +	.class		=&omap44xx_usb_tll_hs_hwmod_class,
> +	.clkdm_name	= "l3_init_clkdm",
> +	.mpu_irqs	= omap44xx_usb_tll_hs_irqs,
> +	.main_clk	= "usb_tll_hs_ick",
> +	.prcm = {
> +		.omap4 = {
> +			.clkctrl_offs = OMAP4_CM_L3INIT_USB_TLL_CLKCTRL_OFFSET,
> +			.context_offs = OMAP4_RM_L3INIT_USB_TLL_CONTEXT_OFFSET,
> +			.modulemode   = MODULEMODE_HWCTRL,
> +		},
> +	},
> +	.slaves		= omap44xx_usb_tll_hs_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap44xx_usb_tll_hs_slaves),
> +	.flags		= HWMOD_SWSUP_SIDLE,
> +	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
> +};
> +
>   static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
> 
>   	/* dmm class */
> @@ -5482,6 +5725,10 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
>   	&omap44xx_wd_timer2_hwmod,
>   	&omap44xx_wd_timer3_hwmod,
> 
> +	&omap44xx_usb_host_hs_hwmod,
> +	&omap44xx_usbhs_ohci_hwmod,
> +	&omap44xx_usbhs_ehci_hwmod,
> +	&omap44xx_usb_tll_hs_hwmod,

This list is ordered, so it should be something like that: 

        &omap44xx_uart3_hwmod,
        &omap44xx_uart4_hwmod,

+       /* usb_host_hs class */
+	&omap44xx_usb_host_hs_hwmod,
+
        /* usb_otg_hs class */
        &omap44xx_usb_otg_hs_hwmod,

+       /* usb_tll_hs class */
+	&omap44xx_usb_tll_hs_hwmod,
+
        /* wd_timer class */
        &omap44xx_wd_timer2_hwmod,
        &omap44xx_wd_timer3_hwmod,

Regards,
Benoit
