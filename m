Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2HVIYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:24:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab2HVIYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:24:33 -0400
Date: Wed, 22 Aug 2012 11:25:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/2] kvm: level irqfd support
Message-ID: <20120822082535.GA10680@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
 <20120822003129.GK9027@redhat.com>
 <1345598895.29292.115.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345598895.29292.115.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 07:28:15PM -0600, Alex Williamson wrote:
> On Wed, 2012-08-22 at 03:31 +0300, Michael S. Tsirkin wrote:
> > On Tue, Aug 21, 2012 at 01:28:57PM -0600, Alex Williamson wrote:
> > > Here's the much anticipated re-write of support for level irqfds.  As
> > > Michael suggested, I've rolled the eoi/ack notification fd into
> > > KVM_IRQFD as a new mode.  For lack of a better name, as there seems to
> > > be objections to associating this specifically with an EOI or an ACK,
> > > I've name this OADN or "On Ack, De-assert & Notify".
> > > 
> > > Patch 1of2 switches current KVM_IRQFDs to use their own IRQ source ID
> > > since we're potentially stepping on KVM_USERSPACE_IRQ_SOURCE_ID.
> > > Unfurtunately I was not able to make 2of2 use a single IRQ source ID,
> > > the reason is it's racy.  Objects to track OADNs are made dynamically,
> > > we look through existing ones for a match under spinlock and setup a
> > > new one if there's no match.  On teardown, we can remove the OADN from
> > > the list under lock, but that same lock prevents us from de-assigning
> > > the IRQ ACK notifier or waiting for an RCU grace period.  We must make
> > > sure that any unused GSI is de-asserted, but the above means it's
> > > possible that another OADN has been created for this source ID/GSI
> > > and de-asserting the GSI could lead to breakage.
> > 
> > I do not see it. What breakage? Could you give an example please?
> > 
> > 
> > I think what you are saying is last deassign must clear
> > since otherwise we never will clear.
> > I agree it is either that or delay deassign until ack.
> > 
> > Can it be as simple as this (after all rcu etc dances)?
> > 	lock irqfds
> > 	if no oadns
> > 		set level to 0
> > 	unlock irqfds
> > ?
> 
> lock irqfds
> remove irqfd from oadn list
> if no oadns
>     remove oadn
>     set gsi 0
> unlock
>                                     lock irqfds
>                                     new oadn
>                                     unlock irqfds
> 
> >> EOI 
>                                                           ack notify new oadn
>                                                           de-assert gsi
>                                                           notify new oadn
> >> re-assert irqfd
>                                                           ack notify old oadn
>                                                           de-assert gsi
>                                                           notify old oadn
> 
> synchronize_rcu
> 
> kvm_unregister_irq_ack_notifier
>
> So, because the unregister is removed from the final clear and because
> we share an IRQ source ID there's a window where we can have two oadns
> registered for the same GSI.  The new one will de-assert and notify
> while the old one has an empty list to notify, but still de-asserts.  We
> can therefore de-assert w/o notify.
> 
> By using a new source ID, we separate the two so users of the new oadn
> can't race the old and we can cleanly free the old source ID,
> de-asserting it.

Need to think about it some more but is the problem two
ack notifiers for the same gsi?

In that case, how about we add __kvm_unregister_irq_ack_notifier
with no locking, and do most of the above under
kvm->irq_lock?

With one change: it is better not to call synchronize_rcu
under irq lock, I think we can safely move it to after
__kvm_unregister_irq_ack_notifier.


> > >  Instead each OADN
> > > object gets it's own source ID, but these are all shared by users
> > > of the same GSI.  So for PCI devices, we might have up to 4 IRQ
> > > source IDs allocated.
> > > 
> > > Michael had also suggested avoiding reference counting and using
> > > list_empty for this OADN object.  Unfortunately, that doesn't work
> > > for similar reasons.  We want to release the OADN object underlock,
> > > preventing others from re-using it on the free path, but in order
> > > to have lock-less de-assert & notify we use RCU, meaning we can't
> > > trust list_empty until after an RCU grace period, which must be
> > > done outside of spinlocks.
> > 
> > confused. list empty on assign/deassing would be under lock
> > so no need for grace periods to trust it.
> > what am I missing?
> > 
> > But if you like kref more that is OK too.
> 
> Maybe I'm misinterpreting this:
> 
> include/linux/rculist.h:
> /**
>  * list_del_rcu - deletes entry from list without re-initialization
>  * @entry: the element to delete from the list.
>  *
>  * Note: list_empty() on entry does not return true after this,
>  * the entry is in an undefined state. It is useful for RCU based
>  * lockfree traversal.
> 
> If I can trust list_empty on oadn->irqfds, which maybe I can re-reading
> it again, then we can drop the kref.  Thanks,
> 
> Alex

I think you are - *the entry you deleted* is not empty.
The list itself naturally is, or so it seems from code.

static inline void list_del_rcu(struct list_head *entry)
{
        __list_del_entry(entry);
        entry->prev = LIST_POISON2;
}

No?

> 
> > > If there are suggestions how we can handle these better, please
> > > make them, but I think this compromise is race-free and still
> > > manages to make allocation of IRQ source IDs mostly a non-issue
> > > for device assignment limits.  Thanks,
> > > 
> > > Alex
> > > 
> > > ---
> > > 
> > > Alex Williamson (2):
> > >       kvm: On Ack, De-assert & Notify KVM_IRQFD extension
> > >       kvm: Use a reserved IRQ source ID for irqfd
> > > 
> > > 
> > >  Documentation/virtual/kvm/api.txt |   13 ++
> > >  arch/x86/kvm/x86.c                |    4 +
> > >  include/linux/kvm.h               |    7 +
> > >  include/linux/kvm_host.h          |    2 
> > >  virt/kvm/eventfd.c                |  199 ++++++++++++++++++++++++++++++++++++-
> > >  5 files changed, 218 insertions(+), 7 deletions(-)
> 
> 
