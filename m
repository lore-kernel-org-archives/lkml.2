Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2JJQ3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab2JJQ3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:29:06 -0400
Date: Wed, 10 Oct 2012 12:21:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
Message-ID: <20121010152144.GA29776@amt.cnet>
References: <50716EE0.6010504@linux.vnet.ibm.com>
 <50716FF7.1060704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50716FF7.1060704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 08:05:11PM +0800, Xiao Guangrong wrote:
> The only difference between FNAME(update_pte) and FNAME(pte_prefetch)
> is that the former is allowed to prefetch gfn from dirty logged slot,
> so introduce a common function to prefetch spte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   55 +++++++++++++++++++------------------------
>  1 files changed, 24 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 36a80ed..f887e4c 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -305,31 +305,43 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
>  					addr, access);
>  }
> 
> -static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> -			      u64 *spte, const void *pte)
> +static bool
> +FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> +		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
>  {
> -	pt_element_t gpte;
>  	unsigned pte_access;
> +	gfn_t gfn;
>  	pfn_t pfn;
> 
> -	gpte = *(const pt_element_t *)pte;
>  	if (prefetch_invalid_gpte(vcpu, sp, spte, gpte))
> -		return;
> +		return false;
> 
>  	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
> +
> +	gfn = gpte_to_gfn(gpte);
>  	pte_access = sp->role.access & gpte_access(vcpu, gpte);
>  	protect_clean_gpte(&pte_access, gpte);
> -	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
> +	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
> +			no_dirty_log && (pte_access & ACC_WRITE_MASK));

Is this a bugfix?


