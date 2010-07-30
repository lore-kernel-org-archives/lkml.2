Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0G3UnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 16:43:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab0G3Um7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 16:42:59 -0400
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
In-Reply-To: <20100729142705.GA25879@redhat.com>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
	 <201007271513.15093.pugs@cisco.com> <20100727235322.GB19930@redhat.com>
	 <201007281414.22335.pugs@cisco.com> <1280354222.3919.12.camel@x201>
	 <20100728215739.GA9671@redhat.com> <1280355199.3919.22.camel@x201>
	 <20100729142705.GA25879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 14:42:31 -0600
Message-ID: <1280522551.3585.388.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 17:27 +0300, Michael S. Tsirkin wrote: 
> On Wed, Jul 28, 2010 at 04:13:19PM -0600, Alex Williamson wrote:
> > On Thu, 2010-07-29 at 00:57 +0300, Michael S. Tsirkin wrote:
> > > On Wed, Jul 28, 2010 at 03:57:02PM -0600, Alex Williamson wrote:
> > > > 
> > > > Something like GET_MSIX_VECTORS seems like a user library routine to me.
> > > > The PCI config space is well specified and if we try to do more than
> > > > shortcut trivial operations (like getting the BAR length), we risk
> > > > losing functionality.  And for my purposes, translating to and from a
> > > > made up API to PCI for the guest seems like a pain.
> > > 
> > > Won't a userspace library do just as well for you?
> > 
> > You mean aside from qemu's reluctance to add dependencies for more
> > libraries?
> 
> Main reason is portability. So as long as it's kvm-only stuff, they
> likely won't care.

I'd like the qemu vfio driver to be available for both qemu and kvm.  It
may have limitation in qemu mode from non-atomic memory writes via tcg,
but I really don't want to have it only live in qemu-kvm like the
current device assignment code.

> > My only concern is that I want enough virtualized/raw config
> > space that I'm not always translating PCI config accesses from the guest
> > into some userspace API.  If it makes sense to do this for things like
> > MSI, since I need someone to figure out what resources can actually be
> > allocated on the host, then maybe the library makes sense for that.
> > Then again, if every user needs to do this, let the vfio kernel driver
> > check what it can get and virtualize the available MSIs in exposed
> > config space, and my driver would be even happier.
> > 
> > Alex
> 
> It would?  guest driver might or might not work if you reduce the number
> of vectors for device.  So I think you need an API to find out whether
> all vectors can be allocated.
>
> And these are examples of why virtualizing is wrong:
> 1. hides real hardware
> 2. no way to report errors

So I think you're proposing something like:

	ioctl(GET_MSIX_VECTORS)
	ioctl(VFIO_EVENTFDS_MSIX)

which I don't see any value over:

	Get #MSIX supported via expose PCI config space
	ioctl(VFIO_EVENTFDS_MSIX)

The GET_MSIX_VECTORS can't do any better job of predicting how many
interrupts can be allocated than looking at what the hardware supports.
Someone else could have exhausted the interrupt vectors by the time you
make the second call.  You'll note here that enabling the MSIX
interrupts actually requires an ioctl to associate eventfds with each
interrupt, so yes, we do have a way to report errors if the system can't
support the number of interrupts requested.  Thanks,

Alex

