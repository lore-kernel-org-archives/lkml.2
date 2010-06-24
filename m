Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0FXHBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:01:41 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:41418 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0FXHBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:01:39 -0400
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
Date: Thu, 24 Jun 2010 10:01:01 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.31.13-131-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1006221327010.1322-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006221327010.1322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006241001.01587.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salı 22 Haziran 2010 günü (saat 20:47:11) Alan Stern şunları yazmıştı:
> On Tue, 22 Jun 2010, [UTF-8] Ozan ÃaÄlayan wrote:

> 
> Sorry about that; a couple of changes have been made in that area since
> 2.6.31 was released.
> 
> Here's what you need to do: In 2.6.31's hub.c there are two calls to
> device_init_wakeup(), both inside usb_set_device_state().  Change both
> of them into calls to device_set_wakeup_capable() and that should fix
> the problem.  This is what the first part of commit
> 16985408b5c48585762ec3b9b7bae1dec4ad7437 does (but the second half of
> that commit will reintroduce the problem, so don't apply it).

Ok so it should be something like this:

--- linux-2.6.31.orig/drivers/usb/core/hub.c
+++ linux-2.6.31/drivers/usb/core/hub.c
@@ -1305,11 +1305,11 @@ void usb_set_device_state(struct usb_dev
 ·  ·   ·   ·   ·   || new_state == USB_STATE_SUSPENDED)
 ·  ·   ·   ·   ;·  /* No change to wakeup settings */
 ·  ·   ·   else if (new_state == USB_STATE_CONFIGURED)
-·  ·   ·   ·   device_init_wakeup(&udev->dev,
+·  ·   ·   ·   device_set_wakeup_capable(&udev->dev,
 ·  ·   ·   ·   ·   (udev->actconfig->desc.bmAttributes
 ·  ·   ·   ·   ·    & USB_CONFIG_ATT_WAKEUP));
 ·  ·   ·   else
-·  ·   ·   ·   device_init_wakeup(&udev->dev, 0);
+·  ·   ·   ·   device_set_wakeup_capable(&udev->dev, 0);
 ·  ·   }
 ·  ·   if (udev->state == USB_STATE_SUSPENDED &&
 ·  ·   ·   new_state != USB_STATE_SUSPENDED)

> 
> You can verify the result by checking the contents of
> /sys/bus/usb/devices/2-5/power/wakeup (replace the 2-5 with the correct
> path for the camera device).  With the current code it will say
> "enabled", but after the change it should say "disabled".
> 

I'll make them try this kernel but when I compare the output of

cat /sys/bus/usb/devices/*/power/wakeup

between the patched and non-patched kernels on my system, all wakeup values 
are still enabled. Because as far as I understand the first call still can 
enable remote wakeup as the 2nd parameter isn't a hardcoded 0. Or should this 
only affect some devices?

Thanks again.


---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
