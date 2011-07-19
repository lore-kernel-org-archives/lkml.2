Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1GSGHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:07:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53703 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1GSGHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:07:34 -0400
Message-ID: <4E251F1F.2080406@gmail.com>
Date: Tue, 19 Jul 2011 16:07:27 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ravishankar <ravishankarkm32@gmail.com>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/2 v3] Staging: comedi: fix printk() issue in adv_pci1710.c
References: <[PATCH]Staging: comedi: fix printk() issue in adv_pci1710.c> <1311054656-14207-1-git-send-email-ravishanakarkm32@gmail.com>
In-Reply-To: <1311054656-14207-1-git-send-email-ravishanakarkm32@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/11 15:50, Ravishankar wrote:
> From: Ravishankar<ravi.shankar@greenturtles.in>
>
> This is a patch to the adv_pci1710.c file that fixes up a printk() warning found by the checkpatch.pl tool
>
> Signed-off-by: Ravishankar<ravishankarkm32@gmail.com>
> ---
> KERN_CONT issue is fixed
>
>   drivers/staging/comedi/drivers/adv_pci1710.c |   20 ++++++++++----------
>   1 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
> index fd71cc6..093b9e6 100644
> --- a/drivers/staging/comedi/drivers/adv_pci1710.c
> +++ b/drivers/staging/comedi/drivers/adv_pci1710.c
> @@ -1396,14 +1396,14 @@ static int pci1710_attach(struct comedi_device *dev,
>   	int i;
>   	int board_index;
>
> -	printk("comedi%d: adv_pci1710: ", dev->minor);
> +	printk(KERN_INFO "comedi%d: adv_pci1710: ", dev->minor);
>
>   	opt_bus = it->options[0];
>   	opt_slot = it->options[1];
>
>   	ret = alloc_private(dev, sizeof(struct pci1710_private));
>   	if (ret<  0) {
> -		printk(" - Allocation failed!\n");
> +		printk(KERN_CONT "\n");
> +		printk(KERN_ERR "Comedi%d: adv_pci1710: Allocation failed\n",
> +		dev->minor);

This still isn't correct. The initial printk (KERN_INFO above) has no 
trailing newline. Here you are almost doing it correctly, except that 
you are adding an extra newline. This error message will look like this:

comedi0: adv_pci1710:
comedi0: adv_pci1710: Allocation failed

Which is just silly. The printk's below are broken in that you are using 
KERN_ERR where you should be using KERN_CONT.

As it stands the code is a little tricky to follow since the trailing 
newline gets added at the end unless there is an error when it gets 
added in place. It might be better just to print the full message, 
including the "comedi%d: adv_pci1710:" bit, at each printk call site and 
get rid of the whole KERN_CONT nonsense altogether. Alternatively you 
could create a comedi_printk function (or use pr_fmt) which wraps this up.

Also, do we really need to print out things like allocation failures? We 
have the errno value already and allocation failures for devices drivers 
aren't so common that we error messages for them?

~Ryan

>   		return -ENOMEM;
>   	}
>
> @@ -1451,10 +1451,10 @@ static int pci1710_attach(struct comedi_device *dev,
>
>   	if (!pcidev) {
>   		if (opt_bus || opt_slot) {
> -			printk(" - Card at b:s %d:%d %s\n",
> +			printk(KERN_ERR " - Card at b:s %d:%d %s\n",
>   			       opt_bus, opt_slot, errstr);
>   		} else {
> -			printk(" - Card %s\n", errstr);
> +			printk(KERN_ERR " - Card %s\n", errstr);
>   		}
>   		return -EIO;
>   	}
> @@ -1465,7 +1465,7 @@ static int pci1710_attach(struct comedi_device *dev,
>   	irq = pcidev->irq;
>   	iobase = pci_resource_start(pcidev, 2);
>
> -	printk(", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot, pci_func,
> +	printk(KERN_INFO ", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot,
> +	  pci_func, iobase);
>
>   	dev->iobase = iobase;
> @@ -1487,7 +1487,7 @@ static int pci1710_attach(struct comedi_device *dev,
>
>   	ret = alloc_subdevices(dev, n_subdevices);
>   	if (ret<  0) {
> -		printk(" - Allocation failed!\n");
> +		printk(KERN_CONT " - Allocation failed!\n");
>   		return ret;
>   	}
>
> @@ -1499,14 +1499,14 @@ static int pci1710_attach(struct comedi_device *dev,
>   					IRQF_SHARED, "Advantech PCI-1710",
>   					dev)) {
>   				printk
> -				    (", unable to allocate IRQ %d, DISABLING IT",
> +				    (KERN_INFO ", unable to allocate IRQ %d, DISABLING IT",
>   				     irq);
>   				irq = 0;	/* Can't use IRQ */
>   			} else {
> -				printk(", irq=%u", irq);
> +				printk(KERN_CONT ", irq=%u", irq);
>   			}
>   		} else {
> -			printk(", IRQ disabled");
> +			printk(KERN_CONT ", IRQ disabled");
>   		}
>   	} else {
>   		irq = 0;
> @@ -1514,7 +1514,7 @@ static int pci1710_attach(struct comedi_device *dev,
>
>   	dev->irq = irq;
>
> -	printk(".\n");
> +	printk(KERN_CONT ".\n");
>
>   	subdev = 0;
>

