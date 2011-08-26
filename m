Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1HZSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:09:56 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58398 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381Ab1HZSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:09:54 -0400
X-Sasl-enc: R3H15kuRUuvaz/7I7KFovQ8xMhlnTqVQhYaNeJ0aOE/D 1314382193
Date: Fri, 26 Aug 2011 11:07:34 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/4] usb: Provide usb_speed_string() function
Message-ID: <20110826180734.GA24226@kroah.com>
References: <cover.1314364322.git.mina86@mina86.com>
 <6ffc8c43e9d3fbef765329f0760fb236d20b585a.1314364323.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ffc8c43e9d3fbef765329f0760fb236d20b585a.1314364323.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 03:18:34PM +0200, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> In a few places in the kernel, the code prints
> a human-readable USB device speed (eg. "high speed").
> This involves a switch statement sometimes wrapped
> around in ({ ... }) block leading to code repetition.
> 
> To mitigate this issue, this commit introduces
> usb_speed_string() function, which returns
> a human-readable name of provided speed.
> 
> It also changes a few places switch was used to use
> this new function.  This changes a bit the way the
> speed is printed in few instances at the same time
> standardising it.
> ---
>  drivers/usb/Makefile                |    2 +
>  drivers/usb/common.c                |   24 ++++++++++++++++
>  drivers/usb/core/hub.c              |   27 ++++++------------
>  drivers/usb/gadget/amd5536udc.c     |    9 +----
>  drivers/usb/gadget/atmel_usba_udc.c |    9 ++---
>  drivers/usb/gadget/composite.c      |   22 ++------------
>  drivers/usb/gadget/file_storage.c   |   15 ++-------
>  drivers/usb/gadget/fsl_udc_core.c   |   53 ++++++++++++----------------------
>  drivers/usb/gadget/gmidi.c          |   11 +------
>  drivers/usb/gadget/langwell_udc.c   |   50 +++++++++++---------------------
>  drivers/usb/gadget/net2272.c        |    4 +-
>  drivers/usb/gadget/net2280.c        |    4 +--
>  drivers/usb/gadget/printer.c        |   14 ++-------
>  drivers/usb/gadget/s3c-hsotg.c      |    8 +----
>  drivers/usb/gadget/udc-core.c       |   19 +-----------
>  drivers/usb/misc/usbtest.c          |   21 +------------
>  include/linux/usb/ch9.h             |   12 ++++++++
>  17 files changed, 109 insertions(+), 195 deletions(-)
>  create mode 100644 drivers/usb/common.c
> 
> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> index 969b0a5..2d5af21 100644
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -53,3 +53,5 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
>  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
>  obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
>  obj-$(CONFIG_USB_GADGET)	+= gadget/
> +
> +obj-$(CONFIG_USB_SUPPORT)	+= common.o

You just built this into the kernel, which while ok for some things,
might not be what some people want.

Please make this into a separate module if people are building the usb
code as modules, usb_common.ko perhaps?

> diff --git a/drivers/usb/common.c b/drivers/usb/common.c
> new file mode 100644
> index 0000000..2f6627c
> --- /dev/null
> +++ b/drivers/usb/common.c
> @@ -0,0 +1,24 @@
> +/*
> + * Provides code common for host and device side USB.
> + */
> +
> +#include <linux/kernel.h>  /* for ARRAY_SIZE() */
> +#include <linux/module.h>  /* for EXPORT_SYMBOL_GPL() */

No need for the "/* for ... */" lines, we all know what this is for.

> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -868,6 +868,18 @@ enum usb_device_speed {
>  	USB_SPEED_SUPER,			/* usb 3.0 */
>  };
>  
> +#ifdef __KERNEL__
> +
> +/**
> + * usb_speed_string() - Returns human readable-name of the speed.
> + * @speed: The speed to return human-readable name for.  If it's not
> + *   any of the speeds defined in usb_device_speed enum, string for
> + *   USB_SPEED_UNKNOWN will be returned.
> + */
> +extern const char *usb_speed_string(enum usb_device_speed speed);
> +
> +#endif

No, this should be in include/linux/usb.h, not ch9.h.

thanks,

greg k-h
