Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2EPPyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab2EPPyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:54:33 -0400
Date: Wed, 16 May 2012 12:49:40 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
Message-ID: <20120516154940.GA20549@amt.cnet>
References: <cover.1337168687.git.mst@redhat.com>
 <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 02:46:12PM +0300, Michael S. Tsirkin wrote:
> Implementation of PV EOI using shared memory.
> This reduces the number of exits an interrupt
> causes as much as by half.
> 
> The idea is simple: there's a bit, per APIC, in guest memory,
> that tells the guest that it does not need EOI.
> We set it before injecting an interrupt and clear
> before injecting a nested one. Guest tests it using
> a test and clear operation - this is necessary
> so that host can detect interrupt nesting -
> and if set, it can skip the EOI MSR.
> 
> There's a new MSR to set the address of said register
> in guest memory. Otherwise not much changed:
> - Guest EOI is not required
> - Register is tested & ISR is automatically cleared on exit
> 
> For testing results see description of previous patch
> 'kvm_para: guest side for eoi avoidance'.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   12 ++++
>  arch/x86/kvm/cpuid.c            |    1 +
>  arch/x86/kvm/irq.c              |    2 +-
>  arch/x86/kvm/lapic.c            |  137 +++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/lapic.h            |    2 +
>  arch/x86/kvm/trace.h            |   34 ++++++++++
>  arch/x86/kvm/x86.c              |    5 ++
>  7 files changed, 187 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 32297f2..3ded418 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -174,6 +174,13 @@ enum {
>  
>  /* apic attention bits */
>  #define KVM_APIC_CHECK_VAPIC	0
> +/*
> + * The following bit is set with PV-EOI, unset on EOI.
> + * We detect PV-EOI changes by guest by comparing
> + * this bit with PV-EOI in guest memory.
> + * See the implementation in apic_update_pv_eoi.
> + */ 
> +#define KVM_APIC_PV_EOI_PENDING	1
>  
>  /*
>   * We don't want allocation failures within the mmu code, so we preallocate
> @@ -485,6 +492,11 @@ struct kvm_vcpu_arch {
>  		u64 length;
>  		u64 status;
>  	} osvw;
> +
> +	struct {
> +		u64 msr_val;
> +		struct gfn_to_hva_cache data;
> +	} pv_eoi;
>  };
>  
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index eba8345..a9f155a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -408,6 +408,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
>  			     (1 << KVM_FEATURE_ASYNC_PF) |
> +			     (1 << KVM_FEATURE_PV_EOI) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
>  
>  		if (sched_info_on())
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index 7e06ba1..07bdfab 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -48,7 +48,7 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
>  	if (!irqchip_in_kernel(v->kvm))
>  		return v->arch.interrupt.pending;
>  
> -	if (kvm_apic_has_interrupt(v) == -1) {	/* LAPIC */
> +	if (kvm_apic_has_interrupt(v) < 0) {	/* LAPIC */
>  		if (kvm_apic_accept_pic_intr(v)) {
>  			s = pic_irqchip(v->kvm);	/* PIC */
>  			return s->output;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 93c1574..b4f7013 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -270,6 +270,54 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
>  			irq->level, irq->trig_mode);
>  }
>  
> +static int pv_eoi_put_user(struct kvm_vcpu *vcpu, u8 val)
> +{
> +
> +	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data, &val,
> +				      sizeof(val));
> +}
> +
> +static int pv_eoi_get_user(struct kvm_vcpu *vcpu, u8 *val)
> +{
> +
> +	return kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data, val,
> +				      sizeof(*val));
> +}
> +
> +static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
> +}
> +
> +static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
> +{
> +	u8 val;
> +	if (pv_eoi_get_user(vcpu, &val) < 0)
> +		apic_debug("Can't read EOI MSR value: 0x%llx\n",
> +			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
> +	return val & 0x1;
> +}
> +
> +static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
> +{
> +	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
> +		apic_debug("Can't set EOI MSR value: 0x%llx\n",
> +			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
> +		return;
> +	}
> +	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
> +}
> +
> +static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
> +{
> +	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
> +		apic_debug("Can't clear EOI MSR value: 0x%llx\n",
> +			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
> +		return;
> +	}
> +	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
> +}
> +
>  static inline int apic_find_highest_isr(struct kvm_lapic *apic)
>  {
>  	int result;
> @@ -482,16 +530,26 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
>  	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
>  }
>  
> -static void apic_set_eoi(struct kvm_lapic *apic)
> +static int apic_set_eoi(struct kvm_lapic *apic)
>  {
>  	int vector = apic_find_highest_isr(apic);
> +
> +	trace_kvm_eoi(apic, vector);
> +
>  	/*
>  	 * Not every write EOI will has corresponding ISR,
>  	 * one example is when Kernel check timer on setup_IO_APIC
>  	 */
>  	if (vector == -1)
> -		return;
> +		return vector;
>  
> +	/*
> +	 * It's legal for guest to ignore the PV EOI optimization
> +	 * and signal EOI by APIC write. If this happens, clear
> +	 * PV EOI on guest's behalf.
> +	 */
> +	if (pv_eoi_enabled(apic->vcpu))
> +		pv_eoi_clr_pending(apic->vcpu);


>  	apic_clear_vector(vector, apic->regs + APIC_ISR);
>  	apic_update_ppr(apic);
>  
> @@ -505,6 +563,7 @@ static void apic_set_eoi(struct kvm_lapic *apic)
>  		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
>  	}
>  	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
> +	return vector;
>  }
>  
>  static void apic_send_ipi(struct kvm_lapic *apic)
> @@ -1085,6 +1144,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
>  	atomic_set(&apic->lapic_timer.pending, 0);
>  	if (kvm_vcpu_is_bsp(vcpu))
>  		vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
> +	vcpu->arch.pv_eoi.msr_val = 0;
>  	apic_update_ppr(apic);
>  
>  	vcpu->arch.apic_arb_prio = 0;
> @@ -1211,9 +1271,10 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  
>  	apic_update_ppr(apic);
>  	highest_irr = apic_find_highest_irr(apic);
> -	if ((highest_irr == -1) ||
> -	    ((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)))
> +	if (highest_irr == -1)
>  		return -1;
> +	if (((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)))
> +		return -2;
>  	return highest_irr;
>  }
>  
> @@ -1245,9 +1306,20 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
>  	int vector = kvm_apic_has_interrupt(vcpu);
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (vector == -1)
> +	/* Detect interrupt nesting and disable EOI optimization */
> +	if (pv_eoi_enabled(vcpu) && vector == -2)
> +		pv_eoi_clr_pending(vcpu);
> +
> +	if (vector < 0)

With interrupt window exiting, the guest will exit:

- as soon as it sets RFLAGS.IF=1 and there is any 
interrupt pending in IRR.
- any new interrupt is set in IRR will kick vcpu
out of guest mode and recalculate interrupt-window-exiting.

Doesnt this make this bit unnecessary ?


