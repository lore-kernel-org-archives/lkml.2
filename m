Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2KWLH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:07:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57744 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab2KWLHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:07:25 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v3 03/10] ARM: OMAP: AM33xx hwmod: Add parent-child
 relationship for PWM subsystem
Thread-Topic: [PATCH v3 03/10] ARM: OMAP: AM33xx hwmod: Add parent-child
 relationship for PWM subsystem
Thread-Index: AQHNxt2EeUTleDNI/kaFZbNycy/8n5f3RlKg
Date: Fri, 23 Nov 2012 11:06:06 +0000
Deferred-Delivery: Fri, 23 Nov 2012 11:05:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EEA8C@DBDE01.ent.ti.com>
References: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
 <1353387831-31538-4-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1353387831-31538-4-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:33:44, Philip, Avinash wrote:
> As part of PWM subsystem integration, PWM subsystem are sharing
> resources like clock across submodules (ECAP, EQEP & EHRPWM).
> To handle resource sharing & IP integration
> 1. Rework on parent child relation between PWMSS and
>    ECAP, EQEP & EHRPWM child devices to support runtime PM.
> 2. Add support for opt_clks in EHRPWM HWMOD entry to handle additional
>    clock gating from control module.
> 3. Add HWMOD entries for EQEP PWM submodule.
> 

Is there any review on this patch?
This patch depends on ECAP & EHRPWM to work in am335x.

Thanks
Avinash

> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
> 	- Remove ADDR_TYPE_RT for PWM sub module register entries.
> 
> :100644 100644 ad8d43b... de2301c... M	arch/arm/mach-omap2/omap_hwmod_33xx_data.c
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c |  419 ++++++++++++++++++----------
>  1 files changed, 276 insertions(+), 143 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> index ad8d43b..de2301c 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> @@ -768,9 +768,7 @@ static struct omap_hwmod am33xx_elm_hwmod = {
>  	},
>  };
>  
> -/*
> - * 'epwmss' class: ecap0,1,2,  ehrpwm0,1,2
> - */
> +/* pwmss */
>  static struct omap_hwmod_class_sysconfig am33xx_epwmss_sysc = {
>  	.rev_offs	= 0x0,
>  	.sysc_offs	= 0x4,
> @@ -786,18 +784,23 @@ static struct omap_hwmod_class am33xx_epwmss_hwmod_class = {
>  	.sysc		= &am33xx_epwmss_sysc,
>  };
>  
> -/* ehrpwm0 */
> -static struct omap_hwmod_irq_info am33xx_ehrpwm0_irqs[] = {
> -	{ .name = "int", .irq = 86 + OMAP_INTC_START, },
> -	{ .name = "tzint", .irq = 58 + OMAP_INTC_START, },
> -	{ .irq = -1 },
> +
> +static struct omap_hwmod_class am33xx_ecap_hwmod_class = {
> +	.name		= "ecap",
>  };
>  
> -static struct omap_hwmod am33xx_ehrpwm0_hwmod = {
> -	.name		= "ehrpwm0",
> +static struct omap_hwmod_class am33xx_eqep_hwmod_class = {
> +	.name		= "eqep",
> +};
> +
> +static struct omap_hwmod_class am33xx_ehrpwm_hwmod_class = {
> +	.name		= "ehrpwm",
> +};
> +/* epwmss0 */
> +static struct omap_hwmod am33xx_epwmss0_hwmod = {
> +	.name		= "epwmss0",
>  	.class		= &am33xx_epwmss_hwmod_class,
>  	.clkdm_name	= "l4ls_clkdm",
> -	.mpu_irqs	= am33xx_ehrpwm0_irqs,
>  	.main_clk	= "l4ls_gclk",
>  	.prcm		= {
>  		.omap4	= {
> @@ -807,63 +810,68 @@ static struct omap_hwmod am33xx_ehrpwm0_hwmod = {
>  	},
>  };
>  
> -/* ehrpwm1 */
> -static struct omap_hwmod_irq_info am33xx_ehrpwm1_irqs[] = {
> -	{ .name = "int", .irq = 87 + OMAP_INTC_START, },
> -	{ .name = "tzint", .irq = 59 + OMAP_INTC_START, },
> +/* ecap0 */
> +static struct omap_hwmod_irq_info am33xx_ecap0_irqs[] = {
> +	{ .irq = 31 + OMAP_INTC_START, },
>  	{ .irq = -1 },
>  };
>  
> -static struct omap_hwmod am33xx_ehrpwm1_hwmod = {
> -	.name		= "ehrpwm1",
> -	.class		= &am33xx_epwmss_hwmod_class,
> +static struct omap_hwmod am33xx_ecap0_hwmod = {
> +	.name		= "ecap0",
> +	.class		= &am33xx_ecap_hwmod_class,
>  	.clkdm_name	= "l4ls_clkdm",
> -	.mpu_irqs	= am33xx_ehrpwm1_irqs,
> +	.mpu_irqs	= am33xx_ecap0_irqs,
>  	.main_clk	= "l4ls_gclk",
> -	.prcm		= {
> -		.omap4	= {
> -			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET,
> -			.modulemode	= MODULEMODE_SWCTRL,
> -		},
> -	},
>  };
>  
> -/* ehrpwm2 */
> -static struct omap_hwmod_irq_info am33xx_ehrpwm2_irqs[] = {
> -	{ .name = "int", .irq = 39 + OMAP_INTC_START, },
> -	{ .name = "tzint", .irq = 60 + OMAP_INTC_START, },
> +/* eqep0 */
> +static struct omap_hwmod_irq_info am33xx_eqep0_irqs[] = {
> +	{ .irq = 79 + OMAP_INTC_START, },
>  	{ .irq = -1 },
>  };
>  
> -static struct omap_hwmod am33xx_ehrpwm2_hwmod = {
> -	.name		= "ehrpwm2",
> -	.class		= &am33xx_epwmss_hwmod_class,
> +static struct omap_hwmod am33xx_eqep0_hwmod = {
> +	.name		= "eqep0",
> +	.class		= &am33xx_eqep_hwmod_class,
>  	.clkdm_name	= "l4ls_clkdm",
> -	.mpu_irqs	= am33xx_ehrpwm2_irqs,
> +	.mpu_irqs	= am33xx_eqep0_irqs,
>  	.main_clk	= "l4ls_gclk",
> -	.prcm		= {
> -		.omap4	= {
> -			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET,
> -			.modulemode	= MODULEMODE_SWCTRL,
> -		},
> -	},
>  };
>  
> -/* ecap0 */
> -static struct omap_hwmod_irq_info am33xx_ecap0_irqs[] = {
> -	{ .irq = 31 + OMAP_INTC_START, },
> +/* ehrpwm0 */
> +static struct omap_hwmod_irq_info am33xx_ehrpwm0_irqs[] = {
> +	{ .name = "int", .irq = 86 + OMAP_INTC_START, },
> +	{ .name = "tzint", .irq = 58 + OMAP_INTC_START, },
>  	{ .irq = -1 },
>  };
>  
> -static struct omap_hwmod am33xx_ecap0_hwmod = {
> -	.name		= "ecap0",
> +/*
> + * Optional clock entry is provided to support additional clock
> + * gating for EHRPWM module functional from control module.
> + */
> +static struct omap_hwmod_opt_clk ehrpwm0_opt_clks[] = {
> +	{ .role = "tbclk", .clk = "ehrpwm0_tbclk" },
> +};
> +
> +static struct omap_hwmod am33xx_ehrpwm0_hwmod = {
> +	.name		= "ehrpwm0",
> +	.class		= &am33xx_ehrpwm_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_ehrpwm0_irqs,
> +	.main_clk	= "l4ls_gclk",
> +	.opt_clks	= ehrpwm0_opt_clks,
> +	.opt_clks_cnt	= ARRAY_SIZE(ehrpwm0_opt_clks),
> +};
> +
> +/* epwmss1 */
> +static struct omap_hwmod am33xx_epwmss1_hwmod = {
> +	.name		= "epwmss1",
>  	.class		= &am33xx_epwmss_hwmod_class,
>  	.clkdm_name	= "l4ls_clkdm",
> -	.mpu_irqs	= am33xx_ecap0_irqs,
>  	.main_clk	= "l4ls_gclk",
>  	.prcm		= {
>  		.omap4	= {
> -			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS0_CLKCTRL_OFFSET,
> +			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET,
>  			.modulemode	= MODULEMODE_SWCTRL,
>  		},
>  	},
> @@ -877,13 +885,60 @@ static struct omap_hwmod_irq_info am33xx_ecap1_irqs[] = {
>  
>  static struct omap_hwmod am33xx_ecap1_hwmod = {
>  	.name		= "ecap1",
> -	.class		= &am33xx_epwmss_hwmod_class,
> +	.class		= &am33xx_ecap_hwmod_class,
>  	.clkdm_name	= "l4ls_clkdm",
>  	.mpu_irqs	= am33xx_ecap1_irqs,
>  	.main_clk	= "l4ls_gclk",
> +};
> +
> +/* eqep1 */
> +static struct omap_hwmod_irq_info am33xx_eqep1_irqs[] = {
> +	{ .irq = 88 + OMAP_INTC_START, },
> +	{ .irq = -1 },
> +};
> +
> +static struct omap_hwmod am33xx_eqep1_hwmod = {
> +	.name		= "eqep1",
> +	.class		= &am33xx_eqep_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_eqep1_irqs,
> +	.main_clk	= "l4ls_gclk",
> +};
> +
> +/* ehrpwm1 */
> +static struct omap_hwmod_irq_info am33xx_ehrpwm1_irqs[] = {
> +	{ .name = "int", .irq = 87 + OMAP_INTC_START, },
> +	{ .name = "tzint", .irq = 59 + OMAP_INTC_START, },
> +	{ .irq = -1 },
> +};
> +
> +/*
> + * Optional clock entry is provided to support additional clock
> + * gating for EHRPWM module functional from control module.
> + */
> +static struct omap_hwmod_opt_clk ehrpwm1_opt_clks[] = {
> +	{ .role = "tbclk", .clk = "ehrpwm1_tbclk" },
> +};
> +
> +static struct omap_hwmod am33xx_ehrpwm1_hwmod = {
> +	.name		= "ehrpwm1",
> +	.class		= &am33xx_ehrpwm_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_ehrpwm1_irqs,
> +	.main_clk	= "l4ls_gclk",
> +	.opt_clks	= ehrpwm1_opt_clks,
> +	.opt_clks_cnt	= ARRAY_SIZE(ehrpwm1_opt_clks),
> +};
> +
> +/* epwmss2 */
> +static struct omap_hwmod am33xx_epwmss2_hwmod = {
> +	.name		= "epwmss2",
> +	.class		= &am33xx_epwmss_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.main_clk	= "l4ls_gclk",
>  	.prcm		= {
>  		.omap4	= {
> -			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET,
> +			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET,
>  			.modulemode	= MODULEMODE_SWCTRL,
>  		},
>  	},
> @@ -897,16 +952,49 @@ static struct omap_hwmod_irq_info am33xx_ecap2_irqs[] = {
>  
>  static struct omap_hwmod am33xx_ecap2_hwmod = {
>  	.name		= "ecap2",
> +	.class		= &am33xx_ecap_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
>  	.mpu_irqs	= am33xx_ecap2_irqs,
> -	.class		= &am33xx_epwmss_hwmod_class,
> +	.main_clk	= "l4ls_gclk",
> +};
> +
> +/* eqep2 */
> +static struct omap_hwmod_irq_info am33xx_eqep2_irqs[] = {
> +	{ .irq = 89 + OMAP_INTC_START, },
> +	{ .irq = -1 },
> +};
> +
> +static struct omap_hwmod am33xx_eqep2_hwmod = {
> +	.name		= "eqep2",
> +	.class		= &am33xx_eqep_hwmod_class,
>  	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_eqep2_irqs,
>  	.main_clk	= "l4ls_gclk",
> -	.prcm		= {
> -		.omap4	= {
> -			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET,
> -			.modulemode	= MODULEMODE_SWCTRL,
> -		},
> -	},
> +};
> +
> +/* ehrpwm2 */
> +static struct omap_hwmod_irq_info am33xx_ehrpwm2_irqs[] = {
> +	{ .name = "int", .irq = 39 + OMAP_INTC_START, },
> +	{ .name = "tzint", .irq = 60 + OMAP_INTC_START, },
> +	{ .irq = -1 },
> +};
> +
> +/*
> + * Optional clock entry is provided to support additional clock
> + * gating for EHRPWM module functional from control module.
> + */
> +static struct omap_hwmod_opt_clk ehrpwm2_opt_clks[] = {
> +	{ .role = "tbclk", .clk = "ehrpwm2_tbclk" },
> +};
> +
> +static struct omap_hwmod am33xx_ehrpwm2_hwmod = {
> +	.name		= "ehrpwm2",
> +	.class		= &am33xx_ehrpwm_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_ehrpwm2_irqs,
> +	.main_clk	= "l4ls_gclk",
> +	.opt_clks	= ehrpwm2_opt_clks,
> +	.opt_clks_cnt	= ARRAY_SIZE(ehrpwm2_opt_clks),
>  };
>  
>  /*
> @@ -2518,162 +2606,201 @@ static struct omap_hwmod_ocp_if am33xx_l4_ls__elm = {
>  	.user		= OCP_USER_MPU,
>  };
>  
> -/*
> - * Splitting the resources to handle access of PWMSS config space
> - * and module specific part independently
> - */
> -static struct omap_hwmod_addr_space am33xx_ehrpwm0_addr_space[] = {
> +static struct omap_hwmod_addr_space am33xx_epwmss0_addr_space[] = {
>  	{
>  		.pa_start	= 0x48300000,
>  		.pa_end		= 0x48300000 + SZ_16 - 1,
>  		.flags		= ADDR_TYPE_RT
>  	},
> -	{
> -		.pa_start	= 0x48300200,
> -		.pa_end		= 0x48300200 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> -	},
>  	{ }
>  };
>  
> -static struct omap_hwmod_ocp_if am33xx_l4_ls__ehrpwm0 = {
> +static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss0 = {
>  	.master		= &am33xx_l4_ls_hwmod,
> -	.slave		= &am33xx_ehrpwm0_hwmod,
> +	.slave		= &am33xx_epwmss0_hwmod,
>  	.clk		= "l4ls_gclk",
> -	.addr		= am33xx_ehrpwm0_addr_space,
> +	.addr		= am33xx_epwmss0_addr_space,
>  	.user		= OCP_USER_MPU,
>  };
>  
> -/*
> - * Splitting the resources to handle access of PWMSS config space
> - * and module specific part independently
> - */
> -static struct omap_hwmod_addr_space am33xx_ehrpwm1_addr_space[] = {
> -	{
> -		.pa_start	= 0x48302000,
> -		.pa_end		= 0x48302000 + SZ_16 - 1,
> -		.flags		= ADDR_TYPE_RT
> -	},
> +static struct omap_hwmod_addr_space am33xx_ecap0_addr_space[] = {
>  	{
> -		.pa_start	= 0x48302200,
> -		.pa_end		= 0x48302200 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_start	= 0x48300100,
> +		.pa_end		= 0x48300100 + SZ_128 - 1,
>  	},
>  	{ }
>  };
>  
> -static struct omap_hwmod_ocp_if am33xx_l4_ls__ehrpwm1 = {
> -	.master		= &am33xx_l4_ls_hwmod,
> -	.slave		= &am33xx_ehrpwm1_hwmod,
> +static struct omap_hwmod_ocp_if am33xx_epwmss0__ecap0 = {
> +	.master		= &am33xx_epwmss0_hwmod,
> +	.slave		= &am33xx_ecap0_hwmod,
>  	.clk		= "l4ls_gclk",
> -	.addr		= am33xx_ehrpwm1_addr_space,
> +	.addr		= am33xx_ecap0_addr_space,
>  	.user		= OCP_USER_MPU,
>  };
>  
> -/*
> - * Splitting the resources to handle access of PWMSS config space
> - * and module specific part independently
> - */
> -static struct omap_hwmod_addr_space am33xx_ehrpwm2_addr_space[] = {
> +static struct omap_hwmod_addr_space am33xx_eqep0_addr_space[] = {
>  	{
> -		.pa_start	= 0x48304000,
> -		.pa_end		= 0x48304000 + SZ_16 - 1,
> -		.flags		= ADDR_TYPE_RT
> -	},
> -	{
> -		.pa_start	= 0x48304200,
> -		.pa_end		= 0x48304200 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_start	= 0x48300180,
> +		.pa_end		= 0x48300180 + SZ_128 - 1,
>  	},
>  	{ }
>  };
>  
> -static struct omap_hwmod_ocp_if am33xx_l4_ls__ehrpwm2 = {
> -	.master		= &am33xx_l4_ls_hwmod,
> -	.slave		= &am33xx_ehrpwm2_hwmod,
> +static struct omap_hwmod_ocp_if am33xx_epwmss0__eqep0 = {
> +	.master		= &am33xx_epwmss0_hwmod,
> +	.slave		= &am33xx_eqep0_hwmod,
>  	.clk		= "l4ls_gclk",
> -	.addr		= am33xx_ehrpwm2_addr_space,
> +	.addr		= am33xx_eqep0_addr_space,
>  	.user		= OCP_USER_MPU,
>  };
>  
> -/*
> - * Splitting the resources to handle access of PWMSS config space
> - * and module specific part independently
> - */
> -static struct omap_hwmod_addr_space am33xx_ecap0_addr_space[] = {
> -	{
> -		.pa_start	= 0x48300000,
> -		.pa_end		= 0x48300000 + SZ_16 - 1,
> -		.flags		= ADDR_TYPE_RT
> -	},
> +static struct omap_hwmod_addr_space am33xx_ehrpwm0_addr_space[] = {
>  	{
> -		.pa_start	= 0x48300100,
> -		.pa_end		= 0x48300100 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_start	= 0x48300200,
> +		.pa_end		= 0x48300200 + SZ_128 - 1,
>  	},
>  	{ }
>  };
>  
> -static struct omap_hwmod_ocp_if am33xx_l4_ls__ecap0 = {
> -	.master		= &am33xx_l4_ls_hwmod,
> -	.slave		= &am33xx_ecap0_hwmod,
> +static struct omap_hwmod_ocp_if am33xx_epwmss0__ehrpwm0 = {
> +	.master		= &am33xx_epwmss0_hwmod,
> +	.slave		= &am33xx_ehrpwm0_hwmod,
>  	.clk		= "l4ls_gclk",
> -	.addr		= am33xx_ecap0_addr_space,
> +	.addr		= am33xx_ehrpwm0_addr_space,
>  	.user		= OCP_USER_MPU,
>  };
>  
> -/*
> - * Splitting the resources to handle access of PWMSS config space
> - * and module specific part independently
> - */
> -static struct omap_hwmod_addr_space am33xx_ecap1_addr_space[] = {
> +static struct omap_hwmod_addr_space am33xx_epwmss1_addr_space[] = {
>  	{
>  		.pa_start	= 0x48302000,
>  		.pa_end		= 0x48302000 + SZ_16 - 1,
>  		.flags		= ADDR_TYPE_RT
>  	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss1 = {
> +	.master		= &am33xx_l4_ls_hwmod,
> +	.slave		= &am33xx_epwmss1_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_epwmss1_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +static struct omap_hwmod_addr_space am33xx_ecap1_addr_space[] = {
>  	{
>  		.pa_start	= 0x48302100,
> -		.pa_end		= 0x48302100 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48302100 + SZ_128 - 1,
>  	},
>  	{ }
>  };
>  
> -static struct omap_hwmod_ocp_if am33xx_l4_ls__ecap1 = {
> -	.master		= &am33xx_l4_ls_hwmod,
> +static struct omap_hwmod_ocp_if am33xx_epwmss1__ecap1 = {
> +	.master		= &am33xx_epwmss1_hwmod,
>  	.slave		= &am33xx_ecap1_hwmod,
>  	.clk		= "l4ls_gclk",
>  	.addr		= am33xx_ecap1_addr_space,
>  	.user		= OCP_USER_MPU,
>  };
>  
> -/*
> - * Splitting the resources to handle access of PWMSS config space
> - * and module specific part independently
> - */
> -static struct omap_hwmod_addr_space am33xx_ecap2_addr_space[] = {
> +static struct omap_hwmod_addr_space am33xx_eqep1_addr_space[] = {
> +	{
> +		.pa_start	= 0x48302180,
> +		.pa_end		= 0x48302180 + SZ_128 - 1,
> +	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_epwmss1__eqep1 = {
> +	.master		= &am33xx_epwmss1_hwmod,
> +	.slave		= &am33xx_eqep1_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_eqep1_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +static struct omap_hwmod_addr_space am33xx_ehrpwm1_addr_space[] = {
> +	{
> +		.pa_start	= 0x48302200,
> +		.pa_end		= 0x48302200 + SZ_128 - 1,
> +	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_epwmss1__ehrpwm1 = {
> +	.master		= &am33xx_epwmss1_hwmod,
> +	.slave		= &am33xx_ehrpwm1_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_ehrpwm1_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +static struct omap_hwmod_addr_space am33xx_epwmss2_addr_space[] = {
>  	{
>  		.pa_start	= 0x48304000,
>  		.pa_end		= 0x48304000 + SZ_16 - 1,
>  		.flags		= ADDR_TYPE_RT
>  	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss2 = {
> +	.master		= &am33xx_l4_ls_hwmod,
> +	.slave		= &am33xx_epwmss2_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_epwmss2_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +static struct omap_hwmod_addr_space am33xx_ecap2_addr_space[] = {
>  	{
>  		.pa_start	= 0x48304100,
> -		.pa_end		= 0x48304100 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48304100 + SZ_128 - 1,
>  	},
>  	{ }
>  };
>  
> -static struct omap_hwmod_ocp_if am33xx_l4_ls__ecap2 = {
> -	.master		= &am33xx_l4_ls_hwmod,
> +static struct omap_hwmod_ocp_if am33xx_epwmss2__ecap2 = {
> +	.master		= &am33xx_epwmss2_hwmod,
>  	.slave		= &am33xx_ecap2_hwmod,
>  	.clk		= "l4ls_gclk",
>  	.addr		= am33xx_ecap2_addr_space,
>  	.user		= OCP_USER_MPU,
>  };
>  
> +static struct omap_hwmod_addr_space am33xx_eqep2_addr_space[] = {
> +	{
> +		.pa_start	= 0x48304180,
> +		.pa_end		= 0x48304180 + SZ_128 - 1,
> +	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_epwmss2__eqep2 = {
> +	.master		= &am33xx_epwmss2_hwmod,
> +	.slave		= &am33xx_eqep2_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_eqep2_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +static struct omap_hwmod_addr_space am33xx_ehrpwm2_addr_space[] = {
> +	{
> +		.pa_start	= 0x48304200,
> +		.pa_end		= 0x48304200 + SZ_128 - 1,
> +	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_epwmss2__ehrpwm2 = {
> +	.master		= &am33xx_epwmss2_hwmod,
> +	.slave		= &am33xx_ehrpwm2_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_ehrpwm2_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
>  /* l3s cfg -> gpmc */
>  static struct omap_hwmod_addr_space am33xx_gpmc_addr_space[] = {
>  	{
> @@ -3356,12 +3483,18 @@ static struct omap_hwmod_ocp_if *am33xx_hwmod_ocp_ifs[] __initdata = {
>  	&am33xx_l4_ls__uart6,
>  	&am33xx_l4_ls__spinlock,
>  	&am33xx_l4_ls__elm,
> -	&am33xx_l4_ls__ehrpwm0,
> -	&am33xx_l4_ls__ehrpwm1,
> -	&am33xx_l4_ls__ehrpwm2,
> -	&am33xx_l4_ls__ecap0,
> -	&am33xx_l4_ls__ecap1,
> -	&am33xx_l4_ls__ecap2,
> +	&am33xx_l4_ls__epwmss0,
> +	&am33xx_epwmss0__ecap0,
> +	&am33xx_epwmss0__eqep0,
> +	&am33xx_epwmss0__ehrpwm0,
> +	&am33xx_l4_ls__epwmss1,
> +	&am33xx_epwmss1__ecap1,
> +	&am33xx_epwmss1__eqep1,
> +	&am33xx_epwmss1__ehrpwm1,
> +	&am33xx_l4_ls__epwmss2,
> +	&am33xx_epwmss2__ecap2,
> +	&am33xx_epwmss2__eqep2,
> +	&am33xx_epwmss2__ehrpwm2,
>  	&am33xx_l3_s__gpmc,
>  	&am33xx_l3_main__lcdc,
>  	&am33xx_l4_ls__mcspi0,
> -- 
> 1.7.0.4
> 
> 

