Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1JXJD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:03:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37650 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1JXJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:03:24 -0400
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to
 support pv-ticketlock
From: Sasha Levin <levinsasha928@gmail.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
	 <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 24 Oct 2011 12:01:50 +0200
Message-ID: <1319450510.5660.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 00:35 +0530, Raghavendra K T wrote:
> Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
>     
> KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
> is woken up because of an event like interrupt.
>    
> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu.
>     
> The presence of these hypercalls is indicated to guest via
> KVM_FEATURE_WAIT_FOR_KICK/KVM_CAP_WAIT_FOR_KICK.
> 
> Qemu needs a corresponding patch to pass up the presence of this feature to 
> guest via cpuid. Patch to qemu will be sent separately.
> 
> There is no Xen/KVM hypercall interface to await kick from.
>     
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 734c376..2874c19 100644
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
> +#define KVM_FEATURE_WAIT_FOR_KICK       6
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 84a28ea..b43fd18 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2077,6 +2077,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_XSAVE:
>  	case KVM_CAP_ASYNC_PF:
>  	case KVM_CAP_GET_TSC_KHZ:
> +	case KVM_CAP_WAIT_FOR_KICK:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -2548,7 +2549,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
>  			     (1 << KVM_FEATURE_ASYNC_PF) |
> -			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
> +			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> +			     (1 << KVM_FEATURE_WAIT_FOR_KICK);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> @@ -5231,6 +5233,61 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +/*
> + * kvm_pv_wait_for_kick_op : Block until kicked by either a KVM_HC_KICK_CPU
> + * hypercall or a event like interrupt.
> + *
> + * @vcpu : vcpu which is blocking.
> + */
> +static void kvm_pv_wait_for_kick_op(struct kvm_vcpu *vcpu)
> +{
> +	DEFINE_WAIT(wait);
> +
> +	/*
> +	 * Blocking on vcpu->wq allows us to wake up sooner if required to
> +	 * service pending events (like interrupts).
> +	 *
> +	 * Also set state to TASK_INTERRUPTIBLE before checking vcpu->kicked to
> +	 * avoid racing with kvm_pv_kick_cpu_op().
> +	 */
> +	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> +
> +	/*
> +	 * Somebody has already tried kicking us. Acknowledge that
> +	 * and terminate the wait.
> +	 */
> +	if (vcpu->kicked) {
> +		vcpu->kicked = 0;
> +		goto end_wait;
> +	}
> +
> +	/* Let's wait for either KVM_HC_KICK_CPU or someother event
> +	 * to wake us up.
> +	 */
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> +	schedule();
> +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +end_wait:
> +	finish_wait(&vcpu->wq, &wait);
> +}
> +
> +/*
> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> + *
> + * @cpu - vcpu to be kicked.
> + */
> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
> +{
> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
> +
> +	if (vcpu) {
> +		vcpu->kicked = 1;

I'm not sure about it, but maybe we want a memory barrier over here?

> +		wake_up_interruptible(&vcpu->wq);
> +	}
> +}
-- 

Sasha.

