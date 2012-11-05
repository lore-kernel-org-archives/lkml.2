Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2KEKFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:05:15 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62823 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2KEKFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:05:11 -0500
Date: Mon, 5 Nov 2012 11:04:08 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "harvey.yang" <harvey.huawei.yang@gmail.com>
Cc: Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/1] staging: usbip: remove an unnecessary lock in
 usbip_event_happened.
Message-ID: <20121105100408.GB24148@kroah.com>
References: <y>
 <1352109071-10696-1-git-send-email-harvey.huawei.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352109071-10696-1-git-send-email-harvey.huawei.yang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 05:51:11PM +0800, harvey.yang wrote:
> From: Harvey.Yang <harvey.huawei.yang@gmail.com>
> 
> 
> Signed-off-by: Harvey.Yang <harvey.huawei.yang@gmail.com>
> ---
>  drivers/staging/usbip/usbip_common.h |    2 +-
>  drivers/staging/usbip/usbip_event.c  |   11 ++---------
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
> index 5d89c0f..b6d7add 100644
> --- a/drivers/staging/usbip/usbip_common.h
> +++ b/drivers/staging/usbip/usbip_common.h
> @@ -330,7 +330,7 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb);
>  int usbip_start_eh(struct usbip_device *ud);
>  void usbip_stop_eh(struct usbip_device *ud);
>  void usbip_event_add(struct usbip_device *ud, unsigned long event);
> -int usbip_event_happened(struct usbip_device *ud);
> +inline int usbip_event_happened(struct usbip_device *ud);
>  
>  static inline int interface_to_busnum(struct usb_interface *interface)
>  {
> diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
> index d332a34..15871f0 100644
> --- a/drivers/staging/usbip/usbip_event.c
> +++ b/drivers/staging/usbip/usbip_event.c
> @@ -112,15 +112,8 @@ void usbip_event_add(struct usbip_device *ud, unsigned long event)
>  }
>  EXPORT_SYMBOL_GPL(usbip_event_add);
>  
> -int usbip_event_happened(struct usbip_device *ud)
> +inline int usbip_event_happened(struct usbip_device *ud)
>  {
> -	int happened = 0;
> -
> -	spin_lock(&ud->lock);
> -	if (ud->event != 0)
> -		happened = 1;
> -	spin_unlock(&ud->lock);
> -
> -	return happened;
> +	return ud->event ? 1 : 0;

No, you aren't locking to see if something changed with ud->event here.

Actually, that's pretty broken anyway, what is to say that event doesn't
change right after this call?  What exactly is this call supposed to be
doing?  Who is calling it?

>  }
>  EXPORT_SYMBOL_GPL(usbip_event_happened);

You can't inline an exported symbol, how would that work?

greg k-h
