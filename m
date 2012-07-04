Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189Ab2GDJzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:55:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:32867 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab2GDJzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:55:01 -0400
Message-ID: <4FF412F5.4030109@atmel.com>
Date: Wed, 4 Jul 2012 11:55:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] at91: first batch of cleanup for 3.6
References: <4FF19B6D.3010704@atmel.com> <201207022058.34442.arnd@arndb.de> <201207040742.56200.arnd@arndb.de>
In-Reply-To: <201207040742.56200.arnd@arndb.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 09:42 AM, Arnd Bergmann :
> On Monday 02 July 2012, Arnd Bergmann wrote:
>> On Monday 02 July 2012, Nicolas Ferre wrote:
>>> The following changes since commit
>>> 6887a4131da3adaab011613776d865f4bcfb5678:
>>>
>>>   Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
>>>
>>> are available in the git repository at:
>>>
>>>   git://github.com/at91linux/linux-at91.git tags/at91-for-next-cleanup
>>
>> Pulled into next/cleanup
> 
> Unfortunately, I got a bunch of new builf errors and warnings:
> 
> 8<----
> ARM: at91: fix new build errors
> 
> MULTI_IRQ_HANDLER and SPARSE_IRQ are now required everywhere because
> mach/irqs.h and mach/entry-macros.S are gone but the symbols are
> only selected for AT91SAM9, not for the NOMMU parts.
> 
> A few files now need to include linux/io.h directly, which used to
> be included through other headers that have changed.
> 
> The new at91_aic_irq_priorities variable is only used with CONFIG_OF
> enabled and should not be visible otherwise.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> Please check these patches for correctness, and try to be more careful
> to avoid such problems in the future. I found these just building the
> defconfig files, not even invoking my randconfig scripts.

Sorry for this Arnd, I should have triggered my building scripts earlier
for this request...

Tell me if you can queue your fixing patch or if you prefer that I
rework it and send it back a series to you...

Anyway, here is my:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


Thanks a lot.

> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 7d0c40a..c8050b1 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -37,6 +37,8 @@ config SOC_AT91SAM9
>  config SOC_AT91RM9200
>  	bool "AT91RM9200"
>  	select CPU_ARM920T
> +	select MULTI_IRQ_HANDLER
> +	select SPARSE_IRQ
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_AT91_DBGU0
>  
> @@ -142,6 +144,8 @@ config ARCH_AT91SAM9G45
>  config ARCH_AT91X40
>  	bool "AT91x40"
>  	depends on !MMU
> +	select MULTI_IRQ_HANDLER
> +	select SPARSE_IRQ
>  	select ARCH_USES_GETTIMEOFFSET
>  
>  endchoice
> diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
> index 4c0f5fd..46090e6 100644
> --- a/arch/arm/mach-at91/at91x40.c
> +++ b/arch/arm/mach-at91/at91x40.c
> @@ -13,6 +13,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/irq.h>
> +#include <linux/io.h>
>  #include <asm/proc-fns.h>
>  #include <asm/system_misc.h>
>  #include <asm/mach/arch.h>
> diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
> index c5eaaa0..1e02c0e 100644
> --- a/arch/arm/mach-at91/irq.c
> +++ b/arch/arm/mach-at91/irq.c
> @@ -49,7 +49,6 @@ static struct irq_domain *at91_aic_domain;
>  static struct device_node *at91_aic_np;
>  static unsigned int n_irqs = NR_AIC_IRQS;
>  static unsigned long at91_aic_caps = 0;
> -static unsigned int *at91_aic_irq_priorities;
>  
>  /* AIC5 introduces a Source Select Register */
>  #define AT91_AIC_CAP_AIC5	(1 << 0)
> @@ -359,6 +358,8 @@ static void __init __maybe_unused at91_aic5_hw_init(unsigned int spu_vector)
>  }
>  
>  #if defined(CONFIG_OF)
> +static unsigned int *at91_aic_irq_priorities;
> +
>  static int at91_aic_irq_map(struct irq_domain *h, unsigned int virq,
>  							irq_hw_number_t hw)
>  {
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index dc474bc..fca9790 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -27,6 +27,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/ioctl.h>
>  #include <linux/completion.h>
> +#include <linux/io.h>
>  
>  #include <asm/uaccess.h>
>  
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 


-- 
Nicolas Ferre


