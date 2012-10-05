Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab2JEQ3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:29:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56336 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab2JEQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:29:41 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/32] USB: EHCI: make ehci-platform use devm_{ioremap,request_mem_region} helpers
Date: Fri, 05 Oct 2012 18:28:38 +0200
Message-ID: <2628717.3gQ4VMN7qb@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1349454064-11606-32-git-send-email-florian@openwrt.org>
References: <1349454064-11606-1-git-send-email-florian@openwrt.org> <1349454064-11606-32-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FlorianOn Friday 05 October 2012 18:21:03  Fainelli wrote:
> This patch changes the ehci-platform driver to use the device managed helper
> functions for requesting memory region and ioremapping memory resources.
> As a result the error path in the probe function is simplified, and the
> platform driver remove callback does not longer need to release and iounmap
> memory resources.

I just realized that I could use devm_request_and_ioremap() instead of these
two calls. Alan, do you mind dropping these last two patches of my serie
and me sending an updated version of both of these patches?

Thanks!

> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  drivers/usb/host/ehci-platform.c |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
> index 3cb0b1b..ebe92cf 100644
> --- a/drivers/usb/host/ehci-platform.c
> +++ b/drivers/usb/host/ehci-platform.c
> @@ -123,29 +123,27 @@ static int __devinit ehci_platform_probe(struct platform_device *dev)
>  	hcd->rsrc_start = res_mem->start;
>  	hcd->rsrc_len = resource_size(res_mem);
>  
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
> +	if (!devm_request_mem_region(&dev->dev, hcd->rsrc_start,
> +					hcd->rsrc_len, hcd_name)) {
>  		dev_err(&dev->dev, "controller already in use");
>  		err = -EBUSY;
>  		goto err_put_hcd;
>  	}
>  
> -	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
> +	hcd->regs = devm_ioremap_nocache(&dev->dev, hcd->rsrc_start,
> +						hcd->rsrc_len);
>  	if (!hcd->regs) {
>  		err = -ENOMEM;
> -		goto err_release_region;
> +		goto err_put_hcd;
>  	}
>  	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>  	if (err)
> -		goto err_iounmap;
> +		goto err_put_hcd;
>  
>  	platform_set_drvdata(dev, hcd);
>  
>  	return err;
>  
> -err_iounmap:
> -	iounmap(hcd->regs);
> -err_release_region:
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>  err_put_hcd:
>  	usb_put_hcd(hcd);
>  err_power:
> @@ -161,8 +159,6 @@ static int __devexit ehci_platform_remove(struct platform_device *dev)
>  	struct usb_ehci_pdata *pdata = dev->dev.platform_data;
>  
>  	usb_remove_hcd(hcd);
> -	iounmap(hcd->regs);
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>  	usb_put_hcd(hcd);
>  	platform_set_drvdata(dev, NULL);
>  
> -- 
> 1.7.9.5
> 
