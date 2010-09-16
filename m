Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0IPN5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab0IPN5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:57:37 -0400
Date: Thu, 16 Sep 2010 15:51:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916135137.GB24850@redhat.com>
References: <20100916101339.GK20864@redhat.com>
 <20100916102047.GY3008@redhat.com>
 <20100916104455.GA22254@redhat.com>
 <20100916105403.GZ3008@redhat.com>
 <20100916105352.GB22254@redhat.com>
 <20100916111752.GA3008@redhat.com>
 <20100916121338.GA23779@redhat.com>
 <20100916123301.GE3008@redhat.com>
 <20100916125717.GA24284@redhat.com>
 <20100916131823.GH3008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916131823.GH3008@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 03:18:23PM +0200, Gleb Natapov wrote:
> On Thu, Sep 16, 2010 at 02:57:17PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Sep 16, 2010 at 02:33:01PM +0200, Gleb Natapov wrote:
> > > On Thu, Sep 16, 2010 at 02:13:38PM +0200, Michael S. Tsirkin wrote:
> > > > > > We haver two users: qemu does deasserts, vhost-net does asserts.
> > > > > Well this is broken. You want KVM to track level for you and this is
> > > > > wrong. KVM does this anyway because it can't relay on devise model
> > > > > to behave correctly [0], but in your case it is designed to behave
> > > > > incorrectly.
> > > > > 
> > > > > Interrupt type is a device property. PCI devices just happen to be level
> > > > > triggered according to PCI spec. What if you want to use vhost-net to
> > > > > implement network device which has active-low interrupt line? [1]
> > > > 
> > > > The polarity would have to be reversed in gsi (irq line can be shared,
> > > > all devices must be active high or low consistently).
> > > > 
> > > There are gsi dedicated to PCI. They can be shared only between PCI
> > > devices.
> > > 
> > > > > If you want to split parts that asserts irq and de-asserts it then we
> > > > > should have irqfd that tracks line status and knows interrupt line
> > > > > polarity.
> > > > 
> > > > Yes, it can know about polarity even though I think it's cleaner to do this
> > > > per gsi. But it can not track line status as line is shared with
> > > > other devices.
> > > It should track only device's line status.
> > 
> > There is no such thing as device's line status on real hardware, either.
> > Devices do not drive INT# high: they drive it low (all the time)
> > or do not drive it at all.
> Same thing, other naming. Device either drive it low (irq_set(1)) or
> not (irq_set(0)).

Well, if I drive it low any number of times it should hae no effect.

> > 
> > Or consider express, the spec explicitly says:
> > "Note: Duplicate Assert_INTx/Deassert_INTx Messages have no effect, but
> >  are not errors."
> > 
> > > > 
> > > > > > Another application is out of process virtio (sandboxing!).
> > > > > It will still assert and de-assert irq at the same code, so it will be
> > > > > able to track irq line status.
> > > > > 
> > > > > > Again, pci stuff needs to stay in qemu.
> > > > > > 
> > > > > 
> > > > > Nothing to do with PCI whatsoever.
> > > > > 
> > > > > [0] most qemu devices behave incorrectly and trigger level irq more then
> > > > >     needed.
> > > > 
> > > > Which devices?
> > > Most of them. They just call update_irq_status() or something and
> > > re-assert interrupt regardless of what previous status was.
> > 
> > At least for PCI devices, these calls do nothing if status does not change.
> I am not sure what code are you locking at. e1000 device emulation
> doesn't check previous line status before calling qemu_set_irq().

Right. If you dig through useless levels of indirection, you will
see that each PCI device has 4 pin levels, when one of these
changes this makes it up level to the parent bus, and so on.

> > 
> > > > pci core tracks line status and will never assert the same
> > > > line multiple times.
> > > That's good if pci core does this, but device shouldn't even try it.
> > 
> > I disagree. We don't want to duplicate a ton of code all over
> > the codebase.
> > 
> So abstract it into a function. It shouldn't be part of PCI emulation.

I don't know what you mean by this, send a patch and we can discuss?
Note that when I patches PCI interrupt handling for compliance
I made it mimic hardware as closely as possible: devices
can send any # of assert/deassert messages, bus discards duplicates.

> > > > 
> > > > > [1] this is how correct PCI device should behave but we override
> > > > >     polarity in ACPI, but now incorrect behaviour is deeply designed
> > > > >     into vhost-net.
> > > > 
> > > > Not really, vhost net signals an eventfd. What happens then is
> > > > up to kvm.
> > > > 
> > > That is what current broken design does and it works, but if you want to
> > > save unneeded calls into kvm fix design.
> > 
> > The interface seems clean enough: vhost handles virtio ring, qemu/kvm handle pci.
> > Making vhost aware of pci breaks this, I would not call that fixing the
> > design.
> > 
> Once again. Nothing to do with PCI, everything to do with device
> emulation. And I propose to abstract interrupt assertion part into
> irqfd, not into vhost.
> 
> --
> 			Gleb.

This could work. KVM would need to find all irqfd
objects mapped to gsi and notify them on deassert.
No idea how hard this is.


-- 
MST
