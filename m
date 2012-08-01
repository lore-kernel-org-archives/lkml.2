Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2HAPqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:46:01 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:65199 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2HAPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:45:59 -0400
X-IronPort-AV: E=Sophos;i="4.77,694,1336348800"; 
   d="scan'208";a="13807298"
Date: Wed, 1 Aug 2012 16:45:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 07/24] xen/arm: Xen detection and shared_info page
 mapping
In-Reply-To: <20120801141959.GE7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011641410.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-7-git-send-email-stefano.stabellini@eu.citrix.com> <20120801141959.GE7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:33:49PM +0100, Stefano Stabellini wrote:
> > Check for a "/xen" node in the device tree, if it is present set
> > xen_domain_type to XEN_HVM_DOMAIN and continue initialization.
> > 
> > Map the real shared info page using XENMEM_add_to_physmap with
> > XENMAPSPACE_shared_info.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/xen/enlighten.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 56 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index d27c2a6..8c923af 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -5,6 +5,9 @@
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/of_address.h>
> >  
> >  struct start_info _xen_start_info;
> >  struct start_info *xen_start_info = &_xen_start_info;
> > @@ -33,3 +36,56 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
> >  	return -ENOSYS;
> >  }
> >  EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
> > +
> > +/*
> > + * == Xen Device Tree format ==
> > + * - /xen node;
> > + * - compatible "arm,xen";
> > + * - one interrupt for Xen event notifications;
> > + * - one memory region to map the grant_table.
> > + */
> > +static int __init xen_guest_init(void)
> > +{
> > +	int cpu;
> > +	struct xen_add_to_physmap xatp;
> > +	static struct shared_info *shared_info_page = 0;
> > +	struct device_node *node;
> > +
> > +	node = of_find_compatible_node(NULL, NULL, "arm,xen");
> > +	if (!node) {
> > +		pr_info("No Xen support\n");
> 
> I don't think the pr_info is appropiate here?

Yes, you are right. In fact I had already turned it into a pr_debug.

> > +		return 0;
> 
> Should this be -ENODEV?

Considering that xen_guest_init is called by a core_initcall, I didn't
want to return an error just because Xen is not present on the platform.


> > +	}
> > +	xen_domain_type = XEN_HVM_DOMAIN;
> > +
> > +	if (!shared_info_page)
> > +		shared_info_page = (struct shared_info *)
> > +			get_zeroed_page(GFP_KERNEL);
> > +	if (!shared_info_page) {
> > +		pr_err("not enough memory");
> 
> \n

OK

> > +		return -ENOMEM;
> > +	}
> > +	xatp.domid = DOMID_SELF;
> > +	xatp.idx = 0;
> > +	xatp.space = XENMAPSPACE_shared_info;
> > +	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
> > +	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
> > +		BUG();
> > +
> > +	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> > +
> > +	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
> > +	 * page, we use it in the event channel upcall and in some pvclock
> > +	 * related functions. We don't need the vcpu_info placement
> > +	 * optimizations because we don't use any pv_mmu or pv_irq op on
> > +	 * HVM.
> > +	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
> > +	 * online but xen_hvm_init_shared_info is run at resume time too and
> > +	 * in that case multiple vcpus might be online. */
> > +	for_each_online_cpu(cpu) {
> > +		per_cpu(xen_vcpu, cpu) =
> > +			&HYPERVISOR_shared_info->vcpu_info[cpu];
> > +	}
> > +	return 0;
> 
> This above looks stringly similar to the x86 one. Could it be
> abstracted away to share the same code? Or is that something that
> ought to be done later on when there is more meat on the bone?

Actually I had to remove these three lines because on ARM we are going
to have just one vcpu_info struct in the shared_info page and then rely
on VCPUOP_register_vcpu_info.
