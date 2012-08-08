Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544Ab2HHSFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:05:54 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29253 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030496Ab2HHSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:05:52 -0400
X-IronPort-AV: E=Sophos;i="4.77,734,1336348800"; 
   d="scan'208";a="13915802"
Date: Wed, 8 Aug 2012 19:05:26 +0100
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
Subject: Re: [PATCH v2 15/23] xen/arm: receive Xen events on ARM
In-Reply-To: <20120807183036.GR15053@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208081826190.21096@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com> <1344263246-28036-15-git-send-email-stefano.stabellini@eu.citrix.com> <20120807183036.GR15053@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Aug 06, 2012 at 03:27:18PM +0100, Stefano Stabellini wrote:
> > Compile events.c on ARM.
> > Parse, map and enable the IRQ to get event notifications from the device
> > tree (node "/xen").
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/include/asm/xen/events.h |   18 ++++++++++++++++++
> >  arch/arm/xen/enlighten.c          |   33 +++++++++++++++++++++++++++++++++
> >  arch/x86/xen/enlighten.c          |    1 +
> >  arch/x86/xen/irq.c                |    1 +
> >  arch/x86/xen/xen-ops.h            |    1 -
> >  drivers/xen/events.c              |   17 ++++++++++++++---
> >  include/xen/events.h              |    2 ++
> >  7 files changed, 69 insertions(+), 4 deletions(-)
> >  create mode 100644 arch/arm/include/asm/xen/events.h
> > 
> > diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
> > new file mode 100644
> > index 0000000..94b4e90
> > --- /dev/null
> > +++ b/arch/arm/include/asm/xen/events.h
> > @@ -0,0 +1,18 @@
> > +#ifndef _ASM_ARM_XEN_EVENTS_H
> > +#define _ASM_ARM_XEN_EVENTS_H
> > +
> > +#include <asm/ptrace.h>
> > +
> > +enum ipi_vector {
> > +	XEN_PLACEHOLDER_VECTOR,
> > +
> > +	/* Xen IPIs go here */
> > +	XEN_NR_IPIS,
> > +};
> > +
> > +static inline int xen_irqs_disabled(struct pt_regs *regs)
> > +{
> > +	return raw_irqs_disabled_flags(regs->ARM_cpsr);
> > +}
> > +
> > +#endif /* _ASM_ARM_XEN_EVENTS_H */
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index e5e92d5..87b17f0 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -1,4 +1,5 @@
> >  #include <xen/xen.h>
> > +#include <xen/events.h>
> >  #include <xen/grant_table.h>
> >  #include <xen/hvm.h>
> >  #include <xen/interface/xen.h>
> > @@ -9,6 +10,8 @@
> >  #include <xen/xenbus.h>
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/xen/hypercall.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/irqreturn.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_irq.h>
> > @@ -33,6 +36,8 @@ EXPORT_SYMBOL_GPL(xen_have_vector_callback);
> >  int xen_platform_pci_unplug = XEN_UNPLUG_ALL;
> >  EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
> >  
> > +static __read_mostly int xen_events_irq = -1;
> > +
> 
> So this is global..
> >  int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
> >  			       unsigned long addr,
> >  			       unsigned long mfn, int nr,
> > @@ -66,6 +71,9 @@ static int __init xen_guest_init(void)
> >  	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
> >  		return 0;
> >  	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
> > +	xen_events_irq = irq_of_parse_and_map(node, 0);
> > +	pr_info("Xen support found, events_irq=%d gnttab_frame_pfn=%lx\n",
> > +			xen_events_irq, xen_hvm_resume_frames);
> >  	xen_domain_type = XEN_HVM_DOMAIN;
> >  
> >  	xen_setup_features();
> > @@ -107,3 +115,28 @@ static int __init xen_guest_init(void)
> >  	return 0;
> >  }
> >  core_initcall(xen_guest_init);
> > +
> > +static irqreturn_t xen_arm_callback(int irq, void *arg)
> > +{
> > +	xen_hvm_evtchn_do_upcall();
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int __init xen_init_events(void)
> > +{
> > +	if (!xen_domain() || xen_events_irq < 0)
> > +		return -ENODEV;
> > +
> > +	xen_init_IRQ();
> > +
> > +	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
> > +			"events", xen_vcpu)) {
> 
> But here you are asking for it to be percpu? What if there are other
> interrupts on the _other_ CPUs that conflict with it?
> > +		pr_err("Error requesting IRQ %d\n", xen_events_irq);
> > +		return -EINVAL;
> > +	}
> > +
> > +	enable_percpu_irq(xen_events_irq, 0);
> 
> Uh, that is bold. One global to rule them all, eh? Should you make
> it at least:
> static DEFINE_PER_CPU(int, xen_events_irq);
> ?

That is an interesting observation.

Currently Xen is using a per-cpu interrupt (a PPI, using the GIC
terminology), and it makes sense so that we can receive event
notifications on multiple vcpus independently.
The irq range 16-31 is reserved for PPIs and I am assuming that Xen will
be able to find one spare, the same one, for all vcpus.
In fact the third field corresponding to the interrupt in the DT (0xf08
in my dts) contains the cpu mask and it is set to 0xf (the maximum)
right now.

Maybe I should just BUG_ON(xen_events_irq > 31 || xen_events_irq < 16)?

The versioning of the hypervisor node on the DT is going to help us make
any changes to the interface in the future.
