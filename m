Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab0FGOjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 10:39:40 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:38239 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0FGOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 10:39:39 -0400
X-IronPort-AV: E=Sophos;i="4.53,378,1272844800"; 
   d="scan'208";a="278804"
Date: Mon, 7 Jun 2010 15:38:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 02/12] early PV on HVM
In-Reply-To: <20100604202008.GB17645@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006071518050.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com> <20100604202008.GB17645@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Konrad Rzeszutek Wilk wrote:
> On Thu, Jun 03, 2010 at 02:10:35PM +0100, stefano.stabellini@eu.citrix.com wrote:
> > From: Sheng Yang <sheng@linux.intel.com>
> > 
> > Initialize basic pv on hvm features in xen_guest_init.
> > 
> > The hook in arch/x86/kernel/setup.c can easily be removed using the new
> > generic hypervisor independent initialization infrastructure present in
> > the linux-2.6-tip tree.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> > Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
> > ---
> >  arch/x86/kernel/setup.c           |    2 +
> >  arch/x86/xen/enlighten.c          |   86 +++++++++++++++++++++++++++++++++++++
> >  drivers/input/xen-kbdfront.c      |    2 +-
> >  drivers/video/xen-fbfront.c       |    2 +-
> >  drivers/xen/xenbus/xenbus_probe.c |   21 ++++++++-
> >  include/xen/xen.h                 |    2 +
> >  6 files changed, 110 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index c4851ef..ae9b6cb 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -69,6 +69,7 @@
> >  #include <linux/tboot.h>
> >  
> >  #include <video/edid.h>
> > +#include <xen/xen.h>
> >  
> >  #include <asm/mtrr.h>
> >  #include <asm/apic.h>
> > @@ -1032,6 +1033,7 @@ void __init setup_arch(char **cmdline_p)
> >  	probe_nr_irqs_gsi();
> >  
> >  	kvm_guest_init();
> > +	xen_guest_init();
> >  
> >  	e820_reserve_resources();
> >  	e820_mark_nosave_regions(max_low_pfn);
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 65d8d79..c1f6545 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -35,6 +35,7 @@
> >  #include <xen/interface/version.h>
> >  #include <xen/interface/physdev.h>
> >  #include <xen/interface/vcpu.h>
> > +#include <xen/interface/memory.h>
> >  #include <xen/features.h>
> >  #include <xen/page.h>
> >  #include <xen/hvc-console.h>
> > @@ -56,6 +57,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <asm/reboot.h>
> >  #include <asm/stackprotector.h>
> > +#include <asm/hypervisor.h>
> >  
> >  #include "xen-ops.h"
> >  #include "mmu.h"
> > @@ -1206,3 +1208,87 @@ asmlinkage void __init xen_start_kernel(void)
> >  	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
> >  #endif
> >  }
> > +
> > +static uint32_t xen_cpuid_base(void)
> > +{
> > +	uint32_t base, eax, ebx, ecx, edx;
> > +	char signature[13];
> > +
> > +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> > +		cpuid(base, &eax, &ebx, &ecx, &edx);
> > +		*(uint32_t*)(signature + 0) = ebx;
> > +		*(uint32_t*)(signature + 4) = ecx;
> > +		*(uint32_t*)(signature + 8) = edx;
> > +		signature[12] = 0;
> > +
> > +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> > +			return base;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int init_hvm_pv_info(int *major, int *minor)
> > +{
> > +	uint32_t eax, ebx, ecx, edx, pages, msr, base;
> > +	u64 pfn;
> > +
> > +	base = xen_cpuid_base();
> > +	if (!base)
> > +		return -EINVAL;
> > +
> > +	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
> > +
> > +	*major = eax >> 16;
> > +	*minor = eax & 0xffff;
> > +	printk(KERN_INFO "Xen version %d.%d.\n", *major, *minor);
> > +
> > +	cpuid(base + 2, &pages, &msr, &ecx, &edx);
> > +
> > +	pfn = __pa(hypercall_page);
> > +	wrmsr_safe(msr, (u32)pfn, (u32)(pfn >> 32));
> > +
> > +	xen_setup_features();
> > +
> > +	pv_info = xen_info;
> > +	pv_info.kernel_rpl = 0;
> > +
> > +	xen_domain_type = XEN_HVM_DOMAIN;
> > +
> > +	return 0;
> > +}
> > +
> > +static void __init init_shared_info(void)
> > +{
> > +	struct xen_add_to_physmap xatp;
> > +	struct shared_info *shared_info_page;
> > +
> > +	shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
> > +	xatp.domid = DOMID_SELF;
> > +	xatp.idx = 0;
> > +	xatp.space = XENMAPSPACE_shared_info;
> > +	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
> > +	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
> > +		BUG();
> > +
> > +	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> > +
> > +	/* Don't do the full vcpu_info placement stuff until we have a
> > +	   possible map and a non-dummy shared_info. */
> 
> Might want to mention where the full vpcu placement is done.

The comment is not accurate, we actually don't do any vcpu_info
placement on hvm because it is not very useful there.
Better just to remove the comment (I have done so in my tree).

> > +	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> 
> Otherwise looks good to me. In other words, Reviewed-by: Konrad
> Rzeszutek Wilk <konrad.wilk@oracle.com>
> 

thanks!

