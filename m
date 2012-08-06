Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2HFKba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:31:30 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:59495 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2HFKb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:31:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,718,1336348800"; 
   d="scan'208";a="13863086"
Date: Mon, 6 Aug 2012 11:31:04 +0100
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
Subject: Re: [PATCH 15/24] xen/arm: receive Xen events on ARM
In-Reply-To: <20120801144418.GM7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208061127440.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-15-git-send-email-stefano.stabellini@eu.citrix.com> <20120801144418.GM7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:33:57PM +0100, Stefano Stabellini wrote:
> > Compile events.c on ARM.
> > Parse, map and enable the IRQ to get event notifications from the device
> > tree (node "/xen").
> > 
> > On ARM Linux irqs are not enabled by default:
> > 
> > - call enable_percpu_irq for xen_events_irq (drivers are supposed
> > to call enable_irq after request_irq);
> > 
> > - reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
> > default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
> > irq_startup, that is responsible for calling irq_unmask at startup time.
> > As a result event channels remain masked.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/xen/enlighten.c |   33 +++++++++++++++++++++++++++++++++
> >  arch/x86/xen/enlighten.c |    1 +
> >  arch/x86/xen/irq.c       |    1 +
> >  arch/x86/xen/xen-ops.h   |    1 -
> >  drivers/xen/events.c     |   18 +++++++++++++++---
> >  include/xen/events.h     |    2 ++
> >  6 files changed, 52 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index 854af1e..60d6d36 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -7,8 +7,11 @@
> >  #include <xen/grant_table.h>
> >  #include <xen/hvm.h>
> >  #include <xen/xenbus.h>
> > +#include <xen/events.h>
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
> >  int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
> >  			       unsigned long addr,
> >  			       unsigned long mfn, int nr,
> > @@ -65,6 +70,9 @@ int __init xen_guest_init(void)
> >  	if (of_address_to_resource(node, 0, &res))
> >  		return -EINVAL;
> >  	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
> > +	xen_events_irq = irq_of_parse_and_map(node, 0);
> > +	pr_info("Xen support found, events_irq=%d gnttab_frame_pfn=%lx\n",
> > +			xen_events_irq, xen_hvm_resume_frames);
> >  	xen_domain_type = XEN_HVM_DOMAIN;
> >  
> >  	xen_setup_features();
> > @@ -114,3 +122,28 @@ int __init xen_guest_init(void)
> >  }
> >  EXPORT_SYMBOL_GPL(xen_guest_init);
> >  core_initcall(xen_guest_init);
> > +
> > +static irqreturn_t xen_arm_callback(int irq, void *arg)
> > +{
> > +	xen_hvm_evtchn_do_upcall();
> > +	return 0;
> 
> Um, IRQ_HANDLED?

Yep


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
> > +		pr_err("Error requesting IRQ %d\n", xen_events_irq);
> > +		return -EINVAL;
> > +	}
> > +
> > +	enable_percpu_irq(xen_events_irq, 0);
> > +
> > +	return 0;
> > +}
> > +postcore_initcall(xen_init_events);
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 6131d43..5a30502 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/memblock.h>
> >  
> >  #include <xen/xen.h>
> > +#include <xen/events.h>
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/version.h>
> >  #include <xen/interface/physdev.h>
> > diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> > index 1573376..01a4dc0 100644
> > --- a/arch/x86/xen/irq.c
> > +++ b/arch/x86/xen/irq.c
> > @@ -5,6 +5,7 @@
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/sched.h>
> >  #include <xen/interface/vcpu.h>
> > +#include <xen/events.h>
> >  
> >  #include <asm/xen/hypercall.h>
> >  #include <asm/xen/hypervisor.h>
> > diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> > index 202d4c1..2368295 100644
> > --- a/arch/x86/xen/xen-ops.h
> > +++ b/arch/x86/xen/xen-ops.h
> > @@ -35,7 +35,6 @@ void xen_set_pat(u64);
> >  
> >  char * __init xen_memory_setup(void);
> >  void __init xen_arch_setup(void);
> > -void __init xen_init_IRQ(void);
> >  void xen_enable_sysenter(void);
> >  void xen_enable_syscall(void);
> >  void xen_vcpu_restore(void);
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 7da65d3..9b506b2 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -31,14 +31,16 @@
> >  #include <linux/irqnr.h>
> >  #include <linux/pci.h>
> >  
> > +#ifdef CONFIG_X86
> >  #include <asm/desc.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/irq.h>
> >  #include <asm/idle.h>
> >  #include <asm/io_apic.h>
> > -#include <asm/sync_bitops.h>
> >  #include <asm/xen/page.h>
> >  #include <asm/xen/pci.h>
> > +#endif
> > +#include <asm/sync_bitops.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <asm/xen/hypervisor.h>
> >  
> > @@ -50,6 +52,9 @@
> >  #include <xen/interface/event_channel.h>
> >  #include <xen/interface/hvm/hvm_op.h>
> >  #include <xen/interface/hvm/params.h>
> > +#include <xen/interface/physdev.h>
> > +#include <xen/interface/sched.h>
> > +#include <asm/hw_irq.h>
> >  
> >  /*
> >   * This lock protects updates to the following mapping and reference-count
> > @@ -834,6 +839,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
> >  		struct irq_info *info = info_for_irq(irq);
> >  		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
> >  	}
> > +	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
> 
> I feel that this should be its own commit by itself. I am not certain
> of the implication of this on x86 and I think it deserves some explanation.

OK. It shouldn't have any effects on x86, considering that both
IRQ_NOREQUEST and IRQ_NOAUTOEN are not set there.


> >  
> >  out:
> >  	mutex_unlock(&irq_mapping_update_lock);
> > @@ -1377,7 +1383,9 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
> >  {
> >  	struct pt_regs *old_regs = set_irq_regs(regs);
> >  
> > +#ifdef CONFIG_X86
> >  	exit_idle();
> > +#endif
> 
> Doesn't exist? Or is that it does not need it?

It does not exist.

