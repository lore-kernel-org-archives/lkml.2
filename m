Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0IPMTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:19:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab0IPMTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:19:36 -0400
Date: Thu, 16 Sep 2010 14:13:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916121338.GA23779@redhat.com>
References: <20100916092553.GV3008@redhat.com>
 <4C91E75B.6010704@redhat.com>
 <20100916095310.GG20864@redhat.com>
 <20100916101332.GW3008@redhat.com>
 <20100916101339.GK20864@redhat.com>
 <20100916102047.GY3008@redhat.com>
 <20100916104455.GA22254@redhat.com>
 <20100916105403.GZ3008@redhat.com>
 <20100916105352.GB22254@redhat.com>
 <20100916111752.GA3008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916111752.GA3008@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 01:17:52PM +0200, Gleb Natapov wrote:
> On Thu, Sep 16, 2010 at 12:53:52PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Sep 16, 2010 at 12:54:03PM +0200, Gleb Natapov wrote:
> > > On Thu, Sep 16, 2010 at 12:44:55PM +0200, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 16, 2010 at 12:20:47PM +0200, Gleb Natapov wrote:
> > > > > On Thu, Sep 16, 2010 at 12:13:39PM +0200, Michael S. Tsirkin wrote:
> > > > > > On Thu, Sep 16, 2010 at 12:13:32PM +0200, Gleb Natapov wrote:
> > > > > > > On Thu, Sep 16, 2010 at 11:53:10AM +0200, Michael S. Tsirkin wrote:
> > > > > > > > On Thu, Sep 16, 2010 at 11:46:03AM +0200, Avi Kivity wrote:
> > > > > > > > >  On 09/16/2010 11:25 AM, Gleb Natapov wrote:
> > > > > > > > > >>
> > > > > > > > > >>  MSI only appeared in rhel6, older guests still use level interrupts.
> > > > > > > > > >So they are already slow for other reasons.
> > > > > > > > > >
> > > > > > > > > 
> > > > > > > > > Exactly, for example they need to exit to userspace to ack the
> > > > > > > > > interrupt.  That's far slower than the workqueue.
> > > > > > > > 
> > > > > > > > Well, this is not exactly comparable: you might get
> > > > > > > > same irq asserted multiple times and only deasserted once.
> > > > > > > > 
> > > > > > > Are we talking about level interrupts? Why would you assert level
> > > > > > > triggered interrupt multiple times before deasserting it?
> > > > > > 
> > > > > > User of irqfd has no way to know what current interrupt level is.
> > > > > > So it has to keep asserting.
> > > > > > 
> > > > > Why can't it keep track of current level?
> > > > 
> > > > This breaks the model: eventfd user is unaware of PCI, levels and such:
> > > > it just signals the event.  Remember that asserts are done from e.g. vhost-net,
> > > > deasserts need to be handled by qemu.
> > > > 
> > > eventfd user implements HW and it knows exactly what type of interrupt
> > > this HW generates.
> > 
> > We haver two users: qemu does deasserts, vhost-net does asserts.
> Well this is broken. You want KVM to track level for you and this is
> wrong. KVM does this anyway because it can't relay on devise model
> to behave correctly [0], but in your case it is designed to behave
> incorrectly.
> 
> Interrupt type is a device property. PCI devices just happen to be level
> triggered according to PCI spec. What if you want to use vhost-net to
> implement network device which has active-low interrupt line? [1]

The polarity would have to be reversed in gsi (irq line can be shared,
all devices must be active high or low consistently).

> If you want to split parts that asserts irq and de-asserts it then we
> should have irqfd that tracks line status and knows interrupt line
> polarity.

Yes, it can know about polarity even though I think it's cleaner to do this
per gsi. But it can not track line status as line is shared with
other devices.

> > Another application is out of process virtio (sandboxing!).
> It will still assert and de-assert irq at the same code, so it will be
> able to track irq line status.
> 
> > Again, pci stuff needs to stay in qemu.
> > 
> 
> Nothing to do with PCI whatsoever.
> 
> [0] most qemu devices behave incorrectly and trigger level irq more then
>     needed.

Which devices?
pci core tracks line status and will never assert the same
line multiple times.

> [1] this is how correct PCI device should behave but we override
>     polarity in ACPI, but now incorrect behaviour is deeply designed
>     into vhost-net.

Not really, vhost net signals an eventfd. What happens then is
up to kvm.

> --
> 			Gleb.



