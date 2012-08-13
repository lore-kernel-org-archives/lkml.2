Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2HMQsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab2HMQsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:48:18 -0400
Message-ID: <1344876495.4683.47.camel@ul30vt.home>
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 13 Aug 2012 10:48:15 -0600
In-Reply-To: <20120812074936.GA1421@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
	 <20120724204320.21081.32333.stgit@bling.home>
	 <20120729145452.GD14278@redhat.com> <1343665330.8073.108.camel@ul30vt>
	 <20120731000100.GA17612@redhat.com> <1343694391.8073.227.camel@ul30vt>
	 <20120731003636.GC17922@redhat.com> <1343697135.8073.245.camel@ul30vt>
	 <1343848002.6698.38.camel@bling.home> <20120812074936.GA1421@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-12 at 10:49 +0300, Michael S. Tsirkin wrote:
> On Wed, Aug 01, 2012 at 01:06:42PM -0600, Alex Williamson wrote:
> > On Mon, 2012-07-30 at 19:12 -0600, Alex Williamson wrote:
> > > On Tue, 2012-07-31 at 03:36 +0300, Michael S. Tsirkin wrote:
> > > > On Mon, Jul 30, 2012 at 06:26:31PM -0600, Alex Williamson wrote:
> > > > > On Tue, 2012-07-31 at 03:01 +0300, Michael S. Tsirkin wrote:
> > > > > > You keep saying this but it is still true: once irqfd
> > > > > > is closed eoifd does not get any more interrupts.
> > > > > 
> > > > > How does that matter?
> > > > 
> > > > Well if it does not get events it is disabled.
> > > > so you have one ifc disabling another, anyway.
> > > 
> > > And a level irqfd without an eoifd can never be de-asserted.  Either we
> > > make modular components, assemble them to do useful work, and
> > > disassemble them independently so they can be used by future interfaces
> > > or we bundle eoifd as just an option of irqfd.  Which is it gonna be?
> > 
> > I don't think I've been successful at explaining my reasoning for making
> > EOI notification a separate interface, so let me try again...
> > 
> > When kvm is not enabled, the qemu vfio driver still needs to know about
> > EOIs to re-enable the physical interrupt.  Since the ioapic is emulated
> > in qemu, we can setup a notifier for this and create abstraction to make
> > it non-x86 specific, etc.  We just need to come up with a design and
> > implement it.  But what happens when kvm is then enabled?  ioapic
> > emulation moves to the kernel (assume kvm includes irqchip for this
> > argument even though it doesn't for POWER), qemu no longer knows about
> > EOIs, and the interface we just created to handle the non-kvm case stops
> > working.  Is anyone going to accept adding a qemu EOI notification
> > interface that only works when kvm is not enabled?
> 
> Yes, it's only a question of abstracting it at the right level.
> 
> For example, if as you suggest below kvm gives you an eventfd that
> asserts an irq, laters automatically deasserts it and notifies another
> eventfd, we can do exactly this in both tcg and kvm:
> 
> setup_level_irq(int gsi, int assert_eventfd, int deassert_eventfd)
> 
> Not advocating this interface but pointing out that to make
> same abstraction to work in tcg and kvm, see what it does in
> each of them first.

The tcg model I was thinking of is that we continue to use qemu_set_irq
to assert and de-assert the interrupt and add an eoi/ack notification
mechanism, much like the ack notifier that already exists in kvm.  There
doesn't seem to be much advantage to creating a new interrupt
infrastructure in tcg that can trigger interrupts by eventfds, so I
assume VFIO is always going to be responsible for the translation of an
eventfd to an irq assertion, get some kind of notification through qemu,
de-assert the interrupt and unmask the device.  With that model in mind,
perhaps it makes more sense why I've been keeping the eoi/ack separate
from irqfd.

> > I suspect we therefore need a notification mechanism between kvm and
> > qemu to make it possible for that interface to continue working.
> 
> Even though no one is actually using it. IMHO, this is a maintainance
> problem.

That's why I'm designing it the way I am.  VFIO will make use of it.  It
will just be using the de-assert and notify mode vs a notify-only mode
that tcg would use.  It would also be easy to add an option to vfio so
that we could fully test both modes.

> > An
> > eventfd also seems like the right mechanism there.  A simple
> > modification to the proposed KVM_EOIFD here would allow it to trigger an
> > eventfd when an EOI is written to a specific gsi on
> > KVM_USERSPACE_IRQ_SOURCE_ID (define a flag and pass gsi in place of
> > key).
> > 
> > The split proposed here does require some assembly, but KVM_EOIFD is
> > re-usable as either a de-assert and notify mechanism tied to an irqfd or
> > a notify-only mechanism allowing users of a qemu EOI notification
> > infrastructure to continue working.  vfio doesn't necessarily need this
> > middle ground, but can easily be used to test it.
> > 
> > The alternative is that we pull eoifd into KVM_IRQFD and invent some
> > other new EOI interface for qemu.  That means we get EOIs tied to an
> > irqfd via one path and other EOIs via another ioctl.  Personally that
> > seems less desirable, but I'm willing to explore that route if
> > necessary.  Thanks,
> > 
> > Alex
> 
> Maybe we should focus on the fact that we notify userspace that we
> deasserted interrupt instead of EOI.

But will a tcg user want the de-assert?  I assume not.  The de-assert is
an optimization to allow us to bypass evaluation in userspace.  In tcg
we're already there.  Thanks,

Alex

