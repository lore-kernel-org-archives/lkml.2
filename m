Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2HNXDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:03:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2HNXDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:03:15 -0400
Date: Wed, 15 Aug 2012 02:04:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120814230417.GC29180@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
 <20120724204320.21081.32333.stgit@bling.home>
 <501F99A8.9050006@redhat.com>
 <501F9E99.9010109@redhat.com>
 <501F9F27.708@redhat.com>
 <1344540375.3441.228.camel@ul30vt.home>
 <20120812093336.GC1421@redhat.com>
 <502A462A.1000600@redhat.com>
 <1344981675.4683.338.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344981675.4683.338.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 04:01:15PM -0600, Alex Williamson wrote:
> On Tue, 2012-08-14 at 15:35 +0300, Avi Kivity wrote:
> > On 08/12/2012 12:33 PM, Michael S. Tsirkin wrote:
> > >> 
> > >> Michael, would the interface be more acceptable to you if we added
> > >> separate ioctls to allocate and free some representation of an irq
> > >> source ID, gsi pair?  For instance, an ioctl might return an idr entry
> > >> for an irq source ID/gsi object which would then be passed as a
> > >> parameter in struct kvm_irqfd and struct kvm_eoifd so that the object
> > >> representing the source id/gsi isn't magically freed on it's own.  This
> > >> would also allow us to deassign/close one end and reconfigure it later.
> > >> Thanks,
> > >> 
> > >> Alex
> > > 
> > > It's acceptable to me either way. I was only pointing out that as
> > > designed, the interface looks simple at first but then you find out some
> > > subtle limitations which are implementation driven. This gives
> > > an overall feeling the abstraction is too low level.
> > > 
> > > If we compare to the existing irqfd, isn't the difference
> > > simply that irqfd deasserts immediately ATM, while we
> > > want to delay this until later?
> > > 
> > > If yes, then along the lines that you proposed, and combining with my
> > > idea of tracking deasserts, how do you like the following:
> > > 
> > > /* Keep line asserted until guest has handled the interrupt. */
> > > #define KVM_IRQFD_FLAG_DEASSERT_ON_ACK (1 << 1)
> > > /* Notify after line is deasserted. */
> > > #define KVM_IRQFD_FLAG_DEASSERT_EVENTFD (2 << 1)
> > > 
> > > 	struct kvm_irqfd {
> > > 		__u32 fd;
> > > 		__u32 gsi;
> > > 		__u32 flags;
> > > 		/* eventfd to notify when line is deasserted */
> > > 		__u32 deassert_eventfd;
> > > 		__u8  pad[16];
> > > 	};
> > > 
> > > now the only limitation is that KVM_IRQFD_FLAG_DEASSERT_ON_ACK is only
> > > effective for level interrupts.
> > > 
> > > Notes about lifetime of objects:
> > > 	- closing deassert_eventfd does nothing (we can keep
> > > 	  reference to it from irqfd so no need for
> > >           complex polling/flushing scheme)
> > > 	- closing irqfd or deasserting dis-associates
> > > 	  deassert_eventfd automatically
> > > 	- source id is internal to irqfd and goes away with it
> > > 
> > > it looks harder to misuse and fits what we want to do nicely,
> > > and needs less code to implement.
> > > 
> > > Avi, what do you think?
> > 
> > I think given all the complexity in the separate ioctl approach that
> > this makes sense.  There are no lifetime issues or code to match the two
> > eventfds.  Alex, would this API simplify the code?
> 
> It does though I'm concerned that it's a very specific solution that
> only addresses this problem.  Generic userspace eoi/ack is not
> addressed.  The latest version using separate ioctls does a lot of
> simplification by exposing irq sourceids.  The bulk of the code there is
> duplicating what irqfd does just so we can catch the POLLHUP for
> cleanup.  If there was an easier way to do that, we don't care about
> POLLIN/POLLOUT, much of the code could be removed.  Alternatively we
> could make some common infrastructure to simplify both irqfd and
> irq_ackfd, but how to frame the helpers isn't easy.

There is way easier with a single ioctl.  Don't you see?

As ack_eventfd pointer becomes part of the irqfd structure now, you
simply drop the reference together with irqfd.
In other words you do not care that ack eventfd goes
away anymore. So no need for POLLHUP handlers, no
separate DEASSERT that can race with that, etc.

So all this code just goes away, and it goes away completely, together
with managing source IDs (source ID comes an internal optimization to
avoid spurious EOIs, so no need to expose it to userspace anymore).

So all we are left with is minimal:
1. change irqfds to use a separate source id (can do this
   unconditionally for all irqfds)
2. check deassert on ack, if set register ack notifier
3. in ack notifier check deassert eventfd, if set signal it
4. (optionally) add a flag in irqfd, set on assert, test and clear
   on deassert, and only signal eventfd if it was set

on top of that we could try to do
5. allocate some more source IDs and if they are free try to use them as
   an optimization to avoid atomics


> > Yet another option was raised in the past, and that was exiling ioapic
> > and pic to userspace.  This moves the entire issue to userspace.  The
> > cost is a new interface that implements the APIC bus (betweem APIC and
> > IOAPIC) and the INTACK sequence (between APIC and PIC), and potential
> > for performance regressions due to the PIC, IOAPIC, and PIT being in
> > userspace.  We would still have to keep the IOAPIC/PIC in the kernel,
> > but no new features would be added.
> 
> Doesn't this assure a performance regression or are we assuming anywhere
> we care about performance we're using MSI?  Thanks,
> 
> Alex
