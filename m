Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1BFSxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:53:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48220 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1BFSxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:53:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] PM: Do not create wakeup sysfs files for devices that cannot wake up (v2)
Date: Sun, 6 Feb 2011 19:53:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>
References: <Pine.LNX.4.44L0.1102061024150.20379-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102061024150.20379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102061953.17433.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011, Alan Stern wrote:
> On Sun, 6 Feb 2011, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > Below is the next version of the patch changing the PM core to only create
> > wakeup sysfs files for devices that are wakeup-capable.  It contains a change
> > in drivers/usb/core/hub.c that should avoid the problem described in the thread
> > at https://lkml.org/lkml/2011/2/5/108 , but I'm not 100% it's the right
> > approach.  Please have a look.
> 
> Yes, that's right -- in fact, it's exactly the same as what I was going
> to do.  Of course, it should be separated out into a separate patch, to
> be applied before the other wakeup changes.

OK, I'll split it out.

Greg, any objections to me putting the change below into the suspend tree as
a separate commit:

Index: linux-2.6/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hub.c
+++ linux-2.6/drivers/usb/core/hub.c
@@ -1465,6 +1465,7 @@ void usb_set_device_state(struct usb_dev
                enum usb_device_state new_state)
 {
        unsigned long flags;
+       int wakeup = -1;
 
        spin_lock_irqsave(&device_state_lock, flags);
        if (udev->state == USB_STATE_NOTATTACHED)
@@ -1479,11 +1480,10 @@ void usb_set_device_state(struct usb_dev
                                        || new_state == USB_STATE_SUSPENDED)
                                ;       /* No change to wakeup settings */
                        else if (new_state == USB_STATE_CONFIGURED)
-                               device_set_wakeup_capable(&udev->dev,
-                                       (udev->actconfig->desc.bmAttributes
-                                        & USB_CONFIG_ATT_WAKEUP));
+                               wakeup = udev->actconfig->desc.bmAttributes
+                                        & USB_CONFIG_ATT_WAKEUP;
                        else
-                               device_set_wakeup_capable(&udev->dev, 0);
+                               wakeup = 0;
                }
                if (udev->state == USB_STATE_SUSPENDED &&
                        new_state != USB_STATE_SUSPENDED)
@@ -1495,6 +1495,8 @@ void usb_set_device_state(struct usb_dev
        } else
                recursively_mark_NOTATTACHED(udev);
        spin_unlock_irqrestore(&device_state_lock, flags);
+       if (wakeup >= 0)
+               device_set_wakeup_capable(&udev->dev, wakeup);
 }
 EXPORT_SYMBOL_GPL(usb_set_device_state);

Thanks,
Rafael
