Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1EIJj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:39:56 -0400
Received: from smtp.nokia.com ([147.243.128.26]:65045 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1EIJjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:39:55 -0400
Message-ID: <4DC7B700.6040809@nokia.com>
Date: Mon, 9 May 2011 12:42:24 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: ext Roger Quadros <roger.quadros@nokia.com>
CC: <gregkh@suse.de>, <stern@rowland.harvard.edu>, <mina86@mina86.com>,
        <m-sonasath@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: gadget: composite: Allow function drivers to
 defer setup responses
References: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com> <1303220033-5274-2-git-send-email-roger.quadros@nokia.com>
In-Reply-To: <1303220033-5274-2-git-send-email-roger.quadros@nokia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.36.192]
X-OriginalArrivalTime: 09 May 2011 09:39:42.0455 (UTC) FILETIME=[060A3070:01CC0E2D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/19/2011 04:33 PM, ext Roger Quadros wrote:
> Some USB function drivers (e.g. f_mass_storage.c) need to delay or defer the
> status phase of standard control requests like SET_CONFIGURATION or
> SET_INTERFACE till they are done with their bookkeeping and are actually ready
> for accepting new commands to their interface.
>
> They can now achieve this functionality by returning USB_GADGET_DELAYED_STATUS
> in their setup handlers (e.g. set_alt()). The composite framework will then
> defer completion of the setup transfer by not sending the Data/Status response.
>
> This ensures that the host does not send new packets to the interface till the
> function driver is ready to take them.
>
> When the function driver that requested for USB_GADGET_DELAYED_STATUS is done
> with its bookkeeping, it should signal the composite framework to continue with
> the Data/Status phase of the setup transfer. It can do so by invoking
> the new API usb_composite_setup_continue(). This is where the setup transfer's
> data/status phases are completed and host can send new transfers.
>
> The DELAYED_STATUS mechanism is currently only supported if the expected data phase
> is 0 bytes (i.e. w_length == 0). Since SET_CONFIGURATION and SET_INTERFACE are the
> only cases that will use this mechanism, this is not a limitation as such.
>
> Signed-off-by: Roger Quadros<roger.quadros@nokia.com>
> ---
>   drivers/usb/gadget/composite.c |   61 +++++++++++++++++++++++++++++++++++++++-
>   include/linux/usb/composite.h  |   17 ++++++++++-
>   2 files changed, 76 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 1ba4bef..43be36e 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -461,6 +461,15 @@ static int set_config(struct usb_composite_dev *cdev,
>   			reset_config(cdev);
>   			goto done;
>   		}
> +
> +		if (result == USB_GADGET_DELAYED_STATUS) {
> +			DBG(cdev,
> +			 "%s: interface %d (%s) requested delayed status\n",
> +					__func__, tmp, f->name);
> +			cdev->delayed_status++;
> +			DBG(cdev, "delayed_status count %d\n",
> +					cdev->delayed_status);
> +		}
>   	}
>

The below snippet needs to be added to the patch, else it causes a regression.

         /* when we return, be sure our power usage is valid */
         power = c->bMaxPower ? (2 * c->bMaxPower) : CONFIG_USB_GADGET_VBUS_DRAW;
  done:
         usb_gadget_vbus_draw(gadget, power);
+       if (result >= 0 && cdev->delayed_status)
+               result = USB_GADGET_DELAYED_STATUS;
         return result;
  }

I will fix this in the next version of the patch-set which I'll send soon.

-- 
regards,
-roger
