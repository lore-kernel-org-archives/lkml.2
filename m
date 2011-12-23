Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1LWNZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:25:05 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60884 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab1LWNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:25:02 -0500
Date: Fri, 23 Dec 2011 09:24:53 -0400
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
Subject: Re: [Xen-devel] [PATCH 10/10] Xen: update pcpu online/offline logic
Message-ID: <20111223132453.GF25286@andromeda.dapyr.net>
References: <DE8DF0795D48FD4CA783C40EC82923359771@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923359771@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:32:12AM +0000, Liu, Jinsong wrote:
> >From 1e59d2ec2ff93b42c86d18c7cc9432ca2172a795 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Wed, 14 Dec 2011 21:06:11 +0800
> Subject: [PATCH 10/10] Xen: update pcpu online/offline logic
> 
> This patch update pcpu online/offline logic.

Roll them in the patch you posted please.
> 
> It closes cpu0's /sys/.../xen_pcpu0/online authority to user.
> It also simplifies pcpu sync by removing redundant logic.
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> ---
>  drivers/xen/pcpu.c |   71 ++++++++++++++--------------------------------------
>  1 files changed, 19 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
> index 6d1a770..1d32784 100644
> --- a/drivers/xen/pcpu.c
> +++ b/drivers/xen/pcpu.c
> @@ -24,7 +24,6 @@ static RAW_NOTIFIER_HEAD(xen_pcpu_chain);
>  
>  struct xen_pcpus {
>  	struct list_head list;
> -	int present;
>  };
>  static struct xen_pcpus xen_pcpus;
>  
> @@ -189,9 +188,13 @@ static int pcpu_sysdev_init(struct pcpu *cpu)
>  		kfree(cpu);
>  		return -1;
>  	}
> -	sysdev_create_file(&cpu->sysdev, &attr_online);
>  	sysdev_create_file(&cpu->sysdev, &attr_apic_id);
>  	sysdev_create_file(&cpu->sysdev, &attr_acpi_id);
> +
> +	/* Not open cpu0 online access to user */
> +	if (cpu->sysdev.id)
> +		sysdev_create_file(&cpu->sysdev, &attr_online);
> +
>  	return 0;
>  }
>  
> @@ -239,17 +242,10 @@ static struct pcpu *init_pcpu(struct xenpf_pcpuinfo *info)
>  	return pcpu;
>  }
>  
> -#define PCPU_NO_CHANGE			0
> -#define PCPU_ADDED			1
> -#define PCPU_ONLINE_OFFLINE		2
> -#define PCPU_REMOVED			3
>  /*
>   * Caller should hold the pcpu lock
> - * < 0: Something wrong
> - * 0: No changes
> - * > 0: State changed
>   */
> -static struct pcpu *_sync_pcpu(int cpu_num, int *max_id, int *result)
> +static int _sync_pcpu(int cpu_num, int *max_id)
>  {
>  	struct pcpu *pcpu = NULL;
>  	struct xenpf_pcpuinfo *info;
> @@ -259,14 +255,12 @@ static struct pcpu *_sync_pcpu(int cpu_num, int *max_id, int *result)
>  	};
>  	int ret;
>  
> -	*result = -1;
> -
>  	info = &op.u.pcpu_info;
>  	info->xen_cpuid = cpu_num;
>  
>  	ret = HYPERVISOR_dom0_op(&op);
>  	if (ret)
> -		return NULL;
> +		return -1;
>  
>  	if (max_id)
>  		*max_id = op.u.pcpu_info.max_present;
> @@ -275,28 +269,24 @@ static struct pcpu *_sync_pcpu(int cpu_num, int *max_id, int *result)
>  
>  	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
>  		/* The pcpu has been removed */
> -		*result = PCPU_NO_CHANGE;
>  		if (pcpu) {
>  			raw_notifier_call_chain(&xen_pcpu_chain,
>  			  XEN_PCPU_REMOVE,
>  			  (void *)(long)pcpu->xen_id);
>  			xen_pcpu_free(pcpu);
> -			*result = PCPU_REMOVED;
>  		}
> -		return NULL;
> +		return 0;
>  	}
>  
>  
>  	if (!pcpu) {
> -		*result = PCPU_ADDED;
>  		pcpu = init_pcpu(info);
>  		if (pcpu == NULL) {
>  			printk(KERN_WARNING "Failed to init pcpu %x\n",
>  			  info->xen_cpuid);
> -			  *result = -1;
> +			return -1;
>  		}
>  	} else {
> -		*result = PCPU_NO_CHANGE;
>  		/*
>  		 * Old PCPU is replaced with a new pcpu, this means
>  		 * several virq is missed, will it happen?
> @@ -307,10 +297,10 @@ static struct pcpu *_sync_pcpu(int cpu_num, int *max_id, int *result)
>  			pcpu->apic_id = info->apic_id;
>  			pcpu->acpi_id = info->acpi_id;
>  		}
> -		if (xen_pcpu_online_check(info, pcpu))
> -			*result = PCPU_ONLINE_OFFLINE;
> +		xen_pcpu_online_check(info, pcpu);
>  	}
> -	return pcpu;
> +
> +	return 0;
>  }
>  
>  int xen_pcpu_index(uint32_t id, int is_acpiid)
> @@ -353,50 +343,27 @@ static int xen_sync_pcpus(void)
>  	/*
>  	 * Boot cpu always have cpu_id 0 in xen
>  	 */
> -	int cpu_num = 0, max_id = 0, result = 0, present = 0;
> +	int cpu_num = 0, max_id = 0, ret = 0;
>  	struct list_head *elem, *tmp;
>  	struct pcpu *pcpu;
>  
>  	get_pcpu_lock();
>  
> -	while ((result >= 0) && (cpu_num <= max_id)) {
> -		pcpu = _sync_pcpu(cpu_num, &max_id, &result);
> -
> -		printk(KERN_DEBUG "sync cpu %x get result %x max_id %x\n",
> -			cpu_num, result, max_id);
> -
> -		switch (result)	{
> -		case PCPU_NO_CHANGE:
> -			if (pcpu)
> -				present++;
> -			break;
> -		case PCPU_ADDED:
> -		case PCPU_ONLINE_OFFLINE:
> -			present++;
> -		case PCPU_REMOVED:
> -			break;
> -		default:
> -			printk(KERN_WARNING "Failed to sync pcpu %x\n",
> -			  cpu_num);
> -			break;
> -
> -		}
> +	while (!ret && (cpu_num <= max_id)) {
> +		ret = _sync_pcpu(cpu_num, &max_id);
>  		cpu_num++;
>  	}
>  
> -	if (result < 0) {
> +	if (ret < 0) {
>  		list_for_each_safe(elem, tmp, &xen_pcpus.list) {
>  			pcpu = list_entry(elem, struct pcpu, pcpu_list);
>  			xen_pcpu_free(pcpu);
>  		}
> -		present = 0;
>  	}
>  
> -	xen_pcpus.present = present;
> -
>  	put_pcpu_lock();
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static void xen_pcpu_dpc(struct work_struct *work)
> @@ -436,10 +403,10 @@ static int __init xen_pcpu_init(void)
>  	}
>  
>  	INIT_LIST_HEAD(&xen_pcpus.list);
> -	xen_pcpus.present = 0;
>  
>  	xen_sync_pcpus();
> -	if (xen_pcpus.present > 0)
> +
> +	if (!list_empty(&xen_pcpus.list))
>  		err = bind_virq_to_irqhandler(VIRQ_PCPU_STATE,
>  			0, xen_pcpu_interrupt, 0, "pcpu", NULL);
>  	if (err < 0)
> -- 
> 1.6.5.6


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

