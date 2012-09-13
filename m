Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2IMIBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:01:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20936 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2IMIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:01:09 -0400
Date: Thu, 13 Sep 2012 11:00:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bruce Humphrey <brucehum@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: Comedi: dyna_pci10xx: Replace printk with
 dev_info
Message-ID: <20120913080041.GI19396@mwanda>
References: <1347500760-4394-1-git-send-email-brucehum@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347500760-4394-1-git-send-email-brucehum@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 03:46:00AM +0200, Bruce Humphrey wrote:
> Replace printk(KERN_XXX with dev_info, dev_warn, dev_dbg as appropiate in dyna_pci10xx
> 
> Signed-off-by: Bruce Humphrey Ventura <brucehum@gmail.com>
> ---
>  drivers/staging/comedi/drivers/dyna_pci10xx.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
> index 064be9a..bfa62d1 100644
> --- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
> +++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
> @@ -140,8 +140,7 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
>  				goto conv_finish;
>  		}
>  		data[n] = 0;
> -		printk(KERN_DEBUG "comedi: dyna_pci10xx: "
> -			"timeout reading analog input\n");
> +		dev_dbg(dev->class_dev, "timeout reading analog input\n");

The trick with removing the "comedi: dyna_pci10xx: " prefix is that
you need to put this at the top of the file before the includes.

#define pr_fmt(fmt) "comedi: dyna_pci10xx: " fmt

You would need to remove the prefix from the other pr_info printk
as well so it's not included twice.

>  		continue;
>  conv_finish:
>  		/* mask the first 4 bits - EOC bits */
> @@ -262,8 +261,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
>  	int ret;
>  
>  	if (alloc_private(dev, sizeof(struct dyna_pci10xx_private)) < 0) {
> -		printk(KERN_ERR "comedi: dyna_pci10xx: "
> -			"failed to allocate memory!\n");
> +		dev_err(dev->class_dev, "failed to allocate memory!\n");

No need.  Kmalloc has it's own printk().

>  		return -ENOMEM;
>  	}
>  
> @@ -276,14 +274,14 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
>  	dev->irq = 0;
>  
>  	if (comedi_pci_enable(pcidev, DRV_NAME)) {
> -		printk(KERN_ERR "comedi: dyna_pci10xx: "
> -			"failed to enable PCI device and request regions!");
> +		dev_err(dev->class_dev,
> +			"failed to enable PCI device and request regions!\n");
>  		return -EIO;
>  	}
>  
>  	mutex_init(&devpriv->mutex);
>  
> -	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
> +	pr_info("comedi: dyna_pci10xx: device found!\n");

No need.

>  
>  	dev->iobase = pci_resource_start(pcidev, 2);
>  	devpriv->BADR3 = pci_resource_start(pcidev, 3);
> @@ -333,7 +331,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
>  	s->state = 0;
>  	s->insn_bits = dyna_pci10xx_do_insn_bits;
>  
> -	printk(KERN_INFO "comedi: dyna_pci10xx: %s - device setup completed!\n",
> +	dev_info(dev->class_dev, "%s - device setup completed!\n",
>  		thisboard->name);

No need for this either.

regards,
dan carpenter

>  
>  	return 1;
> -- 
> 1.7.9.5
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
