Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2FHNEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:04:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab2FHNED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:04:03 -0400
Date: Fri, 8 Jun 2012 16:03:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608130351.GB1964@redhat.com>
References: <1339156616.3870.9.camel@blech>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339156616.3870.9.camel@blech>
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

Why is this needed?
What's wrong with mapping resources through
 /sys/bus/pci/devices/XXXXXresourceX
?

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

uio currently only supports devices which do not
do DMA.

DMA from uio controlled devices is a no no unless
it's behind an IOMMU which can protect us from
random memory corruptions this could cause.

In the later case it's OK but we need some code
to check this and program the IOMMU appropriately.

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
> +
> +	if (pdev->resource[i].flags &&
> +	(pdev->resource[i].flags & IORESOURCE_MEM)) {
> +		gdev->info.mem[i].addr = pci_resource_start(pdev, i);
> +		gdev->info.mem[i].size = pci_resource_len(pdev, i);
> +		gdev->info.mem[i].internal_addr = NULL;
> +		gdev->info.mem[i].memtype = UIO_MEM_PHYS;
> +		}
> +	}
> +
>  	if (uio_register_device(&pdev->dev, &gdev->info))
>  		goto err_register;
>  	pci_set_drvdata(pdev, gdev);
>  
> +	pr_info("UIO_PCI_GENERIC : initialized new device (%x %x)\n",
> +	pdev->vendor, pdev->device);
> +
>  	return 0;
>  err_register:
>  	kfree(gdev);
> @@ -107,17 +164,21 @@
>  static void remove(struct pci_dev *pdev)
>  {
>  	struct uio_pci_generic_dev *gdev = pci_get_drvdata(pdev);
> -
>  	uio_unregister_device(&gdev->info);
> +
> +	pci_release_regions(pdev);
>  	pci_disable_device(pdev);
>  	kfree(gdev);
> +
> +	pr_info("UIO_PCI_GENERIC : removed device (%x %x)\n",
> +	pdev->vendor, pdev->device);
>  }
>  
>  static struct pci_driver driver = {
> -	.name = "uio_pci_generic",
> +	.name     = DRV_NAME,
>  	.id_table = NULL, /* only dynamic id's */
> -	.probe = probe,
> -	.remove = remove,
> +	.probe    = probe,
> +	.remove   = remove,
>  };
>  
>  static int __init init(void)
> 
> 
> -- 
> Gruß
>   Dominic
> 
> Frankfurt Institute for Advanced Studies (FIAS)
> Ruth-Moufang-Straße 1
> D-60438 Frankfurt am Main
> Germany
> 
> Phone:  +49 69 79844114

