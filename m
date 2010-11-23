Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0KWNVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:21:22 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:42360 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0KWNVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:21:21 -0500
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohavlCkce+Ub5QXMSOpHp3KJg5Kr1tMw==
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v1] ppc44x:PHY fixup for USB on canyonlands board
Date: Tue, 23 Nov 2010 14:21:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35.7-sr; KDE/4.5.3; i686; ; )
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, rsarmah@apm.com
References: <201011231256.oANCur3N016433@amcc.com>
In-Reply-To: <201011231256.oANCur3N016433@amcc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231421.02377.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rup,

On Tuesday 23 November 2010 13:56:53 Rupjyoti Sarmah wrote:
> This fix is a reset for USB PHY that requires some amount of time for power
> to be stable on Canyonlands.

Since this is version 2 of your patch, "[PATCH v2]" would have been a bit 
better in the subject line. Its also a good practice to summarize the changes 
between patch versions below the "---" line.

Please find a some further comments below.

<snip>
 
> --- a/arch/powerpc/platforms/44x/44x.h
> +++ b/arch/powerpc/platforms/44x/44x.h
> @@ -4,4 +4,9 @@
>  extern u8 as1_readb(volatile u8 __iomem  *addr);
>  extern void as1_writeb(u8 data, volatile u8 __iomem *addr);
> 
> +#define BCSR_USB_EN	0x11

This define is wrong here. Its not common for all 44x platforms but 
Canyonlands specific.

> +#define GPIO0_OSRH	0xC
> +#define GPIO0_TSRH	0x14
> +#define GPIO0_ISR1H	0x34
> +
>  #endif /* __POWERPC_PLATFORMS_44X_44X_H */
> diff --git a/arch/powerpc/platforms/44x/Makefile
> b/arch/powerpc/platforms/44x/Makefile index 82ff326..6854e73 100644
> --- a/arch/powerpc/platforms/44x/Makefile
> +++ b/arch/powerpc/platforms/44x/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_WARP)	+= warp.o
>  obj-$(CONFIG_XILINX_VIRTEX_5_FXT) += virtex.o
>  obj-$(CONFIG_XILINX_ML510) += virtex_ml510.o
>  obj-$(CONFIG_ISS4xx)	+= iss4xx.o
> +obj-$(CONFIG_CANYONLANDS)+= canyonlands.o
> diff --git a/arch/powerpc/platforms/44x/canyonlands.c
> b/arch/powerpc/platforms/44x/canyonlands.c new file mode 100644
> index 0000000..f13b62f
> --- /dev/null
> +++ b/arch/powerpc/platforms/44x/canyonlands.c
> @@ -0,0 +1,122 @@
> +/*
> + * This contain platform specific code for Canyonalnds board based on
                                              ^^^^^^^^^^^
                                              Canyonlands

> + * APM ppc44x series of processors.
> + *
> + * Copyright (c) 2010, Applied Micro Circuits Corporation
> + * Author: Rupjyoti Sarmah <rsarmah@apm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <asm/pci-bridge.h>
> +#include <asm/ppc4xx.h>
> +#include <asm/udbg.h>
> +#include <asm/uic.h>
> +#include <linux/of_platform.h>
> +#include "44x.h"
> +
> +static __initdata struct of_device_id ppc44x_of_bus[] = {
> +	{ .compatible = "ibm,plb4", },
> +	{ .compatible = "ibm,opb", },
> +	{ .compatible = "ibm,ebc", },
> +	{ .compatible = "simple-bus", },
> +	{},
> +};
> +
> +static int __init ppc44x_device_probe(void)
> +{
> +	of_platform_bus_probe(NULL, ppc44x_of_bus, NULL);
> +
> +	return 0;
> +}
> +machine_device_initcall(canyonlands, ppc44x_device_probe);
> +
> +/* Using this code only for the Canyonlands board.  */
> +
> +static int __init ppc44x_probe(void)
> +{
> +	unsigned long root = of_get_flat_dt_root();
> +		if (of_flat_dt_is_compatible(root, "amcc,canyonlands")) {
> +			ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +			return 1;
> +		}
> +	return 0;
> +}
> +
> +/* PHY fixup code on Canyonlands kit. */

PHY is a bit unspecific. One might think that this is an ethernet PHY (see 
remark below about better comments in the code)?

> +
> +static int __init ppc460ex_canyonlands_fixup(void)
> +{
> +	u8 __iomem *bcsr ;
> +	void __iomem  *vaddr;

Double space before *vaddr.

> +	struct device_node *np;
> +	u32 val ;
> +
> +	np = of_find_compatible_node(NULL, NULL, "apm,ppc460ex-bcsr");
> +	if (!np) {
> +		printk(KERN_ERR "failed did not find apm, ppc460ex bcsr 
node\n");
> +		return -ENODEV;
> +	}
> +
> +	bcsr = of_iomap(np, 0);
> +	of_node_put(np);
> +
> +	if (!bcsr) {
> +		printk(KERN_CRIT "Could not remap bcsr\n");
> +		return -ENODEV;
> +	}
> +
> +	np = of_find_compatible_node(NULL, NULL, "ibm,ppc4xx-gpio");
> +	vaddr = of_iomap(np, 0);
> +	if (!vaddr) {
> +		printk(KERN_CRIT "Could not get gpio node address\n");
> +		return -ENODEV;
> +	}
> +
> +	setbits8(&bcsr[7], BCSR_USB_EN);
> +	udelay(100000);
> +
> +	clrbits8(&bcsr[7], BCSR_USB_EN);
> +	udelay(100000);

Thats a total bootup delay of 200ms. Is this really needed?

> +
> +	/* configure gpio16 and gpio19 as alternate1 */
> +
> +	/* GPIO0_ISR1H for alternate 1 settings */
> +	val = in_be32(vaddr + GPIO0_ISR1H);
> +	out_be32((vaddr + GPIO0_ISR1H), val | 0x4200000);

setbits32 might be even simpler.

> +	/* GPIO0_OSRH for alternate 1 settings */
> +	val = in_be32(vaddr + GPIO0_OSRH);
> +	out_be32((vaddr + GPIO0_OSRH), val | 0x42000000);

Same here.

> +	/* GPIO0_TSRH for alternate 1 settings */
> +	val = in_be32(vaddr + GPIO0_TSRH);
> +	out_be32((vaddr + GPIO0_TSRH), val | 0x42000000);

And here.

And I suggest to add a few comments to the code explaining why exactly you are 
setting/clearing the bits in the BCSR and the GPIO registers.

Cheers,
Stefan
