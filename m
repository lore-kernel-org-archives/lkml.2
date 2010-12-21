Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0LUFah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:30:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:34453 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0LUFaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:30:35 -0500
Subject: Re: [ANNOUNCE] VFIO V6 & public VFIO repositories
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, mbranton@gmail.com, alexey.zaytsev@gmail.com,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org, alex.williamson@redhat.com, mst@redhat.com
In-Reply-To: <4ceafaf4.pffTeLx1ndqdBH3c%pugs@cisco.com>
References: <4ceafaf4.pffTeLx1ndqdBH3c%pugs@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 16:29:28 +1100
Message-ID: <1292909368.16694.722.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 15:21 -0800, Tom Lyon wrote:
> VFIO "driver" development has moved to a publicly accessible respository
> on github:
> 
> 	git://github.com/pugs/vfio-linux-2.6.git
> 
> This is a clone of the Linux-2.6 tree with all VFIO changes on the vfio 
> branch (which is the default). There is a tag 'vfio-v6' marking the latest
> "release" of VFIO.
> 
> In addition, I am open-sourcing my user level code which uses VFIO.
> It is a simple UDP/IP/Ethernet stack supporting 3 different VFIO based
> hardware drivers. This code is available at:
> 
> 	git://github.com/pugs/vfio-user-level-drivers.git

So I do have some concerns about this...

So first, before I go into the meat of my issues, let's just drop a
quick one about the interface: why netlink ? I find it horrible
myself... Just confuses everything and adds overhead. ioctl's would have
been a better choice imho.

Now, my actual issues, which in fact extend to the whole "generic" iommu
APIs that have been added to drivers/pci for "domains", and that in
turns "stains" VFIO in ways that I'm not sure I can use on POWER...

I would appreciate your input on how you think is the best way for me to
solve some of these "mismatches" between our HW and this design.

Basically, the whole iommu domain stuff has been entirely designed
around the idea that you can create those "domains" which are each an
entire address space, and put devices in there.

This is sadly not how the IBM iommus work on POWER today...

I have currently one "shared" DMA address space (per host bridge), but I
can assign regions of it to different devices (and I have limited
filtering capabilities so basically, a bus per region, a device per
region or a function per region).

That means essentially that I cannot just create a mapping for the DMA
addresses I want, but instead, need to have some kind of "allocator" for
DMA translations (which we have in the kernel, ie, dma_map/unmap use a
bitmap allocator).

I generally have 2 regions per device, one in 32-bit space of quite
limited size (some times as small as 128M window) and one in 64-bit
space that I can make quite large if I need to, enough to map all of
memory if that's really desired, using large pages or something like
that).

Now that has various consequences vs. the interfaces betweem iommu
domains and qemu, and VFIO:

 - I don't quite see how I can translate the concept of domains and
attaching devices to such domains. The basic idea won't work. The
domains in my case are essentially pre-existing, not created on-the-fly,
and may contain multiple devices tho I suppose I can assume for now that
we only support KVM pass-through with 1 device == 1 domain.
 
I don't know how to sort that one out if the userspace or kvm code
assumes it can put multiple devices in one domain and they start to
magically share the translations...

Not sure what the right approach here is. I could make the "Linux"
domain some artifical SW construct that contains a list of the real
iommu's it's "bound" to and establish translations in all of them... but
that isn't very efficient. If the guest kernel explicitely use some
iommu PV ops targeting a device, I need to only setup translations for
-that- device, not everything in the "domain".

 - The code in virt/kvm/iommu.c that assumes it can map the entire guest
memory 1:1 in the IOMMU is just not usable for us that way. We -might-
be able to do that for 64-bit capable devices as we can create quite
large regions in the 64-bit space, but at the very least we need some
kind of offset, and the guest must know about it...

 - Similar deal with all the code that currently assume it can pick up a
"virtual" address and create a mapping from that. Either we provide an
allocator, or if we want to keep the flexibility of userspace/kvm
choosing the virtual addresses (preferable), we need to convey some
"ranges" information down to the user.

 - Finally, my guest are always paravirt. There's well defined Hcalls
for inserting/removing DMA translations and we're implementing these
since existing kernels already know how to use them. That means that
overall, I might simply not need to use any of the above.

IE. I could have my own infrastructure for iommu, my H-calls populating
the target iommu directly from the kernel (kvm) or qemu (via ioctls in
the non-kvm case). Might be the best option ... but that would mean
somewhat disentangling VFIO from uiommu...

Any suggestions ? Great ideas ?

Cheers,
Ben.


