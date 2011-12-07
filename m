Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1LGKt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:49:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab1LGKt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:49:57 -0500
Date: Wed, 7 Dec 2011 08:48:49 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
Message-ID: <20111207104849.GA24849@amt.cnet>
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
 <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 02:29:59PM +0530, Raghavendra K T wrote:
> Add a hypercall to KVM hypervisor to support pv-ticketlocks 
> 
> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu out of halt state.
>     
> The presence of these hypercalls is indicated to guest via
> KVM_FEATURE_KICK_VCPU/KVM_CAP_KICK_VCPU.
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
> index 734c376..8b1d65d 100644
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
> +#define KVM_FEATURE_KICK_VCPU		6
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c38efd7..6e1c8b4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2103,6 +2103,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_XSAVE:
>  	case KVM_CAP_ASYNC_PF:
>  	case KVM_CAP_GET_TSC_KHZ:
> +	case KVM_CAP_KICK_VCPU:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -2577,7 +2578,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
>  			     (1 << KVM_FEATURE_ASYNC_PF) |
> -			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
> +			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> +			     (1 << KVM_FEATURE_KICK_VCPU);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> @@ -5305,6 +5307,26 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +/*
> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> + *
> + * @cpu - vcpu to be kicked.
> + */
> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
> +{
> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
> +	struct kvm_mp_state mp_state;
> +
> +	mp_state.mp_state = KVM_MP_STATE_RUNNABLE;

Since vcpu->mp_state is not protected by a lock, this is potentially racy. For example:

CPU0						CPU1
kvm_pv_kick_cpu_op				running vcpuN
vcpuN->mp_state = KVM_MP_STATE_RUNNABLE;
						kvm_emulate_halt
						vcpuN->mp_state = KVM_MP_STATE_HALTED

Is it harmless to lose a kick?

