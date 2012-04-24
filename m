Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2DXKBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:01:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab2DXKBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:01:12 -0400
Date: Tue, 24 Apr 2012 12:59:23 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V6 1/5] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
Message-ID: <20120424095923.GS15413@redhat.com>
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
 <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 03:29:47PM +0530, Raghavendra K T wrote:
> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu out of halt state.
>     
> The presence of these hypercalls is indicated to guest via
> KVM_FEATURE_PV_UNHALT/KVM_CAP_PV_UNHALT.
> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
> index e35b3a8..3252339 100644
> --- a/arch/ia64/include/asm/kvm_host.h
> +++ b/arch/ia64/include/asm/kvm_host.h
> @@ -597,6 +597,9 @@ void kvm_sal_emul(struct kvm_vcpu *vcpu);
>  struct kvm *kvm_arch_alloc_vm(void);
>  void kvm_arch_free_vm(struct kvm *kvm);
>  
> +static inline void kvm_arch_vcpu_reset_pv_unhalted(struct kvm_vcpu *vcpu)
> +{
> +}
>  #endif /* __ASSEMBLY__*/
>  
>  #endif
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 52eb9c1..28446de 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -498,4 +498,8 @@ struct kvm_vcpu_arch {
>  #define KVM_MMIO_REG_QPR	0x0040
>  #define KVM_MMIO_REG_FQPR	0x0060
>  
> +static inline void kvm_arch_vcpu_reset_pv_unhalted(struct kvm_vcpu *vcpu)
> +{
> +}
> +
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 7343872..c47f874 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -256,4 +256,8 @@ struct kvm_arch{
>  };
>  
>  extern int sie64a(struct kvm_s390_sie_block *, u64 *);
> +static inline void kvm_arch_vcpu_reset_pv_unhalted(struct kvm_vcpu *vcpu)
> +{
> +}
> +
>  #endif
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e216ba0..dad475b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -481,6 +481,10 @@ struct kvm_vcpu_arch {
>  		u64 length;
>  		u64 status;
>  	} osvw;
> +	/* pv related host specific info */
> +	struct {
> +		int pv_unhalted;
> +	} pv;
>  };
>  
>  struct kvm_lpage_info {
> @@ -967,4 +971,6 @@ int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
>  void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
>  void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
>  
> +void kvm_arch_vcpu_reset_pv_unhalted(struct kvm_vcpu *vcpu);
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 734c376..5b647ea 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -16,12 +16,14 @@
>  #define KVM_FEATURE_CLOCKSOURCE		0
>  #define KVM_FEATURE_NOP_IO_DELAY	1
>  #define KVM_FEATURE_MMU_OP		2
> +
>  /* This indicates that the new set of kvmclock msrs
>   * are available. The use of 0x11 and 0x12 is deprecated
>   */
>  #define KVM_FEATURE_CLOCKSOURCE2        3
>  #define KVM_FEATURE_ASYNC_PF		4
>  #define KVM_FEATURE_STEAL_TIME		5
> +#define KVM_FEATURE_PV_UNHALT		6
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9fed5be..7c93806 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -408,7 +408,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
>  			     (1 << KVM_FEATURE_ASYNC_PF) |
> -			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
> +			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> +			     (1 << KVM_FEATURE_PV_UNHALT);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4044ce0..7fc9be6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2147,6 +2147,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_ASYNC_PF:
>  	case KVM_CAP_GET_TSC_KHZ:
>  	case KVM_CAP_PCI_2_3:
> +	case KVM_CAP_PV_UNHALT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -4993,6 +4994,36 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +/*
> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> + *
> + * @apicid - apicid of vcpu to be kicked.
> + */
> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
> +{
> +	struct kvm_vcpu *vcpu = NULL;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!kvm_apic_present(vcpu))
> +			continue;
> +
> +		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
> +			break;
> +	}
> +	if (vcpu) {
> +		/*
> +		 * Setting unhalt flag here can result in spurious runnable
> +		 * state when unhalt reset does not happen in vcpu_block.
> +		 * But that is harmless since that should soon result in halt.
> +		 */
> +		vcpu->arch.pv.pv_unhalted = 1;
> +		/* We need everybody see unhalt before vcpu unblocks */
> +		smp_mb();
> +		kvm_vcpu_kick(vcpu);
> +	}
> +}
This is too similar to kvm_irq_delivery_to_apic(). Why not reuse it. We
can use one of reserved delivery modes as PV delivery mode. We will
disallow guest to trigger it through apic interface, so this will not be
part of ABI and can be changed at will.

> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long nr, a0, a1, a2, a3, ret;
> @@ -5026,6 +5057,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	case KVM_HC_VAPIC_POLL_IRQ:
>  		ret = 0;
>  		break;
> +	case KVM_HC_KICK_CPU:
> +		kvm_pv_kick_cpu_op(vcpu->kvm, a0);
> +		ret = 0;
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> @@ -6128,6 +6163,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	BUG_ON(vcpu->kvm == NULL);
>  	kvm = vcpu->kvm;
>  
> +	kvm_arch_vcpu_reset_pv_unhalted(vcpu);
>  	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
>  	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
>  		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> @@ -6398,11 +6434,17 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  		!vcpu->arch.apf.halted)
>  		|| !list_empty_careful(&vcpu->async_pf.done)
>  		|| vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
> +		|| vcpu->arch.pv.pv_unhalted
>  		|| atomic_read(&vcpu->arch.nmi_queued) ||
>  		(kvm_arch_interrupt_allowed(vcpu) &&
>  		 kvm_cpu_has_interrupt(vcpu));
>  }
>  
> +void kvm_arch_vcpu_reset_pv_unhalted(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.pv.pv_unhalted = 0;
> +}
> +
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  {
>  	int me;
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 6c322a9..a189f02 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -589,6 +589,7 @@ struct kvm_ppc_pvinfo {
>  #define KVM_CAP_S390_UCONTROL 73
>  #define KVM_CAP_SYNC_REGS 74
>  #define KVM_CAP_PCI_2_3 75
> +#define KVM_CAP_PV_UNHALT 76
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> index ff476dd..38226e1 100644
> --- a/include/linux/kvm_para.h
> +++ b/include/linux/kvm_para.h
> @@ -19,6 +19,7 @@
>  #define KVM_HC_MMU_OP			2
>  #define KVM_HC_FEATURES			3
>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
> +#define KVM_HC_KICK_CPU			5
>  
>  /*
>   * hypercalls use architecture specific
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 42b7393..edf56d4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1500,6 +1500,14 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>  
>  		if (kvm_arch_vcpu_runnable(vcpu)) {
> +			/*
> +			 * This is the only safe place to reset unhalt flag.
> +			 * otherwise it results in loosing the notification
> +			 * which eventually can result in vcpu hangs.
> +			 */
Why this is the only safe place? Why clearing it in kvm/x86.c just after
call to kvm_vcpu_block() if KVM_REQ_UNHALT is set is not safe enough?

> +			kvm_arch_vcpu_reset_pv_unhalted(vcpu);
> +			/* preventing reordering should be enough here */
> +			barrier();
>  			kvm_make_request(KVM_REQ_UNHALT, vcpu);
>  			break;
>  		}

--
			Gleb.
