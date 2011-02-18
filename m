Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab1BRQbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:31:53 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:47491 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab1BRQbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:31:52 -0500
Date: Fri, 18 Feb 2011 17:31:47 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com, hjk@hansjkoch.de,
        gregkh@suse.de, amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
Message-ID: <20110218163147.GD4684@local>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <1298041530-26855-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298041530-26855-2-git-send-email-pratheesh@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 08:35:29PM +0530, Pratheesh Gangadhar wrote:
> Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> 
> This patch implements PRUSS (Programmable Real-time Unit Sub System)
> UIO driver which exports SOC resources associated with PRUSS like
> I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
> processors which is efficient in performing embedded tasks that
> require manipulation of packed memory mapped data structures and
> efficient in handling system events that have tight real time
> constraints. This driver is currently supported on Texas Instruments
> DA850, AM18xx and OMAPL1-38 devices.
> For example, PRUSS runs firmware for real-time critical industrial
> communication data link layer and communicates with application stack
> running in user space via shared memory and IRQs.

I see a few issues, comments below.

Thanks,
Hans

> ---
>  drivers/uio/Kconfig     |   10 ++
>  drivers/uio/Makefile    |    1 +
>  drivers/uio/uio_pruss.c |  250 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 261 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_pruss.c
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index bb44079..631ffe3 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -94,4 +94,14 @@ config UIO_NETX
>  	  To compile this driver as a module, choose M here; the module
>  	  will be called uio_netx.
>  
> +config UIO_PRUSS
> +	tristate "Texas Instruments PRUSS driver"
> +	depends on ARCH_DAVINCI_DA850
> +	default n

That line is unneccessary, "n" is already the default.

> +	help
> +	  PRUSS driver for OMAPL138/DA850/AM18XX devices
> +	  PRUSS driver requires user space components
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called uio_pruss.
> +
>  endif
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> index 18fd818..d4dd9a5 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
>  obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
>  obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
>  obj-$(CONFIG_UIO_NETX)	+= uio_netx.o
> +obj-$(CONFIG_UIO_PRUSS)         += uio_pruss.o
> diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
> new file mode 100644
> index 0000000..5ae78a5
> --- /dev/null
> +++ b/drivers/uio/uio_pruss.c
> @@ -0,0 +1,250 @@
> +/*
> + * Programmable Real-Time Unit Sub System (PRUSS) UIO driver (uio_pruss)
> + *
> + * This driver exports PRUSS host event out interrupts and PRUSS, L3 RAM,
> + * and DDR RAM to user space for applications interacting with PRUSS firmware 
> + *
> + * Copyright (C) 2010-11 Texas Instruments Incorporated - http://www.ti.com/
> + * 
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as 
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/uio_driver.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +
> +#define DRV_NAME "pruss"
> +#define DRV_VERSION "0.50"
> +
> +/*
> + * Host event IRQ numbers from PRUSS 	
> + * 3 PRU_EVTOUT0 PRUSS Interrupt
> + * 4 PRU_EVTOUT1 PRUSS Interrupt
> + * 5 PRU_EVTOUT2 PRUSS Interrupt
> + * 6 PRU_EVTOUT3 PRUSS Interrupt
> + * 7 PRU_EVTOUT4 PRUSS Interrupt
> + * 8 PRU_EVTOUT5 PRUSS Interrupt
> + * 9 PRU_EVTOUT6 PRUSS Interrupt
> + * 10 PRU_EVTOUT7 PRUSS Interrupt
> +*/
> +
> +#define MAX_PRUSS_EVTOUT_INSTANCE	(8)

The brackets are not needed.

> +
> +static struct clk *pruss_clk;
> +static struct uio_info *info[MAX_PRUSS_EVTOUT_INSTANCE];

is it really neccessary to allocate that statically?

> +static void *ddr_virt_addr;
> +static dma_addr_t ddr_phy_addr;
> +
> +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> +{
> +	return IRQ_HANDLED;
> +}

ROTFL. That reminds me of an old story. The last time I wrote this, and
Greg dared to post it, we received this reply:

http://marc.info/?l=linux-kernel&m=116604101232144&w=2

So, if you really have a _very_ good reason why this _always_ works on
_any_ DA850 board, add a comment that explains why. Otherwise the whole
patch set will be doomed.

> +
> +static int __devinit pruss_probe(struct platform_device *dev)
> +{
> +	int ret = -ENODEV;
> +	int count = 0;
> +	struct resource *regs_pruram, *regs_l3ram, *regs_ddr;
> +	char *string;
> +
> +	/* Power on PRU in case its not done as part of boot-loader */
> +	pruss_clk = clk_get(&dev->dev, "pruss");
> +	if (IS_ERR(pruss_clk)) {
> +		dev_err(&dev->dev, "Failed to get clock\n");
> +		ret = PTR_ERR(pruss_clk);
> +		pruss_clk = NULL;
> +		return ret;
> +	} else {
> +		clk_enable(pruss_clk);
> +	}
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> +		info[count] = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
> +		if (!info[count])
> +			return -ENOMEM;
> +	}
> +
> +	regs_pruram = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (!regs_pruram) {
> +		dev_err(&dev->dev, "No memory resource specified\n");
> +		goto out_free;
> +	}
> +
> +	regs_l3ram = platform_get_resource(dev, IORESOURCE_MEM, 1);
> +	if (!regs_l3ram) {
> +		dev_err(&dev->dev, "No memory resource specified\n");
> +		goto out_free;
> +	}
> +
> +	regs_ddr = platform_get_resource(dev, IORESOURCE_MEM, 2);
> +	if (!regs_ddr) {
> +		dev_err(&dev->dev, "No memory resource specified\n");
> +		goto out_free;
> +	}
> +	ddr_virt_addr =
> +	    dma_alloc_coherent(&dev->dev, regs_ddr->end - regs_ddr->start + 1,
> +			       &ddr_phy_addr, GFP_KERNEL | GFP_DMA);
> +	if (!ddr_virt_addr) {
> +		dev_err(&dev->dev, "Could not allocate external memory\n");
> +		goto out_free;
> +	}
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> +		info[count]->mem[0].addr = regs_pruram->start;
> +		info[count]->mem[0].size =
> +		    regs_pruram->end - regs_pruram->start + 1;
> +		if (!info[count]->mem[0].addr
> +		    || !(info[count]->mem[0].size - 1)) {

That size check looks fishy. If somebody forgot to set the size it's OK ?

> +			dev_err(&dev->dev, "Invalid memory resource\n");
> +			break;
> +		}
> +		info[count]->mem[0].internal_addr =
> +		    ioremap(regs_pruram->start, info[count]->mem[0].size);
> +		if (!info[count]->mem[0].internal_addr) {
> +			dev_err(&dev->dev,
> +				"Can't remap memory address range\n");
> +			break;
> +		}
> +		info[count]->mem[0].memtype = UIO_MEM_PHYS;
> +
> +		info[count]->mem[1].addr = regs_l3ram->start;
> +		info[count]->mem[1].size =
> +		    regs_l3ram->end - regs_l3ram->start + 1;
> +		if (!info[count]->mem[1].addr
> +		    || !(info[count]->mem[1].size - 1)) {
> +			dev_err(&dev->dev, "Invalid memory resource\n");
> +			break;
> +		}
> +		info[count]->mem[1].internal_addr =
> +		    ioremap(regs_l3ram->start, info[count]->mem[1].size);
> +		if (!info[count]->mem[1].internal_addr) {
> +			dev_err(&dev->dev,
> +				"Can't remap memory address range\n");
> +			break;
> +		}
> +		info[count]->mem[1].memtype = UIO_MEM_PHYS;
> +
> +		info[count]->mem[2].addr = ddr_phy_addr;
> +		info[count]->mem[2].size = regs_ddr->end - regs_ddr->start + 1;
> +		if (!info[count]->mem[2].addr
> +		    || !(info[count]->mem[2].size - 1)) {
> +			dev_err(&dev->dev, "Invalid memory resource\n");
> +			break;
> +		}
> +		info[count]->mem[2].internal_addr = ddr_virt_addr;
> +		if (!info[count]->mem[2].internal_addr) {
> +			dev_err(&dev->dev,
> +				"Can't remap memory address range\n");
> +			break;
> +		}
> +		info[count]->mem[2].memtype = UIO_MEM_PHYS;
> +
> +		string = kzalloc(20, GFP_KERNEL);
> +		sprintf(string, "pruss_evt%d", count);
> +		info[count]->name = string;
> +		info[count]->version = "0.50";
> +
> +		/* Register PRUSS IRQ lines */
> +		info[count]->irq = IRQ_DA8XX_EVTOUT0 + count;
> +
> +		info[count]->irq_flags = IRQF_SHARED;

How do you handle shared interrupts with the handler above?

> +		info[count]->handler = pruss_handler;

And how do you make sure your interrupts are not level triggered? The
handler above will hang for level triggered interrupts.

> +
> +		ret = uio_register_device(&dev->dev, info[count]);
> +
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	if (ret < 0) {
> +		if (ddr_virt_addr)
> +			dma_free_coherent(&dev->dev,
> +					  regs_ddr->end - regs_ddr->start + 1,
> +					  ddr_virt_addr, ddr_phy_addr);
> +		while (count--) {
> +			uio_unregister_device(info[count]);
> +			kfree(info[count]->name);
> +			iounmap(info[count]->mem[0].internal_addr);
> +		}
> +	} else {
> +		platform_set_drvdata(dev, info);
> +		return 0;
> +	}
> +
> +out_free:
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++)
> +		kfree(info[count]);
> +
> +	if (pruss_clk != NULL)
> +		clk_put(pruss_clk);
> +
> +	return ret;
> +}
> +
> +static int __devexit pruss_remove(struct platform_device *dev)
> +{
> +	int count = 0;
> +	struct uio_info **info;
> +
> +	info = (struct uio_info **)platform_get_drvdata(dev);
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> +		uio_unregister_device(info[count]);
> +		kfree(info[count]->name);
> +
> +	}
> +	iounmap(info[0]->mem[0].internal_addr);
> +	iounmap(info[0]->mem[1].internal_addr);
> +	if (ddr_virt_addr)
> +		dma_free_coherent(&dev->dev, info[0]->mem[2].size,
> +				  info[0]->mem[2].internal_addr,
> +				  info[0]->mem[2].addr);
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++)
> +		kfree(info[count]);
> +
> +	platform_set_drvdata(dev, NULL);
> +
> +	if (pruss_clk != NULL)
> +		clk_put(pruss_clk);
> +	return 0;
> +}
> +
> +static struct platform_driver pruss_driver = {
> +	.probe = pruss_probe,
> +	.remove = __devexit_p(pruss_remove),
> +	.driver = {
> +		   .name = DRV_NAME,
> +		   .owner = THIS_MODULE,
> +		   },
> +};
> +
> +static int __init pruss_init_module(void)
> +{
> +	return platform_driver_register(&pruss_driver);
> +}
> +
> +module_init(pruss_init_module);
> +
> +static void __exit pruss_exit_module(void)
> +{
> +	platform_driver_unregister(&pruss_driver);
> +}
> +
> +module_exit(pruss_exit_module);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_AUTHOR("Amit Chatterjee <amit.chatterjee@ti.com>");
> +MODULE_AUTHOR("Pratheesh Gangadhar <pratheesh@ti.com>");
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
