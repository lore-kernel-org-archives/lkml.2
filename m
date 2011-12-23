Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1LWNHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:07:48 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60564 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1LWNHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:07:46 -0500
Date: Fri, 23 Dec 2011 09:07:35 -0400
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
Subject: Re: [Xen-devel] [PATCH 03/10] Xen: Export host physical CPU information to dom0
Message-ID: <20111223130735.GC25286@andromeda.dapyr.net>
References: <DE8DF0795D48FD4CA783C40EC829233596CC@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233596CC@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:25:23AM +0000, Liu, Jinsong wrote:
> >From 04151aa18b48a452cc9d0696f36aa96c690ca011 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Thu, 8 Dec 2011 22:28:07 +0800
> Subject: [PATCH 03/10] Xen: Export host physical CPU information to dom0
> 
> This patch rebased from Jeremy's pvops commit
> 3b34cd19627c6e191b15fd6cb59f997b8db21e19 and
> 68320323a51c2378aca433c76157d9e66104ff1e
> 
> This patch expose host's physical CPU information to dom0 in sysfs, so
> that dom0's management tools can control the physical CPU if needed.

Please include an explanation of:
 what  is the benfit of this?
 why would anyone want to do this?

> 
> It also provides interface in sysfs to logical online/offline a physical CPU.

Then you also need Documentation/ABI/

Is there any generic API for doing this? Can that be used instead?
> 
> Notice: The information in dom0 is synced with xen hypervisor asynchronously.
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/xen/Makefile             |    2 +-
>  drivers/xen/pcpu.c               |  452 ++++++++++++++++++++++++++++++++++++++
>  include/xen/interface/platform.h |   28 +++
>  include/xen/interface/xen.h      |    1 +
>  include/xen/pcpu.h               |   32 +++
>  5 files changed, 514 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/xen/pcpu.c
>  create mode 100644 include/xen/pcpu.h
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 405cce9..aedaf48 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,4 +1,4 @@
> -obj-y	+= grant-table.o features.o events.o manage.o balloon.o
> +obj-y	+= grant-table.o features.o events.o manage.o balloon.o pcpu.o

You mentioned this is a dom0 type thing. So can this be wrapped with
CONFIG_XEN_DOM0? There is no point of running this in the guest right?

>  obj-y	+= xenbus/
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
> diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
> new file mode 100644
> index 0000000..6d1a770
> --- /dev/null
> +++ b/drivers/xen/pcpu.c
> @@ -0,0 +1,452 @@
> +/*
> + * pcpu.c - management physical cpu in dom0 environment
> + */
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +#include <linux/cpu.h>
> +#include <xen/xenbus.h>
> +#include <xen/pcpu.h>
> +#include <xen/events.h>
> +#include <xen/acpi.h>

You are missing
xen/xen.h

> +
> +static struct sysdev_class xen_pcpu_sysdev_class = {
> +	.name = "xen_pcpu",
> +};
> +
> +static DEFINE_MUTEX(xen_pcpu_lock);
> +static RAW_NOTIFIER_HEAD(xen_pcpu_chain);
> +
> +/* No need for irq disable since hotplug notify is in workqueue context */
> +#define get_pcpu_lock() mutex_lock(&xen_pcpu_lock);
> +#define put_pcpu_lock() mutex_unlock(&xen_pcpu_lock);
> +
> +struct xen_pcpus {
> +	struct list_head list;
> +	int present;

bool.
> +};
> +static struct xen_pcpus xen_pcpus;
> +
> +int register_xen_pcpu_notifier(struct notifier_block *nb)
> +{
> +	int ret;
> +
> +	/* All refer to the chain notifier is protected by the pcpu_lock */

Huh?
> +	get_pcpu_lock();
> +	ret = raw_notifier_chain_register(&xen_pcpu_chain, nb);
> +	put_pcpu_lock();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(register_xen_pcpu_notifier);
> +
> +void unregister_xen_pcpu_notifier(struct notifier_block *nb)
> +{
> +	get_pcpu_lock();
> +	raw_notifier_chain_unregister(&xen_pcpu_chain, nb);
> +	put_pcpu_lock();
> +}
> +EXPORT_SYMBOL_GPL(unregister_xen_pcpu_notifier);
> +
> +static int xen_pcpu_down(uint32_t xen_id)
> +{
> +	int ret;
> +	xen_platform_op_t op = {
> +		.cmd			= XENPF_cpu_offline,
> +		.interface_version	= XENPF_INTERFACE_VERSION,
> +		.u.cpu_ol.cpuid	= xen_id,
> +	};
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	return ret;
> +}
> +
> +static int xen_pcpu_up(uint32_t xen_id)
> +{
> +	int ret;
> +	xen_platform_op_t op = {
> +		.cmd			= XENPF_cpu_online,
> +		.interface_version	= XENPF_INTERFACE_VERSION,
> +		.u.cpu_ol.cpuid	= xen_id,
> +	};
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	return ret;
> +}
> +
> +static ssize_t show_online(struct sys_device *dev,
> +			struct sysdev_attribute *attr,
> +			char *buf)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, sysdev);

Shouldn't you have a check like this:
 if (!capable(CAP_SYS_ADMIN))
	return -EACCESS;
> +
> +	return sprintf(buf, "%u\n", !!(cpu->flags & XEN_PCPU_FLAGS_ONLINE));
> +}
> +
> +static ssize_t __ref store_online(struct sys_device *dev,
> +				  struct sysdev_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, sysdev);
> +	ssize_t ret;
> +
Um, shouldn't you have a check

 if (!capable(CAP_SYS_ADMIN))
	return -EACCESS;
?
> +	switch (buf[0]) {
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
> +
> +static SYSDEV_ATTR(online, 0644, show_online, store_online);
> +
> +static ssize_t show_apicid(struct sys_device *dev,
> +			struct sysdev_attribute *attr,
> +			char *buf)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, sysdev);
> +

The same priv check.
> +	return sprintf(buf, "%u\n", cpu->apic_id);
> +}
> +
> +static ssize_t show_acpiid(struct sys_device *dev,
> +			struct sysdev_attribute *attr,
> +			char *buf)
> +{
> +	struct pcpu *cpu = container_of(dev, struct pcpu, sysdev);
> +

And here.. But I am wondering. What is the purpose of the ACPI_ID
fields? Why do you want to expose them?

> +	return sprintf(buf, "%u\n", cpu->acpi_id);
> +}
> +static SYSDEV_ATTR(apic_id, 0444, show_apicid, NULL);
> +static SYSDEV_ATTR(acpi_id, 0444, show_acpiid, NULL);
> +
> +static int xen_pcpu_free(struct pcpu *pcpu)
> +{
> +	if (!pcpu)
> +		return 0;
> +
> +	sysdev_remove_file(&pcpu->sysdev, &attr_online);
> +	sysdev_unregister(&pcpu->sysdev);
> +	list_del(&pcpu->pcpu_list);
> +	kfree(pcpu);
> +
> +	return 0;
> +}
> +
> +static inline int same_pcpu(struct xenpf_pcpuinfo *info,
> +			    struct pcpu *pcpu)
> +{
> +	return (pcpu->apic_id == info->apic_id) &&
> +		(pcpu->xen_id == info->xen_cpuid);
> +}
> +
> +/*
> + * Return 1 if online status changed
> + */
> +static int xen_pcpu_online_check(struct xenpf_pcpuinfo *info,

Make it a bool please.
> +				 struct pcpu *pcpu)
> +{
> +	int result = 0;
> +
> +	if (info->xen_cpuid != pcpu->xen_id)
> +		return 0;
> +
> +	if (xen_pcpu_online(info->flags) && !xen_pcpu_online(pcpu->flags)) {
> +		/* the pcpu is onlined */
> +		pcpu->flags |= XEN_PCPU_FLAGS_ONLINE;
> +		kobject_uevent(&pcpu->sysdev.kobj, KOBJ_ONLINE);
> +		raw_notifier_call_chain(&xen_pcpu_chain,
> +			XEN_PCPU_ONLINE, (void *)(long)pcpu->xen_id);
> +		result = 1;
> +	} else if (!xen_pcpu_online(info->flags) &&
> +		 xen_pcpu_online(pcpu->flags))  {
> +		/* The pcpu is offlined now */
> +		pcpu->flags &= ~XEN_PCPU_FLAGS_ONLINE;
> +		kobject_uevent(&pcpu->sysdev.kobj, KOBJ_OFFLINE);
> +		raw_notifier_call_chain(&xen_pcpu_chain,
> +			XEN_PCPU_OFFLINE, (void *)(long)pcpu->xen_id);
> +		result = 1;
> +	}
> +
> +	return result;
> +}
> +
> +static int pcpu_sysdev_init(struct pcpu *cpu)
> +{
> +	int error;
> +
> +	error = sysdev_register(&cpu->sysdev);
> +	if (error) {
> +		printk(KERN_WARNING "xen_pcpu_add: Failed to register pcpu\n");
> +		kfree(cpu);
> +		return -1;

Why not return error?
> +	}
> +	sysdev_create_file(&cpu->sysdev, &attr_online);
> +	sysdev_create_file(&cpu->sysdev, &attr_apic_id);
> +	sysdev_create_file(&cpu->sysdev, &attr_acpi_id);
> +	return 0;
> +}
> +
> +static struct pcpu *get_pcpu(int xen_id)
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
> +static struct pcpu *init_pcpu(struct xenpf_pcpuinfo *info)
> +{
> +	struct pcpu *pcpu;
> +
> +	if (info->flags & XEN_PCPU_FLAGS_INVALID)
> +		return NULL;
> +
> +	/* The PCPU is just added */

Huh? Can you explain this a bit please?

> +	pcpu = kzalloc(sizeof(struct pcpu), GFP_KERNEL);
> +	if (!pcpu)
> +		return NULL;

Why not use ERR_PTR?
> +
> +	INIT_LIST_HEAD(&pcpu->pcpu_list);
> +	pcpu->xen_id = info->xen_cpuid;
> +	pcpu->apic_id = info->apic_id;
> +	pcpu->acpi_id = info->acpi_id;
> +	pcpu->flags = info->flags;
> +
> +	pcpu->sysdev.cls = &xen_pcpu_sysdev_class;
> +	pcpu->sysdev.id = info->xen_cpuid;
> +
> +	if (pcpu_sysdev_init(pcpu)) {
> +		kfree(pcpu);
> +		return NULL;

Why not use ERR_PTR?
> +	}
> +
> +	list_add_tail(&pcpu->pcpu_list, &xen_pcpus.list);
> +	raw_notifier_call_chain(&xen_pcpu_chain,
> +				XEN_PCPU_ADD,
> +				(void *)(long)pcpu->xen_id);
> +	return pcpu;
> +}
> +
> +#define PCPU_NO_CHANGE			0
> +#define PCPU_ADDED			1
> +#define PCPU_ONLINE_OFFLINE		2
> +#define PCPU_REMOVED			3

The space alignemtn looks odd.
> +/*
> + * Caller should hold the pcpu lock
> + * < 0: Something wrong
> + * 0: No changes
> + * > 0: State changed
> + */
> +static struct pcpu *_sync_pcpu(int cpu_num, int *max_id, int *result)
> +{
> +	struct pcpu *pcpu = NULL;
> +	struct xenpf_pcpuinfo *info;
> +	xen_platform_op_t op = {
> +		.cmd            = XENPF_get_cpuinfo,
> +		.interface_version  = XENPF_INTERFACE_VERSION,
> +	};
> +	int ret;
> +

Please check whether result it usable:
	if (result) ...
> +	*result = -1;
> +
> +	info = &op.u.pcpu_info;
> +	info->xen_cpuid = cpu_num;
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return NULL;
> +
> +	if (max_id)
> +		*max_id = op.u.pcpu_info.max_present;
> +
> +	pcpu = get_pcpu(cpu_num);
> +
> +	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
> +		/* The pcpu has been removed */
> +		*result = PCPU_NO_CHANGE;
> +		if (pcpu) {
> +			raw_notifier_call_chain(&xen_pcpu_chain,
> +			  XEN_PCPU_REMOVE,
> +			  (void *)(long)pcpu->xen_id);
> +			xen_pcpu_free(pcpu);
> +			*result = PCPU_REMOVED;
> +		}
> +		return NULL;
> +	}
> +
> +
> +	if (!pcpu) {
> +		*result = PCPU_ADDED;
> +		pcpu = init_pcpu(info);
> +		if (pcpu == NULL) {
> +			printk(KERN_WARNING "Failed to init pcpu %x\n",
> +			  info->xen_cpuid);
> +			  *result = -1;

Please use a #define for -1.

> +		}
> +	} else {
> +		*result = PCPU_NO_CHANGE;
> +		/*
> +		 * Old PCPU is replaced with a new pcpu, this means
> +		 * several virq is missed, will it happen?

s/is/are

"will it happen?" ?? What does that mean? Are in, does it ever happen?
Well sure, if somebody overwrote the event channel mask or such.

> +		 */
> +		if (!same_pcpu(info, pcpu)) {
> +			printk(KERN_WARNING "Pcpu %x changed!\n",
> +			  pcpu->xen_id);
> +			pcpu->apic_id = info->apic_id;
> +			pcpu->acpi_id = info->acpi_id;
> +		}
> +		if (xen_pcpu_online_check(info, pcpu))
> +			*result = PCPU_ONLINE_OFFLINE;
> +	}
> +	return pcpu;
> +}
> +
> +int xen_pcpu_index(uint32_t id, int is_acpiid)
> +{
> +	int cpu_num = 0, max_id = 0, ret;
> +	xen_platform_op_t op = {
> +		.cmd            = XENPF_get_cpuinfo,
> +		.interface_version  = XENPF_INTERFACE_VERSION,
> +	};
> +	struct xenpf_pcpuinfo *info = &op.u.pcpu_info;
> +
> +	info->xen_cpuid = 0;
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return -1;

Can you put a comment explainig why are returning -1?

> +	max_id = op.u.pcpu_info.max_present;
> +

So max_id is not ACPI ID? Right, so why don't you use a different
variable name. Like 'max_cpu_nr'

> +	while ((cpu_num <= max_id)) {
> +		info->xen_cpuid = cpu_num;
> +		ret = HYPERVISOR_dom0_op(&op);
> +		if (ret)
> +			continue;
> +
> +		if (op.u.pcpu_info.max_present > max_id)
> +			max_id = op.u.pcpu_info.max_present;
> +		if (id == (is_acpiid ? info->acpi_id : info->apic_id))
> +			return cpu_num;

Huh? Are you mingling ACPI_ID with logical CPU count number? That is not
correct as the ACPI_ID can be higher than the logical CPUs number.

> +		cpu_num++;
> +	}
> +
> +    return -1;

Why -1?
> +}
> +EXPORT_SYMBOL(xen_pcpu_index);

_GPL
> +
> +/*
> + * Sync dom0's pcpu information with xen hypervisor's
> + */
> +static int xen_sync_pcpus(void)
> +{
> +	/*
> +	 * Boot cpu always have cpu_id 0 in xen
> +	 */
> +	int cpu_num = 0, max_id = 0, result = 0, present = 0;
> +	struct list_head *elem, *tmp;
> +	struct pcpu *pcpu;
> +
> +	get_pcpu_lock();
> +
> +	while ((result >= 0) && (cpu_num <= max_id)) {
> +		pcpu = _sync_pcpu(cpu_num, &max_id, &result);
> +
> +		printk(KERN_DEBUG "sync cpu %x get result %x max_id %x\n",
> +			cpu_num, result, max_id);
> +
> +		switch (result)	{
> +		case PCPU_NO_CHANGE:
> +			if (pcpu)
> +				present++;
> +			break;
> +		case PCPU_ADDED:
> +		case PCPU_ONLINE_OFFLINE:
> +			present++;
> +		case PCPU_REMOVED:
> +			break;
> +		default:
> +			printk(KERN_WARNING "Failed to sync pcpu %x\n",
> +			  cpu_num);
> +			break;
> +
> +		}
> +		cpu_num++;
> +	}
> +
> +	if (result < 0) {
> +		list_for_each_safe(elem, tmp, &xen_pcpus.list) {
> +			pcpu = list_entry(elem, struct pcpu, pcpu_list);
> +			xen_pcpu_free(pcpu);
> +		}
> +		present = 0;
> +	}
> +
> +	xen_pcpus.present = present;
> +
> +	put_pcpu_lock();
> +
> +	return 0;
> +}
> +
> +static void xen_pcpu_dpc(struct work_struct *work)
> +{
> +	if (xen_sync_pcpus() < 0)
> +		printk(KERN_WARNING
> +			"xen_pcpu_dpc: Failed to sync pcpu information\n");
> +}
> +static DECLARE_WORK(xen_pcpu_work, xen_pcpu_dpc);
> +
> +int xen_pcpu_hotplug(int type, uint32_t apic_id)
> +{
> +	schedule_work(&xen_pcpu_work);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(xen_pcpu_hotplug);

_GPL

> +
> +static irqreturn_t xen_pcpu_interrupt(int irq, void *dev_id)
> +{
> +	schedule_work(&xen_pcpu_work);
> +	return IRQ_HANDLED;
> +}
> +
> +static int __init xen_pcpu_init(void)
> +{
> +	int err;
> +
> +	if (!xen_initial_domain())
> +		return 0;

-ENODEV

> +
> +	err = sysdev_class_register(&xen_pcpu_sysdev_class);
> +	if (err) {
> +		printk(KERN_WARNING
> +			"xen_pcpu_init: register xen_pcpu sysdev Failed!\n");
> +		return err;
> +	}
> +
> +	INIT_LIST_HEAD(&xen_pcpus.list);
> +	xen_pcpus.present = 0;
> +
> +	xen_sync_pcpus();
> +	if (xen_pcpus.present > 0)
> +		err = bind_virq_to_irqhandler(VIRQ_PCPU_STATE,
> +			0, xen_pcpu_interrupt, 0, "pcpu", NULL);
> +	if (err < 0)
> +		printk(KERN_WARNING "xen_pcpu_init: "
> +			"Failed to bind pcpu_state virq\n"
> +			"You will lost latest information! \n");
> +	return err;
> +}
> +
> +arch_initcall(xen_pcpu_init);
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index c168468..47ffe16 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -297,6 +297,31 @@ struct xenpf_set_processor_pminfo {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_set_processor_pminfo);
>  
> +#define XENPF_get_cpuinfo 55
> +struct xenpf_pcpuinfo {
> +	/* IN */
> +	uint32_t xen_cpuid;
> +	/* OUT */
> +	/* The maxium cpu_id that is present */
> +	uint32_t max_present;
> +#define XEN_PCPU_FLAGS_ONLINE   1
> +	/* Correponding xen_cpuid is not present*/
> +#define XEN_PCPU_FLAGS_INVALID  2
> +	uint32_t flags;
> +	uint32_t apic_id;
> +	uint32_t acpi_id;
> +};
> +typedef struct xenpf_pcpuinfo xenpf_pcpuinfo_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_pcpuinfo_t);
> +
> +#define XENPF_cpu_online    56
> +#define XENPF_cpu_offline   57
> +struct xenpf_cpu_ol {
> +    uint32_t cpuid;
> +};
> +typedef struct xenpf_cpu_ol xenpf_cpu_ol_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol_t);
> +
>  struct xen_platform_op {
>  	uint32_t cmd;
>  	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
> @@ -312,9 +337,12 @@ struct xen_platform_op {
>  		struct xenpf_change_freq       change_freq;
>  		struct xenpf_getidletime       getidletime;
>  		struct xenpf_set_processor_pminfo set_pminfo;
> +		struct xenpf_pcpuinfo          pcpu_info;
> +		struct xenpf_cpu_ol            cpu_ol;
>  		uint8_t                        pad[128];
>  	} u;
>  };
> +typedef struct xen_platform_op xen_platform_op_t;
>  DEFINE_GUEST_HANDLE_STRUCT(xen_platform_op_t);
>  
>  #endif /* __XEN_PUBLIC_PLATFORM_H__ */
> diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> index 6a6e914..5a91c66 100644
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
> diff --git a/include/xen/pcpu.h b/include/xen/pcpu.h
> new file mode 100644
> index 0000000..7e8f9d1
> --- /dev/null
> +++ b/include/xen/pcpu.h
> @@ -0,0 +1,32 @@
> +#ifndef _XEN_PCPU_H
> +#define _XEN_PCPU_H
> +
> +#include <xen/interface/platform.h>
> +#include <linux/sysdev.h>
> +
> +extern int xen_pcpu_hotplug(int type, uint32_t apic_id);

is this neccessary?
> +#define XEN_PCPU_ONLINE     0x01
> +#define XEN_PCPU_OFFLINE    0x02
> +#define XEN_PCPU_ADD        0x04
> +#define XEN_PCPU_REMOVE     0x08
> +
> +struct pcpu {
> +	struct list_head pcpu_list;
> +	struct sys_device sysdev;
> +	uint32_t xen_id;
> +	uint32_t apic_id;
> +	uint32_t acpi_id;
> +	uint32_t flags;
> +};
> +
> +static inline int xen_pcpu_online(uint32_t flags)
> +{
> +	return !!(flags & XEN_PCPU_FLAGS_ONLINE);
> +}
> +
> +extern int register_xen_pcpu_notifier(struct notifier_block *nb);
> +
> +extern void unregister_xen_pcpu_notifier(struct notifier_block *nb);
> +
> +extern int xen_pcpu_index(uint32_t acpi_id, int is_acpiid);
> +#endif
> -- 
> 1.6.5.6


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

