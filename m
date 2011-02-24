Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1BXKjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:39:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab1BXKjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:39:22 -0500
Message-ID: <4D663552.7070105@redhat.com>
Date: Thu, 24 Feb 2011 12:39:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
Subject: Re: [RFC PATCH 2/3] kvm: Allow memory slot array to grow on demand
References: <20110222183822.22026.62832.stgit@s20.home> <20110222185512.22026.88579.stgit@s20.home>
In-Reply-To: <20110222185512.22026.88579.stgit@s20.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 08:55 PM, Alex Williamson wrote:
> Remove fixed KVM_MEMORY_SLOTS limit, allowing the slot array
> to grow on demand.  Private slots are now allocated at the
> front instead of the end.  Only x86 seems to use private slots,
> so this is now zero for all other archs.  The memslots pointer
> is already updated using rcu, so changing the size off the
> array when it's replaces is straight forward.  x86 also keeps
> a bitmap of slots used by a kvm_mmu_page, which requires a
> shadow tlb flush whenever we increase the number of slots.
> This forces the pages to be rebuilt with the new bitmap size.
>
>
>
>   #define KVM_PIO_PAGE_OFFSET 1
>   #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
> @@ -207,7 +206,7 @@ struct kvm_mmu_page {
>   	 * One bit set per slot which has memory
>   	 * in this shadow page.
>   	 */
> -	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
> +	unsigned long *slot_bitmap;

What about

     union {
           DECLARE_BITMAP(direct_slot_bitmap, BITS_PER_LONG);
           unsigned long *indirect_slot_bitmap;
     };

to make the hackery below more explicit?

>
>   static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>   {
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +
>   	ASSERT(is_empty_shadow_page(sp->spt));
>   	hlist_del(&sp->hash_link);
>   	list_del(&sp->link);
> +	if (unlikely(slots->nmemslots>  sizeof(sp->slot_bitmap) * 8))
> +		kfree(sp->slot_bitmap);
>   	__free_page(virt_to_page(sp->spt));
>   	if (!sp->role.direct)
>   		__free_page(virt_to_page(sp->gfns));
> @@ -1048,6 +1052,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
>   					       u64 *parent_pte, int direct)
>   {
>   	struct kvm_mmu_page *sp;
> +	struct kvm_memslots *slots = kvm_memslots(vcpu->kvm);
>
>   	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
>   	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
> @@ -1056,7 +1061,16 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
>   						  PAGE_SIZE);
>   	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>   	list_add(&sp->link,&vcpu->kvm->arch.active_mmu_pages);
> -	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
> +
> +	if (unlikely(slots->nmemslots>  sizeof(sp->slot_bitmap) * 8)) {
> +		sp->slot_bitmap = kzalloc(sizeof(long) *
> +					  BITS_TO_LONGS(slots->nmemslots),
> +					  GFP_KERNEL);
> +		if (!sp->slot_bitmap)
> +			return NULL;

We don't support failing kvm_mmu_get_page().  See 
mmu_memory_cache_alloc() and mmu_topup_memory_caches().

> +	} else
> +		bitmap_zero((void *)&sp->slot_bitmap, slots->nmemslots);
> +
>



>
>   static void mmu_convert_notrap(struct kvm_mmu_page *sp)
> @@ -3530,13 +3548,19 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
>   void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
>   {
>   	struct kvm_mmu_page *sp;
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
>
>   	list_for_each_entry(sp,&kvm->arch.active_mmu_pages, link) {
>   		int i;
>   		u64 *pt;
>
> -		if (!test_bit(slot, sp->slot_bitmap))
> -			continue;
> +		if (likely(slots->nmemslots<= sizeof(sp->slot_bitmap) * 8)) {
> +			if (!test_bit(slot, (void *)&sp->slot_bitmap))
> +				continue;
> +		} else {
> +			if (!test_bit(slot, sp->slot_bitmap))
> +				continue;
> +		}

That likely() would fail 100% for certain guests.

Neater to write

     slot_bitmap = sp_slot_bitmap(sp);
     if (!test_bit(slot, sp_slot_bitmap))
         continue;

> +
> +/*
> + * Protect from malicious userspace by putting an upper bound on the number
> + * of memory slots.  This is an arbitrarily large number that still allows
> + * us to make pseudo-guarantees about supporting 64 assigned devices with
> + * plenty of slots left over.
> + */
> +#ifndef KVM_MAX_MEM_SLOTS
> + #define KVM_MAX_MEM_SLOTS 512
> +#endif

The increase should be in a separate patch (after we optimize the 
search-fail case).

>
>   	if (!npages) {
>   		r = -ENOMEM;
> -		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
> +
> +		nmemslots = (mem->slot>= kvm->memslots->nmemslots) ?
> +			    mem->slot + 1 : kvm->memslots->nmemslots;
> +
> +		slots = kzalloc(sizeof(struct kvm_memslots) +
> +				nmemslots * sizeof(struct kvm_memory_slot),
> +				GFP_KERNEL);
>   		if (!slots)
>   			goto out_free;
> -		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
> -		if (mem->slot>= slots->nmemslots)
> -			slots->nmemslots = mem->slot + 1;
> +		memcpy(slots, kvm->memslots,
> +		       sizeof(struct kvm_memslots) + kvm->memslots->nmemslots *
> +		       sizeof(struct kvm_memory_slot));
> +		slots->nmemslots = nmemslots;
>   		slots->generation++;
>   		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
>
> @@ -787,12 +797,21 @@ skip_lpage:
>   	}
>
>   	r = -ENOMEM;
> -	slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
> +
> +	if (mem->slot>= kvm->memslots->nmemslots) {
> +		nmemslots = mem->slot + 1;
> +		flush = true;

Isn't flush here a little too agressive?  Shouldn't we flush only if we 
cross the BITS_PER_LONG threshold?

> +	} else
> +		nmemslots = kvm->memslots->nmemslots;
> +
> +	slots = kzalloc(sizeof(struct kvm_memslots) +
> +			nmemslots * sizeof(struct kvm_memory_slot),
> +			GFP_KERNEL);

Code duplication -> helper.

>   	if (!slots)
>   		goto out_free;
> -	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
> -	if (mem->slot>= slots->nmemslots)
> -		slots->nmemslots = mem->slot + 1;
> +	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots) +
> +	       kvm->memslots->nmemslots * sizeof(struct kvm_memory_slot));
> +	slots->nmemslots = nmemslots;
>   	slots->generation++;
>
>   	/* actual memory is freed via old in kvm_free_physmem_slot below */
> @@ -808,6 +827,9 @@ skip_lpage:
>   	rcu_assign_pointer(kvm->memslots, slots);
>   	synchronize_srcu_expedited(&kvm->srcu);
>
> +	if (flush)
> +		kvm_arch_flush_shadow(kvm);
> +

Need to flush before rcu_assign_pointer() so kvm_mmu_free_page() sees 
the old slot count.

But even that is insufficient since we'll create direct and indirect 
slot bitmaps concurrently.  Need to store whether the bitmap is direct 
or not in kvm_mmu_page.

> @@ -1832,6 +1854,8 @@ static long kvm_vm_ioctl(struct file *filp,
>   						sizeof kvm_userspace_mem))
>   			goto out;
>
> +		kvm_userspace_mem.slot += KVM_PRIVATE_MEM_SLOTS;
> +

Slightly uneasy about this, but no real objection.

-- 
error compiling committee.c: too many arguments to function

