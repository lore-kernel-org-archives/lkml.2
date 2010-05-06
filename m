Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0EFSkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:40:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53291 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753851Ab0EFSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:40:07 -0400
Date: Thu, 6 May 2010 14:40:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
       <linux-pm@lists.linux-foundation.org>, list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <jslaby@suse.cz>
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100506194711.75979d22@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1005061426160.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Bruno [UTF-8] Prémont wrote:

> > Bruno, can you confirm that the hang occurs during one of those 
> > cancel_work_sync() calls?
> 
> No, it's not one of the cancel_work_sync() that hangs but it's the
> del_timer_sync() right before them that hangs!
> (del_timer_sync() also hangs if I put it last, so the cancel_work_sync()
> don't hang anything)
> 
> static void hid_cancel_delayed_stuff(struct usbhid_device *usbhid)
> {
> 	del_timer_sync(&usbhid->io_retry); /* this one never returns */
> 	cancel_work_sync(&usbhid->restart_work);
> 	cancel_work_sync(&usbhid->reset_work);
> }

Okay, I see what the problem is.  In usbhid_start() there's a bunch of
statements initializing parts of the usbhid structure.  When probing
fails those statements don't get executed, so the timer and workqueue
things aren't set up properly.

This patch should fix it.

Alan Stern



Index: usb-2.6/drivers/hid/usbhid/hid-core.c
===================================================================
--- usb-2.6.orig/drivers/hid/usbhid/hid-core.c
+++ usb-2.6/drivers/hid/usbhid/hid-core.c
@@ -998,13 +998,6 @@ static int usbhid_start(struct hid_devic
 		}
 	}
 
-	init_waitqueue_head(&usbhid->wait);
-	INIT_WORK(&usbhid->reset_work, hid_reset);
-	INIT_WORK(&usbhid->restart_work, __usbhid_restart_queues);
-	setup_timer(&usbhid->io_retry, hid_retry_timeout, (unsigned long) hid);
-
-	spin_lock_init(&usbhid->lock);
-
 	usbhid->urbctrl = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbhid->urbctrl) {
 		ret = -ENOMEM;
@@ -1180,6 +1173,12 @@ static int usbhid_probe(struct usb_inter
 	usbhid->intf = intf;
 	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
+	init_waitqueue_head(&usbhid->wait);
+	INIT_WORK(&usbhid->reset_work, hid_reset);
+	INIT_WORK(&usbhid->restart_work, __usbhid_restart_queues);
+	setup_timer(&usbhid->io_retry, hid_retry_timeout, (unsigned long) hid);
+	spin_lock_init(&usbhid->lock);
+
 	ret = hid_add_device(hid);
 	if (ret) {
 		if (ret != -ENODEV)

