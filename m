Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2HPMey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:34:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2HPMex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:34:53 -0400
Message-ID: <1345120492.4683.467.camel@ul30vt.home>
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 06:34:52 -0600
In-Reply-To: <1345060759.4683.451.camel@ul30vt.home>
References: <20120810223633.809.44188.stgit@bling.home>
	 <20120815142803.GF3068@redhat.com> <1345052191.4683.435.camel@ul30vt.home>
	 <20120815192224.GB5670@redhat.com> <1345060759.4683.451.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 13:59 -0600, Alex Williamson wrote:
> On Wed, 2012-08-15 at 22:22 +0300, Michael S. Tsirkin wrote:
> > On Wed, Aug 15, 2012 at 11:36:31AM -0600, Alex Williamson wrote:
> > > On Wed, 2012-08-15 at 17:28 +0300, Michael S. Tsirkin wrote:
> > > > On Fri, Aug 10, 2012 at 04:37:08PM -0600, Alex Williamson wrote:
> > > > > v8:
> > > > > 
> > > > > Trying a new approach.  Nobody seems to like the internal IRQ
> > > > > source ID object and the interactions it implies between irqfd
> > > > > and eoifd, so let's get rid of it.  Instead, simply expose
> > > > > IRQ source IDs to userspace.  This lets the user be in charge
> > > > > of freeing them or hanging onto a source ID for later use.
> > > > 
> > > > In the end it turns out source ID is an optimization for shared
> > > > interrupts, isn't it?  Can't we apply the optimization transparently to
> > > > the user?  E.g. if we have some spare source IDs, allocate them, if we
> > > > run out, use a shared source ID?
> > > 
> > > Let's think about shared source IDs a bit more.  I think it's wrong that
> > > irqfd uses KVM_USERSPACE_IRQ_SOURCE_ID, but I'm questioning whether all
> > > irqfd users can share a source ID.  We do not get the logical OR of all
> > > users by putting them on the same source ID, we get "last set wins".
> > > KVM_USERSPACE_IRQ_SOURCE_ID is used for multiple inputs because the
> > > logical OR happens in userspace.  How would we not starve a user if we
> > > define KVM_IRQFD_SOURCE_ID?  What am I missing?
> > 
> > That all irqfds are deasserted on EOI anyway.  So there's no point
> > to do a logical OR.
> 
> Ok, so the argument is:
> 
> - edge irqfds (the code now) can share a source ID because there is no
> state.  Overlapping interrupt injects always cause one or more edge
> triggers.
> - your proposed level extension can only be asserted by the inject
> eventfd and is only de-asserted by EOI, which de-asserts and notifies
> all users.
> 
> What prevents an edge irqfd being registered to the same GSI as a level
> irqfd, resulting in a de-assert that might result in the irr not being
> seen by the guest and therefore maybe not getting an EOI? (I think this
> is the same problem as why we can't use the exiting irqfd to insert a
> level interrupt)
> 
> Having the de-assert only on EOI policy allows level irqfds to share a
> source ID, but do they all need to share a separate source ID from edge
> irqfds?
> 
> > > So I'm inclined to say source IDs are a requirement for shared
> > > interrupts.
> > 
> > Can yo show a specific example that breaks?
> > I don't think it can exist.
> 
> Only the edge vs level interaction if we define the policy above for
> de-assert.

Hmm, there is still a race w/ level.  If we have a number of
level-deassert-irqfds making use of the same gsi and sourceid and we
individually de-assert and notify, a re-assert could get lost if it
happens before all of the de-asserts have finished.  We either need
separate sourceids or we need to do a single de-assert followed by
multiple notifies.  Right?  Thanks,

Alex

> > > That means the re-use scheme becomes complicated (ex. we
> > > run out of IRQ source IDs, so we start looking for sharing by re-using a
> > > source ID used by a different GSI).  Do we want to do that in kernel or
> > > userspace?  This series allows userspace to deal with that complexity.
> > > Please let me know if I'm thinking incorrectly about source ID re-use.
> > > Thanks,
> > > 
> > > Alex
> > 
> > I think there is a misunderstanding.
> > All deassert on ack irqfds can share a source ID.
> > This is why I am now thinking deassert on ack behaviour
> > should be set when irqfd is assigned.
> 
> Maybe you were already thinking along the lines of a separate source ID
> for de-assert on ack irqfds vs normal irqfds then.  I think I missed
> that.  Thanks,
> 
> Alex



