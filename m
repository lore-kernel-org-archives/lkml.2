Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0HINYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:24:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56680 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab0HINYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:24:41 -0400
Message-ID: <4C600171.5020405@canonical.com>
Date: Mon, 09 Aug 2010 21:24:01 +0800
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
CC: david-b@pacbell.net, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, ricardo.salveti@canonical.com,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] musb: move usb_add_hcd to the core init code from gadget
 code (v2)
References: <1279895783-7313-1-git-send-email-bryan.wu@canonical.com>
In-Reply-To: <1279895783-7313-1-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

Any comments on this patch?

Thanks a lot,
-Bryan


On 07/23/2010 10:36 PM, Bryan Wu wrote:
> BugLink: http://bugs.launchpad.net/bugs/608312
>
> v2:
> fix the building error on latest 2.6.35-rc kernel, since v1 was generated in
> 2.6.33 kernel.
>
> v1:
> usb_add_hcd was only called when we insmod the gadget class module or built-in
> that gadget class driver. If musb is configured as OTG controller, we need to
> insmod or built-in gadget class driver to make our Host mode fucntion works.
>
> In our Ubuntu system, normally we compiled all the gadget class drivers as
> modules. Then users can insmod the gadget modules as they want. But without the
> gadget class driver running, we needs host function to support common USB
> devices.
>
> This patch fix this issue and tested on omap3 beagle board and Gumstix board.
>
> Signed-off-by: Bryan Wu<bryan.wu@canonical.com>
> ---
>   drivers/usb/musb/musb_core.c   |   13 +++++--------
>   drivers/usb/musb/musb_gadget.c |   18 ------------------
>   2 files changed, 5 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 3b795c5..1b6d74c 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -1583,14 +1583,6 @@ irqreturn_t musb_interrupt(struct musb *musb)
>   		(devctl&  MUSB_DEVCTL_HM) ? "host" : "peripheral",
>   		musb->int_usb, musb->int_tx, musb->int_rx);
>
> -#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> -	if (is_otg_enabled(musb) || is_peripheral_enabled(musb))
> -		if (!musb->gadget_driver) {
> -			DBG(5, "No gadget driver loaded\n");
> -			return IRQ_HANDLED;
> -		}
> -#endif
> -
>   	/* the core can interrupt us for multiple reasons; docs have
>   	 * a generic interrupt flowchart to follow
>   	 */
> @@ -2128,6 +2120,11 @@ bad_config:
>
>   		status = musb_gadget_setup(musb);
>
> +		if (is_otg_enabled(musb)) {
> +			status = usb_add_hcd(musb_to_hcd(musb), -1, 0);
> +			musb_start(musb);
> +		}
> +
>   		DBG(1, "%s mode, status %d, dev%02x\n",
>   			is_otg_enabled(musb) ? "OTG" : "PERIPHERAL",
>   			status,
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index 6fca870..9e55534 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -1761,24 +1761,6 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
>   		otg_set_peripheral(musb->xceiv,&musb->g);
>
>   		spin_unlock_irqrestore(&musb->lock, flags);
> -
> -		if (is_otg_enabled(musb)) {
> -			DBG(3, "OTG startup...\n");
> -
> -			/* REVISIT:  funcall to other code, which also
> -			 * handles power budgeting ... this way also
> -			 * ensures HdrcStart is indirectly called.
> -			 */
> -			retval = usb_add_hcd(musb_to_hcd(musb), -1, 0);
> -			if (retval<  0) {
> -				DBG(1, "add_hcd failed, %d\n", retval);
> -				spin_lock_irqsave(&musb->lock, flags);
> -				otg_set_peripheral(musb->xceiv, NULL);
> -				musb->gadget_driver = NULL;
> -				musb->g.dev.driver = NULL;
> -				spin_unlock_irqrestore(&musb->lock, flags);
> -			}
> -		}
>   	}
>
>   	return retval;

