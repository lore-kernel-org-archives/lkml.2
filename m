Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030897Ab2CFPDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:03:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030791Ab2CFPDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:03:51 -0500
Date: Tue, 6 Mar 2012 12:01:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less get_dirty_log()
Message-ID: <20120306150104.GA3041@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
 <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
 <20120303142148.2689454b30dc86d84c4a19f5@gmail.com>
 <20120306111540.GA29914@amt.cnet>
 <20120306234317.2817d2071038d11ab3831c82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306234317.2817d2071038d11ab3831c82@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 11:43:17PM +0900, Takuya Yoshikawa wrote:
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> > > +	spin_lock(&kvm->mmu_lock);
> > 
> > It is not clear why mmu_lock is needed. Dropping it across the xchg loop
> > should be similar to srcu implementation, in that concurrent updates
> > will be visible only on the next get_dirty call? Well, it is necessary
> > anyway for write protecting the sptes.
> 
> My implementation does write protection inside the xchg loop.
> Then, after that loop, flushes TLB.
> 
> mmu_lock must protect both of these together.
> 
> If we do not mind scanning the bitmap twice, we can decouple the
> xchg loop and write protection, but it will be a bit slower, and in
> any case we need to hold mmu_lock until TLB is flushed.

Why is it necessary to scan twice? Simply continuing to the next set 
of pages, after dropping the lock, should be enough.

The potential problem i am referring to is:

- kvm.git next + srcu-less series
average(ns)    stdev     ns/page    pages    improvement(%)

8497356.4    16441.0        32.4     256K     -29

So 8ms for 1GB. Assuming it increases linearly, it would take 
400ms for get_dirty on a 50GB slot (most of that time spent 
with mmu_lock held). Is this correct?

> As can be seen from the unit-test result the majority of time
> is being spent on write protecting sptes, so decoupling xchg loop
> alone will not alleviate the problem so much -- my guess.
> 
> > A cond_resched_lock() would alleviate the potentially long held 
> > times for mmu_lock (can you measure it with large memslots?)
> 
> How to move TLB flush out of mmu_lock critical sections was discussed
> before, and there seemed to be some proposals.
> 
> Anyone is working on that?
> 
> After that we can do many things.
> 
> One idea is to make the extra bitmap buffer size shrink to one page
> or so and do xchg and write protection loop by that limited size.
> 
> Because we can drop mmu_lock, it is possible to copy_to_user part of
> the dirty bitmap, and then go to the next part.
> 
> After everything is protected, we can then do TLB flush after dropping
> mmu_lock.
> 
> > Otherwise looks nice.
> 
> Thanks,
> 	Takuya
> 
> 
> > > -		r = -ENOMEM;
> > > -		slots = kmemdup(kvm->memslots, sizeof(*kvm->memslots), GFP_KERNEL);
> > > -		if (!slots)
> > > -			goto out;
> > > +	for (i = 0; i < n / sizeof(long); i++) {
> > > +		unsigned long mask;
> > > +		gfn_t offset;
> > >  
> > > -		memslot = id_to_memslot(slots, log->slot);
> > > -		memslot->nr_dirty_pages = 0;
> > > -		memslot->dirty_bitmap = dirty_bitmap_head;
> > > -		update_memslots(slots, NULL);
> > > +		if (!dirty_bitmap[i])
> > > +			continue;
> > >  
> > > -		old_slots = kvm->memslots;
> > > -		rcu_assign_pointer(kvm->memslots, slots);
> > > -		synchronize_srcu_expedited(&kvm->srcu);
> > > -		kfree(old_slots);
> > > +		is_dirty = true;
> > >  
> > > -		write_protect_slot(kvm, memslot, dirty_bitmap, nr_dirty_pages);
> > > +		mask = xchg(&dirty_bitmap[i], 0);
> > > +		dirty_bitmap_buffer[i] = mask;
> > >  
> > > -		r = -EFAULT;
> > > -		if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n))
> > > -			goto out;
> > > -	} else {
> > > -		r = -EFAULT;
> > > -		if (clear_user(log->dirty_bitmap, n))
> > > -			goto out;
> > > +		offset = i * BITS_PER_LONG;
> > > +		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
> > >  	}
> > > +	if (is_dirty)
> > > +		kvm_flush_remote_tlbs(kvm);
> > > +
> > > +	spin_unlock(&kvm->mmu_lock);
