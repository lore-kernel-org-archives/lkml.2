Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1GFQob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:44:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50895 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1GFQoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:44:30 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Regression 3.0-rc6+ : khubd blocked (usbnet_cdc_unbind)
Date: Wed, 6 Jul 2011 18:44:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc6-00016-ga2fa83f-dirty; KDE/4.6.5; x86_64; ; )
Cc: =?utf-8?q?=C3=89ric_Piel?= <E.A.B.Piel@tudelft.nl>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1107061210070.1995-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107061210070.1995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107061844.25689.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 of July 2011, Alan Stern wrote:
> On Wed, 6 Jul 2011, Éric Piel wrote:
> > Hello,
> > It seems I'm very unlucky this week and I've come across to what looks
> > like a second regression in the kernel. I'm running a version few
> > commits after 3.0-rc6, which includes commit e534c5b831c8 "fix
> > regression occurring during device removal".
> > 
> > When I plug/unplug/plug a mobile phone, after waiting a few minutes I
> > get a "task khubd:621 blocked for more than 120 seconds." Note that it's
> > directly connected to my laptop, not via an external hub (although the
> > bug also happens with an external hub).
> > 
> > Below is the whole dmesg log (with usb debug messages on)
> > 
> > Let me know if you need me to investigate more, or maybe there is
> > already a fix for that bug?
> 
> Ah -- this stack dump points out the reason for the hang.  It looks
> like that "fix regression..." commit didn't go far enough; I neglected
> the fact that interfaces can be unbound out of order when a driver
> claims multiple interfaces.
> 
> Adding this patch on top of that commit should fix this.  Let me
> know what you both get.

This one makes usb working after resume from ram (current Linus git + this 
patch).

> 
> Alan Stern
> 
> 
> 
>  drivers/usb/core/message.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: usb-3.0/drivers/usb/core/message.c
> ===================================================================
> --- usb-3.0.orig/drivers/usb/core/message.c
> +++ usb-3.0/drivers/usb/core/message.c
> @@ -1147,6 +1147,14 @@ void usb_disable_device(struct usb_devic
>  	 * any drivers bound to them (a key side effect)
>  	 */
>  	if (dev->actconfig) {
> +		/*
> +		 * FIXME: In order to avoid self-deadlock involving the
> +		 * bandwidth_mutex, we have to mark all the interfaces
> +		 * before unregistering any of them.
> +		 */
> +		for (i = 0; i < dev->actconfig->desc.bNumInterfaces; i++)
> +			dev->actconfig->interface[i]->unregistering = 1;
> +
>  		for (i = 0; i < dev->actconfig->desc.bNumInterfaces; i++) {
>  			struct usb_interface	*interface;
> 
> @@ -1156,7 +1164,6 @@ void usb_disable_device(struct usb_devic
>  				continue;
>  			dev_dbg(&dev->dev, "unregistering interface %s\n",
>  				dev_name(&interface->dev));
> -			interface->unregistering = 1;
>  			remove_intf_ep_devs(interface);
>  			device_del(&interface->dev);
>  		}


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
