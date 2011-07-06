Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1GFRj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1GFRj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:39:26 -0400
Date: Wed, 6 Jul 2011 14:17:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/19] KVM: MMU: filter out the mmio pfn from the
 fault pfn
Message-ID: <20110706171734.GD24417@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C32A6.6080607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0C32A6.6080607@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:24:06PM +0800, Xiao Guangrong wrote:
> If the page fault is caused by mmio, the gfn can not be found in memslots, and
> 'bad_pfn' is returned on gfn_to_hva path, so we can use 'bad_pfn' to identify
> the mmio page fault.
> And, to clarify the meaning of mmio pfn, we return fault page instead of bad
> page when the gfn is not allowd to prefetch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c       |    4 ++--
>  include/linux/kvm_host.h |    5 +++++
>  virt/kvm/kvm_main.c      |   16 ++++++++++++++--
>  3 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 5334b4e..96a7ed4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2085,8 +2085,8 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
>  
>  	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
>  	if (!slot) {
> -		get_page(bad_page);
> -		return page_to_pfn(bad_page);
> +		get_page(fault_page);
> +		return page_to_pfn(fault_page);
>  	}
>  
>  	hva = gfn_to_hva_memslot(slot, gfn);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 31ebb59..3e548e8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -326,12 +326,17 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
>  static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
>  
>  extern struct page *bad_page;
> +extern struct page *fault_page;
> +
>  extern pfn_t bad_pfn;
> +extern pfn_t fault_pfn;
>  
>  int is_error_page(struct page *page);
>  int is_error_pfn(pfn_t pfn);
>  int is_hwpoison_pfn(pfn_t pfn);
>  int is_fault_pfn(pfn_t pfn);
> +int is_mmio_pfn(pfn_t pfn);
> +int is_invalid_pfn(pfn_t pfn);
>  int kvm_is_error_hva(unsigned long addr);
>  int kvm_set_memory_region(struct kvm *kvm,
>  			  struct kvm_userspace_memory_region *mem,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 11d2783..c7d41d4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -101,8 +101,8 @@ static bool largepages_enabled = true;
>  static struct page *hwpoison_page;
>  static pfn_t hwpoison_pfn;
>  
> -static struct page *fault_page;
> -static pfn_t fault_pfn;
> +struct page *fault_page;
> +pfn_t fault_pfn;
>  
>  inline int kvm_is_mmio_pfn(pfn_t pfn)
>  {
> @@ -931,6 +931,18 @@ int is_fault_pfn(pfn_t pfn)
>  }
>  EXPORT_SYMBOL_GPL(is_fault_pfn);
>  
> +int is_mmio_pfn(pfn_t pfn)
> +{
> +	return pfn == bad_pfn;
> +}
> +EXPORT_SYMBOL_GPL(is_mmio_pfn);

Please use another name this conflicts with real mmio pfn,
see kvm_is_mmio_pfn. "noslot_pfn" is meaningful to me.

