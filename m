Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0IUN5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:57:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:56805 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab0IUN5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:57:44 -0400
Date: Tue, 21 Sep 2010 15:57:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Phil Turmel <philip@turmel.org>
Cc: Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>, Heinz Diehl <htd@fritha.org>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
In-Reply-To: <alpine.LNX.2.00.1009211156520.26813@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1009211556200.26813@pobox.suse.cz>
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz> <4C975F79.9060609@turmel.org> <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
 <AANLkTim6PBGEBz8_PVpK2YajgtejsbAgL11i+DMN-7jh@mail.gmail.com> <alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz> <4C979C79.9090901@turmel.org> <alpine.LNX.2.00.1009211156520.26813@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Jiri Kosina wrote:

> > [   22.705849] HID debug: hiddev_open(): hid: ffff88013a7c0000, hiddev: (null), intf: ffff880137d0ac00
> 
> hiddev_open() has been called. usb_find_interface(&hid_driver, minor) 
> returned interface pointer 0xffff880137d0ac00. Which is bogus! Interface 
> 0xffff880137d0ac00 is not registered with hiddev at all, we should have 
> received 0xffff880137d0a400.
> 
> We currently register minors only for those usbhid devices (through 
> usb_register_dev() in hiddev_connect()) which are going to be claimed by 
> hiddev. It doesn't seem to be problematic to me, and I don't undersntand 
> why usb_find_interface() returns wrong interface.
> 
> I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
> makes the difference. When unset, the problem doesn't trigger, and 
> usb_find_interface() always returns the proper interface. When 
> CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
> 
> I'll look into that.

Could you guys please verify whether the patch below fixes the issues you 
were seeing and puts everything back into shape again? Thanks.


diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3f72924..616b449 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1154,6 +1154,7 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	char buf[64];
 	unsigned int i;
 	int len;
+	int hiddev_minor = 0;
 
 	if (hdev->quirks & HID_QUIRK_HIDDEV_FORCE)
 		connect_mask |= (HID_CONNECT_HIDDEV_FORCE | HID_CONNECT_HIDDEV);
@@ -1168,8 +1169,8 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
 		hdev->claimed |= HID_CLAIMED_INPUT;
 	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
-			!hdev->hiddev_connect(hdev,
-				connect_mask & HID_CONNECT_HIDDEV_FORCE))
+			((hiddev_minor = hdev->hiddev_connect(hdev,
+				connect_mask & HID_CONNECT_HIDDEV_FORCE)) >= 0))
 		hdev->claimed |= HID_CLAIMED_HIDDEV;
 	if ((connect_mask & HID_CONNECT_HIDRAW) && !hidraw_connect(hdev))
 		hdev->claimed |= HID_CLAIMED_HIDRAW;
@@ -1189,7 +1190,7 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		len += sprintf(buf + len, "input");
 	if (hdev->claimed & HID_CLAIMED_HIDDEV)
 		len += sprintf(buf + len, "%shiddev%d", len ? "," : "",
-				hdev->minor);
+				hiddev_minor);
 	if (hdev->claimed & HID_CLAIMED_HIDRAW)
 		len += sprintf(buf + len, "%shidraw%d", len ? "," : "",
 				((struct hidraw *)hdev->hidraw)->minor);
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 599041a..1f0a770 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1201,6 +1201,9 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 	hid->driver_data = usbhid;
 	usbhid->hid = hid;
 	usbhid->intf = intf;
+	/* Only hiddev-claimed devices will have corresponding minor number.
+	 * We can't leave it to 0, as that is valid minor as well */
+	usbhid->intf->minor = -1;
 	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
 	init_waitqueue_head(&usbhid->wait);
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 681e620..7a81c1f 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -899,7 +899,7 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
 		kfree(hiddev);
 		return -1;
 	}
-	return 0;
+	return usbhid->intf->minor;
 }
 
 /*

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
