Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0FXOKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:10:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51094 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752876Ab0FXOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:10:39 -0400
Date: Thu, 24 Jun 2010 10:10:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
cc: linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
In-Reply-To: <201006241001.01587.ozan@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.1006241004430.1654-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, Ozan [utf-8] Çağlayan wrote:

> Ok so it should be something like this:
> 
> --- linux-2.6.31.orig/drivers/usb/core/hub.c
> +++ linux-2.6.31/drivers/usb/core/hub.c
> @@ -1305,11 +1305,11 @@ void usb_set_device_state(struct usb_dev
>  ·  ·   ·   ·   ·   || new_state == USB_STATE_SUSPENDED)
>  ·  ·   ·   ·   ;·  /* No change to wakeup settings */
>  ·  ·   ·   else if (new_state == USB_STATE_CONFIGURED)
> -·  ·   ·   ·   device_init_wakeup(&udev->dev,
> +·  ·   ·   ·   device_set_wakeup_capable(&udev->dev,
>  ·  ·   ·   ·   ·   (udev->actconfig->desc.bmAttributes
>  ·  ·   ·   ·   ·    & USB_CONFIG_ATT_WAKEUP));
>  ·  ·   ·   else
> -·  ·   ·   ·   device_init_wakeup(&udev->dev, 0);
> +·  ·   ·   ·   device_set_wakeup_capable(&udev->dev, 0);
>  ·  ·   }
>  ·  ·   if (udev->state == USB_STATE_SUSPENDED &&
>  ·  ·   ·   new_state != USB_STATE_SUSPENDED)

Right.

> > You can verify the result by checking the contents of
> > /sys/bus/usb/devices/2-5/power/wakeup (replace the 2-5 with the correct
> > path for the camera device).  With the current code it will say
> > "enabled", but after the change it should say "disabled".
> > 
> 
> I'll make them try this kernel but when I compare the output of
> 
> cat /sys/bus/usb/devices/*/power/wakeup
> 
> between the patched and non-patched kernels on my system, all wakeup values 
> are still enabled. Because as far as I understand the first call still can 
> enable remote wakeup as the 2nd parameter isn't a hardcoded 0. Or should this 
> only affect some devices?

The content of the power/wakeup file depends on two values: the 
can_wakeup flag and the should_wakeup flag.  If can_wakeup is false 
then the file will be empty; otherwise it will contain "disabled" or 
"enabled" according to the value of should_wakeup.

Now, device_init_wakeup() sets both flags whereas 
device_set_wakeup_capable() affects only the can_wakeup flag.  After 
this change is made there should be nothing in the kernel that turns on 
the should_wakeup flag, and consequently remote wakeup should remain 
disabled.

You can check this by grepping for occurrences of "should_wakeup" or 
"dev_set_wakeup_enable" (which affects the should_wakeup flag).

Alan Stern

