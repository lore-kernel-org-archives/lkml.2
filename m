Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0CQOiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:38:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42446 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753562Ab0CQOiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:38:50 -0400
Date: Wed, 17 Mar 2010 10:38:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 4/5] usb-hcd,usb-console: poll hcd device to force usb
 console writes
In-Reply-To: <1268773546-12457-5-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003171031400.1734-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Jason Wessel wrote:

> This patch tries to solve the problem that data is lost because there
> are too many outstanding transmit urb's while trying to execute
> printk's to a console.  The same is true if you try something like
> "echo t > /proc/sysrq-trigger".
> 
> This patch takes the route of forcibly polling the hcd device to drain
> the urb queue in order to initiate the bulk write call backs.  This
> only happens if the device is a usb serial console device that sets
> the max_in_flight_urbs to a non zero value in the serial device
> structure.
> 
> A few millisecond penalty will get incurred to allow the hcd controller
> to complete a write urb, else the console data is thrown away.
> 
> The max_in_flight_urbs was reduced in the usb_debug driver because it
> is highly desired to push things out to the console in a timely
> fashion and there is no need to have a queue that large for the
> interrupt driven mode of operation when used through the tty
> interface.

> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 8c9f053..a7d6cf7 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -569,6 +569,9 @@ static inline void usb_mark_last_busy(struct usb_device *udev)
>  
>  /*-------------------------------------------------------------------------*/
>  
> +/* for polling the hcd device */
> +extern void usb_poll_irq(struct usb_device *udev);
> +

The points Johan Hovold made about max_in_flight_urbs are well taken
and they should be addressed before this patch is accepted.

The parts about usb_poll_irq() are fine, although the comment above 
should be changed to something more like:

	/* for polling the device's host controller */

since "hcd" is short for "host controller driver", and "polling the 
host controller driver device" doesn't make much sense.  The same goes 
for the comment in usb_do_console_write().

Alan Stern

