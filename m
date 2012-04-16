Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2DPUb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:31:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31000 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2DPUbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:31:55 -0400
Date: Mon, 16 Apr 2012 16:26:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add mcelog support for xen platform
Message-ID: <20120416202650.GB14982@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335146A62@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335146A62@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F8C81B6.00DD,ss=1,re=1.599,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 01:05:55AM +0000, Liu, Jinsong wrote:
> >From 0ee0651756eb6255bc81da8a7b6313bab4b80d1e Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Sun, 15 Apr 2012 22:58:34 +0800
> Subject: [PATCH 1/2] Add mcelog support for xen platform
> 
> When MCA error occurs, it would be handled by xen hypervisor first,
> and then the error information would be sent to dom0 for logging.
> 
> This patch gets error information from xen hypervisor and convert
> xen format error into linux format mcelog. This logic is basically
> self-contained, not much touching other kernel components.
> 
> So under xen platform when MCA error occurs, the error information
> would be sent to dom0 and converted into native linux mcelog format.
> By using tools like mcelog tool users could read specific error information,
> like what they did under native linux.
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/include/asm/xen/hypercall.h |    8 +
>  arch/x86/xen/enlighten.c             |    4 +-
>  drivers/xen/Kconfig                  |    8 +
>  drivers/xen/Makefile                 |    1 +
>  drivers/xen/mcelog.c                 |  201 ++++++++++++++++++++
>  include/xen/interface/xen-mca.h      |  336 ++++++++++++++++++++++++++++++++++
>  6 files changed, 555 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/xen/mcelog.c
>  create mode 100644 include/xen/interface/xen-mca.h
> 
> diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
> index 5728852..59c226d 100644
> --- a/arch/x86/include/asm/xen/hypercall.h
> +++ b/arch/x86/include/asm/xen/hypercall.h
> @@ -48,6 +48,7 @@
>  #include <xen/interface/sched.h>
>  #include <xen/interface/physdev.h>
>  #include <xen/interface/platform.h>
> +#include <xen/interface/xen-mca.h>
>  
>  /*
>   * The hypercall asms have to meet several constraints:
> @@ -302,6 +303,13 @@ HYPERVISOR_set_timer_op(u64 timeout)
>  }
>  
>  static inline int
> +HYPERVISOR_mca(struct xen_mc *mc_op)
> +{
> +	mc_op->interface_version = XEN_MCA_INTERFACE_VERSION;
> +	return _hypercall1(int, mca, mc_op);
> +}
> +
> +static inline int
>  HYPERVISOR_dom0_op(struct xen_platform_op *platform_op)
>  {
>  	platform_op->interface_version = XENPF_INTERFACE_VERSION;
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 4f51beb..15628d4 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -329,9 +329,7 @@ static void __init xen_init_cpuid_mask(void)
>  	unsigned int xsave_mask;
>  
>  	cpuid_leaf1_edx_mask =
> -		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
> -		  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
> -		  (1 << X86_FEATURE_MTRR) |  /* disable MTRR */
> +		~((1 << X86_FEATURE_MTRR) |  /* disable MTRR */
>  		  (1 << X86_FEATURE_ACC));   /* thermal monitoring */
>  
>  	if (!xen_initial_domain())
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 9424313..f45f923 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -194,4 +194,12 @@ config XEN_ACPI_PROCESSOR
>            module will be called xen_acpi_processor  If you do not know what to choose,
>            select M here. If the CPUFREQ drivers are built in, select Y here.
>  
> +config XEN_MCE_LOG
> +	bool "Xen platform mcelog"
> +	depends on XEN_DOM0 && X86_64 && X86_MCE
> +	default n
> +	help
> +	  Allow kernel fetching mce log from xen platform and
> +	  converting it into linux mcelog format for mcelog tools

You should use proper capitalization. Such as 'Linux' and 'Xen'
and MCE.
> +
>  endmenu
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 9adc5be..1d3e763 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_XEN_GNTDEV)		+= xen-gntdev.o
>  obj-$(CONFIG_XEN_GRANT_DEV_ALLOC)	+= xen-gntalloc.o
>  obj-$(CONFIG_XENFS)			+= xenfs/
>  obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
> +obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
>  obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
>  obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
> diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
> new file mode 100644
> index 0000000..e9f86b8
> --- /dev/null
> +++ b/drivers/xen/mcelog.c
> @@ -0,0 +1,201 @@
> +/******************************************************************************
> + * mcelog.c
> + * Driver for receiving and transferring machine check error infomation
> + *
> + * Copyright (c) 2012 Intel Corporation
> + * Author: Liu, Jinsong <jinsong.liu@intel.com>
> + * Author: Jiang, Yunhong <yunhong.jiang@intel.com>
> + * Author: Ke, Liping <liping.ke@intel.com>
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
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <xen/interface/xen.h>
> +#include <asm/xen/hypervisor.h>
> +#include <xen/events.h>
> +#include <xen/interface/vcpu.h>
> +#include <asm/xen/hypercall.h>
> +#include <asm/mce.h>
> +#include <xen/xen.h>
> +
> +static struct mc_info g_mi;
> +static struct mcinfo_logical_cpu *g_physinfo;
> +static uint32_t ncpus;
> +
> +static DEFINE_SPINLOCK(mcelog_lock);
> +
> +static void convert_log(struct mc_info *mi)

There is a bunch of checks you do in this function.

Why don't you make this function return a value and
then you can do a similar check for return code in
mc_queue_handle?

> +{
> +	struct mcinfo_common *mic;
> +	struct mcinfo_global *mc_global;
> +	struct mcinfo_bank *mc_bank;
> +	struct mce m;
> +	int i;

unsigned int as the ncpus is unsigned int.


> +
> +	mic = NULL;
> +	x86_mcinfo_lookup(&mic, mi, MC_TYPE_GLOBAL);
> +	if (unlikely(!mic))
> +		return;
> +
> +	mce_setup(&m);
> +	mc_global = (struct mcinfo_global *)mic;
> +	m.mcgstatus = mc_global->mc_gstatus;
> +	m.apicid = mc_global->mc_apicid;
> +
> +	for (i = 0; i < ncpus; i++)
> +		if (g_physinfo[i].mc_apicid == m.apicid)
> +			break;
> +	if (unlikely(i == ncpus))
> +		return;
> +
> +	m.socketid = g_physinfo[i].mc_chipid;
> +	m.cpu = m.extcpu = g_physinfo[i].mc_cpunr;
> +	m.cpuvendor = (__u8)g_physinfo[i].mc_vendor;
> +	m.mcgcap = g_physinfo[i].mc_msrvalues[__MC_MSR_MCGCAP].value;
> +
> +	mic = NULL;
> +	x86_mcinfo_lookup(&mic, mi, MC_TYPE_BANK);
> +
> +	do {
> +		if ((!mic) || (mic->size == 0) ||
> +		    (mic->type != MC_TYPE_GLOBAL   &&
> +		     mic->type != MC_TYPE_BANK     &&
> +		     mic->type != MC_TYPE_EXTENDED &&
> +		     mic->type != MC_TYPE_RECOVERY))
> +			break;
> +
> +		if (mic->type == MC_TYPE_BANK) {
> +			mc_bank = (struct mcinfo_bank *)mic;
> +			m.misc = mc_bank->mc_misc;
> +			m.status = mc_bank->mc_status;
> +			m.addr = mc_bank->mc_addr;
> +			m.tsc = mc_bank->mc_tsc;
> +			m.bank = mc_bank->mc_bank;
> +			m.finished = 1;
> +			/*log this record*/
> +			mce_log(&m);
> +		}
> +		mic = x86_mcinfo_next(mic);
> +	} while (1);
> +}
> +
> +static void mc_queue_handle(uint32_t flags)
> +{
> +	struct xen_mc mc_op;
> +	int ret = 0;
> +	unsigned long tmp;
> +
> +	spin_lock_irqsave(&mcelog_lock, tmp);
> +
> +	mc_op.cmd = XEN_MC_fetch;
> +	mc_op.interface_version = XEN_MCA_INTERFACE_VERSION;
> +	set_xen_guest_handle(mc_op.u.mc_fetch.data, &g_mi);
> +	do {
> +		mc_op.u.mc_fetch.flags = flags;
> +		ret = HYPERVISOR_mca(&mc_op);
> +		if (ret || mc_op.u.mc_fetch.flags & XEN_MC_NODATA ||
> +		    mc_op.u.mc_fetch.flags & XEN_MC_FETCHFAILED)
> +			break;
> +		else {
> +			convert_log(&g_mi);
> +			mc_op.u.mc_fetch.flags = flags | XEN_MC_ACK;
> +			ret = HYPERVISOR_mca(&mc_op);
> +			if (ret)
> +				break;
> +		}
> +	} while (1);
> +
> +	spin_unlock_irqrestore(&mcelog_lock, tmp);
> +
> +	return;

No 'return ret' ?

Or at least:

WARN_ON(ret, "Failed @ ... (ret: %d)", g_mi.. something ?, ret);
> +}
> +
> +/* virq handler for machine check error info*/
> +static irqreturn_t mce_dom_interrupt(int irq, void *dev_id)
> +{
> +	/* urgent mc_info */
> +	mc_queue_handle(XEN_MC_URGENT);
> +
> +	/* nonurgent mc_info */
> +	mc_queue_handle(XEN_MC_NONURGENT);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int bind_virq_for_mce(void)
> +{
> +	int ret;
> +	struct xen_mc mc_op;
> +
> +	memset(&mc_op, 0, sizeof(struct xen_mc));
> +
> +	/* Fetch physical CPU Numbers */
> +	mc_op.cmd = XEN_MC_physcpuinfo;
> +	mc_op.interface_version = XEN_MCA_INTERFACE_VERSION;
> +	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
> +	ret = HYPERVISOR_mca(&mc_op);
> +	if (ret) {
> +		printk(KERN_ERR "MCE_LOG: Failed to get CPU numbers\n");

pr_err. And
if you can something like this:

#define DRV_NAME "xen_mce: "

pr_err(DRV_NAME "Failed to get CPU numbers! (ret: %d)\n, ret)

> +		return ret;
> +	}
> +
> +	/* Fetch each CPU Physical Info for later reference*/
> +	ncpus = mc_op.u.mc_physcpuinfo.ncpus;
> +	g_physinfo = kzalloc(sizeof(struct mcinfo_logical_cpu) * ncpus,
> +			     GFP_KERNEL);

Use kcalloc please.

> +	if (!g_physinfo)
> +		return -ENOMEM;
> +	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
> +	ret = HYPERVISOR_mca(&mc_op);
> +	if (ret) {
> +		printk(KERN_ERR "MCE_LOG: Failed to get CPU info\n");

Ditto - pr_err

> +		kfree(g_physinfo);
> +		return ret;
> +	}
> +
> +	ret  = bind_virq_to_irqhandler(VIRQ_MCA, 0,
> +				       mce_dom_interrupt, 0, "mce", NULL);

s/mce_dom_interrupt/xen_mce_interrupt/g


> +	if (ret < 0) {
> +		printk(KERN_ERR "MCE_LOG: Failed to bind virq\n");
> +		kfree(g_physinfo);
> +	}
> +
> +	return ret;
> +}
> +
> +static int __init mcelog_init(void)
> +{
> +	/* Only DOM0 is responsible for MCE logging */
> +	if (xen_initial_domain())
> +		return bind_virq_for_mce();
> +
> +	return -ENODEV;
> +}
> +late_initcall(mcelog_init);
> diff --git a/include/xen/interface/xen-mca.h b/include/xen/interface/xen-mca.h
> new file mode 100644
> index 0000000..f2561db
> --- /dev/null
> +++ b/include/xen/interface/xen-mca.h
> @@ -0,0 +1,336 @@
> +/******************************************************************************
> + * arch-x86/mca.h
> + * Guest OS machine check interface to x86 Xen.
> + *
> + * Contributed by Advanced Micro Devices, Inc.
> + * Author: Christoph Egger <Christoph.Egger@amd.com>
> + *
> + * Updated by Intel Corporation
> + * Author: Liu, Jinsong <jinsong.liu@intel.com>
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + */
> +
> +#ifndef __XEN_PUBLIC_ARCH_X86_MCA_H__
> +#define __XEN_PUBLIC_ARCH_X86_MCA_H__
> +
> +/* Hypercall */
> +#define __HYPERVISOR_mca __HYPERVISOR_arch_0
> +
> +#define XEN_MCA_INTERFACE_VERSION	0x01ecc003
> +
> +/* IN: Dom0 calls hypercall to retrieve nonurgent error log entry */
> +#define XEN_MC_NONURGENT	0x1
> +/* IN: Dom0 calls hypercall to retrieve urgent error log entry */
> +#define XEN_MC_URGENT		0x2
> +/* IN: Dom0 acknowledges previosly-fetched error log entry */
> +#define XEN_MC_ACK		0x4
> +
> +/* OUT: All is ok */
> +#define XEN_MC_OK		0x0
> +/* OUT: Domain could not fetch data. */
> +#define XEN_MC_FETCHFAILED	0x1
> +/* OUT: There was no machine check data to fetch. */
> +#define XEN_MC_NODATA		0x2
> +
> +#ifndef __ASSEMBLY__
> +/* vIRQ injected to Dom0 */
> +#define VIRQ_MCA VIRQ_ARCH_0
> +
> +/*
> + * mc_info entry types
> + * mca machine check info are recorded in mc_info entries.
> + * when fetch mca info, it can use MC_TYPE_... to distinguish
> + * different mca info.
> + */
> +#define MC_TYPE_GLOBAL		0
> +#define MC_TYPE_BANK		1
> +#define MC_TYPE_EXTENDED	2
> +#define MC_TYPE_RECOVERY	3
> +
> +struct mcinfo_common {
> +	uint16_t type; /* structure type */
> +	uint16_t size; /* size of this struct in bytes */
> +};
> +
> +#define MC_FLAG_CORRECTABLE	(1 << 0)
> +#define MC_FLAG_UNCORRECTABLE	(1 << 1)
> +#define MC_FLAG_RECOVERABLE	(1 << 2)
> +#define MC_FLAG_POLLED		(1 << 3)
> +#define MC_FLAG_RESET		(1 << 4)
> +#define MC_FLAG_CMCI		(1 << 5)
> +#define MC_FLAG_MCE		(1 << 6)
> +
> +/* contains x86 global mc information */
> +struct mcinfo_global {
> +	struct mcinfo_common common;
> +
> +	uint16_t mc_domid; /* running domain at the time in error */
> +	uint16_t mc_vcpuid; /* virtual cpu scheduled for mc_domid */
> +	uint32_t mc_socketid; /* physical socket of the physical core */
> +	uint16_t mc_coreid; /* physical impacted core */
> +	uint16_t mc_core_threadid; /* core thread of physical core */
> +	uint32_t mc_apicid;
> +	uint32_t mc_flags;
> +	uint64_t mc_gstatus; /* global status */
> +};
> +
> +/* contains x86 bank mc information */
> +struct mcinfo_bank {
> +	struct mcinfo_common common;
> +
> +	uint16_t mc_bank; /* bank nr */
> +	uint16_t mc_domid; /* domain referenced by mc_addr if valid */
> +	uint64_t mc_status; /* bank status */
> +	uint64_t mc_addr; /* bank address */
> +	uint64_t mc_misc;
> +	uint64_t mc_ctrl2;
> +	uint64_t mc_tsc;
> +};
> +
> +struct mcinfo_msr {
> +	uint64_t reg; /* MSR */
> +	uint64_t value; /* MSR value */
> +};
> +
> +/* contains mc information from other or additional mc MSRs */
> +struct mcinfo_extended {
> +	struct mcinfo_common common;
> +	uint32_t mc_msrs; /* Number of msr with valid values. */
> +	/*
> +	 * Currently Intel extended MSR (32/64) include all gp registers
> +	 * and E(R)FLAGS, E(R)IP, E(R)MISC, up to 11/19 of them might be
> +	 * useful at present. So expand this array to 16/32 to leave room.
> +	 */
> +	struct mcinfo_msr mc_msr[sizeof(void *) * 4];
> +};
> +
> +/* Recovery Action flags. Giving recovery result information to DOM0 */
> +
> +/* Xen takes successful recovery action, the error is recovered */
> +#define REC_ACTION_RECOVERED (0x1 << 0)
> +/* No action is performed by XEN */
> +#define REC_ACTION_NONE (0x1 << 1)
> +/* It's possible DOM0 might take action ownership in some case */
> +#define REC_ACTION_NEED_RESET (0x1 << 2)
> +
> +/*
> + * Different Recovery Action types, if the action is performed successfully,
> + * REC_ACTION_RECOVERED flag will be returned.
> + */
> +
> +/* Page Offline Action */
> +#define MC_ACTION_PAGE_OFFLINE (0x1 << 0)
> +/* CPU offline Action */
> +#define MC_ACTION_CPU_OFFLINE (0x1 << 1)
> +/* L3 cache disable Action */
> +#define MC_ACTION_CACHE_SHRINK (0x1 << 2)
> +
> +/*
> + * Below interface used between XEN/DOM0 for passing XEN's recovery action
> + * information to DOM0.
> + */
> +struct page_offline_action {
> +	/* Params for passing the offlined page number to DOM0 */
> +	uint64_t mfn;
> +	uint64_t status;
> +};
> +
> +struct cpu_offline_action {
> +	/* Params for passing the identity of the offlined CPU to DOM0 */
> +	uint32_t mc_socketid;
> +	uint16_t mc_coreid;
> +	uint16_t mc_core_threadid;
> +};
> +
> +#define MAX_UNION_SIZE 16
> +struct mcinfo_recovery {
> +	struct mcinfo_common common;
> +	uint16_t mc_bank; /* bank nr */
> +	uint8_t action_flags;
> +	uint8_t action_types;
> +	union {
> +		struct page_offline_action page_retire;
> +		struct cpu_offline_action cpu_offline;
> +		uint8_t pad[MAX_UNION_SIZE];
> +	} action_info;
> +};
> +
> +
> +#define MCINFO_MAXSIZE 768
> +struct mc_info {
> +	/* Number of mcinfo_* entries in mi_data */
> +	uint32_t mi_nentries;
> +	uint32_t flags;
> +	uint64_t mi_data[(MCINFO_MAXSIZE - 1) / 8];
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(mc_info);
> +
> +#define __MC_MSR_ARRAYSIZE 8
> +#define __MC_MSR_MCGCAP 0
> +#define __MC_NMSRS 1
> +#define MC_NCAPS 7
> +struct mcinfo_logical_cpu {
> +	uint32_t mc_cpunr;
> +	uint32_t mc_chipid;
> +	uint16_t mc_coreid;
> +	uint16_t mc_threadid;
> +	uint32_t mc_apicid;
> +	uint32_t mc_clusterid;
> +	uint32_t mc_ncores;
> +	uint32_t mc_ncores_active;
> +	uint32_t mc_nthreads;
> +	uint32_t mc_cpuid_level;
> +	uint32_t mc_family;
> +	uint32_t mc_vendor;
> +	uint32_t mc_model;
> +	uint32_t mc_step;
> +	char mc_vendorid[16];
> +	char mc_brandid[64];
> +	uint32_t mc_cpu_caps[MC_NCAPS];
> +	uint32_t mc_cache_size;
> +	uint32_t mc_cache_alignment;
> +	uint32_t mc_nmsrvals;
> +	struct mcinfo_msr mc_msrvalues[__MC_MSR_ARRAYSIZE];
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(mcinfo_logical_cpu);
> +
> +/*
> + * Prototype:
> + *    uint32_t x86_mcinfo_nentries(struct mc_info *mi);
> + */
> +#define x86_mcinfo_nentries(_mi)    \
> +	((_mi)->mi_nentries)
> +/*
> + * Prototype:
> + *    struct mcinfo_common *x86_mcinfo_first(struct mc_info *mi);
> + */
> +#define x86_mcinfo_first(_mi)       \
> +	((struct mcinfo_common *)(_mi)->mi_data)
> +/*
> + * Prototype:
> + *    struct mcinfo_common *x86_mcinfo_next(struct mcinfo_common *mic);
> + */
> +#define x86_mcinfo_next(_mic)       \
> +	((struct mcinfo_common *)((uint8_t *)(_mic) + (_mic)->size))
> +
> +/*
> + * Prototype:
> + *    void x86_mcinfo_lookup(void *ret, struct mc_info *mi, uint16_t type);
> + */
> +static inline void x86_mcinfo_lookup(struct mcinfo_common **ret,
> +				     struct mc_info *mi, uint16_t type)
> +{
> +	uint32_t i;
> +	struct mcinfo_common *mic;
> +	bool found = 0;
> +
> +	if (!ret || !mi)
> +		return;
> +
> +	mic = x86_mcinfo_first(mi);
> +	for (i = 0; i < x86_mcinfo_nentries(mi); i++) {
> +		if (mic->type == type) {
> +			found = 1;
> +			break;
> +		}
> +		mic = x86_mcinfo_next(mic);
> +	}
> +
> +	*ret = found ? mic : NULL;
> +}
> +
> +/*
> + * Fetch machine check data from hypervisor.
> + */
> +#define XEN_MC_fetch		1
> +struct xen_mc_fetch {
> +	/*
> +	 * IN: XEN_MC_NONURGENT, XEN_MC_URGENT,
> +	 * XEN_MC_ACK if ack'king an earlier fetch
> +	 * OUT: XEN_MC_OK, XEN_MC_FETCHAILED, XEN_MC_NODATA
> +	 */
> +	uint32_t flags;
> +	uint32_t _pad0;
> +	/* OUT: id for ack, IN: id we are ack'ing */
> +	uint64_t fetch_id;
> +
> +	/* OUT variables. */
> +	GUEST_HANDLE(mc_info) data;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xen_mc_fetch);
> +
> +
> +/*
> + * This tells the hypervisor to notify a DomU about the machine check error
> + */
> +#define XEN_MC_notifydomain	2
> +struct xen_mc_notifydomain {
> +	/* IN variables */
> +	uint16_t mc_domid; /* The unprivileged domain to notify */
> +	uint16_t mc_vcpuid; /* The vcpu in mc_domid to notify */
> +
> +	/* IN/OUT variables */
> +	uint32_t flags;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xen_mc_notifydomain);
> +
> +#define XEN_MC_physcpuinfo	3
> +struct xen_mc_physcpuinfo {
> +	/* IN/OUT */
> +	uint32_t ncpus;
> +	uint32_t _pad0;
> +	/* OUT */
> +	GUEST_HANDLE(mcinfo_logical_cpu) info;
> +};
> +
> +#define XEN_MC_msrinject	4
> +#define MC_MSRINJ_MAXMSRS	8
> +struct xen_mc_msrinject {
> +	/* IN */
> +	uint32_t mcinj_cpunr; /* target processor id */
> +	uint32_t mcinj_flags; /* see MC_MSRINJ_F_* below */
> +	uint32_t mcinj_count; /* 0 .. count-1 in array are valid */
> +	uint32_t _pad0;
> +	struct mcinfo_msr mcinj_msr[MC_MSRINJ_MAXMSRS];
> +};
> +
> +/* Flags for mcinj_flags above; bits 16-31 are reserved */
> +#define MC_MSRINJ_F_INTERPOSE	0x1
> +
> +#define XEN_MC_mceinject	5
> +struct xen_mc_mceinject {
> +	unsigned int mceinj_cpunr; /* target processor id */
> +};
> +
> +struct xen_mc {
> +	uint32_t cmd;
> +	uint32_t interface_version; /* XEN_MCA_INTERFACE_VERSION */
> +	union {
> +		struct xen_mc_fetch        mc_fetch;
> +		struct xen_mc_notifydomain mc_notifydomain;
> +		struct xen_mc_physcpuinfo  mc_physcpuinfo;
> +		struct xen_mc_msrinject    mc_msrinject;
> +		struct xen_mc_mceinject    mc_mceinject;
> +	} u;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xen_mc);
> +
> +#endif /* __ASSEMBLY__ */
> +#endif /* __XEN_PUBLIC_ARCH_X86_MCA_H__ */

OK, besides those comments it looks great. Please re-send with
the modifications.

> -- 
> 1.7.1


