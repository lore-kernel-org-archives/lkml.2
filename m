Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1KORan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 12:30:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37156 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab1KORal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 12:30:41 -0500
Date: Tue, 15 Nov 2011 17:30:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: NUC900: Add PCI driver support for NUC960
Message-ID: <20111115173023.GC9581@n2100.arm.linux.org.uk>
References: <4EBE98FC.6070903@gmail.com> <4EC0BF9B.2050300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC0BF9B.2050300@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 03:13:31PM +0800, Wan ZongShun wrote:
> +#define NUC900_PCI_MEM_BASE	0xC0000000
> +#define NUC900_PCI_MEM_END	0xDFFFEFFFF
> +#define NUC900_PCI_MEM_SIZE	0x20000000

NUC900_PCI_MEM_END has more than 32 bits.

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
> +	ret = request_resource(&ioport_resource, &pci_io);
> +	if (ret) {
> +		pr_err("%s: failed to request resources: %d\n", __func__, ret);
> +		goto out;
> +	}
...
> +	/*
> +	 * bus->resource[0] is the IO resource for this bus
> +	 * bus->resource[1] is the mem resource for this bus
> +	 * bus->resource[2] is the prefetch mem resource for this bus
> +	 */
> +	resource[0] = &pci_io;
> +	resource[1] = &pci_mem;
> +	resource[2] = NULL;

This is better, but still not correct.

1. in mach/io.h:

-#define IO_SPACE_LIMIT	0xffffffff
+#define IO_SPACE_LIMIT	0xffff

-#define __io(a)	__typesafe_io(a)
+#define __io(a)	((void __iomem __force *)(a) + VA_OF_IO_SPACE)

where VA_OF_IO_SPACE is correctly named and typed.

2. set resource[0] = &ioport_resource and get rid of pci_io entirely.

3. if (!request_mem_region(PA_OF_IO_SPACE, 64K, "PCI IO emulation space"))
	pr_warn("Unable to request PCI IO space\n");
   in your pre-init function.
