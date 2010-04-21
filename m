Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0DUJm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:42:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab0DUJmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:42:52 -0400
Date: Wed, 21 Apr 2010 12:38:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: hjk@linutronix.de, gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org,
       avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] drivers/uio/uio_pci_generic.c: allow access for
	non-privileged processes
Message-ID: <20100421093849.GB30855@redhat.com>
References: <4bccd3af.M/eSrn9OV22zg0A8%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bccd3af.M/eSrn9OV22zg0A8%pugs@cisco.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 03:05:35PM -0700, Tom Lyon wrote:
> 
> These are changes to uio_pci_generic.c to allow better use of the driver by
> non-privileged processes.
> 1. Add back old code which allowed interrupt re-enablement through uio fd.
> 2. Translate PCI bards to uio mmap regions, to allow mmap through uio fd.

Since it's common for drivers to need configuration cycles
for device control, the above 2 are not sufficient for generic devices.
And if you fix the above, you won't need irqcontrol,
which IMO we are better off saving for stuff like eventfd mapping.

Also - this modifies a kernel/userspace interface in a way
that makes an operation that was always safe previously
potentially unsafe.

Also, BAR regions could be less than 1 page in size,
mapping these to unpriveledged process is a security problem.

Also, for a generic driver, we likely need write combining
support in the interface.

Also, io space often can not be mmaped. We need read/write
for that.

> 3. Allow devices which support MSI or MSI-X, but not IRQ.

If the device supports MSI or MSI-X, it can perform
PCI writes upstream, and MSI-X vectors are controlled
through memory. So with MSI-X + mmap to an unpriveledged
process you can easily cause the device to modify any memory.

With MSI it's hard to be sure, maybe some devices might make guarantees
not to do writes except for MSI, but there's no generic way to declare
that: bus master needs to be enabled for MSI to work, and once bus
master is enabled, nothing seems to prevent the device from corrupting
host memory.


> 	Signed-off-by: Tom Lyon <pugs@cisco.com>

So the patch doesn't look like generic enough or safe enough
for users I have in mind (virtualization). What users/devices
do you have in mind?

For virtualization, I've been thinking about unpriviledged access and
msi as well, and here's a plan I thought might work:

- add a uio_iommu character device that controls an iommu domain
- uio_iommu would make sure iommu is programmed in a safe way
- use irqcontrol to bind pci device to iommu domain
- allow config cycles through uio fd, but
  force bus master to 0 unless device is bound to a domain
- for sub-page regions, and io, we can't allow mmap to an unpriveledged
  process. extend irqcontrol to allow read/write and range-check the
  operations
- for msi/msix, drivers use multiple vectors. One idea is to
  map them by binding an eventfd to a vector. This approach has
  the advantage that in virtualization space, kvm already
  can consume eventfd descriptors.

That's it at a high level

> ---
> checkpatch.pl is happy with this one.
> 
> --- linux-2.6.33/drivers/uio/uio_pci_generic.c	2010-02-24 10:52:17.000000000 -0800
> +++ mylinux-2.6.33/drivers/uio/uio_pci_generic.c	2010-04-19 14:57:21.000000000 -0700
> @@ -14,9 +14,10 @@
>   * # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
>   * .../0000:00:19.0/driver -> ../../../bus/pci/drivers/uio_pci_generic
>   *
> - * Driver won't bind to devices which do not support the Interrupt Disable Bit
> - * in the command register. All devices compliant to PCI 2.3 (circa 2002) and
> - * all compliant PCI Express devices should support this bit.
> + * Driver won't bind to devices which do not support MSI, MSI-x, or the
> + * Interrupt Disable Bit in the command register. All devices compliant
> + * to PCI 2.3 (circa 2002) and all compliant PCI Express devices should
> + * support one of these.
>   */
>  
>  #include <linux/device.h>
> @@ -27,7 +28,7 @@
>  
>  #define DRIVER_VERSION	"0.01.0"
>  #define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
> -#define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
> +#define DRIVER_DESC	"Generic UIO driver for PCIe & PCI 2.3 devices"
>  
>  struct uio_pci_generic_dev {
>  	struct uio_info info;
> @@ -41,6 +42,39 @@ to_uio_pci_generic_dev(struct uio_info *
>  	return container_of(info, struct uio_pci_generic_dev, info);
>  }
>  
> +/* Read/modify/write command register to disable interrupts.
> + * Note: we could cache the value and optimize the read if there was a way to
> + * get notified of user changes to command register through sysfs.
> + * */
> +static void irqtoggle(struct uio_pci_generic_dev *gdev, int irq_on)
> +{
> +	struct pci_dev *pdev = gdev->pdev;
> +	unsigned long flags;
> +	u16 orig, new;
> +
> +	spin_lock_irqsave(&gdev->lock, flags);
> +	pci_block_user_cfg_access(pdev);
> +	pci_read_config_word(pdev, PCI_COMMAND, &orig);
> +	new = irq_on ? (orig & ~PCI_COMMAND_INTX_DISABLE)
> +		     : (orig | PCI_COMMAND_INTX_DISABLE);
> +	if (new != orig)
> +		pci_write_config_word(gdev->pdev, PCI_COMMAND, new);
> +	pci_unblock_user_cfg_access(pdev);
> +	spin_unlock_irqrestore(&gdev->lock, flags);
> +}
> +
> +/* irqcontrol is use by userspace to enable/disable interrupts. */
> +/* A privileged app can write the PCI_COMMAND register directly,
> + * but we need this for normal apps
> + */
> +static int irqcontrol(struct uio_info *info, s32 irq_on)
> +{
> +	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
> +
> +	irqtoggle(gdev, irq_on);
> +	return 0;
> +}
> +
>  /* Interrupt handler. Read/modify/write the command register to disable
>   * the interrupt. */
>  static irqreturn_t irqhandler(int irq, struct uio_info *info)
> @@ -89,7 +123,7 @@ done:
>  /* Verify that the device supports Interrupt Disable bit in command register,
>   * per PCI 2.3, by flipping this bit and reading it back: this bit was readonly
>   * in PCI 2.2. */
> -static int __devinit verify_pci_2_3(struct pci_dev *pdev)
> +static int verify_pci_2_3(struct pci_dev *pdev)
>  {
>  	u16 orig, new;
>  	int err = 0;
> @@ -121,17 +155,52 @@ err:
>  	return err;
>  }
>  
> -static int __devinit probe(struct pci_dev *pdev,
> +/* we could've used the generic pci sysfs stuff for mmap,
> + * but this way we can allow non-privileged users as long
> + * as /dev/uio* has the right permissions
> + */
> +static void uio_do_maps(struct uio_pci_generic_dev *gdev)
> +{
> +	struct pci_dev *pdev = gdev->pdev;
> +	struct uio_info *info = &gdev->info;
> +	int i, j;
> +	char *name;
> +
> +	for (i = 0, j = 0; i < PCI_STD_RESOURCE_END && j < MAX_UIO_MAPS; i++) {
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
> +			name = kmalloc(8, GFP_KERNEL);
> +			if (name == NULL)
> +				break;
> +			sprintf(name, "membar%d", i);
> +			info->mem[j].name = name;
> +			info->mem[j].addr = pci_resource_start(pdev, i);
> +			info->mem[j].size = pci_resource_len(pdev, i);
> +			info->mem[j].memtype = UIO_MEM_PHYS;

resource could be < page size.
mmap from an unpriveledged process of an unaligned resouce
is unsafe as it allows access outside the region.

> +			j++;
> +		}
> +	}
> +	for (i = 0, j = 0; i < PCI_STD_RESOURCE_END &&
> +			   j < MAX_UIO_PORT_REGIONS; i++) {
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
> +			name = kmalloc(8, GFP_KERNEL);
> +			if (name == NULL)
> +				break;
> +			sprintf(name, "iobar%d", i);
> +			info->port[j].name = name;
> +			info->port[j].start = pci_resource_start(pdev, i);
> +			info->port[j].size = pci_resource_len(pdev, i);
> +			info->port[j].porttype = UIO_PORT_X86;
> +			j++;

At least on x86, I think io bar can not be mmapped.

> +		}
> +	}
> +}
> +
> +static int probe(struct pci_dev *pdev,
>  			   const struct pci_device_id *id)
>  {
>  	struct uio_pci_generic_dev *gdev;
>  	int err;
> -
> -	if (!pdev->irq) {
> -		dev_warn(&pdev->dev, "No IRQ assigned to device: "
> -			 "no support for interrupts?\n");
> -		return -ENODEV;
> -	}
> +	int msi = 0;
>  
>  	err = pci_enable_device(pdev);
>  	if (err) {
> @@ -140,9 +209,26 @@ static int __devinit probe(struct pci_de
>  		return err;
>  	}
>  
> -	err = verify_pci_2_3(pdev);
> -	if (err)
> -		goto err_verify;
> +	if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
> +		msi++;
> +		pci_disable_msi(pdev);
> +	}
> +	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
> +		msi++;
> +		pci_disable_msix(pdev);
> +	}
> +

I see code to disable msi but not to enable it here.
How does this work?

> +	if (!msi && !pdev->irq) {
> +		dev_warn(&pdev->dev, "No MSI, MSIX, or IRQ assigned to device: "
> +			 "no support for interrupts?\n");
> +		return -ENODEV;
> +	}
> +
> +	if (pdev->irq) {
> +		err = verify_pci_2_3(pdev);
> +		if (err)
> +			goto err_verify;
> +	}
>  
>  	gdev = kzalloc(sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
>  	if (!gdev) {
> @@ -152,10 +238,15 @@ static int __devinit probe(struct pci_de
>  
>  	gdev->info.name = "uio_pci_generic";
>  	gdev->info.version = DRIVER_VERSION;
> -	gdev->info.irq = pdev->irq;
> -	gdev->info.irq_flags = IRQF_SHARED;
> -	gdev->info.handler = irqhandler;
> +	if (pdev->irq) {
> +		gdev->info.irq = pdev->irq;
> +		gdev->info.irq_flags = IRQF_SHARED;
> +		gdev->info.handler = irqhandler;
> +		gdev->info.irqcontrol = irqcontrol;
> +	} else
> +		gdev->info.irq = -1;
>  	gdev->pdev = pdev;
> +	uio_do_maps(gdev);
>  	spin_lock_init(&gdev->lock);
>  
>  	if (uio_register_device(&pdev->dev, &gdev->info))
