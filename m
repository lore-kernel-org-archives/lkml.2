Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0LUVQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:16:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab0LUVP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:15:58 -0500
Subject: Re: [ANNOUNCE] VFIO V6 & public VFIO repositories
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: pugs@ieee.org, linux-pci@vger.kernel.org, mbranton@gmail.com,
        alexey.zaytsev@gmail.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        mst@redhat.com
In-Reply-To: <1292909368.16694.722.camel@pasglop>
References: <4ceafaf4.pffTeLx1ndqdBH3c%pugs@cisco.com>
	 <1292909368.16694.722.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 14:15:27 -0700
Message-ID: <1292966127.2906.53.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 16:29 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2010-11-22 at 15:21 -0800, Tom Lyon wrote:
> > VFIO "driver" development has moved to a publicly accessible respository
> > on github:
> > 
> > 	git://github.com/pugs/vfio-linux-2.6.git
> > 
> > This is a clone of the Linux-2.6 tree with all VFIO changes on the vfio 
> > branch (which is the default). There is a tag 'vfio-v6' marking the latest
> > "release" of VFIO.
> > 
> > In addition, I am open-sourcing my user level code which uses VFIO.
> > It is a simple UDP/IP/Ethernet stack supporting 3 different VFIO based
> > hardware drivers. This code is available at:
> > 
> > 	git://github.com/pugs/vfio-user-level-drivers.git
> 
> So I do have some concerns about this...
> 
> So first, before I go into the meat of my issues, let's just drop a
> quick one about the interface: why netlink ? I find it horrible
> myself... Just confuses everything and adds overhead. ioctl's would have
> been a better choice imho.

I mentioned on irc, but I'll repeat here, ioctls are used for all the
basic interactions.  IIRC, netlink is only used for error handling,
which I haven't tried to link into qemu yet.

> Now, my actual issues, which in fact extend to the whole "generic" iommu
> APIs that have been added to drivers/pci for "domains", and that in
> turns "stains" VFIO in ways that I'm not sure I can use on POWER...
> 
> I would appreciate your input on how you think is the best way for me to
> solve some of these "mismatches" between our HW and this design.
> 
> Basically, the whole iommu domain stuff has been entirely designed
> around the idea that you can create those "domains" which are each an
> entire address space, and put devices in there.
> 
> This is sadly not how the IBM iommus work on POWER today...
> 
> I have currently one "shared" DMA address space (per host bridge), but I
> can assign regions of it to different devices (and I have limited
> filtering capabilities so basically, a bus per region, a device per
> region or a function per region).
> 
> That means essentially that I cannot just create a mapping for the DMA
> addresses I want, but instead, need to have some kind of "allocator" for
> DMA translations (which we have in the kernel, ie, dma_map/unmap use a
> bitmap allocator).
> 
> I generally have 2 regions per device, one in 32-bit space of quite
> limited size (some times as small as 128M window) and one in 64-bit
> space that I can make quite large if I need to, enough to map all of
> memory if that's really desired, using large pages or something like
> that).
> 
> Now that has various consequences vs. the interfaces betweem iommu
> domains and qemu, and VFIO:
> 
>  - I don't quite see how I can translate the concept of domains and
> attaching devices to such domains. The basic idea won't work. The
> domains in my case are essentially pre-existing, not created on-the-fly,
> and may contain multiple devices tho I suppose I can assume for now that
> we only support KVM pass-through with 1 device == 1 domain.

Yep, your hardware may impose some usage restrictions and the iommu
domain may just be an index to the pre-existing context.
 
> I don't know how to sort that one out if the userspace or kvm code
> assumes it can put multiple devices in one domain and they start to
> magically share the translations...

I misremembered how I have this wired in the vfio qemu side when we
spoke on irc.  Userspace gets to make the decision which device is
associated to which iommu, and the command line options (when invoked
through libvirt) allows any combination of putting all the devices into
separate or shared iommu domains.  I expect that on x86 libvirt might
want to use a single domain for all passthrough devices for a given
guest (to reduce iommu tlb pressure), but it would also be entirely
valid to put each in it's own, which is the behavior you'd want.  From
the qemu command line (not using vfiofd & uiommufd), each device gets
it's own domain.

> Not sure what the right approach here is. I could make the "Linux"
> domain some artifical SW construct that contains a list of the real
> iommu's it's "bound" to and establish translations in all of them... but
> that isn't very efficient. If the guest kernel explicitely use some
> iommu PV ops targeting a device, I need to only setup translations for
> -that- device, not everything in the "domain".
> 
>  - The code in virt/kvm/iommu.c that assumes it can map the entire guest
> memory 1:1 in the IOMMU is just not usable for us that way. We -might-
> be able to do that for 64-bit capable devices as we can create quite
> large regions in the 64-bit space, but at the very least we need some
> kind of offset, and the guest must know about it...

Note that this is used for current qemu-kvm device assignment, not vfio
assignment.  For x86 qemu vfio we register each virtual to guest
physical mapping using VFIO_DMA_MAP_IOVA.  Since you only have a portion
of the address space available and plan to trap existing guest
hypercalls to create mappings, you'll want to set these up and tear them
down dynamically.  x86 is expecting non-iommu aware guests, so we need
to handle the entire guest address space, which maps nicely with how the
current generation of x86 iommus work.

>  - Similar deal with all the code that currently assume it can pick up a
> "virtual" address and create a mapping from that. Either we provide an
> allocator, or if we want to keep the flexibility of userspace/kvm
> choosing the virtual addresses (preferable), we need to convey some
> "ranges" information down to the user.
> 
>  - Finally, my guest are always paravirt. There's well defined Hcalls
> for inserting/removing DMA translations and we're implementing these
> since existing kernels already know how to use them. That means that
> overall, I might simply not need to use any of the above.
> 
> IE. I could have my own infrastructure for iommu, my H-calls populating
> the target iommu directly from the kernel (kvm) or qemu (via ioctls in
> the non-kvm case). Might be the best option ... but that would mean
> somewhat disentangling VFIO from uiommu...
> 
> Any suggestions ? Great ideas ?

It seems like vfio could still work for you.  You have a restricted
iommu address space, but you can also expect your guests to make use of
hcalls to setup mappings, which gives you a way to use your resources
more sparingly.  So I could imagine a model where your hcalls end up
calling into qemu vfio userspace, which does the guest physical to host
virtual translation (or some kind of allocator function).  That calls
the vfio VFIO_DMA_MAP_IOVA ioctl to map or unmap the region.  You then
need to implement an iommu interface in the host that performs the hand
waving of inserting that mapping into the translation for the device.
You probably still want something like the uiommu interface and
VFIO_DOMAIN_SET call to create a context for a device for the security
restrictions that Tom mentions, even if the mapping back to hardware
page tables is less direct than it is on x86.

Alex

