Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2EKOY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:24:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22964 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2EKOY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:24:27 -0400
Date: Fri, 11 May 2012 10:18:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Xen physical cpus interface (V2)
Message-ID: <20120511141817.GB13735@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351B58A3@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351B58A3@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> +
> +	device_unregister(dev);
> +}
> +
> +static void free_pcpu(struct pcpu *pcpu)

1) So this isn't just freeing the PCPU, it also unregisters
the SysFS.

As such you should call this differently:

unregister_and_free(struct pcpu *pcpu)

or do the unregistration part seperatly.

2) But there is also another issue - a possiblity of race.

The user might be running:
while (true)
do
 echo 1 > online
 echo 0 > online
done

and the the sync_pcpu will end up calling pcpu_sys_remove and
free the pcpu. The SysFS aren't deleted until all of the
object references (kref's) have been put. So when you get to
'kfree(pcpu)' you might be still holding a reference (meaning
the user is doing 'echo 0 > online') and crash.

I think you need to hold the mutex in the store_online() function
(not good), or better yet, make a device_release function
that will be called when the last kref has been put.


3) Third the name. These functions all depend on the mutex lock being
held. As such add a postfix to the name of the function of 
"_locked" or a prefix of "__' so it is known that the caller holds
the mutex.

> +{
> +	if (!pcpu)
> +		return;
> +
> +	pcpu_sys_remove(pcpu);
> +
> +	list_del(&pcpu->list);
> +	kfree(pcpu);
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
> +	dev->id = pcpu->cpu_id;
> +
> +	err = device_register(dev);
> +	if (err)
> +		return err;
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
> +	INIT_LIST_HEAD(&pcpu->list);
> +	pcpu->cpu_id = info->xen_cpuid;
> +	pcpu->flags = info->flags;
> +
> +	err = pcpu_sys_create(pcpu);
> +	if (err) {
> +		pr_warning(XEN_PCPU "Failed to register pcpu%u\n",
> +			   info->xen_cpuid);
> +		kfree(pcpu);
> +		return ERR_PTR(-ENOENT);
> +	}
> +
> +	/* Need hold on xen_pcpu_lock before pcpu list manipulations */
> +	list_add_tail(&pcpu->list, &xen_pcpus);
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
> +	uint32_t cpu = 0, max_cpu = 0;
> +	int err = 0;
> +	struct list_head *cur, *tmp;
> +	struct pcpu *pcpu;
> +
> +	mutex_lock(&xen_pcpu_lock);
> +
> +	while (!err && (cpu <= max_cpu)) {
> +		err = sync_pcpu(cpu, &max_cpu);
> +		cpu++;
> +	}
> +
> +	if (err) {
> +		list_for_each_safe(cur, tmp, &xen_pcpus) {
> +			pcpu = list_entry(cur, struct pcpu, list);
> +			free_pcpu(pcpu);
> +		}
> +	}
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


