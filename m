Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2HOTVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:21:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab2HOTVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:21:20 -0400
Date: Wed, 15 Aug 2012 22:22:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
Message-ID: <20120815192224.GB5670@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
 <20120815142803.GF3068@redhat.com>
 <1345052191.4683.435.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345052191.4683.435.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:36:31AM -0600, Alex Williamson wrote:
> On Wed, 2012-08-15 at 17:28 +0300, Michael S. Tsirkin wrote:
> > On Fri, Aug 10, 2012 at 04:37:08PM -0600, Alex Williamson wrote:
> > > v8:
> > > 
> > > Trying a new approach.  Nobody seems to like the internal IRQ
> > > source ID object and the interactions it implies between irqfd
> > > and eoifd, so let's get rid of it.  Instead, simply expose
> > > IRQ source IDs to userspace.  This lets the user be in charge
> > > of freeing them or hanging onto a source ID for later use.
> > 
> > In the end it turns out source ID is an optimization for shared
> > interrupts, isn't it?  Can't we apply the optimization transparently to
> > the user?  E.g. if we have some spare source IDs, allocate them, if we
> > run out, use a shared source ID?
> 
> Let's think about shared source IDs a bit more.  I think it's wrong that
> irqfd uses KVM_USERSPACE_IRQ_SOURCE_ID, but I'm questioning whether all
> irqfd users can share a source ID.  We do not get the logical OR of all
> users by putting them on the same source ID, we get "last set wins".
> KVM_USERSPACE_IRQ_SOURCE_ID is used for multiple inputs because the
> logical OR happens in userspace.  How would we not starve a user if we
> define KVM_IRQFD_SOURCE_ID?  What am I missing?

That all irqfds are deasserted on EOI anyway.  So there's no point
to do a logical OR.


> 
> So I'm inclined to say source IDs are a requirement for shared
> interrupts.

Can yo show a specific example that breaks?
I don't think it can exist.

> That means the re-use scheme becomes complicated (ex. we
> run out of IRQ source IDs, so we start looking for sharing by re-using a
> source ID used by a different GSI).  Do we want to do that in kernel or
> userspace?  This series allows userspace to deal with that complexity.
> Please let me know if I'm thinking incorrectly about source ID re-use.
> Thanks,
> 
> Alex

I think there is a misunderstanding.
All deassert on ack irqfds can share a source ID.
This is why I am now thinking deassert on ack behaviour
should be set when irqfd is assigned.


> 
> > > They
> > > can also detach and re-attach components at will.  It also opens
> > > up the possibility that userspace might want to use each IRQ
> > > source ID for more than one GSI (and avoids the kernel needing
> > > to manage that).  Per suggestions, EOIFD is now IRQ_ACKFD.
> > > 
> > > I really wanted to add a de-assert-only option to irqfd so the
> > > irq_ackfd could be fed directly into an irqfd, but I'm dependent
> > > on the ordering of de-assert _then_ signal an eventfd.  Keeping
> > > that ordering doesn't seem to be possible, especially since irqfd
> > > uses a workqueue, if I attempt to make that connection.  Thanks,
> > > 
> > > Alex
> > > ---
> > > 
> > > Alex Williamson (6):
> > >       kvm: Add de-assert option to KVM_IRQ_ACKFD
> > >       kvm: KVM_IRQ_ACKFD
> > >       kvm: Add assert-only option to KVM_IRQFD
> > >       kvm: Add IRQ source ID option to KVM_IRQFD
> > >       kvm: Expose IRQ source IDs to userspace
> > >       kvm: Allow filtering of acked irqs
> > > 
> > > 
> > >  Documentation/virtual/kvm/api.txt |   53 ++++++
> > >  arch/x86/kvm/Kconfig              |    1 
> > >  arch/x86/kvm/i8254.c              |    1 
> > >  arch/x86/kvm/i8259.c              |    8 +
> > >  arch/x86/kvm/x86.c                |    8 +
> > >  include/linux/kvm.h               |   39 ++++-
> > >  include/linux/kvm_host.h          |   18 ++
> > >  virt/kvm/Kconfig                  |    3 
> > >  virt/kvm/assigned-dev.c           |    1 
> > >  virt/kvm/eventfd.c                |  315 +++++++++++++++++++++++++++++++++++++
> > >  virt/kvm/ioapic.c                 |    5 -
> > >  virt/kvm/irq_comm.c               |   28 +++
> > >  virt/kvm/kvm_main.c               |   26 +++
> > >  13 files changed, 496 insertions(+), 10 deletions(-)
> 
> 
