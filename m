Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1GGIgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:36:12 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:44913 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1GGIgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:36:09 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.9
Message-ID: <4E156FF5.9070203@tudelft.nl>
Date: Thu, 07 Jul 2011 10:36:05 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <gregkh@suse.de>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] USB: additional regression fix for device removal
References: <Pine.LNX.4.44L0.1107061658180.1995-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107061658180.1995-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 06-07-11 23:03, Alan Stern schreef:
> Commit e534c5b831c8b8e9f5edee5c8a37753c808b80dc (USB: fix regression
> occurring during device removal) didn't go far enough.  It failed to
> take into account that when a driver claims multiple interfaces, it may
> release them all at the same time.  As a result, some interfaces can
> get released before they are unregistered, and we deadlock trying to
> acquire the bandwidth_mutex that we already own.
>
> This patch (asl478) handles this case by setting the "unregistering"
> flag on all the interfaces before removing any of them.
>
> Signed-off-by: Alan Stern<stern@rowland.harvard.edu>
> CC:<stable@kernel.org>

Great, it works here :-)
Tested-by: Éric Piel <eric.piel@tremplin-utc.net>

Thanks,
Éric
>
> ---
>
> This should take care of Eric's problem as well as Arkadiusz, since
> they seemed to be hitting the same thing (cdc_ether claiming multiple
> interfaces and hanging while releasing them).
>
> Still, we need to rewrite this stuff.  A possible race remains, because
> a driver may try to change an altsetting at the same time as the device
> is removed.  Either the driver's disconnect routine would hang waiting
> for the altsetting change (which is waiting to acquire the
> bandwidth_mutex) or else the altsetting change would go through after
> the driver was unbound from the device.  Neither alternative is good.
>
> Alan Stern
>
>
>
>   drivers/usb/core/message.c |    9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> Index: usb-3.0/drivers/usb/core/message.c
> ===================================================================
> --- usb-3.0.orig/drivers/usb/core/message.c
> +++ usb-3.0/drivers/usb/core/message.c
> @@ -1147,6 +1147,14 @@ void usb_disable_device(struct usb_devic
>   	 * any drivers bound to them (a key side effect)
>   	 */
>   	if (dev->actconfig) {
> +		/*
> +		 * FIXME: In order to avoid self-deadlock involving the
> +		 * bandwidth_mutex, we have to mark all the interfaces
> +		 * before unregistering any of them.
> +		 */
> +		for (i = 0; i<  dev->actconfig->desc.bNumInterfaces; i++)
> +			dev->actconfig->interface[i]->unregistering = 1;
> +
>   		for (i = 0; i<  dev->actconfig->desc.bNumInterfaces; i++) {
>   			struct usb_interface	*interface;
>
> @@ -1156,7 +1164,6 @@ void usb_disable_device(struct usb_devic
>   				continue;
>   			dev_dbg(&dev->dev, "unregistering interface %s\n",
>   				dev_name(&interface->dev));
> -			interface->unregistering = 1;
>   			remove_intf_ep_devs(interface);
>   			device_del(&interface->dev);
>   		}
>

