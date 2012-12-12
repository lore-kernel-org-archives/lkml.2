Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2LLE0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:26:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab2LLE0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:26:01 -0500
Date: Tue, 11 Dec 2012 23:39:27 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 01/10] kvm: Restrict non-existing slot state
 transitions
Message-ID: <20121212013926.GA7281@amt.cnet>
References: <20121210171417.10461.20079.stgit@bling.home>
 <20121210173245.10461.94547.stgit@bling.home>
 <20121212012909.GC2898@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212012909.GC2898@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 11:29:09PM -0200, Marcelo Tosatti wrote:
> On Mon, Dec 10, 2012 at 10:32:45AM -0700, Alex Williamson wrote:
> > The API documentation states:
> > 
> > 	When changing an existing slot, it may be moved in the guest
> > 	physical memory space, or its flags may be modified.
> > 
> > An "existing slot" requires a non-zero npages (memory_size).  The only
> > transition we should therefore allow for a non-existing slot should be
> > to create the slot, which includes setting a non-zero memory_size.  We
> > currently allow calls to modify non-existing slots, which is pointless,
> > confusing, and possibly wrong.
> > 
> > With this we know that the invalidation path of __kvm_set_memory_region
> > is always for a delete or move and never for adding a zero size slot.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  virt/kvm/kvm_main.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6e8fa7e..e426704 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -753,10 +753,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	new.npages = npages;
> >  	new.flags = mem->flags;
> >  
> > -	/* Disallow changing a memory slot's size. */
> > +	/*
> > +	 * Disallow changing a memory slot's size or changing anything about
> > +	 * zero sized slots that doesn't involve making them non-zero.
> > +	 */
> >  	r = -EINVAL;
> >  	if (npages && old.npages && npages != old.npages)
> >  		goto out_free;
> > +	if (!npages && !old.npages)
> > +		goto out_free;
> 
>         /* General sanity checks */
>         if (mem->memory_size & (PAGE_SIZE - 1))
>                 goto out;
>         if (mem->guest_phys_addr & (PAGE_SIZE - 1))
>                 goto out;
> 
>         if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
>                 goto out;
> 
> If mem->memory_size is zero, then check above fails. 

Err, no read a "<=" while writing that.

> If mem->memory_size > 0, it must be at least PAGE_SIZE, in which case 
> npages == 1.
> 
> Which means the code does not allow changes to non-existing slots.
> Yes?
> 
