Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1K3OdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:33:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1K3OdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:33:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
Date: Wed, 30 Nov 2011 14:32:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop> <201111301303.23851.arnd@arndb.de> <1322659535.31810.97.camel@zakaz.uk.xensource.com>
In-Reply-To: <1322659535.31810.97.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301432.54463.arnd@arndb.de>
X-Provags-ID: V02:K0:KiyS5/mKTB55iLS0W4BKJPYzZdPPz/YC+/JscRaM0ef
 CoS+X6fI7K9zEu+Ng77TIUmFPDrSEj8tg+PCYjfBVHsnNzsL36
 uqi+9cytQ1YPvwD2FEvrWzs+YuGEDazmaZJq5A0LHneEjHcvVn
 MiJd1gaw7tWiawwcHcHJK5ojBYrdc4ynccSqe2p4G8d71ZyjY2
 ul06DIizQiKrqnRX2lxQIcJyGIIOjPgnkVYTZ7UKXYdP7Yo7we
 Mj+Zd4elP7Gbm4CEofPcPG8RMwBkUjQMyeeDHdnqTkm8ip/Pjl
 jvBNURr29ZrDxrjX2vH+Ngo4D3wo3RzFHo++rAv8rIDj6+tsW6
 2kdRZHslojueUVJpqRy0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011, Ian Campbell wrote:
> On Wed, 2011-11-30 at 13:03 +0000, Arnd Bergmann wrote:
> > On Wednesday 30 November 2011, Stefano Stabellini wrote:
> > This is the same choice people have made for KVM, but it's not
> > necessarily the best option in the long run. In particular, this
> > board has a lot of hardware that you claim to have by putting the
> > machine number there, when you don't really want to emulate it.
> 
> This code is actually setting up dom0 which (for the most part) sees the
> real hardware.

Ok, I see.

> > Pawell Moll is working on a variant of the vexpress code that uses
> > the flattened device tree to describe the present hardware [1], and
> > I think that would be a much better target for an official release.
> > Ideally, the hypervisor should provide the device tree binary (dtb)
> > to the guest OS describing the hardware that is actually there.
> 
> Agreed. Our intention was to use DT so this fits perfectly with our
> plans.
> 
> For dom0 we would expose a (possibly filtered) version of the DT given
> to us by the firmware (e.g. we might hide a serial port to reserve it
> for Xen's use, we'd likely fiddle with the memory map etc).

Ah, very good.

> For domU the DT would presumably be constructed by the toolstack (in
> dom0 userspace) as appropriate for the guest configuration. I guess this
> needn't correspond to any particular "real" hardware platform.

Correct, but it needs to correspond to some platform that is supported
by the guest OS, which leaves the choice between emulating a real
hardware platform, adding a completely new platform specifically for
virtual machines, or something in between the two.

What I suggested to the KVM developers is to start out with the
vexpress platform, but then generalize it to the point where it fits
your needs. All hardware that one expects a guest to have (GIC, timer,
...) will still show up in the same location as on a real vexpress,
while anything that makes no sense or is better paravirtualized (LCD,
storage, ...) just becomes optional and has to be described in the
device tree if it's actually there.

> > This would also be the place where you tell the guest that it should
> > look for PV devices. I'm not familiar with how Xen announces PV
> > devices to the guest on other architectures, but you have the
> > choice between providing a full "binding", i.e. a formal specification
> > in device tree format for the guest to detect PV devices in the
> > same way as physical or emulated devices, or just providing a single
> > place in the device tree in which the guest detects the presence
> > of a xen device bus and then uses hcalls to find the devices on that
> > bus.
> 
> On x86 there is an emulated PCI device which serves as the hooking point
> for the PV drivers. For ARM I don't think it would be unreasonable to
> have a DT entry instead. I think it would be fine just represent the
> root of the "xenbus" and further discovery would occur using the normal
> xenbus mechanisms (so not a full binding). AIUI for buses which are
> enumerable this is the preferred DT scheme to use.

In general that is the case, yes. One could argue that any software
protocol between Xen and the guest is as good as any other, so it
makes sense to use the device tree to describe all devices here.
The counterargument to that is that Linux and other OSs already
support Xenbus, so there is no need to come up with a new binding.

I don't care much either way, but I think it would be good to
use similar solutions across all hypervisors. The two options
that I've seen discussed for KVM were to use either a virtual PCI
bus with individual virtio-pci devices as on the PC, or to
use the new virtio-mmio driver and individually put virtio devices
into the device tree.

> > Another topic is the question whether there are any hcalls that
> > we should try to standardize before we get another architecture
> > with multiple conflicting hcall APIs as we have on x86 and powerpc.
> 
> The hcall API we are currently targeting is the existing Xen API (at
> least the generic parts of it). These generally deal with fairly Xen
> specific concepts like grant tables etc.

Ok. It would of course still be possible to agree on an argument passing
convention so that we can share the macros used to issue the hcalls,
even if the individual commands are all different. I think I also
remember talk about the need for a set of hypervisor independent calls
that everyone should implement, but I can't remember what those were.
Maybe we can split the number space into a range of some generic and
some vendor specific hcalls?

	Arnd
