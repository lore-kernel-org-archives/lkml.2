Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2JEJIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:08:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38944 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab2JEJIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:08:21 -0400
Message-ID: <506EA37E.6090208@mev.co.uk>
Date: Fri, 5 Oct 2012 10:08:14 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Use dev_ printks in drivers/me_daq.c
References: <1349395648-5976-1-git-send-email-yamanetoshi@gmail.com>
In-Reply-To: <1349395648-5976-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-05 01:07, YAMANE Toshiaki wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> - WARNING: quoted string split across lines
>
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>   drivers/staging/comedi/drivers/me_daq.c |   26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
> index 2ce0b14..0d85729 100644
> --- a/drivers/staging/comedi/drivers/me_daq.c
> +++ b/drivers/staging/comedi/drivers/me_daq.c
> @@ -384,8 +384,8 @@ static int me_ai_insn_read(struct comedi_device *dev,
>   		    (readw(dev_private->me_regbase +
>   			   ME_READ_AD_FIFO) ^ 0x800) & 0x0FFF;
>   	} else {
> -		printk(KERN_ERR "comedi%d: Cannot get single value\n",
> -		       dev->minor);
> +		dev_err(dev->class_dev, "comedi%d: Cannot get single value\n",
> +			dev->minor);

There is no need for the "comedi%d: " prefix as dev_??? already puts the 
device name in the message.  Just use:

		dev_err(dev->class_dev, "Cannot get single value\n");

>   		return -EIO;
>   	}
>
> @@ -566,8 +566,8 @@ static int me2600_xilinx_download(struct comedi_device *dev,
>   	if (value & 0x20) {
>   		/* Disable interrupt */
>   		writel(0x00, dev_private->plx_regbase + PLX_INTCSR);
> -		printk(KERN_ERR "comedi%d: Xilinx download failed\n",
> -		       dev->minor);
> +		dev_err(dev->class_dev, "comedi%d: Xilinx download failed\n",
> +			dev->minor);
>   		return -EIO;
>   	}
>
> @@ -654,8 +654,9 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
>
>   	/* Enable PCI device and request PCI regions */
>   	if (comedi_pci_enable(pcidev, dev->board_name) < 0) {
> -		printk(KERN_ERR "comedi%d: Failed to enable PCI device and "
> -		       "request regions\n", dev->minor);
> +		dev_err(dev->class_dev,
> +			"comedi%d: Failed to enable PCI device and request regions\n",
> +			dev->minor);
>   		return -EIO;
>   	}
>
> @@ -666,7 +667,8 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
>   	    ioremap(plx_regbase_tmp, plx_regbase_size_tmp);
>   	dev_private->plx_regbase_size = plx_regbase_size_tmp;
>   	if (!dev_private->plx_regbase) {
> -		printk("comedi%d: Failed to remap I/O memory\n", dev->minor);
> +		dev_err(dev->class_dev,
> +			"comedi%d: Failed to remap I/O memory\n", dev->minor);
>   		return -ENOMEM;
>   	}
>
> @@ -676,11 +678,13 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
>   	swap_regbase_size_tmp = pci_resource_len(pcidev, 5);
>
>   	if (!swap_regbase_tmp)
> -		printk(KERN_ERR "comedi%d: Swap not present\n", dev->minor);
> +		dev_err(dev->class_dev,
> +			"comedi%d: Swap not present\n", dev->minor);
>
>   	/*---------------------------------------------- Workaround start ---*/
>   	if (plx_regbase_tmp & 0x0080) {
> -		printk(KERN_ERR "comedi%d: PLX-Bug detected\n", dev->minor);
> +		dev_err(dev->class_dev,
> +			"comedi%d: PLX-Bug detected\n", dev->minor);
>
>   		if (swap_regbase_tmp) {
>   			regbase_tmp = plx_regbase_tmp;
> @@ -716,8 +720,8 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
>   	dev_private->me_regbase_size = me_regbase_size_tmp;
>   	dev_private->me_regbase = ioremap(me_regbase_tmp, me_regbase_size_tmp);
>   	if (!dev_private->me_regbase) {
> -		printk(KERN_ERR "comedi%d: Failed to remap I/O memory\n",
> -		       dev->minor);
> +		dev_err(dev->class_dev,
> +			"comedi%d: Failed to remap I/O memory\n", dev->minor);
>   		return -ENOMEM;
>   	}

And the same sort of thing for all of those.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
