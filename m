Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1BOOid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:38:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab1BOOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:38:30 -0500
Message-ID: <4D5A8EEB.5030701@redhat.com>
Date: Tue, 15 Feb 2011 16:34:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 2/6] KVM-HV: KVM Steal time implementation
References: <1297448364-14051-1-git-send-email-glommer@redhat.com> <1297448364-14051-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1297448364-14051-3-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 08:19 PM, Glauber Costa wrote:
> To implement steal time, we need the hypervisor to pass the guest information
> about how much time was spent running other processes outside the VM.
> This is per-vcpu, and using the kvmclock structure for that is an abuse
> we decided not to make.
>
> In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
> holds the memory area address containing information about steal time
>
> This patch contains the hypervisor part for it. I am keeping it separate from
> the headers to facilitate backports to people who wants to backport the kernel
> part but not the hypervisor, or the other way around.
>
>
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ffd7f8d..be6e0e2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -377,6 +377,11 @@ struct kvm_vcpu_arch {
>   	unsigned int hw_tsc_khz;
>   	unsigned int time_offset;
>   	struct page *time_page;
> +
> +	gpa_t stime;
> +	struct kvm_steal_time steal;
> +	u64 this_time_out;
> +

Please put in a small sub-structure (or rename stime to something 
meaningful).

> @@ -1546,6 +1546,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>   		if (kvm_pv_enable_async_pf(vcpu, data))
>   			return 1;
>   		break;
> +	case MSR_KVM_STEAL_TIME:
> +
> +		if (!(data&  1)) {

Named constant.

> +			vcpu->arch.stime = 0;
> +			break;
> +		}
> +
> +		vcpu->arch.stime = data&  ~1;

I asked for 64-byte aligned structure, yes?  Need to fault if bits 1-5 
are set (to make sure the guest doesn't use an unadvertised feature and 
break itself in the future).

We might also want to fault if the cpuid bit isn't present.  We haven't 
done so in the past but it makes some sense.

> +		break;
> +
>   	case MSR_IA32_MCG_CTL:
>   	case MSR_IA32_MCG_STATUS:
>   	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
> @@ -1831,6 +1841,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>   	case MSR_KVM_ASYNC_PF_EN:
>   		data = vcpu->arch.apf.msr_val;
>   		break;
> +	case MSR_KVM_STEAL_TIME:
> +		data = vcpu->arch.stime;
> +		break;

You are returning something other than the guest has written.

>   	case MSR_IA32_P5_MC_ADDR:
>   	case MSR_IA32_P5_MC_TYPE:
>   	case MSR_IA32_MCG_CAP:
>

> @@ -2108,6 +2122,9 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
>
>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
> +	struct kvm_steal_time *st;
> +	st = (struct kvm_steal_time *)vcpu->arch.stime;

You are converting a guest physical address into a host virtual 
address?  Truncating it in the process.

> +
>   	/* Address WBINVD may be executed by guest */
>   	if (need_emulate_wbinvd(vcpu)) {
>   		if (kvm_x86_ops->has_wbinvd_exit())
> @@ -2133,6 +2150,21 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   			kvm_migrate_timers(vcpu);
>   		vcpu->cpu = cpu;
>   	}
> +
> +	if (vcpu->arch.this_time_out) {
> +		u64 to = (get_kernel_ns() - vcpu->arch.this_time_out);
> +
> +		kvm_read_guest(vcpu->kvm, (gpa_t)st,&vcpu->arch.steal,
> +				sizeof(*st));

Now you are converting it back.  Also, you aren't checking the error 
return from kvm_read_guest().

> +
> +		vcpu->arch.steal.steal += to;
> +		vcpu->arch.steal.version += 2;
> +
> +		kvm_write_guest(vcpu->kvm, (gpa_t)st,&vcpu->arch.steal,
> +				sizeof(*st));

Error check.

> +		/* is it possible to have 2 loads in sequence? */

No.

> +		vcpu->arch.this_time_out = 0;
> +	}
>   }

kvm_arch_vcpu_put() is also executed when we return to userspace.  Do we 
want to account that as steal time?

Do we want to execute this code even if steal time isn't enabled?

Please put this into a separate function.

-- 
error compiling committee.c: too many arguments to function

