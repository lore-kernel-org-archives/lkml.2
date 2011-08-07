Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab1HGFdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 01:33:00 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38579 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1HGFcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 01:32:52 -0400
Date: Sat, 6 Aug 2011 21:57:51 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 2/2] AT91: dt: simple device tree support for
 at91sam9g45 family
Message-ID: <20110807035751.GC7667@ponder.secretlab.ca>
References: <56092075210001f40db485e0b126fe7c0c7b75ac.1312560476.git.nicolas.ferre@atmel.com>
 <bdd7c02a561bc0655e9dfd4586f42774f2347ca1.1312560476.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdd7c02a561bc0655e9dfd4586f42774f2347ca1.1312560476.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 05:24:53PM +0100, Nicolas Ferre wrote:
> Add basic device tree support for at91sam9g45 SoC family and the
> at91sam9m10g45ek board.
> DT is been used to describe the at91sam9g45 SoC memory and AIC. It also
> adds the dmaengine driver.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Hi Nicolas,

Looks like a great start.  I was glad we could work on this last week.
Some comments below.

> ---
>  arch/arm/mach-at91/Kconfig               |    8 ++++++
>  arch/arm/mach-at91/Makefile.boot         |    2 +
>  arch/arm/mach-at91/at91sam9g45_devices.c |    3 +-
>  arch/arm/mach-at91/board-sam9m10g45ek.c  |   36 ++++++++++++++++++++++++++++++
>  4 files changed, 48 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 2248467..973c725 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -407,6 +407,14 @@ config MACH_AT91SAM9M10G45EK
>  	  "ES" at the end of the name means that this board is an
>  	  Engineering Sample.
>  
> +config MACH_AT91SAM9M10G45EK_DT
> +	bool "Atmel AT91SAM9M10G45-EK Evaluation Kits with device-tree support"
> +	select USE_OF
> +	select MACH_AT91SAM9M10G45EK
> +	help
> +	  Select this if you want to experiment device-tree with
> +	  Atmel's AT91SAM9M10G45-EK Evaluation Kit.
> +

Now, while I push strongly for .dts files to avoid 'generic'
specification, the actual board support code should try to be as
generic as possible.  You may want to consider naming this
"MACH_AT91_DT" here.  (more below)

>  endif
>  
>  # ----------------------------------------------------------
> diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
> index 3462b81..78d384f 100644
> --- a/arch/arm/mach-at91/Makefile.boot
> +++ b/arch/arm/mach-at91/Makefile.boot
> @@ -16,3 +16,5 @@ else
>  params_phys-y	:= 0x20000100
>  initrd_phys-y	:= 0x20410000
>  endif
> +
> +dtb-$(CONFIG_MACH_AT91SAM9M10G45EK_DT) += at91sam9m10g45ek.dtb
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 600bffb..ff3b7fc 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -35,7 +35,8 @@
>   *  HDMAC - AHB DMA Controller
>   * -------------------------------------------------------------------- */
>  
> -#if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
> +#if (defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)) \
> +	&& !defined(CONFIG_OF)

You'll need to rework this.  Turning on CONFIG_OF should not
disable booting using the old method.

>  static u64 hdmac_dmamask = DMA_BIT_MASK(32);
>  
>  static struct at_dma_platform_data atdma_pdata = {
> diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
> index ad234cc..99e8617 100644
> --- a/arch/arm/mach-at91/board-sam9m10g45ek.c
> +++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
> @@ -26,6 +26,10 @@
>  #include <linux/clk.h>
>  #include <linux/atmel-mci.h>
>  
> +#include <linux/irqdomain.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>

device tree #includes are no different from other includes, You can
mis them in with the rest of the linux/ #include statements.

> +
>  #include <mach/hardware.h>
>  #include <video/atmel_lcdc.h>
>  
> @@ -413,6 +417,38 @@ static void __init ek_board_init(void)
>  	at91_pwm_leds(ek_pwm_led, ARRAY_SIZE(ek_pwm_led));
>  }
>  
> +#if defined(CONFIG_OF)
> +static const struct of_device_id aic_of_match[] __initconst = {
> +	{ .compatible = "atmel,aic", },
> +	{},
> +};
> +
> +static void __init at91sam9g45_dt_device_init(void)
> +{
> +	irq_domain_generate_simple(aic_of_match, 0xfffff000, 0);
> +
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +
> +	/* remaining initialization */
> +	ek_board_init(void)
> +}

Following from my comment earlier, this is fine for the proof of
concept, but it isn't ready for mainline.  For mainline you'll need to
get enough devices working with DT to boot the board without calling
(ek_board_init()), and then add a new board file which only calls
of_platform_populate().  To get started, you'll probably only need
serial working.  Other driver can be fixed up one at a time until the
DT support is at the same level as the old board files.  At that point
the old method can be removed from the tree without any regressions.

g.
