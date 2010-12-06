Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0LFJsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:48:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab0LFJsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:48:06 -0500
Message-ID: <4CFCB150.40202@redhat.com>
Date: Mon, 06 Dec 2010 11:48:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] KVM: MMU: retry #PF for softmmu
References: <4CF76A8B.2040102@cn.fujitsu.com> <4CF76B06.6050708@cn.fujitsu.com>
In-Reply-To: <4CF76B06.6050708@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 11:46 AM, Xiao Guangrong wrote:
> Retry #PF for softmmu only when the current vcpu has the same cr3 as the time
> when #PF occurs
>
> Changelog:
>    Just compare cr3 value since It's harmless to instantiate an spte for an
>    unused translation from Marcelo's comment
>

It's not harmless.  We could be in a different process, so we have to 
re-fetch the gpte.  Or we could have switched from one nested guest to 
another.

>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index c6bb449..3f0d9a0 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2607,9 +2607,11 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
>   static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
>   {
>   	struct kvm_arch_async_pf arch;
> +
>   	arch.token = (vcpu->arch.apf.id++<<  12) | vcpu->vcpu_id;
>   	arch.gfn = gfn;
>   	arch.direct_map = vcpu->arch.mmu.direct_map;
> +	arch.cr3 = vcpu->arch.mmu.get_cr3(vcpu);
>
>   	return kvm_setup_async_pf(vcpu, gva, gfn,&arch);
>   }
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 23275d0..437e11a 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -116,7 +116,7 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
>    */
>   static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   				    struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -				    gva_t addr, u32 access)
> +				    gva_t addr, u32 access, bool prefault)
>   {
>   	pt_element_t pte;
>   	gfn_t table_gfn;
> @@ -194,6 +194,13 @@ walk:
>   #endif
>
>   		if (!eperm&&  !rsvd_fault&&  !(pte&  PT_ACCESSED_MASK)) {
> +			/*
> +			 * Don't set gpte accessed bit if it's on
> +			 * speculative path.
> +			 */
> +			if (prefault)
> +				goto error;

It's actually legal to set the accessed bit on speculative access.

-- 
error compiling committee.c: too many arguments to function

