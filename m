Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1LZNyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 08:54:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab1LZNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 08:54:13 -0500
Message-ID: <4EF87C70.7010901@redhat.com>
Date: Mon, 26 Dec 2011 15:53:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Boris Ostrovsky <ostr@amd64.org>
CC: mtosatti@redhat.com, Joerg.Roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com
Subject: Re: [PATCH] KVM: SVM: Add support for AMD's OSVW feature in guests
References: <1324316763-24080-1-git-send-email-ostr@amd64.org>
In-Reply-To: <1324316763-24080-1-git-send-email-ostr@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 07:46 PM, Boris Ostrovsky wrote:
> From: Boris Ostrovsky <boris.ostrovsky@amd.com>
>
> In some cases guests should not provide workarounds for errata even when the
> physical processor is affected. For example, because of erratum 400 on family
> 10h processors a Linux guest will read an MSR (resulting in VMEXIT) before
> going to idle in order to avoid getting stuck in a non-C0 state. This is not
> necessary: HLT and IO instructions are intercepted and therefore there is no
> reason for erratum 400 workaround in the guest.
>
> This patch allows us to present a guest with certain errata as fixed,
> regardless of the state of actual hardware.
>
>  
> +
> +static int svm_handle_osvw(struct kvm_vcpu *vcpu,
> +			   uint32_t msr, uint64_t *val)
> +{
> +	struct kvm_cpuid_entry2 *cpuid_entry;
> +
> +	/* Guest OSVW support */
> +	cpuid_entry = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
> +	if (!cpuid_entry || !(cpuid_entry->ecx & bit(X86_FEATURE_OSVW)))
> +		return -1;
> +
> +	/*
> +	 * Guests should see errata 400 and 415 as fixed (assuming that
> +	 * HLT and IO instructions are intercepted).
> +	 */
> +	if (msr == MSR_AMD64_OSVW_ID_LENGTH)
> +		*val = (osvw_len >= 3) ? (osvw_len) : 3;
> +	else {
> +		*val = osvw_status & ~(6ULL);
> +
> +		if (osvw_len == 0 && boot_cpu_data.x86 == 0x10)
> +			/* Mark erratum 298 as present */
> +			*val |= 1;
> +	}
> +
> +	return 0;
> +}

Please move this to common code, to support cross-vendor migration.

> +
> +
>  static int has_svm(void)
>  {
>  	const char *msg;
> @@ -620,6 +656,37 @@ static int svm_hardware_enable(void *garbage)
>  		__get_cpu_var(current_tsc_ratio) = TSC_RATIO_DEFAULT;
>  	}
>  
> +
> +	/*
> +	 * Get OSVW bits.
> +	 *
> +	 * Note that it is possible to have a system with mixed processor
> +	 * revisions and therefore different OSVW bits. If bits are not the same
> +	 * on different processors then choose the worst case (i.e. if erratum
> +	 * is present on one processor and not on another then assume that the
> +	 * erratum is present everywhere).
> +	 */
> +	if (cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
> +		uint64_t len, status;
> +		int err;
> +
> +		len = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &err);
> +		if (!err)
> +			status = native_read_msr_safe(MSR_AMD64_OSVW_STATUS,
> +						      &err);
> +
> +		spin_lock(&svm_lock);
> +		if (err)
> +			osvw_status = osvw_len = 0;
> +		else {
> +			if (len < osvw_len)
> +				osvw_len = len;

This implies that if a bit is inside len, then the OS must apply the
workaround?

> +			osvw_status |= status;
> +			osvw_status &= (1ULL << osvw_len) - 1;
> +		}
> +		spin_unlock(&svm_lock);
> +	}
> +
>  	svm_init_erratum_383();
>  
> @@ -3092,6 +3162,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
>  	case MSR_VM_IGNNE:
>  		pr_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
>  		break;
> +	case MSR_AMD64_OSVW_ID_LENGTH:
> +	case MSR_AMD64_OSVW_STATUS:
> +		/* Writes are ignored */
> +		break;
>  	default:
>  		return kvm_set_msr_common(vcpu, ecx, data);
>  	}

Best to allow writes, the manual says writes are allowed for bios code,
and the OS should just avoid it.

Not sure what to do here about live migration, since the guest will not
adjust its behaviour.  Should management software read those MSRs from
userspace and check that they're consistent across a cluster?

-- 
error compiling committee.c: too many arguments to function

