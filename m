Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399Ab0KSWIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:08:07 -0500
Received: from kroah.org ([198.145.64.141]:53060 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab0KSWEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:31 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:26 2010
Message-Id: <20101119220126.460539402@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [52/66] USB: accept some invalid ep0-maxpacket values
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 56626a72a47bf3e50875d960d6b5f17b9bee0ab2 upstream.

A few devices (such as the RCA VR5220 voice recorder) are so
non-compliant with the USB spec that they have invalid maxpacket sizes
for endpoint 0.  Nevertheless, as long as we can safely use them, we
may as well do so.

This patch (as1432) softens our acceptance criterion by allowing
high-speed devices to have ep0-maxpacket sizes other than 64.  A
warning is printed in the system log when this happens, and the
existing error message is clarified.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: James <bjlockie@lockie.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2860,13 +2860,16 @@ hub_port_init (struct usb_hub *hub, stru
 	else
 		i = udev->descriptor.bMaxPacketSize0;
 	if (le16_to_cpu(udev->ep0.desc.wMaxPacketSize) != i) {
-		if (udev->speed != USB_SPEED_FULL ||
+		if (udev->speed == USB_SPEED_LOW ||
 				!(i == 8 || i == 16 || i == 32 || i == 64)) {
-			dev_err(&udev->dev, "ep0 maxpacket = %d\n", i);
+			dev_err(&udev->dev, "Invalid ep0 maxpacket: %d\n", i);
 			retval = -EMSGSIZE;
 			goto fail;
 		}
-		dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);
+		if (udev->speed == USB_SPEED_FULL)
+			dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);
+		else
+			dev_warn(&udev->dev, "Using ep0 maxpacket: %d\n", i);
 		udev->ep0.desc.wMaxPacketSize = cpu_to_le16(i);
 		usb_ep0_reinit(udev);
 	}


