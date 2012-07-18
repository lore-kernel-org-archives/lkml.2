Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2GRXsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 19:48:04 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49927 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab2GRXr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 19:47:57 -0400
Date: Thu, 19 Jul 2012 01:47:50 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Subject: Re: UIO: missing resource mapping
Message-ID: <20120718234750.GA2594@local>
References: <4FFE7C1F.7080702@gmx.net>
 <20120712194432.GA2592@local>
 <20120712231632.GC9317@redhat.com>
 <1342166955.6607.5.camel@blech>
 <20120713132223.GA10959@redhat.com>
 <1342190571.6607.36.camel@blech>
 <20120713181953.GA11527@redhat.com>
 <1342462572.17531.18.camel@blech>
 <20120716215823.GA7879@local>
 <1342608047.4194.0.camel@blech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1342608047.4194.0.camel@blech>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 12:40:47PM +0200, Dominic Eschweiler wrote:
> Am Montag, den 16.07.2012, 23:58 +0200 schrieb Hans J. Koch:
> > Try to hack up a patch to add generic BAR mapping to uio_pci_generic.c
> > and post it for review.
> > 
> 
> Here we go ...

Great! I'm a bit under time pressure with my current work ATM. A call to
open("/dev/hansjkoch", O_NONBLOCK) only returns -EBUSY. So it'll take me one or
two days to review it thoroughly. But at first sight, it is what I had in mind.

You'll hear from me soon, thanks for your work! Comments and reviews from
others are welcome...

Hans

> > 
> Signed-off-by: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
> diff --git a/drivers/uio/uio_pci_generic.c
> b/drivers/uio/uio_pci_generic.c
> index 0bd08ef..e25991e 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
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
> @@ -58,6 +60,7 @@ static int __devinit probe(struct pci_dev *pdev,
>  {
>  	struct uio_pci_generic_dev *gdev;
>  	int err;
> +	int i;
>  
>  	err = pci_enable_device(pdev);
>  	if (err) {
> @@ -67,8 +70,7 @@ static int __devinit probe(struct pci_dev *pdev,
>  	}
>  
>  	if (!pdev->irq) {
> -		dev_warn(&pdev->dev, "No IRQ assigned to device: "
> -			 "no support for interrupts?\n");
> +		dev_warn(&pdev->dev, "No IRQ assigned to device: no support for
> interrupts?\n");
>  		pci_disable_device(pdev);
>  		return -ENODEV;
>  	}
> @@ -91,10 +93,31 @@ static int __devinit probe(struct pci_dev *pdev,
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
> +		(pdev->resource[i].flags & IORESOURCE_MEM)) {
> +			gdev->info.mem[i].addr = pci_resource_start(pdev, i);
> +			gdev->info.mem[i].size = pci_resource_len(pdev, i);
> +			gdev->info.mem[i].internal_addr = NULL;
> +			gdev->info.mem[i].memtype = UIO_MEM_PHYS;
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
> @@ -107,17 +130,21 @@ err_verify:
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
> 
> 
