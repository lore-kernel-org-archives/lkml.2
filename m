Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab1GKJjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:39:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51796 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1GKJjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:39:11 -0400
Date: Mon, 11 Jul 2011 17:36:51 +0800
From: wangyanqing <udknight@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Avoid NULL pointer dereference in usb_disconnect()
Message-ID: <20110711093651.GA10217@udknight>
References: <alpine.LNX.2.00.1107111119080.4462@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107111119080.4462@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:21:18AM +0200, Jesper Juhl wrote:
> If, in drivers/usb/core/hub.c::usb_disconnect(), 'udev' is NULL, then
> we'll never get to the printing of a debug message and returning from
> the function since we'll have already dereferenced the NULL pointer in
> the bus_to_hcd(udev->bus) call.
> This patch moves the dereference to after the test for NULL, thus
> avoiding that potential crash.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/usb/core/hub.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
>  disclaimer: compile tested only.
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index a428aa0..0a98c76 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1634,13 +1634,15 @@ void usb_disconnect(struct usb_device **pdev)
>  {
>  	struct usb_device	*udev = *pdev;
>  	int			i;
> -	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
> +	struct usb_hcd		*hcd;
>  
>  	if (!udev) {
>  		pr_debug ("%s nodev\n", __func__);
>  		return;
>  	}
>  
> +	hcd = bus_to_hcd(udev->bus);
> +
>  	/* mark the device as inactive, so any further urb submissions for
>  	 * this device (and any of its children) will fail immediately.
>  	 * this quiesces everything except pending urbs.
> -- 
> 1.7.6
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Hello,All.Just a question,should we add the NULL checker code at everywhere that 
dereference pointer in kernel? If so,it will scare me.
