Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2HMUsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2HMUs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:48:28 -0400
Message-ID: <1344890905.4683.120.camel@ul30vt.home>
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 13 Aug 2012 14:48:25 -0600
In-Reply-To: <20120813194938.GB19139@redhat.com>
References: <1343665330.8073.108.camel@ul30vt>
	 <20120731000100.GA17612@redhat.com> <1343694391.8073.227.camel@ul30vt>
	 <20120731003636.GC17922@redhat.com> <1343697135.8073.245.camel@ul30vt>
	 <1343848002.6698.38.camel@bling.home> <20120812074936.GA1421@redhat.com>
	 <1344876495.4683.47.camel@ul30vt.home> <20120813165938.GA19139@redhat.com>
	 <1344881845.4683.95.camel@ul30vt.home> <20120813194938.GB19139@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 22:50 +0300, Michael S. Tsirkin wrote:
> On Mon, Aug 13, 2012 at 12:17:25PM -0600, Alex Williamson wrote:
> > On Mon, 2012-08-13 at 19:59 +0300, Michael S. Tsirkin wrote:
> > > On Mon, Aug 13, 2012 at 10:48:15AM -0600, Alex Williamson wrote:
> > > > On Sun, 2012-08-12 at 10:49 +0300, Michael S. Tsirkin wrote:
> > > > > On Wed, Aug 01, 2012 at 01:06:42PM -0600, Alex Williamson wrote:
> > > > > > On Mon, 2012-07-30 at 19:12 -0600, Alex Williamson wrote:
> > > > > > > On Tue, 2012-07-31 at 03:36 +0300, Michael S. Tsirkin wrote:
> > > > > > > > On Mon, Jul 30, 2012 at 06:26:31PM -0600, Alex Williamson wrote:
> > > > > > > > > On Tue, 2012-07-31 at 03:01 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > > You keep saying this but it is still true: once irqfd
> > > > > > > > > > is closed eoifd does not get any more interrupts.
> > > > > > > > > 
> > > > > > > > > How does that matter?
> > > > > > > > 
> > > > > > > > Well if it does not get events it is disabled.
> > > > > > > > so you have one ifc disabling another, anyway.
> > > > > > > 
> > > > > > > And a level irqfd without an eoifd can never be de-asserted.  Either we
> > > > > > > make modular components, assemble them to do useful work, and
> > > > > > > disassemble them independently so they can be used by future interfaces
> > > > > > > or we bundle eoifd as just an option of irqfd.  Which is it gonna be?
> > > > > > 
> > > > > > I don't think I've been successful at explaining my reasoning for making
> > > > > > EOI notification a separate interface, so let me try again...
> > > > > > 
> > > > > > When kvm is not enabled, the qemu vfio driver still needs to know about
> > > > > > EOIs to re-enable the physical interrupt.  Since the ioapic is emulated
> > > > > > in qemu, we can setup a notifier for this and create abstraction to make
> > > > > > it non-x86 specific, etc.  We just need to come up with a design and
> > > > > > implement it.  But what happens when kvm is then enabled?  ioapic
> > > > > > emulation moves to the kernel (assume kvm includes irqchip for this
> > > > > > argument even though it doesn't for POWER), qemu no longer knows about
> > > > > > EOIs, and the interface we just created to handle the non-kvm case stops
> > > > > > working.  Is anyone going to accept adding a qemu EOI notification
> > > > > > interface that only works when kvm is not enabled?
> > > > > 
> > > > > Yes, it's only a question of abstracting it at the right level.
> > > > > 
> > > > > For example, if as you suggest below kvm gives you an eventfd that
> > > > > asserts an irq, laters automatically deasserts it and notifies another
> > > > > eventfd, we can do exactly this in both tcg and kvm:
> > > > > 
> > > > > setup_level_irq(int gsi, int assert_eventfd, int deassert_eventfd)
> > > > > 
> > > > > Not advocating this interface but pointing out that to make
> > > > > same abstraction to work in tcg and kvm, see what it does in
> > > > > each of them first.
> > > > 
> > > > The tcg model I was thinking of is that we continue to use qemu_set_irq
> > > > to assert and de-assert the interrupt and add an eoi/ack notification
> > > > mechanism, much like the ack notifier that already exists in kvm.  There
> > > > doesn't seem to be much advantage to creating a new interrupt
> > > > infrastructure in tcg that can trigger interrupts by eventfds, so I
> > > > assume VFIO is always going to be responsible for the translation of an
> > > > eventfd to an irq assertion, get some kind of notification through qemu,
> > > > de-assert the interrupt and unmask the device.  With that model in mind,
> > > > perhaps it makes more sense why I've been keeping the eoi/ack separate
> > > > from irqfd.
> > > > 
> > > > > > I suspect we therefore need a notification mechanism between kvm and
> > > > > > qemu to make it possible for that interface to continue working.
> > > > > 
> > > > > Even though no one is actually using it. IMHO, this is a maintainance
> > > > > problem.
> > > > 
> > > > That's why I'm designing it the way I am.  VFIO will make use of it.  It
> > > > will just be using the de-assert and notify mode vs a notify-only mode
> > > > that tcg would use.  It would also be easy to add an option to vfio so
> > > > that we could fully test both modes.
> > > > 
> > > > > > An
> > > > > > eventfd also seems like the right mechanism there.  A simple
> > > > > > modification to the proposed KVM_EOIFD here would allow it to trigger an
> > > > > > eventfd when an EOI is written to a specific gsi on
> > > > > > KVM_USERSPACE_IRQ_SOURCE_ID (define a flag and pass gsi in place of
> > > > > > key).
> > > > > > 
> > > > > > The split proposed here does require some assembly, but KVM_EOIFD is
> > > > > > re-usable as either a de-assert and notify mechanism tied to an irqfd or
> > > > > > a notify-only mechanism allowing users of a qemu EOI notification
> > > > > > infrastructure to continue working.  vfio doesn't necessarily need this
> > > > > > middle ground, but can easily be used to test it.
> > > > > > 
> > > > > > The alternative is that we pull eoifd into KVM_IRQFD and invent some
> > > > > > other new EOI interface for qemu.  That means we get EOIs tied to an
> > > > > > irqfd via one path and other EOIs via another ioctl.  Personally that
> > > > > > seems less desirable, but I'm willing to explore that route if
> > > > > > necessary.  Thanks,
> > > > > > 
> > > > > > Alex
> > > > > 
> > > > > Maybe we should focus on the fact that we notify userspace that we
> > > > > deasserted interrupt instead of EOI.
> > > > 
> > > > But will a tcg user want the de-assert?  I assume not.  The de-assert is
> > > > an optimization to allow us to bypass evaluation in userspace.  In tcg
> > > > we're already there.  Thanks,
> > > > 
> > > > Alex
> > > 
> > > Look what I am saying forget tcg and APIs. Build a kernel interface that
> > > makes sense. Then in qemu look at kvm and tcg and build abstraction for
> > > it.  Building kernel interface so you can make nice abstractions in tcg
> > > is backwards.
> > 
> > Can you suggest specifically what doesn't make sense?
> 
> Interface is just very easy to misuse. Here are things that
> you expose that to me do not seem to make sense:
> 
> - ability to create irqfd that by default can not be deasserted
>   (you need eoifd to deassert)

Well, it's not really the default, a user has to add a flag to get this
ability.

> - interface to create eventfd that by default never gets events
>   (you need irqfd to assert)

In v8, this isn't the default, the user has to specify that they want to
use it to de-assert.

> - creating ack eventfd requires level irqfd but you won't
>   know it unless you read documentation

This is also fixed in v8, you get a source ID, then hook it up to an
irqfd/irq ackfd any way you want.

> - duplicating level/edge information that we already have in GSI

Not really duplication, the edge/level information is several layers of
indirection away from this interface.  As we've discussed in the past,
relying on that information also means that the behavior of an ioctl
depends on the state of another piece of emulated hardware which is
controlled by the guest at the time the ioctl is called.  Personally, I
don't think that's a good characteristic.

> Knowing all these quirks is a must if you want things to
> work, but you do not know them until you read documentation.
> This is not good interface, a good interface is
> hard to misuse and self-documenting.

I think v8 makes improvements here, I'd be happy to hear your feedback
on it.

> > For legacy interrupts VFIO needs to:
> > 
> > - Assert an interrupt
> > 
> >         Eventfds seem to be the most efficient way to signal when to
> >         assert an interrupt and gives us the flexibility that we can
> >         send that signal to either another kernel module or to
> >         userspace.  KVM_IRQFD is designed for exactly this, but needs
> >         modifications for level triggered interrupts.  These include:
> >         
> >         - Using a different IRQ source ID
> >         
> >                 GSIs are not exclusive, multiple devices may assert the
> >                 same GSI.  IRQ source IDs are how KVM handles multiple
> >                 inputs.
> 
> Actually, thinking about it some more, all assigned
> device interrupts are deasserted on ack, so together.
> And userspace does the OR in userspace already.
> 
> So why is it not enough to give IRQFDs a single separate
> source ID, distinct from userspace but shared by all devices?

We could do that, but then we lose any ability to filter the KVM irq ack
notifier based on whether a given IRQ source ID is asserted.  This is
something you've been pushing for.  Note that patch 1/6 of the v8 series
adds this generically for all irq ack notifier users.  That's of course
just an optimization, we could have IRQ source IDs re-used and that
might be a good solution if we ever start exhausting them.  v8 allows
userspace to do this if it wants.

> >         - Assert-only
> >         
> >                 KVM_IRQFD currently does assert->deassert to emulate an
> >                 edge triggered interrupt.  For level, we need to be able
> >                 to signal a discrete assertion and de-assertion event.
> >         This results in the modifications I've proposed to KVM_IRQFD.
> 
> Actually is it really necessary at all?  What happens if we assert and
> deassert immediately?  If guest lost the interrupt, on EOI device will
> reassert resulting in another interrupt.

It's been a while since I've tried, but I recall I used this as a
workaround early on in development and it did work.  I don't feel it's a
proper representation of the hardware we're trying to emulate though and
istr that Avi wasn't too fond of it either.

> > - Know when to de-assert an interrupt
> > 
> >         Servicing an interrupt is device specific, we can't know for any
> >         random device what interactions with the device indicate service
> >         of an interrupt.  We therefore look to the underlying hardware
> >         support where a vCPU writes an End Of Interrupt to the APIC to
> >         indicate the chip should re-sample it's inputs and either
> >         de-assert or continue asserting the interrupt level.  Our device
> >         may still require service at this point, but this mechanism has
> >         proven effective with KVM assignment.
> >         
> >         This results in the notify-only portion of the EOIFD/IRQ_ACKFD.
> >         
> > - Deassert an interrupt
> > 
> >         Now that we have an interrupt that's been asserted and we
> >         suspect that we should re-evaluate the interrupt signal due to
> >         activity possibly related to an EOI, we need a mechanism to
> >         de-assert the interrupt.  There are two possibilities here:
> >         
> >         - Test and de-assert
> >         
> >                 Depending on hardware support for INTxDisable, we may be
> >                 able to poll whether the hardware is still asserting
> >                 it's interrupt and de-assert if quiesced.  This
> >                 optimizes for the case where the interrupt is still
> >                 asserting as we avoid re-assertion and avoid unmasking
> >                 the device.
> >         
> >         - De-assert, test, (re-assert)
> >         
> >                 Not all hardware supports INTxDisable, so we may have no
> >                 way to test whether the device is still asserting an
> >                 interrupt other than to unmask and see if it re-fires.
> >                 This not only supports the most hardware, but also
> >                 optimizes for the case where the device is quiesced.
> >                 
> >         Taking the latter path results in the de-assert and notify
> >         interface to the above EOIFD/IRQ_ACKFD.  This reduces the number
> >         of signals between components and supports the most hardware.
> >         
> > That leaves dealing with the IRQ source ID.  Initially I tried to hide
> > this from userspace as it's more of an implementation detail of KVM, but
> > in v8 I expose it as it offers more flexibility and (I hope) removes
> > some of the odd dependencies between interfaces imposed by previous
> > version.
> > 
> > If you have specific suggestions how else to approach this, I welcome
> > the feedback.
> > It would be backwards to design an interface exclusively around a
> > single user, but it would be just as backwards to not envision how an
> > interface would be used in advance.  Thanks,
> > 
> > Alex
> 
> Could you address two questions I ask above pls?
> If we really can use the same source ID for all irqfds,
> and if it's ok to deassert immediately after all,
> then large parts of code can go away.
> 
> Or maybe I was away for too long and forgot
> what the problem were ...

So if we de-assert immediately and remove the notify on de-assert, then
irq_ackfd becomes a notify-only interface.  In v8 that's what it is at
it's base, with an option to de-assert.  That option (patch 6/6) is a
tiny bit of code.

Removing the irq source ID isn't a clear win to me either.  I'm becoming
a broken record, but v8 already simplifies the irq source ID allocation
and preserves the ability to filter irq ack notifications and targeted
re-use of irq source IDs if userspace decides to support that.  Thanks,

Alex

