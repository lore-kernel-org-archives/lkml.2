Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab0I0MAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:00:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab0I0MAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:00:43 -0400
Date: Mon, 27 Sep 2010 13:54:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        alex.williamson@redhat.com
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level PCI
 drivers
Message-ID: <20100927115420.GA7427@redhat.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 02:18:24PM -0700, Tom Lyon wrote:
> 
> Signed-off-by: Tom Lyon <pugs@cisco.com>

Some comments on the pci bits:

After going over them for the Nth time - something needs to be done
with the rvirt/write tables. I doubt anyone besides me and you
has gone over them: one has to pull
up the spec just to understand which bits are set here. Why can't we
have a module init routine and use the macros in pci_regs.h for this purpose,
as all other drivers do? We will also get to use the nice
endian-ness macros linux has for portability ...


> +static struct perm_bits pci_cap_basic_perm[] = {

What endian-ness is this? Native?
You pass this to user as is but pci config is little endian...
Also -are all these readonly? So const? read mostly?


> +	{ 0xFFFFFFFF,	0, },		/* 0x00 vendor & device id - RO */
> +	{ 0x00000003,	0xFFFFFFFF, },	/* 0x04 cmd - mem & io bits virt */

Interrupt disable bit is under host control.

> +	{ 0,		0, },		/* 0x08 class code & revision id */
> +	{ 0,		0xFF00FFFF, },	/* 0x0c bist, htype, lat, cache */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x10 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x14 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x18 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x1c bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x20 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x24 bar */
> +	{ 0,		0, },		/* 0x28 cardbus - not yet */
> +	{ 0,		0, },		/* 0x2c subsys vendor & dev */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x30 rom bar */
> +	{ 0,		0, },		/* 0x34 capability ptr & resv */
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
> +/* 4 different possible layouts of MSI capability */
> +static struct perm_bits pci_cap_msi_10_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x08 MSI message data */
> +};
> +static struct perm_bits pci_cap_msi_14_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message upper addr */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> +};
> +static struct perm_bits pci_cap_msi_20_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x08 MSI message data */
> +	{ 0,		0xFFFFFFFF, },	/* 0x0c MSI mask bits */
> +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI pending bits */
> +};
> +static struct perm_bits pci_cap_msi_24_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message upper addr */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI mask bits */
> +	{ 0,		0xFFFFFFFF, },	/* 0x14 MSI pending bits */
> +};

You let guest control MSI mask and do not virtualize,
but the host expects to control this register - it is
used for masking during interrupt rebalancing.
This will break the device, or even the host with
'unsafe interrupts' enabled.

Note that if you virtualize it, you will have to virtualize
the pending bits too.


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
> +	[PCI_CAP_ID_MSI]	= NULL,			/* special */
> +	[PCI_CAP_ID_PCIX]	= pci_cap_pcix_perm,
> +	[PCI_CAP_ID_EXP]	= pci_cap_exp_perm,
> +	[PCI_CAP_ID_MSIX]	= pci_cap_msix_perm,
> +	[PCI_CAP_ID_AF]		= pci_cap_af_perm,
> +};




> +int vfio_build_config_map(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u8 *map;
> +	int i, len;
> +	u8 pos, cap, tmp;
> +	u16 flags;
> +	int ret;
> +#ifndef PCI_FIND_CAP_TTL
> +#define PCI_FIND_CAP_TTL	48
> +#endif

Could you add a comment to explain what is the TTL for?
Where do you get the number 48?
Why do you have the ifndef here?
Why does it start with PCI_?

> +	int loops = PCI_FIND_CAP_TTL;
> +
> +	map = kmalloc(pdev->cfg_size, GFP_KERNEL);

So this will allocate a 4K for express, but you
never even look at express capabilities, so
you will never even touch them?


> +	if (map == NULL)
> +		return -ENOMEM;
> +	for (i = 0; i < pdev->cfg_size; i++)
> +		map[i] = 0xFF;
> +	vdev->pci_config_map = map;
> +
> +	/* default config space */
> +	for (i = 0; i < pci_capability_length[0]; i++)
> +		map[i] = 0;
> +
> +	/* any capabilities? */
> +	ret = pci_read_config_word(pdev, PCI_STATUS, &flags);
> +	if (ret < 0)
> +		return ret;
> +	if ((flags & PCI_STATUS_CAP_LIST) == 0)
> +		return 0;
> +
> +	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
> +	if (ret < 0)
> +		return ret;
> +	while (pos && --loops > 0) {
> +		ret = pci_read_config_byte(pdev, pos, &cap);
> +		if (ret < 0)
> +			return ret;
> +		if (cap == 0) {
> +			printk(KERN_WARNING "%s: cap 0\n", __func__);
> +			break;
> +		}
> +		if (cap > PCI_CAP_ID_MAX) {
> +			printk(KERN_WARNING "%s: unknown pci capability id %x\n",
> +					__func__, cap);
> +			len = 0;
> +		} else
> +			len = pci_capability_length[cap];
> +		if (len == 0) {
> +			printk(KERN_WARNING "%s: unknown length for pci cap %x\n",
> +					__func__, cap);
> +			len = 4;
> +		}
> +		if (len == 0xFF) {
> +			switch (cap) {
> +			case PCI_CAP_ID_MSI:
> +				len = vfio_msi_cap_len(vdev, pos);
> +				if (len < 0)
> +					return len;
> +				break;
> +			case PCI_CAP_ID_PCIX:
> +				ret = pci_read_config_word(pdev, pos + 2,
> +					&flags);
> +				if (ret < 0)
> +					return ret;
> +				if (flags & 0x3000)
> +					len = 24;
> +				else
> +					len = 8;
> +				break;
> +			case PCI_CAP_ID_VNDR:
> +				/* length follows next field */
> +				ret = pci_read_config_byte(pdev, pos + 2, &tmp);
> +				if (ret < 0)
> +					return ret;
> +				len = tmp;
> +				break;
> +			default:
> +				len = 0;
> +				break;
> +			}
> +		}
> +
> +		for (i = 0; i < len; i++) {
> +			if (map[pos+i] != 0xFF)
> +				printk(KERN_WARNING
> +					"%s: pci config conflict at %x, "
> +					"caps %x %x\n",
> +					__func__, i, map[pos+i], cap);
> +			map[pos+i] = cap;
> +		}
> +		ret = pci_read_config_byte(pdev, pos + PCI_CAP_LIST_NEXT, &pos);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	if (loops <= 0)
> +		printk(KERN_ERR "%s: config space loop!\n", __func__);

If you just want to find all predefined capabilities,
you should porobably just use pci_find_cap.

> +	return 0;
> +}
> +
> +static int vfio_virt_init(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u32 *lp;
> +	int i;
> +
> +	vdev->vconfig = kmalloc(256, GFP_KERNEL);
> +	if (vdev->vconfig == NULL)
> +		return -ENOMEM;

This one is only 256. It looks like it's sometimes
indexed by position which is up to cfg_size,
so it can crash for pci express.

> +
> +	lp = (u32 *)vdev->vconfig;
> +	for (i = 0; i < 256/sizeof(u32); i++, lp++)
> +		pci_read_config_dword(pdev, i * sizeof(u32), lp);
> +	vdev->bardirty = 1;
> +
> +	vdev->rbar[0] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
> +	vdev->rbar[1] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_1];
> +	vdev->rbar[2] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_2];
> +	vdev->rbar[3] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_3];
> +	vdev->rbar[4] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_4];
> +	vdev->rbar[5] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_5];
> +	vdev->rbar[6] = *(u32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
> +
> +	/* for sr-iov devices */
> +	vdev->vconfig[PCI_VENDOR_ID] = pdev->vendor & 0xFF;
> +	vdev->vconfig[PCI_VENDOR_ID+1] = pdev->vendor >> 8;
> +	vdev->vconfig[PCI_DEVICE_ID] = pdev->device & 0xFF;
> +	vdev->vconfig[PCI_DEVICE_ID+1] = pdev->device >> 8;
> +
> +	return 0;
> +}
> +
> +/*
> + * Restore the *real* BARs after we detect a backdoor reset.
> + * (backdoor = some device specific technique that we didn't catch)
> + */
> +static void vfio_bar_restore(struct vfio_dev *vdev)
> +{
> +	printk(KERN_WARNING "%s: restoring real bars\n", __func__);
> +
> +#define do_bar(off, which) \
> +	pci_user_write_config_dword(vdev->pdev, off, vdev->rbar[which])
> +
> +	do_bar(PCI_BASE_ADDRESS_0, 0);
> +	do_bar(PCI_BASE_ADDRESS_1, 1);
> +	do_bar(PCI_BASE_ADDRESS_2, 2);
> +	do_bar(PCI_BASE_ADDRESS_3, 3);
> +	do_bar(PCI_BASE_ADDRESS_4, 4);
> +	do_bar(PCI_BASE_ADDRESS_5, 5);
> +	do_bar(PCI_ROM_ADDRESS, 6);
> +#undef do_bar
> +}
> +
> +/*
> + * Pretend we're hardware and tweak the values
> + * of the *virtual* pci BARs to reflect the hardware
> + * capabilities
> + */
> +static void vfio_bar_fixup(struct vfio_dev *vdev)
> +{

So you do this on each read?
Why don't you mask the appropriate bits on write?
This is what real hardware does, after all.
Then you won't need the bardirty field.


> +	struct pci_dev *pdev = vdev->pdev;
> +	int bar;
> +	u32 *lp;
> +	u64 mask;
> +
> +	for (bar = 0; bar <= 5; bar++) {
> +		if (pci_resource_start(pdev, bar))
> +			mask = ~(pci_resource_len(pdev, bar) - 1);
> +		else
> +			mask = 0;
> +		lp = (u32 *)vdev->vconfig + PCI_BASE_ADDRESS_0 + 4*bar;
> +		*lp &= (u32)mask;
> +
> +		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
> +			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
> +		else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
> +			*lp |= PCI_BASE_ADDRESS_SPACE_MEMORY;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_PREFETCH)
> +				*lp |= PCI_BASE_ADDRESS_MEM_PREFETCH;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM_64) {
> +				*lp |= PCI_BASE_ADDRESS_MEM_TYPE_64;
> +				lp++;
> +				*lp &= (u32)(mask >> 32);
> +				bar++;
> +			}
> +		}
> +	}
> +
> +	if (pci_resource_start(pdev, PCI_ROM_RESOURCE))

Not if (pci_resource_len)?

> +		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
> +	else
> +		mask = 0;
> +	lp = (u32 *)vdev->vconfig + PCI_ROM_ADDRESS;
> +	*lp &= (u32)mask;
> +
> +	vdev->bardirty = 0;

Aren't the pci values in little endian format?
If so doing operations on them in native endianness is wrong.
sparse generally is good at catching these, but you will
have to avoid so many type casts and annotate endian-ness
for it to be of any use.

> +ssize_t vfio_config_readwrite(int write,
> +		struct vfio_dev *vdev,
> +		char __user *buf,
> +		size_t count,
> +		loff_t *ppos)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int done = 0;
> +	int ret;
> +	u16 pos;
> +
> +
> +	if (vdev->pci_config_map == NULL) {
> +		ret = vfio_build_config_map(vdev);
> +		if (ret)
> +			goto out;
> +	}
> +	if (vdev->vconfig == NULL) {
> +		ret = vfio_virt_init(vdev);
> +		if (ret)
> +			goto out;
> +	}

Why don't you init all this on open?

> +
> +	while (count > 0) {
> +		pos = *ppos;
> +		if (pos == pdev->cfg_size)
> +			break;
> +		if (pos > pdev->cfg_size) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		ret = vfio_config_rwbyte(write, vdev, pos, buf);

So you split each access to 1 byte accesses. Hmm.
This will break atomicity guarantees - maybe it does not matter,
but this is why the _userspace accesses are there after all.

Wouldn't it be easier to only support 1, 2 and 4 byte accesses?
This is what all drivers do after all...

> +
> +		if (ret < 0)
> +			goto out;
> +		buf++;
> +		done++;
> +		count--;
> +		(*ppos)++;
> +	}
> +	ret = done;
> +out:
> +	return ret;
> +}
-- 
MST
