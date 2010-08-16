Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0HPPox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0HPPov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:44:51 -0400
Date: Mon, 16 Aug 2010 12:43:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 3/3] KVM: MMU: prefetch ptes when intercepted guest #PF
Message-ID: <20100816154343.GA10363@amt.cnet>
References: <4C58DE49.1020705@cn.fujitsu.com>
 <4C58DF26.3060305@cn.fujitsu.com>
 <4C58DF89.4080404@cn.fujitsu.com>
 <20100805143850.GA1648@amt.cnet>
 <4C689653.2000400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C689653.2000400@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 09:37:23AM +0800, Xiao Guangrong wrote:
> Hi Marcelo,
> 
> Thanks for your review and sorry for the delay reply.
> 
> Marcelo Tosatti wrote:
> 
> >> +static struct kvm_memory_slot *
> >> +pte_prefetch_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
> >> +{
> >> +	struct kvm_memory_slot *slot;
> >> +
> >> +	slot = gfn_to_memslot(vcpu->kvm, gfn);
> >> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
> >> +	      (no_dirty_log && slot->dirty_bitmap))
> >> +		slot = NULL;
> > 
> > Why is this no_dirty_log optimization worthwhile?
> > 
> 
> We disable prefetch the writable pages since 'pte prefetch' will hurt slot's
> dirty page tracking that it set the dirty_bitmap bit but the corresponding page
> is not really accessed.
> 
> >> +
> >> +	return slot;
> >> +}
> >> +
> >> +static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
> >> +				     bool no_dirty_log)
> >> +{
> >> +	struct kvm_memory_slot *slot;
> >> +	unsigned long hva;
> >> +
> >> +	slot = pte_prefetch_gfn_to_memslot(vcpu, gfn, no_dirty_log);
> >> +	if (!slot) {
> >> +		get_page(bad_page);
> >> +		return page_to_pfn(bad_page);
> >> +	}
> >> +
> >> +	hva = gfn_to_hva_memslot(slot, gfn);
> >> +
> >> +	return hva_to_pfn_atomic(vcpu->kvm, hva);
> >> +}
> >> +
> >> +static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
> >> +				    struct kvm_mmu_page *sp,
> >> +				    u64 *start, u64 *end)
> >> +{
> >> +	struct page *pages[PTE_PREFETCH_NUM];
> >> +	struct kvm_memory_slot *slot;
> >> +	unsigned hva, access = sp->role.access;
> >> +	int i, ret, npages = end - start;
> >> +	gfn_t gfn;
> >> +
> >> +	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
> >> +	slot = pte_prefetch_gfn_to_memslot(vcpu, gfn, access & ACC_WRITE_MASK);
> >> +	if (!slot || slot->npages - (gfn - slot->base_gfn) != npages)
> >> +		return -1;
> >> +
> >> +	hva = gfn_to_hva_memslot(slot, gfn);
> >> +	ret = __get_user_pages_fast(hva, npages, 1, pages);
> >> +	if (ret <= 0)
> >> +		return -1;
> > 
> > Better do one at a time with hva_to_pfn_atomic. Or, if you measure that
> > its worthwhile, do on a separate patch (using a helper as discussed
> > previously).
> > 
> 
> Since it should disable 'prefetch' for the writable pages, so i'm not put these
> operations into a common function and define it in kvm_main.c file.
> 
> Maybe we do better do these in a wrap function named pte_prefetch_gfn_to_pages()?

Yes, please have it as a common function in kvm_main.c.

