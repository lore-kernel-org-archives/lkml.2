Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0HPBlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 21:41:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51752 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab0HPBlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 21:41:46 -0400
Message-ID: <4C689653.2000400@cn.fujitsu.com>
Date: Mon, 16 Aug 2010 09:37:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 3/3] KVM: MMU: prefetch ptes when intercepted guest
 #PF
References: <4C58DE49.1020705@cn.fujitsu.com> <4C58DF26.3060305@cn.fujitsu.com> <4C58DF89.4080404@cn.fujitsu.com> <20100805143850.GA1648@amt.cnet>
In-Reply-To: <20100805143850.GA1648@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

Thanks for your review and sorry for the delay reply.

Marcelo Tosatti wrote:

>> +static struct kvm_memory_slot *
>> +pte_prefetch_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
>> +{
>> +	struct kvm_memory_slot *slot;
>> +
>> +	slot = gfn_to_memslot(vcpu->kvm, gfn);
>> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
>> +	      (no_dirty_log && slot->dirty_bitmap))
>> +		slot = NULL;
> 
> Why is this no_dirty_log optimization worthwhile?
> 

We disable prefetch the writable pages since 'pte prefetch' will hurt slot's
dirty page tracking that it set the dirty_bitmap bit but the corresponding page
is not really accessed.

>> +
>> +	return slot;
>> +}
>> +
>> +static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
>> +				     bool no_dirty_log)
>> +{
>> +	struct kvm_memory_slot *slot;
>> +	unsigned long hva;
>> +
>> +	slot = pte_prefetch_gfn_to_memslot(vcpu, gfn, no_dirty_log);
>> +	if (!slot) {
>> +		get_page(bad_page);
>> +		return page_to_pfn(bad_page);
>> +	}
>> +
>> +	hva = gfn_to_hva_memslot(slot, gfn);
>> +
>> +	return hva_to_pfn_atomic(vcpu->kvm, hva);
>> +}
>> +
>> +static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
>> +				    struct kvm_mmu_page *sp,
>> +				    u64 *start, u64 *end)
>> +{
>> +	struct page *pages[PTE_PREFETCH_NUM];
>> +	struct kvm_memory_slot *slot;
>> +	unsigned hva, access = sp->role.access;
>> +	int i, ret, npages = end - start;
>> +	gfn_t gfn;
>> +
>> +	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
>> +	slot = pte_prefetch_gfn_to_memslot(vcpu, gfn, access & ACC_WRITE_MASK);
>> +	if (!slot || slot->npages - (gfn - slot->base_gfn) != npages)
>> +		return -1;
>> +
>> +	hva = gfn_to_hva_memslot(slot, gfn);
>> +	ret = __get_user_pages_fast(hva, npages, 1, pages);
>> +	if (ret <= 0)
>> +		return -1;
> 
> Better do one at a time with hva_to_pfn_atomic. Or, if you measure that
> its worthwhile, do on a separate patch (using a helper as discussed
> previously).
> 

Since it should disable 'prefetch' for the writable pages, so i'm not put these
operations into a common function and define it in kvm_main.c file.

Maybe we do better do these in a wrap function named pte_prefetch_gfn_to_pages()?

>> @@ -302,14 +303,87 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>  static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
>>  				struct guest_walker *gw, int level)
>>  {
>> -	int r;
>>  	pt_element_t curr_pte;
>> -
>> -	r = kvm_read_guest_atomic(vcpu->kvm, gw->pte_gpa[level - 1],
>> +	gpa_t base_gpa, pte_gpa = gw->pte_gpa[level - 1];
>> +	u64 mask;
>> +	int r, index;
>> +
>> +	if (level == PT_PAGE_TABLE_LEVEL) {
>> +		mask = PTE_PREFETCH_NUM * sizeof(pt_element_t) - 1;
>> +		base_gpa = pte_gpa & ~mask;
>> +		index = (pte_gpa - base_gpa) / sizeof(pt_element_t);
>> +
>> +		r = kvm_read_guest_atomic(vcpu->kvm, base_gpa,
>> +				gw->prefetch_ptes, sizeof(gw->prefetch_ptes));
>> +		curr_pte = gw->prefetch_ptes[index];
> 
> This can slowdown a single non-prefetchable pte fault. Maybe its
> irrelevant, but please have kvm_read_guest_atomic in the first patch and
> then later optimize, its easier to review and bisectable.
> 

OK, i'll separate it.

