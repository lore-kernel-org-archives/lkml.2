Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935736Ab2JYOFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:05:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40297 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab2JYOE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:04:58 -0400
Message-ID: <508946FC.7090704@ti.com>
Date: Thu, 25 Oct 2012 16:04:44 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <sshtylyov@mvista.com>
Subject: Re: [PATCH v4 2/7] usb: dwc3-omap: use of_platform API to create
 dwc3 core pdev
References: <1350307680-24938-1-git-send-email-kishon@ti.com> <1350307680-24938-3-git-send-email-kishon@ti.com>
In-Reply-To: <1350307680-24938-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 03:27 PM, Kishon Vijay Abraham I wrote:
> Used of_platform_populate() to populate dwc3 core platform_device
> from device tree data. Since now the allocation of unique device id is
> handled by of_*, removed the call to dwc3_get_device_id.

Just for my understanding: How are these devices organized exactly?

Do we have : omap_wrapper -> dwc3-omap -> dwc3-core ?

The DT binding is mentioning some wrapper, but I'm not sure where it
should be located.

Maybe you should add more documentation on that. Or maybe you do have a
other series to add that part?

Regards,
Benoit

> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c |   50 +++++++++---------------------------------
>  1 file changed, 10 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index d51c69c..4aaeec4 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -47,6 +47,7 @@
>  #include <linux/ioport.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
> +#include <linux/of_platform.h>
>  
>  #include <linux/usb/otg.h>
>  #include <linux/usb/nop-usb-xceiv.h>
> @@ -133,7 +134,6 @@ struct dwc3_omap {
>  	/* device lock */
>  	spinlock_t		lock;
>  
> -	struct platform_device	*dwc3;
>  	struct platform_device	*usb2_phy;
>  	struct platform_device	*usb3_phy;
>  	struct device		*dev;
> @@ -276,12 +276,10 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>  	struct dwc3_omap_data	*pdata = pdev->dev.platform_data;
>  	struct device_node	*node = pdev->dev.of_node;
>  
> -	struct platform_device	*dwc3;
>  	struct dwc3_omap	*omap;
>  	struct resource		*res;
>  	struct device		*dev = &pdev->dev;
>  
> -	int			devid;
>  	int			size;
>  	int			ret = -ENOMEM;
>  	int			irq;
> @@ -324,34 +322,19 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	devid = dwc3_get_device_id();
> -	if (devid < 0)
> -		return -ENODEV;
> -
> -	dwc3 = platform_device_alloc("dwc3", devid);
> -	if (!dwc3) {
> -		dev_err(dev, "couldn't allocate dwc3 device\n");
> -		goto err1;
> -	}
> -
>  	context = devm_kzalloc(dev, resource_size(res), GFP_KERNEL);
>  	if (!context) {
>  		dev_err(dev, "couldn't allocate dwc3 context memory\n");
> -		goto err2;
> +		return -ENOMEM;
>  	}
>  
>  	spin_lock_init(&omap->lock);
> -	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
>  
> -	dwc3->dev.parent = dev;
> -	dwc3->dev.dma_mask = dev->dma_mask;
> -	dwc3->dev.dma_parms = dev->dma_parms;
>  	omap->resource_size = resource_size(res);
>  	omap->context	= context;
>  	omap->dev	= dev;
>  	omap->irq	= irq;
>  	omap->base	= base;
> -	omap->dwc3	= dwc3;
>  
>  	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
>  
> @@ -396,7 +379,7 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>  	if (ret) {
>  		dev_err(dev, "failed to request IRQ #%d --> %d\n",
>  				omap->irq, ret);
> -		goto err2;
> +		return ret;
>  	}
>  
>  	/* enable all IRQs */
> @@ -415,28 +398,16 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>  
>  	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_1, reg);
>  
> -	ret = platform_device_add_resources(dwc3, pdev->resource,
> -			pdev->num_resources);
> -	if (ret) {
> -		dev_err(dev, "couldn't add resources to dwc3 device\n");
> -		goto err2;
> -	}
> -
> -	ret = platform_device_add(dwc3);
> -	if (ret) {
> -		dev_err(dev, "failed to register dwc3 device\n");
> -		goto err2;
> +	if (node) {
> +		ret = of_platform_populate(node, NULL, NULL, dev);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"failed to add create dwc3 core\n");
> +			return ret;
> +		}
>  	}
>  
>  	return 0;
> -
> -err2:
> -	platform_device_put(dwc3);
> -
> -err1:
> -	dwc3_put_device_id(devid);
> -
> -	return ret;
>  }
>  
>  static int __devexit dwc3_omap_remove(struct platform_device *pdev)
> @@ -446,7 +417,6 @@ static int __devexit dwc3_omap_remove(struct platform_device *pdev)
>  	platform_device_unregister(omap->usb2_phy);
>  	platform_device_unregister(omap->usb3_phy);
>  
> -	dwc3_put_device_id(omap->dwc3->id);
>  	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
>  
>  	return 0;
> 

