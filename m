Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab2K0E60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:58:26 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55484 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2K0E6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:58:24 -0500
Message-ID: <50B44866.5000905@ozlabs.ru>
Date: Tue, 27 Nov 2012 15:58:14 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio powerpc: implemented IOMMU driver for VFIO
References: <1353435584.2234.87.camel@bling.home>   <1353661396-14374-1-git-send-email-aik@ozlabs.ru>   <1353661396-14374-2-git-send-email-aik@ozlabs.ru>  <1353954038.1809.114.camel@bling.home> <50B43C36.60707@ozlabs.ru> <1353990588.1809.148.camel@bling.home>
In-Reply-To: <1353990588.1809.148.camel@bling.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/12 15:29, Alex Williamson wrote:
> On Tue, 2012-11-27 at 15:06 +1100, Alexey Kardashevskiy wrote:
>> On 27/11/12 05:20, Alex Williamson wrote:
>>> On Fri, 2012-11-23 at 20:03 +1100, Alexey Kardashevskiy wrote:
>>>> VFIO implements platform independent stuff such as
>>>> a PCI driver, BAR access (via read/write on a file descriptor
>>>> or direct mapping when possible) and IRQ signaling.
>>>>
>>>> The platform dependent part includes IOMMU initialization
>>>> and handling. This patch implements an IOMMU driver for VFIO
>>>> which does mapping/unmapping pages for the guest IO and
>>>> provides information about DMA window (required by a POWERPC
>>>> guest).
>>>>
>>>> The counterpart in QEMU is required to support this functionality.
>>>>
>>>> Cc: David Gibson <david@gibson.dropbear.id.au>
>>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>> ---
>>>>    drivers/vfio/Kconfig                |    6 +
>>>>    drivers/vfio/Makefile               |    1 +
>>>>    drivers/vfio/vfio_iommu_spapr_tce.c |  247 +++++++++++++++++++++++++++++++++++
>>>>    include/linux/vfio.h                |   20 +++
>>>>    4 files changed, 274 insertions(+)
>>>>    create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c
>>>>
>>>> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
>>>> index 7cd5dec..b464687 100644
>>>> --- a/drivers/vfio/Kconfig
>>>> +++ b/drivers/vfio/Kconfig
>>>> @@ -3,10 +3,16 @@ config VFIO_IOMMU_TYPE1
>>>>    	depends on VFIO
>>>>    	default n
>>>>
>>>> +config VFIO_IOMMU_SPAPR_TCE
>>>> +	tristate
>>>> +	depends on VFIO && SPAPR_TCE_IOMMU
>>>> +	default n
>>>> +
>>>>    menuconfig VFIO
>>>>    	tristate "VFIO Non-Privileged userspace driver framework"
>>>>    	depends on IOMMU_API
>>>>    	select VFIO_IOMMU_TYPE1 if X86
>>>> +	select VFIO_IOMMU_SPAPR_TCE if PPC_POWERNV
>>>>    	help
>>>>    	  VFIO provides a framework for secure userspace device drivers.
>>>>    	  See Documentation/vfio.txt for more details.
>>>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>>>> index 2398d4a..72bfabc 100644
>>>> --- a/drivers/vfio/Makefile
>>>> +++ b/drivers/vfio/Makefile
>>>> @@ -1,3 +1,4 @@
>>>>    obj-$(CONFIG_VFIO) += vfio.o
>>>>    obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>>>> +obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>>>>    obj-$(CONFIG_VFIO_PCI) += pci/
>>>> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
>>>> new file mode 100644
>>>> index 0000000..46a6298
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
>>>> @@ -0,0 +1,247 @@
>>>> +/*
>>>> + * VFIO: IOMMU DMA mapping support for TCE on POWER
>>>> + *
>>>> + * Copyright (C) 2012 IBM Corp.  All rights reserved.
>>>> + *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + *
>>>> + * Derived from original vfio_iommu_type1.c:
>>>> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
>>>> + *     Author: Alex Williamson <alex.williamson@redhat.com>
>>>> + */
>>>> +
>>>> +#include <linux/module.h>
>>>> +#include <linux/pci.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/uaccess.h>
>>>> +#include <linux/err.h>
>>>> +#include <linux/vfio.h>
>>>> +#include <asm/iommu.h>
>>>> +
>>>> +#define DRIVER_VERSION  "0.1"
>>>> +#define DRIVER_AUTHOR   "aik@ozlabs.ru"
>>>> +#define DRIVER_DESC     "VFIO IOMMU SPAPR TCE"
>>>> +
>>>> +static void tce_iommu_detach_group(void *iommu_data,
>>>> +		struct iommu_group *iommu_group);
>>>> +
>>>> +/*
>>>> + * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
>>>> + */
>>>> +
>>>> +/*
>>>> + * The container descriptor supports only a single group per container.
>>>> + * Required by the API as the container is not supplied with the IOMMU group
>>>> + * at the moment of initialization.
>>>> + */
>>>> +struct tce_container {
>>>> +	struct mutex lock;
>>>> +	struct iommu_table *tbl;
>>>> +};
>>>> +
>>>> +static void *tce_iommu_open(unsigned long arg)
>>>> +{
>>>> +	struct tce_container *container;
>>>> +
>>>> +	if (arg != VFIO_SPAPR_TCE_IOMMU) {
>>>> +		printk(KERN_ERR "tce_vfio: Wrong IOMMU type\n");
>>>> +		return ERR_PTR(-EINVAL);
>>>> +	}
>>>> +
>>>> +	container = kzalloc(sizeof(*container), GFP_KERNEL);
>>>> +	if (!container)
>>>> +		return ERR_PTR(-ENOMEM);
>>>> +
>>>> +	mutex_init(&container->lock);
>>>> +
>>>> +	return container;
>>>> +}
>>>> +
>>>> +static void tce_iommu_release(void *iommu_data)
>>>> +{
>>>> +	struct tce_container *container = iommu_data;
>>>> +
>>>> +	WARN_ON(container->tbl && !container->tbl->it_group);
>>>
>>> I think your patch ordering is backwards here.  it_group isn't added
>>> until 2/2.  I'd really like to see the arch/powerpc code approved and
>>> merged by the powerpc maintainer before we add the code that makes use
>>> of it into vfio.  Otherwise we just get lots of churn if interfaces
>>> change or they disapprove of it altogether.
>>
>>
>> Makes sense, thanks.
>>
>>
>>>> +	if (container->tbl && container->tbl->it_group)
>>>> +		tce_iommu_detach_group(iommu_data, container->tbl->it_group);
>>>> +
>>>> +	mutex_destroy(&container->lock);
>>>> +
>>>> +	kfree(container);
>>>> +}
>>>> +
>>>> +static long tce_iommu_ioctl(void *iommu_data,
>>>> +				 unsigned int cmd, unsigned long arg)
>>>> +{
>>>> +	struct tce_container *container = iommu_data;
>>>> +	unsigned long minsz;
>>>> +
>>>> +	switch (cmd) {
>>>> +	case VFIO_CHECK_EXTENSION: {
>>>> +		return (arg == VFIO_SPAPR_TCE_IOMMU) ? 1 : 0;
>>>> +	}
>>>> +	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
>>>> +		struct vfio_iommu_spapr_tce_info info;
>>>> +		struct iommu_table *tbl = container->tbl;
>>>> +
>>>> +		if (WARN_ON(!tbl))
>>>> +			return -ENXIO;
>>>> +
>>>> +		minsz = offsetofend(struct vfio_iommu_spapr_tce_info,
>>>> +				dma64_window_size);
>>>> +
>>>> +		if (copy_from_user(&info, (void __user *)arg, minsz))
>>>> +			return -EFAULT;
>>>> +
>>>> +		if (info.argsz < minsz)
>>>> +			return -EINVAL;
>>>> +
>>>> +		info.dma32_window_start = tbl->it_offset << IOMMU_PAGE_SHIFT;
>>>> +		info.dma32_window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
>>>> +		info.dma64_window_start = 0;
>>>> +		info.dma64_window_size = 0;
>>>> +		info.flags = 0;
>>>> +
>>>> +		if (copy_to_user((void __user *)arg, &info, minsz))
>>>> +			return -EFAULT;
>>>> +
>>>> +		return 0;
>>>> +	}
>>>> +	case VFIO_IOMMU_MAP_DMA: {
>>>> +		vfio_iommu_spapr_tce_dma_map param;
>>>> +		struct iommu_table *tbl = container->tbl;
>>>> +		enum dma_data_direction direction = DMA_NONE;
>>>> +
>>>> +		if (WARN_ON(!tbl))
>>>> +			return -ENXIO;
>>>> +
>>>> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_map, size);
>>>> +
>>>> +		if (copy_from_user(&param, (void __user *)arg, minsz))
>>>> +			return -EFAULT;
>>>> +
>>>> +		if (param.argsz < minsz)
>>>> +			return -EINVAL;
>>>> +
>>>> +		if ((param.flags & VFIO_DMA_MAP_FLAG_READ) &&
>>>> +				(param.flags & VFIO_DMA_MAP_FLAG_WRITE)) {
>>>> +			direction = DMA_BIDIRECTIONAL;
>>>> +		} else if (param.flags & VFIO_DMA_MAP_FLAG_READ) {
>>>> +			direction = DMA_TO_DEVICE;
>>>> +		} else if (param.flags & VFIO_DMA_MAP_FLAG_WRITE) {
>>>> +			direction = DMA_FROM_DEVICE;
>>>> +		}
>>>> +
>>>> +		param.size += param.iova & ~IOMMU_PAGE_MASK;
>>>> +		param.size = _ALIGN_UP(param.size, IOMMU_PAGE_SIZE);
>>>
>>> On x86 we force iova, vaddr, and size to all be aligned to the smallest
>>> page granularity of the iommu and return -EINVAL if it doesn't fit.
>>> What does it imply to the user if they're always aligned to work here?
>>> Won't this interface happily map overlapping entries with no indication
>>> to the user that the previous mapping is no longer valid?
>>> Maybe another reason why a combined unmap/map makes me nervous, we have
>>> to assume the user knows what they're doing.
>>
>>
>> I got used to guests which do know what they are doing so I am pretty calm :)
>> but ok, I'll move alignment to the QEMU, it makes sense.
>>
>>
>>>> +
>>>> +		return iommu_put_tces(tbl, param.iova >> IOMMU_PAGE_SHIFT,
>>>> +				param.vaddr & IOMMU_PAGE_MASK, direction,
>>>> +				param.size >> IOMMU_PAGE_SHIFT);
>>>> +	}
>>>> +	case VFIO_IOMMU_UNMAP_DMA: {
>>>> +		vfio_iommu_spapr_tce_dma_unmap param;
>>>> +		struct iommu_table *tbl = container->tbl;
>>>> +
>>>> +		if (WARN_ON(!tbl))
>>>> +			return -ENXIO;
>>>> +
>>>> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_unmap, size);
>>>> +
>>>> +		if (copy_from_user(&param, (void __user *)arg, minsz))
>>>> +			return -EFAULT;
>>>> +
>>>> +		if (param.argsz < minsz)
>>>> +			return -EINVAL;
>>>> +
>>>> +		param.size += param.iova & ~IOMMU_PAGE_MASK;
>>>> +		param.size = _ALIGN_UP(param.size, IOMMU_PAGE_SIZE);
>>>> +
>>>> +		return iommu_put_tces(tbl, param.iova >> IOMMU_PAGE_SHIFT,
>>>> +				0, DMA_NONE, param.size >> IOMMU_PAGE_SHIFT);
>>>> +	}
>>>> +	default:
>>>> +		printk(KERN_WARNING "tce_vfio: unexpected cmd %x\n", cmd);
>>>
>>> pr_warn
>>>
>>>> +	}
>>>> +
>>>> +	return -ENOTTY;
>>>> +}
>>>> +
>>>> +static int tce_iommu_attach_group(void *iommu_data,
>>>> +		struct iommu_group *iommu_group)
>>>> +{
>>>> +	struct tce_container *container = iommu_data;
>>>> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
>>>> +
>>>> +	BUG_ON(!tbl);
>>>> +	mutex_lock(&container->lock);
>>>> +	pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
>>>> +			iommu_group_id(iommu_group), iommu_group);
>>>> +	if (container->tbl) {
>>>> +		printk(KERN_WARNING "tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
>>>
>>> pr_warn
>>>
>>>> +				iommu_group_id(container->tbl->it_group),
>>>> +				iommu_group_id(iommu_group));
>>>> +		mutex_unlock(&container->lock);
>>>> +		return -EBUSY;
>>>> +	}
>>>> +
>>>> +	container->tbl = tbl;
>>>
>>> Would it be too much paranoia to clear all the tce here as you do below
>>> on detach?
>>
>> Guess so. I do unmap on detach() and the guest calls put_tce(0) (i.e.
>> unmaps) the whole DMA window at the boot time.
>
> But that's just one user of this interface, we can't assume they'll all
> be so agreeable.  If any tces were enabled here, a malicious user would
> have a window to host memory, right?  Thanks,


But I still release pages on detach(), how can this code be not called on 
the guest exit (normal or crashed)?



>
> Alex
>


-- 
Alexey
