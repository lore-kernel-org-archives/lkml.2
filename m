Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2HGRrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:47:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45355 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755824Ab2HGRrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:47:17 -0400
Date: Tue, 7 Aug 2012 13:47:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@linaro.org>,
        <praveen.nadahally@stericsson.com>, <ragupathy.rajaram@stericsson.com>,
        <vikrant.bapat@stericsson.com>
Subject: Re: [PATCH v2] usb:musb:musb_host: Handle highmem in PIO mode
In-Reply-To: <1344330980-9064-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
Message-ID: <Pine.LNX.4.44L0.1208071342410.2400-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Virupax Sadashivpetimath wrote:

> In case of USB bulk transfer, when himem page
> is received, the usb_sg_init function sets the
> urb transfer buffer to NULL. When such URB
> transfer is handled, kernel crashes in PIO mode.
> Handle this by mapping the highmem buffer in PIO mode.

...

> @@ -1332,9 +1353,38 @@ void musb_host_tx(struct musb *musb, u8 epnum)
>  		length = qh->maxpacket;
>  	/* Unmap the buffer so that CPU can use it */
>  	usb_hcd_unmap_urb_for_dma(musb_to_hcd(musb), urb);
> -	musb_write_fifo(hw_ep, length, urb->transfer_buffer + offset);
> +
> +	/*
> +	 * We need to map sg if the transfer_buffer is
> +	 * NULL.
> +	 */
> +	if (!urb->transfer_buffer)
> +		use_sg = true;

Here you test urb->transfer_buffer.

> +	if (use_sg) {
> +		/* sg_miter_start is already done in musb_ep_program */
> +		if (!sg_miter_next(&qh->sg_miter)) {
> +			dev_err(musb->controller, "error: sg list empty\n");
> +			sg_miter_stop(&qh->sg_miter);
> +			status = -EINVAL;
> +			goto done;
> +		}
> +		urb->transfer_buffer = qh->sg_miter.addr;

And here you set it.  As a result, on the next iteration of this
routine the test above won't work right.  (This function gets invoked
once for each entry in the sg list, right?)

Is there any reason to set urb->transfer_buffer here?  You could just
use qh->sg_miter.addr directly in the musb_write_fifo() call two lines
below.

> +		length = min_t(u32, length, qh->sg_miter.length);
> +		musb_write_fifo(hw_ep, length, urb->transfer_buffer);
> +		qh->sg_miter.consumed = length;
> +		sg_miter_stop(&qh->sg_miter);
> +	} else {
> +		musb_write_fifo(hw_ep, length, urb->transfer_buffer + offset);
> +	}

Alan Stern

