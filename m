Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2IQSIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab2IQSIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:08:15 -0400
Message-ID: <1347905295.28860.7.camel@bling.home>
Subject: Re: [PATCH v9 0/2] kvm: level irqfd support
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Sep 2012 12:08:15 -0600
In-Reply-To: <20120822082535.GA10680@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
	 <20120822003129.GK9027@redhat.com> <1345598895.29292.115.camel@ul30vt.home>
	 <20120822082535.GA10680@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 11:25 +0300, Michael S. Tsirkin wrote:
> On Tue, Aug 21, 2012 at 07:28:15PM -0600, Alex Williamson wrote:
> > On Wed, 2012-08-22 at 03:31 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Aug 21, 2012 at 01:28:57PM -0600, Alex Williamson wrote:
> > > > Here's the much anticipated re-write of support for level irqfds.  As
> > > > Michael suggested, I've rolled the eoi/ack notification fd into
> > > > KVM_IRQFD as a new mode.  For lack of a better name, as there seems to
> > > > be objections to associating this specifically with an EOI or an ACK,
> > > > I've name this OADN or "On Ack, De-assert & Notify".
> > > > 
> > > > Patch 1of2 switches current KVM_IRQFDs to use their own IRQ source ID
> > > > since we're potentially stepping on KVM_USERSPACE_IRQ_SOURCE_ID.
> > > > Unfurtunately I was not able to make 2of2 use a single IRQ source ID,
> > > > the reason is it's racy.  Objects to track OADNs are made dynamically,
> > > > we look through existing ones for a match under spinlock and setup a
> > > > new one if there's no match.  On teardown, we can remove the OADN from
> > > > the list under lock, but that same lock prevents us from de-assigning
> > > > the IRQ ACK notifier or waiting for an RCU grace period.  We must make
> > > > sure that any unused GSI is de-asserted, but the above means it's
> > > > possible that another OADN has been created for this source ID/GSI
> > > > and de-asserting the GSI could lead to breakage.
> > > 
> > > I do not see it. What breakage? Could you give an example please?
> > > 
> > > 
> > > I think what you are saying is last deassign must clear
> > > since otherwise we never will clear.
> > > I agree it is either that or delay deassign until ack.
> > > 
> > > Can it be as simple as this (after all rcu etc dances)?
> > > 	lock irqfds
> > > 	if no oadns
> > > 		set level to 0
> > > 	unlock irqfds
> > > ?
> > 
> > lock irqfds
> > remove irqfd from oadn list
> > if no oadns
> >     remove oadn
> >     set gsi 0
> > unlock
> >                                     lock irqfds
> >                                     new oadn
> >                                     unlock irqfds
> > 
> > >> EOI 
> >                                                           ack notify new oadn
> >                                                           de-assert gsi
> >                                                           notify new oadn
> > >> re-assert irqfd
> >                                                           ack notify old oadn
> >                                                           de-assert gsi
> >                                                           notify old oadn
> > 
> > synchronize_rcu
> > 
> > kvm_unregister_irq_ack_notifier
> >
> > So, because the unregister is removed from the final clear and because
> > we share an IRQ source ID there's a window where we can have two oadns
> > registered for the same GSI.  The new one will de-assert and notify
> > while the old one has an empty list to notify, but still de-asserts.  We
> > can therefore de-assert w/o notify.
> > 
> > By using a new source ID, we separate the two so users of the new oadn
> > can't race the old and we can cleanly free the old source ID,
> > de-asserting it.
> 
> Need to think about it some more but is the problem two
> ack notifiers for the same gsi?

yes

> In that case, how about we add __kvm_unregister_irq_ack_notifier
> with no locking, and do most of the above under
> kvm->irq_lock?

Converting locks makes me nervous, but I'll give it a shot.  I don't
know how easy/possible it is though.  I know in previous iterations I
tried to make something similar to irqfd use a mutex and couldn't, but I
don't remember the details.

> With one change: it is better not to call synchronize_rcu
> under irq lock, I think we can safely move it to after
> __kvm_unregister_irq_ack_notifier.

Yep, that makes the interface pretty ugly though as we then have two
separate, but dependent steps.  Thanks,

Alex

