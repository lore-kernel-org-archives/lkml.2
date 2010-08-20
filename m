Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0HTR4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:56:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab0HTR43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:56:29 -0400
Date: Fri, 20 Aug 2010 14:56:20 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 30/35] IOCTL for setting TSC rate
Message-ID: <20100820175620.GJ2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-31-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-31-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:44PM -1000, Zachary Amsden wrote:
> Add an IOCTL for setting the TSC rate for a VM, intended to
> be used to migrate non-kvmclock based VMs which rely on TSC
> rate staying stable across host migration.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kvm/x86.c  |   36 ++++++++++++++++++++++++++++++++++++
>  include/linux/kvm.h |    4 ++++
>  2 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 887e30f..e618265 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1017,6 +1017,10 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  			kvm_x86_ops->adjust_tsc_offset(v, tsc-tsc_timestamp);
>  		local_irq_restore(flags);
>  
> +		/* hw_tsc_khz unknown at creation time, check for overrun */
> +		if (this_tsc_khz > v->kvm->arch.virtual_tsc_khz)
> +			vcpu->tsc_overrun = 1;
> +
>  		/* Now, see if we need to switch into trap mode */
>  		if (vcpu->tsc_overrun && !vcpu->tsc_trapping)
>  			kvm_x86_ops->set_tsc_trap(v, 1);
> @@ -1846,6 +1850,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_DEBUGREGS:
>  	case KVM_CAP_X86_ROBUST_SINGLESTEP:
>  	case KVM_CAP_XSAVE:
> +	case KVM_CAP_SET_TSC_RATE:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -3413,6 +3418,37 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		r = 0;
>  		break;
>  	}
> +	case KVM_X86_GET_TSC_RATE: {
> +		u32 rate = kvm->arch.virtual_tsc_khz;
> +		r = -EFAULT;
> +		if (copy_to_user(argp, &rate, sizeof(rate)))
> +			goto out;
> +		r = 0;
> +		break;
> +	}
> +	case KVM_X86_SET_TSC_RATE: {
> +		u32 rate;
> +		int i;
> +		struct kvm_vcpu *vcpu;
> +		r = -EFAULT;
> +		if (copy_from_user(&rate, argp, sizeof rate))
> +			goto out;
> +		if (rate == 0 || rate > (1ULL << 40)) {
> +			r = -EINVAL;
> +			break;
> +		}
> +		/*
> +		 * This is intended to be called once, during VM creation.
> +		 * Calling this with running VCPUs to dynamically change
> +		 * speed is risky; there is no synchronization with the
> +		 * compensation loop, so computations using virtual_tsc_khz
> +		 * conversions may go haywire.  Use at your own risk.
> +		 */
> +		kvm_arch_set_tsc_khz(kvm, rate);
> +		kvm_for_each_vcpu(i, vcpu, kvm)
> +			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> +		break;
> +	}
>  
>  	default:
>  		;
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 3707704..22d27f2 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -539,6 +539,7 @@ struct kvm_ppc_pvinfo {
>  #define KVM_CAP_XCRS 56
>  #endif
>  #define KVM_CAP_PPC_GET_PVINFO 57
> +#define KVM_CAP_SET_TSC_RATE 58
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -675,6 +676,9 @@ struct kvm_clock_data {
>  #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
>  /* Available with KVM_CAP_PPC_GET_PVINFO */
>  #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
> +/* Available with KVM_CAP_SET_TSC_RATE */
> +#define KVM_X86_GET_TSC_RATE      _IOR(KVMIO,  0xa2, __u32)
> +#define KVM_X86_SET_TSC_RATE      _IOW(KVMIO,  0xa3, __u32)

wrap this into a struct?

