Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783Ab2FHQIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:08:09 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49354 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab2FHQIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:08:07 -0400
Date: Fri, 8 Jun 2012 18:07:55 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608160754.GC9705@local>
References: <1339156616.3870.9.camel@blech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339156616.3870.9.camel@blech>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 01:56:56PM +0200, Dominic Eschweiler wrote:
> Hello,
> 
> the current version of the uio_pci_generic module does not export memory
> resources, such as BARs. As far as I can see, the related module does
> only support interrupts, which is not really useful. My suggestion in
> this case would be to either fix this issue, or to completely remove it.
> The latter would not be an option for us, since we need this
> functionality at some stuff at CERN.
> 
> Therefore, here is a patch that fixes the issue. Please give me further
> advice, since I'm doing this the first time ...
> 
> 
> 
> Signed-off-by: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
> ---
> diff -uNr linux-3.4_old/drivers/uio/uio_pci_generic.c
> linux-3.4_new/drivers/uio/uio_pci_generic.c
> --- linux-3.4_old/drivers/uio/uio_pci_generic.c	2012-05-21
> 00:29:13.000000000 +0200
> +++ linux-3.4_new/drivers/uio/uio_pci_generic.c	2012-06-08
> 13:01:12.000000000 +0200
> @@ -25,10 +25,12 @@
>  #include <linux/slab.h>
>  #include <linux/uio_driver.h>
>  
> -#define DRIVER_VERSION	"0.01.0"
> +#define DRIVER_VERSION	"0.02.0"
>  #define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
>  #define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
>  
> +#define DRV_NAME "uio_pci_generic"
> +
>  struct uio_pci_generic_dev {
>  	struct uio_info info;
>  	struct pci_dev *pdev;
> @@ -58,6 +60,7 @@
>  {
>  	struct uio_pci_generic_dev *gdev;
>  	int err;
> +	int i;
>  
>  	err = pci_enable_device(pdev);
>  	if (err) {
> @@ -66,9 +69,33 @@
>  		return err;
>  	}
>  
> +    /* set master */
> +	pci_set_master(pdev);
> +
> +    /* set DMA mask */
> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +	if (err) {
> +		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
> +		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (err) {
> +			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
> +			return -ENODEV;
> +		}
> +	}
> +
> +	/* set consistent DMA mask */
> +	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> +	if (err) {
> +		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit consistent PCI DMA
> mask.\n");
> +		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (err) {
> +			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, aborting
> \n");
> +			return -ENODEV;
> +		}
> +	}
> +

All this DMA stuff doesn't fit into a "uio_pci_generic" driver. There might
be users who need other kinds of DMA handling.

If you need this, please make it a new driver and name it after your device.

>  	if (!pdev->irq) {
> -		dev_warn(&pdev->dev, "No IRQ assigned to device: "
> -			 "no support for interrupts?\n");
> +		dev_warn(&pdev->dev, "No IRQ assigned to device: no support for
> interrupts?\n");
>  		pci_disable_device(pdev);
>  		return -ENODEV;
>  	}
> @@ -91,10 +118,40 @@
>  	gdev->info.handler = irqhandler;
>  	gdev->pdev = pdev;
>  
> +	/* request regions */
> +	err = pci_request_regions(pdev, DRV_NAME);
> +	if (err) {
> +		dev_err(&pdev->dev, "Couldn't get PCI resources, aborting\n");
> +		return err;
> +	}
> +
> +	/* create attributes for BAR mappings */
> +	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> +		if (pdev->resource[i].flags &&
> +		(pdev->resource[i].flags & IORESOURCE_IO)) {
> +			gdev->info.port[i].size = 0;
> +			gdev->info.port[i].porttype = UIO_PORT_OTHER;
> +			#ifdef CONFIG_X86
> +			gdev->info.port[i].porttype = UIO_PORT_X86;
> +			#endif
> +		}

Do you really have x86 ports on your PCI card?

> +
> +	if (pdev->resource[i].flags &&
> +	(pdev->resource[i].flags & IORESOURCE_MEM)) {
> +		gdev->info.mem[i].addr = pci_resource_start(pdev, i);
> +		gdev->info.mem[i].size = pci_resource_len(pdev, i);
> +		gdev->info.mem[i].internal_addr = NULL;
> +		gdev->info.mem[i].memtype = UIO_MEM_PHYS;
> +		}
> +	}

As Michael said, why don't you just use the existing PCI sysfs files?

I don't really object to your approach, but I'd like to hear a reason
why you can't live with the existing possibilities.

Thanks,
Hans

