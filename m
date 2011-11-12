Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1KLXOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 18:14:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57820 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1KLXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 18:14:20 -0500
Date: Sat, 12 Nov 2011 23:14:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: NUC900: Add PCI driver support for NUC960
Message-ID: <20111112231408.GC27746@n2100.arm.linux.org.uk>
References: <4EBE98FC.6070903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBE98FC.6070903@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 12:04:12AM +0800, Wan ZongShun wrote:
> +#define NUC900_PCI_IO_BASE	0xE0000000
> +#define NUC900_PCI_IO_END	0xE000FFFF
> +#define NUC900_PCI_IO_SIZE	0x10000
...
> +static struct resource pci_io = {
> +	.name	= "NUC900 PCI IO",
> +	.start	= NUC900_PCI_IO_BASE,
> +	.end	= NUC900_PCI_IO_BASE + NUC900_PCI_IO_SIZE - 1,
> +	.flags	= IORESOURCE_IO,
> +};
...
> +static int __init pci_nuc900_setup_resources(struct resource **resource)
> +{
> +	int ret = 0;
> +
> +	ret = request_resource(&iomem_resource, &pci_io);
> +	if (ret) {
> +		printk(KERN_ERR "PCI: unable to allocate I/O "
> +		       "memory region (%d)\n", ret);
> +		goto out;
> +	}

You must not cross-register IO resources into MMIO resources.  The
resource manager doesn't work like that.  If you have an IO space which
is part of the MMIO space (which is true on all ARMs) then you should
register a MMIO resource reserving (iow, with IORESOURCE_BUSY, or
using request_mem_region()) to ensure that the region is properly
reserved in the MMIO space.

The IO resource stands entirely separately and is part of the
&ioport_resource tree.

> +	ret = request_resource(&iomem_resource, &pci_mem);
> +	if (ret) {
> +		printk(KERN_ERR "PCI: unable to allocate non-prefetchable "
> +		       "memory region (%d)\n", ret);
> +		goto release_io_mem;
> +	}
> +
> +	/*
> +	 * bus->resource[0] is the IO resource for this bus
> +	 * bus->resource[1] is the mem resource for this bus
> +	 * bus->resource[2] is the prefetch mem resource for this bus
> +	 */
> +	resource[0] = &pci_io;

This seems wrong.  IO space generally is 16-bit, not 32-bit, and
resource 0 is expected to be registered against the ioport_resource
or be the ioport_resource itself if it covers all 16-bit.

Moreover, if you have an IO space which is part of the MMIO space, it
is expected that your __io macro in mach/io.h appropriately translates
an inb(0) access to the start of your IO space emulation.

> +	resource[1] = &pci_mem;
> +	resource[2] = NULL;
> +
> +	goto out;
> +
> + release_io_mem:
> +	release_resource(&pci_io);
> + out:
> +	return ret;
> +}

Missing blank line.

> +int __init pci_nuc900_setup(int nr, struct pci_sys_data *sys)
> +{
> +	int ret = 0;
> +
> +	if (nr == 0) {
> +		sys->mem_offset = 0;
> +		sys->io_offset = 0;
> +		ret = pci_nuc900_setup_resources(sys->resource);
> +		if (ret) {
> +			printk(KERN_ERR "pci_versatile_setup:\
> +							resources... oops?\n");

Don't continue strings with '\'.  Plus this isn't versatile.  Also try
printing the error code, which can aid debugging.

Try this instead:
			pr_err("%s: failed to setup resources: %d\n",
			       __func__, ret);

> +			goto out;
> +		}
> +	} else {
> +		printk(KERN_ERR "pci_versatile_setup:\
> +						resources... nr == 0??\n");
> +		goto out;
> +	}
> +	ret = 1;
> +out:
> +	return ret;
> +}
> +
> +struct pci_bus *pci_nuc900_scan_bus(int nr, struct pci_sys_data *sys)
> +{
> +	return pci_scan_bus(sys->busnr, &pci_nuc900_ops, sys);
> +}
> +
> +void __init pci_nuc900_preinit(void)
> +{
> +	/* CK33 from PLL0 */
> +	__raw_writel(__raw_readl(REG_CLKSEL) & ~EXTAL15M, REG_CLKSEL);
> +	/* PCI CLOCK = 200/6 = 33Mhz */
> +	 __raw_writel(((__raw_readl(REG_CLKDIV) &
> +				(~(0xf<<4))) | CK33DIV5), REG_CLKDIV);
> +
> +	/* enable PCI clock */
> +	__raw_writel(__raw_readl(REG_CLKEN) | 0x4, REG_CLKEN);
> +
> +	__raw_writel(RESET_VAL1, REG_PCICTR);
> +
> +	mdelay(100);
> +
> +	__raw_writel(RESET_VAL2, REG_PCICTR);
> +
> +	mdelay(200);
> +}
> +
> +static inline int bridge_swizzle(int pin, unsigned int slot)
> +{
> +	return (pin + slot) & 3;
> +}
> +
> +/*
> + * This routine handles multiple bridges.
> + */
> +static u8 __init nuc900_swizzle(struct pci_dev *dev, u8 *pinp)
> +{
> +	int pin = *pinp;
> +
> +	if (pin == 0)
> +		pin = 1;

pin should never be zero - are you seeing such cases?

> +
> +	pin -= 1;
> +	while (dev->bus->self) {
> +		pin = bridge_swizzle(pin, PCI_SLOT(dev->devfn));
> +		/*
> +		 * move up the chain of bridges, swizzling as we go.
> +		 */
> +		dev = dev->bus->self;
> +	}
> +	*pinp = pin + 1;
> +
> +	return PCI_SLOT(dev->devfn);
> +}

Is there a reason the standard swizzle (pci_common_swizzle) doesn't work
for you?
