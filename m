Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3AHLxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:53:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab3AHLxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:53:11 -0500
Date: Tue, 8 Jan 2013 13:50:26 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: Write protect the updated slot only when we
 start dirty logging
Message-ID: <20130108115026.GA700@redhat.com>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
 <20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
 <20130107201146.GA19224@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107201146.GA19224@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 06:11:46PM -0200, Marcelo Tosatti wrote:
> On Tue, Dec 18, 2012 at 04:26:47PM +0900, Takuya Yoshikawa wrote:
> > This is needed to make kvm_mmu_slot_remove_write_access() rmap based:
> > otherwise we may end up using invalid rmap's.
> > 
> > Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
> 
> Why? memslot->arch.rmap[] has been properly allocated at this point.
> 
FWIW a long time ago in a galaxy far, far away there was a check for
KVM_MEM_LOG_DIRTY_PAGES before call to kvm_mmu_slot_remove_write_access(),
but it was removed by 90cb0529dd230548a7, as far as I can tell, accidentally.

> > ---
> >  arch/x86/kvm/x86.c  |    9 ++++++++-
> >  virt/kvm/kvm_main.c |    1 -
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1c9c834..9451efa 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6897,7 +6897,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  	spin_lock(&kvm->mmu_lock);
> >  	if (nr_mmu_pages)
> >  		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
> > -	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
> > +	/*
> > +	 * Write protect all pages for dirty logging.
> > +	 * Existing largepage mappings are destroyed here and new ones will
> > +	 * not be created until the end of the logging.
> > +	 */
> > +	if ((mem->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
> > +	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES))
> > +		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
> >  	spin_unlock(&kvm->mmu_lock);
> >  	/*
> >  	 * If memory slot is created, or moved, we need to clear all
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index bd31096..0ef5daa 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -805,7 +805,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
> >  		if (kvm_create_dirty_bitmap(&new) < 0)
> >  			goto out_free;
> > -		/* destroy any largepage mappings for dirty tracking */
> >  	}
> >  
> >  	if (!npages || base_gfn != old.base_gfn) {
> > -- 
> > 1.7.5.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
