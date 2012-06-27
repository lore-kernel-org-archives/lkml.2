Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2F0PDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:03:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab2F0PDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:03:05 -0400
Date: Wed, 27 Jun 2012 18:03:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't clear level from irqfd
Message-ID: <20120627150303.GG6533@redhat.com>
References: <20120627091343.GA17693@redhat.com>
 <20120627100345.GA6533@redhat.com>
 <20120627102024.GA17922@redhat.com>
 <20120627102254.GB6533@redhat.com>
 <20120627113843.GB17922@redhat.com>
 <1340808117.1207.215.camel@bling.home>
 <20120627150056.GB21241@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627150056.GB21241@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 06:00:57PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 27, 2012 at 08:41:57AM -0600, Alex Williamson wrote:
> > On Wed, 2012-06-27 at 14:38 +0300, Michael S. Tsirkin wrote:
> > > On Wed, Jun 27, 2012 at 01:22:54PM +0300, Gleb Natapov wrote:
> > > > On Wed, Jun 27, 2012 at 01:20:24PM +0300, Michael S. Tsirkin wrote:
> > > > > On Wed, Jun 27, 2012 at 01:03:46PM +0300, Gleb Natapov wrote:
> > > > > > On Wed, Jun 27, 2012 at 12:13:43PM +0300, Michael S. Tsirkin wrote:
> > > > > > > irqfd sets and clears the level immediately.
> > > > > > > This used to be necessary for MSI interrupts but isn't anymore.
> > > > > > > 
> > > > > > > Note! We never officially supported irqfd for level
> > > > > > > interrupts but it usually seemed to kind of work,
> > > > > > > and this change will break it. There are no known
> > > > > > > real users of that feature though - only old vfio prototypes.
> > > > > > > Removing this line will make it easier to add
> > > > > > > real support for level irqfds in the future.
> > > > > > > 
> > > > > > Did we officially supported irqfd for ioapic/pic edge interrupts?
> > > > > > Because those will break to.
> > > > > 
> > > > > Hard to say - as Alex points out it was never documented.
> > > > If we will start dropping everything that was never documented we will
> > > > hardly have working VMM at the end :)
> > > 
> > > Generally true.
> > > 
> > > However I just realized that this interface does not work
> > > reliably for ioapic/pic edge either. More or less for the same reason that
> > > it does not work for edge: we set bit in IRR, try to inject,
> > > then clear even if injection failed (e.g. because it is low
> > > priority). Guest will never get an interrupt in this case.
> > > 
> > > So what happened e.g. for Alex's vfio prototype is he never
> > > hit an interrupt window in light testing.
> > > 
> > > What we would need to do to fix it is:
> > > > > > > -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> > > > > > > -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> > > > > > > +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> > > > > > > +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> > > 
> > > Which will fix edge but break level same as this patch.
> > > But is it worth fixing? Maybe declare it broken and be
> > > done with it?
> > 
> > Ugh, so if I understand correctly, the case where kvm_set_irq() returns
> > <0, we're broken.
> 
> Gleb says it's not broken. Maybe I misread the code.
> Need more investigation.
> 
IRR in ioapic/pic is used for edge detection logic for edge interrupts.
It have to be cleared for next set_irq(1) to be detected.

> >  VFIO has masked the physical device and has no error
> > path to know that the interrupt inject was unsuccessful.  We almost need
> > an error eventfd that bounces the interrupt back to userspace for the
> > qemu interrupt model to handle, but that has it's own set of
> > complications.  Suggestions?  Declaring the interface broken isn't very
> > useful.  Thanks,
> > 
> > Alex

--
			Gleb.
