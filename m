Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423873Ab2LGScM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423749Ab2LGScK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:32:10 -0500
Message-ID: <1354905128.3224.98.camel@bling.home>
Subject: Re: [PATCH 02/10] kvm: Check userspace_addr when modifying a memory
 slot
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mtosatti@redhat.com, gleb@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Fri, 07 Dec 2012 11:32:08 -0700
In-Reply-To: <20121207181725.GB13053@redhat.com>
References: <20121206214722.24968.6043.stgit@bling.home>
	 <20121206222037.24968.13698.stgit@bling.home>
	 <20121207181725.GB13053@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 13:17 -0500, Jason Baron wrote:
> On Thu, Dec 06, 2012 at 03:20:37PM -0700, Alex Williamson wrote:
> > The API documents that only flags and guest physical memory space can
> > be modified on an existing slot, but we don't enforce that the
> > userspace address cannot be modified.  Instead we just ignore it.
> > This means that a user may think they've successfully moved both the
> > guest and user addresses, when in fact only the guest address changed.
> > Check and error instead.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  virt/kvm/kvm_main.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index e426704..93213e1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -779,13 +779,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  
> >  	r = -ENOMEM;
> >  
> > -	/* Allocate if a slot is being created */
> > +	/*
> > +	 * Allocate if a slot is being created.  If modifying a slot,
> > +	 * the userspace_addr cannot change.
> > +	 */
> >  	if (!old.npages) {
> >  		new.user_alloc = user_alloc;
> >  		new.userspace_addr = mem->userspace_addr;
> >  
> >  		if (kvm_arch_create_memslot(&new, npages))
> >  			goto out_free;
> > +	} else if (mem->userspace_addr != old.userspace_addr) {
> > +		r = -EINVAL;
> > +		goto out_free;
> >  	}
> >  
> >  	/* Allocate page dirty bitmap if needed */
> > 
> 
> hmmm...does this mean that on a 'destroy', where npages is 0, the user
> has to set up userspace_addr correctly? If so, that would appear to be
> an unwanted change in semantics here.

Good point, it does change that.  We could make this be (npages &&
mem->userspace_addr != old.userspace_addr) to avoid that case.  Thanks,

Alex

