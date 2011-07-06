Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1GFQO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:14:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52321 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751282Ab1GFQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:14:56 -0400
Date: Wed, 6 Jul 2011 12:14:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc6+ : khubd blocked (usbnet_cdc_unbind)
In-Reply-To: <4E148212.1060805@tudelft.nl>
Message-ID: <Pine.LNX.4.44L0.1107061210070.1995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Éric Piel wrote:

> Hello,
> It seems I'm very unlucky this week and I've come across to what looks 
> like a second regression in the kernel. I'm running a version few 
> commits after 3.0-rc6, which includes commit e534c5b831c8 "fix 
> regression occurring during device removal".
> 
> When I plug/unplug/plug a mobile phone, after waiting a few minutes I 
> get a "task khubd:621 blocked for more than 120 seconds." Note that it's 
> directly connected to my laptop, not via an external hub (although the 
> bug also happens with an external hub).
> 
> Below is the whole dmesg log (with usb debug messages on)
> 
> Let me know if you need me to investigate more, or maybe there is
> already a fix for that bug?

Ah -- this stack dump points out the reason for the hang.  It looks 
like that "fix regression..." commit didn't go far enough; I neglected 
the fact that interfaces can be unbound out of order when a driver 
claims multiple interfaces.

Adding this patch on top of that commit should fix this.  Let me 
know what you both get.

Alan Stern



 drivers/usb/core/message.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: usb-3.0/drivers/usb/core/message.c
===================================================================
--- usb-3.0.orig/drivers/usb/core/message.c
+++ usb-3.0/drivers/usb/core/message.c
@@ -1147,6 +1147,14 @@ void usb_disable_device(struct usb_devic
 	 * any drivers bound to them (a key side effect)
 	 */
 	if (dev->actconfig) {
+		/*
+		 * FIXME: In order to avoid self-deadlock involving the
+		 * bandwidth_mutex, we have to mark all the interfaces
+		 * before unregistering any of them.
+		 */
+		for (i = 0; i < dev->actconfig->desc.bNumInterfaces; i++)
+			dev->actconfig->interface[i]->unregistering = 1;
+
 		for (i = 0; i < dev->actconfig->desc.bNumInterfaces; i++) {
 			struct usb_interface	*interface;
 
@@ -1156,7 +1164,6 @@ void usb_disable_device(struct usb_devic
 				continue;
 			dev_dbg(&dev->dev, "unregistering interface %s\n",
 				dev_name(&interface->dev));
-			interface->unregistering = 1;
 			remove_intf_ep_devs(interface);
 			device_del(&interface->dev);
 		}

