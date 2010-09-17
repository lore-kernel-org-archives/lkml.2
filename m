Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab0IQH7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0IQH7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:59:32 -0400
Date: Fri, 17 Sep 2010 09:59:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100917075929.GA11518@redhat.com>
References: <20100916123301.GE3008@redhat.com>
 <20100916125717.GA24284@redhat.com>
 <20100916131823.GH3008@redhat.com>
 <20100916135137.GB24850@redhat.com>
 <20100916140615.GJ3008@redhat.com>
 <20100916142335.GC24850@redhat.com>
 <20100916145117.GK3008@redhat.com>
 <20100916152411.GE24850@redhat.com>
 <20100916154326.GL3008@redhat.com>
 <20100916220715.GA30531@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916220715.GA30531@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 12:07:15AM +0200, Michael S. Tsirkin wrote:
> On Thu, Sep 16, 2010 at 05:43:26PM +0200, Gleb Natapov wrote:
> > On Thu, Sep 16, 2010 at 05:24:11PM +0200, Michael S. Tsirkin wrote:
> > > On Thu, Sep 16, 2010 at 04:51:17PM +0200, Gleb Natapov wrote:
> > > > > > What for? Device emulation should do de-assert.
> > > > > 
> > > > > Sorry, but at this point I have no idea what you call device emulation.
> > > > The same thing everyone calls device emulation. In case of virtio-net it
> > > > is in hw/virtio-net.c. If vhost-net is in use device emulation is split
> > > > between userspace and kernel, but it is still just device emulation.
> > > 
> > > 
> > > case in point, virtio net does not know about pci at all,
> > > so it can not deassert.
> > > 
> > I don't see what PCI has to do with it. virtio-net device implementation is
> > split between several files. virtio-net/virtio-ring/virtio-pci. All of
> > them still implement one emulated device. Whoever implemented virtio-net
> > initially decided to put irq ack register into PCI config space, so code
> > that does de-assert is in virtio-pci,
> > but it is still part of emulated
> > device.
> > 
> > > > > qemu has code to de-assert. vhost has code to assert.
> > > > Good. So qemu will de-assert. So what do you mean by
> > > > "KVM would need to find all irqfd objects mapped to gsi and notify
> > > > them on deassert"
> > > > 
> > > > > I would like to optimize level interrupts and stop driving
> > > > > scheduler insane if at all possible.
> > > > > 
> > > > Worthy goal. Do it in irqfd. Irqfd shouldn't call kvm_set_irq() if irq
> > > > level hasn't changed.
> > > 
> > > Right. Then it needs to know about deasserts. It does not get this
> > Dessert should be done by qemu writing 0 into irqfd.
> 
> writing 0 to eventfd does nothing. The way to deassert irq
That is implementation detail of current irqfd. It was designed for MSI
not level triggered interrupts.

> is currently through ioctl and it seems entirely sensible
> to me to keep it that way.
Then do not complain.

> 
> Also - which irqfd :)
> We need multiple irqfds to map to a single gsi, with kvm
> doing OR on them.
Forget about gsi for now. Care only about your device state. KVM will
keep track of sharing.  Although having irqfd per gsi and keep tracking
there in not a bad idea.

> 
> > Assertion and
> > de-assertion should be done through irqfd.
> > > information, so when kvm gets deassert ioctl it should
> > > locate irqfd object and set level to 0.
> > > See?
> > No.
> > 
> > --
> > 			Gleb.

--
			Gleb.
