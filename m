Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2GSMHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:07:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44567 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab2GSMHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:07:18 -0400
Message-ID: <5007F86F.7060201@mev.co.uk>
Date: Thu, 19 Jul 2012 13:07:11 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 67/90] staging: comedi: dt3000: remove 'phys_addr' from
 the private data
References: <201207181858.25078.hartleys@visionengravers.com>
In-Reply-To: <201207181858.25078.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 02:58, H Hartley Sweeten wrote:
> The 'phys_addr' variable in the private data is simply used as
> a flag for the detach function to know that the pci device has
> been enabled. Use the 'dev->iobase' variable instead as is more
> typical for other comedi pci drivers.

I think dev->iobase is really only meant to hold I/O port addresses, 
although it is wide enough to hold a 32-bit PCI memory address.

> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/staging/comedi/drivers/dt3000.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
> index 92558e7..3937e87 100644
> --- a/drivers/staging/comedi/drivers/dt3000.c
> +++ b/drivers/staging/comedi/drivers/dt3000.c
> @@ -250,7 +250,6 @@ static const struct dt3k_boardtype dt3k_boardtypes[] = {
>   struct dt3k_private {
>
>   	struct pci_dev *pci_dev;
> -	resource_size_t phys_addr;
>   	void __iomem *io_addr;
>   	unsigned int lock;
>   	unsigned int ao_readback[2];
> @@ -824,8 +823,8 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>   	if (ret < 0)
>   		return ret;
>
> -	devpriv->phys_addr = pci_resource_start(pcidev, 0);
> -	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
> +	dev->iobase = pci_resource_start(pcidev, 0);
> +	devpriv->io_addr = ioremap(dev->iobase, DT3000_SIZE);

dev->iobase is an unsigned long, which may be narrower than a 
resource_size_t.  You should really pass the full-width resource_size_t 
value to ioremap().

You could even set dev->iobase to some dummy non-zero value as a flag 
for the detach() routine to call comedi_pci_disable() as dev->iobase is 
not used for anything else.

>   	if (!devpriv->io_addr)
>   		return -ENOMEM;
>
> @@ -905,7 +904,7 @@ static void dt3000_detach(struct comedi_device *dev)
>   		free_irq(dev->irq, dev);
>   	if (devpriv) {
>   		if (devpriv->pci_dev) {
> -			if (devpriv->phys_addr)
> +			if (dev->iobase)
>   				comedi_pci_disable(devpriv->pci_dev);
>   			pci_dev_put(devpriv->pci_dev);
>   		}
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
