Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2JWOub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:50:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2JWOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:50:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Date: Tue, 23 Oct 2012 14:50:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, John Linn <john.linn@xilinx.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210231450.11540.arnd@arndb.de>
X-Provags-ID: V02:K0:LrHcsoDGcdBcIfNPG4KwQeK3SU/m9whKVXEl5d4vX9K
 oFrjaog2cy0/Q0/8QlLKjLD7fF1sx7VCZ8tKAHvm8fCtyV3hd1
 hsqD0V/1Wh7nzf+mYmyk5CClPKH6K5+jL8YgxcQNxpcDHxqlDZ
 OPDqiqd9hsM03nhX83QXpDRFeMPjm89fn4sp3QqOEbFCD9rLjl
 wW1DrdFjdhirAh8FO+C6wd7QO9LM61qcZKBd2TbRCkVp3ENrE/
 uw5kGuX9lrk+aLM6TCOGEOyGjLtCwt+Sw40LH24ML6MORkJsEd
 hrtJr6BLUmcDdJTivuUznXTw3Be/q+FKfoM+2rzHPBbwHZnLJ2
 vHiXjBH6Ip4/GxvHKLd0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2012, Josh Cartwright wrote:
> Shifting them up into the vmalloc region prevents the following warning,
> when booting a zynq qemu target with more than 512mb of RAM:
> 
>   BUG: mapping for 0xe0000000 at 0xe0000000 out of vmalloc space
> 
> In addition, it allows for reuse of these mappings when the proper
> drivers issue requests via ioremap().
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>

This looks like a bug fix that should be backported to older kernels,
so it would be good to add 'Cc: stable@vger.kernel.org' below your
Signed-off-by.


> diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> index d0d3f8f..ae3b236 100644
> --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> @@ -15,33 +15,37 @@
>  #ifndef __MACH_XILINX_SOC_H__
>  #define __MACH_XILINX_SOC_H__
>  
> +#include <asm/pgtable.h>
> +
>  #define PERIPHERAL_CLOCK_RATE		2500000
>  
> -/* For now, all mappings are flat (physical = virtual)
> +/* Static peripheral mappings are mapped at the top of the
> + * vmalloc region
>   */
> -#define UART0_PHYS			0xE0000000
> -#define UART0_VIRT			UART0_PHYS
> +#define UART0_PHYS		0xE0000000
> +#define UART0_SIZE		SZ_4K
> +#define UART0_VIRT		(VMALLOC_END - UART0_SIZE)

There are plans to move the uart location into a fixed virtual
address in the future, but it hasn't been decided yet.
It will still need a fixed mapping though, just to a different
address.

> -#define TTC0_PHYS			0xF8001000
> -#define TTC0_VIRT			TTC0_PHYS
> +#define TTC0_PHYS		0xF8001000
> +#define TTC0_SIZE		SZ_4K
> +#define TTC0_VIRT		(UART0_VIRT - TTC0_SIZE)

It's quite likely that this does not have to be a fixed mapping
any more. Just have a look at how drivers/clocksource/dw_apb_timer_of.c
calls of_iomap() to get the address.

> -#define PL310_L2CC_PHYS			0xF8F02000
> -#define PL310_L2CC_VIRT			PL310_L2CC_PHYS
> +#define PL310_L2CC_PHYS		0xF8F02000
> +#define PL310_L2CC_SIZE		SZ_4K
> +#define PL310_L2CC_VIRT		(TTC0_VIRT - PL310_L2CC_SIZE)

This address would not need a fixed mapping by calling l2x0_of_init
rather than l2x0_init.

> -#define SCU_PERIPH_PHYS			0xF8F00000
> -#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
> +#define SCU_PERIPH_PHYS		0xF8F00000
> +#define SCU_PERIPH_SIZE		SZ_8K
> +#define SCU_PERIPH_VIRT		(PL310_L2CC_VIRT - SCU_PERIPH_SIZE)

And your patch 3 already obsoletes this mapping.

	Arnd
