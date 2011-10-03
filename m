Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab1JCPBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:01:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab1JCPAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:00:52 -0400
Message-ID: <4E89CE09.1080808@redhat.com>
Date: Mon, 03 Oct 2011 17:00:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joerg.roedel@amd.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 8/9] KVM, VMX: Add support for guest/host-only profiling
References: <1317649795-18259-1-git-send-email-gleb@redhat.com> <1317649795-18259-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1317649795-18259-9-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 03:49 PM, Gleb Natapov wrote:
> Support guest/host-only profiling by switch perf msrs on
> a guest entry if needed.
>
> @@ -6052,6 +6056,26 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
>   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
>   }
>
> +static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> +{
> +#ifdef CONFIG_PERF_EVENTS

No need for #ifdef (if you also define perf_guest_get_msrs() when 
!CONFIG_PERF_EVENTS).

>
> +	int i;
> +
> +	if (!cpu_has_arch_perfmon || vmx->perf_msrs_cnt<= 0)
> +		return;

Why the first check?

>
> +
> +	perf_guest_get_msrs(vmx->perf_msrs_cnt, vmx->perf_msrs);
> +	for (i = 0; i<  vmx->perf_msrs_cnt; i++) {
> +		struct perf_guest_switch_msr *msr =&vmx->perf_msrs[i];
> +		if (msr->host == msr->guest)
> +			clear_atomic_switch_msr(vmx, msr->msr);
> +		else
> +			add_atomic_switch_msr(vmx, msr->msr, msr->guest,
> +					msr->host);

This generates a lot of VMWRITEs even if nothing changes, just to re-set 
bits in the VMCS to their existing values.  Need to add something like this:

    if (loaded_vmcs->msr[i].host == msr->host
&& loaded_vmcs->msr[i].guest == msr->guest)
           continue;

btw, shouldn't the msr autoload list be part of loaded_vmcs as well?

>
> +	}
> +#endif
> +}
> +
>   #ifdef CONFIG_X86_64
>   #define R "r"
>   #define Q "q"
> @@ -6101,6 +6125,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   	if (vcpu->guest_debug&  KVM_GUESTDBG_SINGLESTEP)
>   		vmx_set_interrupt_shadow(vcpu, 0);
>
> +	atomic_switch_perf_msrs(vmx);
> +
>   	vmx->__launched = vmx->loaded_vmcs->launched;
>   	asm(
>   		/* Store host registers */
> @@ -6306,6 +6332,15 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>   	vmx->nested.current_vmptr = -1ull;
>   	vmx->nested.current_vmcs12 = NULL;
>
> +	vmx->perf_msrs_cnt = perf_guest_get_msrs_count();
> +	if (vmx->perf_msrs_cnt>  0) {
> +		vmx->perf_msrs = kmalloc(vmx->perf_msrs_cnt *
> +				sizeof(struct perf_guest_switch_msr),
> +				GFP_KERNEL);
> +		if (!vmx->perf_msrs)
> +			goto free_vmcs;
> +	}
> +

Do we really need a private buffer?  Perhaps perf_guest_get_msrs() can 
return a perf-internal buffer (but then, we will need to copy it for the 
optimization above, but that's a separate issue).

-- 
error compiling committee.c: too many arguments to function

