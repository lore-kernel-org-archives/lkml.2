Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab0I0RfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:35:20 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4028 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0I0RfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:35:16 -0400
Message-ID: <4CA0D5D3.3040700@caviumnetworks.com>
Date: Mon, 27 Sep 2010 10:35:15 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] MIPS: Convert DMA to use dma-mapping-common.h
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>	<1285281496-24696-6-git-send-email-ddaney@caviumnetworks.com> <20100927142628X.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100927142628X.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 17:35:15.0241 (UTC) FILETIME=[585FD190:01CB5E6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2010 10:30 PM, FUJITA Tomonori wrote:
> On Thu, 23 Sep 2010 15:38:12 -0700
> David Daney<ddaney@caviumnetworks.com>  wrote:
>
>> Use asm-generic/dma-mapping-common.h to handle all DMA mapping
>> operations and establish a default get_dma_ops() that forwards all
>> operations to the existing code.
>>
>> Augment dev_archdata to carry a pointer to the struct dma_map_ops,
>> allowing DMA operations to be overridden on a per device basis.
>> Currently this is never filled in, so the default dma_map_ops are
>> used.  A follow-on patch sets this for Octeon PCI devices.
>>
>> Also initialize the dma_debug system as it is now used if it is
>> configured.
>>
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> ---
>>   arch/mips/Kconfig                   |    2 +
>>   arch/mips/include/asm/device.h      |   15 +++-
>>   arch/mips/include/asm/dma-mapping.h |  125 +++++++++++++++++--------
>>   arch/mips/mm/dma-default.c          |  179 +++++++++++++---------------------
>>   4 files changed, 172 insertions(+), 149 deletions(-)
>>
>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>> index 6c33709..e68b89f 100644
>> --- a/arch/mips/Kconfig
>> +++ b/arch/mips/Kconfig
>> @@ -14,6 +14,8 @@ config MIPS
>>   	select HAVE_KRETPROBES
>>   	select RTC_LIB if !MACH_LOONGSON
>>   	select GENERIC_ATOMIC64 if !64BIT
>> +	select HAVE_DMA_ATTRS
>> +	select HAVE_DMA_API_DEBUG
>>
>>   mainmenu "Linux/MIPS Kernel Configuration"
>>
>> diff --git a/arch/mips/include/asm/device.h b/arch/mips/include/asm/device.h
>> index 06746c5..65bf274 100644
>> --- a/arch/mips/include/asm/device.h
>> +++ b/arch/mips/include/asm/device.h
>> @@ -3,4 +3,17 @@
>>    *
>>    * This file is released under the GPLv2
>>    */
>> -#include<asm-generic/device.h>
>> +#ifndef _ASM_MIPS_DEVICE_H
>> +#define _ASM_MIPS_DEVICE_H
>> +
>> +struct mips_dma_map_ops;
>> +
>> +struct dev_archdata {
>> +	/* DMA operations on that device */
>> +	struct mips_dma_map_ops	*dma_ops;
>> +};
>> +
>> +struct pdev_archdata {
>> +};
>> +
>> +#endif /* _ASM_MIPS_DEVICE_H*/
>> diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
>> index 18fbf7a..9a4c307 100644
>> --- a/arch/mips/include/asm/dma-mapping.h
>> +++ b/arch/mips/include/asm/dma-mapping.h
>> @@ -5,51 +5,67 @@
>>   #include<asm/cache.h>
>>   #include<asm-generic/dma-coherent.h>
>>
>> -void *dma_alloc_noncoherent(struct device *dev, size_t size,
>> -			   dma_addr_t *dma_handle, gfp_t flag);
>> +struct mips_dma_map_ops {
>> +	struct dma_map_ops dma_map_ops;
>> +	dma_addr_t (*phys_to_dma)(struct device *dev, phys_addr_t paddr);
>> +	phys_addr_t (*dma_to_phys)(struct device *dev, dma_addr_t daddr);
>> +};
>
> The above code doesn't look great but we don't want to add phys_to_dma
> and dma_to_phys to dma_map_ops struct, and these functions on MIPS
> looks too complicated for ifdef. So I guess that we need to live with
> the above code.
>

I think you have a point here.  I will attempt to move these two into a 
chip specific operations vector, and leave the more generic MIPS version 
with the simplified static definition.

Thanks,
David Daney
