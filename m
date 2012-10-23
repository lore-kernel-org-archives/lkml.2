Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab2JWUJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:09:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63055 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab2JWUJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:09:26 -0400
Message-ID: <5086F973.6050309@gmail.com>
Date: Tue, 23 Oct 2012 15:09:23 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Josh Cartwright <josh.cartwright@ni.com>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com> <201210231450.11540.arnd@arndb.de>
In-Reply-To: <201210231450.11540.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 09:50 AM, Arnd Bergmann wrote:
> On Monday 22 October 2012, Josh Cartwright wrote:
>> Shifting them up into the vmalloc region prevents the following warning,
>> when booting a zynq qemu target with more than 512mb of RAM:
>>
>>   BUG: mapping for 0xe0000000 at 0xe0000000 out of vmalloc space
>>
>> In addition, it allows for reuse of these mappings when the proper
>> drivers issue requests via ioremap().
>>
>> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> 
> This looks like a bug fix that should be backported to older kernels,
> so it would be good to add 'Cc: stable@vger.kernel.org' below your
> Signed-off-by.
> 
> 
>> diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
>> index d0d3f8f..ae3b236 100644
>> --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
>> +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
>> @@ -15,33 +15,37 @@
>>  #ifndef __MACH_XILINX_SOC_H__
>>  #define __MACH_XILINX_SOC_H__
>>  
>> +#include <asm/pgtable.h>
>> +
>>  #define PERIPHERAL_CLOCK_RATE		2500000
>>  
>> -/* For now, all mappings are flat (physical = virtual)
>> +/* Static peripheral mappings are mapped at the top of the
>> + * vmalloc region
>>   */
>> -#define UART0_PHYS			0xE0000000
>> -#define UART0_VIRT			UART0_PHYS
>> +#define UART0_PHYS		0xE0000000
>> +#define UART0_SIZE		SZ_4K
>> +#define UART0_VIRT		(VMALLOC_END - UART0_SIZE)
> 
> There are plans to move the uart location into a fixed virtual
> address in the future, but it hasn't been decided yet.
> It will still need a fixed mapping though, just to a different
> address.
> 
>> -#define TTC0_PHYS			0xF8001000
>> -#define TTC0_VIRT			TTC0_PHYS
>> +#define TTC0_PHYS		0xF8001000
>> +#define TTC0_SIZE		SZ_4K
>> +#define TTC0_VIRT		(UART0_VIRT - TTC0_SIZE)
> 
> It's quite likely that this does not have to be a fixed mapping
> any more. Just have a look at how drivers/clocksource/dw_apb_timer_of.c
> calls of_iomap() to get the address.
> 
>> -#define PL310_L2CC_PHYS			0xF8F02000
>> -#define PL310_L2CC_VIRT			PL310_L2CC_PHYS
>> +#define PL310_L2CC_PHYS		0xF8F02000
>> +#define PL310_L2CC_SIZE		SZ_4K
>> +#define PL310_L2CC_VIRT		(TTC0_VIRT - PL310_L2CC_SIZE)
> 
> This address would not need a fixed mapping by calling l2x0_of_init
> rather than l2x0_init.
> 
>> -#define SCU_PERIPH_PHYS			0xF8F00000
>> -#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
>> +#define SCU_PERIPH_PHYS		0xF8F00000
>> +#define SCU_PERIPH_SIZE		SZ_8K
>> +#define SCU_PERIPH_VIRT		(PL310_L2CC_VIRT - SCU_PERIPH_SIZE)
> 
> And your patch 3 already obsoletes this mapping.

Actually, it's probably still needed. The smp platform code typically
reads the number of cores from the SCU and the mapping has to be in
place before ioremap is up. I don't think there is an architected way to
get the number of cores, but it would be nice to avoid this early SCU
access. We could also mandate getting the core count from DT instead.

Also, the physical address can be read with this on A9's:

        asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));

Rob
