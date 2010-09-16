Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0IPO3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:29:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab0IPO3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:29:33 -0400
Date: Thu, 16 Sep 2010 16:23:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916142335.GC24850@redhat.com>
References: <20100916104455.GA22254@redhat.com>
 <20100916105403.GZ3008@redhat.com>
 <20100916105352.GB22254@redhat.com>
 <20100916111752.GA3008@redhat.com>
 <20100916121338.GA23779@redhat.com>
 <20100916123301.GE3008@redhat.com>
 <20100916125717.GA24284@redhat.com>
 <20100916131823.GH3008@redhat.com>
 <20100916135137.GB24850@redhat.com>
 <20100916140615.GJ3008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916140615.GJ3008@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 04:06:15PM +0200, Gleb Natapov wrote:
> On Thu, Sep 16, 2010 at 03:51:37PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Sep 16, 2010 at 03:18:23PM +0200, Gleb Natapov wrote:
> > > On Thu, Sep 16, 2010 at 02:57:17PM +0200, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 16, 2010 at 02:33:01PM +0200, Gleb Natapov wrote:
> > > > > On Thu, Sep 16, 2010 at 02:13:38PM +0200, Michael S. Tsirkin wrote:
> > > > > > > > We haver two users: qemu does deasserts, vhost-net does asserts.
> > > > > > > Well this is broken. You want KVM to track level for you and this is
> > > > > > > wrong. KVM does this anyway because it can't relay on devise model
> > > > > > > to behave correctly [0], but in your case it is designed to behave
> > > > > > > incorrectly.
> > > > > > > 
> > > > > > > Interrupt type is a device property. PCI devices just happen to be level
> > > > > > > triggered according to PCI spec. What if you want to use vhost-net to
> > > > > > > implement network device which has active-low interrupt line? [1]
> > > > > > 
> > > > > > The polarity would have to be reversed in gsi (irq line can be shared,
> > > > > > all devices must be active high or low consistently).
> > > > > > 
> > > > > There are gsi dedicated to PCI. They can be shared only between PCI
> > > > > devices.
> > > > > 
> > > > > > > If you want to split parts that asserts irq and de-asserts it then we
> > > > > > > should have irqfd that tracks line status and knows interrupt line
> > > > > > > polarity.
> > > > > > 
> > > > > > Yes, it can know about polarity even though I think it's cleaner to do this
> > > > > > per gsi. But it can not track line status as line is shared with
> > > > > > other devices.
> > > > > It should track only device's line status.
> > > > 
> > > > There is no such thing as device's line status on real hardware, either.
> > > > Devices do not drive INT# high: they drive it low (all the time)
> > > > or do not drive it at all.
> > > Same thing, other naming. Device either drive it low (irq_set(1)) or
> > > not (irq_set(0)).
> > 
> > Well, if I drive it low any number of times it should hae no effect.
> > 
> There is no meaning of "driving low the line multiple times" on real HW.
> You either drive it low or not. We try to emulate this with individual
> "drive low/high" events in software.
> > > > 
> > > > Or consider express, the spec explicitly says:
> > > > "Note: Duplicate Assert_INTx/Deassert_INTx Messages have no effect, but

Express has assert and deassert messages. It might be easier for
you to think in these terms. level 1: assert, level 0: deassert.
Seems a simple model and what we do models this pretty well.

> > > >  are not errors."
> > > > 
> > > > > > 
> > > > > > > > Another application is out of process virtio (sandboxing!).
> > > > > > > It will still assert and de-assert irq at the same code, so it will be
> > > > > > > able to track irq line status.
> > > > > > > 
> > > > > > > > Again, pci stuff needs to stay in qemu.
> > > > > > > > 
> > > > > > > 
> > > > > > > Nothing to do with PCI whatsoever.
> > > > > > > 
> > > > > > > [0] most qemu devices behave incorrectly and trigger level irq more then
> > > > > > >     needed.
> > > > > > 
> > > > > > Which devices?
> > > > > Most of them. They just call update_irq_status() or something and
> > > > > re-assert interrupt regardless of what previous status was.
> > > > 
> > > > At least for PCI devices, these calls do nothing if status does not change.
> > > I am not sure what code are you locking at. e1000 device emulation
> > > doesn't check previous line status before calling qemu_set_irq().
> > 
> > Right. If you dig through useless levels of indirection, you will
> > see that each PCI device has 4 pin levels, when one of these
> > changes this makes it up level to the parent bus, and so on.
> Yes. Qemu PCI level does it right. Ideally device would not even invoke 
> this logic if interrupt status haven't changed.

It needs to call *some* function to check status
and assert, right? qemu_set_irq is that function.

> > 
> > > > 
> > > > > > pci core tracks line status and will never assert the same
> > > > > > line multiple times.
> > > > > That's good if pci core does this, but device shouldn't even try it.
> > > > 
> > > > I disagree. We don't want to duplicate a ton of code all over
> > > > the codebase.
> > > > 
> > > So abstract it into a function. It shouldn't be part of PCI emulation.
> > 
> > I don't know what you mean by this, send a patch and we can discuss?
> I don't care enough to send patch.  Just remember previous irq status
> and do not call qemu_set_irq() if it doesn't change. Three lines of
> code.

Heh, we have a ton of devices to support.
And then we need to migrate this extra status, and make sure it's in
sync with PCI code.  We'll end up with much more more than 3 lines all
of it in a very sensitive and hard to test parts code.

> > Note that when I patches PCI interrupt handling for compliance
> > I made it mimic hardware as closely as possible: devices
> > can send any # of assert/deassert messages, bus discards duplicates.
> > 
> Qemu PCI code is correct as far as I can see. Not all devices are connected
> via PCI and there is not need to go through couple of layer of
> indirection to figure out that nothing should be done.
> 

If we want to remove the indirection I would be much more
interested to remove it for all cases, not just when
nothing should be done.

> > > > > > 
> > > > > > > [1] this is how correct PCI device should behave but we override
> > > > > > >     polarity in ACPI, but now incorrect behaviour is deeply designed
> > > > > > >     into vhost-net.
> > > > > > 
> > > > > > Not really, vhost net signals an eventfd. What happens then is
> > > > > > up to kvm.
> > > > > > 
> > > > > That is what current broken design does and it works, but if you want to
> > > > > save unneeded calls into kvm fix design.
> > > > 
> > > > The interface seems clean enough: vhost handles virtio ring, qemu/kvm handle pci.
> > > > Making vhost aware of pci breaks this, I would not call that fixing the
> > > > design.
> > > > 
> > > Once again. Nothing to do with PCI, everything to do with device
> > > emulation. And I propose to abstract interrupt assertion part into
> > > irqfd, not into vhost.
> > > 
> > > --
> > > 			Gleb.
> > 
> > This could work. KVM would need to find all irqfd
> > objects mapped to gsi and notify them on deassert.
> > No idea how hard this is.
> > 
> What for? Device emulation should do de-assert.

Sorry, but at this point I have no idea what you call device emulation.
qemu has code to de-assert. vhost has code to assert.
I would like to optimize level interrupts and stop driving
scheduler insane if at all possible.

> --
> 			Gleb.
