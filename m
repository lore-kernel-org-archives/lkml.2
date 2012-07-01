Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2GAHev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 03:34:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab2GAHet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 03:34:49 -0400
Date: Sun, 1 Jul 2012 10:34:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/6] kvm: Extend irqfd to support level interrupts
Message-ID: <20120701073446.GX6533@redhat.com>
References: <20120627050937.23698.68442.stgit@bling.home>
 <20120627152624.GC21393@redhat.com>
 <1340834658.1207.261.camel@bling.home>
 <20120627223128.GB27885@redhat.com>
 <20120628063431.GI6533@redhat.com>
 <20120628083435.GC12447@redhat.com>
 <20120628083541.GN6533@redhat.com>
 <20120628084105.GE12447@redhat.com>
 <20120628084611.GP6533@redhat.com>
 <1341008877.1207.372.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341008877.1207.372.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 04:27:57PM -0600, Alex Williamson wrote:
> On Thu, 2012-06-28 at 11:46 +0300, Gleb Natapov wrote:
> > On Thu, Jun 28, 2012 at 11:41:05AM +0300, Michael S. Tsirkin wrote:
> > > On Thu, Jun 28, 2012 at 11:35:41AM +0300, Gleb Natapov wrote:
> > > > On Thu, Jun 28, 2012 at 11:34:35AM +0300, Michael S. Tsirkin wrote:
> > > > > On Thu, Jun 28, 2012 at 09:34:31AM +0300, Gleb Natapov wrote:
> > > > > > On Thu, Jun 28, 2012 at 01:31:29AM +0300, Michael S. Tsirkin wrote:
> > > > > > > On Wed, Jun 27, 2012 at 04:04:18PM -0600, Alex Williamson wrote:
> > > > > > > > On Wed, 2012-06-27 at 18:26 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > On Tue, Jun 26, 2012 at 11:09:46PM -0600, Alex Williamson wrote:
> > > > > > > > > > @@ -71,6 +130,14 @@ irqfd_inject(struct work_struct *work)
> > > > > > > > > >  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> > > > > > > > > >  }
> > > > > > > > > >  
> > > > > > > > > > +static void
> > > > > > > > > > +irqfd_inject_level(struct work_struct *work)
> > > > > > > > > > +{
> > > > > > > > > > +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> > > > > > > > > > +
> > > > > > > > > > +	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
> > > > > > > > > > +}
> > > > > > > > > > +
> > > > > > > > > >  /*
> > > > > > > > > >   * Race-free decouple logic (ordering is critical)
> > > > > > > > > >   */
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Why is it safe to ignore return value here?
> > > > > > > > > needs a comment.
> > > > > > > > 
> > > > > > > > Well, it seems like you and Gleb came to the conclusion that it's safe,
> > > > > > > > but I can really follow from the list thread.  Can you explain and I'll
> > > > > > > > add a comment?  Thanks,
> > > > > > > > 
> > > > > > > > Alex
> > > > > > > 
> > > > > > > We merely talked about edge interrupts.
> > > > > > > 
> > > > > > In fact it would have been nice to return -EBUSY when write() to level
> > > > > > irqfd is coalesced.
> > > > > 
> > > > > Possibly nice but not really practical.
> > > > > 
> > > > What do you mean by that? Impossible to implement or not useful?
> > > 
> > > Impossible to implement and also does not match normal eventfd
> > > semantics.
> > > 
> > Hmm, I remember we discussed using irqfd for level triggered interrupt ~2
> > years ago and came to a conclusion that eventfd is a bad fit for it,
> > was true than is true now. Not be able to detect coalescing will make
> > irqfd level interrupts inferior to IRQ_LINE ioctl.
> 
> Why do we care about coalescing?  I've been worried we need to re-inject
> based on the return value of kvm_set_irq(), but re-reading specs and
> code, we always post the interrupt to the irr.  For device assignment we
> don't really care if kvm_set_irq() managed to actually inject the
> interrupt, we're happy as long as it eventually hits the vcpu.  Current
> device assignment uses kvm_set_irq() without looking for coalescing.
> KVM_LINE_STATUS is the only caller that does something with the return
> value and neither apic nor ioapic code in qemu do anything with the
> value other than update accounting stats.  What am I missing that makes
> the return value worth knowing?  Thanks,
> 
Currently the only device in QEMU that cares about coalescing is RTC.
There reason is that Windows keeps wall clock time by counting how many
RTC interrupts were received, so it is not enough to inject the RTC
interrupt, but it needs to be inject correct number of times. Another
potential users for that are PIC/HPET. For device assignment it is
likely not needed unless we pass through one of HPET timers directly
to a guest. I am not necessary against this patch series (I think this
is the best that can be done given eventfd limitations), but we need to
be aware of the fact that this API cannot satisfy some of existing use
cases. As Michaels pointed out, this is not new for this patch series
though. RTC/HPET/PIC interrupts are edge (not sure about non-MSI HPET)
and current edge irqfd drops kvm_set_irq() return value too. The
alternative way to count injected interrupt is to consider interrupt
injected only after EOI is called, but then we need to get EOI
notifications on edge interrupt too.

--
			Gleb.
