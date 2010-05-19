Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044Ab0ESNE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:04:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:26575 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0ESNEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:04:55 -0400
X-IronPort-AV: E=Sophos;i="4.53,263,1272859200"; 
   d="scan'208";a="8588603"
Date: Wed, 19 May 2010 14:08:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 03/12] evtchn delivery on HVM
In-Reply-To: <4BF2D828.60602@goop.org>
Message-ID: <alpine.DEB.2.00.1005191402030.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-3-git-send-email-stefano.stabellini@eu.citrix.com> <4BF2D828.60602@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Jeremy Fitzhardinge wrote:
> On 05/18/2010 03:22 AM, Stefano Stabellini wrote:
> > From: Sheng Yang <sheng@linux.intel.com>
> >
> > Set the callback to receive evtchns from Xen, using the
> > callback vector delivery mechanism.
> >
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> > ---
> >  arch/x86/xen/enlighten.c         |   35 +++++++++++++++++++++++++++++++++++
> >  drivers/xen/events.c             |   31 ++++++++++++++++++++++++-------
> >  include/xen/events.h             |    3 +++
> >  include/xen/hvm.h                |    9 +++++++++
> >  include/xen/interface/features.h |    3 +++
> >  5 files changed, 74 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 87a3b10..502c4f8 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -37,8 +37,11 @@
> >  #include <xen/interface/vcpu.h>
> >  #include <xen/interface/memory.h>
> >  #include <xen/interface/hvm/hvm_op.h>
> > +#include <xen/interface/hvm/params.h>
> >  #include <xen/features.h>
> >  #include <xen/page.h>
> > +#include <xen/hvm.h>
> > +#include <xen/events.h>
> >  #include <xen/hvc-console.h>
> >  
> >  #include <asm/paravirt.h>
> > @@ -79,6 +82,8 @@ struct shared_info xen_dummy_shared_info;
> >  
> >  void *xen_initial_gdt;
> >  
> > +int xen_have_vector_callback;
> > +
> >  /*
> >   * Point at some empty memory to start with. We map the real shared_info
> >   * page as soon as fixmap is up and running.
> > @@ -1279,6 +1284,31 @@ static void __init init_shared_info(void)
> >  	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> >  }
> >  
> > +int xen_set_callback_via(uint64_t via)
> > +{
> > +	struct xen_hvm_param a;
> > +	a.domid = DOMID_SELF;
> > +	a.index = HVM_PARAM_CALLBACK_IRQ;
> > +	a.value = via;
> > +	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
> >   
> 
> Does this implicitly set the vector delivery on all vcpus, current and
> future?
> 

Yes.

> > +}
> > +
> > +void do_hvm_pv_evtchn_intr(void)
> > +{
> > +	xen_hvm_evtchn_do_upcall(get_irq_regs());
> > +}
> > +
> > +static void xen_callback_vector(void)
> >   
> 
> All this callback vector stuff should be in drivers/xen/events.c.  It
> would also be good to give it a more descriptive name
> ("xen_set_callback_vector"?), and make it an init function.
> 

I could move it events.c and call it at the beginning of xen_init_IRQ,
is that OK?


> > +{
> > +	uint64_t callback_via;
> > +	if (xen_feature(XENFEAT_hvm_callback_vector)) {
> > +		callback_via = HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR);
> > +		xen_set_callback_via(callback_via);
> >   
> 
> Do you need to check the return value here?  Can it possibly fail?
> 

Yes, it can fail. The vector delivery mechanism hasn't been checked in
Xen yet (I sent the patch right after this patch series).


> > +		x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
> > +		xen_have_vector_callback = 1;
> > +	}
> > +}
> > +
> >  void __init xen_guest_init(void)
> >  {
> >  	int r;
> > @@ -1292,4 +1322,9 @@ void __init xen_guest_init(void)
> >  		return;
> >  
> >  	init_shared_info();
> > +
> > +	xen_callback_vector();
> > +
> > +	have_vcpu_info_placement = 0;
> > +	x86_init.irqs.intr_init = xen_init_IRQ;
> >  }
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index db8f506..3523dbb 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -36,6 +36,8 @@
> >  #include <asm/xen/hypercall.h>
> >  #include <asm/xen/hypervisor.h>
> >  
> > +#include <xen/xen.h>
> > +#include <xen/hvm.h>
> >  #include <xen/xen-ops.h>
> >  #include <xen/events.h>
> >  #include <xen/interface/xen.h>
> > @@ -617,17 +619,13 @@ static DEFINE_PER_CPU(unsigned, xed_nesting_count);
> >   * a bitset of words which contain pending event bits.  The second
> >   * level is a bitset of pending events themselves.
> >   */
> > -void xen_evtchn_do_upcall(struct pt_regs *regs)
> > +void __xen_evtchn_do_upcall(struct pt_regs *regs)
> >   
> 
> Given that the regs arg is completely unused, you should drop it.
> 

OK

> >  {
> >  	int cpu = get_cpu();
> > -	struct pt_regs *old_regs = set_irq_regs(regs);
> >  	struct shared_info *s = HYPERVISOR_shared_info;
> >  	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
> >   	unsigned count;
> >  
> > -	exit_idle();
> > -	irq_enter();
> > -
> >  	do {
> >  		unsigned long pending_words;
> >  
> > @@ -667,10 +665,26 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
> >  	} while(count != 1);
> >  
> >  out:
> > +
> > +	put_cpu();
> > +}
> > +
> > +void xen_evtchn_do_upcall(struct pt_regs *regs)
> > +{
> > +	struct pt_regs *old_regs = set_irq_regs(regs);
> > +
> > +	exit_idle();
> > +	irq_enter();
> > +
> > +	__xen_evtchn_do_upcall(regs);
> > +
> >  	irq_exit();
> >  	set_irq_regs(old_regs);
> > +}
> >  
> > -	put_cpu();
> > +void xen_hvm_evtchn_do_upcall(struct pt_regs *regs)
> > +{
> > +	__xen_evtchn_do_upcall(regs);
> >   
> 
> Don't you need to set_irq_regs here?

No, that was done by smp_x86_platform_ipi or do_IRQ.


