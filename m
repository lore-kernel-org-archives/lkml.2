Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab2AMWWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:22:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311Ab2AMWWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:22:04 -0500
Message-ID: <1326493296.5945.76.camel@bling.home>
Subject: Re: [PATCH 0/5] VFIO core framework
From: Alex Williamson <alex.williamson@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: anthony.perard@citrix.com, chrisw@sous-sol.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, joerg.roedel@amd.com, agraf@suse.de,
        benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
        B07421@freescale.com, avi@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Jan 2012 15:21:36 -0700
In-Reply-To: <20120112205647.GA17689@phenom.dumpdata.com>
References: <20111221213019.27028.26890.stgit@bling.home>
	 <20120110162631.GB22499@phenom.dumpdata.com>
	 <1326220554.1605.107.camel@bling.home>
	 <20120112205647.GA17689@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 15:56 -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 10, 2012 at 11:35:54AM -0700, Alex Williamson wrote:
> > On Tue, 2012-01-10 at 11:26 -0500, Konrad Rzeszutek Wilk wrote:
> > > On Wed, Dec 21, 2011 at 02:42:02PM -0700, Alex Williamson wrote:
> > > > This series includes the core framework for the VFIO driver.
> > > > VFIO is a userspace driver interface meant to replace both the
> > > > KVM device assignment code as well as interfaces like UIO.  Please
> > > > see patch 1/5 for a complete description of VFIO, what it can do,
> > > > and how it's designed.
> > > > 
> > > > This version and the VFIO PCI bus driver, for exposing PCI devices
> > > > through VFIO, can be found here:
> > > > 
> > > > git://github.com/awilliam/linux-vfio.git vfio-next-20111221
> > > > 
> > > > A development version of qemu which includes a full working
> > > > vfio-pci driver, indepdendent of KVM support, can be found here:
> > > > 
> > > > git://github.com/awilliam/qemu-vfio.git vfio-ng
> > > > 
> > > > Thanks,
> > > 
> > > Alex,
> > > 
> > > So I took a look at the patchset with two different things in mind this time:
> > >  - What if you do not need to do any IRQ ack/de-ack etc in the host all of that
> > >    is done in the guest (say you have an actual IOAPIC in the guest that is
> > >    _not_ managed by QEMU).
> > >  - What would be required to make this work with a different hypervisor - say Xen.
> > > 
> > > And the conclusions I came to that it would require some surgery - especially
> > > as some of the IRQ, irqfs, etc code support is not required per say.
> > > 
> > > To me it seems to get this working with Xen (or perhaps with the Power machines
> > > as well, as their hypervisor is similar to Xen in architecture?) we would need at
> > > least two extra pieces of Linux kernel code: 
> > > - Xen IOMMU, which really is just doing a whole bunch of xc_domain_memory_mapping
> > >   the user-space iova calls. For the normal PCI devices operations it would just
> > >   offload them to the existing DMA API.
> > > - Xen VFIO PCI. Or at least make the VFIO PCI (in your vfio-next-20111221 branch)
> > >   driver allow some abstraction. There are certain things we might done via alternate
> > >   operations. Such as the interrupt handling - where we "bind" the IRQ to an event
> > >   channel or make a hypercall to program the guest' MSI vectors. Perhaps there can
> > >   be an "platform-specific" part of it.
> > 
> > Sure, I've envisioned that we'll have multiple iommu interfaces.  We'll
> > need build-time and run-time selection.  I haven't implemented that yet
> > since the iommu requirements are still developing.  Likewise, a
> > vfio-xen-pci module is possible or we can look at whether we make the
> > vfio-pci code too ugly by incorporating a dual-mode into that.
> 
> Yuck. Well, I am all up for making it pretty.
> 
> > 
> > > In the userland:
> > >  - In QEMU VFIO, make the interrupt part optional for certain parts (like we don't
> > >    expect an IRQ to happen in the host).
> > 
> > Or can it be handled by vfio-xen-pci, which enables event channels
> > through to xen?  It's possible the GET_IRQ_INFO ioctls could report a
> 
> Sure.
> > flag indicating the type of notification available (eventfds being the
> > initial option) and SET_IRQ_EVENTFDS could be generalized to take an
> > array of structs other than eventfds.  For the non-Xen case, eventfds
> > seem to provide us with the most flexibility since we can either connect
> > them to userspace or just have userspace be the agent that connects the
> > eventfd to an irqfd in another module.  See the (outdated) version of
> > qemu-kvm vfio in this tree for an example (look for QEMU_KVM_BUILD):
> > https://github.com/awilliam/qemu-kvm-vfio/blob/vfio/hw/vfio.c
> 
> Ah I see.

Here's how I'm thinking of reworking the IRQ ioctls, this should allow
more generic future extensions and consolidates what we have now:

VFIO_DEVICE_GET_IRQ_INFO
	_IOWR(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_info)

struct vfio_irq_info {
        __u32   argsz;
        __u32   flags;
#define VFIO_IRQ_INFO_EVENTFD           (1 << 0) /* Supports eventfd signals */
#define VFIO_IRQ_INFO_MASKABLE          (1 << 1) /* Supports un/masking */
#define VFIO_IRQ_INFO_AUTOMASKED        (1 << 2) /* Auto masked after trigger */
        __u32   index;          /* IRQ index */
        __u32   count;          /* Number of IRQs within this index */
};

I previously had a LEVEL flag here, but that just means that it's
automatically masked and needs to be unmasked to re-trigger, so we might
as well just name it AUTOMASKED.  We can also add a bit for MASKABLE,
which enables us to do things like optionally supporting MSI/MSI-X
masking (level triggered would be expected to set both MASKABLE &
AUTOMASKED).  The EVENTFD flag indicates that it supports EVENTFD based
triggering, so we can clear that and add another flag if we need to use
a different mechanism.

VFIO_DEVICE_SET_IRQS
	_IOW(VFIO_TYPE, VFIO_BASE + 11, struct vfio_irq_set)

struct vfio_irq_set {
        __u32   argsz;
        __u32   flags;
#define VFIO_IRQ_SET_SINGLE             (1 << 0) /* count = subindex */
#define VFIO_IRQ_SET_MASK               (1 << 1) /* mask/unmask irq(s) */
#define VFIO_IRQ_SET_TRIGGER_EVENTFD    (1 << 2) /* Set eventfds for trigger */
#define VFIO_IRQ_SET_MASK_EVENTFD       (1 << 3) /* Set eventfds for mask */
#define VFIO_IRQ_SET_UNMASK_EVENTFD     (1 << 4) /* Set eventfds for unmask */
        __u32   index;          /* IRQ index */
        __s32   count;          /* Number of data array elements */
        __u8    data[];         /* Flag specific data array */
};

Here the caller now needs to set a flag indicating what they're setting.
SINGLE is a modifier flag, when set we use count field as the subindex
of the interrupt index block and only apply the data to that entry.
When clear, count indicates the size of the data array and each entry is
applied to the corresponding subindex.

MASK is an action flag, when set data is a u8 indicating 0/1 mask state
(this replaces VFIO_DEVICE_UNMASK_IRQ).

TRIGGER_EVENTFD, MASK_EVENTFD, and UNMASK_EVENTFD are also action flags.
When these are used, data is an s32 indicating the eventfd using for the
indicated action.  I imagine that we'll eventually be able tie all of
these directly to kvm with eventfd<->irqfd binding to avoid kernel
exits.

Only one "action" flag is allowed, "modifier" flags can be used in
conjunction with action flags.  

I'm wondering if EVENTFD should be a modifier here so that we don't have
to duplicate trigger, mask, and unmask for every signaling type that we
want to use.  Also considering if we need an ALL in addition to SINGLE
to facilitate anything.  I currently use count = 0 to tear down setup.

Would something like this be useful so that we can more easily
incorporate new signaling mechanisms?

> > 
> > > I am curious to see how the Power folks have to deal with this? Perhaps the requirement
> > > to write an PV IOMMU is not something they need to write?
> > > 
> > > In terms of this patchset, the "big" thing for me is that it moves the usual mechanism
> > > of "unbind"/"bind" of using the SysFS to be done via ioctls. I get the reasoning for it
> > > - cannot guarantee any locking, but doing it all in ioctls instead of configfs or sysfs
> > > seems odd. But perhaps that is just me having gotten use to doing it in sysfs/configfs.
> > > Certainly it makes it easier to program in QEMU/libvirt. And ultimately that is going
> > > to be user for 99% of this.
> > 
> > Can you be more specific about which ioctl part you're referring to?  We
> > bind/unbind each device to vfio-pci via the normal sysfs driver
> 
> Let me look again at the QEMU changes. I was thinking you did a bunch
> of ioctls to assign a device, but I am probably getting it confused
> with the vfio-group ioctls.

I try to outline this in 1/5 with the very basic example of setting up a
device.  It does take a fair number of ioctl calls, but that's hard to
avoid.  There are a few things here that we used to do via sysfs, like
reading through the resource file and using resource# for device access.
Those are effectively duplicated in vfio, bit they're generalized to not
be device type specific.  To summarize the steps:

 - $GROUP = open($GROUP_FILE)
 - ioctl($GROUP, VFIO_GROUP_GET_INFO,)
 - $IOMMU = ioctl($GROUP, VFIO_GROUP_GET_IOMMU_FD)
 - ioctl($IOMMU, VFIO_IOMMU_GET_INFO,)
 - ioctl($IOMMU, VFIO_IOMMU_MAP_DMA,)
 - $DEVICE = ioctl($GROUP, VFIO_GROU_GET_DEVICE_FD)
 - ioctl($DEVICE, VFIO_DEVICE_GET_INFO)
 - ioctl($DEVICE, VFIO_DEVICE_GET_REGION_INFO)
 - mmap/read/write($DEVICE)
 - ioctl($DEVICE, VFIO_DEVICE_GET_IRQ_INFO)
 - ioctl($DEVICE, VFIO_DEVICE_SET_IRQ)

Thanks,

Alex

