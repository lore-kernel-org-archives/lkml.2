Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2LLEaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:30:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab2LLEax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:30:53 -0500
Message-ID: <1355286652.3224.199.camel@bling.home>
Subject: Re: [PATCH v2 01/10] kvm: Restrict non-existing slot state
 transitions
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 11 Dec 2012 21:30:52 -0700
In-Reply-To: <20121212013926.GA7281@amt.cnet>
References: <20121210171417.10461.20079.stgit@bling.home>
	 <20121210173245.10461.94547.stgit@bling.home>
	 <20121212012909.GC2898@amt.cnet> <20121212013926.GA7281@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 23:39 -0200, Marcelo Tosatti wrote:
> On Tue, Dec 11, 2012 at 11:29:09PM -0200, Marcelo Tosatti wrote:
> > On Mon, Dec 10, 2012 at 10:32:45AM -0700, Alex Williamson wrote:
> > > The API documentation states:
> > > 
> > > 	When changing an existing slot, it may be moved in the guest
> > > 	physical memory space, or its flags may be modified.
> > > 
> > > An "existing slot" requires a non-zero npages (memory_size).  The only
> > > transition we should therefore allow for a non-existing slot should be
> > > to create the slot, which includes setting a non-zero memory_size.  We
> > > currently allow calls to modify non-existing slots, which is pointless,
> > > confusing, and possibly wrong.
> > > 
> > > With this we know that the invalidation path of __kvm_set_memory_region
> > > is always for a delete or move and never for adding a zero size slot.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > >  virt/kvm/kvm_main.c |    9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 6e8fa7e..e426704 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -753,10 +753,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >  	new.npages = npages;
> > >  	new.flags = mem->flags;
> > >  
> > > -	/* Disallow changing a memory slot's size. */
> > > +	/*
> > > +	 * Disallow changing a memory slot's size or changing anything about
> > > +	 * zero sized slots that doesn't involve making them non-zero.
> > > +	 */
> > >  	r = -EINVAL;
> > >  	if (npages && old.npages && npages != old.npages)
> > >  		goto out_free;
> > > +	if (!npages && !old.npages)
> > > +		goto out_free;
> > 
> >         /* General sanity checks */
> >         if (mem->memory_size & (PAGE_SIZE - 1))
> >                 goto out;
> >         if (mem->guest_phys_addr & (PAGE_SIZE - 1))
> >                 goto out;
> > 
> >         if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
> >                 goto out;
> > 
> > If mem->memory_size is zero, then check above fails. 
> 
> Err, no read a "<=" while writing that.

;)  Thanks for the double check,

Alex

> > If mem->memory_size > 0, it must be at least PAGE_SIZE, in which case 
> > npages == 1.
> > 
> > Which means the code does not allow changes to non-existing slots.
> > Yes?
> > 



