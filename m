Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1K3NZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:25:39 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:54412 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1K3NZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:25:37 -0500
X-IronPort-AV: E=Sophos;i="4.69,596,1315180800"; 
   d="scan'208";a="9207145"
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
Date: Wed, 30 Nov 2011 13:25:34 +0000
In-Reply-To: <201111301303.23851.arnd@arndb.de>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
	 <201111292129.20444.arnd@arndb.de>
	 <alpine.DEB.2.00.1111301053300.31179@kaball-desktop>
	 <201111301303.23851.arnd@arndb.de>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1322659535.31810.97.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 13:03 +0000, Arnd Bergmann wrote:
> On Wednesday 30 November 2011, Stefano Stabellini wrote:
> > On Tue, 29 Nov 2011, Arnd Bergmann wrote:
> > > On Tuesday 29 November 2011, Stefano Stabellini wrote:
> > > 
> > > Do you have a pointer to the kernel sources for the Linux guest?
> > 
> > We have very few changes to the Linux kernel at the moment (only 3
> > commits!), just enough to be able to issue hypercalls and start a PV
> > console.
> > 
> > A git branch is available here (not ready for submission):
> > 
> > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git arm
> 
> Ok, interesting. There really isn't much of the platform support
> that I was expecting there. I finally found the information
> I was looking for in the xen construct_dom0() function:
> 
>  167     regs->r0 = 0; /* SBZ */
>  168     regs->r1 = 2272; /* Machine NR: Versatile Express */
>  169     regs->r2 = 0xc0000100; /* ATAGS */
> 
> What this means is that you are emulating the current ARM/Keil reference
> board, at least to the degree that is necessary to get the guest started.
> 
> This is the same choice people have made for KVM, but it's not
> necessarily the best option in the long run. In particular, this
> board has a lot of hardware that you claim to have by putting the
> machine number there, when you don't really want to emulate it.

This code is actually setting up dom0 which (for the most part) sees the
real hardware.

The hardcoding of the platform is just a short term hack.

> Pawell Moll is working on a variant of the vexpress code that uses
> the flattened device tree to describe the present hardware [1], and
> I think that would be a much better target for an official release.
> Ideally, the hypervisor should provide the device tree binary (dtb)
> to the guest OS describing the hardware that is actually there.

Agreed. Our intention was to use DT so this fits perfectly with our
plans.

For dom0 we would expose a (possibly filtered) version of the DT given
to us by the firmware (e.g. we might hide a serial port to reserve it
for Xen's use, we'd likely fiddle with the memory map etc).

For domU the DT would presumably be constructed by the toolstack (in
dom0 userspace) as appropriate for the guest configuration. I guess this
needn't correspond to any particular "real" hardware platform.

> This would also be the place where you tell the guest that it should
> look for PV devices. I'm not familiar with how Xen announces PV
> devices to the guest on other architectures, but you have the
> choice between providing a full "binding", i.e. a formal specification
> in device tree format for the guest to detect PV devices in the
> same way as physical or emulated devices, or just providing a single
> place in the device tree in which the guest detects the presence
> of a xen device bus and then uses hcalls to find the devices on that
> bus.

On x86 there is an emulated PCI device which serves as the hooking point
for the PV drivers. For ARM I don't think it would be unreasonable to
have a DT entry instead. I think it would be fine just represent the
root of the "xenbus" and further discovery would occur using the normal
xenbus mechanisms (so not a full binding). AIUI for buses which are
enumerable this is the preferred DT scheme to use.

> Another topic is the question whether there are any hcalls that
> we should try to standardize before we get another architecture
> with multiple conflicting hcall APIs as we have on x86 and powerpc.

The hcall API we are currently targeting is the existing Xen API (at
least the generic parts of it). These generally deal with fairly Xen
specific concepts like grant tables etc.

Ian.

> 
> 	Arnd
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg149604.html
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


