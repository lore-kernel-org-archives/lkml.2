Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab0EJWel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:34:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:4569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0EJWej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:34:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,203,1272870000"; 
   d="scan'208";a="516742806"
Date: Tue, 11 May 2010 00:35:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       Mattias Wallin <mattias.wallin@stericsson.com>
Subject: Re: [PATCH 4/4] ARM: AB3550 board configuration and irq for U300 v2
Message-ID: <20100510223521.GD3288@sortiz.org>
References: <1272731200-30492-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272731200-30492-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, May 01, 2010 at 06:26:40PM +0200, Linus Walleij wrote:
> From: Mattias Wallin <mattias.wallin@stericsson.com>
> 
> This patch adds the i2c board configuration needed for the
> Mixed Signal chip AB3550. It also adds the irq numbers needed
> for the irq_chip implementation.
Patch applied, many thanks.

Cheers,
Samuel.


> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  arch/arm/mach-u300/i2c.c               |   55 ++++++++++++++++++++++++++++++++
>  arch/arm/mach-u300/include/mach/irqs.h |    7 ++++
>  2 files changed, 62 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
> index d893ee0..f0394ba 100644
> --- a/arch/arm/mach-u300/i2c.c
> +++ b/arch/arm/mach-u300/i2c.c
> @@ -46,6 +46,7 @@
>  /* BUCK SLEEP 0xAC: 1.05V, Not used, SLEEP_A and B, Not used */
>  #define BUCK_SLEEP_SETTING	0xAC
>  
> +#ifdef CONFIG_AB3100_CORE
>  static struct regulator_consumer_supply supply_ldo_c[] = {
>  	{
>  		.dev_name = "ab3100-codec",
> @@ -253,14 +254,68 @@ static struct ab3100_platform_data ab3100_plf_data = {
>  		LDO_D_SETTING,
>  	},
>  };
> +#endif
> +
> +#ifdef CONFIG_AB3550_CORE
> +static struct abx500_init_settings ab3550_init_settings[] = {
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR1,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR2,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR3,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR4,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR5,
> +		/* The two most significant bits are not used */
> +		.setting = 0x3f
> +	},
> +};
> +
> +static struct ab3550_platform_data ab3550_plf_data = {
> +	.irq = {
> +		.base = IRQ_AB3550_BASE,
> +		.count = (IRQ_AB3550_END - IRQ_AB3550_BASE + 1),
> +	},
> +	.dev_data = {
> +	},
> +	.init_settings = ab3550_init_settings,
> +	.init_settings_sz = ARRAY_SIZE(ab3550_init_settings),
> +};
> +#endif
>  
>  static struct i2c_board_info __initdata bus0_i2c_board_info[] = {
> +#if defined(CONFIG_AB3550_CORE)
> +	{
> +		.type = "ab3550",
> +		.addr = 0x4A,
> +		.irq = IRQ_U300_IRQ0_EXT,
> +		.platform_data = &ab3550_plf_data,
> +	},
> +#elif defined(CONFIG_AB3100_CORE)
>  	{
>  		.type = "ab3100",
>  		.addr = 0x48,
>  		.irq = IRQ_U300_IRQ0_EXT,
>  		.platform_data = &ab3100_plf_data,
>  	},
> +#else
> +	{ },
> +#endif
>  };
>  
>  static struct i2c_board_info __initdata bus1_i2c_board_info[] = {
> diff --git a/arch/arm/mach-u300/include/mach/irqs.h b/arch/arm/mach-u300/include/mach/irqs.h
> index a6867b1..09b1b28 100644
> --- a/arch/arm/mach-u300/include/mach/irqs.h
> +++ b/arch/arm/mach-u300/include/mach/irqs.h
> @@ -109,6 +109,13 @@
>  #define U300_NR_IRQS			48
>  #endif
>  
> +#ifdef CONFIG_AB3550_CORE
> +#define IRQ_AB3550_BASE			(U300_NR_IRQS)
> +#define IRQ_AB3550_END			(IRQ_AB3550_BASE + 37)
> +
> +#define NR_IRQS				(IRQ_AB3550_END + 1)
> +#else
>  #define NR_IRQS U300_NR_IRQS
> +#endif
>  
>  #endif
> -- 
> 1.7.0.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
