Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0GFLXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab0GFLXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:23:06 -0400
Date: Tue, 6 Jul 2010 14:22:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 4/9] KVM: MMU: introduce gfn_to_pfn_atomic() function
Message-ID: <20100706112259.GV4689@redhat.com>
References: <4C330918.6040709@cn.fujitsu.com>
 <4C3309D3.6010109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3309D3.6010109@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 06:47:47PM +0800, Xiao Guangrong wrote:
> Introduce gfn_to_pfn_atomic(), it's the fast path and can used in atomic
> context, the later patch will use it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/linux/kvm_host.h |    1 +
>  virt/kvm/kvm_main.c      |   32 +++++++++++++++++++++++++-------
>  2 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e796326..e0fb543 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -295,6 +295,7 @@ void kvm_release_page_dirty(struct page *page);
>  void kvm_set_page_dirty(struct page *page);
>  void kvm_set_page_accessed(struct page *page);
>  
> +pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
>  pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
>  pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
>  			 struct kvm_memory_slot *slot, gfn_t gfn);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a60b6b0..5467fe5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -934,19 +934,25 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_hva);
>  
> -static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
> +static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic)
>  {
>  	struct page *page[1];
>  	int npages;
>  	pfn_t pfn;
>  
> -	might_sleep();
> -
> -	npages = get_user_pages_fast(addr, 1, 1, page);
> +	if (atomic)
> +		npages = __get_user_pages_fast(addr, 1, 1, page);
> +	else {
> +		might_sleep();
> +		npages = get_user_pages_fast(addr, 1, 1, page);
> +	}
>  
>  	if (unlikely(npages != 1)) {
>  		struct vm_area_struct *vma;
>  
> +		if (atomic)
> +			goto return_bad_page;
> +
You are skipping hwpoison test and sometimes you will return bad_page
for something that returns good pfn now without caller even know.
vma->vm_flags & VM_PFNMAP comes to mind. Is this safe?

>  		down_read(&current->mm->mmap_sem);
>  		if (is_hwpoison_address(addr)) {
>  			up_read(&current->mm->mmap_sem);
> @@ -959,6 +965,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
>  		if (vma == NULL || addr < vma->vm_start ||
>  		    !(vma->vm_flags & VM_PFNMAP)) {
>  			up_read(&current->mm->mmap_sem);
> +return_bad_page:
>  			get_page(bad_page);
>  			return page_to_pfn(bad_page);
>  		}
> @@ -972,7 +979,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
>  	return pfn;
>  }
>  
> -pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
> +pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic)
>  {
>  	unsigned long addr;
>  
> @@ -982,7 +989,18 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
>  		return page_to_pfn(bad_page);
>  	}
>  
> -	return hva_to_pfn(kvm, addr);
> +	return hva_to_pfn(kvm, addr, atomic);
> +}
> +
> +pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
> +{
> +	return __gfn_to_pfn(kvm, gfn, true);
> +}
> +EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
> +
> +pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
> +{
> +	return __gfn_to_pfn(kvm, gfn, false);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn);
>  
> @@ -990,7 +1008,7 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
>  			 struct kvm_memory_slot *slot, gfn_t gfn)
>  {
>  	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
> -	return hva_to_pfn(kvm, addr);
> +	return hva_to_pfn(kvm, addr, false);
>  }
>  
>  struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
> -- 
> 1.6.1.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
