Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1G0Mf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:35:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23135 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1G0Mfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:35:55 -0400
Date: Wed, 27 Jul 2011 14:35:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ravishankar <ravishankarkm32@gmail.com>
cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH v2] Staging: comedi: fix printk issue in adv_pci_dio.c
In-Reply-To: <1311766859-6217-1-git-send-email-ravishankarkm32@gmail.com>
Message-ID: <alpine.LNX.2.00.1107271359150.16245@swampdragon.chaosbits.net>
References: <[PATCH]Staging: Comedi: fix printk issue in adv_pci_dio.c> <1311766859-6217-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Ravishankar wrote:

> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the adv_pci_dio.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/adv_pci_dio.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
> index d23799b..1d2261f 100644
> --- a/drivers/staging/comedi/drivers/adv_pci_dio.c
> +++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
> @@ -1106,11 +1106,11 @@ static int pci_dio_attach(struct comedi_device *dev,
>  	unsigned long iobase;
>  	struct pci_dev *pcidev = NULL;
>  
> -	printk("comedi%d: adv_pci_dio: ", dev->minor);
> +	printk(KERN_INFO "comedi%d: adv_pci_dio: ", dev->minor);
>  

This printk() is used both for printing out information in the case of 
success, in which case the KERN_INFO level is fine. But it is also used to 
print out error messages in case of failure, in which case KERN_WARNING 
would probably be better. So I'm wondering if it wouldn't be better to 
restructure the code so that the printing of error messages and success 
info becomes two seperate printk()'s each with the apropriate level.


>  	ret = alloc_private(dev, sizeof(struct pci_dio_private));
>  	if (ret < 0) {
> -		printk(", Error: Cann't allocate private memory!\n");
> +		printk(KERN_CONT ", Error: Cann't allocate private memory!\n");

Might as well fix the spelling error ( s/Cann't/Can't/ ) while you are 
changing the line anyway.


>  		return -ENOMEM;
>  	}
>  
> @@ -1140,19 +1140,19 @@ static int pci_dio_attach(struct comedi_device *dev,
>  	}
>  
>  	if (!dev->board_ptr) {
> -		printk(", Error: Requested type of the card was not found!\n");
> +		printk(KERN_WARNING ", Error: Requested type of the card was not "
> +		"found!\n");

As Joe Perches already pointed out to you, this is a continuation of the 
first printk() and should be using KERN_CONT.


>  		return -EIO;
>  	}
>  
>  	if (comedi_pci_enable(pcidev, driver_pci_dio.driver_name)) {
>  		printk
> -		    (", Error: Can't enable PCI device and request regions!\n");
> +		(KERN_WARNING ", Error: Can't enable PCI device and request "
> +		"regions!\n");

This one as well. And it has got to be possible to find a less hideous way 
to break that line..

what about:

  printk(KERN_CONT
         ", Error: Can't enable PCI device and request regions!\n");

? If it even needs to be broken at all (the 80 column rule is not fixed in 
stone).


>  		return -EIO;
>  	}
>  	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
> -	printk(", b:s:f=%d:%d:%d, io=0x%4lx",
> -	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
> -	       PCI_FUNC(pcidev->devfn), iobase);
> +	printk(KERN_CONT ", b:s:f=%d:%d:%d, io=0x%4lx",
> +	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
> +	       PCI_FUNC(pcidev->devfn), iobase);
> 
>  	dev->iobase = iobase;
>  	dev->board_name = this_board->name;
> @@ -1178,11 +1178,11 @@ static int pci_dio_attach(struct comedi_device *dev,
>  
>  	ret = alloc_subdevices(dev, n_subdevices);
>  	if (ret < 0) {
> -		printk(", Error: Cann't allocate subdevice memory!\n");
> +		printk(KERN_CONT ", Error: Cann't allocate subdevice memory!\n");
>  		return ret;
>  	}
>  
> -	printk(".\n");
> +	printk(KERN_CONT ".\n");
>  
>  	subdev = 0;
>  
 
Please take the feedback people give you serious. Joe kindly pointed out 
your mistakes the last time you posted this and yet your next patch has 
the exact same mistakes.

Read through your patches before you send them and double check each and 
every change - then check it again.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

