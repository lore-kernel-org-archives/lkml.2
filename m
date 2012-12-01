Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2LAAOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:14:53 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38805 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab2LAAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:14:52 -0500
Message-ID: <50B94BF0.4080408@ozlabs.ru>
Date: Sat, 01 Dec 2012 11:14:40 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
References: <1354162826.1809.241.camel@bling.home>  <1354256043-24963-1-git-send-email-aik@ozlabs.ru> <1354294088.14547.36.camel@ul30vt.home>
In-Reply-To: <1354294088.14547.36.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/12 03:48, Alex Williamson wrote:
> On Fri, 2012-11-30 at 17:14 +1100, Alexey Kardashevskiy wrote:
>> This patch initializes IOMMU groups based on the IOMMU
>> configuration discovered during the PCI scan on POWERNV
>> (POWER non virtualized) platform. The IOMMU groups are
>> to be used later by VFIO driver (PCI pass through).
>>
>> It also implements an API for mapping/unmapping pages for
>> guest PCI drivers and providing DMA window properties.
>> This API is going to be used later by QEMU-VFIO to handle
>> h_put_tce hypercalls from the KVM guest.
>>
>> Although this driver has been tested only on the POWERNV
>> platform, it should work on any platform which supports
>> TCE tables.
>>
>> To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config
>> option and configure VFIO as required.
>>
>> Cc: David Gibson <david@gibson.dropbear.id.au>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>   arch/powerpc/include/asm/iommu.h     |    9 ++
>>   arch/powerpc/kernel/iommu.c          |  186 ++++++++++++++++++++++++++++++++++
>>   arch/powerpc/platforms/powernv/pci.c |  135 ++++++++++++++++++++++++
>>   drivers/iommu/Kconfig                |    8 ++
>>   4 files changed, 338 insertions(+)
>>
>> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
>> index cbfe678..5c7087a 100644
>> --- a/arch/powerpc/include/asm/iommu.h
>> +++ b/arch/powerpc/include/asm/iommu.h
>> @@ -76,6 +76,9 @@ struct iommu_table {
>>   	struct iommu_pool large_pool;
>>   	struct iommu_pool pools[IOMMU_NR_POOLS];
>>   	unsigned long *it_map;       /* A simple allocation bitmap for now */
>> +#ifdef CONFIG_IOMMU_API
>> +	struct iommu_group *it_group;
>> +#endif
>>   };
>>
>>   struct scatterlist;
>> @@ -147,5 +150,11 @@ static inline void iommu_restore(void)
>>   }
>>   #endif
>>
>> +extern long iommu_clear_tces(struct iommu_table *tbl, unsigned long entry,
>> +		unsigned long pages);
>> +extern long iommu_put_tces(struct iommu_table *tbl, unsigned long entry,
>> +		uint64_t tce, enum dma_data_direction direction,
>> +		unsigned long pages);
>> +
>>   #endif /* __KERNEL__ */
>>   #endif /* _ASM_IOMMU_H */
>> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
>> index ff5a6ce..0646c50 100644
>> --- a/arch/powerpc/kernel/iommu.c
>> +++ b/arch/powerpc/kernel/iommu.c
>> @@ -44,6 +44,7 @@
>>   #include <asm/kdump.h>
>>   #include <asm/fadump.h>
>>   #include <asm/vio.h>
>> +#include <asm/tce.h>
>>
>>   #define DBG(...)
>>
>> @@ -856,3 +857,188 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
>>   		free_pages((unsigned long)vaddr, get_order(size));
>>   	}
>>   }
>> +
>> +#ifdef CONFIG_IOMMU_API
>> +/*
>> + * SPAPR TCE API
>> + */
>> +
>> +/*
>> + * Returns the number of used IOMMU pages (4K) within
>> + * the same system page (4K or 64K).
>> + * bitmap_weight is not used as it does not support bigendian maps.
>> + */
>> +static int syspage_weight(unsigned long *map, unsigned long entry)
>> +{
>> +	int ret = 0, nbits = PAGE_SIZE/IOMMU_PAGE_SIZE;
>> +
>> +	/* Aligns TCE entry number to system page boundary */
>> +	entry &= PAGE_MASK >> IOMMU_PAGE_SHIFT;
>> +
>> +	/* Count used 4K pages */
>> +	while (nbits--)
>> +		ret += (test_bit(entry++, map) == 0) ? 0 : 1;
>
> Ok, entry is the iova page number.  So presumably it's relative to the
> start of dma32_window_start since you're unlikely to have a bitmap that
> covers all of memory.  I hadn't realized that previously.

No, it is zero based. The DMA window is a filter but not offset. But you 
are right, the it_map does not cover the whole global table (one per PHB, 
roughly), will fix it, thanks for pointing. On my test system IOMMU group 
is a whole PHB and DMA window always starts from 0 so tests do not show 
everything :)

> Doesn't that
> mean that it's actually impossible to create an ioctl based interface to
> the dma64_window since we're not going to know which window is the
> target?  I know you're not planning on one, but it seems limiting.

No ,it is not limiting as iova is zero based. Even if it was, there are 
flags in map/unmap ioctls which we could use, no?

> We
> at least need some documentation here, but I'm wondering if iova
> shouldn't be zero based so we can determine which window it hits.  Also,
> now that I look at it, I can't find any range checking on the iova.

True... Have not hit this problem yet :) Good point, will fix, thanks.



-- 
Alexey
