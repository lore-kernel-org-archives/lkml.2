Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2FXWfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 18:35:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab2FXWfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 18:35:01 -0400
Date: Mon, 25 Jun 2012 01:35:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 4/4][RFC] kvm: eoi_eventfd
Message-ID: <20120624223502.GC17046@redhat.com>
References: <20120622220040.9858.43665.stgit@bling.home>
 <20120622221626.9858.33817.stgit@bling.home>
 <20120624082451.GA1712@redhat.com>
 <1340549277.14120.42.camel@bling.home>
 <20120624154050.GB2851@redhat.com>
 <1340574612.5076.157.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340574612.5076.157.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 03:50:12PM -0600, Alex Williamson wrote:
> On Sun, 2012-06-24 at 18:40 +0300, Michael S. Tsirkin wrote:
> > On Sun, Jun 24, 2012 at 08:47:57AM -0600, Alex Williamson wrote:
> > > On Sun, 2012-06-24 at 11:24 +0300, Michael S. Tsirkin wrote:
> > > > On Fri, Jun 22, 2012 at 04:16:53PM -0600, Alex Williamson wrote:
> > > > > I think we're probably also going to need something like this.
> > > > > When running in non-accelerated qemu, we're going to have to
> > > > > create some kind of EOI notifier for drivers.  VFIO can make
> > > > > additional improvements when running on KVM so it will probably
> > > > > make use of the KVM_IRQFD_LEVEL_EOI interface, but we don't
> > > > > want to have a generic EOI notifier in qemu that just stops
> > > > > working when kvm-ioapic is enabled.  This is just a simple way
> > > > > to register an eventfd using the existing KVM ack notifier.
> > > > > I tried combining the ack notifier of the LEVEL_EOI interface
> > > > > into this one, but it didn't work out well.  The code complexity
> > > > > goes up a lot.
> > > > > 
> > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > ---
> > > > > 
> > > > >  Documentation/virtual/kvm/api.txt |   14 ++++++
> > > > >  arch/x86/kvm/x86.c                |    1 
> > > > >  include/linux/kvm.h               |   12 +++++
> > > > >  include/linux/kvm_host.h          |    7 +++
> > > > >  virt/kvm/eventfd.c                |   89 +++++++++++++++++++++++++++++++++++++
> > > > >  virt/kvm/kvm_main.c               |    9 ++++
> > > > >  6 files changed, 132 insertions(+)
> > > > > 
> > > > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > > > > index 2f8a0aa..69b1747 100644
> > > > > --- a/Documentation/virtual/kvm/api.txt
> > > > > +++ b/Documentation/virtual/kvm/api.txt
> > > > > @@ -1998,6 +1998,20 @@ matched using kvm_irqfd.fd, kvm_irqfd.gsi, and kvm_irqfd.fd2.
> > > > >  De-assigning automatically de-asserts the interrupt line setup through
> > > > >  this interface.
> > > > >  
> > > > > +4.77 KVM_EOI_EVENTFD
> > > > > +
> > > > > +Capability: KVM_CAP_EOI_EVENTFD
> > > > > +Architectures: x86
> > > > > +Type: vm ioctl
> > > > > +Parameters: struct kvm_eoi_eventfd (in)
> > > > > +Returns: 0 on success, -1 on error
> > > > > +
> > > > > +This interface allows userspace to be notified through an eventfd for
> > > > > +EOI writes to the in-kernel irqchip.  kvm_eoi_eventfd.fd specifies
> > > > > +the eventfd to signal on EOI to kvm_eoi_eventfd.gsi.  To disable,
> > > > > +use KVM_EOI_EVENTFD_FLAG_DEASSIGN and specify both the original fd
> > > > > +and gsi.
> > > > > +
> > > > >  5. The kvm_run structure
> > > > >  ------------------------
> > > > >  
> > > > 
> > > > The patch looks like it only works for ioapic IRQs.  I think it's a good
> > > > idea to explicitly limit this to level interrupts, straight away:
> > > > there's no reason for userspace to need an exit on an edge interrupt.
> > > 
> > > Are you suggesting documentation or code to prevent users from binding
> > > to an edge interrupt?
> > 
> > Yes.
> 
> Ok, that was failed attempt at clarification.  I'll assume documentation
> is sufficient.
> 
> > > > I also suggest we put LEVEL somewhere in the name.
> > > 
> > > Ok
> > > 
> > > > With this eventfd, do we also need the fd2 parameter in the irqfd
> > > > structure? It seems to be used for the same thing ...
> > > 
> > > Yes we still need fd2, this does not replace KVM_IRQFD_LEVEL_EOI.  The
> > > models we need to support are:
> > > 
> > > 1) assert from userspace (IRQ_LINE), eoi to userspace (EOI_EVENTFD),
> > > de-assert from userspace (IRQ_LINE)
> > > 
> > > 2a) assert from vfio (IRQFD.fd), de-assert in kvm, notify vfio
> > > (IRQFD.fd2)
> > > or
> > > 
> > > 2b) assert from vfio (IRQFD.fd), eoi to vfio (EOI_EVENTFD), de-assert
> > > from vfio (IRQFD.fd2)
> > 
> > Or maybe deassert in kvm, notify vfio using eventfd?
> 
> Um, how is that different from 2a?  Are you suggesting EOI_EVENTFD does
> a de-assert?

Yes.

>  My first implementation of this whole thing looked like
> this:
> 
>         irq_source_id = ioctl(vmfd, KVM_GET_IRQ_SOURCE_ID)
>         
>         struct kvm_irqfd irqfd = {
>             .fd = fd,
>             .gsi = gsi,
>             .flags = KVM_IRQFD_FLAG_LEVEL | KVM_IRQFD_FLAG_SOURCE_ID,

FLAG_LEVEL might not be needed.

>             .irq_source_id = irq_source_id,
>         };
>         
>         ioctl(vmfd, KVM_IRQFD, &irqfd);
>         
>         struct kvm_eoi_eventfd eoifd = {
>             .fd = fd2,
>             .gsi = gsi,
>             .flags = KVM_EOI_EVENTFD_FLAG_SOURCE_ID,
>             .irq_source_id = irq_source_id,
>         };
>         
>         ioctl(vmfd, KVM_EOI_EVENTFD, &eoifd);
> 
> What I didn't like about this was that the latter two ioctls are too
> interdependent on each other.  For instance, ordering of de-assignment
> is potentially important to avoid leaving the interrupt asserted.  The
> combined KVM_IRQFD_LEVEL_EOI completely manages that.  Also, if qemu
> wants to make use of this, they do not want the de-assert on EOI

IMO it should not matter.  Most likely level is already 0 by the time
EOI is invoked.  eventfds are asynchronous so you do not want
level to stay asserted until some action.
If qemu does not want the deassert on EOI, it should just
avoid using the eventfd interface.


> and
> want to make use of the fixed userspace source id, so we end up with a
> source id flag and a de-assert flag.  Eventually I decided that using a
> new source id is really only required when using an irqfd, so we could
> keep the source id internal and simplify the interface by pulling it all
> into KVM_IRQFD.


I see, thanks for the clarification.  But then we end up with
EOI_EVENTFD for userspace that duplicates some of the functionality.
I'm not sure how to do it best. How about passing in a special
fd value to IRQFD so that only fd2 is valid?

> > > This series enables 1) and 2a).  2b) has some pros and cons.  The pro is
> > > that vfio could test the device to see if an interrupt is pending and
> > > not de-assert if there is still an interrupt pending.  The con is that a
> > > standard level interrupt cycle takes 3 transactions instead of 2.
> > > 
> > > Any case of triggering the interrupt externally via an irqfd requires
> > > that the irqfd uses it's own irq_source_id so that it doesn't interfere
> > > with KVM_USERSPACE_IRQ_SOURCE_ID.  So we can't mix IRQ_LINE and IRQFD
> > > unless we want to completely expose a new irq source id allocation
> > > mechanism and include it in all the interfaces (KVM_GET_IRQ_SOURCE_ID,
> > > KVM_PUT_IRQ_SOURCE_ID, pass a source id to IRQFD and IRQ_LINE, etc).
> > > Thanks,
> > > 
> > > Alex
> > 
> > I don't follow this last paragraph. What are you trying to say?
> > To support IRQ sharing for level irqs, each irqfd for level IRQ
> > must have a distinct source id. But IRQ_LINE works fine without,
> > and one source ID for all irq_line users seems enough.
> 
> Ok, assume we have irqfd support as implemented in 3/4, but instead of
> allocating a new irq_source_id, we just use KVM_USERSPACE_IRQ_SOURCE_ID.
> The irqfd is triggered and asserts the interrupt line.  The guest begins
> handling the interrupt, first probing an emulated device, but it has
> nothing to do so moves on to the assigned device on the same interrupt
> line.  Qemu then decides that emulated device really does have something
> to do and assert the interrupt line.  Nothing happens because the guest
> is already handling that interrupt.  Guest finishes and writes an eoi.
> We're done, so we deassert.  Qemu's assert gets lost.
> 
> If we use a new irq_source_id, the guest sees the logical OR of all the
> source ids for that interrupt line, so even though we de-assert, the
> guest receives another interrupt because qemu's interrupt line status is
> still visible.  Qemu is able to share a single irq_source_id for all
> it's devices because the various components in the set_irq path are able
> to multiplex multiple emulated interrupt sources themselves.
> 
> As above, I argue that the only time you need a new source id is if
> you're injecting an interrupt from outside of the userspace model, which
> pretty much means irqfd.

This last paragraph is true IMO.

>  Thanks,
> 
> Alex
