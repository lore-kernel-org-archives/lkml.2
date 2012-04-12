Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256Ab2DLATa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:19:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab2DLAT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:19:26 -0400
Date: Wed, 11 Apr 2012 21:15:17 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 <x86@kernel.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V5 3/6] kvm : Add unhalt msr to aid (live) migration
Message-ID: <20120412001517.GB32051@amt.cnet>
References: <20120323080503.14568.43092.sendpatchset@codeblue>
 <20120323080723.14568.23068.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323080723.14568.23068.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 01:37:26PM +0530, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> 
> Currently guest does not need to know pv_unhalt state and intended to be
> used via GET/SET_MSR ioctls  during migration.
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 9234f13..46f9751 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -40,6 +40,7 @@
>  #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
>  #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
> +#define MSR_KVM_PV_UNHALT   0x4b564d04
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bd5ef91..38e6c47 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -784,12 +784,13 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
>   * kvm-specific. Those are put in the beginning of the list.
>   */
>  
> -#define KVM_SAVE_MSRS_BEGIN	9
> +#define KVM_SAVE_MSRS_BEGIN	10
>  static u32 msrs_to_save[] = {
>  	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
>  	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
>  	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
>  	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
> +	MSR_KVM_PV_UNHALT,
>  	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
>  	MSR_STAR,
>  #ifdef CONFIG_X86_64
> @@ -1606,7 +1607,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>  
>  		break;
> -
> +	case MSR_KVM_PV_UNHALT:
> +		vcpu->pv_unhalted = (u32) data;
> +		break;
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
>  	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
> @@ -1917,6 +1920,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  	case MSR_KVM_STEAL_TIME:
>  		data = vcpu->arch.st.msr_val;
>  		break;
> +	case MSR_KVM_PV_UNHALT:
> +		data = (u64)vcpu->pv_unhalted;
> +		break;
>  	case MSR_IA32_P5_MC_ADDR:
>  	case MSR_IA32_P5_MC_TYPE:
>  	case MSR_IA32_MCG_CAP:

Unless there is a reason to use an MSR, should use a normal ioctl
such as KVM_{GET,SET}_MP_STATE.

