Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0GFUHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 16:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab0GFUHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 16:07:49 -0400
Date: Tue, 6 Jul 2010 16:52:54 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 8/9] KVM: MMU: combine guest pte read between fetch
 and pte prefetch
Message-ID: <20100706195254.GA4311@amt.cnet>
References: <4C330918.6040709@cn.fujitsu.com>
 <4C330A9A.9030106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C330A9A.9030106@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 06:51:06PM +0800, Xiao Guangrong wrote:
> Combine guest pte read between guest pte check in the fetch path and pte prefetch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   69 ++++++++++++++++++++++++++-----------------
>  1 files changed, 42 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index e04c1a4..a1e6d91 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -67,6 +67,7 @@ struct guest_walker {
>  	int level;
>  	gfn_t table_gfn[PT_MAX_FULL_LEVELS];
>  	pt_element_t ptes[PT_MAX_FULL_LEVELS];
> +	pt_element_t prefetch_ptes[PTE_PREFETCH_NUM];
>  	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
>  	unsigned pt_access;
>  	unsigned pte_access;
> @@ -291,12 +292,12 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		     gpte_to_gfn(gpte), pfn, true, true);
>  }
>  
> -static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
> +static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
> +				u64 *sptep)
>  {
>  	struct kvm_mmu_page *sp;
> -	pt_element_t gptep[PTE_PREFETCH_NUM];
> -	gpa_t first_pte_gpa;
> -	int offset = 0, index, i, j, max;
> +	pt_element_t *gptep;
> +	int index, i, j, max;
>  
>  	sp = page_header(__pa(sptep));
>  	index = sptep - sp->spt;
> @@ -311,15 +312,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
>  	i = index & ~(PTE_PREFETCH_NUM - 1);
>  	max = index | (PTE_PREFETCH_NUM - 1);
>  
> -	if (PTTYPE == 32)
> -		offset = sp->role.quadrant << PT64_LEVEL_BITS;
> -
> -	first_pte_gpa = gfn_to_gpa(sp->gfn) +
> -				(offset + i) * sizeof(pt_element_t);
> -
> -	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
> -					sizeof(gptep)) < 0)
> -		return;
> +	gptep = gw->prefetch_ptes;

Where do you reread the gpte in the prefetch path?

