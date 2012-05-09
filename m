Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851Ab2EITZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:25:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2EITZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:25:54 -0400
Date: Wed, 9 May 2012 12:25:50 -0700
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        Partha Basak <p-basak2@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [ 035/167] [PATCH] usb: gadget: udc-core: fix asymmetric calls
 in remove_driver
Message-ID: <20120509192549.GC15527@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055034.468801255@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055034.468801255@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:51:04AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kishon Vijay Abraham I <kishon@ti.com>
> 
> commit 8ae8090c82eb407267001f75b3d256b3bd4ae691 upstream.

After applying this it seems we need also this upstream commit applied
in addition:
320cd1e750f1bf3e47eb41209dcb2be07264cb76

> 
> During modprobe of gadget driver, pullup is called after
> udc_start. In order to make the exit path symmetric when
> removing a gadget driver, call pullup before ->udc_stop.
> 
> This is needed to avoid issues with PM where udc_stop
> disables the module completely (put IP in reset state,
> cut functional and interface clocks, and so on), which
> prevents us from accessing the IP's address space,
> thus creating the possibility of an abort exception
> when we try to access IP's address space after clocks
> are off.
> 
> Signed-off-by: Partha Basak <p-basak2@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/usb/gadget/udc-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index c261887..2fa9865 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -264,8 +264,8 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
>  	if (udc_is_newstyle(udc)) {
>  		udc->driver->disconnect(udc->gadget);
>  		udc->driver->unbind(udc->gadget);
> -		usb_gadget_udc_stop(udc->gadget, udc->driver);
>  		usb_gadget_disconnect(udc->gadget);
> +		usb_gadget_udc_stop(udc->gadget, udc->driver);
>  	} else {
>  		usb_gadget_stop(udc->gadget, udc->driver);
>  	}
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
