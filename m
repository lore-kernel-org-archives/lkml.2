Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1FISvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:51:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41660 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751942Ab1FISve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:51:34 -0400
Date: Thu, 9 Jun 2011 14:51:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb:dummy_hcd: Force FS device connection according
 to module parameter
In-Reply-To: <1307635009-5741-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106091449490.2081-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Tatyana Brokhman wrote:

> This patch adds a new module parameter to dummy_hcd: is_high_speed
> When set to false the connected device will be forced to operate in FS
> mode. The default of this parameter is true.

...

> @@ -904,12 +908,15 @@ usb_gadget_probe_driver(struct usb_gadget_driver *driver,
>  	dum->gadget.ep0 = &dum->ep [0].ep;
>  	if (mod_data.is_super_speed)
>  		dum->gadget.speed = driver->speed;
> -	else
> +	else if (mod_data.is_high_speed)
>  		dum->gadget.speed = min((u8)USB_SPEED_HIGH, (u8)driver->speed);

Use min_t().

> +	else
> +		dum->gadget.speed = USB_SPEED_FULL;
>  	if (dum->gadget.speed < driver->speed)
> -		dev_dbg(udc_dev(dum), "This device can perform faster if"
> -				      " you connect it to a "
> -				      "SupeSpeed port...\n");
> +		dev_dbg(udc_dev(dum), "This device can perform faster"
> +				" if you connect it to a %s port...\n",
> +			(driver->speed == USB_SPEED_SUPER ?
> +			 "SuperSpeed" : "HighSpeed"));
>  
>  	if (dum->gadget.speed == USB_SPEED_SUPER) {
>  		for (i = 0; i < DUMMY_ENDPOINTS; i++)
> @@ -2417,6 +2424,9 @@ static int __init init (void)
>  	if (usb_disabled ())
>  		return -ENODEV;
>  
> +	if (!mod_data.is_high_speed && mod_data.is_super_speed)
> +		return -EINVAL;

Print an error message in the log so that the user will know why the 
failure occurred.

Alan Stern

