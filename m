Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0D0Mmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:42:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab0D0Mm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:42:29 -0400
Message-ID: <4BD6DBB3.7050908@redhat.com>
Date: Tue, 27 Apr 2010 15:42:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] KVM: X86: Add kvm_read_guest_page_tdp function
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-14-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-14-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> This patch adds a function which can read from the guests
> physical memory or from the guest's guest physical memory.
> This will be used in the two-dimensional page table walker.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    3 +++
>   arch/x86/kvm/x86.c              |   24 ++++++++++++++++++++++++
>   2 files changed, 27 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3cbfb51..7851bbc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -635,6 +635,9 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
>   void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
>   void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
>   			   u32 error_code);
> +int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			    gfn_t gfn, void *data, int offset, int len,
> +			    u32 *error);
>   bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
>
>   int kvm_pic_set_irq(void *opaque, int irq, int level);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6b2ce1d..558d995 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -356,6 +356,30 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
>   EXPORT_SYMBOL_GPL(kvm_require_cpl);
>
>   /*
> + * This function will be used to read from the physical memory of the currently
> + * running guest. The difference to kvm_read_guest_page ist that this function
> + * can read from guest physical or from the guest's guest physical memory.
> + */
>    

s/ist/is/

> +int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			    gfn_t gfn, void *data, int offset, int len,
> +			    u32 *error)
>    

Naming: I see 'tdp' as a host property, and this is valid whether tdp is 
enabled or not.  Suggest calling it kvm_read_nested_guest_page().

Following mmu.txt, the parameter would be ngfn, not gfn.

> +{
> +	gfn_t real_gfn;
> +	gpa_t gpa;
> +
> +	*error   = 0;
> +	gpa      = gfn<<  PAGE_SHIFT;
> +	real_gfn = mmu->translate_gpa(vcpu, gpa, error);
>    

Overflow: sizeof(gpa) > sizeof(gfn).

> +	if (real_gfn == UNMAPPED_GVA)
> +		return -EFAULT;
> +
> +	real_gfn>>= PAGE_SHIFT;
>    

gpa_to_gfn().

> +
> +	return kvm_read_guest_page(vcpu->kvm, real_gfn, data, offset, len);
> +}
> +EXPORT_SYMBOL_GPL(kvm_read_guest_page_tdp);
> +
>    

-- 
error compiling committee.c: too many arguments to function

