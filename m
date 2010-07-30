Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab0G3SAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:00:19 -0400
Received: from kroah.org ([198.145.64.141]:59292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab0G3R56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:51 2010
Message-Id: <20100730175151.766386268@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>
Subject: [197/205] HID: usbhid: enable remote wakeup for keyboards
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 3d61510f4ecacfe47c75c0eb51c0659dfa77fb1b upstream.

This patch (as1365) enables remote wakeup by default for USB keyboard
devices.  Keyboards in general are supposed to be wakeup devices, but
the correct place to enable it depends on the device's bus; no single
approach will work for all keyboard devices.  In particular, this
covers only USB keyboards (and then only those supporting the boot
protocol).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-core.c |    7 +++++--
 drivers/hid/usbhid/usbkbd.c   |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1019,12 +1019,15 @@ static int usbhid_start(struct hid_devic
 	/* Some keyboards don't work until their LEDs have been set.
 	 * Since BIOSes do set the LEDs, it must be safe for any device
 	 * that supports the keyboard boot protocol.
+	 * In addition, enable remote wakeup by default for all keyboard
+	 * devices supporting the boot protocol.
 	 */
 	if (interface->desc.bInterfaceSubClass == USB_INTERFACE_SUBCLASS_BOOT &&
 			interface->desc.bInterfaceProtocol ==
-				USB_INTERFACE_PROTOCOL_KEYBOARD)
+				USB_INTERFACE_PROTOCOL_KEYBOARD) {
 		usbhid_set_leds(hid);
-
+		device_set_wakeup_enable(&dev->dev, 1);
+	}
 	return 0;
 
 fail:
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -313,6 +313,7 @@ static int usb_kbd_probe(struct usb_inte
 		goto fail2;
 
 	usb_set_intfdata(iface, kbd);
+	device_set_wakeup_enable(&dev->dev, 1);
 	return 0;
 
 fail2:	


