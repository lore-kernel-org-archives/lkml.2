Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2F1I32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:29:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab2F1I3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:29:23 -0400
Date: Thu, 28 Jun 2012 11:29:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/6] kvm: Extend irqfd to support level interrupts
Message-ID: <20120628082923.GA12447@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050937.23698.68442.stgit@bling.home>
 <20120627095137.GH17507@redhat.com>
 <1340830749.1207.236.camel@bling.home>
 <20120627211413.GE27746@redhat.com>
 <1340832499.1207.255.camel@bling.home>
 <20120627222852.GA27885@redhat.com>
 <1340855572.1207.300.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340855572.1207.300.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 09:52:52PM -0600, Alex Williamson wrote:
> On Thu, 2012-06-28 at 01:28 +0300, Michael S. Tsirkin wrote:
> > On Wed, Jun 27, 2012 at 03:28:19PM -0600, Alex Williamson wrote:
> > > On Thu, 2012-06-28 at 00:14 +0300, Michael S. Tsirkin wrote:
> > > > On Wed, Jun 27, 2012 at 02:59:09PM -0600, Alex Williamson wrote:
> > > > > On Wed, 2012-06-27 at 12:51 +0300, Michael S. Tsirkin wrote:
> > > > > > On Tue, Jun 26, 2012 at 11:09:46PM -0600, Alex Williamson wrote:
> > > > > > > In order to inject an interrupt from an external source using an
> > > > > > > irqfd, we need to allocate a new irq_source_id.  This allows us to
> > > > > > > assert and (later) de-assert an interrupt line independently from
> > > > > > > users of KVM_IRQ_LINE and avoid lost interrupts.
> > > > > > > 
> > > > > > > We also add what may appear like a bit of excessive infrastructure
> > > > > > > around an object for storing this irq_source_id.  However, notice
> > > > > > > that we only provide a way to assert the interrupt here.  A follow-on
> > > > > > > interface will make use of the same irq_source_id to allow de-assert.
> > > > > > > 
> > > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > ---
> > > > > > > 
> > > > > > >  Documentation/virtual/kvm/api.txt |    5 ++
> > > > > > >  arch/x86/kvm/x86.c                |    1 
> > > > > > >  include/linux/kvm.h               |    3 +
> > > > > > >  virt/kvm/eventfd.c                |   95 +++++++++++++++++++++++++++++++++++--
> > > > > > >  4 files changed, 99 insertions(+), 5 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > > > > > > index ea9edce..b216709 100644
> > > > > > > --- a/Documentation/virtual/kvm/api.txt
> > > > > > > +++ b/Documentation/virtual/kvm/api.txt
> > > > > > > @@ -1981,6 +1981,11 @@ the guest using the specified gsi pin.  The irqfd is removed using
> > > > > > >  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
> > > > > > >  and kvm_irqfd.gsi.
> > > > > > >  
> > > > > > > +With KVM_IRQFD_FLAG_LEVEL KVM_IRQFD allocates a new IRQ source ID for
> > > > > > > +the requested irqfd.  This is necessary to share level triggered
> > > > > > > +interrupts with those injected through KVM_IRQ_LINE.  IRQFDs created
> > > > > > > +with KVM_IRQFD_FLAG_LEVEL must also set this flag when de-assiging.
> > > > > > > +KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
> > > > > > 
> > > > > > Note that if my patch removing auto-deassert gets accepted,
> > > > > > this is not needed at all: we can just look at the GSI
> > > > > > to see if it's level or edge.
> > > > > 
> > > > > I'm not sure this is a good idea.  I know from vfio that I'm injecting a
> > > > > level interrupt regardless of how the guest has the pic/ioapic
> > > > > programmed at the time I'm calling this ioctl.  Peeking across address
> > > > > spaces to get to the right pin on the right pic/ioapic and see how it's
> > > > > currently programmed seems fragile.  Thanks,
> > > > > 
> > > > > Alex
> > > > 
> > > > Fragile? If you set eventfd as LEVEL but GSI is really edge then
> > > > it all explodes, right? So why give users the option to shoot
> > > > themselves in the foot?
> > > 
> > > If the guest has the ioapic rte set to edge at the time I call KVM_IRQFD
> > > to register my level interrupt then it all explodes, right?  I'd rather
> > > let the user shoot themselves than play Russian roulette with the guest.
> > > Am I misunderstanding what you mean by looking that the GSI to see if
> > > it's level or edge?
> > 
> > Not sure.
> > I simply mean this: if eventfd is bound to irqfd, set level from irqfd
> > and clear from eventfd ack notifier.
> 
> Are you simply saying assert (kvm_set_irq(,,,1)) from irqfd trigger and
> de-assert (kvm_set_irq(,,,0)) from eventfd ack notifier (aka KVM_EOIFD)?

Yes.

> > There's no need for a special IRQ_LEVEL for this.
> 
> That ignores the whole problem of when do we need to allocate a new
> irq_source_id and when do we inject using KVM_USERSPACE_IRQ_SOURCE_ID.
> We've already discussed that a level triggered, externally fired
> interrupt must use a separate source ID from Qemu userspace.  Therefore
> when you say "look at the GSI to see if it's level or edge", I assume
> you mean trace the gsi back to the pic/ioapic pin and look at the
> trigger mode.  That trigger mode is configured by the guest, so that
> means that at the point in time when we call KVM_IRQFD we make a
> determination based on how the _guest_ has programmed the ioapic.  That
> may not match the interrupt we expect to inject.  On the other hand, the
> user calling KVM_IRQFD absolutely knows the type of interrupt provided
> by their device.  I think we need a flag regardless of whether your
> patch is accepted.  We may be able to share the inject handler if it is
> accepted, but it doesn't change the user API.  Thanks,
> 
> Alex

This has merit, I am just looking for a way out
without adding LEVEL flag which seems to duplicate
what guest does, especially now it turns out
we can't add new flags to IRQFD.

How about this: allocate source id when eventfd is mapped?

-- 
MST
