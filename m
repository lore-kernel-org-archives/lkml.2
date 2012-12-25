Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2LYEIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 23:08:14 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:48670 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2LYEIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 23:08:11 -0500
Date: Tue, 25 Dec 2012 13:08:40 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Gleb Natapov <gleb@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: Write protect the updated slot only when we
 start dirty logging
Message-Id: <20121225130840.74996653.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20121224132717.GW17584@redhat.com>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121224132717.GW17584@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2012 15:27:17 +0200
Gleb Natapov <gleb@redhat.com> wrote:

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
> We should not check old slot flags here or at least check that
> old.npages is not zero. Userspace may delete a slot using old flags,
> then, if new memslot is created with dirty log enabled, it will not be
> protected.

The flag, KVM_MEM_LOG_DIRTY_PAGES, is explicitely cleared when we
delete a slot to free dirty_bitmap:

	if (!npages)
		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;

So when old.npages is not zero, the second condition must be true.

Other parts are doing "if (!slot->dirty_bitmap)" to see if the slot
is in dirty logging mode.  If you prefer, we can do the same here.

Thanks,
	Takuya
