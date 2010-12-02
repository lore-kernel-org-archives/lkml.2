Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab0LBNzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:55:05 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43834 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab0LBNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:55:04 -0500
X-IronPort-AV: E=Sophos;i="4.59,288,1288569600"; 
   d="scan'208";a="3154671"
Date: Thu, 2 Dec 2010 13:54:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Keir Fraser <Keir.Fraser@eu.citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH] xen: HVM X2APIC support
In-Reply-To: <201012021433.46976.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1012021319240.14723@kaball-desktop>
References: <1291258990-16080-1-git-send-email-sheng@linux.intel.com> <4CF73C80.4000101@goop.org> <201012021433.46976.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Sheng Yang wrote:
> On Thursday 02 December 2010 14:28:16 Jeremy Fitzhardinge wrote:
> > On 12/01/2010 07:03 PM, Sheng Yang wrote:
> > > This patch is similiar to Gleb Natapov's patch for KVM, which enable the
> > > hypervisor to emulate x2apic feature for the guest. By this way, the
> > > emulation of lapic would be simpler with x2apic interface(MSR), and
> > > faster.
> > 
> > We have a set of patches to directly use event channels from within hvm
> > domains, completely bypassing the apic altogether.  Do we need this as
> > well?
> 
> This is for other HVMs. And the pvhvm still have limitation like it can't use 
> MSI/MSI-X assigned device.

That is not true: upstream Linux kernels can remap MSI/MSI-X into pirqs,
if it doesn't work is a bug :)
If you are interested give a look at arch/x86/pci/xen.c:xen_hvm_setup_msi_irqs.

> 
> > 
> > > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> > > ---
> > > 
> > >  arch/x86/include/asm/xen/hypervisor.h |   33
> > >  +++++++++++++++++++++++++++++++++ arch/x86/kernel/apic/apic.c          
> > >  |    4 +++-
> > >  arch/x86/xen/enlighten.c              |   19 -------------------
> > >  3 files changed, 36 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/xen/hypervisor.h
> > > b/arch/x86/include/asm/xen/hypervisor.h index 396ff4c..e862874 100644
> > > --- a/arch/x86/include/asm/xen/hypervisor.h
> > > +++ b/arch/x86/include/asm/xen/hypervisor.h
> > > @@ -37,4 +37,37 @@
> > > 
> > >  extern struct shared_info *HYPERVISOR_shared_info;
> > >  extern struct start_info *xen_start_info;
> > > 
> > > +#include <asm/processor.h>
> > > +
> > > +static inline uint32_t xen_cpuid_base(void)
> > > +{
> > > +	uint32_t base, eax, ebx, ecx, edx;
> > > +	char signature[13];
> > > +
> > > +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> > > +		cpuid(base, &eax, &ebx, &ecx, &edx);
> > > +		*(uint32_t *)(signature + 0) = ebx;
> > > +		*(uint32_t *)(signature + 4) = ecx;
> > > +		*(uint32_t *)(signature + 8) = edx;
> > > +		signature[12] = 0;
> > > +
> > > +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> > > +			return base;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +#ifdef CONFIG_XEN
> > > +static inline bool xen_para_available(void)
> > > +{
> > > +	return 0;
> > > +}
> > > +#else
> > > +static inline bool xen_para_available(void)
> > > +{
> > > +	return (xen_cpuid_base() != 0);
> > > +}
> > > +#endif
> > 
> > So this returns true if you're running a kernel without CONFIG_XEN under
> > Xen?  Does that assume that all versions of Xen implement x2apic
> > emulation?  Why wouldn't we also want this for CONFIG_XEN kernels?
> 
> Because only the ones that implement the feature would expose x2apic CPUID.
> 
> For CONFIG_XEN(pv or pvhvm), they both use evtchn, so no need for x2apic.

In that case you need to check for CONFIG_XEN_PVHVM and the presence of
xen_feature(XENFEAT_hvm_pirqs) because only in this case a PV on HVM
guests are able to remap both GSIs and MSIs into evtchns.
So I would do something like this:


#ifdef CONFIG_XEN_PVHVM
static inline bool xen_para_available(void)
{
    if (xen_cpuid_base() != 0 && xen_feature(XENFEAT_hvm_pirqs))
    	return 0;
    else
        return 1;
}
#else
static inline bool xen_para_available(void)
{
	return (xen_cpuid_base() != 0);
}
#endif


This is assuming that enabling x2apic doesn't prevent Linux from
receiving evtchns either using the callback vector mechanism or the
legacy platform-pci interrupt.
Finally when running as dom0 would this feature create problems in the
presence of a real x2apic?

