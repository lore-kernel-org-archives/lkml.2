Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2HCOm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:42:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55591 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753500Ab2HCOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:42:54 -0400
Date: Fri, 3 Aug 2012 10:42:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: y b <ycbzzjlby@gmail.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: kernel panic when called usb_control_msg()
In-Reply-To: <CAPoh-nbx6pxhV2kXhnOmWzAGp6-jAkwQPcwGRtdXZEFoBB-iBw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1208031041070.1520-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012, y b wrote:

> Hi,
> kernel panic when called usb_control_msg(), like this:
>    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
> XR_SET_REG, USB_DIR_OUT | USB_TYPE_VENDOR, value, regnum | (block <<
> 8), NULL, 0, 5000)
> The kernel's version is 2.6.33_rc4, but I think it will happen in
> lastest statable version too.

> I fixed it like this:
> 
> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> index 4bb717d..b043f27 100644
> --- a/drivers/usb/musb/musb_host.c
> +++ b/drivers/usb/musb/musb_host.c
> @@ -2056,9 +2056,15 @@ static int musb_urb_enqueue(
>         kfree(qh);
>         qh = NULL;
>         ret = 0;
> -   } else
> -       ret = musb_schedule(musb, qh,
> -               epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK);
> +   } else {
> +       if (!next_urb(qh)) {
> +           kfree(qh);
> +           qh = NULL;
> +           ret = 0;
> +       } else
> +           ret = musb_schedule(musb, qh,
> +                   epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK);
> +   }
> 

You could shrink this patch a lot:

	 * we only have work to do in the former case.
	 */
	spin_lock_irqsave(&musb->lock, flags);
-	if (hep->hcpriv) {
+	if (hep->hcpriv || !next_urb(qh)) {
		/* some concurrent activity submitted another urb to hep...
		 * odd, rare, error prone, but legal.
		 */

Alan Stern

