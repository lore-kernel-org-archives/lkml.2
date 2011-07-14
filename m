Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1GNLit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab1GNLir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:38:47 -0400
Message-ID: <4E1ED53F.7030903@redhat.com>
Date: Thu, 14 Jul 2011 14:38:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 4/7] KVM: SVM: Use seperate VMCB for L2 guests
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-5-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1310571145-28930-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 06:32 PM, Joerg Roedel wrote:
> From: Joerg Roedel<joro@8bytes.org>
>
> Move torwards emulation of VMCB-clean-bits by using a
> seperate VMCB when running L2 guests.
>
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f81e35e..6dacf59 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -105,6 +105,8 @@ struct nested_state {
>
>   	/* Nested Paging related state */
>   	u64 nested_cr3;
> +
> +	struct vmcb *n_vmcb;
>   };
>
>   #define MSRPM_OFFSETS	16
> @@ -974,6 +976,26 @@ static u64 svm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
>   	return target_tsc - tsc;
>   }
>
> +static bool init_nested_vmcb(struct vcpu_svm *svm)
> +{
> +	struct vmcb_control_area *hc, *nc;
> +
> +	svm->nested.n_vmcb = (void *)get_zeroed_page(GFP_KERNEL);
> +	if (svm->nested.n_vmcb == NULL)
> +		return false;
> +
> +	nc =&svm->nested.n_vmcb->control;
> +	hc =&svm->host_vmcb->control;
> +
> +	nc->iopm_base_pa		= hc->iopm_base_pa;
> +	nc->msrpm_base_pa		= hc->msrpm_base_pa;
> +	nc->nested_ctl			= hc->nested_ctl;
> +	nc->pause_filter_count		= hc->pause_filter_count;
> +	svm->nested.n_vmcb->save.g_pat	= svm->host_vmcb->save.g_pat;
> +
> +	return true;
> +}
> +

Instead of initializing the non-nested vmcb and then copying it, 
separate out the bits you're copying here into a separate function (i.e. 
init_vmcb_host_state()) and call it for both vmcbs.

I had practically the same comment for nvmx (see 
vmx_set_constant_host_state()).

-- 
error compiling committee.c: too many arguments to function

