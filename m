Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab0ERSKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:10:52 -0400
Received: from claw.goop.org ([74.207.240.146]:45699 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208Ab0ERSKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:10:49 -0400
Message-ID: <4BF2D828.60602@goop.org>
Date: Tue, 18 May 2010 11:10:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 03/12] evtchn delivery on HVM
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-3-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1274178187-20602-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 03:22 AM, Stefano Stabellini wrote:
> From: Sheng Yang <sheng@linux.intel.com>
>
> Set the callback to receive evtchns from Xen, using the
> callback vector delivery mechanism.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> ---
>  arch/x86/xen/enlighten.c         |   35 +++++++++++++++++++++++++++++++++++
>  drivers/xen/events.c             |   31 ++++++++++++++++++++++++-------
>  include/xen/events.h             |    3 +++
>  include/xen/hvm.h                |    9 +++++++++
>  include/xen/interface/features.h |    3 +++
>  5 files changed, 74 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 87a3b10..502c4f8 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -37,8 +37,11 @@
>  #include <xen/interface/vcpu.h>
>  #include <xen/interface/memory.h>
>  #include <xen/interface/hvm/hvm_op.h>
> +#include <xen/interface/hvm/params.h>
>  #include <xen/features.h>
>  #include <xen/page.h>
> +#include <xen/hvm.h>
> +#include <xen/events.h>
>  #include <xen/hvc-console.h>
>  
>  #include <asm/paravirt.h>
> @@ -79,6 +82,8 @@ struct shared_info xen_dummy_shared_info;
>  
>  void *xen_initial_gdt;
>  
> +int xen_have_vector_callback;
> +
>  /*
>   * Point at some empty memory to start with. We map the real shared_info
>   * page as soon as fixmap is up and running.
> @@ -1279,6 +1284,31 @@ static void __init init_shared_info(void)
>  	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
>  }
>  
> +int xen_set_callback_via(uint64_t via)
> +{
> +	struct xen_hvm_param a;
> +	a.domid = DOMID_SELF;
> +	a.index = HVM_PARAM_CALLBACK_IRQ;
> +	a.value = via;
> +	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
>   

Does this implicitly set the vector delivery on all vcpus, current and
future?

> +}
> +
> +void do_hvm_pv_evtchn_intr(void)
> +{
> +	xen_hvm_evtchn_do_upcall(get_irq_regs());
> +}
> +
> +static void xen_callback_vector(void)
>   

All this callback vector stuff should be in drivers/xen/events.c.  It
would also be good to give it a more descriptive name
("xen_set_callback_vector"?), and make it an init function.

> +{
> +	uint64_t callback_via;
> +	if (xen_feature(XENFEAT_hvm_callback_vector)) {
> +		callback_via = HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR);
> +		xen_set_callback_via(callback_via);
>   

Do you need to check the return value here?  Can it possibly fail?

> +		x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
> +		xen_have_vector_callback = 1;
> +	}
> +}
> +
>  void __init xen_guest_init(void)
>  {
>  	int r;
> @@ -1292,4 +1322,9 @@ void __init xen_guest_init(void)
>  		return;
>  
>  	init_shared_info();
> +
> +	xen_callback_vector();
> +
> +	have_vcpu_info_placement = 0;
> +	x86_init.irqs.intr_init = xen_init_IRQ;
>  }
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index db8f506..3523dbb 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -36,6 +36,8 @@
>  #include <asm/xen/hypercall.h>
>  #include <asm/xen/hypervisor.h>
>  
> +#include <xen/xen.h>
> +#include <xen/hvm.h>
>  #include <xen/xen-ops.h>
>  #include <xen/events.h>
>  #include <xen/interface/xen.h>
> @@ -617,17 +619,13 @@ static DEFINE_PER_CPU(unsigned, xed_nesting_count);
>   * a bitset of words which contain pending event bits.  The second
>   * level is a bitset of pending events themselves.
>   */
> -void xen_evtchn_do_upcall(struct pt_regs *regs)
> +void __xen_evtchn_do_upcall(struct pt_regs *regs)
>   

Given that the regs arg is completely unused, you should drop it.

>  {
>  	int cpu = get_cpu();
> -	struct pt_regs *old_regs = set_irq_regs(regs);
>  	struct shared_info *s = HYPERVISOR_shared_info;
>  	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
>   	unsigned count;
>  
> -	exit_idle();
> -	irq_enter();
> -
>  	do {
>  		unsigned long pending_words;
>  
> @@ -667,10 +665,26 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>  	} while(count != 1);
>  
>  out:
> +
> +	put_cpu();
> +}
> +
> +void xen_evtchn_do_upcall(struct pt_regs *regs)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	exit_idle();
> +	irq_enter();
> +
> +	__xen_evtchn_do_upcall(regs);
> +
>  	irq_exit();
>  	set_irq_regs(old_regs);
> +}
>  
> -	put_cpu();
> +void xen_hvm_evtchn_do_upcall(struct pt_regs *regs)
> +{
> +	__xen_evtchn_do_upcall(regs);
>   

Don't you need to set_irq_regs here?

>  }
>  
>  /* Rebind a new event channel to an existing irq. */
> @@ -947,5 +961,8 @@ void __init xen_init_IRQ(void)
>  	for (i = 0; i < NR_EVENT_CHANNELS; i++)
>  		mask_evtchn(i);
>  
> -	irq_ctx_init(smp_processor_id());
> +	if (xen_hvm_domain())
> +		native_init_IRQ();
> +	else
> +		irq_ctx_init(smp_processor_id());
>  }
> diff --git a/include/xen/events.h b/include/xen/events.h
> index e68d59a..868e5d6 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -56,4 +56,7 @@ void xen_poll_irq(int irq);
>  /* Determine the IRQ which is bound to an event channel */
>  unsigned irq_from_evtchn(unsigned int evtchn);
>  
> +void xen_evtchn_do_upcall(struct pt_regs *regs);
> +void xen_hvm_evtchn_do_upcall(struct pt_regs *regs);
> +
>  #endif	/* _XEN_EVENTS_H */
> diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> index 6b0d418..5940ee5 100644
> --- a/include/xen/hvm.h
> +++ b/include/xen/hvm.h
> @@ -3,6 +3,7 @@
>  #define XEN_HVM_H__
>  
>  #include <xen/interface/hvm/params.h>
> +#include <asm/xen/hypercall.h>
>  
>  static inline int hvm_get_parameter(int idx, uint64_t *value)
>  {
> @@ -21,4 +22,12 @@ static inline int hvm_get_parameter(int idx, uint64_t *value)
>         return r;
>  }
>  
> +int xen_set_callback_via(uint64_t via);
> +extern int xen_have_vector_callback;
> +
> +#define HVM_CALLBACK_VIA_TYPE_VECTOR 0x2
> +#define HVM_CALLBACK_VIA_TYPE_SHIFT 56
> +#define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
> +                               HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
> +
>  #endif /* XEN_HVM_H__ */
> diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
> index f51b641..8ab08b9 100644
> --- a/include/xen/interface/features.h
> +++ b/include/xen/interface/features.h
> @@ -41,6 +41,9 @@
>  /* x86: Does this Xen host support the MMU_PT_UPDATE_PRESERVE_AD hypercall? */
>  #define XENFEAT_mmu_pt_update_preserve_ad  5
>  
> +/* x86: Does this Xen host support the HVM callback vector type? */
> +#define XENFEAT_hvm_callback_vector        8
> +
>  #define XENFEAT_NR_SUBMAPS 1
>  
>  #endif /* __XEN_PUBLIC_FEATURES_H__ */
>   

