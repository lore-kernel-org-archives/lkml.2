Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2HNOtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2HNOtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:49:43 -0400
Date: Tue, 14 Aug 2012 17:50:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120814145022.GB4606@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
 <20120724204320.21081.32333.stgit@bling.home>
 <501F99A8.9050006@redhat.com>
 <501F9E99.9010109@redhat.com>
 <501F9F27.708@redhat.com>
 <1344540375.3441.228.camel@ul30vt.home>
 <20120812093336.GC1421@redhat.com>
 <502A462A.1000600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502A462A.1000600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 03:35:54PM +0300, Avi Kivity wrote:
> On 08/12/2012 12:33 PM, Michael S. Tsirkin wrote:
> >> 
> >> Michael, would the interface be more acceptable to you if we added
> >> separate ioctls to allocate and free some representation of an irq
> >> source ID, gsi pair?  For instance, an ioctl might return an idr entry
> >> for an irq source ID/gsi object which would then be passed as a
> >> parameter in struct kvm_irqfd and struct kvm_eoifd so that the object
> >> representing the source id/gsi isn't magically freed on it's own.  This
> >> would also allow us to deassign/close one end and reconfigure it later.
> >> Thanks,
> >> 
> >> Alex
> > 
> > It's acceptable to me either way. I was only pointing out that as
> > designed, the interface looks simple at first but then you find out some
> > subtle limitations which are implementation driven. This gives
> > an overall feeling the abstraction is too low level.
> > 
> > If we compare to the existing irqfd, isn't the difference
> > simply that irqfd deasserts immediately ATM, while we
> > want to delay this until later?
> > 
> > If yes, then along the lines that you proposed, and combining with my
> > idea of tracking deasserts, how do you like the following:
> > 
> > /* Keep line asserted until guest has handled the interrupt. */
> > #define KVM_IRQFD_FLAG_DEASSERT_ON_ACK (1 << 1)
> > /* Notify after line is deasserted. */
> > #define KVM_IRQFD_FLAG_DEASSERT_EVENTFD (2 << 1)
> > 
> > 	struct kvm_irqfd {
> > 		__u32 fd;
> > 		__u32 gsi;
> > 		__u32 flags;
> > 		/* eventfd to notify when line is deasserted */
> > 		__u32 deassert_eventfd;
> > 		__u8  pad[16];
> > 	};
> > 
> > now the only limitation is that KVM_IRQFD_FLAG_DEASSERT_ON_ACK is only
> > effective for level interrupts.
> > 
> > Notes about lifetime of objects:
> > 	- closing deassert_eventfd does nothing (we can keep
> > 	  reference to it from irqfd so no need for
> >           complex polling/flushing scheme)
> > 	- closing irqfd or deasserting dis-associates
> > 	  deassert_eventfd automatically
> > 	- source id is internal to irqfd and goes away with it
> > 
> > it looks harder to misuse and fits what we want to do nicely,
> > and needs less code to implement.
> > 
> > Avi, what do you think?
> 
> I think given all the complexity in the separate ioctl approach that
> this makes sense.  There are no lifetime issues or code to match the two
> eventfds.

OK, it's fine with me too then. Pls disregard my earlier proposal to
deassert immediately; Gleb showed me it does not work.

> Alex, would this API simplify the code?
> 
> Yet another option was raised in the past, and that was exiling ioapic
> and pic to userspace.  This moves the entire issue to userspace.  The
> cost is a new interface that implements the APIC bus (betweem APIC and
> IOAPIC) and the INTACK sequence (between APIC and PIC), and potential
> for performance regressions due to the PIC, IOAPIC, and PIT being in
> userspace.  We would still have to keep the IOAPIC/PIC in the kernel,
> but no new features would be added.
> 
> However, this is a huge job.  We could discuss this to death too but I
> have the feeling the end result will be to choose the shorter path --
> adding irqackfd/deassertfd/whateverwecallitfd.
> 
> 
> -- 
> error compiling committee.c: too many arguments to function
