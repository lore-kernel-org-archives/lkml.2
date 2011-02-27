Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1B0JpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 04:45:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1B0Jo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 04:44:57 -0500
Message-ID: <4D6A1D11.2060008@redhat.com>
Date: Sun, 27 Feb 2011 11:44:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
Subject: Re: [RFC PATCH 2/3] kvm: Allow memory slot array to grow on demand
References: <20110222183822.22026.62832.stgit@s20.home>	 <20110222185512.22026.88579.stgit@s20.home>  <4D663552.7070105@redhat.com> <1298570896.6140.35.camel@x201>
In-Reply-To: <1298570896.6140.35.camel@x201>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 08:08 PM, Alex Williamson wrote:
> >  >  @@ -207,7 +206,7 @@ struct kvm_mmu_page {
> >  >    	* One bit set per slot which has memory
> >  >    	* in this shadow page.
> >  >    	*/
> >  >  -	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
> >  >  +	unsigned long *slot_bitmap;
> >
> >  What about
> >
> >       union {
> >             DECLARE_BITMAP(direct_slot_bitmap, BITS_PER_LONG);
> >             unsigned long *indirect_slot_bitmap;
> >       };
> >
> >  to make the hackery below more explicit?
>
> Yeah, it need something to make the hackery go down easier.  I was
> actually thinking about:
>
> 	unsigned long *slot_bitmap;
> 	DECLARE_BITMAP(direct_slot_bitmap, BITS_PER_LONG);
>
> Where we'd then just set:
>
> 	slot_bitmap =&direct_slot_bitmap;
>
> It wastes 8 bytes, and pushes the cache a little harder, but still helps
> the locality and makes the usage more consistent.

    unsigned long *sp_slot_bitmap(struct kvm_mmu_page *sp) { ... }

gives you the best of both worlds.

> >
> >  We don't support failing kvm_mmu_get_page().  See
> >  mmu_memory_cache_alloc() and mmu_topup_memory_caches().
>
> Hmm, apparently my search stopped at __direct_map() calling
> kvm_mmu_get_page() and handling an error.

That's dead code (was there from the very first commit into mmu.c).

> >  >
> >  >    	r = -ENOMEM;
> >  >  -	slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
> >  >  +
> >  >  +	if (mem->slot>= kvm->memslots->nmemslots) {
> >  >  +		nmemslots = mem->slot + 1;
> >  >  +		flush = true;
> >
> >  Isn't flush here a little too agressive?  Shouldn't we flush only if we
> >  cross the BITS_PER_LONG threshold?
>
> Perhaps, but is that overly exploiting our knowledge about the bitmap
> implementation?  I figured better to error too aggressively than too
> lazy since this is a rare event already.

I'm worried about the screen-clearing using the vga window at 
0xa[08]000.  If that works without too much flushing, then we're fine.

On second thoughts we're likely fine even if we do flush, since it's in 
a tight loop so it takes very little work to reestablish the dropped sptes.

> >  >  @@ -1832,6 +1854,8 @@ static long kvm_vm_ioctl(struct file *filp,
> >  >    						sizeof kvm_userspace_mem))
> >  >    			goto out;
> >  >
> >  >  +		kvm_userspace_mem.slot += KVM_PRIVATE_MEM_SLOTS;
> >  >  +
> >
> >  Slightly uneasy about this, but no real objection.
>
> If you have better ideas, let me know.  This reminds me to ask about
> this chunk:
>
> @@ -671,7 +674,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>
>          /* Check for overlaps */
>          r = -EEXIST;
> -       for (i = 0; i<  KVM_MEMORY_SLOTS; ++i) {
> +       for (i = KVM_PRIVATE_MEM_SLOTS; i<  kvm->memslots->nmemslots; ++i) {
>                  struct kvm_memory_slot *s =&kvm->memslots->memslots[i];
>
>                  if (s == memslot || !s->npages)
>
> I kept the same behavior as previous, but it highlights that we're not
> checking for overlaps between private slots and anything else.  Existing
> bug?  Thanks,

Yes, possibly serious.  Who knows what happens if we create a page using 
one slot and remove it via another?

Let's go write some Visual Basic.

-- 
error compiling committee.c: too many arguments to function

