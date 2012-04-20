Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2DTUzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:55:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25657 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2DTUzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:55:40 -0400
Date: Fri, 20 Apr 2012 15:24:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Xen physical cpus interface
Message-ID: <20120420192439.GA32170@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F91CD48.0026,ss=1,re=1.599,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 01:33:03PM +0000, Liu, Jinsong wrote:
> >From afdd30a7769e706e9be64f80d64136e2e267ecb9 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Fri, 20 Apr 2012 05:11:58 +0800
> Subject: [PATCH 3/3] Xen physical cpus interface
> 
> Manage physical cpus in dom0, get physical cpus info and provide sys interface.

Anything that exposes SysFS attributes needs documentation in 
Documentation/ABI

Can you explain what this solves? And if there are any
userland applications that use this?


> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> ---
>  drivers/xen/Makefile             |    1 +
>  drivers/xen/pcpu.c               |  393 ++++++++++++++++++++++++++++++++++++++
>  include/xen/interface/platform.h |   10 +-
>  include/xen/interface/xen.h      |    1 +
>  4 files changed, 404 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/xen/pcpu.c
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 1d3e763..d12d14d 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
>  obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
>  obj-$(CONFIG_XEN_DOM0)			+= pci.o
> +obj-$(CONFIG_XEN_DOM0)			+= pcpu.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
> diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
> new file mode 100644
> index 0000000..9295def
> --- /dev/null
> +++ b/drivers/xen/pcpu.c
> @@ -0,0 +1,393 @@
> +/******************************************************************************
> + * pcpu.c
> + * Management physical cpu in dom0, get pcpu info and provide sys interface
> + *
> + * Copyright (c) 2012 Intel Corporation
> + * Author: Liu, Jinsong <jinsong.liu@intel.com>
> + * Author: Jiang, Yunhong <yunhong.jiang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation; or, when distributed
> + * separately from the Linux kernel or incorporated into other
> + * software packages, subject to the following license:
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this source file (the "Software"), to deal in the Software without
> + * restriction, including without limitation the rights to use, copy, modify,
> + * merge, publish, distribute, sublicense, and/or sell copies of the Software,
> + * and to permit persons to whom the Software is furnished to do so, subject to
> + * the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
> + * IN THE SOFTWARE.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/cpu.h>
> +#include <linux/stat.h>
> +#include <xen/xen.h>
> +#include <xen/xenbus.h>
> +#include <xen/events.h>
> +#include <xen/interface/platform.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +
> +struct pcpu {
> +	struct list_head pcpu_list;
> +	struct device dev;
> +	uint32_t xen_id;

What is a 'xen_id'? Can you put a provide a comment
explaining the relationship between that and apic_id acpi_id
and flags?

Or better yet, just at the start of the structure have:

/*
 * @xen_id The ...
 * @apic_id ... so on.


> +	uint32_t apic_id;
> +	uint32_t acpi_id;
> +	uint32_t flags;
> +};
> +
> +static struct bus_type xen_pcpu_subsys = {

> +	.name = "xen_cpu",
> +	.dev_name = "xen_cpu",
> +};
> +
> +static DEFINE_MUTEX(xen_pcpu_lock);
> +#define get_pcpu_lock() mutex_lock(&xen_pcpu_lock);

Just use the mutex - no point of using the #define


> +#define put_pcpu_lock() mutex_unlock(&xen_pcpu_lock);
> +
> +#define XEN_PCPU "xen_cpu: "
> +
> +struct xen_pcpus {
> +	struct list_head list;

Uh, so it is just a list? 
> +};
> +static struct xen_pcpus xen_pcpus;

Can't you just do

static struct pcpu * xen_pcpus;

And then use that to add/remove items?

> +
> +static int xen_pcpu_down(uint32_t xen_id)
> +{
> +	int ret;
> +	struct xen_platform_op op = {
> +		.cmd			= XENPF_cpu_offline,
> +		.interface_version	= XENPF_INTERFACE_VERSION,
> +		.u.cpu_ol.cpuid		= xen_id,
> +	};
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	return ret;

Just collapse it in:
	return HYPERVISOR_dom0_op..

> +}
> +
> +static int xen_pcpu_up(uint32_t xen_id)
> +{
> +	int ret;
> +	struct xen_platform_op op = {
> +		.cmd			= XENPF_cpu_online,
> +		.interface_version	= XENPF_INTERFACE_VERSION,
> +		.u.cpu_ol.cpuid		= xen_id,
> +	};
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	return ret;

Ditto.

> +}
> +
> +static ssize_t show_online(struct device *dev,
> +			   struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, dev);
> +
> +	return sprintf(buf, "%u\n", !!(cpu->flags & XEN_PCPU_FLAGS_ONLINE));
> +}
> +
> +static ssize_t __ref store_online(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, dev);
> +	ssize_t ret;
> +

Add:
	if (!capable(CAP_SYS_ADMIN))
		return -EPERM;


> +	switch (buf[0]) {

Use strict_strtoull pls.

> +	case '0':
> +		ret = xen_pcpu_down(cpu->xen_id);
> +		break;
> +	case '1':
> +		ret = xen_pcpu_up(cpu->xen_id);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret >= 0)
> +		ret = count;
> +	return ret;
> +}
> +static DEVICE_ATTR(online, S_IRUGO | S_IWUSR, show_online, store_online);

> +
> +static ssize_t show_apicid(struct device *dev,
> +			   struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, dev);
> +
> +	return sprintf(buf, "%u\n", cpu->apic_id);
> +}
> +
> +static ssize_t show_acpiid(struct device *dev,
> +			   struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, dev);
> +
> +	return sprintf(buf, "%u\n", cpu->acpi_id);
> +}
> +static DEVICE_ATTR(apic_id, S_IRUGO, show_apicid, NULL);
> +static DEVICE_ATTR(acpi_id, S_IRUGO, show_acpiid, NULL);

What benefit is there in exposing these values to the user?

> +
> +static bool xen_pcpu_online(uint32_t flags)
> +{
> +	return !!(flags & XEN_PCPU_FLAGS_ONLINE);
> +}
> +
> +static void pcpu_online_status(struct xenpf_pcpuinfo *info,
> +			       struct pcpu *pcpu)
> +{
> +	if (xen_pcpu_online(info->flags) &&
> +	   !xen_pcpu_online(pcpu->flags)) {
> +		/* the pcpu is onlined */
> +		pcpu->flags |= XEN_PCPU_FLAGS_ONLINE;
> +		kobject_uevent(&pcpu->dev.kobj, KOBJ_ONLINE);
> +	} else if (!xen_pcpu_online(info->flags) &&
> +		    xen_pcpu_online(pcpu->flags)) {
> +		/* The pcpu is offlined */
> +		pcpu->flags &= ~XEN_PCPU_FLAGS_ONLINE;
> +		kobject_uevent(&pcpu->dev.kobj, KOBJ_OFFLINE);
> +	}
> +}
> +
> +static struct pcpu *get_pcpu(uint32_t xen_id)
> +{
> +	struct pcpu *pcpu = NULL;
> +
> +	list_for_each_entry(pcpu, &xen_pcpus.list, pcpu_list) {
> +		if (pcpu->xen_id == xen_id)
> +			return pcpu;
> +	}
> +	return NULL;
> +}
> +
> +static void pcpu_sys_remove(struct pcpu *pcpu)
> +{
> +	struct device *dev;
> +
> +	if (!pcpu)
> +		return;
> +
> +	dev = &pcpu->dev;
> +	if (dev->id)
> +		device_remove_file(dev, &dev_attr_online);
> +	device_remove_file(dev, &dev_attr_acpi_id);
> +	device_remove_file(dev, &dev_attr_apic_id);
> +	device_unregister(dev);

So .. if you are using that, can't you use the .release
and define something like:

static void pcpu_release(struct device *dev)
{
	struct pcpu *pcpu = container_of(dev, struct pcpu, dev);

	list_del(&pcpu->pcpu_list);
	kfree(pcpu);
}
> +}
> +
> +static void free_pcpu(struct pcpu *pcpu)
> +{
> +	if (!pcpu)
> +		return;
> +
> +	pcpu_sys_remove(pcpu);

> +	list_del(&pcpu->pcpu_list);
> +	kfree(pcpu);

Those two shouldn't be there. They sould be part of the
release function.
> +}
> +
> +static int pcpu_sys_create(struct pcpu *pcpu)
> +{
> +	struct device *dev;
> +	int err = -EINVAL;
> +
> +	if (!pcpu)
> +		return err;
> +
> +	dev = &pcpu->dev;
> +	dev->bus = &xen_pcpu_subsys;
> +	dev->id = pcpu->xen_id;

And then here dev->release = &pcpu_release;

> +
> +	err = device_register(dev);
> +	if (err)
> +		goto err1;
> +
> +	err = device_create_file(dev, &dev_attr_apic_id);
> +	if (err)
> +		goto err2;
> +	err = device_create_file(dev, &dev_attr_acpi_id);
> +	if (err)
> +		goto err3;

Usually this is done with an array, like the drivers/xen/xen-balloon.c
..
But I am still not sure why these two parameters are needed?

> +	/* Not open pcpu0 online access to user */

Huh? You mean "Nobody can touch PCPU0" ?

Why? Why can they touch the other ones? And better yet,
what happens if one boots without "dom0_max_vcpus=X"
and powers of some of the CPUs?

> +	if (dev->id) {
> +		err = device_create_file(dev, &dev_attr_online);
> +		if (err)
> +			goto err4;
> +	}
> +
> +	return 0;
> +
> +err4:
> +	device_remove_file(dev, &dev_attr_acpi_id);
> +err3:
> +	device_remove_file(dev, &dev_attr_apic_id);
> +err2:
> +	device_unregister(dev);
> +err1:
> +	return err;
> +}
> +
> +static struct pcpu *init_pcpu(struct xenpf_pcpuinfo *info)
> +{
> +	struct pcpu *pcpu;
> +	int err;
> +
> +	if (info->flags & XEN_PCPU_FLAGS_INVALID)
> +		return ERR_PTR(-ENODEV);
> +
> +	pcpu = kzalloc(sizeof(struct pcpu), GFP_KERNEL);
> +	if (!pcpu)
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_LIST_HEAD(&pcpu->pcpu_list);
> +	pcpu->xen_id = info->xen_cpuid;
> +	pcpu->apic_id = info->apic_id;
> +	pcpu->acpi_id = info->acpi_id;
> +	pcpu->flags = info->flags;
> +
> +	err = pcpu_sys_create(pcpu);
> +	if (err) {
> +		pr_warning(XEN_PCPU "Failed to register pcpu%d\n",

Not %u?
> +			   info->xen_cpuid);
> +		kfree(pcpu);
> +		return ERR_PTR(-ENOENT);
> +	}
> +

Should this be protected by the mutex? [edit: I see now
that the calleer is suppose to hold on the lock.
Mention that please right before you do any list manipulations]


> +	list_add_tail(&pcpu->pcpu_list, &xen_pcpus.list);
> +	return pcpu;
> +}
> +
> +/*
> + * Caller should hold the pcpu lock

Provide full name of the mutex lock.
> + */
> +static int _sync_pcpu(uint32_t cpu_num, uint32_t *ptr_max_cpu_num)

Why the '_' in front of the name?

For parameters do:

uint32 cpu, uint32 *max_cpu

> +{
> +	int ret;
> +	struct pcpu *pcpu = NULL;
> +	struct xenpf_pcpuinfo *info;
> +	struct xen_platform_op op = {
> +		.cmd                   = XENPF_get_cpuinfo,
> +		.interface_version     = XENPF_INTERFACE_VERSION,
> +		.u.pcpu_info.xen_cpuid = cpu_num,
> +	};
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return ret;
> +
> +	info = &op.u.pcpu_info;
> +	if (ptr_max_cpu_num)
> +		*ptr_max_cpu_num = info->max_present;
> +
> +	pcpu = get_pcpu(cpu_num);
> +
> +	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
> +		/* The pcpu has been removed */
> +		if (pcpu)
> +			free_pcpu(pcpu);
> +		return 0;
> +	}
> +
> +	if (!pcpu) {
> +		pcpu = init_pcpu(info);
> +		if (IS_ERR_OR_NULL(pcpu))
> +			return -ENODEV;
> +	} else
> +		pcpu_online_status(info, pcpu);
> +
> +	return 0;
> +}
> +
> +/*
> + * Sync dom0's pcpu information with xen hypervisor's
> + */
> +static int xen_sync_pcpus(void)
> +{
> +	/*
> +	 * Boot cpu always have cpu_id 0 in xen
> +	 */
> +	uint32_t cpu_num = 0, max_cpu_num = 0;

Use 'cpu' and 'max_cpu'

> +	int err = 0;
> +	struct list_head *elem, *tmp;
> +	struct pcpu *pcpu;
> +
> +	get_pcpu_lock();
> +
> +	while (!err && (cpu_num <= max_cpu_num)) {
> +		err = _sync_pcpu(cpu_num, &max_cpu_num);
> +		cpu_num++;
> +	}
> +
> +	if (err) {
> +		list_for_each_safe(elem, tmp, &xen_pcpus.list) {

s/elem/pcpu/

> +			pcpu = list_entry(elem, struct pcpu, pcpu_list);

That you can remove once you make the xen_pcpus structure as I mentioned
above.

> +			free_pcpu(pcpu);
> +		}
> +	}
> +
> +	put_pcpu_lock();

Ah, so you are locking around here.
> +
> +	return err;
> +}
> +
> +static void xen_pcpu_dpc(struct work_struct *work)

s/dpc/workqueue/

> +{
> +	xen_sync_pcpus();
> +}
> +static DECLARE_WORK(xen_pcpu_work, xen_pcpu_dpc);
> +
> +static irqreturn_t xen_pcpu_interrupt(int irq, void *dev_id)
> +{
> +	schedule_work(&xen_pcpu_work);
> +	return IRQ_HANDLED;
> +}
> +
> +static int __init xen_pcpu_init(void)
> +{
> +	int ret;
> +
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	ret = subsys_system_register(&xen_pcpu_subsys, NULL);
> +	if (ret) {
> +		pr_warning(XEN_PCPU "Failed to register pcpu subsys\n");
> +		return ret;
> +	}
> +
> +	INIT_LIST_HEAD(&xen_pcpus.list);
> +
> +	ret = xen_sync_pcpus();
> +	if (ret) {
> +		pr_warning(XEN_PCPU "Failed to sync pcpu info\n");
> +		return ret;
> +	}
> +
> +	ret = bind_virq_to_irqhandler(VIRQ_PCPU_STATE, 0,
> +				      xen_pcpu_interrupt, 0,
> +				      "pcpu", NULL);

"xen-pcpu"

> +	if (ret < 0) {
> +		pr_warning(XEN_PCPU "Failed to bind pcpu virq\n");

Shouldn't you delete what 'xen_sync_pcpus' did?
Or is it OK to still work without the interrupts? What is the purpose
of that interrupt? How does it actually work - the hypervisor
decides when/where to turn off CPUs?

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +arch_initcall(xen_pcpu_init);
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index 486653f..2c56d4f 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -298,7 +298,7 @@ struct xenpf_set_processor_pminfo {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_set_processor_pminfo);
>  
> -#define XENPF_get_cpuinfo 55
> +#define XENPF_get_cpuinfo	55

Why?

>  struct xenpf_pcpuinfo {
>  	/* IN */
>  	uint32_t xen_cpuid;
> @@ -314,6 +314,13 @@ struct xenpf_pcpuinfo {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_pcpuinfo);
>  
> +#define XENPF_cpu_online	56
> +#define XENPF_cpu_offline	57
> +struct xenpf_cpu_ol {
> +	uint32_t cpuid;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
> +
>  struct xen_platform_op {
>  	uint32_t cmd;
>  	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
> @@ -330,6 +337,7 @@ struct xen_platform_op {
>  		struct xenpf_getidletime       getidletime;
>  		struct xenpf_set_processor_pminfo set_pminfo;
>  		struct xenpf_pcpuinfo          pcpu_info;
> +		struct xenpf_cpu_ol            cpu_ol;
>  		uint8_t                        pad[128];
>  	} u;
>  };
> diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> index a890804..0801468 100644
> --- a/include/xen/interface/xen.h
> +++ b/include/xen/interface/xen.h
> @@ -80,6 +80,7 @@
>  #define VIRQ_CONSOLE    2  /* (DOM0) Bytes received on emergency console. */
>  #define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   */
>  #define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   */
> +#define VIRQ_PCPU_STATE 9  /* (DOM0) PCPU state changed                   */
>  
>  /* Architecture-specific VIRQ definitions. */
>  #define VIRQ_ARCH_0    16
> -- 
> 1.7.1


