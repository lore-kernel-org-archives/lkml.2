Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab2C2L7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:59:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41906 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2C2L6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:58:51 -0400
Message-ID: <4F744E23.3040207@mvista.com>
Date: Thu, 29 Mar 2012 15:57:23 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: yurex: remove allocation of coherent buffer for
 setup-packet buffer
References: <4F739CBB.8060602@gmail.com>
In-Reply-To: <4F739CBB.8060602@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-03-2012 3:20, Tomoki Sekiyama wrote:

> Removes allocation of coherent buffer for the control-request setup-packet
> buffer from the yurex driver. Using coherent buffers for setup-packet is
> obsoleted and does not work with some USB host implementations.

> This patch also fixes missing URB_NO_TRANSFER_DMA_MAP flag in urb.

   Looks like the patch should be split into two then as it does two different
things.

> Signed-off-by: Tomoki Sekiyama<tomoki.sekiyama@gmail.com>
> ---
>   drivers/usb/misc/yurex.c |   10 +++-------
>   1 files changed, 3 insertions(+), 7 deletions(-)

> diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
> index 897edda..7020146 100644
> --- a/drivers/usb/misc/yurex.c
> +++ b/drivers/usb/misc/yurex.c
> @@ -99,9 +99,7 @@ static void yurex_delete(struct kref *kref)
>   	usb_put_dev(dev->udev);
>   	if (dev->cntl_urb) {
>   		usb_kill_urb(dev->cntl_urb);
> -		if (dev->cntl_req)
> -			usb_free_coherent(dev->udev, YUREX_BUF_SIZE,
> -				dev->cntl_req, dev->cntl_urb->setup_dma);
> +		kfree(dev->cntl_req);
>   		if (dev->cntl_buffer)
>   			usb_free_coherent(dev->udev, YUREX_BUF_SIZE,
>   				dev->cntl_buffer, dev->cntl_urb->transfer_dma);
> @@ -234,9 +232,7 @@ static int yurex_probe(struct usb_interface *interface, const struct usb_device_
>   	}
> 
>   	/* allocate buffer for control req */
> -	dev->cntl_req = usb_alloc_coherent(dev->udev, YUREX_BUF_SIZE,
> -					   GFP_KERNEL,
> -					&dev->cntl_urb->setup_dma);
> +	dev->cntl_req = kmalloc(YUREX_BUF_SIZE, GFP_KERNEL);
>   	if (!dev->cntl_req) {
>   		err("Could not allocate cntl_req");
>   		goto error;
> @@ -286,7 +282,7 @@ static int yurex_probe(struct usb_interface *interface, const struct usb_device_
>   			 usb_rcvintpipe(dev->udev, dev->int_in_endpointAddr),
>   			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
>   			 dev, 1);
> -	dev->cntl_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +	dev->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>   	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
>   		retval = -EIO;
>   		err("Could not submitting URB");

WBR, Sergei
