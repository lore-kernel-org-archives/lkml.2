Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2GSJhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:37:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44212 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab2GSJht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:37:49 -0400
Message-ID: <5007D568.2050401@mev.co.uk>
Date: Thu, 19 Jul 2012 10:37:44 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/90] staging: comedi: adv_pci1723: move comedi_pci_enable()
 into the attach
References: <201207181830.48668.hartleys@visionengravers.com>
In-Reply-To: <201207181830.48668.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 02:30, H Hartley Sweeten wrote:
> Use pci_is_enabled() in the "find pci device" function to determine if
> the found pci device is not in use and move the comedi_pci_enable() call
> into the attach.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/staging/comedi/drivers/adv_pci1723.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
> index f561a2a..e971fa6 100644
> --- a/drivers/staging/comedi/drivers/adv_pci1723.c
> +++ b/drivers/staging/comedi/drivers/adv_pci1723.c
> @@ -302,11 +302,7 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
>   		}
>   		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
>   			continue;
> -		/*
> -		 * Look for device that isn't in use.
> -		 * Enable PCI device and request regions.
> -		 */
> -		if (comedi_pci_enable(pcidev, "adv_pci1723"))
> +		if (pci_is_enabled(pcidev))
>   			continue;
>   		return pcidev;
>   	}

Just because the device is enabled doesn't mean that it is in use, so 
this change could skip over a perfectly good unused device.

If you want to move the comedi_pci_enable() call, this is a change in 
behaviour for this particular driver, but is consistent with most of the 
other Comedi PCI drivers (and the bus/slot options can be used to select 
a particular device).  This is probably a good thing, but you should 
take out the pci_is_enabled test.

> @@ -335,6 +331,10 @@ static int pci1723_attach(struct comedi_device *dev,
>   	if (!devpriv->pcidev)
>   		return -EIO;
>
> +	ret = comedi_pci_enable(devpriv->pcidev, "adv_pci1723");
> +	if (ret)
> +		return ret;
> +
>   	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
>
>   	dev->board_name = this_board->name;
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


