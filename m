Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935838Ab0GPHTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935747Ab0GPHTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:19:46 -0400
Date: Fri, 16 Jul 2010 10:19:36 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
Message-ID: <20100716071936.GE17894@redhat.com>
References: <4C3FC033.3000605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3FC033.3000605@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:13:07AM +0800, Lai Jiangshan wrote:
> When page fault, we always call get_user_pages(write=1).
> 
> Actually, we don't need to do this when it is not write fault.
> get_user_pages(write=1) will cause shared page(ksm) copied.
> If this page is not modified in future, this copying and the copied page
> are just wasted. Ksm may scan and merge them and may cause thrash.
> 
But is page is written into afterwords we will get another page fault.

> In this patch, if the page is RO for host VMM and it not write fault for guest,
> we will use RO page, otherwise we use a writable page.
> 
Currently pages allocated for guest memory are required to be RW, so after your series
behaviour will remain exactly the same as before.

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 8ba9b0d..6382140 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1832,6 +1832,45 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
>  	}
>  }
>  
> +/* get a current mapped page fast, and test whether the page is writable. */
> +static struct page *get_user_page_and_protection(unsigned long addr,
> +	int *writable)
> +{
> +	struct page *page[1];
> +
> +	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
> +		*writable = 1;
> +		return page[0];
> +	}
> +	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
> +		*writable = 0;
> +		return page[0];
> +	}
> +	return NULL;
> +}
> +
> +static pfn_t kvm_get_pfn_for_page_fault(struct kvm *kvm, gfn_t gfn,
> +		int write_fault, int *host_writable)
> +{
> +	unsigned long addr;
> +	struct page *page;
> +
> +	if (!write_fault) {
> +		addr = gfn_to_hva(kvm, gfn);
> +		if (kvm_is_error_hva(addr)) {
> +			get_page(bad_page);
> +			return page_to_pfn(bad_page);
> +		}
> +
> +		page = get_user_page_and_protection(addr, host_writable);
> +		if (page)
> +			return page_to_pfn(page);
> +	}
> +
> +	*host_writable = 1;
> +	return kvm_get_pfn_for_gfn(kvm, gfn);
> +}
> +
kvm_get_pfn_for_gfn() returns fault_page if page is mapped RO, so caller
of kvm_get_pfn_for_page_fault() and kvm_get_pfn_for_gfn() will get
different results when called on the same page. Not good.
kvm_get_pfn_for_page_fault() logic should be folded into
kvm_get_pfn_for_gfn().

>  static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>  				  bool can_unsync)
>  {
> @@ -2085,6 +2124,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
>  	int level;
>  	pfn_t pfn;
>  	unsigned long mmu_seq;
> +	int host_writable;
>  
>  	level = mapping_level(vcpu, gfn);
>  
> @@ -2099,7 +2139,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
>  
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> -	pfn = kvm_get_pfn_for_gfn(vcpu->kvm, gfn);
> +	pfn = kvm_get_pfn_for_page_fault(vcpu->kvm, gfn, write, &host_writable);
>  
>  	/* mmio */
>  	if (is_error_pfn(pfn))
> @@ -2109,7 +2149,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
>  	if (mmu_notifier_retry(vcpu, mmu_seq))
>  		goto out_unlock;
>  	kvm_mmu_free_some_pages(vcpu);
> -	r = __direct_map(vcpu, v, write, level, gfn, pfn, true);
> +	r = __direct_map(vcpu, v, write, level, gfn, pfn, host_writable);
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  
>  
> @@ -2307,6 +2347,8 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
>  	int level;
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	unsigned long mmu_seq;
> +	int write_fault = error_code & PFERR_WRITE_MASK;
> +	int host_writable;
>  
>  	ASSERT(vcpu);
>  	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
> @@ -2321,15 +2363,16 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
>  
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> -	pfn = kvm_get_pfn_for_gfn(vcpu->kvm, gfn);
> +	pfn = kvm_get_pfn_for_page_fault(vcpu->kvm, gfn, write_fault,
> +			&host_writable);
>  	if (is_error_pfn(pfn))
>  		return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);
>  	spin_lock(&vcpu->kvm->mmu_lock);
>  	if (mmu_notifier_retry(vcpu, mmu_seq))
>  		goto out_unlock;
>  	kvm_mmu_free_some_pages(vcpu);
> -	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
> -			 level, gfn, pfn, true);
> +	r = __direct_map(vcpu, gpa, write_fault,
> +			 level, gfn, pfn, host_writable);
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  
>  	return r;
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index a9dbaa0..1874f51 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -430,6 +430,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
>  	pfn_t pfn;
>  	int level = PT_PAGE_TABLE_LEVEL;
>  	unsigned long mmu_seq;
> +	int host_writable;
>  
>  	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
>  	kvm_mmu_audit(vcpu, "pre page fault");
> @@ -461,7 +462,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
>  
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> -	pfn = kvm_get_pfn_for_gfn(vcpu->kvm, walker.gfn);
> +	pfn = kvm_get_pfn_for_page_fault(vcpu->kvm, walker.gfn, write_fault,
> +			&host_writable);
>  
>  	/* mmio */
>  	if (is_error_pfn(pfn))
> @@ -472,7 +474,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
>  		goto out_unlock;
>  	kvm_mmu_free_some_pages(vcpu);
>  	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
> -			     level, &write_pt, pfn, true);
> +			     level, &write_pt, pfn, host_writable);
>  	(void)sptep;
>  	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
>  		 sptep, *sptep, write_pt);
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index 738e659..a4ce19f 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -8,6 +8,7 @@
>  #include <linux/mm.h>
>  #include <linux/vmstat.h>
>  #include <linux/highmem.h>
> +#include <linux/module.h>
>  
>  #include <asm/pgtable.h>
>  
> @@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  
>  	return nr;
>  }
> +EXPORT_SYMBOL_GPL(__get_user_pages_fast);
>  
>  /**
>   * get_user_pages_fast() - pin user pages in memory
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
