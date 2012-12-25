Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2LYFGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 00:06:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2LYFF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 00:05:59 -0500
Date: Tue, 25 Dec 2012 07:05:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: Write protect the updated slot only when we
 start dirty logging
Message-ID: <20121225050555.GD29007@redhat.com>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
 <20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
 <20121224132717.GW17584@redhat.com>
 <20121225130840.74996653.yoshikawa_takuya_b1@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121225130840.74996653.yoshikawa_takuya_b1@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 01:08:40PM +0900, Takuya Yoshikawa wrote:
> On Mon, 24 Dec 2012 15:27:17 +0200
> Gleb Natapov <gleb@redhat.com> wrote:
> 
> > > @@ -6897,7 +6897,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> > >  	spin_lock(&kvm->mmu_lock);
> > >  	if (nr_mmu_pages)
> > >  		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
> > > -	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
> > > +	/*
> > > +	 * Write protect all pages for dirty logging.
> > > +	 * Existing largepage mappings are destroyed here and new ones will
> > > +	 * not be created until the end of the logging.
> > > +	 */
> > > +	if ((mem->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
> > > +	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES))
> > > +		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
> > We should not check old slot flags here or at least check that
> > old.npages is not zero. Userspace may delete a slot using old flags,
> > then, if new memslot is created with dirty log enabled, it will not be
> > protected.
> 
> The flag, KVM_MEM_LOG_DIRTY_PAGES, is explicitely cleared when we
> delete a slot to free dirty_bitmap:
> 
> 	if (!npages)
> 		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> 
> So when old.npages is not zero, the second condition must be true.
> 
Right. I was looking for where it is cleared and missed that.

> Other parts are doing "if (!slot->dirty_bitmap)" to see if the slot
> is in dirty logging mode.  If you prefer, we can do the same here.
> 
Does not matter to me. If you think it will be more consistent do it.

--
			Gleb.
