Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0DZMGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:06:20 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54738 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0DZMGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:06:19 -0400
Date: Mon, 26 Apr 2010 10:29:05 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: USB gadget with drivers "on board"
To: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vbrfqdznfxrvh1@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I need to create an USB gadget with drivers for Windows included
"on board".  In particular, when the gadget is connected to Windows
host it is detected as mass storage and mounted drive include the
drivers.  However, when the drivers are installed, it is detected
as some other device.

Now, it seems that a simple composite device with two configurations
is enough -- the first containing mass storage and the second other
functions.  My tests show that Windows manages to set the first
configuration and detect the mass storage interface.

Unfortunately, Linux does the same thing -- chooses the first
configuration and detects the mass storage interface.  What I'd
like to see is Linux choosing the second configuration which is
more functional.

Is there any way to accomplish that?

I came up with an idea of swapping bConfigurationValues (so that mass
storage configuration has it set to 2 and the other configuration
has it set to 1) but still retaining the order those are given to
host (a bit like with g_ether).

This however did not work, as Linux pretty much ignores those values
when choosing configuration.

So can it be done differently?

I think the following change would achieve the result I am seeking:

diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index bdf87a8..38fd44e 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -121,21 +121,22 @@ int usb_choose_configuration(struct usb_device *udev)
                   		else if (udev->descriptor.bDeviceClass !=
                   						USB_CLASS_VENDOR_SPEC &&
                   				(!desc || desc->bInterfaceClass !=
                   						USB_CLASS_VENDOR_SPEC)) {
                   			best = c;
                   			break;
                   		}

                   		/* If all the remaining configs are vendor-specific,
                   		 * choose the first one. */
-		else if (!best)
+		else if (!best || best->desc.bConfigurationValue > c->desc.bConfigurationValue)
                   			best = c;
                   	}

                   	if (insufficient_power > 0)
                   		dev_info(&udev->dev, "rejected %d configuration%s "
                   			"due to insufficient available bus power\n",
                   			insufficient_power, plural(insufficient_power));

                   	if (best) {
                   		i = best->desc.bConfigurationValue;

Or maybe it'd be a good idea to prefer configurations with bigger
number of interfaces?

So what do you think? Does anyone know a (better) solution?

-- 
Best regards,                                           _     _
--.--| Liege of Serenely Enlightened Majesty of       o' \,=./ `o
---.-| Computer Science,  Michał "mina86" Nazarewicz     (o o)
-...-+---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
