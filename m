Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2JDMXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:23:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54957 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab2JDMXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:23:16 -0400
Message-ID: <506D7F95.2030401@ti.com>
Date: Thu, 4 Oct 2012 17:52:45 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH v3 5/6] ARM: davinci: Add support for PRUSS on DA850
References: <1349276133-26408-1-git-send-email-mporter@ti.com> <1349276133-26408-6-git-send-email-mporter@ti.com>
In-Reply-To: <1349276133-26408-6-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2012 8:25 PM, Matt Porter wrote:
> Adds PRUSS clock, registers the L3RAM pool, and registers the
> platform device for uio_pruss on DA850.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

I am interested in knowing how this patch was tested.

> ---
>  arch/arm/mach-davinci/board-da850-evm.c    |   12 +++++
>  arch/arm/mach-davinci/da850.c              |    7 +++
>  arch/arm/mach-davinci/devices-da8xx.c      |   66 ++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/include/mach/da8xx.h |    2 +
>  4 files changed, 87 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 1295e61..acc6e84 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -29,6 +29,7 @@
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/tps6507x.h>
>  #include <linux/input/tps6507x-ts.h>
> +#include <linux/platform_data/uio_pruss.h>
>  #include <linux/spi/spi.h>
>  #include <linux/spi/flash.h>
>  #include <linux/delay.h>
> @@ -42,6 +43,7 @@
>  #include <mach/da8xx.h>
>  #include <linux/platform_data/mtd-davinci.h>
>  #include <mach/mux.h>
> +#include <mach/sram.h>
>  #include <linux/platform_data/mtd-davinci-aemif.h>
>  #include <linux/platform_data/spi-davinci.h>

I know you did not introduce the mess, but can you include a patch to
fix the mixture of mach/ and linux/ includes here? mach/ includes should
follow the linux/ includes.

>  
> @@ -1253,6 +1255,10 @@ static __init int da850_wl12xx_init(void)
>  
>  #endif /* CONFIG_DA850_WL12XX */
>  
> +struct uio_pruss_pdata da8xx_pruss_uio_pdata = {
> +	.pintc_base	= 0x4000,
> +};
> +
>  #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
>  
>  static __init void da850_evm_init(void)
> @@ -1339,6 +1345,12 @@ static __init void da850_evm_init(void)
>  		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",
>  				ret);
>  
> +	da8xx_pruss_uio_pdata.l3ram_pool = sram_get_gen_pool();

I wonder if this platform data should still be called l3ram pool. L3RAM
is OMAP terminology. May be just call it sram_pool? Also this patch
should follow 6/6 to prevent build breakage.

> +	ret = da8xx_register_pruss_uio(&da8xx_pruss_uio_pdata);
> +	if (ret)
> +		pr_warning("pruss_uio initialization failed: %d\n",
> +				ret);
> +
>  	/* Handle board specific muxing for LCD here */
>  	ret = davinci_cfg_reg_list(da850_evm_lcdc_pins);
>  	if (ret)
> diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> index d8d69de..7c01d31 100644
> --- a/arch/arm/mach-davinci/da850.c
> +++ b/arch/arm/mach-davinci/da850.c

Can you separate out board and SoC changes into different patches?

> @@ -212,6 +212,12 @@ static struct clk tptc2_clk = {
>  	.flags		= ALWAYS_ENABLED,
>  };
>  
> +static struct clk pruss_clk = {
> +	.name		= "pruss",
> +	.parent		= &pll0_sysclk2,
> +	.lpsc		= DA8XX_LPSC0_PRUSS,
> +};
> +
>  static struct clk uart0_clk = {
>  	.name		= "uart0",
>  	.parent		= &pll0_sysclk2,
> @@ -378,6 +384,7 @@ static struct clk_lookup da850_clks[] = {
>  	CLK(NULL,		"tptc1",	&tptc1_clk),
>  	CLK(NULL,		"tpcc1",	&tpcc1_clk),
>  	CLK(NULL,		"tptc2",	&tptc2_clk),
> +	CLK(NULL,		"pruss",	&pruss_clk),

This is actually incorrect since we should use device name rather than
con_id for matching the clock. If there is just one clock that the
driver needs, connection id should be NULL. Looking at the driver now,
the clk_get() call seems to pass a valid device pointer. So, I wonder
how you are able to look up the clock even with a NULL device name.

>  	CLK(NULL,		"uart0",	&uart0_clk),
>  	CLK(NULL,		"uart1",	&uart1_clk),
>  	CLK(NULL,		"uart2",	&uart2_clk),
> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index bd2f72b..7c2e0d2 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -518,6 +518,72 @@ void __init da8xx_register_mcasp(int id, struct snd_platform_data *pdata)
>  	}
>  }
>  
> +#define DA8XX_PRUSS_MEM_BASE		0x01C30000

In this file all base addresses are added at the top of the file. The
defines are sorted in ascending order of address. If that's broken, its
all my fault, but please don't add to the breakage when adding this entry :)

> +
> +static struct resource da8xx_pruss_resources[] = {
> +	{
> +		.start	= DA8XX_PRUSS_MEM_BASE,
> +		.end	= DA8XX_PRUSS_MEM_BASE + 0xFFFF,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT0,
> +		.end	= IRQ_DA8XX_EVTOUT0,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT1,
> +		.end	= IRQ_DA8XX_EVTOUT1,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT2,
> +		.end	= IRQ_DA8XX_EVTOUT2,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT3,
> +		.end	= IRQ_DA8XX_EVTOUT3,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT4,
> +		.end	= IRQ_DA8XX_EVTOUT4,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT5,
> +		.end	= IRQ_DA8XX_EVTOUT5,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT6,
> +		.end	= IRQ_DA8XX_EVTOUT6,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_DA8XX_EVTOUT7,
> +		.end	= IRQ_DA8XX_EVTOUT7,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device da8xx_pruss_uio_dev = {
> +	.name		= "pruss_uio",
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(da8xx_pruss_resources),
> +	.resource	= da8xx_pruss_resources,
> +	.dev	 =	{
> +		.coherent_dma_mask = 0xffffffff,

DMA_BIT_MASK(32)?

Thanks,
Sekhar
