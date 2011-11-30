Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab1K3Q15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:27:57 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:30332 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1K3Q1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:27:55 -0500
X-IronPort-AV: E=Sophos;i="4.69,597,1315180800"; 
   d="scan'208";a="9212840"
Subject: Re: [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt
 extensions
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
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
Date: Wed, 30 Nov 2011 16:27:53 +0000
In-Reply-To: <201111301432.54463.arnd@arndb.de>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
	 <201111301303.23851.arnd@arndb.de>
	 <1322659535.31810.97.camel@zakaz.uk.xensource.com>
	 <201111301432.54463.arnd@arndb.de>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1322670473.31810.129.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 14:32 +0000, Arnd Bergmann wrote:
> On Wednesday 30 November 2011, Ian Campbell wrote:
> > On Wed, 2011-11-30 at 13:03 +0000, Arnd Bergmann wrote:
> > For domU the DT would presumably be constructed by the toolstack (in
> > dom0 userspace) as appropriate for the guest configuration. I guess this
> > needn't correspond to any particular "real" hardware platform.
> 
> Correct, but it needs to correspond to some platform that is supported
> by the guest OS, which leaves the choice between emulating a real
> hardware platform, adding a completely new platform specifically for
> virtual machines, or something in between the two.
> 
> What I suggested to the KVM developers is to start out with the
> vexpress platform, but then generalize it to the point where it fits
> your needs. All hardware that one expects a guest to have (GIC, timer,
> ...) will still show up in the same location as on a real vexpress,
> while anything that makes no sense or is better paravirtualized (LCD,
> storage, ...) just becomes optional and has to be described in the
> device tree if it's actually there.

That's along the lines of what I was thinking as well.

The DT contains the address of GIC, timer etc as well right? So at least
in principal we needn't provide e.g. the GIC at the same address as any
real platform but in practice I expect we will.

In principal we could also offer the user options as to which particular
platform a guest looks like.

> > > This would also be the place where you tell the guest that it should
> > > look for PV devices. I'm not familiar with how Xen announces PV
> > > devices to the guest on other architectures, but you have the
> > > choice between providing a full "binding", i.e. a formal specification
> > > in device tree format for the guest to detect PV devices in the
> > > same way as physical or emulated devices, or just providing a single
> > > place in the device tree in which the guest detects the presence
> > > of a xen device bus and then uses hcalls to find the devices on that
> > > bus.
> > 
> > On x86 there is an emulated PCI device which serves as the hooking point
> > for the PV drivers. For ARM I don't think it would be unreasonable to
> > have a DT entry instead. I think it would be fine just represent the
> > root of the "xenbus" and further discovery would occur using the normal
> > xenbus mechanisms (so not a full binding). AIUI for buses which are
> > enumerable this is the preferred DT scheme to use.
> 
> In general that is the case, yes. One could argue that any software
> protocol between Xen and the guest is as good as any other, so it
> makes sense to use the device tree to describe all devices here.
> The counterargument to that is that Linux and other OSs already
> support Xenbus, so there is no need to come up with a new binding.

Right.

> I don't care much either way, but I think it would be good to
> use similar solutions across all hypervisors. The two options
> that I've seen discussed for KVM were to use either a virtual PCI
> bus with individual virtio-pci devices as on the PC, or to
> use the new virtio-mmio driver and individually put virtio devices
> into the device tree.
> 
> > > Another topic is the question whether there are any hcalls that
> > > we should try to standardize before we get another architecture
> > > with multiple conflicting hcall APIs as we have on x86 and powerpc.
> > 
> > The hcall API we are currently targeting is the existing Xen API (at
> > least the generic parts of it). These generally deal with fairly Xen
> > specific concepts like grant tables etc.
> 
> Ok. It would of course still be possible to agree on an argument passing
> convention so that we can share the macros used to issue the hcalls,
> even if the individual commands are all different.

I think it likely that we can all agree on a common calling convention
for N-argument hypercalls. It doubt there are that many useful choices
with conflicting requirements yet strongly compelling advantages.

>  I think I also
> remember talk about the need for a set of hypervisor independent calls
> that everyone should implement, but I can't remember what those were.

I'd not heard of this, maybe I just wasn't looking the right way though.

> Maybe we can split the number space into a range of some generic and
> some vendor specific hcalls?

Ian.

