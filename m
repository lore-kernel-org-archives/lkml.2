Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2AELVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:21:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2AELV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:21:29 -0500
Date: Thu, 5 Jan 2012 09:20:18 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Boris Ostrovsky <ostr@amd64.org>
Cc: avi@redhat.com, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Add support for AMD's OSVW feature in guests
Message-ID: <20120105112018.GA1901@amt.cnet>
References: <1325651893-7487-1-git-send-email-ostr@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325651893-7487-1-git-send-email-ostr@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 11:38:13PM -0500, Boris Ostrovsky wrote:
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
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    6 ++++
>  arch/x86/kvm/svm.c              |   55 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c              |   30 ++++++++++++++++++++-
>  3 files changed, 90 insertions(+), 1 deletions(-)
> 
> Second version of OSVW patch. svm_init_osvw() is still in svm.c but registers'
> values are kept in virtual MSRs and should be available on reboot after
> cross-vendor migration. The registers can also be set from userland so
> that they are consistent across a cluster.
> 
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b4973f4..9ef9215 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -452,6 +452,12 @@ struct kvm_vcpu_arch {
>  		u32 id;
>  		bool send_user_only;
>  	} apf;
> +
> +	/* OSVW MSRs (AMD only) */
> +	struct {
> +		u64 length;
> +		u64 status;
> +	} osvw;
>  };
>  
>  struct kvm_arch {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e32243e..b19769d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -110,6 +110,13 @@ struct nested_state {
>  #define MSRPM_OFFSETS	16
>  static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  
> +/*
> + * Set osvw_len to higher value when updated Revision Guides
> + * are published and we know what the new status bits are
> + */
> +static uint64_t osvw_len = 4, osvw_status;
> +static DEFINE_SPINLOCK(svm_lock);

No need for this lock, operation already serialized by kvm_lock.

>  struct vcpu_svm {
>  	struct kvm_vcpu vcpu;
>  	struct vmcb *vmcb;
> @@ -556,6 +563,20 @@ static void svm_init_erratum_383(void)
>  	erratum_383_found = true;
>  }
>  
> +static void svm_init_osvw(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Guests should see errata 400 and 415 as fixed (assuming that
> +	 * HLT and IO instructions are intercepted).
> +	 */
> +	vcpu->arch.osvw.length = (osvw_len >= 3) ? (osvw_len) : 3;
> +	vcpu->arch.osvw.status = osvw_status & ~(6ULL);

Do you really want to expose the hosts osvw_status and osvw_len? If
only exposure of 400 and 415 as fixed is necessary, then dealing with
migration is simpler (that is, you control what workarounds are applied
in the guest instead of making it dependent on particular hosts).

> +	/* Mark erratum 298 as present */
> +	if (osvw_len == 0 && boot_cpu_data.x86 == 0x10)
> +		vcpu->arch.osvw.status |= 1;
> +}

Why is it necessary to explicitly do this? Please add documentation.

> +	case MSR_AMD64_OSVW_ID_LENGTH:
> +		if (!guest_cpuid_has_osvw(vcpu))
> +			return 1;
> +		vcpu->arch.osvw.length = data;
> +		break;
> +	case MSR_AMD64_OSVW_STATUS:
> +		if (!guest_cpuid_has_osvw(vcpu))
> +			return 1;
> +		vcpu->arch.osvw.status = data;
> +		break;

If writes are allowed, it is necessary to migrate this.

>  	default:
>  		if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
>  			return xen_hvm_config(vcpu, data);
> @@ -1978,6 +1996,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  		 */
>  		data = 0xbe702111;
>  		break;
> +	case MSR_AMD64_OSVW_ID_LENGTH:
> +		if (!guest_cpuid_has_osvw(vcpu))
> +			return 1;
> +		data = vcpu->arch.osvw.length;
> +		break;
> +	case MSR_AMD64_OSVW_STATUS:
> +		if (!guest_cpuid_has_osvw(vcpu))
> +			return 1;
> +		data = vcpu->arch.osvw.status;
> +		break;
>  	default:
>  		if (!ignore_msrs) {
>  			pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
> @@ -2451,7 +2479,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  	const u32 kvm_supported_word6_x86_features =
>  		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
>  		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
> -		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
> +		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
>  		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM);
>  
>  	/* cpuid 0xC0000001.edx */
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
