Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2JVRHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:07:52 -0400
Received: from userp1050.oracle.com ([156.151.31.82]:36885 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab2JVRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:07:51 -0400
X-Greylist: delayed 4483 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 13:07:50 EDT
Date: Mon, 22 Oct 2012 11:40:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 2/6] xen/pvh: Extend vcpu_guest_context, p2m, event, and
 xenbus to support PVH.
Message-ID: <20121022154049.GA25200@phenom.dumpdata.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
 <1350695882-12820-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1210221439530.2689@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210221439530.2689@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 02:44:40PM +0100, Stefano Stabellini wrote:
> On Sat, 20 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz}, as PVH
> > only needs to send down gdtaddr and gdtsz.
> > 
> > For interrupts, PVH uses native_irq_ops.
> > vcpu hotplug is currently not available for PVH.
> > 
> > For events we follow what PVHVM does - to use callback vector.
> > Lastly, also use HVM path to setup XenBus.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/include/asm/xen/interface.h |   11 +++++-
> >  arch/x86/xen/irq.c                   |    5 ++-
> >  arch/x86/xen/p2m.c                   |    2 +-
> >  arch/x86/xen/smp.c                   |   75 ++++++++++++++++++++++------------
> >  drivers/xen/cpu_hotplug.c            |    4 +-
> >  drivers/xen/events.c                 |    9 ++++-
> >  drivers/xen/xenbus/xenbus_client.c   |    3 +-
> >  7 files changed, 77 insertions(+), 32 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
> > index 6d2f75a..4c08f23 100644
> > --- a/arch/x86/include/asm/xen/interface.h
> > +++ b/arch/x86/include/asm/xen/interface.h
> > @@ -144,7 +144,16 @@ struct vcpu_guest_context {
> >      struct cpu_user_regs user_regs;         /* User-level CPU registers     */
> >      struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
> >      unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
> > -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
> > +    union {
> > +	struct {
> > +		/* PV: GDT (machine frames, # ents).*/
> > +		unsigned long gdt_frames[16], gdt_ents;
> > +	} pv;
> > +	struct {
> > +		/* PVH: GDTR addr and size */
> > +		unsigned long gdtaddr, gdtsz;
> > +	} pvh;
> > +    } u;
> >      unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)   */
> >      /* NB. User pagetable on x86/64 is placed in ctrlreg[1]. */
> >      unsigned long ctrlreg[8];               /* CR0-CR7 (control registers)  */
> > diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> > index 01a4dc0..fcbe56a 100644
> > --- a/arch/x86/xen/irq.c
> > +++ b/arch/x86/xen/irq.c
> > @@ -5,6 +5,7 @@
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/sched.h>
> >  #include <xen/interface/vcpu.h>
> > +#include <xen/features.h>
> >  #include <xen/events.h>
> >  
> >  #include <asm/xen/hypercall.h>
> > @@ -129,6 +130,8 @@ static const struct pv_irq_ops xen_irq_ops __initconst = {
> >  
> >  void __init xen_init_irq_ops(void)
> >  {
> > -	pv_irq_ops = xen_irq_ops;
> > +	/* For PVH we use default pv_irq_ops settings */
> > +	if (!xen_feature(XENFEAT_hvm_callback_vector))
> > +		pv_irq_ops = xen_irq_ops;
> >  	x86_init.irqs.intr_init = xen_init_IRQ;
> >  }
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 95fb2aa..ea553c8 100644
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -798,7 +798,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> >  {
> >  	unsigned topidx, mididx, idx;
> >  
> > -	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
> > +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> >  		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
> >  		return true;
> >  	}
> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index 353c50f..df400349 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -68,9 +68,11 @@ static void __cpuinit cpu_bringup(void)
> >  	touch_softlockup_watchdog();
> >  	preempt_disable();
> >  
> > -	xen_enable_sysenter();
> > -	xen_enable_syscall();
> > -
> > +	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
> > +	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
> > +		xen_enable_sysenter();
> > +		xen_enable_syscall();
> > +	}
> >  	cpu = smp_processor_id();
> >  	smp_store_cpu_info(cpu);
> >  	cpu_data(cpu).x86_max_cores = 1;
> > @@ -230,10 +232,11 @@ static void __init xen_smp_prepare_boot_cpu(void)
> >  	BUG_ON(smp_processor_id() != 0);
> >  	native_smp_prepare_boot_cpu();
> >  
> > -	/* We've switched to the "real" per-cpu gdt, so make sure the
> > -	   old memory can be recycled */
> > -	make_lowmem_page_readwrite(xen_initial_gdt);
> > -
> > +	if (!xen_feature(XENFEAT_writable_page_tables)) {
> > +		/* We've switched to the "real" per-cpu gdt, so make sure the
> > +		 * old memory can be recycled */
> > +		make_lowmem_page_readwrite(xen_initial_gdt);
> > +	}
> >  	xen_filter_cpu_maps();
> >  	xen_setup_vcpu_info_placement();
> >  }
> > @@ -300,8 +303,6 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
> >  	gdt = get_cpu_gdt_table(cpu);
> >  
> >  	ctxt->flags = VGCF_IN_KERNEL;
> > -	ctxt->user_regs.ds = __USER_DS;
> > -	ctxt->user_regs.es = __USER_DS;
> >  	ctxt->user_regs.ss = __KERNEL_DS;
> >  #ifdef CONFIG_X86_32
> >  	ctxt->user_regs.fs = __KERNEL_PERCPU;
> > @@ -310,35 +311,57 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
> >  	ctxt->gs_base_kernel = per_cpu_offset(cpu);
> >  #endif
> >  	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
> > -	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
> >  
> >  	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
> >  
> > -	xen_copy_trap_info(ctxt->trap_ctxt);
> > +	/* check for autoxlated to get it right for 32bit kernel */
> 
> I am not sure what this comment means, considering that in another
> comment below you say that we don't support 32bit PVH kernels.

Hm, even the V1 had this. I think he meant something else.

> 
> 
> > +	if (xen_feature(XENFEAT_auto_translated_physmap) &&
> > +	    xen_feature(XENFEAT_supervisor_mode_kernel)) {
> >  
> > -	ctxt->ldt_ents = 0;
> > +		ctxt->user_regs.ds = __KERNEL_DS;
> > +		ctxt->user_regs.es = 0;
> > +		ctxt->user_regs.gs = 0;
> >  
> > -	BUG_ON((unsigned long)gdt & ~PAGE_MASK);
> > +		ctxt->u.pvh.gdtaddr = (unsigned long)gdt;
> > +		ctxt->u.pvh.gdtsz = (unsigned long)(GDT_SIZE - 1);
> >  
> > -	gdt_mfn = arbitrary_virt_to_mfn(gdt);
> > -	make_lowmem_page_readonly(gdt);
> > -	make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
> > +#ifdef CONFIG_X86_64
> > +		/* Note: PVH is not supported on x86_32. */
> > +		ctxt->gs_base_user = (unsigned long)
> > +					per_cpu(irq_stack_union.gs_base, cpu);
> > +#endif
> > +	} else {
> > +		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
> > +		ctxt->user_regs.ds = __USER_DS;
> > +		ctxt->user_regs.es = __USER_DS;
> >  
> > -	ctxt->gdt_frames[0] = gdt_mfn;
> > -	ctxt->gdt_ents      = GDT_ENTRIES;
> > +		xen_copy_trap_info(ctxt->trap_ctxt);
> >  
> > -	ctxt->user_regs.cs = __KERNEL_CS;
> > -	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
> > +		ctxt->ldt_ents = 0;
> >  
> > -	ctxt->kernel_ss = __KERNEL_DS;
> > -	ctxt->kernel_sp = idle->thread.sp0;
> > +		BUG_ON((unsigned long)gdt & ~PAGE_MASK);
> > +
> > +		gdt_mfn = arbitrary_virt_to_mfn(gdt);
> > +		make_lowmem_page_readonly(gdt);
> > +		make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
> > +
> > +		ctxt->u.pv.gdt_frames[0] = gdt_mfn;
> > +		ctxt->u.pv.gdt_ents      = GDT_ENTRIES;
> > +
> > +		ctxt->kernel_ss = __KERNEL_DS;
> > +		ctxt->kernel_sp = idle->thread.sp0;
> >  
> >  #ifdef CONFIG_X86_32
> > -	ctxt->event_callback_cs     = __KERNEL_CS;
> > -	ctxt->failsafe_callback_cs  = __KERNEL_CS;
> > +		ctxt->event_callback_cs     = __KERNEL_CS;
> > +		ctxt->failsafe_callback_cs  = __KERNEL_CS;
> >  #endif
> > -	ctxt->event_callback_eip    = (unsigned long)xen_hypervisor_callback;
> > -	ctxt->failsafe_callback_eip = (unsigned long)xen_failsafe_callback;
> > +		ctxt->event_callback_eip    =
> > +					(unsigned long)xen_hypervisor_callback;
> > +		ctxt->failsafe_callback_eip =
> > +					(unsigned long)xen_failsafe_callback;
> > +	}
> > +	ctxt->user_regs.cs = __KERNEL_CS;
> > +	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
> >  
> >  	per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
> >  	ctxt->ctrlreg[3] = xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
> 
> The tradional path looks the same as before, however it is hard to tell
> whether the PVH path is correct without the Xen side. For example, what
> is gdtsz?
