Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0GSE51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 00:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0GSE50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 00:57:26 -0400
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
In-Reply-To: <20100718093934.GA7342@redhat.com>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
	 <20100718093934.GA7342@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 22:56:47 -0600
Message-ID: <1279515407.20397.382.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom, Michael,

Comments for both of you below.  Tom, what does this build against?  Are
we still on 2.6.34?

On Sun, 2010-07-18 at 12:39 +0300, Michael S. Tsirkin wrote:
> Hi Tom,
> > ---
> > In this version:
> > 
> > There are lots of bug fixes and cleanups in this version, but the main
> > change is to check to make sure that the IOMMU has interrupt remapping
> > enabled, which is necessary to prevent user level code from triggering
> > spurious interrupts for other devices.  Since most platforms today
> > do not have the necessary hardware and/or software for this, a module
> > option can override this check, thus making vfio useful (but not safe)
> > on many more platforms.
> > 
> > In the next version I plan to add kernel to user messaging using the
> > generic netlink mechanism to allow the user driver to react to hot add
> > and remove, and power management requests.
> > 
> > Blurb from version 2:
> > 
> > This version now requires an IOMMU domain to be set before any access to
> > device registers is granted (except that config space may be read).  In
> > addition, the VFIO_DMA_MAP_ANYWHERE is dropped - it used the dma_map_sg API
> > which does not have sufficient controls around IOMMU usage.  The IOMMU domain
> > is obtained from the 'uiommu' driver which is included in this patch.
> > 
> > Various locking, security, and documentation issues have also been fixed.
> > 
> 
> I think this is making nice progress, especially good to see
> some effort to address the interrupt remapping issue.
> I just realized we also have an issue with determining
> the MSI capability and allocating entries. Some ideas
> on addressing this posted below.
> I also think it might make sense to involve the pci crowd here.
> 
> It might be nice to see a bit of documentation for the interface
> presented to userspace. It is not always obvious.
> For example, passing CONFIG as offset to
> write or read will not always trigger access to config space.
> 
> More comments below.
> 
> 
> On Fri, Jul 16, 2010 at 02:58:48PM -0700, Tom Lyon wrote:
> > +static int vfio_msix_check(struct vfio_dev *vdev, u64 start, u32 len)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	u16 pos;
> > +	u32 table_offset;
> > +	u16 table_size;
> > +	u8 bir;
> > +	u32 lo, hi, startp, endp;
> > +
> > +	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> > +	if (!pos)
> > +		return 0;
> > +
> > +	pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &table_size);
> > +	table_size = (table_size & PCI_MSIX_FLAGS_QSIZE) + 1;
> > +	pci_read_config_dword(pdev, pos + 4, &table_offset);
> > +	bir = table_offset & PCI_MSIX_FLAGS_BIRMASK;
> > +	lo = table_offset >> PAGE_SHIFT;
> > +	hi = (table_offset + PCI_MSIX_ENTRY_SIZE * table_size + PAGE_SIZE - 1)
> > +		>> PAGE_SHIFT;
> > +	startp = start >> PAGE_SHIFT;
> > +	endp = (start + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +	if (bir == vfio_offset_to_pci_space(start) &&
> > +	    overlap(lo, hi, startp, endp)) {
> > +		printk(KERN_WARNING "%s: cannot write msi-x vectors\n",
> > +			__func__);
> > +		return -EINVAL;
> > +	}
> > +	return 0;
> > +}
> 
> 
> You can't just check MSI capability to figure out whether MSI
> will work: this also depends on the host system in many ways.
> The only way to really know is to request vectors in host. So
> what we really need is an API that will reserve MSI vectors,
> but not assign them in the device until guest asks us to
> do it.
> 
> > +
> > +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) {
> > +		if (allow_unsafe_intrs) {
> > +			/* don't allow writes to msi-x vectors */
> > +			ret = vfio_msix_check(vdev, *ppos, count);
> 
> I thought we have an agreement here: it's useless to protect
> msix vector space and at the same time allow DMA from device,
> since device can do DMA write to trigger MSI.
> So why do you keep this code around?
> 
> 
> > +	case VFIO_EVENTFD_MSI:
> > +		if (copy_from_user(&fd, uarg, sizeof fd))
> > +			return -EFAULT;
> > +		mutex_lock(&vdev->igate);
> > +		if (fd >= 0 && vdev->ev_msi == NULL && vdev->ev_msix == NULL)
> > +			ret = vfio_enable_msi(vdev, fd);
> > +		else if (fd < 0 && vdev->ev_msi)
> > +			vfio_disable_msi(vdev);
> > +		else
> > +			ret = -EINVAL;
> > +		mutex_unlock(&vdev->igate);
> > +		break;
> 
> I think that for virt we'll need multivector support for MSI.
> 
> 
> > diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
> > index e69de29..8bd5c00 100644
> > --- a/drivers/vfio/vfio_pci_config.c
> > +++ b/drivers/vfio/vfio_pci_config.c
> > @@ -0,0 +1,605 @@
> > +/*
> > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > + * Author: Tom Lyon, pugs@cisco.com
> 
> Any hints on what this file does?
> 
> > + *
> > + * This program is free software; you may redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + *
> > + * Portions derived from drivers/uio/uio.c:
> > + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> > + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> > + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> > + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> > + *
> > + * Portions derived from drivers/uio/uio_pci_generic.c:
> > + * Copyright (C) 2009 Red Hat, Inc.
> > + * Author: Michael S. Tsirkin <mst@redhat.com>
> > + */
> 
> Tom so this file is some 600 lines of pretty tricky code,
> that I still don't completely understand the purpose of.
> For example, it prevents usespace from writing into readonly hardware
> registers like class/revision id. But writing them is harmless.
> As above, all code that does tricks with msi is also kind of useless.
> Maybe we need protection against writing BAR registers, but
> what about all the rest of it?
> Leavng it pasted below so you can explain it to me.
> 
> Also, I am still unsure what purpose does the trick of "virtualization" serve.
> For example, you return a fake device id for an sr/iov device.
> Sounds a bit like forcing policy.
> Wouldn't it be cleaner to simply add an ioctl to get the
> fake id, thus making both the real value and the fake value
> available.

Is there a better default for this example?  Linux has already figured
out what the vendor and device IDs are for the VF, why burden every
userspace caller to go figure out what's in pcisysfs and do the same
trick?  If userspace wants to expose something different, they're free
to trap these config offsets and return whatever they please.  If
userspace wants direct access, they can use pcisysfs.

> On the other hand, the virtualization trick will prevent userspace
> from doing things like restoring registers after a device specific reset.
> See drivers/infiniband/hw/mthca/mthca_reset.c as one example.
> For BARs, we can solve this by checking for BAR change and
> restoring it.
> Again, doing this might be better done through a special ioctl?

A reset ioctl may make sense, but what would we lose if we simply
trapped the flr write in vfio and issued a device reset?

> > +
> > +#include <linux/fs.h>
> > +#include <linux/pci.h>
> > +#include <linux/mmu_notifier.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/vfio.h>
> > +
> > +#define PCI_CAP_ID_BASIC	0
> > +#ifndef PCI_CAP_ID_MAX
> > +#define	PCI_CAP_ID_MAX		PCI_CAP_ID_AF
> > +#endif
> > +
> > +/*
> > + * Lengths of PCI Config Capabilities
> > + * 0 means unknown (but at least 4)
> > + * FF means special/variable
> > + */
> > +static u8 pci_capability_length[] = {
> > +	[PCI_CAP_ID_BASIC]	= 64,		/* pci config header */
> > +	[PCI_CAP_ID_PM]		= PCI_PM_SIZEOF,
> > +	[PCI_CAP_ID_AGP]	= PCI_AGP_SIZEOF,
> > +	[PCI_CAP_ID_VPD]	= 8,
> > +	[PCI_CAP_ID_SLOTID]	= 4,
> > +	[PCI_CAP_ID_MSI]	= 0xFF,		/* 10, 14, 20, or 24 */
> > +	[PCI_CAP_ID_CHSWP]	= 4,
> > +	[PCI_CAP_ID_PCIX]	= 0xFF,		/* 8 or 24 */
> > +	[PCI_CAP_ID_HT]		= 28,
> > +	[PCI_CAP_ID_VNDR]	= 0xFF,
> > +	[PCI_CAP_ID_DBG]	= 0,
> > +	[PCI_CAP_ID_CCRC]	= 0,
> > +	[PCI_CAP_ID_SHPC]	= 0,
> > +	[PCI_CAP_ID_SSVID]	= 0,		/* bridge only - not supp */
> > +	[PCI_CAP_ID_AGP3]	= 0,
> > +	[PCI_CAP_ID_EXP]	= 36,
> > +	[PCI_CAP_ID_MSIX]	= 12,
> > +	[PCI_CAP_ID_AF]		= 6,
> > +};
> 
> Maybe all these constants should go into pci_regs.h?
> Please consider Cc Jesse/linux-pci.
> 
> > +
> > +/*
> > + * Read/Write Permission Bits - one bit for each bit in capability
> > + * Any field can be read if it exists,
> > + * but what is read depends on whether the field
> > + * is 'virtualized', or just pass thru to the hardware.
> > + * Any virtualized field is also virtualized for writes.
> > + * Writes are only permitted if they have a 1 bit here.
> > + */
> > +struct perm_bits {
> > +	u32	rvirt;		/* read bits which must be virtualized */
> > +	u32	write;		/* writeable bits - virt if read virt */
> > +};
> > +
> > +static struct perm_bits pci_cap_basic_perm[] = {
> > +	{ 0xFFFFFFFF,	0, },		/* 0x00 vendor & device id - RO */
> > +	{ 0,		0xFFFFFFFC, },	/* 0x04 cmd & status except mem/io */
> 
> don't want to virtualize mem/io?

This seems like a hole to me too.  I haven't looked in the spec for this
issue, but an 82576 VF doesn't have working mem/io bits, so I end up
falling back to qemu for the command register.

> > +	{ 0,		0, },		/* 0x08 class code & revision id */
> > +	{ 0,		0xFF00FFFF, },	/* 0x0c bist, htype, lat, cache */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x10 bar */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x14 bar */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x18 bar */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x1c bar */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x20 bar */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x24 bar */
> > +	{ 0,		0, },		/* 0x28 cardbus - not yet */
> > +	{ 0,		0, },		/* 0x2c subsys vendor & dev */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x30 rom bar */
> > +	{ 0,		0, },		/* 0x34 capability ptr & resv */
> > +	{ 0,		0, },		/* 0x38 resv */
> > +	{ 0x000000FF,	0x000000FF, },	/* 0x3c max_lat ... irq */
> > +};
> 
> Use .[] initializers above instead of sticking register name in comment?
> 
> > +
> > +static struct perm_bits pci_cap_pm_perm[] = {
> > +	{ 0,		0, },		/* 0x00 PM capabilities */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x04 PM control/status */
> > +};
> > +
> > +static struct perm_bits pci_cap_vpd_perm[] = {
> > +	{ 0,		0xFFFF0000, },	/* 0x00 address */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x04 data */
> > +};
> > +
> > +static struct perm_bits pci_cap_slotid_perm[] = {
> > +	{ 0,		0, },		/* 0x00 all read only */
> > +};
> > +
> > +/* 4 different possible layouts of MSI capability */
> > +static struct perm_bits pci_cap_msi_10_perm[] = {
> > +	{ 0,		0, },		/* 0x00 MSI message control */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> > +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x08 MSI message data */
> > +};
> > +static struct perm_bits pci_cap_msi_14_perm[] = {
> > +	{ 0,		0, },		/* 0x00 MSI message control */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message upper addr */
> > +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> > +};
> > +static struct perm_bits pci_cap_msi_20_perm[] = {
> > +	{ 0,		0, },		/* 0x00 MSI message control */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> > +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x08 MSI message data */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x0c MSI mask bits */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI pending bits */
> > +};
> > +static struct perm_bits pci_cap_msi_24_perm[] = {
> > +	{ 0,		0, },		/* 0x00 MSI message control */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> > +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message upper addr */
> > +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI mask bits */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x14 MSI pending bits */
> > +};
> > +
> > +static struct perm_bits pci_cap_pcix_perm[] = {
> > +	{ 0,		0xFFFF0000, },	/* 0x00 PCI_X_CMD */
> > +	{ 0,		0, },		/* 0x04 PCI_X_STATUS */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x08 ECC ctlr & status */
> > +	{ 0,		0, },		/* 0x0c ECC first addr */
> > +	{ 0,		0, },		/* 0x10 ECC second addr */
> > +	{ 0,		0, },		/* 0x14 ECC attr */
> > +};
> > +
> > +/* pci express capabilities */
> > +static struct perm_bits pci_cap_exp_perm[] = {
> > +	{ 0,		0, },		/* 0x00 PCIe capabilities */
> > +	{ 0,		0, },		/* 0x04 PCIe device capabilities */
> > +	{ 0,		0xFFFFFFFF, },	/* 0x08 PCIe device control & status */
> > +	{ 0,		0, },		/* 0x0c PCIe link capabilities */
> > +	{ 0,		0x000000FF, },	/* 0x10 PCIe link ctl/stat - SAFE? */
> > +	{ 0,		0, },		/* 0x14 PCIe slot capabilities */
> > +	{ 0,		0x00FFFFFF, },	/* 0x18 PCIe link ctl/stat - SAFE? */
> > +	{ 0,		0, },		/* 0x1c PCIe root port stuff */
> > +	{ 0,		0, },		/* 0x20 PCIe root port stuff */
> > +};
> > +
> > +static struct perm_bits pci_cap_msix_perm[] = {
> > +	{ 0,		0, },		/* 0x00 MSI-X Enable */
> > +	{ 0,		0, },		/* 0x04 table offset & bir */
> > +	{ 0,		0, },		/* 0x08 pba offset & bir */
> > +};
> > +
> > +static struct perm_bits pci_cap_af_perm[] = {
> > +	{ 0,		0, },		/* 0x00 af capability */
> > +	{ 0,		0x0001,	 },	/* 0x04 af flr bit */
> 
> So you let application reset the function?
> If this happens, application will need to restore config space,
> so virtualizing will create problems.
> 
> > +};
> > +
> > +static struct perm_bits *pci_cap_perms[] = {
> > +	[PCI_CAP_ID_BASIC]	= pci_cap_basic_perm,
> > +	[PCI_CAP_ID_PM]		= pci_cap_pm_perm,
> > +	[PCI_CAP_ID_VPD]	= pci_cap_vpd_perm,
> > +	[PCI_CAP_ID_SLOTID]	= pci_cap_slotid_perm,
> > +	[PCI_CAP_ID_MSI]	= NULL,			/* special */
> > +	[PCI_CAP_ID_PCIX]	= pci_cap_pcix_perm,
> > +	[PCI_CAP_ID_EXP]	= pci_cap_exp_perm,
> > +	[PCI_CAP_ID_MSIX]	= pci_cap_msix_perm,
> > +	[PCI_CAP_ID_AF]		= pci_cap_af_perm,
> > +};
> > +
> > +static int pci_msi_cap_len(struct pci_dev *pdev, u8 pos)
> > +{
> > +	int len;
> > +	int ret;
> > +	u16 flags;
> > +
> > +	ret = pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &flags);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (flags & PCI_MSI_FLAGS_64BIT)
> > +		len = 14;
> > +	else
> > +		len = 10;
> > +	if (flags & PCI_MSI_FLAGS_MASKBIT)
> > +		len += 10;
> > +	return len;
> > +}
> > +
> > +/*
> > + * We build a map of the config space that tells us where
> > + * and what capabilities exist, so that we can map reads and
> > + * writes back to capabilities, and thus figure out what to
> > + * allow, deny, or virtualize
> > + */
> > +int vfio_build_config_map(struct vfio_dev *vdev)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	u8 *map;
> > +	int i, len;
> > +	u8 pos, cap, tmp;
> > +	u16 flags;
> > +	int ret;
> > +#ifndef PCI_FIND_CAP_TTL
> > +#define PCI_FIND_CAP_TTL	48
> > +#endif
> > +	int loops = PCI_FIND_CAP_TTL;
> > +
> > +	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
> > +	if (map == NULL)
> > +		return -ENOMEM;
> > +	for (i = 0; i < pdev->cfg_size; i++)
> > +		map[i] = 0xFF;
> > +	vdev->pci_config_map = map;
> > +
> > +	/* default config space */
> > +	for (i = 0; i < pci_capability_length[0]; i++)
> > +		map[i] = 0;
> > +
> > +	/* any capabilities? */
> > +	ret = pci_read_config_word(pdev, PCI_STATUS, &flags);
> > +	if (ret < 0)
> > +		return ret;
> > +	if ((flags & PCI_STATUS_CAP_LIST) == 0)
> > +		return 0;
> > +
> > +	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
> > +	if (ret < 0)
> > +		return ret;
> > +	while (pos && --loops > 0) {
> > +		ret = pci_read_config_byte(pdev, pos, &cap);
> > +		if (ret < 0)
> > +			return ret;
> > +		if (cap == 0) {
> > +			printk(KERN_WARNING "%s: cap 0\n", __func__);
> > +			break;
> > +		}
> > +		if (cap > PCI_CAP_ID_MAX) {
> > +			printk(KERN_WARNING "%s: unknown pci capability id %x\n",
> > +					__func__, cap);
> > +			len = 0;
> 
> Why is this a problem? Devices will implement more capabilities.
> How is access to an unknown one worse that access outside
> any capability, or vendor specific, that you do allow?

I believe the code doesn't allow access outside of known config space or
capabilities.  It does seem like we could simply skip unknown caps
though, but that would require virtualizing the capability next pointer,
which isn't very amenable to how virtualized reads are currently done.
We'd need something more like how qemu virtualizes config space for
that.

> > +		} else
> > +			len = pci_capability_length[cap];
> > +		if (len == 0) {
> > +			printk(KERN_WARNING "%s: unknown length for pci cap %x\n",
> > +					__func__, cap);
> > +			len = 4;
> > +		}
> > +		if (len == 0xFF) {
> > +			switch (cap) {
> > +			case PCI_CAP_ID_MSI:
> > +				len = pci_msi_cap_len(pdev, pos);
> > +				if (len < 0)
> > +					return len;
> > +				break;
> > +			case PCI_CAP_ID_PCIX:
> > +				ret = pci_read_config_word(pdev, pos + 2,
> > +					&flags);
> > +				if (ret < 0)
> > +					return ret;
> > +				if (flags & 0x3000)
> > +					len = 24;
> > +				else
> > +					len = 8;
> > +				break;
> > +			case PCI_CAP_ID_VNDR:
> > +				/* length follows next field */
> > +				ret = pci_read_config_byte(pdev, pos + 2, &tmp);
> > +				if (ret < 0)
> > +					return ret;
> > +				len = tmp;
> > +				break;
> > +			default:
> > +				len = 0;
> > +				break;
> > +			}
> > +		}
> > +
> > +		for (i = 0; i < len; i++) {
> > +			if (map[pos+i] != 0xFF)
> > +				printk(KERN_WARNING
> > +					"%s: pci config conflict at %x, "
> > +					"caps %x %x\n",
> > +					__func__, i, map[pos+i], cap);
> > +			map[pos+i] = cap;
> > +		}
> > +		ret = pci_read_config_byte(pdev, pos + PCI_CAP_LIST_NEXT, &pos);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +	if (loops <= 0)
> > +		printk(KERN_ERR "%s: config space loop!\n", __func__);
> > +	return 0;
> > +}
> > +
> > +static void vfio_virt_init(struct vfio_dev *vdev)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	int bar;
> > +	u32 *lp;
> > +	u32 val;
> > +	u8 pos;
> > +	int i, len;
> > +
> > +	for (bar = 0; bar <= 5; bar++) {
> > +		lp = (u32 *)&vdev->vinfo.bar[bar * 4];
> > +		pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0 + 4*bar, &val);
> > +		*lp++ = val;
> > +	}
> > +	lp = (u32 *)vdev->vinfo.rombar;
> > +	pci_read_config_dword(pdev, PCI_ROM_ADDRESS, &val);
> > +	*lp = val;
> > +
> > +	vdev->vinfo.intr = pdev->irq;
> > +
> > +	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
> > +	if (pos > 0) {
> > +		len = pci_msi_cap_len(pdev, pos);
> > +		if (len < 0)
> > +			return;
> > +		for (i = 0; i < len; i++)
> > +			(void) pci_read_config_byte(pdev, pos + i,
> > +						&vdev->vinfo.msi[i]);
> > +	}
> > +}
> > +
> > +static void vfio_bar_fixup(struct vfio_dev *vdev)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	int bar;
> > +	u32 *lp;
> > +	u64 mask;
> > +
> > +	for (bar = 0; bar <= 5; bar++) {
> > +		if (pci_resource_start(pdev, bar))
> > +			mask = ~(pci_resource_len(pdev, bar) - 1);
> > +		else
> > +			mask = 0;
> > +		lp = (u32 *)&vdev->vinfo.bar[bar * 4];
> > +		*lp &= (u32)mask;
> > +
> > +		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
> > +			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
> > +		else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
> > +			*lp |= PCI_BASE_ADDRESS_SPACE_MEMORY;
> > +			if (pci_resource_flags(pdev, bar) & IORESOURCE_PREFETCH)
> > +				*lp |= PCI_BASE_ADDRESS_MEM_PREFETCH;
> > +			if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM_64) {
> > +				*lp |= PCI_BASE_ADDRESS_MEM_TYPE_64;
> > +				lp++;
> > +				*lp &= (u32)(mask >> 32);
> > +				bar++;
> > +			}
> > +		}
> > +	}
> > +
> > +	lp = (u32 *)vdev->vinfo.rombar;
> > +	mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
> > +	*lp &= (u32)mask | PCI_ROM_ADDRESS_ENABLE;
> > +
> > +	vdev->vinfo.bardirty = 0;
> > +}
> > +
> > +static int vfio_config_rwbyte(int write,
> > +				struct vfio_dev *vdev,
> > +				int pos,
> > +				char __user *buf)
> 
> Consider exporting from pci-sysfs.c instead of duplicating code.

Seems like we'd need to reach some agreement that this should look a lot
more like pci-sysfs config access first, no?

> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	u8 *map = vdev->pci_config_map;
> > +	u8 cap, val, newval;
> > +	u16 start, off;
> > +	int p;
> > +	struct perm_bits *perm;
> > +	u8 wr, virt;
> > +	int ret;
> > +	int len;
> > +
> > +	cap = map[pos];
> > +	if (cap == 0xFF) {	/* unknown region */
> > +		if (write)
> > +			return 0;	/* silent no-op */
> > +		val = 0;
> > +		if (pos <= pci_capability_length[0])	/* ok to read */
> > +			(void) pci_read_config_byte(pdev, pos, &val);

Tom, there's a kernel memory leak here.  val always needs to be
initialized if we're going to stuff it back in the user buffer.

> > +		if (copy_to_user(buf, &val, 1))
> > +			return -EFAULT;
> > +		return 0;
> > +	}
> > +
> > +	/* scan back to start of cap region */
> > +	for (p = pos; p >= 0; p--) {
> > +		if (map[p] != cap)
> > +			break;
> > +		start = p;
> > +	}
> > +	off = pos - start;	/* offset within capability */
> > +
> > +	perm = pci_cap_perms[cap];
> > +	if (cap == PCI_CAP_ID_MSI) {
> > +		len = pci_msi_cap_len(pdev, start);
> > +		switch (len) {
> > +		case 10:
> > +			perm = pci_cap_msi_10_perm;
> > +			break;
> > +		case 14:
> > +			perm = pci_cap_msi_14_perm;
> > +			break;
> > +		case 20:
> > +			perm = pci_cap_msi_20_perm;
> > +			break;
> > +		case 24:
> > +			perm = pci_cap_msi_24_perm;
> > +			break;
> > +		default:
> > +			perm = NULL;
> > +			break;
> > +		}
> > +	}
> > +	if (perm == NULL) {
> > +		wr = 0;
> > +		virt = 0;
> > +	} else {
> > +		perm += (off >> 2);
> > +		wr = perm->write >> ((off & 3) * 8);
> > +		virt = perm->rvirt >> ((off & 3) * 8);
> > +	}
> > +	if (write && !wr)		/* no writeable bits */
> > +		return 0;
> > +	if (!virt) {
> > +		if (write) {
> > +			if (copy_from_user(&val, buf, 1))
> > +				return -EFAULT;
> > +			val &= wr;
> > +			if (wr != 0xFF) {
> > +				u8 existing;
> > +
> > +				ret = pci_read_config_byte(pdev, pos,
> > +								&existing);
> > +				if (ret < 0)
> > +					return ret;
> > +				val |= (existing & ~wr);
> > +			}
> > +			pci_write_config_byte(pdev, pos, val);
> 
> I think this should be pci_user_write_config_dword and same for read.
> 
> 
> > +		} else {
> > +			ret = pci_read_config_byte(pdev, pos, &val);
> > +			if (ret < 0)
> > +				return ret;
> > +			if (copy_to_user(buf, &val, 1))
> > +				return -EFAULT;
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	if (write) {
> > +		if (copy_from_user(&newval, buf, 1))
> > +			return -EFAULT;
> > +	}
> > +	/*
> > +	 * We get here if there are some virt bits
> > +	 * handle remaining real bits, if any
> > +	 */
> > +	if (~virt) {
> > +		u8 rbits = (~virt) & wr;
> > +
> > +		ret = pci_read_config_byte(pdev, pos, &val);
> > +		if (ret < 0)
> > +			return ret;
> > +		if (write && rbits) {
> > +			val &= ~rbits;
> > +			newval &= rbits;
> > +			val |= newval;
> > +			pci_write_config_byte(pdev, pos, val);
> > +		}
> > +	}
> > +	/*
> > +	 * Now handle entirely virtual fields
> > +	 */
> > +	switch (cap) {
> > +	case PCI_CAP_ID_BASIC:		/* virtualize BARs */
> > +		switch (off) {
> > +		/*
> > +		 * vendor and device are virt because they don't
> > +		 * show up otherwise for sr-iov vfs
> > +		 */
> > +		case PCI_VENDOR_ID:
> > +			val = pdev->vendor;
> > +			break;
> > +		case PCI_VENDOR_ID + 1:
> > +			val = pdev->vendor >> 8;
> > +			break;
> > +		case PCI_DEVICE_ID:
> > +			val = pdev->device;
> > +			break;
> > +		case PCI_DEVICE_ID + 1:
> > +			val = pdev->device >> 8;
> > +			break;
> > +		case PCI_INTERRUPT_LINE:
> > +			if (write)
> > +				vdev->vinfo.intr = newval;
> > +			else
> > +				val = vdev->vinfo.intr;
> > +			break;
> > +		case PCI_ROM_ADDRESS:
> > +		case PCI_ROM_ADDRESS+1:
> > +		case PCI_ROM_ADDRESS+2:
> > +		case PCI_ROM_ADDRESS+3:
> > +			if (write) {
> > +				vdev->vinfo.rombar[off & 3] = newval;
> > +				vdev->vinfo.bardirty = 1;
> > +			} else {
> > +				if (vdev->vinfo.bardirty)
> > +					vfio_bar_fixup(vdev);
> > +				val = vdev->vinfo.rombar[off & 3];
> > +			}
> > +			break;
> > +		default:
> > +			if (off >= PCI_BASE_ADDRESS_0 &&
> > +			    off <= PCI_BASE_ADDRESS_5 + 3) {
> > +				int boff = off - PCI_BASE_ADDRESS_0;
> > +
> > +				if (write) {
> > +					vdev->vinfo.bar[boff] = newval;
> > +					vdev->vinfo.bardirty = 1;
> > +				} else {
> > +					if (vdev->vinfo.bardirty)
> > +						vfio_bar_fixup(vdev);
> > +					val = vdev->vinfo.bar[boff];
> > +				}
> > +			}
> > +			break;
> > +		}
> > +		break;
> > +	case PCI_CAP_ID_MSI:		/* virtualize (parts of) MSI */
> > +		if (write)
> > +			vdev->vinfo.msi[off] = newval;
> > +		else
> > +			val = vdev->vinfo.msi[off];
> > +		break;
> > +	}
> > +	if (!write && copy_to_user(buf, &val, 1))
> > +		return -EFAULT;
> > +	return 0;
> > +}
> > +
> > +ssize_t vfio_config_readwrite(int write,
> > +		struct vfio_dev *vdev,
> > +		char __user *buf,
> > +		size_t count,
> > +		loff_t *ppos)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	int done = 0;
> > +	int ret;
> > +	u16 pos;
> > +
> > +
> > +	if (vdev->pci_config_map == NULL) {
> > +		ret = vfio_build_config_map(vdev);
> > +		if (ret < 0)
> > +			goto out;
> > +		vfio_virt_init(vdev);
> > +	}
> > +
> > +	while (count > 0) {
> > +		pos = *ppos;
> > +		if (pos == pdev->cfg_size)
> > +			break;
> > +		if (pos > pdev->cfg_size) {
> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> > +
> > +		/*
> > +		 * we grab the irqlock here to prevent confusing
> > +		 * the read/modify/write sequence in vfio_interrupt
> > +		 */
> > +		spin_lock_irq(&vdev->irqlock);
> > +		ret = vfio_config_rwbyte(write, vdev, pos, buf);
> > +		spin_unlock_irq(&vdev->irqlock);
> > +
> > +		if (ret < 0)
> > +			goto out;
> > +		buf++;
> > +		done++;
> > +		count--;
> > +		(*ppos)++;
> > +	}
> > +	ret = done;
> > +out:
> > +	return ret;
> > +}
> > diff --git a/drivers/vfio/vfio_rdwr.c b/drivers/vfio/vfio_rdwr.c
> > index e69de29..f4bd2b7 100644
> > --- a/drivers/vfio/vfio_rdwr.c
> > +++ b/drivers/vfio/vfio_rdwr.c
> > @@ -0,0 +1,152 @@
> > +/*
> > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > + * Author: Tom Lyon, pugs@cisco.com
> 
> Any hints on what this file does?
> 
> > + *
> > + * This program is free software; you may redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + *
> > + * Portions derived from drivers/uio/uio.c:
> > + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> > + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> > + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> > + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> > + *
> > + * Portions derived from drivers/uio/uio_pci_generic.c:
> > + * Copyright (C) 2009 Red Hat, Inc.
> > + * Author: Michael S. Tsirkin <mst@redhat.com>
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/mmu_notifier.h>
> > +#include <linux/pci.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/io.h>
> > +
> > +#include <linux/vfio.h>
> > +
> > +ssize_t vfio_io_readwrite(
> > +		int write,
> > +		struct vfio_dev *vdev,
> > +		char __user *buf,
> > +		size_t count,
> > +		loff_t *ppos)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	size_t done = 0;
> > +	resource_size_t end;
> > +	void __iomem *io;
> > +	loff_t pos;
> > +	int pci_space;
> > +	int unit;
> > +
> > +	pci_space = vfio_offset_to_pci_space(*ppos);
> > +	pos = vfio_offset_to_pci_offset(*ppos);
> > +
> > +	if (!pci_resource_start(pdev, pci_space))
> > +		return -EINVAL;
> > +	end = pci_resource_len(pdev, pci_space);
> > +	if (pos + count > end)
> > +		return -EINVAL;
> > +	if (vdev->bar[pci_space] == NULL)
> > +		vdev->bar[pci_space] = pci_iomap(pdev, pci_space, 0);
> > +	io = vdev->bar[pci_space];
> > +
> > +	while (count > 0) {
> > +		if ((pos % 4) == 0 && count >= 4) {
> > +			u32 val;
> > +
> > +			if (write) {
> > +				if (copy_from_user(&val, buf, 4))
> > +					return -EFAULT;
> > +				iowrite32(val, io + pos);
> > +			} else {
> > +				val = ioread32(io + pos);
> > +				if (copy_to_user(buf, &val, 4))
> > +					return -EFAULT;
> > +			}
> > +			unit = 4;
> > +		} else if ((pos % 2) == 0 && count >= 2) {
> > +			u16 val;
> > +
> > +			if (write) {
> > +				if (copy_from_user(&val, buf, 2))
> > +					return -EFAULT;
> > +				iowrite16(val, io + pos);
> > +			} else {
> > +				val = ioread16(io + pos);
> > +				if (copy_to_user(buf, &val, 2))
> > +					return -EFAULT;
> > +			}
> > +			unit = 2;
> > +		} else {
> > +			u8 val;
> > +
> > +			if (write) {
> > +				if (copy_from_user(&val, buf, 1))
> > +					return -EFAULT;
> > +				iowrite8(val, io + pos);
> > +			} else {
> > +				val = ioread8(io + pos);
> > +				if (copy_to_user(buf, &val, 1))
> > +					return -EFAULT;
> > +			}
> > +			unit = 1;
> > +		}
> > +		pos += unit;
> > +		buf += unit;
> > +		count -= unit;
> > +		done += unit;
> 
> Again, export from pci-sysfs.c?

I just submitted a patch to be able to do read/write to ioport
resources, but I still think these serve a different purpose.  PCI sysfs
config and resource files don't have the same tie in to DMA mapping as
vfio does, so they'll happily let you setup the device without the added
security of an iommu.  We have to trust that the user is going to be
safe and use the iommu.  I believe vfio is trying to create a safe
interface that provides iommu enforcement and simple config space
virtualization, so does need to reimplement a few things that we may be
able to get unsafely through pci-sysfs.

> > +	}
> > +	*ppos += done;
> > +	return done;
> > +}
> > +
> > +ssize_t vfio_mem_readwrite(
> > +		int write,
> > +		struct vfio_dev *vdev,
> > +		char __user *buf,
> > +		size_t count,
> > +		loff_t *ppos)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	resource_size_t end;
> > +	void __iomem *io;
> > +	loff_t pos;
> > +	int pci_space;
> > +
> > +	pci_space = vfio_offset_to_pci_space(*ppos);
> > +	pos = vfio_offset_to_pci_offset(*ppos);
> > +
> > +	if (!pci_resource_start(pdev, pci_space))
> > +		return -EINVAL;
> > +	end = pci_resource_len(pdev, pci_space);
> > +	if (vdev->bar[pci_space] == NULL)
> > +		vdev->bar[pci_space] = pci_iomap(pdev, pci_space, 0);
> > +	io = vdev->bar[pci_space];
> > +
> > +	if (pos > end)
> > +		return -EINVAL;
> > +	if (pos == end)
> > +		return 0;
> > +	if (pos + count > end)
> > +		count = end - pos;
> > +	if (write) {
> > +		if (copy_from_user(io + pos, buf, count))
> > +			return -EFAULT;
> > +	} else {
> > +		if (copy_to_user(buf, io + pos, count))
> > +			return -EFAULT;
> > +	}
> > +	*ppos += count;
> > +	return count;
> > +}
> > diff --git a/drivers/vfio/vfio_sysfs.c b/drivers/vfio/vfio_sysfs.c
> > index e69de29..6275809 100644
> > --- a/drivers/vfio/vfio_sysfs.c
> > +++ b/drivers/vfio/vfio_sysfs.c
> > @@ -0,0 +1,153 @@
> > +/*
> > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > + * Author: Tom Lyon, pugs@cisco.com
> > + *
> > + * This program is free software; you may redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + *
> > + * Portions derived from drivers/uio/uio.c:
> > + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> > + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> > + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> > + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> > + *
> > + * Portions derived from drivers/uio/uio_pci_generic.c:
> > + * Copyright (C) 2009 Red Hat, Inc.
> > + * Author: Michael S. Tsirkin <mst@redhat.com>
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/device.h>
> > +#include <linux/kobject.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/mm.h>
> > +#include <linux/fs.h>
> > +#include <linux/pci.h>
> > +#include <linux/mmu_notifier.h>
> > +
> > +#include <linux/vfio.h>
> > +
> > +struct vfio_class *vfio_class;
> > +
> > +int vfio_class_init(void)
> > +{
> > +	int ret = 0;
> > +
> > +	if (vfio_class != NULL) {
> > +		kref_get(&vfio_class->kref);
> > +		goto exit;
> > +	}
> > +
> > +	vfio_class = kzalloc(sizeof(*vfio_class), GFP_KERNEL);
> > +	if (!vfio_class) {
> > +		ret = -ENOMEM;
> > +		goto err_kzalloc;
> > +	}
> > +
> > +	kref_init(&vfio_class->kref);
> > +	vfio_class->class = class_create(THIS_MODULE, "vfio");
> > +	if (IS_ERR(vfio_class->class)) {
> > +		ret = IS_ERR(vfio_class->class);
> > +		printk(KERN_ERR "class_create failed for vfio\n");
> > +		goto err_class_create;
> > +	}
> > +	return 0;
> > +
> > +err_class_create:
> > +	kfree(vfio_class);
> > +	vfio_class = NULL;
> > +err_kzalloc:
> > +exit:
> > +	return ret;
> > +}
> > +
> > +static void vfio_class_release(struct kref *kref)
> > +{
> > +	/* Ok, we cheat as we know we only have one vfio_class */
> > +	class_destroy(vfio_class->class);
> > +	kfree(vfio_class);
> > +	vfio_class = NULL;
> > +}
> > +
> > +void vfio_class_destroy(void)
> > +{
> > +	if (vfio_class)
> > +		kref_put(&vfio_class->kref, vfio_class_release);
> > +}
> > +
> > +static ssize_t config_map_read(struct kobject *kobj,
> > +		struct bin_attribute *bin_attr,
> > +		char *buf, loff_t off, size_t count)
> > +{
> > +	struct vfio_dev *vdev = bin_attr->private;
> > +	int ret;
> > +
> > +	if (off >= 256)
> > +		return 0;
> > +	if (off + count > 256)
> > +		count = 256 - off;
> > +	if (vdev->pci_config_map == NULL) {
> > +		ret = vfio_build_config_map(vdev);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +	memcpy(buf, vdev->pci_config_map + off, count);
> > +	return count;
> > +}
> > +
> > +static ssize_t show_locked_pages(struct device *dev,
> > +				 struct device_attribute *attr,
> > +				 char *buf)
> > +{
> > +	struct vfio_dev *vdev = dev_get_drvdata(dev);
> > +
> > +	if (vdev == NULL)
> > +		return -ENODEV;
> > +	return sprintf(buf, "%u\n", vdev->locked_pages);
> > +}
> > +
> > +static DEVICE_ATTR(locked_pages, S_IRUGO, show_locked_pages, NULL);
> > +
> > +static struct attribute *vfio_attrs[] = {
> > +	&dev_attr_locked_pages.attr,
> > +	NULL,
> > +};
> > +
> > +static struct attribute_group vfio_attr_grp = {
> > +	.attrs = vfio_attrs,
> > +};
> > +
> > +static struct bin_attribute config_map_bin_attribute = {
> > +	.attr	= {
> > +		.name = "config_map",
> > +		.mode = S_IRUGO,
> > +	},
> > +	.size	= 256,
> > +	.read	= config_map_read,
> > +};
> 
> The config map looks like an internal implementation detail
> of the driver. Right? If so exposing it will tie us to
> this forever, so not a good idea.
> 
> > +
> > +int vfio_dev_add_attributes(struct vfio_dev *vdev)
> > +{
> > +	struct bin_attribute *bi;
> > +	int ret;
> > +
> > +	ret = sysfs_create_group(&vdev->dev->kobj, &vfio_attr_grp);
> > +	if (ret)
> > +		return ret;
> > +	bi = kmalloc(sizeof(*bi), GFP_KERNEL);
> > +	if (bi == NULL)
> > +		return -ENOMEM;
> > +	*bi = config_map_bin_attribute;
> > +	bi->private = vdev;
> > +	return sysfs_create_bin_file(&vdev->dev->kobj, bi);
> > +}
> > diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> > index e2ea0b2..ed37cf4 100644
> > --- a/include/linux/Kbuild
> > +++ b/include/linux/Kbuild
> > @@ -166,6 +166,7 @@ header-y += ultrasound.h
> >  header-y += un.h
> >  header-y += utime.h
> >  header-y += veth.h
> > +header-y += vfio.h
> >  header-y += videotext.h
> >  header-y += x25.h
> >  
> > diff --git a/include/linux/uiommu.h b/include/linux/uiommu.h
> > index e69de29..a7b7eac 100644
> > --- a/include/linux/uiommu.h
> > +++ b/include/linux/uiommu.h
> > @@ -0,0 +1,76 @@
> > +/*
> > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > + * Author: Tom Lyon, pugs@cisco.com
> > + *
> > + * This program is free software; you may redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + */
> > +
> > +/*
> > + * uiommu driver - manipulation of iommu domains from user progs
> > + */
> > +struct uiommu_domain {
> > +	struct iommu_domain	*domain;
> > +	atomic_t		refcnt;
> > +};
> > +
> > +/*
> > + * Kernel routines invoked by fellow driver (vfio)
> > + * after uiommu domain fd is passed in.
> > + */
> > +struct uiommu_domain *uiommu_fdget(int fd);
> > +void uiommu_put(struct uiommu_domain *);
> > +
> > +/*
> > + * These inlines are placeholders for future routines
> > + * which may keep statistics, show info in sysfs, etc.
> > + */
> > +static inline int uiommu_attach_device(struct uiommu_domain *udomain,
> > +			       struct device *dev)
> > +{
> > +	return iommu_attach_device(udomain->domain, dev);
> > +}
> > +
> > +static inline void uiommu_detach_device(struct uiommu_domain *udomain,
> > +				struct device *dev)
> > +{
> > +	iommu_detach_device(udomain->domain, dev);
> > +}
> > +
> > +static inline int uiommu_map_range(struct uiommu_domain *udomain,
> > +				unsigned long iova,
> > +				phys_addr_t paddr,
> > +				size_t size,
> > +				int prot)
> > +{
> > +	return iommu_map_range(udomain->domain, iova, paddr, size, prot);
> > +}
> > +
> > +static inline void uiommu_unmap_range(struct uiommu_domain *udomain,
> > +					unsigned long iova,
> > +					size_t size)
> > +{
> > +	iommu_unmap_range(udomain->domain, iova, size);
> > +}
> > +
> > +static inline phys_addr_t uiommu_iova_to_phys(struct uiommu_domain *udomain,
> > +						unsigned long iova)
> > +{
> > +	return iommu_iova_to_phys(udomain->domain, iova);
> > +}
> > +
> > +static inline int uiommu_domain_has_cap(struct uiommu_domain *udomain,
> > +						unsigned long cap)
> > +{
> > +	return iommu_domain_has_cap(udomain->domain, cap);
> > +}
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e69de29..52aa0dd 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -0,0 +1,202 @@
> > +/*
> > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > + * Author: Tom Lyon, pugs@cisco.com
> > + *
> > + * This program is free software; you may redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + *
> > + * Portions derived from drivers/uio/uio.c:
> > + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> > + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> > + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> > + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> > + *
> > + * Portions derived from drivers/uio/uio_pci_generic.c:
> > + * Copyright (C) 2009 Red Hat, Inc.
> > + * Author: Michael S. Tsirkin <mst@redhat.com>
> > + */
> > +#include <linux/types.h>
> > +
> > +/*
> > + * VFIO driver - allow mapping and use of certain PCI devices
> > + * in unprivileged user processes. (If IOMMU is present)
> > + * Especially useful for Virtual Function parts of SR-IOV devices
> > + */
> > +
> > +#ifdef __KERNEL__
> > +
> > +struct vfio_dev {
> > +	struct device	*dev;
> > +	struct pci_dev	*pdev;
> > +	u8		*pci_config_map;
> > +	int		pci_config_size;
> > +	char		name[8];
> > +	int		devnum;
> > +	void __iomem	*bar[PCI_ROM_RESOURCE+1];
> > +	spinlock_t	irqlock;	/* guards command register accesses */
> > +	int		listeners;
> > +	u32		locked_pages;
> > +	struct mutex	lgate;		/* listener gate */
> > +	struct mutex	dgate;		/* dma op gate */
> > +	struct mutex	igate;		/* intr op gate */
> > +	wait_queue_head_t dev_idle_q;
> > +	int		mapcount;
> > +	struct uiommu_domain	*udomain;
> > +	struct msix_entry	*msix;
> > +	int			nvec;
> > +	int			cachec;
> > +	struct eventfd_ctx	*ev_irq;
> > +	struct eventfd_ctx	*ev_msi;
> > +	struct eventfd_ctx	**ev_msix;
> > +	struct {
> > +		u8	intr;
> > +		u8	bardirty;
> > +		u8	rombar[4];
> > +		u8	bar[6*4];
> > +		u8	msi[24];
> > +	} vinfo;
> > +};
> > +
> > +struct vfio_listener {
> > +	struct vfio_dev	*vdev;
> > +	struct list_head	dm_list;
> > +	struct mm_struct	*mm;
> > +	struct mmu_notifier	mmu_notifier;
> > +};
> > +
> > +/*
> > + * Structure for keeping track of memory nailed down by the
> > + * user for DMA
> > + */
> > +struct dma_map_page {
> > +	struct list_head list;
> > +	struct page     **pages;
> > +	dma_addr_t      daddr;
> > +	unsigned long	vaddr;
> > +	int		npage;
> > +	int		rdwr;
> > +};
> > +
> > +/* VFIO class infrastructure */
> > +struct vfio_class {
> > +	struct kref kref;
> > +	struct class *class;
> > +};
> > +extern struct vfio_class *vfio_class;
> > +
> > +ssize_t vfio_io_readwrite(int, struct vfio_dev *,
> > +			char __user *, size_t, loff_t *);
> > +ssize_t vfio_mem_readwrite(int, struct vfio_dev *,
> > +			char __user *, size_t, loff_t *);
> > +ssize_t vfio_config_readwrite(int, struct vfio_dev *,
> > +			char __user *, size_t, loff_t *);
> > +
> > +void vfio_disable_msi(struct vfio_dev *);
> > +void vfio_disable_msix(struct vfio_dev *);
> > +int vfio_enable_msi(struct vfio_dev *, int);
> > +int vfio_enable_msix(struct vfio_dev *, int, void __user *);
> > +
> > +#ifndef PCI_MSIX_ENTRY_SIZE
> > +#define	PCI_MSIX_ENTRY_SIZE	16
> > +#endif
> > +#ifndef PCI_STATUS_INTERRUPT
> > +#define	PCI_STATUS_INTERRUPT	0x08
> > +#endif
> > +
> > +struct vfio_dma_map;
> > +void vfio_dma_unmapall(struct vfio_listener *);
> > +int vfio_dma_unmap_dm(struct vfio_listener *, struct vfio_dma_map *);
> > +int vfio_dma_map_common(struct vfio_listener *, unsigned int,
> > +			struct vfio_dma_map *);
> > +int vfio_domain_set(struct vfio_dev *, int, int);
> > +int vfio_domain_unset(struct vfio_dev *);
> > +
> > +int vfio_class_init(void);
> > +void vfio_class_destroy(void);
> > +int vfio_dev_add_attributes(struct vfio_dev *);
> > +int vfio_build_config_map(struct vfio_dev *);
> > +
> > +irqreturn_t vfio_interrupt(int, void *);
> > +
> > +#endif	/* __KERNEL__ */
> > +
> > +/* Kernel & User level defines for ioctls */
> > +
> > +/*
> > + * Structure for DMA mapping of user buffers
> > + * vaddr, dmaaddr, and size must all be page aligned
> > + * buffer may only be larger than 1 page if (a) there is
> > + * an iommu in the system, or (b) buffer is part of a huge page
> > + */
> > +struct vfio_dma_map {
> > +	__u64	vaddr;		/* process virtual addr */
> > +	__u64	dmaaddr;	/* desired and/or returned dma address */
> > +	__u64	size;		/* size in bytes */
> > +	__u64	flags;		/* bool: 0 for r/o; 1 for r/w */
> > +#define	VFIO_FLAG_WRITE		0x1	/* req writeable DMA mem */
> > +};
> > +
> > +/* map user pages at specific dma address */
> > +/* requires previous VFIO_DOMAIN_SET */
> > +#define	VFIO_DMA_MAP_IOVA	_IOWR(';', 101, struct vfio_dma_map)
> > +
> > +/* unmap user pages */
> > +#define	VFIO_DMA_UNMAP		_IOW(';', 102, struct vfio_dma_map)
> > +
> > +/* request IRQ interrupts; use given eventfd */
> > +#define	VFIO_EVENTFD_IRQ	_IOW(';', 103, int)
> > +
> > +/* request MSI interrupts; use given eventfd */
> > +#define	VFIO_EVENTFD_MSI	_IOW(';', 104, int)
> > +
> > +/* Request MSI-X interrupts: arg[0] is #, arg[1-n] are eventfds */
> > +#define	VFIO_EVENTFDS_MSIX	_IOW(';', 105, int)
> > +
> > +/* Get length of a BAR */
> > +#define	VFIO_BAR_LEN		_IOWR(';', 167, __u32)
> > +
> > +/* Set the IOMMU domain - arg is fd from uiommu driver */
> > +#define	VFIO_DOMAIN_SET		_IOW(';', 107, int)
> > +
> > +/* Unset the IOMMU domain */
> > +#define	VFIO_DOMAIN_UNSET	_IO(';', 108)
> > +
> > +/*
> > + * Reads, writes, and mmaps determine which PCI BAR (or config space)
> > + * from the high level bits of the file offset
> > + */
> > +#define	VFIO_PCI_BAR0_RESOURCE		0x0
> > +#define	VFIO_PCI_BAR1_RESOURCE		0x1
> > +#define	VFIO_PCI_BAR2_RESOURCE		0x2
> > +#define	VFIO_PCI_BAR3_RESOURCE		0x3
> > +#define	VFIO_PCI_BAR4_RESOURCE		0x4
> > +#define	VFIO_PCI_BAR5_RESOURCE		0x5
> 
> This looks wrong.
> In the code I snipped, we had:
>  +       pci_space = vfio_offset_to_pci_space(*ppos);
> 
> So this is actually used as resource number, not BAR number.
> One or the other will need to get fixed, otherwise
> with 64 bit BAR0, you will get the wrong resource.

Aren't BAR number and resource number synonymous?  I would have assumed
that if BAR0 is 64bit, pci_resource_len(, BAR1) is zero, which should
work just fine for the way it's coded up here.

> > +#define	VFIO_PCI_ROM_RESOURCE		0x6
> > +#define	VFIO_PCI_CONFIG_RESOURCE	0xF
> > +#define	VFIO_PCI_SPACE_SHIFT	32
> > +#define VFIO_PCI_CONFIG_OFF vfio_pci_space_to_offset(VFIO_PCI_CONFIG_RESOURCE)
> > +
> > +static inline int vfio_offset_to_pci_space(__u64 off)
> > +{
> > +	return (off >> VFIO_PCI_SPACE_SHIFT) & 0xF;
> > +}
> > +
> > +static inline u32 vfio_offset_to_pci_offset(__u64 off)
> > +{
> > +	return off & (u32)0xFFFFFFFF;
> > +}
> > +
> > +static inline __u64 vfio_pci_space_to_offset(int sp)
> > +{
> > +	return (__u64)(sp) << VFIO_PCI_SPACE_SHIFT;
> > +}



