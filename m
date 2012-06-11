Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2FKU1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:27:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27583 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2FKU1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:27:30 -0400
Date: Mon, 11 Jun 2012 16:20:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Xen physical cpus online/offline sys
 interface
Message-ID: <20120611202008.GA14435@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923352259E4@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923352259E4@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 05:56:29AM +0000, Liu, Jinsong wrote:
> Konrad,
> 
> Our old patch of cpu online/offline is based on old kernel tree.
> I rebase it to your latest xen.git
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git   branch devel/mce.v3

applied.
> 
> Thanks,
> Jinsong
> 
> =====================
> >From 29152bb054d87334ef970ad037888b7bb032f8ef Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Mon, 11 Jun 2012 20:38:08 +0800
> Subject: [PATCH] Xen physical cpus online/offline sys interface
> 
> This patch provide Xen physical cpus online/offline sys interface.
> User can use it for their own purpose, like power saving:
> by offlining some cpus when light workload it save power greatly.
> 
> Its basic workflow is, user online/offline cpu via sys interface,
> then hypercall xen to implement, after done xen inject virq back to dom0,
> and then dom0 sync cpu status.
> 
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> ---
>  .../ABI/testing/sysfs-devices-system-xen_cpu       |   20 +
>  drivers/xen/Makefile                               |    1 +
>  drivers/xen/pcpu.c                                 |  371 ++++++++++++++++++++
>  include/xen/interface/platform.h                   |    8 +
>  include/xen/interface/xen.h                        |    1 +
>  5 files changed, 401 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-system-xen_cpu
>  create mode 100644 drivers/xen/pcpu.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-xen_cpu b/Documentation/ABI/testing/sysfs-devices-system-xen_cpu
> new file mode 100644
> index 0000000..9ca02fb
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-devices-system-xen_cpu
> @@ -0,0 +1,20 @@
> +What:		/sys/devices/system/xen_cpu/
> +Date:		May 2012
> +Contact:	Liu, Jinsong <jinsong.liu@intel.com>
> +Description:
> +		A collection of global/individual Xen physical cpu attributes
> +
> +		Individual physical cpu attributes are contained in
> +		subdirectories named by the Xen's logical cpu number, e.g.:
> +		/sys/devices/system/xen_cpu/xen_cpu#/
> +
> +
> +What:		/sys/devices/system/xen_cpu/xen_cpu#/online
> +Date:		May 2012
> +Contact:	Liu, Jinsong <jinsong.liu@intel.com>
> +Description:
> +		Interface to online/offline Xen physical cpus
> +
> +		When running under Xen platform, it provide user interface
> +		to online/offline physical cpus, except cpu0 due to several
> +		logic restrictions and assumptions.
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index a787029..d80bea5 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
>  obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
>  obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
> +obj-$(CONFIG_XEN_DOM0)			+= pcpu.o
>  obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
>  obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
> diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
> new file mode 100644
> index 0000000..067fcfa
> --- /dev/null
> +++ b/drivers/xen/pcpu.c
> @@ -0,0 +1,371 @@
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
> +#include <linux/capability.h>
> +
> +#include <xen/xen.h>
> +#include <xen/xenbus.h>
> +#include <xen/events.h>
> +#include <xen/interface/platform.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +
> +#define XEN_PCPU "xen_cpu: "
> +
> +/*
> + * @cpu_id: Xen physical cpu logic number
> + * @flags: Xen physical cpu status flag
> + * - XEN_PCPU_FLAGS_ONLINE: cpu is online
> + * - XEN_PCPU_FLAGS_INVALID: cpu is not present
> + */
> +struct pcpu {
> +	struct list_head list;
> +	struct device dev;
> +	uint32_t cpu_id;
> +	uint32_t flags;
> +};
> +
> +static struct bus_type xen_pcpu_subsys = {
> +	.name = "xen_cpu",
> +	.dev_name = "xen_cpu",
> +};
> +
> +static DEFINE_MUTEX(xen_pcpu_lock);
> +
> +static LIST_HEAD(xen_pcpus);
> +
> +static int xen_pcpu_down(uint32_t cpu_id)
> +{
> +	struct xen_platform_op op = {
> +		.cmd			= XENPF_cpu_offline,
> +		.interface_version	= XENPF_INTERFACE_VERSION,
> +		.u.cpu_ol.cpuid		= cpu_id,
> +	};
> +
> +	return HYPERVISOR_dom0_op(&op);
> +}
> +
> +static int xen_pcpu_up(uint32_t cpu_id)
> +{
> +	struct xen_platform_op op = {
> +		.cmd			= XENPF_cpu_online,
> +		.interface_version	= XENPF_INTERFACE_VERSION,
> +		.u.cpu_ol.cpuid		= cpu_id,
> +	};
> +
> +	return HYPERVISOR_dom0_op(&op);
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
> +	struct pcpu *pcpu = container_of(dev, struct pcpu, dev);
> +	unsigned long long val;
> +	ssize_t ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (kstrtoull(buf, 0, &val) < 0)
> +		return -EINVAL;
> +
> +	switch (val) {
> +	case 0:
> +		ret = xen_pcpu_down(pcpu->cpu_id);
> +		break;
> +	case 1:
> +		ret = xen_pcpu_up(pcpu->cpu_id);
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
> +static struct pcpu *get_pcpu(uint32_t cpu_id)
> +{
> +	struct pcpu *pcpu;
> +
> +	list_for_each_entry(pcpu, &xen_pcpus, list) {
> +		if (pcpu->cpu_id == cpu_id)
> +			return pcpu;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void pcpu_release(struct device *dev)
> +{
> +	struct pcpu *pcpu = container_of(dev, struct pcpu, dev);
> +
> +	list_del(&pcpu->list);
> +	kfree(pcpu);
> +}
> +
> +static void unregister_and_remove_pcpu(struct pcpu *pcpu)
> +{
> +	struct device *dev;
> +
> +	if (!pcpu)
> +		return;
> +
> +	dev = &pcpu->dev;
> +	if (dev->id)
> +		device_remove_file(dev, &dev_attr_online);
> +
> +	/* pcpu remove would be implicitly done */
> +	device_unregister(dev);
> +}
> +
> +static int register_pcpu(struct pcpu *pcpu)
> +{
> +	struct device *dev;
> +	int err = -EINVAL;
> +
> +	if (!pcpu)
> +		return err;
> +
> +	dev = &pcpu->dev;
> +	dev->bus = &xen_pcpu_subsys;
> +	dev->id = pcpu->cpu_id;
> +	dev->release = pcpu_release;
> +
> +	err = device_register(dev);
> +	if (err) {
> +		pcpu_release(dev);
> +		return err;
> +	}
> +
> +	/*
> +	 * Xen never offline cpu0 due to several restrictions
> +	 * and assumptions. This basically doesn't add a sys control
> +	 * to user, one cannot attempt to offline BSP.
> +	 */
> +	if (dev->id) {
> +		err = device_create_file(dev, &dev_attr_online);
> +		if (err) {
> +			device_unregister(dev);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct pcpu *create_and_register_pcpu(struct xenpf_pcpuinfo *info)
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
> +	INIT_LIST_HEAD(&pcpu->list);
> +	pcpu->cpu_id = info->xen_cpuid;
> +	pcpu->flags = info->flags;
> +
> +	/* Need hold on xen_pcpu_lock before pcpu list manipulations */
> +	list_add_tail(&pcpu->list, &xen_pcpus);
> +
> +	err = register_pcpu(pcpu);
> +	if (err) {
> +		pr_warning(XEN_PCPU "Failed to register pcpu%u\n",
> +			   info->xen_cpuid);
> +		return ERR_PTR(-ENOENT);
> +	}
> +
> +	return pcpu;
> +}
> +
> +/*
> + * Caller should hold the xen_pcpu_lock
> + */
> +static int sync_pcpu(uint32_t cpu, uint32_t *max_cpu)
> +{
> +	int ret;
> +	struct pcpu *pcpu = NULL;
> +	struct xenpf_pcpuinfo *info;
> +	struct xen_platform_op op = {
> +		.cmd                   = XENPF_get_cpuinfo,
> +		.interface_version     = XENPF_INTERFACE_VERSION,
> +		.u.pcpu_info.xen_cpuid = cpu,
> +	};
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return ret;
> +
> +	info = &op.u.pcpu_info;
> +	if (max_cpu)
> +		*max_cpu = info->max_present;
> +
> +	pcpu = get_pcpu(cpu);
> +
> +	/*
> +	 * Only those at cpu present map has its sys interface.
> +	 */
> +	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
> +		if (pcpu)
> +			unregister_and_remove_pcpu(pcpu);
> +		return 0;
> +	}
> +
> +	if (!pcpu) {
> +		pcpu = create_and_register_pcpu(info);
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
> +	uint32_t cpu = 0, max_cpu = 0;
> +	int err = 0;
> +	struct pcpu *pcpu, *tmp;
> +
> +	mutex_lock(&xen_pcpu_lock);
> +
> +	while (!err && (cpu <= max_cpu)) {
> +		err = sync_pcpu(cpu, &max_cpu);
> +		cpu++;
> +	}
> +
> +	if (err)
> +		list_for_each_entry_safe(pcpu, tmp, &xen_pcpus, list)
> +			unregister_and_remove_pcpu(pcpu);
> +
> +	mutex_unlock(&xen_pcpu_lock);
> +
> +	return err;
> +}
> +
> +static void xen_pcpu_work_fn(struct work_struct *work)
> +{
> +	xen_sync_pcpus();
> +}
> +static DECLARE_WORK(xen_pcpu_work, xen_pcpu_work_fn);
> +
> +static irqreturn_t xen_pcpu_interrupt(int irq, void *dev_id)
> +{
> +	schedule_work(&xen_pcpu_work);
> +	return IRQ_HANDLED;
> +}
> +
> +static int __init xen_pcpu_init(void)
> +{
> +	int irq, ret;
> +
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	irq = bind_virq_to_irqhandler(VIRQ_PCPU_STATE, 0,
> +				      xen_pcpu_interrupt, 0,
> +				      "xen-pcpu", NULL);
> +	if (irq < 0) {
> +		pr_warning(XEN_PCPU "Failed to bind pcpu virq\n");
> +		return irq;
> +	}
> +
> +	ret = subsys_system_register(&xen_pcpu_subsys, NULL);
> +	if (ret) {
> +		pr_warning(XEN_PCPU "Failed to register pcpu subsys\n");
> +		goto err1;
> +	}
> +
> +	ret = xen_sync_pcpus();
> +	if (ret) {
> +		pr_warning(XEN_PCPU "Failed to sync pcpu info\n");
> +		goto err2;
> +	}
> +
> +	return 0;
> +
> +err2:
> +	bus_unregister(&xen_pcpu_subsys);
> +err1:
> +	unbind_from_irqhandler(irq, NULL);
> +	return ret;
> +}
> +arch_initcall(xen_pcpu_init);
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index 486653f..61fa661 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
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


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

