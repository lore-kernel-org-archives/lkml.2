Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0FIFvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:51:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0FIFvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:51:07 -0400
Date: Wed, 9 Jun 2010 08:45:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100609054557.GB4940@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <20100608223844.GD21815@redhat.com> <201006081654.43967.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006081654.43967.pugs@lyon-about.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 04:54:43PM -0700, Tom Lyon wrote:
> On Tuesday 08 June 2010 03:38:44 pm Michael S. Tsirkin wrote:
> > On Tue, Jun 08, 2010 at 02:21:52PM -0700, Tom Lyon wrote:
> > > The VFIO "driver" is used to allow privileged AND non-privileged processes to 
> > > implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> > > devices.
> > > 	Signed-off-by: Tom Lyon <pugs@cisco.com>
> > 
> > Some general comments:
> > - Please pass this through ./scripts/checkpatch.pl to fix some formatting.
> I did. What did you find?

Heh, it passed, sorry.

> > - Lots of hard-coded constants. Please try using pci_regs.h much more,
> >   where not possible please add named enums.
> This is mostly for lengths not specified in pci_regs, but given in standards docs.

Add them to pci_regs.h, or to named define in your code.
The largest problem is the tables though.

> > - There are places where you get parameters from userspace and pass them
> >   on to kmalloc etc. Everything you get from userspace needs to be
> >   validated.
> I  thought I had. Thats what more eyeballs are for.

That's what code comments are for :)
Go over malloc calls - each time you malloc in response
to ioctl, and keep memory around, ask yourself why isn't this a DOS
attack. If it's not, document why.

> > - You play non-standard tricks with minor numbers.
> >   Won't it be easier to just make udev create a node
> >   for the device in the way everyone does it? The name could be
> >   descriptive including e.g. bus/dev/fn so userspace can find
> >   your device.
> I just copied what uio was doing. What is "the way everyone does it?"

Everyone is an over-statement :), but look at virtio-serial for example.
Your open routine could be as simple as:

        struct cdev *cdev = inode->i_cdev;
        struct vfio_dev *dev = container_of(cdev, struct vfio_dev, vfio_cdev);

        filp->private_data = dev;


> > 
> > - I note that if we exclude the iommu mapping, the rest conceptually could belong
> >   in pci_generic driver in uio. So if we move these ioctls to the iommu driver,
> >   as Avi suggested, then vfio can be part of the uio framework.
> But the interrupt handling is different in uio;

eventfd? This can be supported IMO.

> uio doesn't support read or write calls
> to read and write registers or memory,

We don't use write in pci generic uio so this can be fixed:
all we need is pass offset and size to control call, right?

> and it doesn't support ioctls at all for other
> misc stuff.
>  If we could blow off backwards compatibility with uio, then, sure we
> could have a nice unified solution.

What I said above, *if* you move the mapping ioctl to iommu
device - no important ioctls are left after this, really.

....

> 
> > > +		/* reset to known state if we can */
> > > +		(void) pci_reset_function(vdev->pdev);
> > 
> > We are opening the device - how can it not be in a known state?
> If an alternate driver left it in a weird state.

Don't we care if it fails then? I think we do ...

> > 
> > > +	}
> > > +	vdev->listeners++;
> > > +	mutex_unlock(&vdev->lgate);
> > > +	return 0;
> > > +
> > > +err_alloc_listener:
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +static int vfio_release(struct inode *inode, struct file *filep)
> > > +{
> > > +	int ret = 0;
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +
> > > +	vfio_dma_unmapall(listener);
> > > +	if (listener->mm) {
> > > +#ifdef CONFIG_MMU_NOTIFIER
> > > +		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
> > > +#endif
> > > +		listener->mm = NULL;
> > > +	}
> > > +
> > > +	mutex_lock(&vdev->lgate);
> > > +	if (--vdev->listeners <= 0) {
> > > +		/* we don't need to hold igate here since there are
> > > +		 * no more listeners doing ioctls
> > > +		 */
> > > +		if (vdev->ev_msix)
> > > +			vfio_disable_msix(vdev);
> > > +		if (vdev->ev_msi)
> > > +			vfio_disable_msi(vdev);
> > > +		if (vdev->ev_irq) {
> > > +			eventfd_ctx_put(vdev->ev_msi);
> > > +			vdev->ev_irq = NULL;
> > > +		}
> > > +		vfio_domain_unset(vdev);
> > > +		/* reset to known state if we can */
> > > +		(void) pci_reset_function(vdev->pdev);
> > 
> > This is too late - device could be doing DMA here and we moved it from under the domain!
> OK - how about a pci_clear_master before the domain_unset?

Not all devices let you do it at any random time.
How about pci_reset_function before domain_unset?

> > 
> > And we should make sure (at open time) we *can* reset on close, fail binding if we can't.
> How do you propose?

Fail open if reset fails on open?

> > > +	if (bir == vfio_offset_to_pci_space(start) &&
> > > +	    overlap(lo, hi, startp, endp)) {
> > > +		printk(KERN_WARNING "%s: cannot write msi-x vectors\n",
> > > +			__func__);
> > > +		return -EINVAL;
> > > +	}
> > 
> > Tricky, slow, and - is it really necessary?
> > And it won't work if PAGE_SIZE is > 4K, because MSIX page is only 4K in size.
> It can be sped up with some caching.
> BTW, MSI-X can be up to 2048 entries of 16 bytes..

Right. Point is, it can be < PAGE_SIZE, so page will have other stuff in it,
so prohibiting it will create problems.

> > 
> > 
> > > +	return 0;
> > > +}
> > > +
> > > +static ssize_t vfio_write(struct file *filep, const char __user *buf,
> > > +			size_t count, loff_t *ppos)
> > > +{
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	int pci_space;
> > > +	int ret;
> > > +
> > > +	/* no reads or writes until IOMMU domain set */
> > > +	if (vdev->udomain == NULL)
> > > +		return -EINVAL;
> > > +	pci_space = vfio_offset_to_pci_space(*ppos);
> > > +	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
> > > +		return vfio_config_readwrite(1, vdev,
> > > +					(char __user *)buf, count, ppos);
> > > +	if (pci_space > PCI_ROM_RESOURCE)
> > > +		return -EINVAL;
> > > +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
> > > +		return vfio_io_readwrite(1, vdev,
> > > +					(char __user *)buf, count, ppos);
> > > +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) {
> > > +		/* don't allow writes to msi-x vectors */
> > 
> > What happens if we don't do all these checks?
> These are just sorting out config, io, and memory read/writes.

Sorry, I mean the one below.

> > 
> > > +		ret = vfio_msix_check(vdev, *ppos, count);
> > > +		if (ret)
> > > +			return ret;
> > > +		return vfio_mem_readwrite(1, vdev,
> > > +				(char __user *)buf, count, ppos);
> > > +	}
> > > +	return -EINVAL;
> > > +}
> > > +
> > > +static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
> > > +{
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	unsigned long requested, actual;
> > > +	int pci_space;
> > > +	u64 start;
> > > +	u32 len;
> > > +	unsigned long phys;
> > > +	int ret;
> > > +
> > > +	/* no reads or writes until IOMMU domain set */
> > > +	if (vdev->udomain == NULL)
> > > +		return -EINVAL;
> > > +
> > > +	if (vma->vm_end < vma->vm_start)
> > > +		return -EINVAL;
> > > +	if ((vma->vm_flags & VM_SHARED) == 0)
> > > +		return -EINVAL;
> > > +
> > > +
> > > +	pci_space = vfio_offset_to_pci_space((u64)vma->vm_pgoff << PAGE_SHIFT);
> > > +	if (pci_space > PCI_ROM_RESOURCE)
> > > +		return -EINVAL;
> > > +	switch (pci_space) {
> > > +	case PCI_ROM_RESOURCE:
> > > +		if (vma->vm_flags & VM_WRITE)
> > > +			return -EINVAL;
> > > +		if (pci_resource_flags(pdev, PCI_ROM_RESOURCE) == 0)
> > > +			return -EINVAL;
> > > +		actual = pci_resource_len(pdev, PCI_ROM_RESOURCE) >> PAGE_SHIFT;
> > > +		break;
> > > +	default:
> > > +		if ((pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) == 0)
> > > +			return -EINVAL;
> > > +		actual = pci_resource_len(pdev, pci_space) >> PAGE_SHIFT;
> > > +		break;
> > > +	}
> > > +
> > 
> > I don't think we really care about non-memory mmaps. They can all go
> > through read.
> Its conceivable that a virtual machine may want to jump to ROM code.

It can always shadow ROM if it wants to do that. And I didn't think
you can jump to code mmaped in this way - can you?

> > 
> > > +	requested = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> > > +	if (requested > actual || actual == 0)
> > > +		return -EINVAL;
> > > +
> > > +	/*
> > > +	 * Can't allow non-priv users to mmap MSI-X vectors
> > > +	 * else they can write anywhere in phys memory
> > > +	 */
> > 
> > not if there's an iommu.
> I'm not totally convinced that the IOMMU code, as implemented, forces the
> devices to use only their own vectors.  But the iommu code is deep.

MSI is just a memory write. So if it didn't, then device could
trigger interrupt for another device just by doing a memory write.
IOW, if you let userspace control the device, it's useless from security POW
to prevent control to the MSI/MSIX table.

> > 
> > > +	start = vma->vm_pgoff << PAGE_SHIFT;
> > > +	len = vma->vm_end - vma->vm_start;
> > > +	if (vma->vm_flags & VM_WRITE) {
> > > +		ret = vfio_msix_check(vdev, start, len);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	vma->vm_private_data = vdev;
> > > +	vma->vm_flags |= VM_IO | VM_RESERVED;
> > > +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > +	phys = pci_resource_start(pdev, pci_space) >> PAGE_SHIFT;
> > > +
> > > +	return remap_pfn_range(vma, vma->vm_start, phys,
> > > +			       vma->vm_end - vma->vm_start,
> > > +			       vma->vm_page_prot);
> > 
> > I think there's a security problem here:
> > userspace can do mmap, then close the file and unbind
> > device from iommu, now that device is not bound
> > (or bound to anothe rprocess)
> > access device through mmap and crash the system.
> > 
> > We must make sure device stays open until no one
> > maps the memory range.
> The memory system holds a file reference when pages are mapped; 
> the driver release routine won't be called until the region is unmapped or
> killed.

Right. sorry about the noise.

> > 
> > 
> > > +}
> > > +
> > > +static long vfio_unl_ioctl(struct file *filep,
> > > +			unsigned int cmd,
> > > +			unsigned long arg)
> > > +{
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +	void __user *uarg = (void __user *)arg;
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	struct vfio_dma_map dm;
> > > +	int ret = 0;
> > > +	u64 mask;
> > > +	int fd, nfd;
> > > +	int bar;
> > > +
> > > +	if (vdev == NULL)
> > > +		return -EINVAL;
> > > +
> > > +	switch (cmd) {
> > > +
> > > +	case VFIO_DMA_MAP_IOVA:
> > > +		if (copy_from_user(&dm, uarg, sizeof dm))
> > > +			return -EFAULT;
> > > +		ret = vfio_dma_map_common(listener, cmd, &dm);
> > > +		if (!ret && copy_to_user(uarg, &dm, sizeof dm))
> > > +			ret = -EFAULT;
> > > +		break;
> > > +
> > > +	case VFIO_DMA_UNMAP:
> > > +		if (copy_from_user(&dm, uarg, sizeof dm))
> > > +			return -EFAULT;
> > > +		ret = vfio_dma_unmap_dm(listener, &dm);
> > > +		break;
> > > +
> > > +	case VFIO_DMA_MASK:	/* set master mode and DMA mask */
> > > +		if (copy_from_user(&mask, uarg, sizeof mask))
> > > +			return -EFAULT;
> > > +		pci_set_master(pdev);
> > 
> > This better be done by userspace when it sees fit.
> > Otherwise device might corrupt userspace memory.

Hope the above is clear: userspace driver might need
to do some initializations before it lets
device write into its memory.

> > > +		ret = pci_set_dma_mask(pdev, mask);
> > > +		break;
> > 
> > Is the above needed?
> > 

....

> > So what happens if someone has a device file open and device
> > is being hot-unplugged? At a minimum, we want userspace to
> > have a way to get and handle these notifications.
> > But also remember we can not trust userspace to be well-behaved.
> For now,

And when it's fixed, how will the sysadmin know it's now safe?
It's the driver's responsibility to prevent crash and burn.

> hotplug and suspend/resume not supported -
> sys admin must not enable vfio for these devices.

For *which* devices? suspend is a system wide feature.
If device doesn't support it, make it depend on !SUSPEND && !HOTPLUG
or something?

>  I think they are doable,

Issue is, if userspace interface is designed not to support these
events, applications will be written ignoring it, and we will
be stuck. Had this problem with infiniband userspace, no
hotplug/suspend support to this day.

> but lots of testing
> work - and not important for my use case.

That's what users are for :)

> > 
> > 
> > > +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> > > +
> > > +	vfio_free_minor(vdev);
> > > +
> > > +	if (pdev->irq > 0)
> > > +		free_irq(pdev->irq, vdev);
> > > +
> > > +#ifdef notdef
> > > +	vfio_dev_del_attributes(vdev);
> > > +#endif
> > > +
> > > +	pci_set_drvdata(pdev, NULL);
> > > +	device_destroy(vfio_class->class, vdev->devnum);
> > > +	kfree(vdev);
> > > +	vfio_class_destroy();
> > > +	pci_disable_device(pdev);
> > > +}
> > > +
> > > +static struct pci_driver driver = {
> > > +	.name = "vfio",
> > > +	.id_table = NULL, /* only dynamic id's */
> > > +	.probe = vfio_probe,
> > > +	.remove = vfio_remove,
> > 
> > Also - I think we need to handle e.g. suspend in some way.
> > Again, this likely involves notifying userspace so it can
> > save state to memory.
> > 
> > > +};
> > > +
> > > +static int __init init(void)
> > > +{
> > > +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> > > +	return pci_register_driver(&driver);
> > > +}
> > > +
> > > +static void __exit cleanup(void)
> > > +{
> > > +	if (vfio_major >= 0)
> > > +		unregister_chrdev(vfio_major, "vfio");
> > > +	pci_unregister_driver(&driver);
> > > +}
> > > +
> > > +module_init(init);
> > > +module_exit(cleanup);
> > > +
> > > +MODULE_VERSION(DRIVER_VERSION);
> > > +MODULE_LICENSE("GPL v2");
> > > +MODULE_AUTHOR(DRIVER_AUTHOR);
> > > +MODULE_DESCRIPTION(DRIVER_DESC);
> > > diff -uprN linux-2.6.34/drivers/vfio/vfio_pci_config.c vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c
> > > --- linux-2.6.34/drivers/vfio/vfio_pci_config.c	1969-12-31 16:00:00.000000000 -0800
> > > +++ vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c	2010-05-28 14:26:47.000000000 -0700
> > > @@ -0,0 +1,554 @@
> > > +/*
> > > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > > + * Author: Tom Lyon, pugs@cisco.com
> > > + *
> > > + * This program is free software; you may redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation; version 2 of the License.
> > > + *
> > > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > > + * SOFTWARE.
> > > + *
> > > + * Portions derived from drivers/uio/uio.c:
> > > + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> > > + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> > > + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> > > + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> > > + *
> > > + * Portions derived from drivers/uio/uio_pci_generic.c:
> > > + * Copyright (C) 2009 Red Hat, Inc.
> > > + * Author: Michael S. Tsirkin <mst@redhat.com>
> > > + */
> > > +
> > > +#include <linux/fs.h>
> > > +#include <linux/pci.h>
> > > +#include <linux/mmu_notifier.h>
> > > +#include <linux/uaccess.h>
> > > +#include <linux/vfio.h>
> > > +
> > > +#define PCI_CAP_ID_BASIC	0
> > > +#ifndef PCI_CAP_ID_MAX
> > > +#define	PCI_CAP_ID_MAX		PCI_CAP_ID_AF
> > > +#endif
> > > +
> > > +/*
> > > + * Lengths of PCI Config Capabilities
> > > + * 0 means unknown (but at least 4)
> > > + * FF means special/variable
> > > + */
> > > +static u8 pci_capability_length[] = {
> > > +	[PCI_CAP_ID_BASIC]	= 64,		/* pci config header */
> > > +	[PCI_CAP_ID_PM]		= PCI_PM_SIZEOF,
> > > +	[PCI_CAP_ID_AGP]	= PCI_AGP_SIZEOF,
> > > +	[PCI_CAP_ID_VPD]	= 8,
> > > +	[PCI_CAP_ID_SLOTID]	= 4,
> > > +	[PCI_CAP_ID_MSI]	= 0xFF,		/* 10, 14, or 24 */
> > > +	[PCI_CAP_ID_CHSWP]	= 4,
> > > +	[PCI_CAP_ID_PCIX]	= 0xFF,		/* 8 or 24 */
> > > +	[PCI_CAP_ID_HT]		= 28,
> > > +	[PCI_CAP_ID_VNDR]	= 0xFF,
> > > +	[PCI_CAP_ID_DBG]	= 0,
> > > +	[PCI_CAP_ID_CCRC]	= 0,
> > > +	[PCI_CAP_ID_SHPC]	= 0,
> > > +	[PCI_CAP_ID_SSVID]	= 0,		/* bridge only - not supp */
> > > +	[PCI_CAP_ID_AGP3]	= 0,
> > > +	[PCI_CAP_ID_EXP]	= 36,
> > > +	[PCI_CAP_ID_MSIX]	= 12,
> > > +	[PCI_CAP_ID_AF]		= 6,
> > > +};
> > > +
> > > +/*
> > > + * Read/Write Permission Bits - one bit for each bit in capability
> > > + * Any field can be read if it exists,
> > > + * but what is read depends on whether the field
> > > + * is 'virtualized',

Using '' implies it is not really virtualized?
what exactly do you mean?

> or just pass thru to the hardware.
> > > + * Any virtualized field is also virtualized for writes.

virtualized for writes? what does it mean?

> > > + * Writes are only permitted if they have a 1 bit here.

you mean they are ignored if register is all 0, right?

> > > + */
> > > +struct perm_bits {
> > > +	u32	rvirt;		/* read bits which must be virtualized */
> > > +	u32	write;		/* writeable bits - virt if read virt */
> > > +};

By the time I got half page down, I forgot the order.
So please use .rvirt/.write initializers.

> > > +

When this table changes - as it invariably will - how
will userspace know?
We could add an ioctl to query this table - but more
ioctls, more bugs in kernel and userspace.
It would be easier if we had just one or two registers,
and just did protection, failing illegal reads/writes.
Then userspace would have a simple standard way to
find out, right where it happens, and it could deal with virtualization.

> > > +static struct perm_bits pci_cap_basic_perm[] = {

what endian-ness is all this in, btw?

> > > +	{ 0xFFFFFFFF,	0, },		/* 0x00 vendor & device id - RO */

you virtualize vendor and device id?

> > > +	{ 0,		0xFFFFFFFC, },	/* 0x04 cmd & status except mem/io */
> > > +	{ 0,		0xFF00FFFF, },	/* 0x08 bist, htype, lat, cache */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x0c bar */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x10 bar */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x14 bar */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x18 bar */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x1c bar */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x20 bar */

Virtualizing  bars is not that simple. PCI is full of
this stuff, and qemu has to do a ton of tricks in userspace.
If you are really sure we want this in kernel - and I still don't see
why - still better pass through as much as possible.

> > > +	{ 0,		0, },		/* 0x24 cardbus - not yet */
> > > +	{ 0,		0, },		/* 0x28 subsys vendor & dev */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x2c rom bar */
> > > +	{ 0,		0, },		/* 0x30 capability ptr & resv */
> > > +	{ 0,		0, },		/* 0x34 resv */
> > > +	{ 0,		0, },		/* 0x38 resv */
> > > +	{ 0x000000FF,	0x000000FF, },	/* 0x3c max_lat ... irq */

Use [] initializers here as well.
More importantly, please document *why* you are virtualizing
or blocking access, not just what you do.

irq is safe to write I think, it's for the OS, device does not use it.


> > > +};

Above it broken for non-type 0 devices. Is there a check in code
that this is what we get? Should be ...

> > > +
> > > +static struct perm_bits pci_cap_pm_perm[] = {
> > > +	{ 0,		0, },		/* 0x00 PM capabilities */
> > > +	{ 0,		0xFFFFFFFF, },	/* 0x04 PM control/status */
> > > +};
> > > +
> > > +static struct perm_bits pci_cap_vpd_perm[] = {
> > > +	{ 0,		0xFFFF0000, },	/* 0x00 address */

You don't let userspace write address?

> > > +	{ 0,		0xFFFFFFFF, },	/* 0x04 data */
> > > +};
> > > +
> > > +static struct perm_bits pci_cap_slotid_perm[] = {
> > > +	{ 0,		0, },		/* 0x00 all read only */


Why do we bother protecting readonly registers?

> > > +};
> > > +
> > > +static struct perm_bits pci_cap_msi_perm[] = {
> > > +	{ 0,		0, },		/* 0x00 MSI message control */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> > > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message addr/data */
> > > +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> > > +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI mask bits */
> > > +	{ 0,		0xFFFFFFFF, },	/* 0x14 MSI pending bits */
> > > +};
> > > +
> > > +static struct perm_bits pci_cap_pcix_perm[] = {
> > > +	{ 0,		0xFFFF0000, },	/* 0x00 PCI_X_CMD */
> > > +	{ 0,		0, },		/* 0x04 PCI_X_STATUS */
> > > +	{ 0,		0xFFFFFFFF, },	/* 0x08 ECC ctlr & status */
> > > +	{ 0,		0, },		/* 0x0c ECC first addr */
> > > +	{ 0,		0, },		/* 0x10 ECC second addr */
> > > +	{ 0,		0, },		/* 0x14 ECC attr */
> > > +};
> > > +
> > > +/* pci express capabilities */
> > > +static struct perm_bits pci_cap_exp_perm[] = {
> > > +	{ 0,		0, },		/* 0x00 PCIe capabilities */
> > > +	{ 0,		0, },		/* 0x04 PCIe device capabilities */
> > > +	{ 0,		0xFFFFFFFF, },	/* 0x08 PCIe device control & status */
> > > +	{ 0,		0, },		/* 0x0c PCIe link capabilities */
> > > +	{ 0,		0x000000FF, },	/* 0x10 PCIe link ctl/stat - SAFE? */
> > > +	{ 0,		0, },		/* 0x14 PCIe slot capabilities */
> > > +	{ 0,		0x00FFFFFF, },	/* 0x18 PCIe link ctl/stat - SAFE? */
> > > +	{ 0,		0, },		/* 0x1c PCIe root port stuff */
> > > +	{ 0,		0, },		/* 0x20 PCIe root port stuff */


better check you don't get a root port then.

> > > +};
> > > +
> > > +static struct perm_bits pci_cap_msix_perm[] = {
> > > +	{ 0,		0, },		/* 0x00 MSI-X Enable */
> > > +	{ 0,		0, },		/* 0x04 table offset & bir */
> > > +	{ 0,		0, },		/* 0x08 pba offset & bir */
> > > +};
> > > +
> > > +static struct perm_bits pci_cap_af_perm[] = {
> > > +	{ 0,		0, },		/* 0x00 af capability */
> > > +	{ 0,		0x0001,	 },	/* 0x04 af flr bit */
> > > +};
> > > +
> > > +static struct perm_bits *pci_cap_perms[] = {
> > > +	[PCI_CAP_ID_BASIC]	= pci_cap_basic_perm,
> > > +	[PCI_CAP_ID_PM]		= pci_cap_pm_perm,
> > > +	[PCI_CAP_ID_VPD]	= pci_cap_vpd_perm,
> > > +	[PCI_CAP_ID_SLOTID]	= pci_cap_slotid_perm,
> > > +	[PCI_CAP_ID_MSI]	= pci_cap_msi_perm,
> > > +	[PCI_CAP_ID_PCIX]	= pci_cap_pcix_perm,
> > > +	[PCI_CAP_ID_EXP]	= pci_cap_exp_perm,
> > > +	[PCI_CAP_ID_MSIX]	= pci_cap_msix_perm,
> > > +	[PCI_CAP_ID_AF]		= pci_cap_af_perm,
> > > +};

Disallowing access or 'virtualizing' - by which I think
you mean replacing write with read modify write? Should
really be very special case.

Can't simple open-coded C work?
	if (addr == PCI_COMMAND)
		return -EPERM;

....




> > > +
> > > +/*
> > > + * We build a map of the config space that tells us where
> > > + * and what capabilities exist, so that we can map reads and
> > > + * writes back to capabilities, and thus figure out what to
> > > + * allow, deny, or virtualize
> > > + */
> > 
> > So the above looks like it is very unlikely to be exhaustive and
> > correct. Maybe there aren't bugs in this table to be found just by
> > looking hard at the spec, but likely will surface when someone tries
> > to actually run driver with e.g. a working pm on top.
> > Let's ask another question:
> > 
> > since we have the iommu protecting us, can't all or most of this be
> > done in userspace? What can userspace do that will harm the host?
> > I think each place where we block access to a register, there should
> > be a very specific documentation for why we do this.
> I think, in an ideal world, you would be correct.  I don't trust either
> the hardware or the iommu software

Not sure adding emulation bugs on top will help though: and
we will break userspace. Note how there's no way for userspace
to query the tables to figure out what works and what doesn't.

> to feel good about this though.

About documenting the tables? Me too, but for different reasons:
if there are bugs, we should be finding them and documenting
what they are, not plastering over.

> > 
> > 
> > > +int vfio_build_config_map(struct vfio_dev *vdev)
> > > +{
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	u8 *map;
> > > +	int i, len;
> > > +	u8 pos, cap, tmp;
> > > +	u16 flags;
> > > +	int ret;
> > > +	int loops = 100;
> > 
> > 100?
> Why not?

The answer's 42. Document the constants please.


> > 
> > 
> > .....
> > 
> > > +int vfio_dma_map_common(struct vfio_listener *listener,
> > > +		unsigned int cmd, struct vfio_dma_map *dmp)
> > > +{
> > > +	int locked, lock_limit;
> > > +	struct page **pages;
> > > +	int npage;
> > > +	struct dma_map_page *mlp;
> > > +	int rdwr = (dmp->flags & VFIO_FLAG_WRITE) ? 1 : 0;
> > > +	int ret = 0;
> > > +
> > > +	if (dmp->vaddr & (PAGE_SIZE-1))
> > > +		return -EINVAL;
> > > +	if (dmp->size & (PAGE_SIZE-1))
> > > +		return -EINVAL;
> > > +	if (dmp->size <= 0)
> > > +		return -EINVAL;
> > > +	npage = dmp->size >> PAGE_SHIFT;
> > > +	if (npage <= 0)
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&listener->vdev->dgate);
> > > +
> > > +	/* account for locked pages */
> > > +	locked = npage + current->mm->locked_vm;
> > > +	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur
> > > +			>> PAGE_SHIFT;
> > > +	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
> > > +		printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
> > > +			__func__);
> > > +		ret = -ENOMEM;
> > > +		goto out_lock;
> > > +	}
> > > +	/* only 1 address space per fd */
> > > +	if (current->mm != listener->mm) {
> > 
> > Why is that?
> Its OK to have multiple fds per device, but multiple address spaces per fd
> means somebody forked - and I don't know how to keep track of mmu 
> notifications once that happens.

Maybe we need a notifier for that :) I thought we lock the memory
though - using the mlock rlimit - so why are we using notifiers
at all?

Just noticed this btw:

+static void vfio_dma_handle_mmu_notify(struct mmu_notifier *mn,
+               unsigned long start, unsigned long end)
+{
+       struct vfio_listener *listener;
+       unsigned long myend;
+       struct list_head *pos, *pos2;
+       struct dma_map_page *mlp;
+
+       listener = container_of(mn, struct vfio_listener, mmu_notifier);
+       mutex_lock(&listener->vdev->dgate);
+       list_for_each_safe(pos, pos2, &listener->dm_list) {
+               mlp = list_entry(pos, struct dma_map_page, list);
+               if (mlp->vaddr >= end)

I think you can't do a mutex: mmu notifiers are called
under rcu critical section. Also, userspace can make the dm_list
very long, making the rcu critical section very long.
Set some limit on the number of entries, and replace list
with an array? Or use a tree?


> > 
> > > +		if (listener->mm != NULL) {
> > > +			ret = -EINVAL;
> > > +			goto out_lock;
> > > +		}
> > > +		listener->mm = current->mm;
> > > +#ifdef CONFIG_MMU_NOTIFIER
> > > +		listener->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
> > > +		ret = mmu_notifier_register(&listener->mmu_notifier,
> > > +						listener->mm);
> > > +		if (ret)
> > > +			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
> > > +				__func__, ret);
> > > +		ret = 0;
> > > +#endif
> > > +	}
> > > +
> > > +	pages = kzalloc(npage * sizeof(struct page *), GFP_KERNEL);
> > 
> > If you map a 4G region, this will try to allocate 8Mbytes?
> Yes. Ce la vie.

First of all, this will fail - and the request is quite real with
decent sized guests. Second, with appropriately sized allocs before failing
it will stress the system pretty hard. Split it in chunks of 4K or something.

> > 
> > > +	if (pages == NULL) {
> > > +		ret = ENOMEM;
> > > +		goto out_lock;
> > > +	}
> > > +	ret = get_user_pages_fast(dmp->vaddr, npage, rdwr, pages);
> > > +	if (ret != npage) {
> > > +		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
> > > +			__func__, ret, npage);
> > > +		kfree(pages);
> > > +		ret = -EFAULT;
> > > +		goto out_lock;
> > > +	}
> > > +	ret = 0;
> > > +
> > > +	mlp = vfio_dma_map_iova(listener, dmp->dmaaddr,
> > > +				pages, npage, rdwr);
> > > +	if (IS_ERR(mlp)) {
> > > +		ret = PTR_ERR(mlp);
> > > +		kfree(pages);
> > > +		goto out_lock;
> > > +	}
> > > +	mlp->vaddr = dmp->vaddr;
> > > +	mlp->rdwr = rdwr;
> > > +	dmp->dmaaddr = mlp->daddr;
> > > +	list_add(&mlp->list, &listener->dm_list);
> > > +
> > > +	current->mm->locked_vm += npage;
> > > +	listener->vdev->locked_pages += npage;
> > > +out_lock:
> > > +	mutex_unlock(&listener->vdev->dgate);
> > > +	return ret;
> > > +}
> > > +
> > 
> 
