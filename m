Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1LALMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:12:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1LALMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:12:18 -0500
Message-ID: <4ED760F1.6080804@redhat.com>
Date: Thu, 01 Dec 2011 13:11:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com> <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 10:59 AM, Raghavendra K T wrote:
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

The hypercall needs to be documented in
Documentation/virtual/kvm/hypercalls.txt.

Have you tested it on AMD machines?  There are some differences in the
hypercall infrastructure there.

>  /* This indicates that the new set of kvmclock msrs
>   * are available. The use of 0x11 and 0x12 is deprecated
>   */
>  #define KVM_FEATURE_CLOCKSOURCE2        3
>  #define KVM_FEATURE_ASYNC_PF		4
>  #define KVM_FEATURE_STEAL_TIME		5
> +#define KVM_FEATURE_KICK_VCPU		6

Documentation/virtual/kvm/cpuid.txt.

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

This is redundant with the feature bit?  In general, KVM_CAP is for the
host API, while KVM_FEATURE is for the guest API.

>  
> +/*
> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> + *
> + * @cpu - vcpu to be kicked.
> + */
> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
> +{
> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);

There is no guarantee that guest cpu numbers match host vcpu numbers. 
Use APIC IDs, and kvm_apic_match_dest().

> +	struct kvm_mp_state mp_state;
> +
> +	mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
> +	if (vcpu) {
> +		vcpu->kicked = 1;
> +		/* Ensure kicked is always set before wakeup */
> +		barrier();
> +	}
> +	kvm_arch_vcpu_ioctl_set_mpstate(vcpu, &mp_state);

This must only be called from the vcpu thread.

> +	kvm_vcpu_kick(vcpu);
> +}
> +
>  
>  	struct kvm_vcpu_arch arch;
> +
> +	/*
> +	 * blocked vcpu wakes up by checking this flag set by unlocker.
> +	 */
> +	int kicked;
>

Write only variable.

An alternative approach is to use an MSR protocol like x2apic ICR.

-- 
error compiling committee.c: too many arguments to function

