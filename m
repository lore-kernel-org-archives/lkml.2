Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1LWNWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:22:22 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60817 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab1LWNWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:22:11 -0500
Date: Fri, 23 Dec 2011 09:22:00 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Brown, Len" <len.brown@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 06/10] Xen: Add memory hotadd to pvops dom0
Message-ID: <20111223132200.GE25286@andromeda.dapyr.net>
References: <DE8DF0795D48FD4CA783C40EC82923359700@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923359700@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:28:21AM +0000, Liu, Jinsong wrote:
> >From a5d21e2a01049eef6aa64406e71f6574e7a371c1 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Sun, 11 Dec 2011 21:51:28 +0800
> Subject: [PATCH 06/10] Xen: Add memory hotadd to pvops dom0
> 
> This patch rebased from Jeremy's pvops commit
> fe3cb1ebf78399fd5176ff6aa1c9ab498f2d8bd7
> 
> When memory hotadd event happen, a Xen hook will be called, to notify
> hypervisor of the new added memory.
> 
> Because xen hypervisor will use the new memory to setup frametable/m2p
> table, so dom0 will always return success to acpi bios, and notify xen
> hypervisor later.
> 
> It add a hook in driver/acpi/acpi_memhotplug.c, but that change is
> quite small, not sure if it is acceptable. Other method is to provide
> a xen specific acpi_memory_device_driver, but I'm not sure if it worth
> to add so much changes, to simply avoid two hooks.

Have you looked at the balloon hotplug memory code? Daniel Kiper did a
bunch of work in this area to make the balloon code use the generic
hotplug mechanism to expand the memory. Can you leverage some of his
work for this functionality?? (search using 'git log --grep=Daniel'
to find his work).

Can you also provide details of what kind of hardware has this and how
one would test it? Would this work for example with the IBM x3850?

> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/acpi/acpi_memhotplug.c    |    4 +
>  drivers/xen/Makefile              |    1 +
>  drivers/xen/xen_acpi_memhotplug.c |  209 +++++++++++++++++++++++++++++++++++++
>  include/xen/acpi.h                |    5 +
>  include/xen/interface/platform.h  |    9 ++
>  5 files changed, 228 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/xen/xen_acpi_memhotplug.c
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index e28e64d..2f2169e 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -32,6 +32,7 @@
>  #include <linux/memory_hotplug.h>
>  #include <linux/slab.h>
>  #include <acpi/acpi_drivers.h>
> +#include <xen/acpi.h>
>  
>  #define ACPI_MEMORY_DEVICE_CLASS		"memory"
>  #define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
> @@ -214,6 +215,9 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>  		return result;
>  	}
>  
> +	if (xen_initial_domain())
> +		return xen_hotadd_memory(mem_device);
> +
>  	node = acpi_get_node(mem_device->device->handle);
>  	/*
>  	 * Tell the VM there is more memory here...
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index aedaf48..7dc3c0b 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
>  obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
> +obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= xen_acpi_memhotplug.o
>  ifdef CONFIG_ACPI_PROCESSOR_XEN
>  obj-$(CONFIG_ACPI_PROCESSOR)		+= acpi_processor.o
>  endif
> diff --git a/drivers/xen/xen_acpi_memhotplug.c b/drivers/xen/xen_acpi_memhotplug.c
> new file mode 100644
> index 0000000..0c4af99
> --- /dev/null
> +++ b/drivers/xen/xen_acpi_memhotplug.c
> @@ -0,0 +1,209 @@
> +/*
> + *  xen_acpi_memhotplug.c - interface to notify Xen on memory device hotadd
> + *
> + *  Copyright (C) 2008, Intel corporation
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or (at
> + *  your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.

Get rid of that please. The address can change.

Hm, going to stop looking at the patch here - will wait until you take a
look at Daniel's work and see if you can use some of it.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/memory_hotplug.h>
> +#include <acpi/acpi_drivers.h>
> +#include <xen/interface/platform.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +#include <xen/acpi.h>
> +
> +struct xen_hotmem_entry {
> +	struct list_head hotmem_list;
> +	uint64_t start;
> +	uint64_t end;
> +	uint32_t flags;
> +	uint32_t pxm;
> +};
> +
> +struct xen_hotmem_list {
> +	struct list_head list;
> +	int entry_nr;
> +} xen_hotmem;
> +
> +DEFINE_SPINLOCK(xen_hotmem_lock);
> +
> +static int xen_hyper_addmem(struct xen_hotmem_entry *entry)
> +{
> +	int ret;
> +
> +	xen_platform_op_t op = {
> +		.cmd            = XENPF_mem_hotadd,
> +		.interface_version  = XENPF_INTERFACE_VERSION,
> +	};
> +	op.u.mem_add.spfn = entry->start >> PAGE_SHIFT;
> +	op.u.mem_add.epfn = entry->end >> PAGE_SHIFT;
> +	op.u.mem_add.flags = entry->flags;
> +	op.u.mem_add.pxm = entry->pxm;
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	return ret;
> +}
> +
> +static int add_hotmem_entry(int pxm, uint64_t start,
> +			uint64_t length, uint32_t flags)
> +{
> +	struct xen_hotmem_entry *entry;
> +
> +	if (pxm < 0 || !length)
> +		return -EINVAL;
> +
> +	entry = kzalloc(sizeof(struct xen_hotmem_entry), GFP_ATOMIC);
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&entry->hotmem_list);
> +	entry->start = start;
> +	entry->end = start + length;
> +	entry->flags = flags;
> +	entry->pxm = pxm;
> +
> +	spin_lock(&xen_hotmem_lock);
> +
> +	list_add_tail(&entry->hotmem_list, &xen_hotmem.list);
> +	xen_hotmem.entry_nr++;
> +
> +	spin_unlock(&xen_hotmem_lock);
> +
> +	return 0;
> +}
> +
> +static int free_hotmem_entry(struct xen_hotmem_entry *entry)
> +{
> +	list_del(&entry->hotmem_list);
> +	kfree(entry);
> +
> +	return 0;
> +}
> +
> +static void xen_hotadd_mem_dpc(struct work_struct *work)
> +{
> +	struct list_head *elem, *tmp;
> +	struct xen_hotmem_entry *entry;
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&xen_hotmem_lock, flags);
> +	list_for_each_safe(elem, tmp, &xen_hotmem.list) {
> +		entry = list_entry(elem, struct xen_hotmem_entry, hotmem_list);
> +		ret = xen_hyper_addmem(entry);
> +		if (ret)
> +			printk(KERN_WARNING "xen addmem failed with %x\n", ret);
> +		free_hotmem_entry(entry);
> +		xen_hotmem.entry_nr--;
> +	}
> +	spin_unlock_irqrestore(&xen_hotmem_lock, flags);
> +}
> +
> +static DECLARE_WORK(xen_hotadd_mem_work, xen_hotadd_mem_dpc);
> +
> +static int xen_acpi_get_pxm(acpi_handle h)
> +{
> +	unsigned long long pxm;
> +	acpi_status status;
> +	acpi_handle handle;
> +	acpi_handle phandle = h;
> +
> +	do {
> +		handle = phandle;
> +		status = acpi_evaluate_integer(handle, "_PXM", NULL, &pxm);
> +		if (ACPI_SUCCESS(status))
> +			return pxm;
> +		status = acpi_get_parent(handle, &phandle);
> +	} while (ACPI_SUCCESS(status));
> +
> +	return -1;
> +}
> +
> +int xen_hotadd_memory(struct acpi_memory_device *mem_device)
> +{
> +	int pxm, result;
> +	int num_enabled = 0;
> +	struct acpi_memory_info *info;
> +
> +	if (!mem_device)
> +		return -EINVAL;
> +
> +	pxm = xen_acpi_get_pxm(mem_device->device->handle);
> +
> +	if (pxm < 0)
> +		return -EINVAL;
> +
> +	/*
> +	 * Always return success to ACPI driver, and notify hypervisor later
> +	 * because hypervisor will utilize the memory in memory hotadd hypercall
> +	 */
> +	list_for_each_entry(info, &mem_device->res_list, list) {
> +		if (info->enabled) { /* just sanity check...*/
> +			num_enabled++;
> +			continue;
> +		}
> +		/*
> +		 * If the memory block size is zero, please ignore it.
> +		 * Don't try to do the following memory hotplug flowchart.
> +		 */
> +		if (!info->length)
> +			continue;
> +
> +		result = add_hotmem_entry(pxm, info->start_addr,
> +					info->length, 0);
> +		if (result)
> +			continue;
> +		info->enabled = 1;
> +		num_enabled++;
> +	}
> +
> +	if (!num_enabled)
> +		return -EINVAL;
> +
> +	schedule_work(&xen_hotadd_mem_work);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(xen_hotadd_memory);
> +
> +static int xen_hotadd_mem_init(void)
> +{
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	INIT_LIST_HEAD(&xen_hotmem.list);
> +	xen_hotmem.entry_nr = 0;
> +
> +	return 0;
> +}
> +
> +static void xen_hotadd_mem_exit(void)
> +{
> +	flush_scheduled_work();
> +}
> +
> +module_init(xen_hotadd_mem_init);
> +module_exit(xen_hotadd_mem_exit);
> +MODULE_LICENSE("GPL");
> diff --git a/include/xen/acpi.h b/include/xen/acpi.h
> index 7aa282d..8b3462e 100644
> --- a/include/xen/acpi.h
> +++ b/include/xen/acpi.h
> @@ -107,6 +107,11 @@ static inline int xen_acpi_processor_get_performance(struct acpi_processor *pr)
>  }
>  #endif
>  
> +#if defined(CONFIG_ACPI_HOTPLUG_MEMORY) || \
> +defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
> +int xen_hotadd_memory(struct acpi_memory_device *mem_device);
> +#endif
> +
>  #if defined(CONFIG_ACPI_PROCESSOR_XEN) || \
>  defined(CONFIG_ACPI_PROCESSOR_XEN_MODULE)
>  
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index 9fd6b07..0787c68 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -329,6 +329,14 @@ struct xenpf_cpu_hotadd {
>  	uint32_t pxm;
>  };
>  
> +#define XENPF_mem_hotadd    59
> +struct xenpf_mem_hotadd {
> +	uint64_t spfn;
> +	uint64_t epfn;
> +	uint32_t pxm;
> +	uint32_t flags;
> +};
> +
>  struct xen_platform_op {
>  	uint32_t cmd;
>  	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
> @@ -347,6 +355,7 @@ struct xen_platform_op {
>  		struct xenpf_pcpuinfo          pcpu_info;
>  		struct xenpf_cpu_ol            cpu_ol;
>  		struct xenpf_cpu_hotadd        cpu_add;
> +		struct xenpf_mem_hotadd        mem_add;
>  		uint8_t                        pad[128];
>  	} u;
>  };
> -- 
> 1.6.5.6


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

