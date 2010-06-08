Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0FHWnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:43:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0FHWns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:43:48 -0400
Date: Wed, 9 Jun 2010 01:38:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100608223844.GD21815@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 02:21:52PM -0700, Tom Lyon wrote:
> The VFIO "driver" is used to allow privileged AND non-privileged processes to 
> implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> devices.
> 	Signed-off-by: Tom Lyon <pugs@cisco.com>

Some general comments:
- Please pass this through ./scripts/checkpatch.pl to fix some formatting.
- Lots of hard-coded constants. Please try using pci_regs.h much more,
  where not possible please add named enums.
- There are places where you get parameters from userspace and pass them
  on to kmalloc etc. Everything you get from userspace needs to be
  validated.
- You play non-standard tricks with minor numbers.
  Won't it be easier to just make udev create a node
  for the device in the way everyone does it? The name could be
  descriptive including e.g. bus/dev/fn so userspace can find
  your device.

- I note that if we exclude the iommu mapping, the rest conceptually could belong
  in pci_generic driver in uio. So if we move these ioctls to the iommu driver,
  as Avi suggested, then vfio can be part of the uio framework.

> ---
> This version now requires an IOMMU domain to be set before any access to
> device registers is granted (except that config space may be read).  In
> addition, the VFIO_DMA_MAP_ANYWHERE is dropped - it used the dma_map_sg API
> which does not have sufficient controls around IOMMU usage.  The IOMMU domain
> is obtained from the 'uiommu' driver which is included in this patch.
> 
> Various locking, security, and documentation issues have also been fixed.
> 
> Please commit - it or me!
> But seriously, who gets to commit this? Avi for KVM? or GregKH for drivers?
> 
> Blurb from previous patch version:
> 
> This patch is the evolution of code which was first proposed as a patch to
> uio/uio_pci_generic, then as a more generic uio patch. Now it is taken entirely
> out of the uio framework, and things seem much cleaner. Of course, there is
> a lot of functional overlap with uio, but the previous version just seemed
> like a giant mode switch in the uio code that did not lead to clarity for
> either the new or old code.
> 
> [a pony for avi...]
> The major new functionality in this version is the ability to deal with
> PCI config space accesses (through read & write calls) - but includes table
> driven code to determine whats safe to write and what is not. Also, some
> virtualization of the config space to allow drivers to think they're writing
> some registers when they're not.  Also, IO space accesses are also allowed.
> Drivers for devices which use MSI-X are now prevented from directly writing
> the MSI-X vector area.

This table adds a lot of complexity to the code,
and I don't really understand why we need this code in
kernel: isn't the point of iommu that it protects us
from buggy devices? If yes, we should be able to
just ask userspace to be careful and avoid doing silly things
like overwriting MSI-X vectors, and if it's not careful,
no one gets hurt :)

If some registers absolutely must be protected,
I think we should document this carefully in code.

> +/*
> + * MSI and MSI-X Interrupt handler.
> + * Just signal an event
> + */
> +static irqreturn_t msihandler(int irq, void *arg)
> +{
> +	struct eventfd_ctx *ctx = arg;
> +
> +	eventfd_signal(ctx, 1);
> +	return IRQ_HANDLED;
> +}
> +
> +void vfio_disable_msi(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +
> +	if (vdev->ev_msi) {
> +		eventfd_ctx_put(vdev->ev_msi);
> +		free_irq(pdev->irq, vdev->ev_msi);
> +		vdev->ev_msi = NULL;
> +	}
> +	pci_disable_msi(pdev);
> +}
> +
> +int vfio_enable_msi(struct vfio_dev *vdev, int fd)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct eventfd_ctx *ctx;
> +	int ret;
> +
> +	ctx = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
> +	vdev->ev_msi = ctx;
> +	pci_enable_msi(pdev);
> +	ret = request_irq(pdev->irq, msihandler, 0,
> +			vdev->name, ctx);
> +	if (ret) {
> +		eventfd_ctx_put(ctx);
> +		pci_disable_msi(pdev);
> +		vdev->ev_msi = NULL;
> +	}
> +	return ret;
> +}
> +
> +void vfio_disable_msix(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int i;
> +
> +	if (vdev->ev_msix && vdev->msix) {
> +		for (i = 0; i < vdev->nvec; i++) {
> +			free_irq(vdev->msix[i].vector, vdev->ev_msix[i]);
> +			if (vdev->ev_msix[i])
> +				eventfd_ctx_put(vdev->ev_msix[i]);
> +		}
> +	}
> +	kfree(vdev->ev_msix);
> +	vdev->ev_msix = NULL;
> +	kfree(vdev->msix);
> +	vdev->msix = NULL;
> +	vdev->nvec = 0;
> +	pci_disable_msix(pdev);
> +}
> +
> +int vfio_enable_msix(struct vfio_dev *vdev, int nvec, void __user *uarg)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct eventfd_ctx *ctx;
> +	int ret = 0;
> +	int i;
> +	int fd;
> +
> +	vdev->msix = kzalloc(nvec * sizeof(struct msix_entry),
> +				GFP_KERNEL);

kzalloc with size coming from userspace? And it's signed. Ugh.
I think you should just enable all vectors and map them,
at startup.

> +	if (vdev->msix == NULL)
> +		return -ENOMEM;
> +	vdev->ev_msix = kzalloc(nvec * sizeof(struct eventfd_ctx *),
> +				GFP_KERNEL);
> +	if (vdev->ev_msix == NULL) {
> +		kfree(vdev->msix);
> +		return -ENOMEM;
> +	}
> +	for (i = 0; i < nvec; i++) {
> +		if (copy_from_user(&fd, uarg, sizeof fd)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +		uarg += sizeof fd;
> +		ctx = eventfd_ctx_fdget(fd);
> +		if (IS_ERR(ctx)) {
> +			ret = PTR_ERR(ctx);
> +			break;
> +		}
> +		vdev->msix[i].entry = i;
> +		vdev->ev_msix[i] = ctx;
> +	}
> +	if (!ret)
> +		ret = pci_enable_msix(pdev, vdev->msix, nvec);
> +	vdev->nvec = 0;
> +	for (i = 0; i < nvec && !ret; i++) {
> +		ret = request_irq(vdev->msix[i].vector, msihandler, 0,
> +			vdev->name, vdev->ev_msix[i]);
> +		if (ret)
> +			break;
> +		vdev->nvec = i+1;
> +	}
> +	if (ret)
> +		vfio_disable_msix(vdev);
> +	return ret;
> +}
> diff -uprN linux-2.6.34/drivers/vfio/vfio_main.c vfio-linux-2.6.34/drivers/vfio/vfio_main.c
> --- linux-2.6.34/drivers/vfio/vfio_main.c	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/drivers/vfio/vfio_main.c	2010-06-07 12:39:17.000000000 -0700
> @@ -0,0 +1,624 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/mm.h>
> +#include <linux/idr.h>
> +#include <linux/string.h>
> +#include <linux/interrupt.h>
> +#include <linux/fs.h>
> +#include <linux/eventfd.h>
> +#include <linux/pci.h>
> +#include <linux/iommu.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/uaccess.h>
> +
> +#include <linux/vfio.h>
> +
> +
> +#define DRIVER_VERSION	"0.1"
> +#define DRIVER_AUTHOR	"Tom Lyon <pugs@cisco.com>"
> +#define DRIVER_DESC	"VFIO - User Level PCI meta-driver"
> +
> +static int vfio_major = -1;
> +DEFINE_IDR(vfio_idr);
> +/* Protect idr accesses */
> +DEFINE_MUTEX(vfio_minor_lock);
> +
> +/*
> + * Does [a1,b1) overlap [a2,b2) ?
> + */
> +static inline int overlap(int a1, int b1, int a2, int b2)
> +{
> +	/*
> +	 * Ranges overlap if they're not disjoint; and they're
> +	 * disjoint if the end of one is before the start of
> +	 * the other one.
> +	 */
> +	return !(b2 <= a1 || b1 <= a2);
> +}
> +
> +static int vfio_open(struct inode *inode, struct file *filep)
> +{
> +	struct vfio_dev *vdev;
> +	struct vfio_listener *listener;
> +	int ret = 0;
> +
> +	mutex_lock(&vfio_minor_lock);
> +	vdev = idr_find(&vfio_idr, iminor(inode));
> +	mutex_unlock(&vfio_minor_lock);

Instead of all this complexity, can't we just stick a pointer to your device
in 'struct cdev *i_cdev' on the inode?

> +	if (!vdev) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	listener = kzalloc(sizeof(*listener), GFP_KERNEL);
> +	if (!listener) {
> +		ret = -ENOMEM;
> +		goto err_alloc_listener;
> +	}
> +
> +	listener->vdev = vdev;
> +	INIT_LIST_HEAD(&listener->dm_list);
> +	filep->private_data = listener;
> +
> +	mutex_lock(&vdev->lgate);
> +	if (vdev->listeners == 0) {		/* first open */
> +		/* reset to known state if we can */
> +		(void) pci_reset_function(vdev->pdev);

We are opening the device - how can it not be in a known state?

> +	}
> +	vdev->listeners++;
> +	mutex_unlock(&vdev->lgate);
> +	return 0;
> +
> +err_alloc_listener:
> +out:
> +	return ret;
> +}
> +
> +static int vfio_release(struct inode *inode, struct file *filep)
> +{
> +	int ret = 0;
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +
> +	vfio_dma_unmapall(listener);
> +	if (listener->mm) {
> +#ifdef CONFIG_MMU_NOTIFIER
> +		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
> +#endif
> +		listener->mm = NULL;
> +	}
> +
> +	mutex_lock(&vdev->lgate);
> +	if (--vdev->listeners <= 0) {
> +		/* we don't need to hold igate here since there are
> +		 * no more listeners doing ioctls
> +		 */
> +		if (vdev->ev_msix)
> +			vfio_disable_msix(vdev);
> +		if (vdev->ev_msi)
> +			vfio_disable_msi(vdev);
> +		if (vdev->ev_irq) {
> +			eventfd_ctx_put(vdev->ev_msi);
> +			vdev->ev_irq = NULL;
> +		}
> +		vfio_domain_unset(vdev);
> +		/* reset to known state if we can */
> +		(void) pci_reset_function(vdev->pdev);

This is too late - device could be doing DMA here and we moved it from under the domain!

And we should make sure (at open time) we *can* reset on close, fail binding if we can't.


> +	}
> +	mutex_unlock(&vdev->lgate);
> +
> +	kfree(listener);
> +	return ret;
> +}
> +
> +static ssize_t vfio_read(struct file *filep, char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	struct pci_dev *pdev = vdev->pdev;
> +	int pci_space;
> +
> +	/* no reads or writes until IOMMU domain set */
> +	if (vdev->udomain == NULL)
> +		return -EINVAL;
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
> +		return vfio_config_readwrite(0, vdev, buf, count, ppos);
> +	if (pci_space > PCI_ROM_RESOURCE)
> +		return -EINVAL;
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
> +		return vfio_io_readwrite(0, vdev, buf, count, ppos);
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM)
> +		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
> +	if (pci_space == PCI_ROM_RESOURCE)
> +		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
> +	return -EINVAL;
> +}
> +
> +static int vfio_msix_check(struct vfio_dev *vdev, u64 start, u32 len)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u16 pos;
> +	u32 table_offset;
> +	u16 table_size;
> +	u8 bir;
> +	u32 lo, hi, startp, endp;
> +
> +	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> +	if (!pos)
> +		return 0;
> +
> +	pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &table_size);
> +	table_size = (table_size & PCI_MSIX_FLAGS_QSIZE) + 1;
> +	pci_read_config_dword(pdev, pos + 4, &table_offset);
> +	bir = table_offset & PCI_MSIX_FLAGS_BIRMASK;
> +	lo = table_offset >> PAGE_SHIFT;
> +	hi = (table_offset + PCI_MSIX_ENTRY_SIZE * table_size + PAGE_SIZE - 1)
> +		>> PAGE_SHIFT;
> +	startp = start >> PAGE_SHIFT;
> +	endp = (start + len + PAGE_SIZE - 1) >> PAGE_SHIFT;

PAGE_ALIGN here and elsewhere?

> +	if (bir == vfio_offset_to_pci_space(start) &&
> +	    overlap(lo, hi, startp, endp)) {
> +		printk(KERN_WARNING "%s: cannot write msi-x vectors\n",
> +			__func__);
> +		return -EINVAL;
> +	}

Tricky, slow, and - is it really necessary?
And it won't work if PAGE_SIZE is > 4K, because MSIX page is only 4K in size.


> +	return 0;
> +}
> +
> +static ssize_t vfio_write(struct file *filep, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	struct pci_dev *pdev = vdev->pdev;
> +	int pci_space;
> +	int ret;
> +
> +	/* no reads or writes until IOMMU domain set */
> +	if (vdev->udomain == NULL)
> +		return -EINVAL;
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
> +		return vfio_config_readwrite(1, vdev,
> +					(char __user *)buf, count, ppos);
> +	if (pci_space > PCI_ROM_RESOURCE)
> +		return -EINVAL;
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
> +		return vfio_io_readwrite(1, vdev,
> +					(char __user *)buf, count, ppos);
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) {
> +		/* don't allow writes to msi-x vectors */

What happens if we don't do all these checks?

> +		ret = vfio_msix_check(vdev, *ppos, count);
> +		if (ret)
> +			return ret;
> +		return vfio_mem_readwrite(1, vdev,
> +				(char __user *)buf, count, ppos);
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	struct pci_dev *pdev = vdev->pdev;
> +	unsigned long requested, actual;
> +	int pci_space;
> +	u64 start;
> +	u32 len;
> +	unsigned long phys;
> +	int ret;
> +
> +	/* no reads or writes until IOMMU domain set */
> +	if (vdev->udomain == NULL)
> +		return -EINVAL;
> +
> +	if (vma->vm_end < vma->vm_start)
> +		return -EINVAL;
> +	if ((vma->vm_flags & VM_SHARED) == 0)
> +		return -EINVAL;
> +
> +
> +	pci_space = vfio_offset_to_pci_space((u64)vma->vm_pgoff << PAGE_SHIFT);
> +	if (pci_space > PCI_ROM_RESOURCE)
> +		return -EINVAL;
> +	switch (pci_space) {
> +	case PCI_ROM_RESOURCE:
> +		if (vma->vm_flags & VM_WRITE)
> +			return -EINVAL;
> +		if (pci_resource_flags(pdev, PCI_ROM_RESOURCE) == 0)
> +			return -EINVAL;
> +		actual = pci_resource_len(pdev, PCI_ROM_RESOURCE) >> PAGE_SHIFT;
> +		break;
> +	default:
> +		if ((pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) == 0)
> +			return -EINVAL;
> +		actual = pci_resource_len(pdev, pci_space) >> PAGE_SHIFT;
> +		break;
> +	}
> +

I don't think we really care about non-memory mmaps. They can all go
through read.

> +	requested = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +	if (requested > actual || actual == 0)
> +		return -EINVAL;
> +
> +	/*
> +	 * Can't allow non-priv users to mmap MSI-X vectors
> +	 * else they can write anywhere in phys memory
> +	 */

not if there's an iommu.

> +	start = vma->vm_pgoff << PAGE_SHIFT;
> +	len = vma->vm_end - vma->vm_start;
> +	if (vma->vm_flags & VM_WRITE) {
> +		ret = vfio_msix_check(vdev, start, len);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	vma->vm_private_data = vdev;
> +	vma->vm_flags |= VM_IO | VM_RESERVED;
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	phys = pci_resource_start(pdev, pci_space) >> PAGE_SHIFT;
> +
> +	return remap_pfn_range(vma, vma->vm_start, phys,
> +			       vma->vm_end - vma->vm_start,
> +			       vma->vm_page_prot);

I think there's a security problem here:
userspace can do mmap, then close the file and unbind
device from iommu, now that device is not bound
(or bound to anothe rprocess)
access device through mmap and crash the system.

We must make sure device stays open until no one
maps the memory range.


> +}
> +
> +static long vfio_unl_ioctl(struct file *filep,
> +			unsigned int cmd,
> +			unsigned long arg)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	void __user *uarg = (void __user *)arg;
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct vfio_dma_map dm;
> +	int ret = 0;
> +	u64 mask;
> +	int fd, nfd;
> +	int bar;
> +
> +	if (vdev == NULL)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +
> +	case VFIO_DMA_MAP_IOVA:
> +		if (copy_from_user(&dm, uarg, sizeof dm))
> +			return -EFAULT;
> +		ret = vfio_dma_map_common(listener, cmd, &dm);
> +		if (!ret && copy_to_user(uarg, &dm, sizeof dm))
> +			ret = -EFAULT;
> +		break;
> +
> +	case VFIO_DMA_UNMAP:
> +		if (copy_from_user(&dm, uarg, sizeof dm))
> +			return -EFAULT;
> +		ret = vfio_dma_unmap_dm(listener, &dm);
> +		break;
> +
> +	case VFIO_DMA_MASK:	/* set master mode and DMA mask */
> +		if (copy_from_user(&mask, uarg, sizeof mask))
> +			return -EFAULT;
> +		pci_set_master(pdev);

This better be done by userspace when it sees fit.
Otherwise device might corrupt userspace memory.

> +		ret = pci_set_dma_mask(pdev, mask);
> +		break;

Is the above needed?

> +
> +	case VFIO_EVENTFD_IRQ:
> +		if (copy_from_user(&fd, uarg, sizeof fd))
> +			return -EFAULT;
> +		mutex_lock(&vdev->igate);
> +		if (vdev->ev_irq)
> +			eventfd_ctx_put(vdev->ev_irq);
> +		if (fd >= 0) {
> +			vdev->ev_irq = eventfd_ctx_fdget(fd);
> +			if (vdev->ev_irq == NULL)
> +				ret = -EINVAL;
> +		}
> +		mutex_unlock(&vdev->igate);
> +		break;
> +
> +	case VFIO_EVENTFD_MSI:
> +		if (copy_from_user(&fd, uarg, sizeof fd))
> +			return -EFAULT;
> +		mutex_lock(&vdev->igate);
> +		if (fd >= 0 && vdev->ev_msi == NULL && vdev->ev_msix == NULL)
> +			ret = vfio_enable_msi(vdev, fd);
> +		else if (fd < 0 && vdev->ev_msi)
> +			vfio_disable_msi(vdev);
> +		else
> +			ret = -EINVAL;
> +		mutex_unlock(&vdev->igate);
> +		break;
> +
> +	case VFIO_EVENTFDS_MSIX:
> +		if (copy_from_user(&nfd, uarg, sizeof nfd))
> +			return -EFAULT;
> +		uarg += sizeof nfd;
> +		mutex_lock(&vdev->igate);
> +		if (nfd > 0 && vdev->ev_msi == NULL && vdev->ev_msix == NULL)
> +			ret = vfio_enable_msix(vdev, nfd, uarg);
> +		else if (nfd == 0 && vdev->ev_msix)
> +			vfio_disable_msix(vdev);
> +		else
> +			ret = -EINVAL;
> +		mutex_unlock(&vdev->igate);
> +		break;
> +
> +	case VFIO_BAR_LEN:
> +		if (copy_from_user(&bar, uarg, sizeof bar))
> +			return -EFAULT;
> +		if (bar < 0 || bar > PCI_ROM_RESOURCE)
> +			return -EINVAL;
> +		bar = pci_resource_len(pdev, bar);
> +		if (copy_to_user(uarg, &bar, sizeof bar))
> +			return -EFAULT;
> +		break;
> +
> +	case VFIO_DOMAIN_SET:
> +		if (copy_from_user(&fd, uarg, sizeof fd))
> +			return -EFAULT;
> +		ret = vfio_domain_set(vdev, fd);
> +		break;
> +
> +	case VFIO_DOMAIN_UNSET:
> +		vfio_domain_unset(vdev);
> +		ret = 0;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +static const struct file_operations vfio_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= vfio_open,
> +	.release	= vfio_release,
> +	.read		= vfio_read,
> +	.write		= vfio_write,
> +	.unlocked_ioctl	= vfio_unl_ioctl,
> +	.mmap		= vfio_mmap,
> +};
> +
> +static int vfio_get_devnum(struct vfio_dev *vdev)
> +{
> +	int retval = -ENOMEM;
> +	int id;
> +
> +	mutex_lock(&vfio_minor_lock);
> +	if (idr_pre_get(&vfio_idr, GFP_KERNEL) == 0)
> +		goto exit;
> +
> +	retval = idr_get_new(&vfio_idr, vdev, &id);
> +	if (retval < 0) {
> +		if (retval == -EAGAIN)
> +			retval = -ENOMEM;
> +		goto exit;
> +	}
> +	if (id > MINORMASK) {
> +		idr_remove(&vfio_idr, id);
> +		retval = -ENOMEM;
> +	}
> +	if (vfio_major < 0) {
> +		retval = register_chrdev(0, "vfio", &vfio_fops);
> +		if (retval < 0)
> +			goto exit;
> +		vfio_major = retval;
> +	}
> +
> +	retval = MKDEV(vfio_major, id);
> +exit:
> +	mutex_unlock(&vfio_minor_lock);
> +	return retval;
> +}
> +
> +static void vfio_free_minor(struct vfio_dev *vdev)
> +{
> +	mutex_lock(&vfio_minor_lock);
> +	idr_remove(&vfio_idr, MINOR(vdev->devnum));
> +	mutex_unlock(&vfio_minor_lock);
> +}
> +
> +/*
> + * Verify that the device supports Interrupt Disable bit in command register,
> + * per PCI 2.3, by flipping this bit and reading it back: this bit was readonly
> + * in PCI 2.2.  (from uio_pci_generic)
> + */
> +static int verify_pci_2_3(struct pci_dev *pdev)
> +{
> +	u16 orig, new;
> +	int err = 0;
> +	u8 pin;
> +
> +	pci_block_user_cfg_access(pdev);
> +
> +	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> +	if (pin == 0)		/* irqs not needed */
> +		goto out;
> +
> +	pci_read_config_word(pdev, PCI_COMMAND, &orig);
> +	pci_write_config_word(pdev, PCI_COMMAND,
> +			      orig ^ PCI_COMMAND_INTX_DISABLE);
> +	pci_read_config_word(pdev, PCI_COMMAND, &new);
> +	/* There's no way to protect against
> +	 * hardware bugs or detect them reliably, but as long as we know
> +	 * what the value should be, let's go ahead and check it. */
> +	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
> +		err = -EBUSY;
> +		dev_err(&pdev->dev, "Command changed from 0x%x to 0x%x: "
> +			"driver or HW bug?\n", orig, new);
> +		goto out;
> +	}
> +	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
> +		dev_warn(&pdev->dev, "Device does not support "
> +			 "disabling interrupts: unable to bind.\n");
> +		err = -ENODEV;
> +		goto out;
> +	}
> +	/* Now restore the original value. */
> +	pci_write_config_word(pdev, PCI_COMMAND, orig);
> +out:
> +	pci_unblock_user_cfg_access(pdev);
> +	return err;
> +}
> +
> +static int vfio_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct vfio_dev *vdev;
> +	int err;
> +
> +	if (!iommu_found())
> +		return -EINVAL;
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "%s: pci_enable_device failed: %d\n",
> +			__func__, err);
> +		return err;
> +	}
> +
> +	err = verify_pci_2_3(pdev);
> +	if (err)
> +		goto err_verify;
> +
> +	vdev = kzalloc(sizeof(struct vfio_dev), GFP_KERNEL);
> +	if (!vdev) {
> +		err = -ENOMEM;
> +		goto err_alloc;
> +	}
> +	vdev->pdev = pdev;
> +
> +	err = vfio_class_init();
> +	if (err)
> +		goto err_class;
> +
> +	mutex_init(&vdev->lgate);
> +	mutex_init(&vdev->dgate);
> +	mutex_init(&vdev->igate);
> +
> +	err = vfio_get_devnum(vdev);
> +	if (err < 0)
> +		goto err_get_devnum;
> +	vdev->devnum = err;
> +	err = 0;
> +
> +	sprintf(vdev->name, "vfio%d", MINOR(vdev->devnum));
> +	pci_set_drvdata(pdev, vdev);
> +	vdev->dev = device_create(vfio_class->class, &pdev->dev,
> +			  vdev->devnum, vdev, vdev->name);
> +	if (IS_ERR(vdev->dev)) {
> +		printk(KERN_ERR "VFIO: device register failed\n");
> +		err = PTR_ERR(vdev->dev);
> +		goto err_device_create;
> +	}
> +
> +	err = vfio_dev_add_attributes(vdev);
> +	if (err)
> +		goto err_vfio_dev_add_attributes;
> +
> +
> +	if (pdev->irq > 0) {
> +		err = request_irq(pdev->irq, vfio_interrupt,
> +				  IRQF_SHARED, "vfio", vdev);
> +		if (err)
> +			goto err_request_irq;
> +	}
> +	vdev->vinfo.bardirty = 1;
> +
> +	return 0;
> +
> +err_request_irq:
> +#ifdef notdef
> +	vfio_dev_del_attributes(vdev);
> +#endif
> +err_vfio_dev_add_attributes:
> +	device_destroy(vfio_class->class, vdev->devnum);
> +err_device_create:
> +	vfio_free_minor(vdev);
> +err_get_devnum:
> +err_class:
> +	kfree(vdev);
> +err_alloc:
> +err_verify:
> +	pci_disable_device(pdev);
> +	return err;
> +}
> +
> +static void vfio_remove(struct pci_dev *pdev)
> +{

So what happens if someone has a device file open and device
is being hot-unplugged? At a minimum, we want userspace to
have a way to get and handle these notifications.
But also remember we can not trust userspace to be well-behaved.


> +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> +
> +	vfio_free_minor(vdev);
> +
> +	if (pdev->irq > 0)
> +		free_irq(pdev->irq, vdev);
> +
> +#ifdef notdef
> +	vfio_dev_del_attributes(vdev);
> +#endif
> +
> +	pci_set_drvdata(pdev, NULL);
> +	device_destroy(vfio_class->class, vdev->devnum);
> +	kfree(vdev);
> +	vfio_class_destroy();
> +	pci_disable_device(pdev);
> +}
> +
> +static struct pci_driver driver = {
> +	.name = "vfio",
> +	.id_table = NULL, /* only dynamic id's */
> +	.probe = vfio_probe,
> +	.remove = vfio_remove,

Also - I think we need to handle e.g. suspend in some way.
Again, this likely involves notifying userspace so it can
save state to memory.

> +};
> +
> +static int __init init(void)
> +{
> +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> +	return pci_register_driver(&driver);
> +}
> +
> +static void __exit cleanup(void)
> +{
> +	if (vfio_major >= 0)
> +		unregister_chrdev(vfio_major, "vfio");
> +	pci_unregister_driver(&driver);
> +}
> +
> +module_init(init);
> +module_exit(cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff -uprN linux-2.6.34/drivers/vfio/vfio_pci_config.c vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c
> --- linux-2.6.34/drivers/vfio/vfio_pci_config.c	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c	2010-05-28 14:26:47.000000000 -0700
> @@ -0,0 +1,554 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/pci.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +
> +#define PCI_CAP_ID_BASIC	0
> +#ifndef PCI_CAP_ID_MAX
> +#define	PCI_CAP_ID_MAX		PCI_CAP_ID_AF
> +#endif
> +
> +/*
> + * Lengths of PCI Config Capabilities
> + * 0 means unknown (but at least 4)
> + * FF means special/variable
> + */
> +static u8 pci_capability_length[] = {
> +	[PCI_CAP_ID_BASIC]	= 64,		/* pci config header */
> +	[PCI_CAP_ID_PM]		= PCI_PM_SIZEOF,
> +	[PCI_CAP_ID_AGP]	= PCI_AGP_SIZEOF,
> +	[PCI_CAP_ID_VPD]	= 8,
> +	[PCI_CAP_ID_SLOTID]	= 4,
> +	[PCI_CAP_ID_MSI]	= 0xFF,		/* 10, 14, or 24 */
> +	[PCI_CAP_ID_CHSWP]	= 4,
> +	[PCI_CAP_ID_PCIX]	= 0xFF,		/* 8 or 24 */
> +	[PCI_CAP_ID_HT]		= 28,
> +	[PCI_CAP_ID_VNDR]	= 0xFF,
> +	[PCI_CAP_ID_DBG]	= 0,
> +	[PCI_CAP_ID_CCRC]	= 0,
> +	[PCI_CAP_ID_SHPC]	= 0,
> +	[PCI_CAP_ID_SSVID]	= 0,		/* bridge only - not supp */
> +	[PCI_CAP_ID_AGP3]	= 0,
> +	[PCI_CAP_ID_EXP]	= 36,
> +	[PCI_CAP_ID_MSIX]	= 12,
> +	[PCI_CAP_ID_AF]		= 6,
> +};
> +
> +/*
> + * Read/Write Permission Bits - one bit for each bit in capability
> + * Any field can be read if it exists,
> + * but what is read depends on whether the field
> + * is 'virtualized', or just pass thru to the hardware.
> + * Any virtualized field is also virtualized for writes.
> + * Writes are only permitted if they have a 1 bit here.
> + */
> +struct perm_bits {
> +	u32	rvirt;		/* read bits which must be virtualized */
> +	u32	write;		/* writeable bits - virt if read virt */
> +};
> +
> +static struct perm_bits pci_cap_basic_perm[] = {
> +	{ 0xFFFFFFFF,	0, },		/* 0x00 vendor & device id - RO */
> +	{ 0,		0xFFFFFFFC, },	/* 0x04 cmd & status except mem/io */
> +	{ 0,		0xFF00FFFF, },	/* 0x08 bist, htype, lat, cache */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x0c bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x10 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x14 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x18 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x1c bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x20 bar */
> +	{ 0,		0, },		/* 0x24 cardbus - not yet */
> +	{ 0,		0, },		/* 0x28 subsys vendor & dev */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x2c rom bar */
> +	{ 0,		0, },		/* 0x30 capability ptr & resv */
> +	{ 0,		0, },		/* 0x34 resv */
> +	{ 0,		0, },		/* 0x38 resv */
> +	{ 0x000000FF,	0x000000FF, },	/* 0x3c max_lat ... irq */
> +};
> +
> +static struct perm_bits pci_cap_pm_perm[] = {
> +	{ 0,		0, },		/* 0x00 PM capabilities */
> +	{ 0,		0xFFFFFFFF, },	/* 0x04 PM control/status */
> +};
> +
> +static struct perm_bits pci_cap_vpd_perm[] = {
> +	{ 0,		0xFFFF0000, },	/* 0x00 address */
> +	{ 0,		0xFFFFFFFF, },	/* 0x04 data */
> +};
> +
> +static struct perm_bits pci_cap_slotid_perm[] = {
> +	{ 0,		0, },		/* 0x00 all read only */
> +};
> +
> +static struct perm_bits pci_cap_msi_perm[] = {
> +	{ 0,		0, },		/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message addr/data */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI mask bits */
> +	{ 0,		0xFFFFFFFF, },	/* 0x14 MSI pending bits */
> +};
> +
> +static struct perm_bits pci_cap_pcix_perm[] = {
> +	{ 0,		0xFFFF0000, },	/* 0x00 PCI_X_CMD */
> +	{ 0,		0, },		/* 0x04 PCI_X_STATUS */
> +	{ 0,		0xFFFFFFFF, },	/* 0x08 ECC ctlr & status */
> +	{ 0,		0, },		/* 0x0c ECC first addr */
> +	{ 0,		0, },		/* 0x10 ECC second addr */
> +	{ 0,		0, },		/* 0x14 ECC attr */
> +};
> +
> +/* pci express capabilities */
> +static struct perm_bits pci_cap_exp_perm[] = {
> +	{ 0,		0, },		/* 0x00 PCIe capabilities */
> +	{ 0,		0, },		/* 0x04 PCIe device capabilities */
> +	{ 0,		0xFFFFFFFF, },	/* 0x08 PCIe device control & status */
> +	{ 0,		0, },		/* 0x0c PCIe link capabilities */
> +	{ 0,		0x000000FF, },	/* 0x10 PCIe link ctl/stat - SAFE? */
> +	{ 0,		0, },		/* 0x14 PCIe slot capabilities */
> +	{ 0,		0x00FFFFFF, },	/* 0x18 PCIe link ctl/stat - SAFE? */
> +	{ 0,		0, },		/* 0x1c PCIe root port stuff */
> +	{ 0,		0, },		/* 0x20 PCIe root port stuff */
> +};
> +
> +static struct perm_bits pci_cap_msix_perm[] = {
> +	{ 0,		0, },		/* 0x00 MSI-X Enable */
> +	{ 0,		0, },		/* 0x04 table offset & bir */
> +	{ 0,		0, },		/* 0x08 pba offset & bir */
> +};
> +
> +static struct perm_bits pci_cap_af_perm[] = {
> +	{ 0,		0, },		/* 0x00 af capability */
> +	{ 0,		0x0001,	 },	/* 0x04 af flr bit */
> +};
> +
> +static struct perm_bits *pci_cap_perms[] = {
> +	[PCI_CAP_ID_BASIC]	= pci_cap_basic_perm,
> +	[PCI_CAP_ID_PM]		= pci_cap_pm_perm,
> +	[PCI_CAP_ID_VPD]	= pci_cap_vpd_perm,
> +	[PCI_CAP_ID_SLOTID]	= pci_cap_slotid_perm,
> +	[PCI_CAP_ID_MSI]	= pci_cap_msi_perm,
> +	[PCI_CAP_ID_PCIX]	= pci_cap_pcix_perm,
> +	[PCI_CAP_ID_EXP]	= pci_cap_exp_perm,
> +	[PCI_CAP_ID_MSIX]	= pci_cap_msix_perm,
> +	[PCI_CAP_ID_AF]		= pci_cap_af_perm,
> +};
> +
> +/*
> + * We build a map of the config space that tells us where
> + * and what capabilities exist, so that we can map reads and
> + * writes back to capabilities, and thus figure out what to
> + * allow, deny, or virtualize
> + */

So the above looks like it is very unlikely to be exhaustive and
correct. Maybe there aren't bugs in this table to be found just by
looking hard at the spec, but likely will surface when someone tries
to actually run driver with e.g. a working pm on top.
Let's ask another question:

since we have the iommu protecting us, can't all or most of this be
done in userspace? What can userspace do that will harm the host?
I think each place where we block access to a register, there should
be a very specific documentation for why we do this.


> +int vfio_build_config_map(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u8 *map;
> +	int i, len;
> +	u8 pos, cap, tmp;
> +	u16 flags;
> +	int ret;
> +	int loops = 100;

100?


.....

> +int vfio_dma_map_common(struct vfio_listener *listener,
> +		unsigned int cmd, struct vfio_dma_map *dmp)
> +{
> +	int locked, lock_limit;
> +	struct page **pages;
> +	int npage;
> +	struct dma_map_page *mlp;
> +	int rdwr = (dmp->flags & VFIO_FLAG_WRITE) ? 1 : 0;
> +	int ret = 0;
> +
> +	if (dmp->vaddr & (PAGE_SIZE-1))
> +		return -EINVAL;
> +	if (dmp->size & (PAGE_SIZE-1))
> +		return -EINVAL;
> +	if (dmp->size <= 0)
> +		return -EINVAL;
> +	npage = dmp->size >> PAGE_SHIFT;
> +	if (npage <= 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&listener->vdev->dgate);
> +
> +	/* account for locked pages */
> +	locked = npage + current->mm->locked_vm;
> +	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur
> +			>> PAGE_SHIFT;
> +	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
> +		printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
> +			__func__);
> +		ret = -ENOMEM;
> +		goto out_lock;
> +	}
> +	/* only 1 address space per fd */
> +	if (current->mm != listener->mm) {

Why is that?

> +		if (listener->mm != NULL) {
> +			ret = -EINVAL;
> +			goto out_lock;
> +		}
> +		listener->mm = current->mm;
> +#ifdef CONFIG_MMU_NOTIFIER
> +		listener->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
> +		ret = mmu_notifier_register(&listener->mmu_notifier,
> +						listener->mm);
> +		if (ret)
> +			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
> +				__func__, ret);
> +		ret = 0;
> +#endif
> +	}
> +
> +	pages = kzalloc(npage * sizeof(struct page *), GFP_KERNEL);

If you map a 4G region, this will try to allocate 8Mbytes?

> +	if (pages == NULL) {
> +		ret = ENOMEM;
> +		goto out_lock;
> +	}
> +	ret = get_user_pages_fast(dmp->vaddr, npage, rdwr, pages);
> +	if (ret != npage) {
> +		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
> +			__func__, ret, npage);
> +		kfree(pages);
> +		ret = -EFAULT;
> +		goto out_lock;
> +	}
> +	ret = 0;
> +
> +	mlp = vfio_dma_map_iova(listener, dmp->dmaaddr,
> +				pages, npage, rdwr);
> +	if (IS_ERR(mlp)) {
> +		ret = PTR_ERR(mlp);
> +		kfree(pages);
> +		goto out_lock;
> +	}
> +	mlp->vaddr = dmp->vaddr;
> +	mlp->rdwr = rdwr;
> +	dmp->dmaaddr = mlp->daddr;
> +	list_add(&mlp->list, &listener->dm_list);
> +
> +	current->mm->locked_vm += npage;
> +	listener->vdev->locked_pages += npage;
> +out_lock:
> +	mutex_unlock(&listener->vdev->dgate);
> +	return ret;
> +}
> +
