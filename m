Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2EaJ50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab2EaJ5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:57:24 -0400
Date: Thu, 31 May 2012 12:57:10 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 5/5] kvm: host side for eoi optimization
Message-ID: <20120531095710.GM2311@redhat.com>
References: <cover.1337695416.git.mst@redhat.com>
 <f434b6864a1af1f813e6ead964026553cd879c38.1337695416.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f434b6864a1af1f813e6ead964026553cd879c38.1337695416.git.mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 05:05:47PM +0300, Michael S. Tsirkin wrote:
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
>  arch/x86/kvm/lapic.c            |  135 +++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/lapic.h            |    2 +
>  arch/x86/kvm/trace.h            |   34 ++++++++++
>  arch/x86/kvm/x86.c              |    5 ++
>  6 files changed, 185 insertions(+), 4 deletions(-)
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
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0d2985d..9d804e7 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -309,6 +309,54 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
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
> @@ -525,15 +573,18 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
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
>  	apic_clear_isr(vector, apic);
>  	apic_update_ppr(apic);
> @@ -548,6 +599,7 @@ static void apic_set_eoi(struct kvm_lapic *apic)
>  		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
>  	}
>  	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
> +	return vector;
>  }
>  
>  static void apic_send_ipi(struct kvm_lapic *apic)
> @@ -1130,6 +1182,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
>  	atomic_set(&apic->lapic_timer.pending, 0);
>  	if (kvm_vcpu_is_bsp(vcpu))
>  		vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
> +	vcpu->arch.pv_eoi.msr_val = 0;
>  	apic_update_ppr(apic);
>  
>  	vcpu->arch.apic_arb_prio = 0;
> @@ -1330,11 +1383,50 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
>  		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
>  }
>  
> +/*
> + * apic_sync_pv_eoi_from_guest - called on vmexit
> + *
> + * Detect whether guest triggered PV EOI since the
> + * last entry. If yes, set EOI on guests's behalf.
> + */
> +static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
> +					struct kvm_lapic *apic)
> +{
> +	bool pending;
> +	int vector;
> +	/*
> +	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
> +	 * and KVM_PV_EOI_ENABLED in guest memory as follows:
> +	 *
> +	 * KVM_APIC_PV_EOI_PENDING is unset:
> +	 * 	-> host disabled PV EOI.
> +	 * KVM_APIC_PV_EOI_PENDING is set, KVM_PV_EOI_ENABLED is set:
> +	 * 	-> host enabled PV EOI, guest did not execute EOI yet.
> +	 * KVM_APIC_PV_EOI_PENDING is set, KVM_PV_EOI_ENABLED is unset:
> +	 * 	-> host enabled PV EOI, guest executed EOI.
> +	 */
> +	BUG_ON(!pv_eoi_enabled(vcpu));
> +	pending = pv_eoi_get_pending(vcpu);
> +	/*
> +	 * Clear pending bit in any case: it will be set again on vmentry.
> +	 * While this might not be ideal from performance point of view,
> +	 * this makes sure pv eoi is only enabled when we know it's safe.
> +	 */
> +	pv_eoi_clr_pending(vcpu);
> +	if (pending)
> +		return;
> +	vector = apic_set_eoi(apic);
> +	trace_kvm_pv_eoi(apic, vector);
> +}
> +
>  void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
>  {
>  	u32 data;
>  	void *vapic;
>  
> +	if (test_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention))
> +		apic_sync_pv_eoi_from_guest(vcpu, vcpu->arch.apic);
> +
>  	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
>  		return;
>  
> @@ -1345,17 +1437,40 @@ void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
>  	apic_set_tpr(vcpu->arch.apic, data & 0xff);
>  }
>  
> +/*
> + * apic_sync_pv_eoi_to_guest - called before vmentry
> + *
> + * Detect whether it's safe to enable PV EOI and
> + * if yes do so.
> + */
> +static void apic_sync_pv_eoi_to_guest(struct kvm_vcpu *vcpu,
> +					struct kvm_lapic *apic)
> +{
> +	if (!pv_eoi_enabled(vcpu) ||
> +	    /* IRR set or many bits in ISR: could be nested. */
> +	    unlikely(apic->irr_pending) ||
> +	    unlikely(apic->isr_count != 1) ||
Remind me why pv_eoi should not be set if there is more than one isr?

> +	    /* Cache not set: safe but we don't bother. */
> +	    unlikely(apic->isr_cache == -1) ||
> +	    /* Need EOI to update ioapic. */
> +	    unlikely(kvm_ioapic_handles_vector(vcpu->kvm, apic->isr_cache)))
> +		return;
> +
> +	pv_eoi_set_pending(apic->vcpu);
> +}
> +
apic_sync_pv_eoi_to_guest() is not paired with
apic_sync_pv_eoi_from_guest() if event injection is canceled.
You can enter guest with stale pv_eoi bit.

>  void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
>  {
>  	u32 data, tpr;
>  	int max_irr, max_isr;
> -	struct kvm_lapic *apic;
> +	struct kvm_lapic *apic = vcpu->arch.apic;
>  	void *vapic;
>  
> +	apic_sync_pv_eoi_to_guest(vcpu, apic);
> +
>  	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
>  		return;
>  
> -	apic = vcpu->arch.apic;
>  	tpr = apic_get_reg(apic, APIC_TASKPRI) & 0xff;
>  	max_irr = apic_find_highest_irr(apic);
>  	if (max_irr < 0)
> @@ -1441,3 +1556,15 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
>  
>  	return 0;
>  }
> +
> +int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	u64 addr = data & ~KVM_MSR_ENABLED;
> +	if (pv_eoi_enabled(vcpu))
> +		pv_eoi_clr_pending(vcpu);
> +	vcpu->arch.pv_eoi.msr_val = data;
> +	if (!pv_eoi_enabled(vcpu))
> +		return 0;
> +	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.pv_eoi.data,
> +					 addr);
> +}
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 9f8deff..41c62c7 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -62,4 +62,6 @@ static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
>  {
>  	return vcpu->arch.hv_vapic & HV_X64_MSR_APIC_ASSIST_PAGE_ENABLE;
>  }
> +
> +int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data);
>  #endif
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 911d264..851914e 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -517,6 +517,40 @@ TRACE_EVENT(kvm_apic_accept_irq,
>  		  __entry->coalesced ? " (coalesced)" : "")
>  );
>  
> +TRACE_EVENT(kvm_eoi,
> +	    TP_PROTO(struct kvm_lapic *apic, int vector),
> +	    TP_ARGS(apic, vector),
> +
> +	TP_STRUCT__entry(
> +		__field(	__u32,		apicid		)
> +		__field(	int,		vector		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->apicid		= apic->vcpu->vcpu_id;
> +		__entry->vector		= vector;
> +	),
> +
> +	TP_printk("apicid %x vector %d", __entry->apicid, __entry->vector)
> +);
> +
> +TRACE_EVENT(kvm_pv_eoi,
> +	    TP_PROTO(struct kvm_lapic *apic, int vector),
> +	    TP_ARGS(apic, vector),
> +
> +	TP_STRUCT__entry(
> +		__field(	__u32,		apicid		)
> +		__field(	int,		vector		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->apicid		= apic->vcpu->vcpu_id;
> +		__entry->vector		= vector;
> +	),
> +
> +	TP_printk("apicid %x vector %d", __entry->apicid, __entry->vector)
> +);
> +
>  /*
>   * Tracepoint for nested VMRUN
>   */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3e57566..4fa26f2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -795,6 +795,7 @@ static u32 msrs_to_save[] = {
>  	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
>  	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
>  	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
> +	MSR_KVM_PV_EOI_EN,
>  	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
>  	MSR_STAR,
>  #ifdef CONFIG_X86_64
> @@ -1653,6 +1654,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>  
>  		break;
> +	case MSR_KVM_PV_EOI_EN:
> +		if (kvm_lapic_enable_pv_eoi(vcpu, data))
> +			return 1;
> +		break;
>  
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
> -- 
> MST

--
			Gleb.
