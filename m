Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0LUVoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:44:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:35101 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0LUVob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:44:31 -0500
Subject: Re: [ANNOUNCE] VFIO V6 & public VFIO repositories
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: pugs@ieee.org
Cc: linux-pci@vger.kernel.org, mbranton@gmail.com, alexey.zaytsev@gmail.com,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org, alex.williamson@redhat.com, mst@redhat.com
In-Reply-To: <201012211148.43941.pugs@lyon-about.com>
References: <4ceafaf4.pffTeLx1ndqdBH3c%pugs@cisco.com>
	 <1292909368.16694.722.camel@pasglop> <1292909853.16694.726.camel@pasglop>
	 <201012211148.43941.pugs@lyon-about.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 08:33:27 +1100
Message-ID: <1292967207.16694.737.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 11:48 -0800, Tom Lyon wrote:
> 
> Ben - I don't have any good news for you.
> 
> DMA remappers like on Power and Sparc have been around forever, the new thing 
> about Intel/AMD iommus is the per-device address spaces and the protection 
> inherent in having separate mappings for each device.  If one is to trust a 
> user level app or virtual machine to program DMA registers directly, then you 
> really need per device translation.

Right, and we had that for a while too on our PCIe variants :-)

IE. We have a single address space, -but- that address space is divided
into windows that have an individual filter on the transaction requester
IDs (which I can configure to filter a full bus, a full device, or
pretty much per function). I have a pile of such windows (depending on
the exact chipset, up to 256 today).

So essentially, each device -does- have separate mappings, tho those are
limited to a "window" of the address space which is typically going to
be around 256M (or smaller) in 32-bit space (but can be much larger in
64-bit space depending on how much physically contiguous space we can
spare for the translation table itself).

Now, it doesn't do multi-level translations. So KVM guests (or userspace
applications) will not directly modify the translation table. That does
mean map/unmap "ioctls" for userspace. In the KVM case, hypercalls.

This is not a huge deal for us right now as our operating environment is
already paravirtualized (for running under pHyp aka PowerVM aka IBM
proprietary hypervisor). So we just implement the same hypercalls in KVM
and existing kernels will "just work". Not as efficient as direct access
into a multi level page table but still better than nothing :-)

> That said, early versions of VFIO had a mapping mode that used the normal DMA 
> API instead of the iommu/uiommu api and assumed that the user was trusted, but 
> that wasn't interesting for the long term.
> 
> So if you want safe device assigment you're going to need hardware help.

Well, there are going to be some amount of changes in future HW but
that's not something we can count on today and we have to support
existing machines. That said, as I wrote above, I -do- have per-device
assignment, however, I don't get to give an entire 64-bit address space
to each of them, only a "window" in a single address space, so I need
somewhat to convey those boundaries to userspace.

There's also a mismatch with the concept of creating an iommu domain,
and then attaching devices to it (which kvm intends to exploit, Alex was
explaining that his plan is to put all devices in a partition inside the
same domain). In our case, the domains are pretty-much pre-existing and
tied to each device. But this is more an API mismatch specific to
uiommu.

Cheers,
Ben.

> 
> > > 
> > > Cheers, 

