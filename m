Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab2EITT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:19:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab2EITTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:19:54 -0400
Date: Wed, 9 May 2012 12:19:50 -0700
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>
Subject: Re: [ 034/167] [PATCH] usb: gadget: udc-core: stop UDC on
 device-initiated disconnect
Message-ID: <20120509191950.GB15527@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055034.318079643@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055034.318079643@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:51:03AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Felipe Balbi <balbi@ti.com>
> 
> commit 6d258a4c42089229b855fd706622029decf316d6 upstream.

We also need a follow up fix to this, commit
83a787a71e034244a9fd1d5988fe18f226341417 upstream.

> 
> When we want to do device-initiated disconnect,
> let's make sure we stop the UDC in order to
> e.g. allow lower power states to be achieved by
> turning off unnecessary clocks and/or stoping
> PHYs.
> 
> When reconnecting, call ->udc_start() again to
> make sure UDC is reinitialized.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/usb/gadget/udc-core.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index 56da49f..c261887 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -411,8 +411,12 @@ static ssize_t usb_udc_softconn_store(struct device *dev,
>  	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
>  
>  	if (sysfs_streq(buf, "connect")) {
> +		if (udc_is_newstyle(udc))
> +			usb_gadget_udc_start(udc->gadget, udc->driver);
>  		usb_gadget_connect(udc->gadget);
>  	} else if (sysfs_streq(buf, "disconnect")) {
> +		if (udc_is_newstyle(udc))
> +			usb_gadget_udc_stop(udc->gadget, udc->driver);
>  		usb_gadget_disconnect(udc->gadget);
>  	} else {
>  		dev_err(dev, "unsupported command '%s'\n", buf);
> -- 
> 1.7.10
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
