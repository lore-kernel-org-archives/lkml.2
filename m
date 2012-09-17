Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2IQH4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:56:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:44332 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2IQH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:56:24 -0400
Message-ID: <5056D794.5000107@atmel.com>
Date: Mon, 17 Sep 2012 09:56:04 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 02/24] ARM: at91: use __iomem pointers for MMIO
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1347658492-11608-3-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 11:34 PM, Arnd Bergmann :
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
> 
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-at91/at91x40.c                 |    2 +-
>  arch/arm/mach-at91/at91x40_time.c            |    4 ++--
>  arch/arm/mach-at91/include/mach/hardware.h   |    4 ++--
>  arch/arm/mach-at91/include/mach/uncompress.h |    6 +++---
>  arch/arm/mach-at91/setup.c                   |    4 ++--
>  5 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
> index 46090e6..6bd7300 100644
> --- a/arch/arm/mach-at91/at91x40.c
> +++ b/arch/arm/mach-at91/at91x40.c
> @@ -47,7 +47,7 @@ static void at91x40_idle(void)
>  	 * Disable the processor clock.  The processor will be automatically
>  	 * re-enabled by an interrupt or by a reset.
>  	 */
> -	__raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);
> +	__raw_writel(AT91_PS_CR_CPU, AT91_IO_P2V(AT91_PS_CR));
>  	cpu_do_idle();
>  }
>  
> diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
> index 6ca680a..ee06d7b 100644
> --- a/arch/arm/mach-at91/at91x40_time.c
> +++ b/arch/arm/mach-at91/at91x40_time.c
> @@ -29,10 +29,10 @@
>  #include <mach/at91_tc.h>
>  
>  #define at91_tc_read(field) \
> -	__raw_readl(AT91_TC + field)
> +	__raw_readl(AT91_IO_P2V(AT91_TC) + field)
>  
>  #define at91_tc_write(field, value) \
> -	__raw_writel(value, AT91_TC + field);
> +	__raw_writel(value, AT91_IO_P2V(AT91_TC) + field);
>  
>  /*
>   *	3 counter/timer units present.
> diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
> index 09242b6..711a789 100644
> --- a/arch/arm/mach-at91/include/mach/hardware.h
> +++ b/arch/arm/mach-at91/include/mach/hardware.h
> @@ -67,13 +67,13 @@
>   * to 0xFEF78000 .. 0xFF000000.  (544Kb)
>   */
>  #define AT91_IO_PHYS_BASE	0xFFF78000
> -#define AT91_IO_VIRT_BASE	(0xFF000000 - AT91_IO_SIZE)
> +#define AT91_IO_VIRT_BASE	IOMEM(0xFF000000 - AT91_IO_SIZE)
>  #else
>  /*
>   * Identity mapping for the non MMU case.
>   */
>  #define AT91_IO_PHYS_BASE	AT91_BASE_SYS
> -#define AT91_IO_VIRT_BASE	AT91_IO_PHYS_BASE
> +#define AT91_IO_VIRT_BASE	IOMEM(AT91_IO_PHYS_BASE)
>  #endif
>  
>  #define AT91_IO_SIZE		(0xFFFFFFFF - AT91_IO_PHYS_BASE + 1)
> diff --git a/arch/arm/mach-at91/include/mach/uncompress.h b/arch/arm/mach-at91/include/mach/uncompress.h
> index 6f6118d..58c9d5b 100644
> --- a/arch/arm/mach-at91/include/mach/uncompress.h
> +++ b/arch/arm/mach-at91/include/mach/uncompress.h
> @@ -94,7 +94,7 @@ static const u32 uarts_sam9x5[] = {
>  	0,
>  };
>  
> -static inline const u32* decomp_soc_detect(u32 dbgu_base)
> +static inline const u32* decomp_soc_detect(void __iomem*dbgu_base)

A whitespace is missing before the *, no?

>  {
>  	u32 cidr, socid;
>  
> @@ -142,10 +142,10 @@ static inline void arch_decomp_setup(void)
>  	int i = 0;
>  	const u32* usarts;
>  
> -	usarts = decomp_soc_detect(AT91_BASE_DBGU0);
> +	usarts = decomp_soc_detect((void __iomem *)AT91_BASE_DBGU0);
>  
>  	if (!usarts)
> -		usarts = decomp_soc_detect(AT91_BASE_DBGU1);
> +		usarts = decomp_soc_detect((void __iomem *)AT91_BASE_DBGU1);
>  	if (!usarts) {
>  		at91_uart = NULL;
>  		return;
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 944bffb..e6f52de 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -73,7 +73,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
>  {
>  	struct map_desc *desc = &sram_desc[bank];
>  
> -	desc->virtual = AT91_IO_VIRT_BASE - length;
> +	desc->virtual = (unsigned long)AT91_IO_VIRT_BASE - length;
>  	if (bank > 0)
>  		desc->virtual -= sram_desc[bank - 1].length;
>  
> @@ -88,7 +88,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
>  }
>  
>  static struct map_desc at91_io_desc __initdata = {
> -	.virtual	= AT91_VA_BASE_SYS,
> +	.virtual	= (unsigned long)AT91_VA_BASE_SYS,
>  	.pfn		= __phys_to_pfn(AT91_BASE_SYS),
>  	.length		= SZ_16K,
>  	.type		= MT_DEVICE,
> 

Otherwise, look good.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

You can carry it directly in the arm-soc tree.

Bye,
-- 
Nicolas Ferre
