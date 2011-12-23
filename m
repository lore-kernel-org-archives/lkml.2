Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1LWMm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:42:27 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60286 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1LWMmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:42:24 -0500
Date: Fri, 23 Dec 2011 08:42:08 -0400
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
Subject: Re: [Xen-devel] [PATCH 01/10] Add mcelog support from xen platform
Message-ID: <20111223124208.GA25286@andromeda.dapyr.net>
References: <DE8DF0795D48FD4CA783C40EC82923359699@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923359699@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:23:03AM +0000, Liu, Jinsong wrote:
> >From 0e8de1ce0f13aa34aa6013e6a387ae5be78031ca Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Tue, 6 Dec 2011 18:08:12 +0800
> Subject: [PATCH 01/10] Add mcelog support from xen platform

.. for xen platform.
> 
> This patch backport from Jeremy's pvops commit a5ed1f3dae179158e385e9371462dd65d5e125c5,
> which in turn backport from previous xen DOM0(2.6.18) cs: 75e5bfa7fbdc

Ok. You should also include a link to the tree.

Is this patch by itself usuable? Meaning it can work without being
dependent on the ACPI patches?
> 
> When a MCE/CMCI error happens (or by polling), the related error

What does CMCI stand for? Can you include the full description of
what those are (both MCE and CMCI)?
> information will be sent to privileged pv-ops domain by XEN. This

No need to say 'pv-ops'. This patchset is _for_ the pv-ops kernel
and it is _only_ a pv-ops type kernel.

> patch will help to fetch the xen-logged information by hypercall

s/xen-logged/logged
> and then convert XEN-format log into Linux format MCELOG. It makes
> using current available mcelog tools for native Linux possible.

Excellent. Can you include in this section how to test it.
A step by step instruction? Or perhaps just point to documentation
if such exist?

> 
> With this patch, after mce/cmci error log information is sent to
> pv-ops guest, Running mcelog tools in the guest, you will get same

Priviliged guests or not-priviliged?
> detailed decoded mce information as in Native Linux.
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/include/asm/xen/hypercall.h |    8 +
>  arch/x86/xen/enlighten.c             |    8 +-
>  drivers/xen/Kconfig                  |    8 +
>  drivers/xen/Makefile                 |    1 +
>  drivers/xen/mcelog.c                 |  217 +++++++++++++++++
>  include/xen/interface/xen-mca.h      |  429 ++++++++++++++++++++++++++++++++++

Make sure you run this patch through scripts/cleanpatch.pl.

I ran it through that and found 8 issues, please fix those.

>  6 files changed, 667 insertions(+), 4 deletions(-)
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
> index 9306320..b073e4c 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -242,14 +242,14 @@ static void __init xen_init_cpuid_mask(void)
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
>  		cpuid_leaf1_edx_mask &=
> -			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
> +			~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
> +			  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
> +			  (1 << X86_FEATURE_APIC) |  /* disable local APIC */
>  			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
>  	ax = 1;
>  	xen_cpuid(&ax, &bx, &cx, &dx);
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index e8fb85f..eb2a327 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -117,6 +117,14 @@ config XEN_SYS_HYPERVISOR
>  	 virtual environment, /sys/hypervisor will still be present,
>  	 but will have no xen contents.
>  
> +config XEN_MCE_LOG
> +	bool "Xen platform mcelog"
> +	depends on XEN_DOM0 && X86_64 && X86_MCE
> +	default y

That should 'n'.
> +	help
> +	  Allow kernel fetching mce log from xen platform and
> +	  converting it into linux mcelog format for mcelog tools
> +
>  config ACPI_PROCESSOR_XEN
>  	tristate
>  	depends on XEN_DOM0 && ACPI_PROCESSOR && CPU_FREQ
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index d42da53..405cce9 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_XEN_GNTDEV)		+= xen-gntdev.o
>  obj-$(CONFIG_XEN_GRANT_DEV_ALLOC)	+= xen-gntalloc.o
>  obj-$(CONFIG_XENFS)			+= xenfs/
>  obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
> +obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
>  obj-$(CONFIG_XEN_PLATFORM_PCI)		+= xen-platform-pci.o
>  obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
> diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
> new file mode 100644
> index 0000000..892ca7b
> --- /dev/null
> +++ b/drivers/xen/mcelog.c
> @@ -0,0 +1,217 @@
> +/******************************************************************************
> + * mcelog.c
> + * Add Machine Check event Logging support in DOM0
> + *
> + * Driver for receiving and logging machine check event

Uh, logging? I thought the logging would be handed of the generic MCElog
interface?

> + *
> + * Copyright (c) 2008, 2009 Intel Corporation
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
> +static mc_info_t *g_mi;

Include a comment saying why you don't need locking for the 'g_mi'
structure.
> +static mcinfo_logical_cpu_t *g_physinfo;

.. and for this one too.

> +static uint32_t ncpus;
> +
> +static int convert_log(struct mc_info *mi)
> +{
> +	struct mcinfo_common *mic = NULL;
> +	struct mcinfo_global *mc_global;
> +	struct mcinfo_bank *mc_bank;
> +	struct mce m;
> +	int i, found = 0;

Make 'found' a bool please.
> +
> +	x86_mcinfo_lookup(&mic, mi, MC_TYPE_GLOBAL);
> +	WARN_ON(!mic);

Should there be some extra information? Say:

WARN_ON(!mic,"Was not able to find global MCE!")

Should you quit this routine if this happens?
> +
> +	mce_setup(&m);
> +	mc_global = (struct mcinfo_global *)mic;
> +	m.mcgstatus = mc_global->mc_gstatus;

So if mic=NULL, this would do mic->mc_gstatus which would trigger a NULL
pointer problem. Please rework this.
> +	m.apicid = mc_global->mc_apicid;

And this one too.

> +	for (i = 0; i < ncpus; i++) {
> +		if (g_physinfo[i].mc_apicid == m.apicid) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	WARN_ON(!found);

So... if we went through _all_ of the g_physinfo and
did not find the m.apicid, we would print a WARN_ON
and then here:
> +
> +	m.socketid = g_physinfo[i].mc_chipid;

we would use the last g_physinfo record. Shouldn't we just
abondon this instead and return from this function?

> +	m.cpu = m.extcpu = g_physinfo[i].mc_cpunr;
> +	m.cpuvendor = (__u8)g_physinfo[i].mc_vendor;

Why the casting?
> +	m.mcgcap = g_physinfo[i].mc_msrvalues[0].value;

Is it always going to 0? Should there be a define for the
entries in the array?

You ought to do this first:
	mic = NULL;

before calling this function. I know that the function does set
the *mic = NULL on entry but that is not obvious from this level
of the function. So either say it (one line comment) or just
do that 'mic = NULL'
> +	x86_mcinfo_lookup(&mic, mi, MC_TYPE_BANK);
> +	do {
> +		if (mic == NULL || mic->size == 0)
> +			break;
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
> +
> +	return 0;
> +}
> +
> +/*pv_ops domain mce virq handler, logging physical mce error info*/

Get rid of the 'pv_ops' domain please.

Can you expand this a bit. Say when this interrupt happens, how often
it can happen, and whether it can only be sent to priviliged domains.

> +static irqreturn_t mce_dom_interrupt(int irq, void *dev_id)
> +{
> +	xen_mc_t mc_op;
> +	int result = 0;

int err = 0;

> +
> +	mc_op.cmd = XEN_MC_fetch;
> +	mc_op.interface_version = XEN_MCA_INTERFACE_VERSION;
> +	set_xen_guest_handle(mc_op.u.mc_fetch.data, g_mi);
> +urgent:
> +	mc_op.u.mc_fetch.flags = XEN_MC_URGENT;
> +	result = HYPERVISOR_mca(&mc_op);
> +	if (result || mc_op.u.mc_fetch.flags & XEN_MC_NODATA ||
> +			mc_op.u.mc_fetch.flags & XEN_MC_FETCHFAILED)

Please fix the spacing. They should be aligned.
> +		goto nonurgent;
> +	else {
> +		result = convert_log(g_mi);
> +		if (result)
> +			goto end;
> +		/* After fetching the error event log entry from DOM0,
> +		 * we need to dec the refcnt and release the entry.
> +		 * The entry is reserved and inc refcnt when filling
> +		 * the error log entry.

Uh? Which refcnt? Where is the refcnt? Can you explain this in more
details please?
> +		 */
> +		mc_op.u.mc_fetch.flags = XEN_MC_URGENT | XEN_MC_ACK;
> +		result = HYPERVISOR_mca(&mc_op);
> +		goto urgent;

Eww, this is a while loop using goto statements.

Can you restructure this to be a while loop please?

> +	}
> +nonurgent:
> +	mc_op.u.mc_fetch.flags = XEN_MC_NONURGENT;
> +	result = HYPERVISOR_mca(&mc_op);
> +	if (result || mc_op.u.mc_fetch.flags & XEN_MC_NODATA ||
> +			mc_op.u.mc_fetch.flags & XEN_MC_FETCHFAILED)
> +		goto end;
> +	else {
> +		result = convert_log(g_mi);
> +		if (result)
> +			goto end;
> +		/* After fetching the error event log entry from DOM0,
> +		 * we need to dec the refcnt and release the entry. The
> +		 * entry is reserved and inc refcnt when filling the
> +		 * error log entry.
> +		 */
> +		mc_op.u.mc_fetch.flags = XEN_MC_NONURGENT | XEN_MC_ACK;
> +		result = HYPERVISOR_mca(&mc_op);
> +		goto nonurgent;

This is the same as the previous code. Can you squash these together?
You could use a state flag to figure out if you are doing the urgent
vs the non-urgent part now.

Or you can move this 'while loop' in its own function and just call
it with the different flags.

> +	}
> +end:
> +	return IRQ_HANDLED;
> +}
> +
> +static int bind_virq_for_mce(void)
> +{
> +	int ret;
> +	xen_mc_t mc_op;
> +
> +	g_mi = kmalloc(sizeof(struct mc_info), GFP_KERNEL);

Most of the time 'kzalloc' is used just in case you do not end
up filling all of the fields of the mc_op. And this is especially true
if you run with CONFIG_DEBUG_PAGEALLOC which will them with garbage
and you can get interesting results when you have forgotton to set them
all.

So if you are sure that _all_ the fields of the 'mc_op' have been filled
then you don't need kmalloc. But otherwise please use 'kzalloc'.
> +
> +	if (!g_mi)
> +		return -ENOMEM;
> +
> +	/* Fetch physical CPU Numbers */
> +	mc_op.cmd = XEN_MC_physcpuinfo;
> +	mc_op.interface_version = XEN_MCA_INTERFACE_VERSION;
> +	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
> +	ret = HYPERVISOR_mca(&mc_op);
> +	if (ret) {
> +		printk(KERN_ERR "MCE_DOM0_LOG: Fail to get physical CPU numbers\n");

..s/fail/failed.

Is the DOM0 part neccessary? The user knows he/she is running under xen
and what difference does it make it if its domU or dom0?

> +		kfree(g_mi);
> +		return ret;
> +	}
> +
> +	/* Fetch each CPU Physical Info for later reference*/
> +	ncpus = mc_op.u.mc_physcpuinfo.ncpus;
> +	g_physinfo = kmalloc(sizeof(struct mcinfo_logical_cpu)*ncpus,
> +					GFP_KERNEL);

Align the spacing please. And also put a space for the '*'
> +	if (!g_physinfo) {
> +		kfree(g_mi);
> +		return -ENOMEM;
> +	}
> +	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
> +	ret = HYPERVISOR_mca(&mc_op);
> +	if (ret) {
> +		printk(KERN_ERR "MCE_DOM0_LOG: Fail to get physical CPUs info\n");

Some comment about the dom0, fail for this.
> +		kfree(g_mi);
> +		kfree(g_physinfo);
> +		return ret;
> +	}
> +
> +	ret  = bind_virq_to_irqhandler(VIRQ_MCA, 0,
> +		mce_dom_interrupt, 0, "mce", NULL);
Please tab/space align this properly.
> +
> +	if (ret < 0) {
> +		printk(KERN_ERR "MCE_DOM0_LOG: bind_virq for DOM0 failed\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init mcelog_init(void)
> +{
> +	/* Only DOM0 is responsible for MCE logging */
> +	if (xen_initial_domain())
> +		return bind_virq_for_mce();
> +
> +	return 0;

return -ENODEV;

for the non-initial-domain case. Otherwise you end up loading this
module for nothing.
> +}
> +
> +
> +static void __exit mcelog_cleanup(void)
> +{
> +	kfree(g_mi);
> +	kfree(g_physinfo);
> +}
> +module_init(mcelog_init);
> +module_exit(mcelog_cleanup);
> +
> +MODULE_LICENSE("GPL");
> diff --git a/include/xen/interface/xen-mca.h b/include/xen/interface/xen-mca.h
> new file mode 100644
> index 0000000..f31fdab
> --- /dev/null
> +++ b/include/xen/interface/xen-mca.h
> @@ -0,0 +1,429 @@
> +/******************************************************************************
> + * arch-x86/mca.h
> + *
> + * Contributed by Advanced Micro Devices, Inc.
> + * Author: Christoph Egger <Christoph.Egger@amd.com>
> + *
> + * Guest OS machine check interface to x86 Xen.
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
> +/* Full MCA functionality has the following Usecases from the guest side:
> + *
> + * Must have's:
> + * 1. Dom0 and DomU register machine check trap callback handlers
> + *    (already done via "set_trap_table" hypercall)
> + * 2. Dom0 registers machine check event callback handler
> + *    (doable via EVTCHNOP_bind_virq)
> + * 3. Dom0 and DomU fetches machine check data

So the domU case is not covered here. is there another patch for that?
> + * 4. Dom0 wants Xen to notify a DomU
> + * 5. Dom0 gets DomU ID from physical address
> + * 6. Dom0 wants Xen to kill DomU (already done for "xm destroy")
> + *
> + * Nice to have's:
> + * 7. Dom0 wants Xen to deactivate a physical CPU
> + *    This is better done as separate task, physical CPU hotplugging,
> + *    and hypercall(s) should be sysctl's
> + * 8. Page migration proposed from Xen NUMA work, where Dom0 can tell Xen to
> + *    move a DomU (or Dom0 itself) away from a malicious page
> + *    producing correctable errors.
> + * 9. offlining physical page:
> + *    Xen free's and never re-uses a certain physical page.
> + * 10. Testfacility: Allow Dom0 to write values into machine check MSR's
> + *     and tell Xen to trigger a machine check
> + */
> +
> +#ifndef __XEN_PUBLIC_ARCH_X86_MCA_H__
> +#define __XEN_PUBLIC_ARCH_X86_MCA_H__
> +
> +/* Hypercall */
> +#define __HYPERVISOR_mca __HYPERVISOR_arch_0
> +
> +/*
> + * The xen-unstable repo has interface version 0x03000001; out interface
> + * is incompatible with that and any future minor revisions, so we
> + * choose a different version number range that is numerically less
> + * than that used in xen-unstable.

I don't understand that. Does it mean you can't use this with
xen-unstable? Or that it can't be used with 4.1? Can this be fixed
in the xen-unstable tree? Which xen-unstable tree? At what point was
this neccessary ? (include a c/s to denote _when_ so one has an idea if
this is truly true anymore).
> + */
> +#define XEN_MCA_INTERFACE_VERSION 0x01ecc003
> +
> +/* IN: Dom0 calls hypercall to retrieve nonurgent error log entry */
> +#define XEN_MC_NONURGENT  0x0001
> +/* IN: Dom0/DomU calls hypercall to retrieve urgent error log entry */
> +#define XEN_MC_URGENT     0x0002
> +/* IN: Dom0 acknowledges previosly-fetched error log entry */
> +#define XEN_MC_ACK        0x0004
> +
> +/* OUT: All is ok */
> +#define XEN_MC_OK           0x0
> +/* OUT: Domain could not fetch data. */
> +#define XEN_MC_FETCHFAILED  0x1
> +/* OUT: There was no machine check data to fetch. */
> +#define XEN_MC_NODATA       0x2
> +/* OUT: Between notification time and this hypercall an other
> + *  (most likely) correctable error happened. The fetched data,
> + *  does not match the original machine check data. */
> +#define XEN_MC_NOMATCH      0x4
> +
> +/* OUT: DomU did not register MC NMI handler. Try something else. */
> +#define XEN_MC_CANNOTHANDLE 0x8
> +/* OUT: Notifying DomU failed. Retry later or try something else. */
> +#define XEN_MC_NOTDELIVERED 0x10
> +/* Note, XEN_MC_CANNOTHANDLE and XEN_MC_NOTDELIVERED are mutually exclusive. */
> +
> +
> +#ifndef __ASSEMBLY__
> +
> +#define VIRQ_MCA VIRQ_ARCH_0 /* G. (DOM0) Machine Check Architecture */

What is the 'G.' for?
> +
> +/*
> + * Machine Check Architecure:
> + * structs are read-only and used to report all kinds of
> + * correctable and uncorrectable errors detected by the HW.
> + * Dom0 and DomU: register a handler to get notified.

Uhh. But your code does not do that? It only does it for the dom0 case?
Is this comment still valid?
> + * Dom0 only: Correctable errors are reported via VIRQ_MCA
> + */
> +#define MC_TYPE_GLOBAL          0

Can you describe what this means?
> +#define MC_TYPE_BANK            1

And this?
> +#define MC_TYPE_EXTENDED        2
And this?
> +#define MC_TYPE_RECOVERY        3

So are these Xen ABI specific or do they overlap with the Linux
idea of MC type checks? Please include that information in the
comment section.

> +
> +struct mcinfo_common {
> +	uint16_t type;      /* structure type */
> +	uint16_t size;      /* size of this struct in bytes */
> +};
> +
> +
> +#define MC_FLAG_CORRECTABLE     (1 << 0)
> +#define MC_FLAG_UNCORRECTABLE   (1 << 1)
> +#define MC_FLAG_RECOVERABLE	(1 << 2)
> +#define MC_FLAG_POLLED		(1 << 3)
> +#define MC_FLAG_RESET		(1 << 4)
> +#define MC_FLAG_CMCI		(1 << 5)
> +#define MC_FLAG_MCE		(1 << 6)

UGh, that looks out of alignemnt. Not sure if this my mailer or what but
please double check.
> +/* contains global x86 mc information */
> +struct mcinfo_global {
> +	struct mcinfo_common common;
> +
> +	/* running domain at the time in error (most likely
> +	 * the impacted one) */
> +	uint16_t mc_domid;
> +	uint16_t mc_vcpuid; /* virtual cpu scheduled for mc_domid */
> +	uint32_t mc_socketid; /* physical socket of the physical core */
> +	uint16_t mc_coreid; /* physical impacted core */
> +	uint16_t mc_core_threadid; /* core thread of physical core */
> +	uint32_t mc_apicid;
> +	uint32_t mc_flags;
> +	uint64_t mc_gstatus; /* global status */
> +};
> +
> +/* contains bank local x86 mc information */
> +struct mcinfo_bank {
> +	struct mcinfo_common common;
> +
> +	uint16_t mc_bank; /* bank nr */
> +	uint16_t mc_domid; /* Usecase 5: domain referenced by mc_addr on
> +			* privileged pv-ops dom and if mc_addr is valid.
> +			* Never valid on DomU. */
> +	uint64_t mc_status; /* bank status */
> +	uint64_t mc_addr;   /* bank address, only valid
> +					 * if addr bit is set in mc_status */

Please fix the spacing.
> +	uint64_t mc_misc;
> +	uint64_t mc_ctrl2;
> +	uint64_t mc_tsc;
> +};
> +
> +
> +struct mcinfo_msr {
> +	uint64_t reg;   /* MSR */
> +	uint64_t value; /* MSR value */
> +};
> +
> +/* contains mc information from other
> + * or additional mc MSRs */
> +struct mcinfo_extended {
> +	struct mcinfo_common common;
> +
> +	/* You can fill up to five registers.
> +	 * If you need more, then use this structure
> +	 * multiple times. */
> +
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
> +/* Different Recovery Action types, if the action is performed successfully,
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
> +/* Below interface used between XEN/DOM0 for passing XEN's recovery action
> + * information to DOM0.
> + * usage Senario: After offlining broken page, XEN might pass its page offline
> + * recovery action result to DOM0. DOM0 will save the information in
> + * non-volatile memory for further proactive actions, such as offlining the
> + * easy broken page earlier when doing next reboot.

Can you rewrite the last paragraph please. It is not clear what you
mean.
> +*/
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
> +	/* Recovery Action Flags defined above such as REC_ACTION_DONE */
> +	uint8_t action_flags;
> +	/* Recovery Action types defined above such as MC_ACTION_PAGE_OFFLINE */
> +	uint8_t action_types;
> +	/* In future if more than one recovery action permitted per error bank,
> +	 * a mcinfo_recovery data array will be returned
> +	 */
> +	union {
> +		struct page_offline_action page_retire;
> +		struct cpu_offline_action cpu_offline;
> +		uint8_t pad[MAX_UNION_SIZE];
> +	} action_info;
> +};
> +
> +
> +#define MCINFO_HYPERCALLSIZE	1024
> +#define MCINFO_MAXSIZE		768
> +
> +struct mc_info {
> +	/* Number of mcinfo_* entries in mi_data */
> +	uint32_t mi_nentries;
> +	uint32_t _pad0;
> +	uint64_t mi_data[(MCINFO_MAXSIZE - 1) / 8];
> +};
> +typedef struct mc_info mc_info_t;
> +DEFINE_GUEST_HANDLE_STRUCT(mc_info);
> +
> +#define __MC_MSR_ARRAYSIZE 8
> +#define __MC_NMSRS 1
> +#define MC_NCAPS	7	/* 7 CPU feature flag words */
> +#define MC_CAPS_STD_EDX	0	/* cpuid level 0x00000001 (%edx) */
> +#define MC_CAPS_AMD_EDX	1	/* cpuid level 0x80000001 (%edx) */
> +#define MC_CAPS_TM	2	/* cpuid level 0x80860001 (TransMeta) */
> +#define MC_CAPS_LINUX	3	/* Linux-defined */
> +#define MC_CAPS_STD_ECX	4	/* cpuid level 0x00000001 (%ecx) */
> +#define MC_CAPS_VIA	5	/* cpuid level 0xc0000001 */
> +#define MC_CAPS_AMD_ECX	6	/* cpuid level 0x80000001 (%ecx) */
> +
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
> +	int32_t mc_cpuid_level;

This looks odd? Can you explain why it is int32 instead of uint32?

> +	uint32_t mc_family;
> +	uint32_t mc_vendor;
> +	uint32_t mc_model;
> +	uint32_t mc_step;
> +	char mc_vendorid[16];
> +	char mc_brandid[64];
> +	uint32_t mc_cpu_caps[MC_NCAPS];
> +	uint32_t mc_cache_size;
> +	uint32_t mc_cache_alignment;
> +	int32_t mc_nmsrvals;

Ditto.
> +	struct mcinfo_msr mc_msrvalues[__MC_MSR_ARRAYSIZE];
> +};
> +typedef struct mcinfo_logical_cpu mcinfo_logical_cpu_t;

No typedefs.
> +DEFINE_GUEST_HANDLE_STRUCT(mcinfo_logical_cpu);
> +
> +
> +/*
> + * OS's should use these instead of writing their own lookup function
> + * each with its own bugs and drawbacks.

What are the drawbacks?
> + * We use macros instead of static inline functions to allow guests
> + * to include this header in assembly files (*.S).
> + */
> +/* Prototype:
> + *    uint32_t x86_mcinfo_nentries(struct mc_info *mi);
> + */
> +#define x86_mcinfo_nentries(_mi)    \
> +    ((_mi)->mi_nentries)
> +/* Prototype:
> + *    struct mcinfo_common *x86_mcinfo_first(struct mc_info *mi);
> + */
> +#define x86_mcinfo_first(_mi)       \
> +    ((struct mcinfo_common *)(_mi)->mi_data)
> +/* Prototype:
> + *    struct mcinfo_common *x86_mcinfo_next(struct mcinfo_common *mic);
> + */
> +#define x86_mcinfo_next(_mic)       \
> +    ((struct mcinfo_common *)((uint8_t *)(_mic) + (_mic)->size))
> +
> +/* Prototype:
> + *    void x86_mcinfo_lookup(void *ret, struct mc_info *mi, uint16_t type);
> + */
> +
> +static inline void x86_mcinfo_lookup
> +	(struct mcinfo_common **ret, struct mc_info *mi, uint16_t type)

Fix the argument list. It should be something like this:
static inline void x86_mcinfo_lookup(struct mcinfo_common *ret,
				     struct mc_info *mi, ...

> +{
> +	uint32_t found = 0, i;

Make found be a 'bool' please.

> +	struct mcinfo_common *mic;
> +
> +	*ret = NULL;

Check if ret is NULL first. Like:

	if (!ret)
		return

> +	if (!mi)
> +		return;

or you can merge them both together:
	if (!mi || !ret)
		return;
> +	mic = x86_mcinfo_first(mi);
> +
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
> +/* Usecase 1
> + * Register machine check trap callback handler
> + *    (already done via "set_trap_table" hypercall)
> + */
> +
> +/* Usecase 2
> + * Dom0 registers machine check event callback handler
> + * done by EVTCHNOP_bind_virq
> + */
> +
> +/* Usecase 3
> + * Fetch machine check data from hypervisor.
> + * Note, this hypercall is special, because both Dom0 and DomU must use this.
> + */
> +#define XEN_MC_fetch            1
> +struct xen_mc_fetch {
> +    /* IN/OUT variables.
> +	 * IN: XEN_MC_NONURGENT, XEN_MC_URGENT,
> +	 * XEN_MC_ACK if ack'king an earlier fetch
> +	 * OUT: XEN_MC_OK, XEN_MC_FETCHAILED,
> +	 * XEN_MC_NODATA, XEN_MC_NOMATCH
> +	*/
> +	uint32_t flags;
> +	uint32_t _pad0;
> +	/* OUT: id for ack, IN: id we are ack'ing */
> +	uint64_t fetch_id;
> +
> +	/* OUT variables. */
> +	GUEST_HANDLE(mc_info) data;
> +};
> +typedef struct xen_mc_fetch xen_mc_fetch_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xen_mc_fetch);
> +
> +
> +/* Usecase 4
> + * This tells the hypervisor to notify a DomU about the machine check error
> + */
> +#define XEN_MC_notifydomain     2
> +struct xen_mc_notifydomain {
> +	/* IN variables. */
> +	uint16_t mc_domid;/* The unprivileged domain to notify. */
> +	uint16_t mc_vcpuid;/* The vcpu in mc_domid to notify.
> +			* Usually echo'd value from the fetch hypercall. */
> +
> +	/* IN/OUT variables. */
> +	uint32_t flags;
> +
> +/* OUT: XEN_MC_OK, XEN_MC_CANNOTHANDLE, XEN_MC_NOTDELIVERED, XEN_MC_NOMATCH */
> +};
> +typedef struct xen_mc_notifydomain xen_mc_notifydomain_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xen_mc_notifydomain);
> +
> +#define XEN_MC_physcpuinfo 3
> +struct xen_mc_physcpuinfo {
> +	/* IN/OUT */
> +	uint32_t ncpus;
> +	uint32_t _pad0;
> +	/* OUT */
> +	GUEST_HANDLE(mcinfo_logical_cpu) info;
> +};
> +
> +#define XEN_MC_msrinject    4
> +#define MC_MSRINJ_MAXMSRS       8

These are a bit out of sync. Can you make them on aligned please.
> +struct xen_mc_msrinject {
> +	/* IN */
> +	uint32_t mcinj_cpunr;/* target processor id */
> +	uint32_t mcinj_flags;/* see MC_MSRINJ_F_* below */
> +	uint32_t mcinj_count;/* 0 .. count-1 in array are valid */
> +	uint32_t _pad0;
> +	struct mcinfo_msr mcinj_msr[MC_MSRINJ_MAXMSRS];
> +};
> +
> +/* Flags for mcinj_flags above; bits 16-31 are reserved */
> +#define MC_MSRINJ_F_INTERPOSE   0x1
> +
> +#define XEN_MC_mceinject    5

And these as well.
> +struct xen_mc_mceinject {
> +	unsigned int mceinj_cpunr;      /* target processor id */
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
> +typedef struct xen_mc xen_mc_t;

Ugh. No typedefs. Please rework this to get rid of that.
> +DEFINE_GUEST_HANDLE_STRUCT(xen_mc);
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* __XEN_PUBLIC_ARCH_X86_MCA_H__ */
> -- 
> 1.6.5.6


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

