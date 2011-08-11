Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1HKVvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:51:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55434 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1HKVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:51:10 -0400
Date: Thu, 11 Aug 2011 18:51:42 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] BTUSB: be quiet on device disconnect
Message-ID: <20110811215142.GG19699@joana>
Mail-Followup-To: Paul Bolle <pebolle@tiscali.nl>,
	Marcel Holtmann <marcel@holtmann.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1312902988.1853.24.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312902988.1853.24.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

* Paul Bolle <pebolle@tiscali.nl> [2011-08-09 17:16:28 +0200]:

> Disabling the bluetooth usb device embedded in (some) ThinkPads tends to
> lead to errors like these:
>     btusb_bulk_complete: hci0 urb ffff88011b9bfd68 failed to resubmit (19)
>     btusb_intr_complete: hci0 urb ffff88011b46a318 failed to resubmit (19)
>     btusb_bulk_complete: hci0 urb ffff88011b46a000 failed to resubmit (19)
> 
> That is because usb_disconnect() doesn't "quiesces" pending urbs.
> 
> Disconnecting a device is a normal thing to happen so it's no big deal
> that usb_submit_urb() returns -ENODEV. The simplest way to get rid of
> these errors is to stop treating that return as an error. Trivial,
> actually.
> 
> While we're at it, add comments to be explicit about the reasons we're
> not complaining about -EPERM and -ENODEV.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) This patch seems to put an end to a pet peeve of mine: the errors in
> the logs of a ThinkPad when I disable its embedded bluetooth.
> 
> 1) I added Greg and linux-usb@vger.kernel.org because usb_submit_urb()
> doesn't specify the meaning of its negative return values. I traced
> -EPERM to usb_hcd_link_urb_to_ep(). That returns -EPERM if the urb is
> "being killed". Did I trace the calls made by usb_submit_urb()
> correctly? I also just assumed that -ENODEV always means device got
> disconnected or something comparable. Is that correct too?
> 
> 2) Sent as an RFC because btusb's btusb_*_complete() functions puzzle
> me. If I read their code correctly these three functions will be an
> urb's completion handler when usb_submit_urb() is called on that urb.
> This means they will be called when usb_submit_urb() is done doing its
> stuff. But they themselves also call usb_submit_urb()! So, apparently,
> there's this endless loop:
>     usb_submit_urb()
>         btusb_*_complete()
>            usb_submit_urb()
>                [...]
> 
> It seems that usb_submit_urb() returning -EPERM is the expected way for
> this loop to end. Am I reading this correctly? If so, doesn't this need
> some comments to explain that? But perhaps calling usb_submit_urb() in a
> completion handler is a common pattern for usb devices.
> 
>  drivers/bluetooth/btusb.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 91d13a9..9e4448e 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -256,7 +256,9 @@ static void btusb_intr_complete(struct urb *urb)
>  
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err < 0) {
> -		if (err != -EPERM)
> +		/* -EPERM: urb is being killed;
> +		 * -ENODEV: device got disconnected */
> +		if (err != -EPERM && err != -ENODEV)
>  			BT_ERR("%s urb %p failed to resubmit (%d)",
>  						hdev->name, urb, -err);
>  		usb_unanchor_urb(urb);
> @@ -341,7 +343,9 @@ static void btusb_bulk_complete(struct urb *urb)
>  
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err < 0) {
> -		if (err != -EPERM)
> +		/* -EPERM: urb is being killed;
> +		 * -ENODEV: device got disconnected */
> +		if (err != -EPERM && err != -ENODEV)
>  			BT_ERR("%s urb %p failed to resubmit (%d)",
>  						hdev->name, urb, -err);
>  		usb_unanchor_urb(urb);
> @@ -431,7 +435,9 @@ static void btusb_isoc_complete(struct urb *urb)
>  
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err < 0) {
> -		if (err != -EPERM)
> +		/* -EPERM: urb is being killed;
> +		 * -ENODEV: device got disconnected */
> +		if (err != -EPERM && err != -ENODEV)
>  			BT_ERR("%s urb %p failed to resubmit (%d)",
>  						hdev->name, urb, -err);
>  		usb_unanchor_urb(urb);

Applied. Thanks.

	Gustavo
